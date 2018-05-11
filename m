From: Alexey Gladkov <gladkov.alexey@gmail.com>
Subject: [PATCH v5 0/7] proc: modernize proc to support multiple private
 instances
Date: Fri, 11 May 2018 11:32:21 +0200
Message-ID: <20180511093221.GA902@comp-core-i7-2640m-0182e6>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Kees Cook <keescook@chromium.org>, Andy Lutomirski <luto@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, linux-security-module@vger.kernel.org, linux-api@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Akinobu Mita <akinobu.mita@gmail.com>, Oleg Nesterov <oleg@redhat.com>, Jeff Layton <jlayton@poochiereds.net>, Ingo Molnar <mingo@kernel.org>, Alexey Dobriyan <adobriyan@gmail.com>, "Eric W. Biederman" <ebiederm@xmission.com>, Linus Torvalds <torvalds@linux-foundation.org>, aniel Micay <danielmicay@gmail.com>, Jonathan Corbet <corbet@lwn.net>, bfields@fieldses.org, Stephen Rothwell <sfr@canb.auug.org.au>, solar@openwall.com, "Dmitry V. Levin" <ldv@altlinux.org>, Djalal Harouni <tixxdz@gmail.com>
List-Id: linux-api@vger.kernel.org

Greetings!

Preface:
--------
This is RFC v5 to modernize procfs and make it able to support multiple
private instances per the same pid namespace.

RFC v1 is here:
https://lkml.org/lkml/2017/3/30/670

RFC v2 is here:
https://lkml.org/lkml/2017/4/25/282

This RFC v5 can be applied on top of v4.17-rc4-45-g2f4474d

This RFC was tested on Ubuntu/Debian/Altlinux/Fedora.


Procfs modernization:
---------------------
Historically procfs was always tied to pid namespaces, during pid
namespace creation we internally create a procfs mount for it. However,
this has the effect that all new procfs mounts are just a mirror of the
internal one, any change, any mount option update, any new future
introduction will propagate to all other procfs mounts that are in the
same pid namespace.

This may have solved several use cases in that time. However today we
face new requirements, and making procfs able to support new private
instances inside same pid namespace seems a major point. If we want to
to introduce new features and security mechanisms we have to make sure
first that we do not break existing usecases. Supporting private procfs
instances will allow to support new features and behaviour without
propagating it to all other procfs mounts.

Today procfs is more of a burden especially to some Embedded, IoT,
sandbox, container use cases. In user space we are over-mounting null
or inaccessible files on top to hide files and information. If we want
to hide pids we have to create PID namespaces otherwise mount options
propagate to all other proc mounts, changing a mount option value in one
mount will propagate to all other proc mounts. If we want to introduce
new features, then they will propagate to all other mounts too, resulting
either maybe new useful functionality or maybe breaking stuff. We have
also to note that userspace should not workaround procfs, the kernel
should just provide a sane simple interface.

In this regard several developers and maintainers pointed out that
there are problems with procfs and it has to be modernized:

"Here's another one: split up and modernize /proc." by Andy Lutomirski [1]

Discussion about kernel pointer leaks:

"And yes, as Kees and Daniel mentioned, it's definitely not just dmesg.
In fact, the primary things tend to be /proc and /sys, not dmesg
itself." By Linus Torvalds [2]

Lot of other areas in the kernel and filesystems have been updated to be
able to support private instances, devpts is one major example [3]. The aim
here is to modernize procfs without breaking userspace, or without affecting
the shared procfs mount. Later new features will apply on the private
instances, and after more testing, months, maybe it can be made the default
especially for IoT.

We want the possibility to do:

$ mount -t proc -onewinstance,newfeature none /proc

newfeature: we are planning new features later for procfs, for now in
this RFC we only introduce "pids=all|ptraceable" mount option.

This allows to absorbe changes, make improvments without breaking use
cases.

Which will be used for:

1) Embedded systems and IoT: usually we have one supervisor for
apps, we have some lightweight sandbox support, however if we create
pid namespaces we have to manage all the processes inside too,
where our goal is to be able to run a bunch of apps each one inside
its own mount namespace, maybe use network namespaces for vlans
setups, but right now we only want mount namespaces, without all the
other complexity. We want procfs to behave more like a real file system,
and block access to inodes that belong to other users. The 'hidepid=' will
not work since it is a shared mount option.

2) Containers, sandboxes and Private instances of file systems - devpts case
Historically, lot of file systems inside Linux kernel view when instantiated
were just a mirror of an already created and mounted filesystem. This was the
case of devpts filesystem, it seems at that time the requirements were to
optimize things and reuse the same memory, etc. This design used to work but not
anymore with today’s containers, IoT, hostile environments and all the privacy
challenges that Linux faces.

In that regards, devpts was updated so that each new mounts is a total
independent file system by the following patches:

“devpts: Make each mount of devpts an independent filesystem” by
Eric W. Biederman [3] [4]

3) Linux Security Modules have multiple ptrace paths inside some
subsystems, however inside procfs, the implementation does not guarantee
that the ptrace() check which triggers the security_ptrace_check() hook
will always run. We have the 'hidepid' mount option that can be used to
force the ptrace_may_access() check inside has_pid_permissions() to run.
The problem is that 'hidepid' is per pid namespace and not attached to
the mount point, any remount or modification of 'hidepid' will propagate
to all other procfs mounts.

