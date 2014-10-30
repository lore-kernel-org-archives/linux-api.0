From: Jan Kara <jack@suse.cz>
Subject: Re: [v5 1/5] Adds general codes to enforces project quota limits
Date: Thu, 30 Oct 2014 17:05:43 +0100
Message-ID: <20141030160543.GG28444@quack.suse.cz>
References: <1414300973-1118-1-git-send-email-lixi@ddn.com>
 <1414300973-1118-2-git-send-email-lixi@ddn.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1414300973-1118-2-git-send-email-lixi@ddn.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Li Xi <pkuelelixi@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, linux-api@vger.kernel.org, tytso@mit.edu, adilger@dilger.ca, jack@suse.cz, viro@zeniv.linux.org.uk, hch@infradead.org, dmonakhov@openvz.org
List-Id: linux-api@vger.kernel.org

On Sun 26-10-14 13:22:49, Li Xi wrote:
> This patch adds support for a new quota type PRJQUOTA for project quota
> enforcement. Also a new method get_projid() is added into dquot_operations
> structure.
> 
> Signed-off-by: Li Xi <lixi@ddn.com>
> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
...
> @@ -72,6 +76,8 @@ static int quota_quotaon(struct super_block *sb, int type, int cmd, qid_t id,
>  		return sb->s_qcop->quota_on_meta(sb, type, id);
>  	if (IS_ERR(path))
>  		return PTR_ERR(path);
> +	if (type == PRJQUOTA && sb->dq_op->get_projid == NULL)
> +		return -EOPNOTSUPP;
>  	return sb->s_qcop->quota_on(sb, type, id, path);
>  }
  Checking for ->get_projid() in quota_quotaon() isn't necessary. This will
be already handled by allowed_qtype bitmask in my patches. But you could
add a test in vfs_load_quota_inode() just after ->quota_write and
->quota_read tests. It will be mostly a safety check but I think it's
worthwhile.

Otherwise the patch looks fine to me.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
