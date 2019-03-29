From: Christian Brauner <christian@brauner.io>
Subject: [PATCH v2 0/5] pid: add pidfd_open()
Date: Fri, 29 Mar 2019 16:54:20 +0100
Message-ID: <20190329155425.26059-1-christian@brauner.io>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: jannh@google.com, luto@kernel.org, dhowells@redhat.com, serge@hallyn.com, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, ebiederm@xmission.com, khlebnikov@yandex-team.ru, keescook@chromium.org, adobriyan@gmail.com, tglx@linutronix.de, mtk.manpages@gmail.com, bl0pbl33p@gmail.com, ldv@altlinux.org, akpm@linux-foundation.org, oleg@redhat.com, nagarathnam.muthusamy@oracle.com, cyphar@cyphar.com, viro@zeniv.linux.org.uk, joel@joelfernandes.org, dancol@google.com, Christian Brauner <christian@brauner.io>
List-Id: linux-api@vger.kernel.org

/* Introduction */
This adds the pidfd_open() syscall.
pidfd_open() allows to retrieve file descriptors for a given pid. This
includes both file descriptors for processes and file descriptors for
threads.

With the addition of this syscalls pidfds become independent of procfs just
as pids are. Of course, if CONFIG_PROC_FS is not set then metadata access
for processes will not be possible but everything else will just work fine.
In addition, this allows us to remove the dependency of pidfd_send_signal()
on procfs and enable it unconditionally.
With the ability to call pidfd_open() on tids we can now add a flag to
pidfd_send_signal() to signal to a specific thread capturing the
functionality of tgkill() and related thread-focused signal syscalls.

The desire to lift the restriction for pidfds on procfs has been expressed
by multiple people (cf. the commit message of commit
3eb39f47934f9d5a3027fe00d906a45fe3a15fad and [2]).

/* Signature */
int pidfd_open(pid_t pid, unsigned int flags);

/* pidfds are anon inode file descriptors */
These pidfds are allocated using anon_inode_getfd(), are O_CLOEXEC by
default and can be used with the pidfd_send_signal() syscall. They are not
dirfds and as such have the advantage that we can make them pollable or
readable in the future if we see a need to do so. The pidfds are not
associated with a specific pid namespaces but rather only reference struct
pid of a given process in their private_data member.
Additionally, Andy made an argument that we should go forward with
non-proc-dirfd file descriptors for the sake of security and extensibility
(cf. [3]). This will unblock or help move along work on pidfd_wait which
is currently ongoing.

/* Process Metadata Access */
One of the oustanding issues has been how to get information about a given
process if pidfds are regular file descriptors and do not provide access to
the process /proc/<pid> directory.
Various solutions have been proposed. The one that most people prefer is to
be able to retrieve a file descriptor to /proc/<pid> based on a pidfd
(cf. [5]). The prefered solution for how to do this has been to implement
an ioctl that for pidfds that translates a pidfd into a dirfd for
/proc/<pid>. This has been implemented in this patchset as well. If
PIDFD_GET_PROCFD is passed as a command to an ioctl() taking a pidfd and an
fd referring to a procfs directory as an argument a corresponding dirfd to
/proc/<pid> can be retrieved.
The ioctl() makes very sure that the struct pid associated with the
/proc/<pid> fd is identical to the struct pid stashed in the pidfd. This
ensures that we avoid pid recycling issues.

/* Testing */
The patchset comes with tests (which btw. I consider mandatory with
every feature-patch that intends to go through the pidfd tree):
- test that no invalid flags can be passed to pidfd_open()
- test that no invalid pid can be passed to pidfd_open()
- test that a pidfd can be retrieved with pidfd_open()
- test whether a pidfd can be converted into an fd to /proc/<pid> to get
  metadata access
- test that a pidfd retrieved based on a pid that has been recycled cannot
  be converted into /proc/<pid> for that recycled pid

/* Example */
int pidfd = pidfd_open(1234, 0);
int procfd = open("/proc", O_DIRECTORY | O_RDONLY | O_CLOEXEC);
int procpidfd = ioctl(pidfd, PIDFD_GET_PROCFD, procfd);
int statusfd = openat(procpidfd, "status", O_RDONLY | O_CLOEXEC);
int ret = read(statusfd, buf, sizeof(buf));
ret = pidfd_send_signal(pidfd, SIGKILL, NULL, 0);

/* References */
[1]: https://lore.kernel.org/lkml/20181228233725.722tdfgijxcssg76@brauner.io/
[2]: https://lore.kernel.org/lkml/20190320203910.GA2842@avx2/
[3]: https://lore.kernel.org/lkml/CALCETrXO=V=+qEdLDVPf8eCgLZiB9bOTrUfe0V-U-tUZoeoRDA@mail.gmail.com
[4]: https://lore.kernel.org/lkml/CAHk-=wgmKZm-fESEiLq_W37sKpqCY89nQkPNfWhvF_CQ1ANgcw@mail.gmail.com
[5]: https://lore.kernel.org/lkml/533075A9-A6CF-4549-AFC8-B90505B198FD@joelfernandes.org

Christian Brauner (4):
  pid: add pidfd_open()
  signal: support pidfd_open() with pidfd_send_signal()
  signal: PIDFD_SIGNAL_TID threads via pidfds
  tests: add pidfd_open() tests

David Howells (1):
  Make anon_inodes unconditional

 arch/arm/kvm/Kconfig                          |   1 -
 arch/arm64/kvm/Kconfig                        |   1 -
 arch/mips/kvm/Kconfig                         |   1 -
 arch/powerpc/kvm/Kconfig                      |   1 -
 arch/s390/kvm/Kconfig                         |   1 -
 arch/x86/Kconfig                              |   1 -
 arch/x86/entry/syscalls/syscall_32.tbl        |   1 +
 arch/x86/entry/syscalls/syscall_64.tbl        |   1 +
 arch/x86/kvm/Kconfig                          |   1 -
 drivers/base/Kconfig                          |   1 -
 drivers/char/tpm/Kconfig                      |   1 -
 drivers/dma-buf/Kconfig                       |   1 -
 drivers/gpio/Kconfig                          |   1 -
 drivers/iio/Kconfig                           |   1 -
 drivers/infiniband/Kconfig                    |   1 -
 drivers/vfio/Kconfig                          |   1 -
 fs/Makefile                                   |   2 +-
 fs/notify/fanotify/Kconfig                    |   1 -
 fs/notify/inotify/Kconfig                     |   1 -
 include/linux/pid.h                           |   2 +
 include/linux/syscalls.h                      |   1 +
 include/uapi/linux/wait.h                     |   5 +
 init/Kconfig                                  |  10 -
 kernel/pid.c                                  | 181 +++++++++
 kernel/signal.c                               | 130 +++++--
 kernel/sys_ni.c                               |   3 -
 tools/testing/selftests/pidfd/Makefile        |   2 +-
 tools/testing/selftests/pidfd/pidfd.h         |  57 +++
 .../testing/selftests/pidfd/pidfd_open_test.c | 361 ++++++++++++++++++
 tools/testing/selftests/pidfd/pidfd_test.c    |  41 +-
 30 files changed, 701 insertions(+), 112 deletions(-)
 create mode 100644 tools/testing/selftests/pidfd/pidfd.h
 create mode 100644 tools/testing/selftests/pidfd/pidfd_open_test.c

-- 
2.21.0
