From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 2/4] Adds project ID support for ext4
Date: Wed, 24 Sep 2014 19:11:08 +0200
Message-ID: <20140924171108.GG27000@quack.suse.cz>
References: <1411567470-31799-1-git-send-email-lixi@ddn.com>
 <1411567470-31799-3-git-send-email-lixi@ddn.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1411567470-31799-3-git-send-email-lixi@ddn.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Li Xi <pkuelelixi@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, linux-api@vger.kernel.org, tytso@mit.edu, adilger@dilger.ca, jack@suse.cz, viro@zeniv.linux.org.uk, hch@infradead.org, dmonakhov@openvz.org
List-Id: linux-api@vger.kernel.org

On Wed 24-09-14 22:04:28, Li Xi wrote:
> This patch adds a new internal field of ext4 inode to save project
> identifier. Also a new flag EXT4_INODE_PROJINHERIT is added for
> inheriting project ID from parent directory.
  Nice. Just a few smaller things below.

  Firstly, I think your patch forgets to add a check to EXT4_IOC_SETFLAGS
ioctl so that EXT4_INODE_PROJINHERIT flag can be set only when
EXT4_FEATURE_RO_COMPAT_PROJECT is enabled.

> Signed-off-by: Li Xi <lixi@ddn.com>
> ---
>  fs/ext4/ext4.h   |   21 +++++++++++++++++----
>  fs/ext4/ialloc.c |    6 ++++++
>  fs/ext4/inode.c  |   29 ++++++++++++++++++++++++++++-
>  fs/ext4/namei.c  |   10 ++++++++++
>  fs/ext4/super.c  |    1 +
>  5 files changed, 62 insertions(+), 5 deletions(-)
> 
...
> diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
> index 5b87fc3..b6b7284 100644
> --- a/fs/ext4/ialloc.c
> +++ b/fs/ext4/ialloc.c
> @@ -756,6 +756,12 @@ struct inode *__ext4_new_inode(handle_t *handle, struct inode *dir,
>  		inode->i_gid = dir->i_gid;
>  	} else
>  		inode_init_owner(inode, dir, mode);
> +	if (ext4_test_inode_flag(dir, EXT4_INODE_PROJINHERIT)) {
> +		ei->i_projid = EXT4_I(dir)->i_projid;
> +	} else {
> +		ei->i_projid =
> +			make_kprojid(&init_user_ns, EXT4_DEF_PROJID);
> +	}
>  	dquot_initialize(inode);
>  
>  	if (!goal)
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index d5dd7d4..8c641eb 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -3874,6 +3874,24 @@ static inline void ext4_iget_extra_inode(struct inode *inode,
>  		EXT4_I(inode)->i_inline_off = 0;
>  }
>  
> +static projid_t ext4_inode_projid_get(struct inode *inode, struct ext4_inode *raw,
> +				 struct ext4_inode_info *ei)
> +{
> +	return (projid_t)le32_to_cpu(raw->i_projid);
> +}
> +
> +static void ext4_inode_projid_set(struct inode *inode, struct ext4_inode *raw,
> +				 struct ext4_inode_info *ei, projid_t projid)
> +{
> +	raw->i_projid = cpu_to_le32(projid);
> +}
  I don't see a need for these two wrappers. IMHO they just obfuscate the
code. Please just write the code directly in appropriate place.

> @@ -4204,7 +4228,8 @@ static int ext4_do_update_inode(handle_t *handle,
>  	EXT4_INODE_SET_XTIME(i_atime, inode, raw_inode);
>  	EXT4_EINODE_SET_XTIME(i_crtime, ei, raw_inode);
>  
> -	if (ext4_inode_blocks_set(handle, raw_inode, ei)) {
> +	err = ext4_inode_blocks_set(handle, raw_inode, ei);
> +	if (err) {
>  		spin_unlock(&ei->i_raw_lock);
>  		goto out_brelse;
>  	}
  This is an unrelated fix, right? Please send as a separate patch. Thanks!

> @@ -4255,6 +4280,8 @@ static int ext4_do_update_inode(handle_t *handle,
>  
>  	ext4_inode_csum_set(inode, raw_inode, ei);
>  
> +	ext4_inode_projid_set(inode, raw_inode, ei, i_projid);
> +
  This is wrong - you have to set project ID before a checksum is computed.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
