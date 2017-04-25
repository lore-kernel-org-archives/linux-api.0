From: Djalal Harouni <tixxdz@gmail.com>
Subject: [PATCH RFC v2 0/6] proc: support private proc instances per pidnamespace
Date: Tue, 25 Apr 2017 14:23:52 +0200
Message-ID: <1493123038-30590-1-git-send-email-tixxdz@gmail.com>
Return-path: <linux-security-module-owner@vger.kernel.org>
Sender: owner-linux-security-module@vger.kernel.org
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Andy Lutomirski <luto@kernel.org>, Kees Cook <keescook@chromium.org>, Andrew Morton <akpm@linux-foundation.org>, linux-fsdevel@vger.kernel.org, kernel-hardening@lists.openwall.com, linux-security-module@vger.kernel.org
Cc: Linux API <linux-api@vger.kernel.org>, Dongsu Park <dpark@posteo.net>, Casey Schaufler <casey@schaufler-ca.com>, James Morris <james.l.morris@oracle.com>, serge@hallyn.com, Jeff Layton <jlayton@poochiereds.net>, bfields@fieldses.org, Alexander Viro <viro@zeniv.linux.org.uk>, Alexey Dobriyan <adobriyan@gmail.com>, Ingo Molnar <mingo@kernel.org>, ebiederm@xmission.com, Oleg Nesterov <oleg@redhat.com>, Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>, Djalal Harouni <tixxdz@gmail.com>
List-Id: linux-api@vger.kernel.org

Hi,

This is RFC v2 to modernize procfs and make it able to support multiple
private instances per the same pid namespace. RFC v1 is here [1]

This RFC v2 can be applied on top of next-20170424

Historically procfs was tied to pid namespaces, and mount options were
propagated to all other procfs instances in the same pid namespace. This
solved several use cases in that time. However today we face new
requirements, and making procfs able to support new private instances
inside same pid namespace seems a major point. This was discussed
previously with Andy Lutomirski and the conclusion was to go into this
direction.


1) The main aim of this work is to have on embedded systems one
supervisor for apps. Right now we have some lightweight sandbox support,
however if we create pid namespacess we have to manages all the
processes inside too, where our goal is to be able to run a bunch of
apps each one inside its own mount namespace without being able to
notice each other. We only want to use mount namespaces, and we want
procfs to behave more like a real mount point.


2) Linux Security Modules have multiple ptrace paths inside some
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
and which users can not.

Side notes:
* This covers the lack of seccomp where it is not able to parse
arguments, it is easy to install a seccomp filter on direct syscalls
that operate on pids, however /proc/<pid>/ is a Linux ABI using
filesystem syscalls. With this change LSMs should be able to analyze
open/read/write/close...


3) This will modernize procfs and align it with all other filesystems
and subsystems that have been updated recently to be able to work in a
flexible way. This is the same as devpts where each mount now is a distinct
filesystem such that ptys and their indicies allocated in one mount are
independent from ptys and their indicies in all other mounts.

We have to align procfs and modernize it to have a per mount context
where at least the mount option do not propagate to all other mounts,
then maybe we can continue to implement new features. One example is to
require CAP_SYS_ADMIN in the init user namespace on some /proc/* which are
not pids and which are are not virtualized by design, or CAP_NET_ADMIN
inside userns on the net bits that are virtualized, etc.
These mount options won't propagate to previous mounts, and the system
will continue to be usable.


This adds a new mount option 'limit_pids' that can be renamed to
whatever is best, when it is passed it will automatically instruct
procfs internally to create a new instance.

How to test:
$ sudo mount -t proc -o limit_pids=1 none /test


Note for userspace that should be documented:
If you are over mounting /proc, then make sure you are in a new mount
namespace where propagation to master is disconnected. This will avoid
to pin that new /proc mount.


# Changes since v1:
*) Removed 'unshared' mount option and replaced it with 'limit_pids'
   which is attached to the current procfs mount.
   Suggested-by Andy Lutomirski <luto@kernel.org>
*) Do not fill dcache with pid entries that we can not ptrace.
*) Many bug fixes.


Djalal Harouni (6):
[PATCH 1/6] proc: add proc_fs_info struct to store proc information
[PATCH 2/6] proc: move /proc/{self|thread-self} dentries to proc_fs_info
[PATCH 3/6] proc: add helpers to set and get proc hidepid and gid
[PATCH 4/6] proc: support mounting private procfs instances inside
[PATCH 5/6] proc: instantiate only pids that we can ptrace on 'limit_pids=1' mount option
[PATCH 6/6] proc: flush task dcache entries from all procfs instances

 fs/locks.c                    |   6 +-
 fs/proc/base.c                |  98 ++++++++++++++++-------
 fs/proc/inode.c               |  22 +++++-
 fs/proc/internal.h            |   2 +-
 fs/proc/root.c                | 176 ++++++++++++++++++++++++++++++++++++++----
 fs/proc/self.c                |   9 ++-
 fs/proc/thread_self.c         |   9 ++-
 fs/proc_namespace.c           |  14 ++--
 include/linux/pid_namespace.h |  46 ++++++++++-
 include/linux/proc_fs.h       | 106 +++++++++++++++++++++++++
 10 files changed, 422 insertions(+), 66 deletions(-)


[1] https://lkml.org/lkml/2017/3/30/670

Thanks!
