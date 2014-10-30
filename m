From: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [v5 2/5] Adds project ID support for ext4
Date: Thu, 30 Oct 2014 17:18:15 +0100
Message-ID: <20141030161815.GH28444@quack.suse.cz>
References: <1414300973-1118-1-git-send-email-lixi@ddn.com>
 <1414300973-1118-3-git-send-email-lixi@ddn.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1414300973-1118-3-git-send-email-lixi-LfVdkaOWEx8@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Li Xi <pkuelelixi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tytso-3s7WtUTddSA@public.gmane.org, adilger-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org, jack-AlSwsSmVLrQ@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, dmonakhov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Sun 26-10-14 13:22:50, Li Xi wrote:
> This patch adds a new internal field of ext4 inode to save project
> identifier. Also a new flag EXT4_INODE_PROJINHERIT is added for
> inheriting project ID from parent directory.
  The patch looks good. You can add:
Reviewed-by: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>

  Just a few formatting issues below:

> diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
> index 8012a5d..78a2775 100644
> --- a/fs/ext4/ialloc.c
> +++ b/fs/ext4/ialloc.c
> @@ -756,6 +756,14 @@ struct inode *__ext4_new_inode(handle_t *handle, struct inode *dir,
>  		inode->i_gid = dir->i_gid;
>  	} else
>  		inode_init_owner(inode, dir, mode);
> +	if (EXT4_HAS_RO_COMPAT_FEATURE(sb,
> +		EXT4_FEATURE_RO_COMPAT_PROJECT) &&
  This looks like excessive line wrapping. You can merge the above two
lines...

> +	    ext4_test_inode_flag(dir, EXT4_INODE_PROJINHERIT)) {
> +		ei->i_projid = EXT4_I(dir)->i_projid;
> +	} else {
> +		ei->i_projid =
> +			make_kprojid(&init_user_ns, EXT4_DEF_PROJID);
  And here as well.

> +	}
>  	dquot_initialize(inode);
>  
>  	if (!goal)
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index e9777f9..ab3bd51 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -3886,6 +3886,15 @@ static inline void ext4_iget_extra_inode(struct inode *inode,
>  		EXT4_I(inode)->i_inline_off = 0;
>  }
>  
> +int ext4_get_projid(struct inode *inode, kprojid_t *projid)
> +{
> +	if (!EXT4_HAS_RO_COMPAT_FEATURE(inode->i_sb,
> +			EXT4_FEATURE_RO_COMPAT_PROJECT))
  And here as well...

> +		return -EOPNOTSUPP;
> +	*projid = EXT4_I(inode)->i_projid;
> +	return 0;
> +}
> +
>  struct inode *ext4_iget(struct super_block *sb, unsigned long ino)
>  {
>  	struct ext4_iloc iloc;
> @@ -3897,6 +3906,7 @@ struct inode *ext4_iget(struct super_block *sb, unsigned long ino)
>  	int block;
>  	uid_t i_uid;
>  	gid_t i_gid;
> +	projid_t i_projid;
>  
>  	inode = iget_locked(sb, ino);
>  	if (!inode)
> @@ -3946,12 +3956,19 @@ struct inode *ext4_iget(struct super_block *sb, unsigned long ino)
>  	inode->i_mode = le16_to_cpu(raw_inode->i_mode);
>  	i_uid = (uid_t)le16_to_cpu(raw_inode->i_uid_low);
>  	i_gid = (gid_t)le16_to_cpu(raw_inode->i_gid_low);
> +	if (EXT4_HAS_RO_COMPAT_FEATURE(sb,
> +			EXT4_FEATURE_RO_COMPAT_PROJECT))
  And here...

> +		i_projid = (projid_t)le32_to_cpu(raw_inode->i_projid);
> +	else
> +		i_projid = EXT4_DEF_PROJID;
> +
>  	if (!(test_opt(inode->i_sb, NO_UID32))) {
>  		i_uid |= le16_to_cpu(raw_inode->i_uid_high) << 16;
>  		i_gid |= le16_to_cpu(raw_inode->i_gid_high) << 16;
>  	}
>  	i_uid_write(inode, i_uid);
>  	i_gid_write(inode, i_gid);
> +	ei->i_projid = make_kprojid(&init_user_ns, i_projid);;
>  	set_nlink(inode, le16_to_cpu(raw_inode->i_links_count));
>  
>  	ext4_clear_state_flags(ei);	/* Only relevant on 32-bit archs */
...
> diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
> index 61756f9..3229604 100644
> --- a/fs/ext4/namei.c
> +++ b/fs/ext4/namei.c
> @@ -2931,6 +2931,11 @@ static int ext4_link(struct dentry *old_dentry,
>  	if (inode->i_nlink >= EXT4_LINK_MAX)
>  		return -EMLINK;
>  
> +	if ((ext4_test_inode_flag(dir, EXT4_INODE_PROJINHERIT)) &&
> +	    (!projid_eq(EXT4_I(dir)->i_projid,
> +			EXT4_I(old_dentry->d_inode)->i_projid)))
> +		return -EXDEV;
> +
>  	dquot_initialize(dir);
>  
>  retry:
> @@ -3173,6 +3178,11 @@ static int ext4_rename(struct inode *old_dir, struct dentry *old_dentry,
>  	int force_reread;
>  	int retval;
>  
> +	if ((ext4_test_inode_flag(new_dir, EXT4_INODE_PROJINHERIT)) &&
> +	    (!projid_eq(EXT4_I(new_dir)->i_projid,
> +		EXT4_I(old_dentry->d_inode)->i_projid)))
  The above line is wrongly indented. Move it one tab more to the right.

								Honza
-- 
Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
SUSE Labs, CR
