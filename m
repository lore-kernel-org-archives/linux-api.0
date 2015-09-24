From: Andreas Dilger <adilger-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>
Subject: Re: [v15 0/4] ext4: add project quota support
Date: Thu, 24 Sep 2015 19:12:11 +0200
Message-ID: <43B1BB97-8D53-4D93-9B57-B5E2048F7E7A@dilger.ca>
References: <1442146833-13652-1-git-send-email-lixi@ddn.com>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2104\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1442146833-13652-1-git-send-email-lixi-LfVdkaOWEx8@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Li Xi <pkuelelixi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-ext4 <linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>, =?utf-8?B?0JTQvNC40YLRgNC40Lkg0JzQvtC90LDRhdC+0LI=?= <dmonakhov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Shuichi Ihara <ihashu-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Sep 13, 2015, at 2:20 PM, Li Xi <pkuelelixi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> 
> The following patches propose an implementation of project quota
> support for ext4. A project is an aggregate of unrelated inodes
> which might scatter in different directories. Inodes that belong
> to the same project possess an identical identification i.e.
> 'project ID', just like every inode has its user/group
> identification. The following patches add project quota as
> supplement to the former uer/group quota types.

We discussed this on the ext4 developer concall today and tried to
move the landing of these patches forward.  Some notes below:

- Ted: agreed to reserve EXT4_FEATURE_RO_COMPAT_PROJECT, s_prj_quota_inum,
  EXT4_PROJINHERIT_FL, and i_projid fields for use by project quota to
  avoid compatibility issues if patches are not landed immediately.
   - Ted: to do final check of inode flag value
   - ext4 project quota inode does not need to use a reserved inode, but
     could after Jan's patch to increase reserved inodes lands
- Li Xi: identify xfstests subtests that are exercising project quota
   - submit patches to xfstests that will activate them for ext4
   - keep in ext4 xfstests for testing until patches land upstream
   - this needs to be done before landing to ensure ext4 code works
- Li Xi: document the behaviour of project quota (if no existing
  document exists for XFS already), some of this is already below
   - update man pages for df(1) and statfs(2) for subdir with project ID
     (i.e. that it returns only quota usage and limit for project ID)
   - Ted: where should document go? linux/Documentation/fs? ext4 wiki?
   - not a requirement for testing, can be done after landing

- All: decide on a common tool for setting project ID on file/directory
   - don't want to require xfsutils in order to use project quota
   - start with chattr (using FS_IOC_FS{GET,SET}XATTR) in e2fsprogs
     - allows testing project quota with e2fsprogs/ext4
   - chproj (like chown/chgrp) would also be an option
     - needs more discussion/development effort, goes into fileutils
   - this doesn't need to be decided immediately, and both could be done

Ted, please add in anything that I forgot.

Cheers, Andreas

