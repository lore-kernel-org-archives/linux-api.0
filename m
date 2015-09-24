From: Jan Kara <jack@suse.cz>
Subject: Re: [v15 0/4] ext4: add project quota support
Date: Thu, 24 Sep 2015 14:09:16 +0200
Message-ID: <20150924120916.GB27066@quack.suse.cz>
References: <1442146833-13652-1-git-send-email-lixi@ddn.com>
 <20150923123119.GA13946@quack.suse.cz>
 <CAPTn0cBB7h89R7NB+zg+J+TVvKXut_Usixs==S=AWs-v7kZExg@mail.gmail.com>
 <87bncttg61.fsf@openvz.org>
 <CAPTn0cC=1xWCcUMVqhAx4pvqqX9rXC8p6B4Jt7cpm4HfuaFOMw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAPTn0cC=1xWCcUMVqhAx4pvqqX9rXC8p6B4Jt7cpm4HfuaFOMw@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Li Xi <pkuelelixi@gmail.com>
Cc: Dmitry Monakhov <dmonakhov@openvz.org>, Jan Kara <jack@suse.cz>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, Ext4 Developers List <linux-ext4@vger.kernel.org>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>, Theodore Ts'o <tytso@mit.edu>, Andreas Dilger <adilger@dilger.ca>, "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>, "hch@infradead.org" <hch@infradead.org>
List-Id: linux-api@vger.kernel.org

  Hi,

On Wed 23-09-15 21:57:06, Li Xi wrote:
> Please check following linkage. It includes all the patches I've made
> for ext4 project quota. Unfortunately, multiple tools need to be
> patched, including 1) patch e2fsprogs 2) patch quota-tools 3) patch
> linux kernel 4) compile project_manage.
> 
> Please let me know if there is any problem.

BTW, do you plan to submit e.g. quota-tools related changes? I've glanced
over what you have in your github repo and it looks sensible. Only you can
rip out prjjquota mount option and quotacheck support for project quota
since that will be all handled in kernel / e2fsprogs...

								Honza

