From: Jan Kara <jack@suse.cz>
Subject: Re: [v10 4/5] ext4: adds FS_IOC_FSSETXATTR/FS_IOC_FSGETXATTR
 interface support
Date: Thu, 19 Mar 2015 10:56:34 +0100
Message-ID: <20150319095634.GF28368@quack.suse.cz>
References: <1426705497-22158-1-git-send-email-lixi@ddn.com>
 <1426705497-22158-5-git-send-email-lixi@ddn.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1426705497-22158-5-git-send-email-lixi@ddn.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Li Xi <pkuelelixi@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, linux-api@vger.kernel.org, tytso@mit.edu, adilger@dilger.ca, jack@suse.cz, viro@zeniv.linux.org.uk, hch@infradead.org, dmonakhov@openvz.org
List-Id: linux-api@vger.kernel.org

On Thu 19-03-15 04:04:56, Li Xi wrote:
> This patch adds FS_IOC_FSSETXATTR/FS_IOC_FSGETXATTR ioctl interface
> support for ext4. The interface is kept consistent with
> XFS_IOC_FSGETXATTR/XFS_IOC_FSGETXATTR.
  Two more comments below.

> 
> Signed-off-by: Li Xi <lixi@ddn.com>
...
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
  Why do you test capabilities here when you already test permission in
EXT4_IOC_FSSETXATTR? Furthermore this test is too restrictive. Just delete
it.

...
> -flags_out:
> +		err = ext4_ioctl_setflags(inode, flags);
>  		mutex_unlock(&inode->i_mutex);
> -		mnt_drop_write_file(filp);
> +		mnt_drop_write(filp->f_path.mnt);
  Why did you change this? mnt_drop_write_file() should stay here.

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
