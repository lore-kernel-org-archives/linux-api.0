From: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Subject: Re: [v8 4/5] ext4: adds FS_IOC_FSSETXATTR/FS_IOC_FSGETXATTR interface
 support
Date: Thu, 22 Jan 2015 18:28:51 +0300
Message-ID: <54C11733.7080801@yandex-team.ru>
References: <1418102548-5469-1-git-send-email-lixi@ddn.com> <1418102548-5469-5-git-send-email-lixi@ddn.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1418102548-5469-5-git-send-email-lixi@ddn.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Li Xi <pkuelelixi@gmail.com>, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, linux-api@vger.kernel.org, tytso@mit.edu, adilger@dilger.ca, jack@suse.cz, viro@zeniv.linux.org.uk, hch@infradead.org, dmonakhov@openvz.org
List-Id: linux-api@vger.kernel.org

On 09.12.2014 08:22, Li Xi wrote:
> This patch adds FS_IOC_FSSETXATTR/FS_IOC_FSGETXATTR ioctl interface
> support for ext4. The interface is kept consistent with
> XFS_IOC_FSGETXATTR/XFS_IOC_FSGETXATTR.
>
> Signed-off-by: Li Xi <lixi@ddn.com>
> ---
>   fs/ext4/ext4.h          |  111 ++++++++++++++++
>   fs/ext4/ioctl.c         |  330 +++++++++++++++++++++++++++++++++--------------
>   fs/xfs/xfs_fs.h         |   47 +++-----
>   include/uapi/linux/fs.h |   58 ++++++++
>   4 files changed, 418 insertions(+), 128 deletions(-)
>
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index 136e18c..43a2a88 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -384,6 +384,115 @@ struct flex_groups {
>   #define EXT4_FL_USER_VISIBLE		0x204BDFFF /* User visible flags */
>   #define EXT4_FL_USER_MODIFIABLE		0x204380FF /* User modifiable flags */
>
> +/* Transfer internal flags to xflags */
> +static inline __u32 ext4_iflags_to_xflags(unsigned long iflags)
> +{
> +	__u32 xflags = 0;
> +
> +	if (iflags & EXT4_SECRM_FL)
> +		xflags |= FS_XFLAG_SECRM;
> +	if (iflags & EXT4_UNRM_FL)
> +		xflags |= FS_XFLAG_UNRM;
> +	if (iflags & EXT4_COMPR_FL)
> +		xflags |= FS_XFLAG_COMPR;
> +	if (iflags & EXT4_SYNC_FL)
> +		xflags |= FS_XFLAG_SYNC;
> +	if (iflags & EXT4_IMMUTABLE_FL)
> +		xflags |= FS_XFLAG_IMMUTABLE;
> +	if (iflags & EXT4_APPEND_FL)
> +		xflags |= FS_XFLAG_APPEND;
> +	if (iflags & EXT4_NODUMP_FL)
> +		xflags |= FS_XFLAG_NODUMP;
> +	if (iflags & EXT4_NOATIME_FL)
> +		xflags |= FS_XFLAG_NOATIME;
> +	if (iflags & EXT4_COMPRBLK_FL)
> +		xflags |= FS_XFLAG_COMPRBLK;
> +	if (iflags & EXT4_NOCOMPR_FL)
> +		xflags |= FS_XFLAG_NOCOMPR;
> +	if (iflags & EXT4_ECOMPR_FL)
> +		xflags |= FS_XFLAG_ECOMPR;
> +	if (iflags & EXT4_INDEX_FL)
> +		xflags |= FS_XFLAG_INDEX;
> +	if (iflags & EXT4_IMAGIC_FL)
> +		xflags |= FS_XFLAG_IMAGIC;
> +	if (iflags & EXT4_JOURNAL_DATA_FL)
> +		xflags |= FS_XFLAG_JOURNAL_DATA;
> +	if (iflags & EXT4_NOTAIL_FL)
> +		xflags |= FS_XFLAG_NOTAIL;
> +	if (iflags & EXT4_DIRSYNC_FL)
> +		xflags |= FS_XFLAG_DIRSYNC;
> +	if (iflags & EXT4_TOPDIR_FL)
> +		xflags |= FS_XFLAG_TOPDIR;
> +	if (iflags & EXT4_HUGE_FILE_FL)
> +		xflags |= FS_XFLAG_HUGE_FILE;
> +	if (iflags & EXT4_EXTENTS_FL)
> +		xflags |= FS_XFLAG_EXTENTS;
> +	if (iflags & EXT4_EA_INODE_FL)
> +		xflags |= FS_XFLAG_EA_INODE;
> +	if (iflags & EXT4_EOFBLOCKS_FL)
> +		xflags |= FS_XFLAG_EOFBLOCKS;
> +	if (iflags & EXT4_INLINE_DATA_FL)
> +		xflags |= FS_XFLAG_INLINE_DATA;
> +	if (iflags & EXT4_PROJINHERIT_FL)
> +		xflags |= FS_XFLAG_PROJINHERIT;
> +	return xflags;
> +}
> +
> +/* Transfer xflags flags to internal */
> +static inline unsigned long ext4_xflags_to_iflags(__u32 xflags)
> +{
> +	unsigned long iflags = 0;
> +
> +	if (xflags & FS_XFLAG_SECRM)
> +		iflags |= EXT4_SECRM_FL;
> +	if (xflags & FS_XFLAG_UNRM)
> +		iflags |= EXT4_UNRM_FL;
> +	if (xflags & FS_XFLAG_COMPR)
> +		iflags |= EXT4_COMPR_FL;
> +	if (xflags & FS_XFLAG_SYNC)
> +		iflags |= EXT4_SYNC_FL;
> +	if (xflags & FS_XFLAG_IMMUTABLE)
> +		iflags |= EXT4_IMMUTABLE_FL;
> +	if (xflags & FS_XFLAG_APPEND)
> +		iflags |= EXT4_APPEND_FL;
> +	if (xflags & FS_XFLAG_NODUMP)
> +		iflags |= EXT4_NODUMP_FL;
> +	if (xflags & FS_XFLAG_NOATIME)
> +		iflags |= EXT4_NOATIME_FL;
> +	if (xflags & FS_XFLAG_COMPRBLK)
> +		iflags |= EXT4_COMPRBLK_FL;
> +	if (xflags & FS_XFLAG_NOCOMPR)
> +		iflags |= EXT4_NOCOMPR_FL;
> +	if (xflags & FS_XFLAG_ECOMPR)
> +		iflags |= EXT4_ECOMPR_FL;
> +	if (xflags & FS_XFLAG_INDEX)
> +		iflags |= EXT4_INDEX_FL;
> +	if (xflags & FS_XFLAG_IMAGIC)
> +		iflags |= EXT4_IMAGIC_FL;
> +	if (xflags & FS_XFLAG_JOURNAL_DATA)
> +		iflags |= EXT4_JOURNAL_DATA_FL;
> +	if (xflags & FS_XFLAG_IMAGIC)
> +		iflags |= FS_XFLAG_NOTAIL;
> +	if (xflags & FS_XFLAG_DIRSYNC)
> +		iflags |= EXT4_DIRSYNC_FL;
> +	if (xflags & FS_XFLAG_TOPDIR)
> +		iflags |= EXT4_TOPDIR_FL;
> +	if (xflags & FS_XFLAG_HUGE_FILE)
> +		iflags |= EXT4_HUGE_FILE_FL;
> +	if (xflags & FS_XFLAG_EXTENTS)
> +		iflags |= EXT4_EXTENTS_FL;
> +	if (xflags & FS_XFLAG_EA_INODE)
> +		iflags |= EXT4_EA_INODE_FL;
> +	if (xflags & FS_XFLAG_EOFBLOCKS)
> +		iflags |= EXT4_EOFBLOCKS_FL;
> +	if (xflags & FS_XFLAG_INLINE_DATA)
> +		iflags |= EXT4_INLINE_DATA_FL;
> +	if (xflags & FS_XFLAG_PROJINHERIT)
> +		iflags |= EXT4_PROJINHERIT_FL;
> +
> +	return iflags;
> +}
> +
>   /* Flags that should be inherited by new inodes from their parent. */
>   #define EXT4_FL_INHERITED (EXT4_SECRM_FL | EXT4_UNRM_FL | EXT4_COMPR_FL |\
>   			   EXT4_SYNC_FL | EXT4_NODUMP_FL | EXT4_NOATIME_FL |\
> @@ -606,6 +715,8 @@ enum {
>   #define EXT4_IOC_RESIZE_FS		_IOW('f', 16, __u64)
>   #define EXT4_IOC_SWAP_BOOT		_IO('f', 17)
>   #define EXT4_IOC_PRECACHE_EXTENTS	_IO('f', 18)
> +#define EXT4_IOC_FSGETXATTR		FS_IOC_FSGETXATTR
> +#define EXT4_IOC_FSSETXATTR		FS_IOC_FSSETXATTR
>
>   #if defined(__KERNEL__) && defined(CONFIG_COMPAT)
>   /*
> diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
> index f58a0d1..8332476 100644
> --- a/fs/ext4/ioctl.c
> +++ b/fs/ext4/ioctl.c
> @@ -14,6 +14,8 @@
>   #include <linux/compat.h>
>   #include <linux/mount.h>
>   #include <linux/file.h>
> +#include <linux/quotaops.h>
> +#include <linux/quota.h>
>   #include <asm/uaccess.h>
>   #include "ext4_jbd2.h"
>   #include "ext4.h"
> @@ -196,126 +198,220 @@ journal_err_out:
>   	return err;
>   }
>
> -long ext4_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
> +static int ext4_ioctl_setflags(struct file *filp, unsigned int flags)
>   {
>   	struct inode *inode = file_inode(filp);
> -	struct super_block *sb = inode->i_sb;
>   	struct ext4_inode_info *ei = EXT4_I(inode);
> -	unsigned int flags;
> +	handle_t *handle = NULL;
> +	int err, migrate = 0;
> +	struct ext4_iloc iloc;
> +	unsigned int oldflags, mask, i;
> +	unsigned int jflag;
>
> -	ext4_debug("cmd = %u, arg = %lu\n", cmd, arg);
> +	if (!inode_owner_or_capable(inode))
> +		return -EACCES;
>
> -	switch (cmd) {
> -	case EXT4_IOC_GETFLAGS:
> -		ext4_get_inode_flags(ei);
> -		flags = ei->i_flags & EXT4_FL_USER_VISIBLE;
> -		return put_user(flags, (int __user *) arg);
> -	case EXT4_IOC_SETFLAGS: {
> -		handle_t *handle = NULL;
> -		int err, migrate = 0;
> -		struct ext4_iloc iloc;
> -		unsigned int oldflags, mask, i;
> -		unsigned int jflag;
> +	err = mnt_want_write_file(filp);
> +	if (err)
> +		return err;
>
> -		if (!inode_owner_or_capable(inode))
> -			return -EACCES;
> +	flags = ext4_mask_flags(inode->i_mode, flags);
>
> -		if (get_user(flags, (int __user *) arg))
> -			return -EFAULT;
> +	err = -EPERM;
> +	mutex_lock(&inode->i_mutex);
> +	/* Is it quota file? Do not allow user to mess with it */
> +	if (IS_NOQUOTA(inode))
> +		goto flags_out;
>
> -		err = mnt_want_write_file(filp);
> -		if (err)
> -			return err;
> +	oldflags = ei->i_flags;
>
> -		flags = ext4_mask_flags(inode->i_mode, flags);
> +	/* The JOURNAL_DATA flag is modifiable only by root */
> +	jflag = flags & EXT4_JOURNAL_DATA_FL;
>
> -		err = -EPERM;
> -		mutex_lock(&inode->i_mutex);
> -		/* Is it quota file? Do not allow user to mess with it */
> -		if (IS_NOQUOTA(inode))
> +	/*
> +	 * The IMMUTABLE and APPEND_ONLY flags can only be changed by
> +	 * the relevant capability.
> +	 *
> +	 * This test looks nicer. Thanks to Pauline Middelink
> +	 */
> +	if ((flags ^ oldflags) & (EXT4_APPEND_FL | EXT4_IMMUTABLE_FL)) {
> +		if (!capable(CAP_LINUX_IMMUTABLE))
>   			goto flags_out;
> +	}
>
> -		oldflags = ei->i_flags;
> -
> -		/* The JOURNAL_DATA flag is modifiable only by root */
> -		jflag = flags & EXT4_JOURNAL_DATA_FL;
> -
> -		/*
> -		 * The IMMUTABLE and APPEND_ONLY flags can only be changed by
> -		 * the relevant capability.
> -		 *
> -		 * This test looks nicer. Thanks to Pauline Middelink
> -		 */
> -		if ((flags ^ oldflags) & (EXT4_APPEND_FL | EXT4_IMMUTABLE_FL)) {
> -			if (!capable(CAP_LINUX_IMMUTABLE))
> -				goto flags_out;
> -		}
> -
> -		/*
> -		 * The JOURNAL_DATA flag can only be changed by
> -		 * the relevant capability.
> -		 */
> -		if ((jflag ^ oldflags) & (EXT4_JOURNAL_DATA_FL)) {
> -			if (!capable(CAP_SYS_RESOURCE))
> -				goto flags_out;
> -		}
> -		if ((flags ^ oldflags) & EXT4_EXTENTS_FL)
> -			migrate = 1;
> -
> +	/*
> +	 * The JOURNAL_DATA flag can only be changed by
> +	 * the relevant capability.
> +	 */
> +	if ((jflag ^ oldflags) & (EXT4_JOURNAL_DATA_FL)) {
> +		if (!capable(CAP_SYS_RESOURCE))
> +			goto flags_out;
> +	}
> +	if ((flags ^ oldflags) & EXT4_EXTENTS_FL)
> +		migrate = 1;
>   		if (flags & EXT4_EOFBLOCKS_FL) {
> -			/* we don't support adding EOFBLOCKS flag */
> -			if (!(oldflags & EXT4_EOFBLOCKS_FL)) {
> -				err = -EOPNOTSUPP;
> -				goto flags_out;
> -			}
> -		} else if (oldflags & EXT4_EOFBLOCKS_FL)
> -			ext4_truncate(inode);
> -
> -		handle = ext4_journal_start(inode, EXT4_HT_INODE, 1);
> -		if (IS_ERR(handle)) {
> -			err = PTR_ERR(handle);
> +		/* we don't support adding EOFBLOCKS flag */
> +		if (!(oldflags & EXT4_EOFBLOCKS_FL)) {
> +			err = -EOPNOTSUPP;
>   			goto flags_out;
>   		}
> -		if (IS_SYNC(inode))
> -			ext4_handle_sync(handle);
> -		err = ext4_reserve_inode_write(handle, inode, &iloc);
> -		if (err)
> -			goto flags_err;
> -
> -		for (i = 0, mask = 1; i < 32; i++, mask <<= 1) {
> -			if (!(mask & EXT4_FL_USER_MODIFIABLE))
> -				continue;
> -			if (mask & flags)
> -				ext4_set_inode_flag(inode, i);
> -			else
> -				ext4_clear_inode_flag(inode, i);
> -		}
> +	} else if (oldflags & EXT4_EOFBLOCKS_FL)
> +		ext4_truncate(inode);
>
> -		ext4_set_inode_flags(inode);
> -		inode->i_ctime = ext4_current_time(inode);
> +	handle = ext4_journal_start(inode, EXT4_HT_INODE, 1);
> +	if (IS_ERR(handle)) {
> +		err = PTR_ERR(handle);
> +		goto flags_out;
> +	}
> +	if (IS_SYNC(inode))
> +		ext4_handle_sync(handle);
> +	err = ext4_reserve_inode_write(handle, inode, &iloc);
> +	if (err)
> +		goto flags_err;
> +
> +	for (i = 0, mask = 1; i < 32; i++, mask <<= 1) {
> +		if (!(mask & EXT4_FL_USER_MODIFIABLE))
> +			continue;
> +		if (mask & flags)
> +			ext4_set_inode_flag(inode, i);
> +		else
> +			ext4_clear_inode_flag(inode, i);
> +	}
>
> -		err = ext4_mark_iloc_dirty(handle, inode, &iloc);
> -flags_err:
> -		ext4_journal_stop(handle);
> -		if (err)
> -			goto flags_out;
> +	ext4_set_inode_flags(inode);
> +	inode->i_ctime = ext4_current_time(inode);
>
> -		if ((jflag ^ oldflags) & (EXT4_JOURNAL_DATA_FL))
> -			err = ext4_change_inode_journal_flag(inode, jflag);
> -		if (err)
> -			goto flags_out;
> -		if (migrate) {
> -			if (flags & EXT4_EXTENTS_FL)
> -				err = ext4_ext_migrate(inode);
> -			else
> -				err = ext4_ind_migrate(inode);
> -		}
> +	err = ext4_mark_iloc_dirty(handle, inode, &iloc);
> +flags_err:
> +	ext4_journal_stop(handle);
> +	if (err)
> +		goto flags_out;
> +
> +	if ((jflag ^ oldflags) & (EXT4_JOURNAL_DATA_FL))
> +		err = ext4_change_inode_journal_flag(inode, jflag);
> +	if (err)
> +		goto flags_out;
> +	if (migrate) {
> +		if (flags & EXT4_EXTENTS_FL)
> +			err = ext4_ext_migrate(inode);
> +		else
> +			err = ext4_ind_migrate(inode);
> +	}
>
>   flags_out:
> -		mutex_unlock(&inode->i_mutex);
> -		mnt_drop_write_file(filp);
> +	mutex_unlock(&inode->i_mutex);
> +	mnt_drop_write_file(filp);
> +	return err;
> +}
> +
> +static int ext4_ioctl_setproject(struct file *filp, __u32 projid)
> +{
> +	struct inode *inode = file_inode(filp);
> +	struct super_block *sb = inode->i_sb;
> +	struct ext4_inode_info *ei = EXT4_I(inode);
> +	int err;
> +	handle_t *handle;
> +	kprojid_t kprojid;
> +	struct ext4_iloc iloc;
> +	struct ext4_inode *raw_inode;
> +
> +	struct dquot *transfer_to[EXT4_MAXQUOTAS] = { };
> +
> +	/* Make sure caller can change project. */
> +	if (!capable(CAP_SYS_ADMIN))
> +		return -EACCES;
> +
> +	if (projid != EXT4_DEF_PROJID
> +	    && !EXT4_HAS_RO_COMPAT_FEATURE(sb,
> +			EXT4_FEATURE_RO_COMPAT_PROJECT))
> +		return -EOPNOTSUPP;
> +
> +	if (!EXT4_HAS_RO_COMPAT_FEATURE(sb,
> +			EXT4_FEATURE_RO_COMPAT_PROJECT)) {
> +		BUG_ON(__kprojid_val(EXT4_I(inode)->i_projid)
> +		       != EXT4_DEF_PROJID);
> +		if (projid != EXT4_DEF_PROJID)
> +			return -EOPNOTSUPP;
> +		else
> +			return 0;
> +	}
> +
> +	kprojid = make_kprojid(&init_user_ns, (projid_t)projid);

Maybe current_user_ns()?
This code should be user-namespace aware from the beginning.

> +
> +	if (projid_eq(kprojid, EXT4_I(inode)->i_projid))
> +		return 0;
> +
> +	err = mnt_want_write_file(filp);
> +	if (err)
>   		return err;
> +
> +	err = -EPERM;
> +	mutex_lock(&inode->i_mutex);
> +	/* Is it quota file? Do not allow user to mess with it */
> +	if (IS_NOQUOTA(inode))
> +		goto project_out;
> +
> +	dquot_initialize(inode);
> +
> +	handle = ext4_journal_start(inode, EXT4_HT_QUOTA,
> +		EXT4_QUOTA_INIT_BLOCKS(sb) +
> +		EXT4_QUOTA_DEL_BLOCKS(sb) + 3);
> +	if (IS_ERR(handle)) {
> +		err = PTR_ERR(handle);
> +		goto project_out;
> +	}
> +
> +	err = ext4_reserve_inode_write(handle, inode, &iloc);
> +	if (err)
> +		goto project_stop;
> +
> +	raw_inode = ext4_raw_inode(&iloc);
> +	if ((EXT4_INODE_SIZE(sb) <=
> +	     EXT4_GOOD_OLD_INODE_SIZE) ||
> +	    (!EXT4_FITS_IN_INODE(raw_inode, ei, i_projid))) {
> +	    	err = -EFBIG;
> +	    	goto project_stop;
>   	}
> +
> +	transfer_to[PRJQUOTA] = dqget(sb, make_kqid_projid(kprojid));
> +	if (!transfer_to[PRJQUOTA])
> +		goto project_set;
> +
> +	err = __dquot_transfer(inode, transfer_to);
> +	dqput(transfer_to[PRJQUOTA]);
> +	if (err)
> +		goto project_stop;
> +
> +project_set:
> +	EXT4_I(inode)->i_projid = kprojid;
> +	inode->i_ctime = ext4_current_time(inode);
> +	err = ext4_mark_iloc_dirty(handle, inode, &iloc);
> +project_stop:
> +	ext4_journal_stop(handle);
> +project_out:
> +	mutex_unlock(&inode->i_mutex);
> +	mnt_drop_write_file(filp);
> +	return err;
> +}
> +
> +long ext4_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
> +{
> +	struct inode *inode = file_inode(filp);
> +	struct super_block *sb = inode->i_sb;
> +	struct ext4_inode_info *ei = EXT4_I(inode);
> +	unsigned int flags;
> +
> +	ext4_debug("cmd = %u, arg = %lu\n", cmd, arg);
> +
> +	switch (cmd) {
> +	case EXT4_IOC_GETFLAGS:
> +		ext4_get_inode_flags(ei);
> +		flags = ei->i_flags & EXT4_FL_USER_VISIBLE;
> +		return put_user(flags, (int __user *) arg);
> +	case EXT4_IOC_SETFLAGS:
> +		if (get_user(flags, (int __user *) arg))
> +			return -EFAULT;
> +		return ext4_ioctl_setflags(filp, flags);
>   	case EXT4_IOC_GETVERSION:
>   	case EXT4_IOC_GETVERSION_OLD:
>   		return put_user(inode->i_generation, (int __user *) arg);
> @@ -615,7 +711,45 @@ resizefs_out:
>   	}
>   	case EXT4_IOC_PRECACHE_EXTENTS:
>   		return ext4_ext_precache(inode);
> +	case EXT4_IOC_FSGETXATTR:
> +	{
> +		struct fsxattr fa;
> +
> +		memset(&fa, 0, sizeof(struct fsxattr));
> +
> +		ext4_get_inode_flags(ei);
> +		fa.fsx_xflags = ext4_iflags_to_xflags(ei->i_flags & EXT4_FL_USER_VISIBLE);
> +
> +		if (EXT4_HAS_RO_COMPAT_FEATURE(inode->i_sb,
> +				EXT4_FEATURE_RO_COMPAT_PROJECT)) {
> +			fa.fsx_projid = (__u32)from_kprojid(&init_user_ns,
> +				EXT4_I(inode)->i_projid);

Same here.

> +		}
> +
> +		if (copy_to_user((struct fsxattr __user *)arg,
> +				 &fa, sizeof(fa)))
> +			return -EFAULT;
> +		return 0;
> +	}
> +	case EXT4_IOC_FSSETXATTR:
> +	{
> +		struct fsxattr fa;
> +		int err;
> +
> +		if (copy_from_user(&fa, (struct fsxattr __user *)arg,
> +				   sizeof(fa)))
> +			return -EFAULT;
>
> +		err = ext4_ioctl_setflags(filp, ext4_xflags_to_iflags(fa.fsx_xflags));
> +		if (err)
> +			return err;
> +
> +		err = ext4_ioctl_setproject(filp, fa.fsx_projid);
> +		if (err)
> +			return err;
> +
> +		return 0;
> +	}
>   	default:
>   		return -ENOTTY;
>   	}
> diff --git a/fs/xfs/xfs_fs.h b/fs/xfs/xfs_fs.h
> index 18dc721..64c7ae6 100644
> --- a/fs/xfs/xfs_fs.h
> +++ b/fs/xfs/xfs_fs.h
> @@ -36,38 +36,25 @@ struct dioattr {
>   #endif
>
>   /*
> - * Structure for XFS_IOC_FSGETXATTR[A] and XFS_IOC_FSSETXATTR.
> - */
> -#ifndef HAVE_FSXATTR
> -struct fsxattr {
> -	__u32		fsx_xflags;	/* xflags field value (get/set) */
> -	__u32		fsx_extsize;	/* extsize field value (get/set)*/
> -	__u32		fsx_nextents;	/* nextents field value (get)	*/
> -	__u32		fsx_projid;	/* project identifier (get/set) */
> -	unsigned char	fsx_pad[12];
> -};
> -#endif
> -
> -/*
>    * Flags for the bs_xflags/fsx_xflags field
>    * There should be a one-to-one correspondence between these flags and the
>    * XFS_DIFLAG_s.
>    */
> -#define XFS_XFLAG_REALTIME	0x00000001	/* data in realtime volume */
> -#define XFS_XFLAG_PREALLOC	0x00000002	/* preallocated file extents */
> -#define XFS_XFLAG_IMMUTABLE	0x00000008	/* file cannot be modified */
> -#define XFS_XFLAG_APPEND	0x00000010	/* all writes append */
> -#define XFS_XFLAG_SYNC		0x00000020	/* all writes synchronous */
> -#define XFS_XFLAG_NOATIME	0x00000040	/* do not update access time */
> -#define XFS_XFLAG_NODUMP	0x00000080	/* do not include in backups */
> -#define XFS_XFLAG_RTINHERIT	0x00000100	/* create with rt bit set */
> -#define XFS_XFLAG_PROJINHERIT	0x00000200	/* create with parents projid */
> -#define XFS_XFLAG_NOSYMLINKS	0x00000400	/* disallow symlink creation */
> -#define XFS_XFLAG_EXTSIZE	0x00000800	/* extent size allocator hint */
> -#define XFS_XFLAG_EXTSZINHERIT	0x00001000	/* inherit inode extent size */
> -#define XFS_XFLAG_NODEFRAG	0x00002000  	/* do not defragment */
> -#define XFS_XFLAG_FILESTREAM	0x00004000	/* use filestream allocator */
> -#define XFS_XFLAG_HASATTR	0x80000000	/* no DIFLAG for this	*/
> +#define XFS_XFLAG_REALTIME	FS_XFLAG_REALTIME	/* data in realtime volume */
> +#define XFS_XFLAG_PREALLOC	FS_XFLAG_PREALLOC	/* preallocated file extents */
> +#define XFS_XFLAG_IMMUTABLE	FS_XFLAG_IMMUTABLE	/* file cannot be modified */
> +#define XFS_XFLAG_APPEND	FS_XFLAG_APPEND		/* all writes append */
> +#define XFS_XFLAG_SYNC		FS_XFLAG_SYNC		/* all writes synchronous */
> +#define XFS_XFLAG_NOATIME	FS_XFLAG_NOATIME	/* do not update access time */
> +#define XFS_XFLAG_NODUMP	FS_XFLAG_NODUMP		/* do not include in backups */
> +#define XFS_XFLAG_RTINHERIT	FS_XFLAG_RTINHERIT	/* create with rt bit set */
> +#define XFS_XFLAG_PROJINHERIT	FS_XFLAG_PROJINHERIT	/* create with parents projid */
> +#define XFS_XFLAG_NOSYMLINKS	FS_XFLAG_NOSYMLINKS	/* disallow symlink creation */
> +#define XFS_XFLAG_EXTSIZE	FS_XFLAG_EXTSIZE	/* extent size allocator hint */
> +#define XFS_XFLAG_EXTSZINHERIT	FS_XFLAG_EXTSZINHERIT	/* inherit inode extent size */
> +#define XFS_XFLAG_NODEFRAG	FS_XFLAG_NODEFRAG  	/* do not defragment */
> +#define XFS_XFLAG_FILESTREAM	FS_XFLAG_FILESTREAM	/* use filestream allocator */
> +#define XFS_XFLAG_HASATTR	FS_XFLAG_HASATTR	/* no DIFLAG for this	*/
>
>   /*
>    * Structure for XFS_IOC_GETBMAP.
> @@ -503,8 +490,8 @@ typedef struct xfs_swapext
>   #define XFS_IOC_ALLOCSP		_IOW ('X', 10, struct xfs_flock64)
>   #define XFS_IOC_FREESP		_IOW ('X', 11, struct xfs_flock64)
>   #define XFS_IOC_DIOINFO		_IOR ('X', 30, struct dioattr)
> -#define XFS_IOC_FSGETXATTR	_IOR ('X', 31, struct fsxattr)
> -#define XFS_IOC_FSSETXATTR	_IOW ('X', 32, struct fsxattr)
> +#define XFS_IOC_FSGETXATTR	FS_IOC_FSGETXATTR
> +#define XFS_IOC_FSSETXATTR	FS_IOC_FSSETXATTR
>   #define XFS_IOC_ALLOCSP64	_IOW ('X', 36, struct xfs_flock64)
>   #define XFS_IOC_FREESP64	_IOW ('X', 37, struct xfs_flock64)
>   #define XFS_IOC_GETBMAP		_IOWR('X', 38, struct getbmap)
> diff --git a/include/uapi/linux/fs.h b/include/uapi/linux/fs.h
> index fcbf647..872fed5 100644
> --- a/include/uapi/linux/fs.h
> +++ b/include/uapi/linux/fs.h
> @@ -58,6 +58,62 @@ struct inodes_stat_t {
>   	long dummy[5];		/* padding for sysctl ABI compatibility */
>   };
>
> +/*
> + * Extend attribute flags. These should be or-ed together to figure out what
> + * is valid.
> + */
> +#define FSX_XFLAGS	(1 << 0)
> +#define FSX_EXTSIZE	(1 << 1)
> +#define FSX_NEXTENTS	(1 << 2)
> +#define FSX_PROJID	(1 << 3)
> +
> +/*
> + * Structure for FS_IOC_FSGETXATTR and FS_IOC_FSSETXATTR.
> + */
> +struct fsxattr {
> +	__u32		fsx_xflags;	/* xflags field value (get/set) */
> +	__u32		fsx_extsize;	/* extsize field value (get/set)*/
> +	__u32		fsx_nextents;	/* nextents field value (get)	*/
> +	__u32		fsx_projid;	/* project identifier (get/set) */
> +	unsigned char	fsx_pad[12];
> +};
> +
> +/*
> + * Flags for the fsx_xflags field
> + */
> +#define FS_XFLAG_REALTIME	0x00000001	/* data in realtime volume */
> +#define FS_XFLAG_PREALLOC	0x00000002	/* preallocated file extents */
> +#define FS_XFLAG_SECRM		0x00000004	/* secure deletion */
> +#define FS_XFLAG_IMMUTABLE	0x00000008	/* file cannot be modified */
> +#define FS_XFLAG_APPEND		0x00000010	/* all writes append */
> +#define FS_XFLAG_SYNC		0x00000020	/* all writes synchronous */
> +#define FS_XFLAG_NOATIME	0x00000040	/* do not update access time */
> +#define FS_XFLAG_NODUMP		0x00000080	/* do not include in backups */
> +#define FS_XFLAG_RTINHERIT	0x00000100	/* create with rt bit set */
> +#define FS_XFLAG_PROJINHERIT	0x00000200	/* create with parents projid */
> +#define FS_XFLAG_NOSYMLINKS	0x00000400	/* disallow symlink creation */
> +#define FS_XFLAG_EXTSIZE	0x00000800	/* extent size allocator hint */
> +#define FS_XFLAG_EXTSZINHERIT	0x00001000	/* inherit inode extent size */
> +#define FS_XFLAG_NODEFRAG	0x00002000  	/* do not defragment */
> +#define FS_XFLAG_FILESTREAM	0x00004000	/* use filestream allocator */
> +#define FS_XFLAG_UNRM		0x00008000	/* undelete */
> +#define FS_XFLAG_COMPR		0x00010000	/* compress file */
> +#define FS_XFLAG_COMPRBLK	0x00020000	/* one or more compressed clusters */
> +#define FS_XFLAG_NOCOMPR	0x00040000	/* don't compress */
> +#define FS_XFLAG_ECOMPR		0x00080000	/* compression error */
> +#define FS_XFLAG_INDEX		0x00100000	/* hash-indexed directory */
> +#define FS_XFLAG_IMAGIC		0x00200000	/* AFS directory */
> +#define FS_XFLAG_JOURNAL_DATA	0x00400000	/* file data should be journaled */
> +#define FS_XFLAG_NOTAIL		0x00800000	/* file tail should not be merged */
> +#define FS_XFLAG_DIRSYNC	0x01000000	/* dirsync behaviour (directories only) */
> +#define FS_XFLAG_TOPDIR		0x02000000	/* top of directory hierarchies*/
> +#define FS_XFLAG_HUGE_FILE	0x04000000	/* set to each huge file */
> +#define FS_XFLAG_EXTENTS	0x08000000	/* inode uses extents */
> +#define FS_XFLAG_EA_INODE	0x10000000	/* inode used for large EA */
> +#define FS_XFLAG_EOFBLOCKS	0x20000000	/* blocks allocated beyond EOF */
> +#define FS_XFLAG_INLINE_DATA	0x40000000	/* inode has inline data. */
> +#define FS_XFLAG_HASATTR	0x80000000	/* no DIFLAG for this */
> +
>
>   #define NR_FILE  8192	/* this can well be larger on a larger system */
>
> @@ -163,6 +219,8 @@ struct inodes_stat_t {
>   #define	FS_IOC_GETVERSION		_IOR('v', 1, long)
>   #define	FS_IOC_SETVERSION		_IOW('v', 2, long)
>   #define FS_IOC_FIEMAP			_IOWR('f', 11, struct fiemap)
> +#define FS_IOC_FSGETXATTR		_IOR('f', 31, struct fsxattr)
> +#define FS_IOC_FSSETXATTR		_IOW('f', 32, struct fsxattr)
>   #define FS_IOC32_GETFLAGS		_IOR('f', 1, int)
>   #define FS_IOC32_SETFLAGS		_IOW('f', 2, int)
>   #define FS_IOC32_GETVERSION		_IOR('v', 1, int)
>

