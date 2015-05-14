From: ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org (Eric W. Biederman)
Subject: [CFT][PATCH 0/10] Making new mounts of proc and sysfs as safe as bind
	mounts
Date: Thu, 14 May 2015 12:30:45 -0500
Message-ID: <87pp63jcca.fsf@x220.int.ebiederm.org>
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
To: Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
Cc: Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Kenton Varda <kenton-AuYgBwuPrUQTaNkGU808tA@public.gmane.org>, Michael Kerrisk-manpages <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org


The code is currently available at:

   git://git.kernel.org/pub/scm/linux/kernel/git/ebiederm/user-namespace.git for-testing

   HEAD: a524faf520600968e58bbc732063fccf2fdf9199 mnt: Update fs_fully_visible to test for permanently empty directories

The problem:  Mounting a new instance of proc of sysfs can allow things
that a bind mount of those filesystems would not.

That is the cases I am dealing with are:
     unshare --user --net --mount ; mount -t sysfs ...
     unshare --user --pid --mount ; mount -t proc ...

The big change is that this set of changes enforces the preservation of
locked mount flags, from the existing mount to the current mount.  Which
means that if proc was mounted read-only the current current will allow
a new instance of proc to be mounted read-write, and this set of changes
enforces that proc remain read-only.

The other gotcha is that the current code does not properly detect empty
directories so to prevent things slipping through the cracks this set of
changes annotates all mount points where nothing will be revealed if
the filesystem mounted on top is removed.

Enforcing the administrators policy can actually matter in the real
world as has been shown by the recent docker issue.

With this patchset I have two concerns:
- The enforcement of mount flag preservation on proc and sysfs may break
  things.  (I am especially worried about the implicit adding of nodev).

- I missed a filesystem mountpoint on proc or sysfs which would make a
  fresh copy unmountable for no good reason.

I don't want to break userspace if I can help it, and the code has been
this way for a while so I figure there is time to find any pitfalls and
address them before this code gets merged.

So if this works for you please give me your Tested-By

The well known mountpoints for pseudo filesystems that I could find are:
/dev/ffs*/                 functionfs
/dev/gadget/               gadgetfs
/dev/mqueue                mqueue
/dev/oprofile/             oprofilefs
/dev/pts/                  devpts
/dlm/                      ocfs2_dlmfs
/ipath/                    ipathfs
/proc/fs/nfsd/             nfsd
/proc/openprom/            openpromfs
/proc/sys/fs/binfmt_misc/  binfmt_misc
/spu/                      spufs
/sys/firmware/efi/efivars/ efivarfs
/sys/fs/cgroup/            cgroup
/sys/fs/fuse/connections/  fusectl
/sys/fs/pstore/            pstore
/sys/fs/selinux/           selinuxfs
/sys/fs/smackfs/           smackfs
/sys/hypervisor/s390/      s390_hypfs
/sys/kernel/config/        configfs
/sys/kernel/debug/         debugfs
/sys/kernel/security/      securityfs
/sys/kernel/tracing/       tracefs
/var/lib/ibmasm/           ibmasmfs
/var/lib/nfs/rpc_pipefs/   rpc_pipefs

Eric W. Biederman (10):
      mnt: Refactor the logic for mounting sysfs and proc in a user namespace
      mnt: Modify fs_fully_visible to deal with mount attributes
      vfs: Ignore unlocked mounts in fs_fully_visible
      fs: Add helper functions for permanently empty directories.
      sysctl: Allow creating permanently empty directories.
      proc: Allow creating permanently empty directories.
      kernfs: Add support for always empty directories.
      sysfs: Add support for permanently empty directories.
      sysfs: Create mountpoints with sysfs_create_empty_dir
      mnt: Update fs_fully_visible to test for permanently empty directories

 arch/s390/hypfs/inode.c      | 12 ++----
 drivers/firmware/efi/efi.c   |  6 +--
 fs/configfs/mount.c          | 10 ++---
 fs/debugfs/inode.c           | 11 ++---
 fs/fuse/inode.c              |  9 ++---
 fs/kernfs/dir.c              | 38 +++++++++++++++++-
 fs/kernfs/inode.c            |  2 +
 fs/libfs.c                   | 96 ++++++++++++++++++++++++++++++++++++++++++++
 fs/namespace.c               | 47 +++++++++++++++++++---
 fs/proc/generic.c            | 23 +++++++++++
 fs/proc/inode.c              |  3 ++
 fs/proc/internal.h           |  1 +
 fs/proc/proc_sysctl.c        | 37 +++++++++++++++++
 fs/proc/root.c               |  9 ++---
 fs/pstore/inode.c            | 12 ++----
 fs/sysfs/dir.c               | 34 ++++++++++++++++
 fs/sysfs/mount.c             |  5 +--
 fs/tracefs/inode.c           |  6 +--
 include/linux/fs.h           |  4 +-
 include/linux/kernfs.h       |  3 ++
 include/linux/sysctl.h       |  3 ++
 include/linux/sysfs.h        | 16 ++++++++
 kernel/cgroup.c              | 10 ++---
 kernel/sysctl.c              |  8 +---
 security/inode.c             | 10 ++---
 security/selinux/selinuxfs.c | 11 +++--
 security/smack/smackfs.c     |  8 ++--
 27 files changed, 344 insertions(+), 90 deletions(-)
