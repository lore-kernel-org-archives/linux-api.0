From: ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org (Eric W. Biederman)
Subject: [GIT PULL] User namespace related fixes for v4.2
Date: Fri, 26 Jun 2015 15:50:09 -0500
Message-ID: <87381eyz26.fsf@x220.int.ebiederm.org>
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
Cc: Seth Forshee <seth.forshee-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Kenton Varda <kenton-AuYgBwuPrUQTaNkGU808tA@public.gmane.org>, Michael Kerrisk-manpages <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Ivan Delalande <colona-nzgTgzXrdUbQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org


Date: Fri, 22 May 2015 15:41:45 -0500 (4 weeks, 6 days, 23 hours ago)

Linus,

Please pull the for-linus branch from the git tree:

   git://git.kernel.org/pub/scm/linux/kernel/git/ebiederm/user-namespace.git for-linus

   HEAD: 81909cb3350299977a88f72264651f6cec06c836 mnt: Avoid unnecessary regressions in fs_fully_visible

Long ago and far away when user namespaces where young and I was a more
optimistic man it was realized that allowing fresh mounts of proc and
sysfs with only user namespace permissions could violate the basic rule
that only root gets to decide if proc or sysfs should be mounted at all.

Some hacks were put in place to reduce the worst of the damage could be
done, and the common sense rule was adopted that fresh mounts of proc
and sysfs should allow no more than bind mounts of proc and sysfs.
Unfortunately that rule has not been fully enforced.

There are two kinds of gaps in that enforcement.  Only filesystems mount
on empty directories on proc and sysfs should be ignored but the test
for empty directories was insufficient.  So this patchset requires
directories on proc, sysctl and sysfs that are will always be empty to
be created specially.  Every other technique is lossy as an ordinary
directory can dynamically be added to later.  This actually makes this
code in the kernel a smidge clearer about it's purpose.  I asked
container developers from the various container projects to help test
this and no holes were found in the set of mount points on proc and
sysfs that this patchset identifies.

This set of changes also starts enforcing the mount flags of fresh
mounts of proc and sysfs are consistent with the existing mount of proc
and sysfs.  I expected this to be the boring part of this patchset but
unfortunately userspace has been stupid and extra work has to be done to
avoid regressions.  The atime, read-only, and nodev attributes were not
a problem and as such are enforced absolutely.

People have been winding up mounting proc and sysfs in contaners with
nosuid and noexec clear, when the global root had set nosuid and noexec.
In practice this does not make a hill of beans difference today because
currently there are no exectuables on proc and sysfs.  Unfortunately
that can not be guaranteed in the future.  People refactor code and bugs
get reintroduced, or people find a good reason to do something that
today seems ludicrous.  Give people 20 more years and who knows what
will happen.

The libvirt-lxc and lxc developers have been contacted so they can
correct the bugs where they clear noexec and nosuid on proc and sysfs
through oversights when they wrote their code.  Thos bugs should be
fixed in those projects shortly.  These bugs are an issue however
libvirt-lxc or lxc create containers.  However they only violate kernel
permission checks in the case of containers created by unprivileged
users, which is a niche case today.

Therefore this changeset marks for backporting the attribute enforcement
that do not cause regressions in the existing userspace. Implements
enforcement of nosuid and noexec.  Then disables that enforcement of
nosuid and nosexec and replaces that enforcment with a big fat warning.
Userspace should be fixed before 4.2 ships so I do not expect these
warnings to fire.  However the warnings give userspace time to get their
act together.  I am optimistic that all of userspace that cares will be
fixed and for v4.3 I can remove the warning messages and enforce the
attribute checks.

It is a fine line on the regression front and I hate walking it, but now
is the best time to address the issue of clearing attributes that should
not be cleared before lots of unprivileged container implementations
accumulate, and before nosid and noexec proc and sysfs matter.

This set of changes also addresses how open file descriptors from
/proc/<pid>/ns/* are displayed.  Recently readlink of /proc/<pid>/fd has
been triggering a WARN_ON that has not been meaningful in nearly a
decade, and is actively wrong now.  An old bug (2 years?) in
/proc/<pid>/mountinfo where bind mounts of these descriptors were
not meaningfully show is fixed.

Eric W. Biederman (14):
      mnt: Refactor the logic for mounting sysfs and proc in a user namespace
      mnt: Modify fs_fully_visible to deal with locked ro nodev and atime
      mnt: Modify fs_fully_visible to deal with locked nosuid and noexec
      vfs: Ignore unlocked mounts in fs_fully_visible
      fs: Add helper functions for permanently empty directories.
      sysctl: Allow creating permanently empty directories that serve as mountpoints.
      proc: Allow creating permanently empty directories that serve as mount points
      kernfs: Add support for always empty directories.
      sysfs: Add support for permanently empty directories to serve as mount points.
      sysfs: Create mountpoints with sysfs_create_mount_point
      mnt: Update fs_fully_visible to test for permanently empty directories
      vfs: Remove incorrect debugging WARN in prepend_path
      nsfs: Add a show_path method to fix mountinfo
      mnt: Avoid unnecessary regressions in fs_fully_visible

 arch/s390/hypfs/inode.c      | 12 ++----
 drivers/firmware/efi/efi.c   |  6 +--
 fs/configfs/mount.c          | 10 ++---
 fs/dcache.c                  | 11 -----
 fs/debugfs/inode.c           | 11 ++---
 fs/fuse/inode.c              |  9 ++---
 fs/kernfs/dir.c              | 38 +++++++++++++++++-
 fs/kernfs/inode.c            |  2 +
 fs/libfs.c                   | 96 ++++++++++++++++++++++++++++++++++++++++++++
 fs/namespace.c               | 80 +++++++++++++++++++++++++++++++++---
 fs/nsfs.c                    | 10 +++++
 fs/proc/generic.c            | 23 +++++++++++
 fs/proc/inode.c              |  4 ++
 fs/proc/internal.h           |  6 +++
 fs/proc/proc_sysctl.c        | 37 +++++++++++++++++
 fs/proc/root.c               |  9 ++---
 fs/pstore/inode.c            | 12 ++----
 fs/sysfs/dir.c               | 34 ++++++++++++++++
 fs/sysfs/mount.c             |  5 +--
 fs/tracefs/inode.c           |  6 +--
 include/linux/fs.h           |  4 +-
 include/linux/kernfs.h       |  3 ++
 include/linux/mount.h        |  5 +++
 include/linux/sysctl.h       |  3 ++
 include/linux/sysfs.h        | 15 +++++++
 kernel/cgroup.c              | 10 ++---
 kernel/sysctl.c              |  8 +---
 security/inode.c             | 10 ++---
 security/selinux/selinuxfs.c | 11 +++--
 security/smack/smackfs.c     |  8 ++--
 30 files changed, 397 insertions(+), 101 deletions(-)
