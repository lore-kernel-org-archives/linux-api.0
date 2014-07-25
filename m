From: David Drysdale <drysdale@google.com>
Subject: [RFC PATCHv2 00/11] Adding FreeBSD's Capsicum security framework
Date: Fri, 25 Jul 2014 14:46:56 +0100
Message-ID: <1406296033-32693-1-git-send-email-drysdale@google.com>
Return-path: <linux-security-module-owner@vger.kernel.org>
Sender: linux-security-module-owner@vger.kernel.org
To: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Meredydd Luff <meredydd@senatehouse.org>, Kees Cook <keescook@chromium.org>, James Morris <james.l.morris@oracle.com>, Andy Lutomirski <luto@amacapital.net>, Paolo Bonzini <pbonzini@redhat.com>, Paul Moore <paul@paul-moore.com>, Christoph Hellwig <hch@infradead.org>, linux-api@vger.kernel.org, David Drysdale <drysdale@google.com>
List-Id: linux-api@vger.kernel.org

The last couple of versions of FreeBSD (9.x/10.x) have included the
Capsicum security framework [1], which allows security-aware
applications to sandbox themselves in a very fine-grained way.  For
example, OpenSSH now (>= 6.5) uses Capsicum in its FreeBSD version to
restrict sshd's credentials checking process, to reduce the chances of
credential leakage.

It would be good to have equivalent functionality in Linux, so I've been
working on getting the Capsicum framework running in the kernel, and I'd
appreciate some feedback/opinions on the general approach.

I'm attaching a corresponding draft patchset for reference, but
hopefully this cover email can cover the significant features to save
everyone having to look through the code details.  (It does mean this is
a long email though -- apologies for that.)


1) Capsicum Capabilities
------------------------

The most significant aspect of Capsicum is associating *rights* with
(some) file descriptors, so that the kernel only allows operations on an
FD if the rights permit it.  This allows userspace applications to
sandbox themselves by tightly constraining what's allowed with both
input and outputs; for example, tcpdump might restrict itself so it can
only read from the network FD, and only write to stdout.

The kernel thus needs to police the rights checks for these file
descriptors (referred to as 'Capsicum capabilities', completely
different than POSIX.1e capabilities), and the best place to do this is
at the points where a file descriptor from userspace is converted to a
struct file * within the kernel.

  [Policing the rights checks anywhere else, for example at the system
  call boundary, isn't a good idea because it opens up the possibility
  of time-of-check/time-of-use (TOCTOU) attacks [2] where FDs are
  changed (as openat/close/dup2 are allowed in capability mode) between
  the 'check' at syscall entry and the 'use' at fget() invocation.]

However, this does lead to quite an invasive change to the kernel --
every invocation of fget() or similar functions (fdget(),
sockfd_lookup(), user_path_at(),...) needs to be annotated with the
rights associated with the specific operations that will be performed on
the struct file.  There are ~100 such invocations that need annotation.

My current implementation approach is to use varargs variants of the
fget() functions that include the required rights, varargs-macroed so
that the only impact in a non-Capsicum build is the need to cope with an
ERR_PTR on failure rather than just NULL:

  #ifdef CONFIG_SECURITY_CAPSICUM
  #define fgetr(fd, ...)	_fgetr((fd), __VA_ARGS__, CAP_LIST_END)
  /* + Other variants... */
  #else
  #define fgetr(fd, ...)	(fget(fd) ?: ERR_PTR(-EBADF))
  /* + Other variants... */
  #endif

