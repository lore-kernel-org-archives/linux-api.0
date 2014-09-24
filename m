From: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH 4/4] Adds ioctl interface support for ext4 project
Date: Wed, 24 Sep 2014 18:43:05 +0200
Message-ID: <20140924164305.GD27000@quack.suse.cz>
References: <1411567470-31799-1-git-send-email-lixi@ddn.com>
 <1411567470-31799-5-git-send-email-lixi@ddn.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1411567470-31799-5-git-send-email-lixi-LfVdkaOWEx8@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Li Xi <pkuelelixi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tytso-3s7WtUTddSA@public.gmane.org, adilger-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org, jack-AlSwsSmVLrQ@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, dmonakhov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Wed 24-09-14 22:04:30, Li Xi wrote:
> This patch adds ioctl interface for setting/getting project of ext4.
  One more thing...

> Signed-off-by: Li Xi <lixi-LfVdkaOWEx8@public.gmane.org>
> ---
>  Documentation/filesystems/ext4.txt |    4 ++
>  fs/ext4/ext4.h                     |    2 +
>  fs/ext4/ioctl.c                    |   85 ++++++++++++++++++++++++++++++++++++
>  3 files changed, 91 insertions(+), 0 deletions(-)
> 
> +	case EXT4_IOC_SETPROJECT:
> +	{
> +		__u32 projid;
> +		int err;
> +		handle_t *handle;
> +		kprojid_t kprojid;
> +		struct ext4_iloc iloc;
> +		struct ext4_inode *raw_inode;
> +
> +		struct dquot *transfer_to[EXT4_MAXQUOTAS] = { };
> +
> +		/* Make sure caller can change project. */
> +		if (!capable(CAP_SYS_ADMIN))
> +			return -EACCES;
  I realized you forgot to check EXT4_FEATURE_RO_COMPAT_PROJECT here...

								Honza

> +
> +		if (get_user(projid, (__u32 __user *) arg))
> +			return -EFAULT;
> +
> +		kprojid = make_kprojid(&init_user_ns, (projid_t)projid);
> +
> +		if (projid_eq(kprojid, EXT4_I(inode)->i_projid))
> +			return 0;
> +
> +		err = mnt_want_write_file(filp);
> +		if (err)
> +			return err;
> +
> +		err = -EPERM;
> +		mutex_lock(&inode->i_mutex);
> +		/* Is it quota file? Do not allow user to mess with it */
> +		if (IS_NOQUOTA(inode))
> +			goto project_out;
> +
> +		dquot_initialize(inode);
> +
> +		handle = ext4_journal_start(inode, EXT4_HT_QUOTA,
> +			EXT4_QUOTA_INIT_BLOCKS(sb) +
> +			EXT4_QUOTA_DEL_BLOCKS(sb) + 3);
> +		if (IS_ERR(handle)) {
> +			err = PTR_ERR(handle);
> +			goto project_out;
> +		}
> +
> +		err = ext4_reserve_inode_write(handle, inode, &iloc);
> +		if (err)
> +			goto project_stop;
> +
> +		raw_inode = ext4_raw_inode(&iloc);
> +		if ((EXT4_INODE_SIZE(inode->i_sb) <=
> +		     EXT4_GOOD_OLD_INODE_SIZE) ||
> +		    (!EXT4_FITS_IN_INODE(raw_inode, ei, i_projid))) {
> +		    	err = -EFBIG;
> +		    	goto project_stop;
> +		}
> +
> +		transfer_to[PRJQUOTA] = dqget(sb, make_kqid_projid(kprojid));
> +		if (!transfer_to[PRJQUOTA])
> +			goto project_set;
> +
> +		err = __dquot_transfer(inode, transfer_to);
> +		dqput(transfer_to[PRJQUOTA]);
> +		if (err)
> +			goto project_stop;
> +
> +project_set:
> +		EXT4_I(inode)->i_projid = kprojid;
> +		inode->i_ctime = ext4_current_time(inode);
> +		err = ext4_mark_iloc_dirty(handle, inode, &iloc);
> +project_stop:
> +		ext4_journal_stop(handle);
> +project_out:
> +		mutex_unlock(&inode->i_mutex);
> +		mnt_drop_write_file(filp);
> +		return err;
> +	}
>  	default:
>  		return -ENOTTY;
>  	}
> -- 
> 1.7.1
> 
-- 
Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
SUSE Labs, CR