> The semantics of ext4 project quota is consistent with XFS. Each
> directory can have EXT4_INODE_PROJINHERIT flag set. When the
> EXT4_INODE_PROJINHERIT flag of a parent directory is not set, a
> newly created inode under that directory will have a default project
> ID (i.e. 0). And its EXT4_INODE_PROJINHERIT flag is not set either.
> When this flag is set on a directory, following rules will be kept:
> 
> 1) The newly created inode under that directory will inherit both
> the EXT4_INODE_PROJINHERIT flag and the project ID from its parent
> directory.
> 
> 2) Hard-linking a inode with different project ID into that directory
> will fail with errno EXDEV.
> 
> 3) Renaming a inode with different project ID into that directory
> will fail with errno EXDEV. However, 'mv' command will detect this
> failure and copy the renamed inode to a new inode in the directory.
> Thus, this new inode will inherit both the project ID and
> EXT4_INODE_PROJINHERIT flag.
> 
> 4) If the project quota of that ID is being enforced, statfs() on
> that directory will take the quotas as another upper limits along
> with the capacity of the file system, i.e. the total block/inode
> number will be the minimum of the quota limits and file system
> capacity.
> 
> Changelog:
> * v15 <- v14:
> - Rebase to newest master branch of git repository (b0a1ea51b).
> * v14 <- v13:
> - Cleanup ioctl of setting project ID;
> - Do not check project quota inode number specially;
> - Check isize when extract project ID from disk;
> - Rebase to latest kernel (4.0.0)
> * v13 <- v12:
> - Update inode size check of project ID.
> * v12 <- v11:
> - Relax the permission check when setting project ID.
> * v11 <- v10:
> - Remove project quota mount option;
> - Fix permission check when setting project ID.
> * v10 <- v9:
> - Remove non-journaled project quota interface;
> - Only allow admin to read project quota info;
> - Cleanup FS_IOC_FSSETXATTR/FS_IOC_FSGETXATTR interface.
> * v9 <- v8:
> - Remove non-journaled project quota;
> - Rebase to newest dev branch of ext4 repository (3.19.0-rc3).
> * v8 <- v7:
> - Rebase to newest dev branch of ext4 repository (3.18.0_rc3).
> * v7 <- v6:
> - Map ext4 inode flags to xflags of struct fsxattr;
> - Add patch to cleanup ext4 inode flag definitions.
> * v6 <- v5:
> - Add project ID check for cross rename;
> - Remove patch of EXT4_IOC_GETPROJECT/EXT4_IOC_SETPROJECT ioctl
> * v5 <- v4:
> - Check project feature when set/get project ID;
> - Do not check project feature for project quota;
> - Add support of FS_IOC_FSSETXATTR/FS_IOC_FSGETXATTR.
> * v4 <- v3:
> - Do not check project feature when set/get project ID;
> - Use EXT4_MAXQUOTAS instead of MAXQUOTAS in ext4 patches;
> - Remove unnecessary change of fs/quota/dquot.c;
> - Remove CONFIG_QUOTA_PROJECT.
> * v3 <- v2:
> - Add EXT4_INODE_PROJINHERIT semantics.
> * v2 <- v1:
> - Add ioctl interface for setting/getting project;
> - Add EXT4_FEATURE_RO_COMPAT_PROJECT;
> - Add get_projid() method in struct dquot_operations;
> - Add error check of ext4_inode_projid_set/get().
> 
> v14: http://article.gmane.org/gmane.linux.kernel.api/10345
> v13: http://www.spinics.net/lists/linux-fsdevel/msg85205.html
> v12: http://www.spinics.net/lists/linux-fsdevel/msg84905.html
> v11: http://www.spinics.net/lists/linux-ext4/msg47450.html
> v10: http://www.spinics.net/lists/linux-ext4/msg47413.html
> v9: http://www.spinics.net/lists/linux-ext4/msg47326.html
> v8: http://www.spinics.net/lists/linux-ext4/msg46545.html
> v7: http://www.spinics.net/lists/linux-fsdevel/msg80404.html
> v6: http://www.spinics.net/lists/linux-fsdevel/msg80022.html
> v5: http://www.spinics.net/lists/linux-api/msg04840.html
> v4: http://lwn.net/Articles/612972/
> v3: http://www.spinics.net/lists/linux-ext4/msg45184.html
> v2: http://www.spinics.net/lists/linux-ext4/msg44695.html
> v1: http://article.gmane.org/gmane.comp.file-systems.ext4/45153
> 
> Any comments or feedbacks are appreciated.
> 
> Regards,
>                                         - Li Xi
> 
> Li Xi (4):
>  ext4: adds project ID support
>  ext4: adds project quota support
>  ext4: adds FS_IOC_FSSETXATTR/FS_IOC_FSGETXATTR interface support
>  ext4: cleanup inode flag definitions
> 
> fs/ext4/ext4.h          |   85 +++++++----
> fs/ext4/ialloc.c        |    7 +
> fs/ext4/inode.c         |   28 ++++
> fs/ext4/ioctl.c         |  367 ++++++++++++++++++++++++++++++++++++-----------
> fs/ext4/namei.c         |   19 +++
> fs/ext4/super.c         |   57 +++++++-
> fs/xfs/libxfs/xfs_fs.h  |   47 +++----
> include/uapi/linux/fs.h |   33 +++++
> 8 files changed, 490 insertions(+), 153 deletions(-)
> 


Cheers, Andreas