For example, an existing chunk of code like:

  SYSCALL_DEFINE1(fchdir, unsigned int, fd)
  {
  	struct fd f = fdget_raw(fd);
  	struct inode *inode;
  	int error = -EBADF;

  	error = -EBADF;
  	if (!f.file)
  		goto out;
  ...

might become:

  SYSCALL_DEFINE1(fchdir, unsigned int, fd)
  {
  	struct fd f = fdgetr_raw(fd, CAP_FCHDIR);
  	struct inode *inode;
  	int error = -EBADF;

  	if (IS_ERR(f.file)) {
  		error = PTR_ERR(f.file);
  		goto out;
  	}
  ...

In a Capsicum build the fdgetr_raw() function performs rights checks
(and potentially returns a new errno as ERR_PTR(-ENOTCAPABLE)), whereas
in a non-Capsicum build the only change is that fdget_raw() returns
ERR_PTR(-EBADF) rather than just NULL.


2) Capsicum Capabilities Data Structure
---------------------------------------

Internally, the rights associated with a Capsicum capability FD are
stored in a special struct file wrapper.  For a normal file, the rights
check inside fget() falls through, but for a capability wrapper the
rights in the wrapper are checked and (if capable) the underlying
wrapped struct file is returned.

  [This is approximately the implementation that was present in FreeBSD
  9.x.  For FreeBSD 10.x, the wrapper file was removed and the rights
  associated with a file descriptor are now stored in the fdtable. As
  that impacts memory use for all processes, whether Capsicum users or
  not, I've stuck with the FreeBSD 9.x approach.]


3) Allowing Capability Mode
---------------------------

Capsicum also includes 'capability mode', which locks down the available
syscalls so the rights restrictions can't just be bypassed by opening
new file descriptors.  More precisely, capability mode prevents access
to syscalls that access global namespaces, such as the filesystem or the
IP:port space.

The existing seccomp-bpf functionality of the kernel is a good mechanism
for implementing capability mode, but there are a few additional details
that also need to be addressed.

 a) The capability mode filter program needs to apply process-wide, not
    just to the current thread.

 b) In capability mode, new files can still be opened with openat(2) but
    only if they are beneath an existing directory file descriptor.

 c) In capability mode it should still be possible for a process to send
    signals to itself with kill(2)/tgkill(2).

This v2 patchset copes with these as follows:

 a) Kees Cook's incoming seccomp(2) patchset covers thread
    synchronization of filters.

 b) A new prctl(PR_SET_OPENAT_BENEATH) operation implicitly sets the
    O_BENEATH flag (see below) for all file-open operations for all
    threads of the current process, by adding a new openat_beneath
    flag in task_struct.

 c) An extension to the seccomp_data structure that includes the current
    task's tid and tgid values allows for BPF programs that check a
    kill(2)/tgkill(2) argument against the current thread, in a manner
    that is robust against fork(2)/clone(2).

The combination of these features with the existing seccomp-bpf
functionality gives the tools needed to implement capability mode.


4) New System Calls
-------------------

To allow userspace applications to access the Capsicum capability
functionality, I'm proposing two new system calls: cap_rights_limit(2)
and cap_rights_get(2).  I guess these could potentially be implemented
elsewhere (e.g. as fcntl(2) operations?) but the changes seem
significant enough that new syscalls are warranted.

  [FreeBSD 10.x actually includes six new syscalls for manipulating the
  rights associated with a Capsicum capability -- the capability rights
  can police that only specific fcntl(2) or ioctl(2) commands are
  allowed, and FreeBSD sets these with distinct syscalls.]


5) New openat(2) O_BENEATH Flag
-------------------------------

For Capsicum capabilities that are directory file descriptors, the
Capsicum framework only allows openat(cap_dfd, path, ...) operations to
work for files that are beneath the specified directory (and even that
only when the directory FD has the CAP_LOOKUP right), rejecting paths
that start with "/" or include "..".  The same restriction applies
process-wide for a process in capability mode.

As this seemed like functionality that might be more generally useful,
I've implemented it independently as a new O_BENEATH flag for openat(2).
The Capsicum code then always triggers the use of that flag when the dfd
is a Capsicum capability, or when the prctl(2) command described above
is in play.

  [FreeBSD has the openat(2) relative-only behaviour for capability DFDs
  and processes in capability mode, but does not include the O_BENEATH
  flag.]


6) Patchset Notes
-----------------

I've appended the draft patchset (against v3.16-rc5) for the
implementation of Capsicum capabilities, in case anyone wants to dive
into the details.

However, I should point out that it might include some code that hasn't
been compiled -- I attempted to change every fget() invocation I could
find, even if it was for a build that I can't perform (but I have built
allyesconfig on x86 & ARM).

Also, I've left a gap in the syscall and prctl(2) command numbering, to
allow this to be merged on top of Kees Cook's seccomp(2) changes.

Regards,

David Drysdale


[1] http://www.cl.cam.ac.uk/research/security/capsicum/papers/2010usenix-security-capsicum-website.pdf
[2] http://www.watson.org/~robert/2007woot/


