From: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [v9 2/5] ext4: adds project ID support
Date: Mon, 16 Mar 2015 15:37:56 +0100
Message-ID: <20150316143756.GO4934@quack.suse.cz>
References: <1426043003-31043-1-git-send-email-lixi@ddn.com>
 <1426043003-31043-3-git-send-email-lixi@ddn.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1426043003-31043-3-git-send-email-lixi-LfVdkaOWEx8@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Li Xi <pkuelelixi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tytso-3s7WtUTddSA@public.gmane.org, adilger-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org, jack-AlSwsSmVLrQ@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, dmonakhov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Wed 11-03-15 12:03:20, Li Xi wrote:
> This patch adds a new internal field of ext4 inode to save project
> identifier. Also a new flag EXT4_INODE_PROJINHERIT is added for
> inheriting project ID from parent directory.
> 
> Signed-off-by: Li Xi <lixi-LfVdkaOWEx8@public.gmane.org>
> Reviewed-by: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
...
> @@ -3395,6 +3405,13 @@ static int ext4_cross_rename(struct inode *old_dir, struct dentry *old_dentry,
>  	u8 new_file_type;
>  	int retval;
>  
> +	if ((ext4_test_inode_flag(new_dir, EXT4_INODE_PROJINHERIT)) &&
> +	    ((!projid_eq(EXT4_I(new_dir)->i_projid,
> +			 EXT4_I(old_dentry->d_inode)->i_projid)) ||
> +	     (!projid_eq(EXT4_I(old_dir)->i_projid,
> +			 EXT4_I(new_dentry->d_inode)->i_projid))))
> +		return -EXDEV;
> +
  I believe this needs to also check EXT4_INODE_PROJINHERIT on old_dir. So
something like:
	if ((ext4_test_inode_flag(new_dir, EXT4_INODE_PROJINHERIT) &&
	     !projid_eq(EXT4_I(new_dir)->i_projid,
			 EXT4_I(old_dentry->d_inode)->i_projid)) ||
	    (ext4_test_inode_flag(old_dir, EXT4_INODE_PROJINHERIT) &&
	     !projid_eq(EXT4_I(old_dir)->i_projid,
			 EXT4_I(new_dentry->d_inode)->i_projid)))
		return -EXDEV;

								Honza
-- 
Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
SUSE Labs, CR
