From: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [v9 4/5] ext4: adds FS_IOC_FSSETXATTR/FS_IOC_FSGETXATTR
 interface support
Date: Mon, 16 Mar 2015 16:26:51 +0100
Message-ID: <20150316152651.GQ4934@quack.suse.cz>
References: <1426043003-31043-1-git-send-email-lixi@ddn.com>
 <1426043003-31043-5-git-send-email-lixi@ddn.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1426043003-31043-5-git-send-email-lixi-LfVdkaOWEx8@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Li Xi <pkuelelixi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tytso-3s7WtUTddSA@public.gmane.org, adilger-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org, jack-AlSwsSmVLrQ@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, dmonakhov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Wed 11-03-15 12:03:22, Li Xi wrote:
> This patch adds FS_IOC_FSSETXATTR/FS_IOC_FSGETXATTR ioctl interface
> support for ext4. The interface is kept consistent with
> XFS_IOC_FSGETXATTR/XFS_IOC_FSGETXATTR.
  Thanks for the patch! I think we are getting to a working solution :) Apart
from the bug Konstantin pointed out, I have a few comments below.
 
> Signed-off-by: Li Xi <lixi-LfVdkaOWEx8@public.gmane.org>
> ---
>  fs/ext4/ext4.h          |   47 +++++++
>  fs/ext4/ioctl.c         |  341 +++++++++++++++++++++++++++++++++--------------
>  fs/xfs/xfs_fs.h         |   47 +++----
>  include/uapi/linux/fs.h |   32 +++++
>  4 files changed, 338 insertions(+), 129 deletions(-)
> 
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index 3443456..2f4b9ba 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -385,6 +385,51 @@ struct flex_groups {
>  #define EXT4_FL_USER_VISIBLE		0x204BDFFF /* User visible flags */
>  #define EXT4_FL_USER_MODIFIABLE		0x204380FF /* User modifiable flags */
>  
> +#define EXT4_FL_XFLAG_VISIBLE		(EXT4_SYNC_FL | \
> +					 EXT4_IMMUTABLE_FL | \
> +					 EXT4_APPEND_FL | \
> +					 EXT4_NOATIME_FL | \
> +					 EXT4_PROJINHERIT_FL)
> +
> +/* Transfer internal flags to xflags */
> +static inline __u32 ext4_iflags_to_xflags(unsigned long iflags)
> +{
> +	__u32 xflags = 0;
> +
> +	if (iflags & EXT4_SYNC_FL)
> +		xflags |= FS_XFLAG_SYNC;
> +	if (iflags & EXT4_IMMUTABLE_FL)
> +		xflags |= FS_XFLAG_IMMUTABLE;
> +	if (iflags & EXT4_APPEND_FL)
> +		xflags |= FS_XFLAG_APPEND;
> +	if (iflags & EXT4_NOATIME_FL)
> +		xflags |= FS_XFLAG_NOATIME;
> +	if (iflags & EXT4_PROJINHERIT_FL)
> +		xflags |= FS_XFLAG_PROJINHERIT;
> +	return xflags;
> +}
  I think EXT4_NODUMP_FL is missing in EXT4_FL_XFLAG_VISIBLE and isn't
handled in ext4_iflags_to_xflags().

> +/* Transfer xflags flags to internal */
> +static inline unsigned long ext4_xflags_to_iflags(__u32 xflags)
> +{
> +	unsigned long iflags = 0;
> +
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
> +	if (xflags & FS_XFLAG_PROJINHERIT)
> +		iflags |= EXT4_PROJINHERIT_FL;
> +
> +	return iflags;
> +}
  These two functions are only used in fs/ext4/ioctl.c. So just move their
definition there.