Changes since v1:
 - removed gratuitous LSM hooks [Andy Lutomirski, Paul Moore]
 - renamed O_BENEATH_ONLY to O_BENEATH [Christoph Hellwig]
 - updated syscall numbers to allow for seccomp(2)
 - added prctl(PR_SET_OPENAT_BENEATH) [Paolo Bonzini]
 - added tid/tgid info to seccomp_data [Paolo Bonzini]
 - update spacing for current checkpatch.pl
 - [manpages] describe struct cap_rights [Andy Lutomirski]
 - [manpages] clarify nioctl use [Andy Lutomirski]
 - [manpages] clarify CAP_FCNTL use [Andy Lutomirski]


David Drysdale (11):
  fs: add O_BENEATH flag to openat(2)
  selftests: Add test of O_BENEATH & openat(2)
  capsicum: rights values and structure definitions
  capsicum: implement fgetr() and friends
  capsicum: convert callers to use fgetr() etc
  capsicum: implement sockfd_lookupr()
  capsicum: convert callers to use sockfd_lookupr() etc
  capsicum: invoke Capsicum on FD/file conversion
  capsicum: add syscalls to limit FD rights
  capsicum: prctl(2) to force use of O_BENEATH
  seccomp: Add tgid and tid into seccomp_data

 Documentation/security/capsicum.txt             | 102 +++++++
 arch/alpha/include/uapi/asm/fcntl.h             |   1 +
 arch/alpha/kernel/osf_sys.c                     |   6 +-
 arch/ia64/kernel/perfmon.c                      |  54 ++--
 arch/parisc/hpux/fs.c                           |   6 +-
 arch/parisc/include/uapi/asm/fcntl.h            |   1 +
 arch/powerpc/kvm/powerpc.c                      |   4 +-
 arch/powerpc/platforms/cell/spu_syscalls.c      |  15 +-
 arch/powerpc/platforms/cell/spufs/coredump.c    |   2 +
 arch/sparc/include/uapi/asm/fcntl.h             |   1 +
 arch/x86/syscalls/syscall_64.tbl                |   2 +
 drivers/base/dma-buf.c                          |   6 +-
 drivers/block/loop.c                            |  14 +-
 drivers/block/nbd.c                             |   5 +-
 drivers/infiniband/core/ucma.c                  |   4 +-
 drivers/infiniband/core/uverbs_cmd.c            |   6 +-
 drivers/infiniband/core/uverbs_main.c           |   4 +-
 drivers/infiniband/hw/usnic/usnic_transport.c   |   2 +-
 drivers/md/md.c                                 |   8 +-
 drivers/scsi/iscsi_tcp.c                        |   2 +-
 drivers/staging/android/sync.c                  |   2 +-
 drivers/staging/lustre/lustre/llite/file.c      |   6 +-
 drivers/staging/lustre/lustre/lmv/lmv_obd.c     |   7 +-
 drivers/staging/lustre/lustre/mdc/lproc_mdc.c   |   8 +-
 drivers/staging/lustre/lustre/mdc/mdc_request.c |   4 +-
 drivers/staging/usbip/stub_dev.c                |   2 +-
 drivers/staging/usbip/vhci_sysfs.c              |   2 +-
 drivers/vfio/pci/vfio_pci.c                     |   6 +-
 drivers/vfio/pci/vfio_pci_intrs.c               |   6 +-
 drivers/vfio/vfio.c                             |   6 +-
 drivers/vhost/net.c                             |   8 +-
 drivers/video/fbdev/msm/mdp.c                   |   4 +-
 fs/aio.c                                        |  37 ++-
 fs/autofs4/dev-ioctl.c                          |  16 +-
 fs/autofs4/inode.c                              |   4 +-
 fs/btrfs/ioctl.c                                |  20 +-
 fs/btrfs/send.c                                 |   7 +-
 fs/cifs/ioctl.c                                 |   6 +-
 fs/coda/inode.c                                 |   4 +-
 fs/coda/psdev.c                                 |   2 +-
 fs/compat.c                                     |  18 +-
 fs/compat_ioctl.c                               |  14 +-
 fs/eventfd.c                                    |  17 +-
 fs/eventpoll.c                                  |  19 +-
 fs/ext4/ioctl.c                                 |   6 +-
 fs/fcntl.c                                      | 106 ++++++-
 fs/fhandle.c                                    |   6 +-
 fs/file.c                                       | 130 ++++++++
 fs/fuse/inode.c                                 |  10 +-
 fs/ioctl.c                                      |  13 +-
 fs/locks.c                                      |  11 +-
 fs/namei.c                                      | 310 ++++++++++++++-----
 fs/ncpfs/inode.c                                |   5 +-
 fs/notify/dnotify/dnotify.c                     |   2 +
 fs/notify/fanotify/fanotify_user.c              |  16 +-
 fs/notify/inotify/inotify_user.c                |  12 +-
 fs/ocfs2/cluster/heartbeat.c                    |   8 +-
 fs/open.c                                       |  46 +--
 fs/proc/fd.c                                    |  17 +-
 fs/proc/namespaces.c                            |   6 +-
 fs/read_write.c                                 | 113 ++++---
 fs/readdir.c                                    |  18 +-
 fs/select.c                                     |  11 +-
 fs/signalfd.c                                   |   6 +-
 fs/splice.c                                     |  34 ++-
 fs/stat.c                                       |  10 +-
 fs/statfs.c                                     |   8 +-
 fs/sync.c                                       |  21 +-
 fs/timerfd.c                                    |  40 ++-
 fs/utimes.c                                     |  10 +-
 fs/xattr.c                                      |  26 +-
 fs/xfs/xfs_ioctl.c                              |  14 +-
 include/linux/capsicum.h                        |  72 +++++
 include/linux/file.h                            | 136 +++++++++
 include/linux/namei.h                           |  10 +
 include/linux/net.h                             |  16 +
 include/linux/sched.h                           |   3 +
 include/linux/syscalls.h                        |  12 +
 include/uapi/asm-generic/errno.h                |   3 +
 include/uapi/asm-generic/fcntl.h                |   4 +
 include/uapi/linux/Kbuild                       |   1 +
 include/uapi/linux/capsicum.h                   | 343 +++++++++++++++++++++
 include/uapi/linux/prctl.h                      |  14 +
 include/uapi/linux/seccomp.h                    |  10 +
 ipc/mqueue.c                                    |  30 +-
 kernel/events/core.c                            |  14 +-
 kernel/module.c                                 |  10 +-
 kernel/seccomp.c                                |   2 +
 kernel/sys.c                                    |  33 +-
 kernel/sys_ni.c                                 |   4 +
 kernel/taskstats.c                              |   4 +-
 kernel/time/posix-clock.c                       |  27 +-
 mm/fadvise.c                                    |   7 +-
 mm/internal.h                                   |  19 ++
 mm/memcontrol.c                                 |  12 +-
 mm/mmap.c                                       |   7 +-
 mm/nommu.c                                      |   9 +-
 mm/readahead.c                                  |   6 +-
 net/9p/trans_fd.c                               |  10 +-
 net/bluetooth/bnep/sock.c                       |   2 +-
 net/bluetooth/cmtp/sock.c                       |   2 +-
 net/bluetooth/hidp/sock.c                       |   4 +-
 net/compat.c                                    |   4 +-
 net/l2tp/l2tp_core.c                            |  11 +-
 net/l2tp/l2tp_core.h                            |   2 +
 net/sched/sch_atm.c                             |   2 +-
 net/socket.c                                    | 207 ++++++++++---
 net/sunrpc/svcsock.c                            |   4 +-
 security/Kconfig                                |  15 +
 security/Makefile                               |   2 +-
 security/capsicum-rights.c                      | 201 +++++++++++++
 security/capsicum-rights.h                      |  10 +
 security/capsicum.c                             | 380 ++++++++++++++++++++++++
 sound/core/pcm_native.c                         |  10 +-
 tools/testing/selftests/Makefile                |   1 +
 tools/testing/selftests/openat/.gitignore       |   3 +
 tools/testing/selftests/openat/Makefile         |  24 ++
 tools/testing/selftests/openat/openat.c         | 146 +++++++++
 virt/kvm/eventfd.c                              |   6 +-
 virt/kvm/vfio.c                                 |  12 +-
 120 files changed, 2818 insertions(+), 533 deletions(-)
 create mode 100644 Documentation/security/capsicum.txt
 create mode 100644 include/linux/capsicum.h
 create mode 100644 include/uapi/linux/capsicum.h
 create mode 100644 security/capsicum-rights.c
 create mode 100644 security/capsicum-rights.h
 create mode 100644 security/capsicum.c
 create mode 100644 tools/testing/selftests/openat/.gitignore
 create mode 100644 tools/testing/selftests/openat/Makefile
 create mode 100644 tools/testing/selftests/openat/openat.c

--
2.0.0.526.g5318336

