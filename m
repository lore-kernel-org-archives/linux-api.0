From: ebiederm@xmission.com (Eric W. Biederman)
Subject: [CFT][PATCH 00/10] Making new mounts of proc and sysfs as safe as bind mounts (take 2)
Date: Fri, 15 May 2015 21:05:39 -0500
Message-ID: <87siaxuvik.fsf@x220.int.ebiederm.org>
References: <87pp63jcca.fsf@x220.int.ebiederm.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <87pp63jcca.fsf@x220.int.ebiederm.org> (Eric W. Biederman's
	message of "Thu, 14 May 2015 12:30:45 -0500")
Sender: linux-fsdevel-owner@vger.kernel.org
To: Linux Containers <containers@lists.linux-foundation.org>
Cc: linux-fsdevel@vger.kernel.org, Linux API <linux-api@vger.kernel.org>, "Serge E. Hallyn" <serge@hallyn.com>, Andy Lutomirski <luto@amacapital.net>, Richard Weinberger <richard@nod.at>, Kenton Varda <kenton@sandstorm.io>, Michael Kerrisk-manpages <mtk.manpages@gmail.com>, =?utf-8?Q?St=C3=A9phane?= Graber <stgraber@ubuntu.com>, Eric Windisch <ewindisch@docker.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Tejun Heo <tj@kernel.org>
List-Id: linux-api@vger.kernel.org

The code is currently available at:

   git://git.kernel.org/pub/scm/linux/kernel/git/ebiederm/user-namespace.git for-testing

   HEAD: 513d98ba1adfa9e3178b6fc3b2fa57a622283d32 mnt: Update fs_fully_visible to test for permanently empty directories

The problem:  Mounting a new instance of proc of sysfs can allow things
that a bind mount of those filesystems would not.

That is the cases I am dealing with are:
     unshare --user --net --mount ; mount -t sysfs ...
     unshare --user --pid --mount ; mount -t proc ...

This set of changes enforces the preservation of locked mount flags,
from the existing mount to the current mount.  Which means that if proc
was mounted read-only the current current will allow a new instance of
proc to be mounted read-write, and this set of changes enforces that
proc remain read-only.

This set of changes also updates sysctl, proc and sysfs to explicitly
create the directories they expect to be mount points as mount points.
Making the code a little clearly and making it so when fs_fully_visible
disregards something mounted on a proc or sysfs it is guaranteed to
be safe, unlike the current code which can occassionally let things
fall through the cracks.

These changes to enforce the administrators policy can actually matter
in the real world as has been shown by the recent docker issue.

With this patchset I have two concerns:
- The enforcement of not being able to mount proc or sysfs with fewer
  mount flags than the existing mount may break something.

- That there is a filesystem that that common mounts on proc or sysfs
  and I missed annotating it's mount point.  That would make mounting
  a freshy copy of proc or sysfs impossible.

I don't want to break userspace if I can help it, and the code has been
this way for a while so I figure there is time to find any pitfalls and
address them before this code gets merged.  Folks rom lxc, sandstorm,
libvirt-lxc (anyone who uses user namespaces in the least) a
confirmation that I have not broken your existing code would be
appreciated.

If this works for you please give me your Tested-By

Since the first version I have renamed the directory creation calls to
have sysfs_create_mount_point and proc_create_mount_point (as suggested
by Greg KH so that it is very clear what the code that creates those
mount points is doing.  I have also fixed a stupid bug that slipped into
the proc code when I refactored it.  I have also gone through and rested
everything so hopefully nothing has slipped past me.

The well known mountpoints for pseudo filesystems that I could find are:
/dev/ffs*/                 functionfs
/dev/gadget/               gadgetfs
/dev/mqueue                mqueue
/dev/oprofile/             oprofilefs
/dev/pts/                  devpts
/dev/shm/                  tmpfs
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
      sysctl: Allow creating permanently empty directories that serve as mountpoints.
      proc: Allow creating permanently empty directories that serve as mount points
      kernfs: Add support for always empty directories.
      sysfs: Add support for permanently empty directories to serve as mount points.
      sysfs: Create mountpoints with sysfs_create_mount_point
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
 include/linux/sysfs.h        | 16 ++++++++
 kernel/cgroup.c              | 10 ++---
 kernel/sysctl.c              |  8 +---
 security/inode.c             | 10 ++---
 security/selinux/selinuxfs.c | 11 +++--
 security/smack/smackfs.c     |  8 ++--
 27 files changed, 350 insertions(+), 90 deletions(-)

Eric
