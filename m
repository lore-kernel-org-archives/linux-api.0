From: ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org (Eric W. Biederman)
Subject: [GIT PULL] namespaces related fixes for v4.11-rc1
Date: Thu, 23 Feb 2017 09:48:17 +1300
Message-ID: <8760k29cku.fsf@xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/containers/>
List-Post: <mailto:containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org


Linus,

Please pull the for-linus branch from the git tree:

   git://git.kernel.org/pub/scm/linux/kernel/git/ebiederm/user-namespace.git for-linus

   HEAD: ace0c791e6c3cf5ef37cad2df69f0d90ccc40ffb proc/sysctl: Don't grab i_lock under sysctl_lock.

This pull request is coming a few days into the merge window as just
before the merge window opened a bug was discovered in a change I had
merged so a little time was needed to verify and merge the fix.

There is a lot here.  A lot of these changes result in subtle user
visible differences in kernel behavior.  I don't expect anything will
care but I will revert/fix things immediately if any regressions show
up.

>From Seth Forshee there is a continuation of the work to make the vfs
ready for unpriviled mounts.  We had thought the previous changes
prevented the creation of files outside of s_user_ns of a filesystem,
but it turns we missed the O_CREAT path.  Ooops.

Pavel Tikhomirov and Oleg Nesterov worked together to fix a long
standing bug in the implemenation of PR_SET_CHILD_SUBREAPER where only
children that are forked after the prctl are considered and not children
forked before the prctl.  The only known user of this prctl systemd
forks all children after the prctl.  So no userspace regressions will
occur.  Holding earlier forked children to the same rules as later
forked children creates a semantic that is sane enough to allow
checkpoing of processes that use this feature.

There is a long delayed change by Nikolay Borisov to limit inotify
instances inside a user namespace.

Michael Kerrisk extends the API for files used to maniuplate namespaces
with two new trivial ioctls to allow discovery of the hierachy and
properties of namespaces.

Konstantin Khlebnikov with the help of Al Viro adds code that when a
network namespace exits purges it's sysctl entries from the dcache.  As
in some circumstances this could use a lot of memory.

Vivek Goyal fixed a bug with stacked filesystems where the permissions
on the wrong inode were being checked.

I continue previous work on ptracing across exec.  Allowing a file to
be setuid across exec while being ptraced if the tracer has enough
credentials in the user namespace, and if the process has CAP_SETUID in
it's own namespace.  Proc files for setuid or otherwise undumpable
executables are now owned by the root in the user namespace of their
mm.  Allowing debugging of setuid applications in containers to work
better.

A bug I introduced with permission checking and automount is now fixed.
The big change is to mark the mounts that the kernel initiates as a
result of an automount.  This allows the permission checks in sget
to be safely suppressed for this kind of mount.  As the permission check
happened when the original filesystem was mounted.

Finally a special case in the mount namespace is removed preventing
unbounded chains in the mount hash table, and making the semantics
simpler which benefits CRIU.

The vfs fix along with related work in ima and evm I believe makes us
ready to finish developing and merge fully unprivileged mounts of the
fuse filesystem.  The cleanups of the mount namespace makes discussing
how to fix the worst case complexity of umount.  The stacked filesystem
fixes pave the way for adding multiple mappings for the filesystem uids
so that efficient and safer containers can be implemented.

Eric

Eric W. Biederman (8):
      exec: Don't reset euid and egid when the tracee has CAP_SETUID
      exec: Test the ptracer's saved cred to see if the tracee can gain caps
      exec: Remove LSM_UNSAFE_PTRACE_CAP
      proc: Better ownership of files for non-dumpable tasks in user namespaces
      fs: Better permission checking for submounts
      Merge branch 'nsfs-discovery'
      mnt: Tuck mounts under others instead of creating shadow/side mounts.
      proc/sysctl: Don't grab i_lock under sysctl_lock.

Konstantin Khlebnikov (1):
      proc/sysctl: prune stale dentries during unregistering

Michael Kerrisk (man-pages) (2):
      nsfs: Add an ioctl() to return the namespace type
      nsfs: Add an ioctl() to return owner UID of a userns

Nikolay Borisov (1):
      inotify: Convert to using per-namespace limits

Oleg Nesterov (2):
      exit: fix the setns() && PR_SET_CHILD_SUBREAPER interaction
      introduce the walk_process_tree() helper

Pavel Tikhomirov (1):
      prctl: propagate has_child_subreaper flag to every descendant

Seth Forshee (1):
      vfs: open() with O_CREAT should not create inodes with unknown ids

Vivek Goyal (1):
      vfs: Use upper filesystem inode in bprm_fill_uid()


 fs/afs/mntpt.c                       |   2 +-
 fs/autofs4/waitq.c                   |   4 +-
 fs/cifs/cifs_dfs_ref.c               |   7 +-
 fs/debugfs/inode.c                   |   8 +--
 fs/exec.c                            |  10 +--
 fs/mount.h                           |   1 -
 fs/namei.c                           |   9 ++-
 fs/namespace.c                       | 127 +++++++++++++++++++++--------------
 fs/nfs/namespace.c                   |   2 +-
 fs/nfs/nfs4namespace.c               |   2 +-
 fs/notify/inotify/inotify.h          |  17 +++++
 fs/notify/inotify/inotify_fsnotify.c |   6 +-
 fs/notify/inotify/inotify_user.c     |  34 +++++-----
 fs/nsfs.c                            |  13 ++++
 fs/pnode.c                           |  61 +++++++++++++----
 fs/pnode.h                           |   2 +
 fs/proc/base.c                       | 102 ++++++++++++++++------------
 fs/proc/fd.c                         |  12 +---
 fs/proc/inode.c                      |   3 +-
 fs/proc/internal.h                   |  23 ++-----
 fs/proc/proc_sysctl.c                |  66 +++++++++++++-----
 fs/super.c                           |  13 +++-
 include/linux/debugfs.h              |   3 +-
 include/linux/fsnotify_backend.h     |   3 +-
 include/linux/mount.h                |   3 +
 include/linux/sched.h                |   7 +-
 include/linux/security.h             |   3 +-
 include/linux/sysctl.h               |   1 +
 include/linux/user_namespace.h       |   4 ++
 include/uapi/linux/fs.h              |   1 +
 include/uapi/linux/nsfs.h            |   9 ++-
 kernel/exit.c                        |  13 ++--
 kernel/fork.c                        |  42 +++++++++++-
 kernel/sys.c                         |  22 ++++++
 kernel/trace/trace.c                 |   4 +-
 kernel/ucount.c                      |   6 +-
 security/apparmor/domain.c           |   2 +-
 security/commoncap.c                 |   5 +-
 security/selinux/hooks.c             |   3 +-
 security/smack/smack_lsm.c           |   2 +-
 40 files changed, 431 insertions(+), 226 deletions(-)