This also does not allow to support Yama LSM easily in desktop and user
sessions. Yama ptrace scope which restricts ptrace and some other
syscalls to be allowed only on inferiors, can be updated to have a
per-task context, where the context will be inherited during fork(),
clone() and preserved across execve(). If we support multiple private
procfs instances, then we may force the ptrace_may_access() on
/proc/<pids>/ to always run inside that new procfs instances. This will
allow to specifiy on user sessions if we should populate procfs with
pids that the user can ptrace or not.

By using Yama ptrace scope, some restricted users will only be able to see
inferiors inside /proc, they won't even be able to see their other
processes. Some software like Chromium, Firefox's crash handler, Wine
and others are already using Yama to restrict which processes can be
ptracable. With this change this will give the possibility to restrict
/proc/<pids>/ but more importantly this will give desktop users a
generic and usuable way to specifiy which users should see all processes
and which user can not.

Side notes:
* This covers the lack of seccomp where it is not able to parse
arguments, it is easy to install a seccomp filter on direct syscalls
that operate on pids, however /proc/<pid>/ is a Linux ABI using
filesystem syscalls. With this change all LSMs should be able to analyze
open/read/write/close... on /proc/<pid>/

4) This will allow to implement new features either in kernel or
userspace without having to worry about procfs.
In containers, sandboxes, etc we have workarounds to hide some /proc
inodes, this should be supported natively without doing extra complex
work, the kernel should be able to support sane options that work with
today and future Linux use cases.

Introduced changes:
-------------------
This series adds few new mount options:

* 'newinstance' mount option, it was also suggesed by Andy Lutomirski [5].
When this option is passed we automatically create a private procfs instance.

This is not the default behaviour since we do not want to break userspace
and we do not want to provide different devices IDs by default when
stat()ing inodes, I am not sure about all the use cases there [6].

* 'pidonly' that allows to hide non-pid inodes from procfs. It can be used
in containers and sandboxes, as these are already trying to hide and block
access to procfs inodes anyway.

* 'pids' mount option, as discussed with Andy Lutomirski.

  If 'pids=' is passed without 'newinstance' then it has no effect.

  If 'newinstance,pids=all' then processes will be show inside the proc
  mount.

  If 'newinstance,pids=ptraceable' then only ptraceable processes will be
  shown.

This allows to support lightweight sandboxes in Embedded Linux, also
solves the case for LSM where now with this mount option, we make sure
that they have a ptrace path in procfs.

Use cases of 'newinstance' mount option:

* We create a private procfs instance that it is disconnected from the
shared or other procfs instances.

* "hidepid" instead of chaning all other mirrored procfs mounts, now
it will work only on the new private instance.

* "gid" instead of chaning all other mirrored procfs mounts, now it will
work only on the new private instance.

* "pids=ptraceable" mount option which will take precendence over
"hidepid" will only work when 'newinstance' is set. Otherwise it is ignored.

This should allow later after real testing to have a smooth transition
to a procfs with default private instances.

How to test:
$ sudo mount -t proc -onewinstance,pids=ptraceable none /test

Note for userspace that should be documented:

If you are over mounting /proc, then make sure you are in a new mount
namespace where propagation to master is disconnected. This will avoid
to pin that new /proc mount.

References:
-----------
[1] https://lists.linuxfoundation.org/pipermail/ksummit-discuss/2017-January/004215.html
[2] http://www.openwall.com/lists/kernel-hardening/2017/10/05/5
[3] https://lwn.net/Articles/689539/
[4] http://lxr.free-electrons.com/source/Documentation/filesystems/devpts.txt?v=3.14
[5] https://lkml.org/lkml/2017/5/2/407
[6] https://lkml.org/lkml/2017/5/3/357


# Changes since RFC v5:
*) Fixed a bug that caused a problem with the Fedora boot.
*) The 'pidonly' option is visible among the mount options.

# Changes since RFC v2:
*) Renamed mount options to 'newinstance' and 'pids='
   Suggested-by: Andy Lutomirski <luto@kernel.org>
*) Fixed order of commit, Suggested-by: Andy Lutomirski <luto@kernel.org>
*) Many bug fixes.

# Changes since RFC v1:
*) Removed 'unshared' mount option and replaced it with 'limit_pids'
   which is attached to the current procfs mount.
   Suggested-by Andy Lutomirski <luto@kernel.org>
*) Do not fill dcache with pid entries that we can not ptrace.
*) Many bug fixes.

Alexey Gladkov (1):
  proc: add option to mount only a pids subset

Djalal Harouni (6):
  proc: add proc_fs_info struct to store proc information
  proc: move /proc/{self|thread-self} dentries to proc_fs_info
  proc: add helpers to set and get proc hidepid and gid mount options
  proc: support mounting private procfs instances inside same pid
    namespace
  proc: instantiate only pids that we can ptrace on 'limit_pids=1' mount
    option
  proc: flush task dcache entries from all procfs instances

 fs/locks.c                    |   6 +-
 fs/proc/base.c                | 101 ++++++++++++++++-------
 fs/proc/generic.c             |  20 +++++
 fs/proc/inode.c               |  29 ++++++-
 fs/proc/internal.h            |   2 +-
 fs/proc/root.c                | 184 +++++++++++++++++++++++++++++++++++++++---
 fs/proc/self.c                |   9 ++-
 fs/proc/thread_self.c         |   9 ++-
 fs/proc_namespace.c           |  14 ++--
 include/linux/pid_namespace.h |  46 ++++++++++-
 include/linux/proc_fs.h       | 127 +++++++++++++++++++++++++++++
 11 files changed, 480 insertions(+), 67 deletions(-)

-- 
2.10.5
