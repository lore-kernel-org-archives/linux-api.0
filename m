From: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH 3/4] Adds project quota support for ext4
Date: Wed, 24 Sep 2014 19:31:23 +0200
Message-ID: <20140924173123.GH27000@quack.suse.cz>
References: <1411567470-31799-1-git-send-email-lixi@ddn.com>
 <1411567470-31799-4-git-send-email-lixi@ddn.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1411567470-31799-4-git-send-email-lixi-LfVdkaOWEx8@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Li Xi <pkuelelixi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tytso-3s7WtUTddSA@public.gmane.org, adilger-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org, jack-AlSwsSmVLrQ@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, dmonakhov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Wed 24-09-14 22:04:29, Li Xi wrote:
> This patch adds mount options for enabling/disabling project quota
> accounting and enforcement. A new specific inode is also used for
> project quota accounting.
  The patch looks mostly fine. A few smaller things below.

...
> @@ -1433,6 +1437,8 @@ static const struct mount_opts {
>  							MOPT_SET | MOPT_Q},
>  	{Opt_grpquota, EXT4_MOUNT_QUOTA | EXT4_MOUNT_GRPQUOTA,
>  							MOPT_SET | MOPT_Q},
> +	{Opt_prjquota, EXT4_MOUNT_QUOTA | EXT4_MOUNT_PRJQUOTA,
> +							MOPT_SET | MOPT_Q},
>  	{Opt_noquota, (EXT4_MOUNT_QUOTA | EXT4_MOUNT_USRQUOTA |
>  		       EXT4_MOUNT_GRPQUOTA), MOPT_CLEAR | MOPT_Q},
  I think you missed to add EXT4_MOUNT_PRJQUOTA to Opt_noquota...

...
> @@ -2833,6 +2855,13 @@ static int ext4_feature_set_ok(struct super_block *sb, int readonly)
>  			 "without CONFIG_QUOTA");
>  		return 0;
>  	}
> +	if (EXT4_HAS_RO_COMPAT_FEATURE(sb, EXT4_FEATURE_RO_COMPAT_PROJECT) &&
> +	    !readonly) {
> +		ext4_msg(sb, KERN_ERR,
> +			 "Filesystem with project quota feature cannot be"
> +			 "mounted RDWR without CONFIG_QUOTA");
> +		return 0;
> +	}
  Hum, I don't think this is right. EXT4_FEATURE_RO_COMPAT_PROJECT is about
maintaining project IDs not about quota. So it seems perfectly OK to have
EXT4_FEATURE_RO_COMPAT_PROJECT without CONFIG_QUOTA.

...
> @@ -5060,6 +5129,8 @@ static int ext4_statfs(struct dentry *dentry, struct kstatfs *buf)
>  	ext4_fsblk_t overhead = 0, resv_blocks;
>  	u64 fsid;
>  	s64 bfree;
> +	struct inode *inode = dentry->d_inode;
> +	int err = 0;
>  	resv_blocks = EXT4_C2B(sbi, atomic64_read(&sbi->s_resv_clusters));
>  
>  	if (!test_opt(sb, MINIX_DF))
> @@ -5084,7 +5155,18 @@ static int ext4_statfs(struct dentry *dentry, struct kstatfs *buf)
>  	buf->f_fsid.val[0] = fsid & 0xFFFFFFFFUL;
>  	buf->f_fsid.val[1] = (fsid >> 32) & 0xFFFFFFFFUL;
>  
> -	return 0;
> +	if (EXT4_HAS_RO_COMPAT_FEATURE(sb, EXT4_FEATURE_RO_COMPAT_PROJECT) &&
> +	    ext4_test_inode_flag(inode, EXT4_INODE_PROJINHERIT) &&
> +	    sb_has_quota_usage_enabled(sb, PRJQUOTA) &&
> +	    sb_has_quota_limits_enabled(sb, PRJQUOTA)) {
  If limits are enabled, then usage is enabled. So the check for usage
enabled is superfluous...

> +	    	err = ext4_statfs_project(sb, EXT4_I(inode)->i_projid, buf);
> +	    	if (err) {
> +			ext4_warning(sb, "Cannot get quota of project %u\n",
> +				     from_kprojid(&init_user_ns,
> +						  EXT4_I(inode)->i_projid));
> +	    	}
  The warning seems actually bogus - it can happen that project quota
enforcement gets turned off after we check sb_has_quota_limits_enabled()
but before calling dget() in ext4_statfs_project(). So I would just treat
error from ext4_statfs_project() as project quota being disabled...

								Honza
-- 
Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
SUSE Labs, CR