...
> diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
> index f58a0d1..20a6337 100644
> --- a/fs/ext4/ioctl.c
> +++ b/fs/ext4/ioctl.c
> @@ -14,6 +14,8 @@
>  #include <linux/compat.h>
>  #include <linux/mount.h>
>  #include <linux/file.h>
> +#include <linux/quotaops.h>
> +#include <linux/quota.h>
>  #include <asm/uaccess.h>
>  #include "ext4_jbd2.h"
>  #include "ext4.h"
> @@ -196,126 +198,229 @@ journal_err_out:
>  	return err;
>  }
>  
> -long ext4_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
> +static int ext4_ioctl_setflags(struct file *filp,
> +			       unsigned int flags, int is_from_xflags)
>  {
  Hum, I think we can get rid of the is_from_xflags argument. As I'm
looking into the code below the only real reason why we have is_from_xflags
is that we need to compare old value of flags against new value of flags
and see what has changed. So what we can do is that FSSETXATTR ioctl will
construct flags to pass to ext4_ioctl_setflags() like:
	flags = (ei->i_flags & ~EXT4_FL_XFLAG_VISIBLE) |
		(flags & EXT4_FL_XFLAG_VISIBLE);

That way we don't change any flags outside of EXT4_FL_XFLAG_VISIBLE and
ext4_ioctl_setflags() doesn't have to be aware about different callers. The
only downside is that we need to hold i_mutex to reliably create 'flags'
value which requires moving mnt_want_write_file() and
mutex_lock(&inode->i_mutex) into the caller but that's pretty simple.

>  	struct inode *inode = file_inode(filp);
> -	struct super_block *sb = inode->i_sb;
>  	struct ext4_inode_info *ei = EXT4_I(inode);
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
> +	if (is_from_xflags)
> +		flags &= EXT4_FL_XFLAG_VISIBLE;
> +
> +	err = -EPERM;
> +	mutex_lock(&inode->i_mutex);
> +	/* Is it quota file? Do not allow user to mess with it */
> +	if (IS_NOQUOTA(inode))
> +		goto flags_out;
> +
> +	oldflags = ei->i_flags;
> +	if (is_from_xflags)
> +		oldflags &= EXT4_FL_XFLAG_VISIBLE;
> +
> +	/* The JOURNAL_DATA flag is modifiable only by root */
> +	jflag = flags & EXT4_JOURNAL_DATA_FL;
> +	if (is_from_xflags)
> +		jflag &= EXT4_FL_XFLAG_VISIBLE;
> +
> +	/*
> +	 * The IMMUTABLE and APPEND_ONLY flags can only be changed by
> +	 * the relevant capability.
> +	 *
> +	 * This test looks nicer. Thanks to Pauline Middelink
> +	 */
> +	if ((flags ^ oldflags) & (EXT4_APPEND_FL | EXT4_IMMUTABLE_FL)) {
> +		if (!capable(CAP_LINUX_IMMUTABLE))
> +			goto flags_out;
> +	}
>  
> -		if (get_user(flags, (int __user *) arg))
> -			return -EFAULT;
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
> +		if (flags & EXT4_EOFBLOCKS_FL) {
> +		/* we don't support adding EOFBLOCKS flag */
> +		if (!(oldflags & EXT4_EOFBLOCKS_FL)) {
> +			err = -EOPNOTSUPP;
> +			goto flags_out;
> +		}
> +	} else if (oldflags & EXT4_EOFBLOCKS_FL)
> +		ext4_truncate(inode);
>  
> -		err = mnt_want_write_file(filp);
> -		if (err)
> -			return err;
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
> +		if (is_from_xflags && !(mask & EXT4_FL_XFLAG_VISIBLE))
> +			continue;
> +		if (mask & flags)
> +			ext4_set_inode_flag(inode, i);
> +		else
> +			ext4_clear_inode_flag(inode, i);
> +	}
>  
> -		flags = ext4_mask_flags(inode->i_mode, flags);
> +	ext4_set_inode_flags(inode);
> +	inode->i_ctime = ext4_current_time(inode);
>  
> -		err = -EPERM;
> -		mutex_lock(&inode->i_mutex);
> -		/* Is it quota file? Do not allow user to mess with it */
> -		if (IS_NOQUOTA(inode))
> -			goto flags_out;
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
> -		oldflags = ei->i_flags;
> +flags_out:
> +	mutex_unlock(&inode->i_mutex);
> +	mnt_drop_write_file(filp);
> +	return err;
> +}
>  
> -		/* The JOURNAL_DATA flag is modifiable only by root */
> -		jflag = flags & EXT4_JOURNAL_DATA_FL;
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
  Why is the test here twice? The first one seems to be redundant...

								Honza
-- 
Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
SUSE Labs, CR
