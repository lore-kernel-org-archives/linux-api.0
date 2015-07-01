From: ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org (Eric W. Biederman)
Subject: [GIT PULL] User namespace related fixes for v4.2
Date: Wed, 01 Jul 2015 15:41:37 -0500
Message-ID: <878uazhapq.fsf@x220.int.ebiederm.org>
References: <87381eyz26.fsf@x220.int.ebiederm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <87381eyz26.fsf-JOvCrm2gF+uungPnsOpG7nhyD016LWXt@public.gmane.org> (Eric W. Biederman's
	message of "Fri, 26 Jun 2015 15:50:09 -0500")
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

Linus,

Please pull the for-linus branch from the git tree:

   git://git.kernel.org/pub/scm/linux/kernel/git/ebiederm/user-namespace.git for-linus

   HEAD: 93e3bce6287e1fb3e60d3324ed08555b5bbafa89 vfs: Remove incorrect debugging WARN in prepend_path

Colds suck and I was tired and pushing a little too hard at the start of
this merge window and I included a few things in my previous pull
request that I felt a were not quite ready.  Those things have
been dropped from my tree.  My apologies that was irresponsible.

Long ago and far away when user namespaces where young it was realized
that allowing fresh mounts of proc and sysfs with only user namespace
permissions could violate the basic rule that only root gets to decide
if proc or sysfs should be mounted at all.

Some hacks were put in place to reduce the worst of the damage could be
done, and the common sense rule was adopted that fresh mounts of proc
and sysfs should allow no more than bind mounts of proc and sysfs.
Unfortunately that rule has not been fully enforced.

There are two kinds of gaps in that enforcement.  Only filesystems
mounted on empty directories of proc and sysfs should be ignored but the
test for empty directories was insufficient.  So in my tree directories
on proc, sysctl and sysfs that will always be empty are created
specially.  Every other technique is imperfect as an ordinary directory
can have entries added even after a readdir returns and shows that the
directory is empty.  Special creation of directories for mount points
makes the code in the kernel a smidge clearer about it's purpose.  I
asked container developers from the various container projects to help
test this and no holes were found in the set of mount points on proc and
sysfs that are created specially.

This set of changes also starts enforcing the mount flags of fresh
mounts of proc and sysfs are consistent with the existing mount of proc
and sysfs.  I expected this to be the boring part of the work but
unfortunately unprivileged userspace winds up mounting fresh copies of
proc and sysfs with noexec and nosuid clear when root set those flags on
the previous mount of proc and sysfs.  So for now only the atime,
read-only and nodev attributes which userspace happens to keep
consistent are enforced.  Dealing with the noexec and nosuid attributes
remains for another time.

This set of changes also addresses an issue with how open file
descriptors from /proc/<pid>/ns/* are displayed.  Recently readlink of
/proc/<pid>/fd has been triggering a WARN_ON that has not been
meaningful since it was added (as all of the code in the kernel was
converted) and is not now actively wrong.

There is also a short list of issues that have not been fixed yet that I
will mention briefly.

It is possible to rename a directory from below to above a bind mount.
At which point any directory pointers below the renamed directory can be
walked up to the root directory of the filesystem.  With user namespaces
enabled a bind mount of the bind mount can be created allowing the user
to pick a directory whose children they can rename to outside of the
bind mount.  This is challenging to fix and doubly so because all
obvious solutions must touch code that is in the performance part of
pathname resolution.

As mentioned above there is also a question of how to ensure that
developers by accident or with purpose do not introduce exectuable files
on sysfs and proc and in doing so introduce security regressions in the
current userspace that will not be immediately obvious and as such are
likely to require breaking userspace in painful ways once they are
recognized.

Eric W. Biederman (11):
      mnt: Refactor the logic for mounting sysfs and proc in a user namespace
      mnt: Modify fs_fully_visible to deal with locked ro nodev and atime
      vfs: Ignore unlocked mounts in fs_fully_visible
      fs: Add helper functions for permanently empty directories.
      sysctl: Allow creating permanently empty directories that serve as mountpoints.
      proc: Allow creating permanently empty directories that serve as mount points
      kernfs: Add support for always empty directories.
      sysfs: Add support for permanently empty directories to serve as mount points.
      sysfs: Create mountpoints with sysfs_create_mount_point
      mnt: Update fs_fully_visible to test for permanently empty directories
      vfs: Remove incorrect debugging WARN in prepend_path

 arch/s390/hypfs/inode.c      | 12 ++----
 drivers/firmware/efi/efi.c   |  6 +--
 fs/configfs/mount.c          | 10 ++---
 fs/dcache.c                  | 11 -----
 fs/debugfs/inode.c           | 11 ++---
 fs/fuse/inode.c              |  9 ++---
 fs/kernfs/dir.c              | 38 +++++++++++++++++-
 fs/kernfs/inode.c            |  2 +
 fs/libfs.c                   | 96 ++++++++++++++++++++++++++++++++++++++++++++
 fs/namespace.c               | 39 +++++++++++++++---
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
 include/linux/sysctl.h       |  3 ++
 include/linux/sysfs.h        | 15 +++++++
 kernel/cgroup.c              | 10 ++---
 kernel/sysctl.c              |  8 +---
 security/inode.c             | 10 ++---
 security/selinux/selinuxfs.c | 11 +++--
 security/smack/smackfs.c     |  8 ++--
 28 files changed, 341 insertions(+), 101 deletions(-)

Eric
