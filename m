From: Li Xi <pkuelelixi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [v5 0/5] quota: add project quota support for ext4
Date: Sun, 26 Oct 2014 13:22:48 +0800
Message-ID: <1414300973-1118-1-git-send-email-lixi@ddn.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tytso-3s7WtUTddSA@public.gmane.org, adilger-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org, jack-AlSwsSmVLrQ@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, dmonakhov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org
List-Id: linux-api@vger.kernel.org

The following patches propose an implementation of project quota
support for ext4. A project is an aggregate of unrelated inodes
which might scatter in different directories. Inodes belongs to a
project possesses a same identification i.e. 'project ID', just
like every inode has its user/group identification. The following
patches adds project quota as supplement to the former uer/group
quota types.

The semantics of ext4 project quota is consistent with XFS. Each
directory can have EXT4_INODE_PROJINHERIT flag set. When the
EXT4_INODE_PROJINHERIT flag of a parent directory is not set, a
newly created inode under that directory will have a default project
ID (i.e. 0). And its EXT4_INODE_PROJINHERIT flag is not set either.
When this flag is set on a directory, following rules will be kept:

1) The newly created inode under that directory will inherit both
the EXT4_INODE_PROJINHERIT flag and the project ID from its parent
directory.

2) Hard-linking a inode with different project ID into that directory
will fail with errno EXDEV.

3) Renaming a inode with different project ID into that directory
will fail with errno EXDEV. However, 'mv' command will detect this
failure and copy the renamed inode to a new inode in the directory.
Thus, this new inode will inherit both the project ID and
EXT4_INODE_PROJINHERIT flag.

4) If the project quota of that ID is being enforced, statfs() on
that directory will take the quotas as another upper limits along
with the capacity of the file system, i.e. the total block/inode
number will be the minimum of the quota limits and file system
capacity.

Changelog:
* v5 <- v4:
 - Check project feature when set/get project ID;
 - Do not check project feature for project quota;
 - Add support of FS_IOC_FSSETXATTR/FS_IOC_FSGETXATTR.
* v4 <- v3:
 - Do not check project feature when set/get project ID;
 - Use EXT4_MAXQUOTAS instead of MAXQUOTAS in ext4 patches;
 - Remove unnecessary change of fs/quota/dquot.c;
 - Remove CONFIG_QUOTA_PROJECT.
* v3 <- v2:
 - Add EXT4_INODE_PROJINHERIT semantics.
* v2 <- v1:
 - Add ioctl interface for setting/getting project;
 - Add EXT4_FEATURE_RO_COMPAT_PROJECT;
 - Add get_projid() method in struct dquot_operations;
 - Add error check of ext4_inode_projid_set/get().

v4: http://lwn.net/Articles/612972/
v3: http://www.spinics.net/lists/linux-ext4/msg45184.html
v2: http://www.spinics.net/lists/linux-ext4/msg44695.html
v1: http://article.gmane.org/gmane.comp.file-systems.ext4/45153

Any comments or feedbacks are appreciated.

Regards,
                                         - Li Xi

Li Xi (5):
  Adds general codes to enforces project quota limits
  Adds project ID support for ext4
  Adds project quota support for ext4
  Adds ioctl interface support for ext4 project
  Adds FS_IOC_FSSETXATTR/FS_IOC_FSGETXATTR interface support for ext4

 Documentation/filesystems/ext4.txt |    4 +
 fs/ext4/ext4.h                     |   33 ++++-
 fs/ext4/ialloc.c                   |    8 +
 fs/ext4/inode.c                    |   31 +++++
 fs/ext4/ioctl.c                    |  253 ++++++++++++++++++++++++++++++++++++
 fs/ext4/namei.c                    |   10 ++
 fs/ext4/super.c                    |   96 ++++++++++++--
 fs/quota/dquot.c                   |   32 ++++-
 fs/quota/quota.c                   |   10 +-
 fs/quota/quotaio_v2.h              |    6 +-
 fs/xfs/xfs_fs.h                    |   17 +--
 include/linux/quota.h              |    2 +
 include/uapi/linux/fs.h            |   22 +++
 include/uapi/linux/quota.h         |    6 +-
 14 files changed, 488 insertions(+), 42 deletions(-)