> On Wed, Sep 23, 2015 at 9:32 PM, Dmitry Monakhov <dmonakhov@openvz.org> wrote:
> > Li Xi <pkuelelixi@gmail.com> writes:
> >
> >> Hi Jan Kara,
> >>
> >> Sorry, I forgot to mention that we run the xfstests for both XFS and
> >> Ext4 with and without these patches. And still, some (but not too
> >> many) of the tests fails, but the failed tests are the same no matter
> >> the patches are applied or not. And we didn't see any project quota
> >> related tests fails.
> > BTW. Where I can find userspace tools to play with this feature?
> >>
> >> Regards,
> >> Li Xi
> >>
> >> On Wed, Sep 23, 2015 at 8:31 PM, Jan Kara <jack@suse.cz> wrote:
> >>> On Sun 13-09-15 21:20:29, Li Xi wrote:
> >>>> The following patches propose an implementation of project quota
> >>>> support for ext4. A project is an aggregate of unrelated inodes
> >>>> which might scatter in different directories. Inodes that belong
> >>>> to the same project possess an identical identification i.e.
> >>>> 'project ID', just like every inode has its user/group
> >>>> identification. The following patches add project quota as
> >>>> supplement to the former uer/group quota types.
> >>>
> >>> With the last version of the patches, there was only one outstanding issue
> >>> and that was whether xfstests for XFS pass correctly (especially the
> >>> project quota related ones). Have you been able to verify this?
> >>>
> >>>                                                                 Honza
> >>>
> >>>>
> >>>> The semantics of ext4 project quota is consistent with XFS. Each
> >>>> directory can have EXT4_INODE_PROJINHERIT flag set. When the
> >>>> EXT4_INODE_PROJINHERIT flag of a parent directory is not set, a
> >>>> newly created inode under that directory will have a default project
> >>>> ID (i.e. 0). And its EXT4_INODE_PROJINHERIT flag is not set either.
> >>>> When this flag is set on a directory, following rules will be kept:
> >>>>
> >>>> 1) The newly created inode under that directory will inherit both
> >>>> the EXT4_INODE_PROJINHERIT flag and the project ID from its parent
> >>>> directory.
> >>>>
> >>>> 2) Hard-linking a inode with different project ID into that directory
> >>>> will fail with errno EXDEV.
> >>>>
> >>>> 3) Renaming a inode with different project ID into that directory
> >>>> will fail with errno EXDEV. However, 'mv' command will detect this
> >>>> failure and copy the renamed inode to a new inode in the directory.
> >>>> Thus, this new inode will inherit both the project ID and
> >>>> EXT4_INODE_PROJINHERIT flag.
> >>>>
> >>>> 4) If the project quota of that ID is being enforced, statfs() on
> >>>> that directory will take the quotas as another upper limits along
> >>>> with the capacity of the file system, i.e. the total block/inode
> >>>> number will be the minimum of the quota limits and file system
> >>>> capacity.
> >>>>
> >>>> Changelog:
> >>>> * v15 <- v14:
> >>>>  - Rebase to newest master branch of git repository (b0a1ea51b).
> >>>> * v14 <- v13:
> >>>>  - Cleanup ioctl of setting project ID;
> >>>>  - Do not check project quota inode number specially;
> >>>>  - Check isize when extract project ID from disk;
> >>>>  - Rebase to latest kernel (4.0.0)
> >>>> * v13 <- v12:
> >>>>  - Update inode size check of project ID.
> >>>> * v12 <- v11:
> >>>>  - Relax the permission check when setting project ID.
> >>>> * v11 <- v10:
> >>>>  - Remove project quota mount option;
> >>>>  - Fix permission check when setting project ID.
> >>>> * v10 <- v9:
> >>>>  - Remove non-journaled project quota interface;
> >>>>  - Only allow admin to read project quota info;
> >>>>  - Cleanup FS_IOC_FSSETXATTR/FS_IOC_FSGETXATTR interface.
> >>>> * v9 <- v8:
> >>>>  - Remove non-journaled project quota;
> >>>>  - Rebase to newest dev branch of ext4 repository (3.19.0-rc3).
> >>>> * v8 <- v7:
> >>>>  - Rebase to newest dev branch of ext4 repository (3.18.0_rc3).
> >>>> * v7 <- v6:
> >>>>  - Map ext4 inode flags to xflags of struct fsxattr;
> >>>>  - Add patch to cleanup ext4 inode flag definitions.
> >>>> * v6 <- v5:
> >>>>  - Add project ID check for cross rename;
> >>>>  - Remove patch of EXT4_IOC_GETPROJECT/EXT4_IOC_SETPROJECT ioctl
> >>>> * v5 <- v4:
> >>>>  - Check project feature when set/get project ID;
> >>>>  - Do not check project feature for project quota;
> >>>>  - Add support of FS_IOC_FSSETXATTR/FS_IOC_FSGETXATTR.
> >>>> * v4 <- v3:
> >>>>  - Do not check project feature when set/get project ID;
> >>>>  - Use EXT4_MAXQUOTAS instead of MAXQUOTAS in ext4 patches;
> >>>>  - Remove unnecessary change of fs/quota/dquot.c;
> >>>>  - Remove CONFIG_QUOTA_PROJECT.
> >>>> * v3 <- v2:
> >>>>  - Add EXT4_INODE_PROJINHERIT semantics.
> >>>> * v2 <- v1:
> >>>>  - Add ioctl interface for setting/getting project;
> >>>>  - Add EXT4_FEATURE_RO_COMPAT_PROJECT;
> >>>>  - Add get_projid() method in struct dquot_operations;
> >>>>  - Add error check of ext4_inode_projid_set/get().
> >>>>
> >>>> v14: http://article.gmane.org/gmane.linux.kernel.api/10345
> >>>> v13: http://www.spinics.net/lists/linux-fsdevel/msg85205.html
> >>>> v12: http://www.spinics.net/lists/linux-fsdevel/msg84905.html
> >>>> v11: http://www.spinics.net/lists/linux-ext4/msg47450.html
> >>>> v10: http://www.spinics.net/lists/linux-ext4/msg47413.html
> >>>> v9: http://www.spinics.net/lists/linux-ext4/msg47326.html
> >>>> v8: http://www.spinics.net/lists/linux-ext4/msg46545.html
> >>>> v7: http://www.spinics.net/lists/linux-fsdevel/msg80404.html
> >>>> v6: http://www.spinics.net/lists/linux-fsdevel/msg80022.html
> >>>> v5: http://www.spinics.net/lists/linux-api/msg04840.html
> >>>> v4: http://lwn.net/Articles/612972/
> >>>> v3: http://www.spinics.net/lists/linux-ext4/msg45184.html
> >>>> v2: http://www.spinics.net/lists/linux-ext4/msg44695.html
> >>>> v1: http://article.gmane.org/gmane.comp.file-systems.ext4/45153
> >>>>
> >>>> Any comments or feedbacks are appreciated.
> >>>>
> >>>> Regards,
> >>>>                                          - Li Xi
> >>>>
> >>>> Li Xi (4):
> >>>>   ext4: adds project ID support
> >>>>   ext4: adds project quota support
> >>>>   ext4: adds FS_IOC_FSSETXATTR/FS_IOC_FSGETXATTR interface support
> >>>>   ext4: cleanup inode flag definitions
> >>>>
> >>>>  fs/ext4/ext4.h          |   85 +++++++----
> >>>>  fs/ext4/ialloc.c        |    7 +
> >>>>  fs/ext4/inode.c         |   28 ++++
> >>>>  fs/ext4/ioctl.c         |  367 ++++++++++++++++++++++++++++++++++++-----------
> >>>>  fs/ext4/namei.c         |   19 +++
> >>>>  fs/ext4/super.c         |   57 +++++++-
> >>>>  fs/xfs/libxfs/xfs_fs.h  |   47 +++----
> >>>>  include/uapi/linux/fs.h |   33 +++++
> >>>>  8 files changed, 490 insertions(+), 153 deletions(-)
> >>>>
> >>> --
> >>> Jan Kara <jack@suse.com>
> >>> SUSE Labs, CR
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
