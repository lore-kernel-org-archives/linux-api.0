From: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [v5 3/5] Adds project quota support for ext4
Date: Thu, 30 Oct 2014 17:50:24 +0100
Message-ID: <20141030165024.GI28444@quack.suse.cz>
References: <1414300973-1118-1-git-send-email-lixi@ddn.com>
 <1414300973-1118-4-git-send-email-lixi@ddn.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1414300973-1118-4-git-send-email-lixi-LfVdkaOWEx8@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Li Xi <pkuelelixi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tytso-3s7WtUTddSA@public.gmane.org, adilger-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org, jack-AlSwsSmVLrQ@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, dmonakhov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Sun 26-10-14 13:22:51, Li Xi wrote:
> This patch adds mount options for enabling/disabling project quota
> accounting and enforcement. A new specific inode is also used for
> project quota accounting.
  The patch looks good except for one small issue:

...
> +	limit = dquot->dq_dqb.dqb_isoftlimit ?
> +		dquot->dq_dqb.dqb_isoftlimit :
> +		dquot->dq_dqb.dqb_ihardlimit;
> +	if (limit && buf->f_files > limit) {
> +		buf->f_files = limit;
> +		buf->f_ffree =
> +			(buf->f_files > dquot->dq_dqb.dqb_curinodes) ?
> +			 (buf->f_ffree - dquot->dq_dqb.dqb_curinodes) : 0;
                              ^^^^^ here should be f_files, shouldn't it?

> +	}
> +
> +	spin_unlock(&dq_data_lock);
> +	dqput(dquot);
> +	return 0;
> +}
> +
>  static int ext4_statfs(struct dentry *dentry, struct kstatfs *buf)
>  {
>  	struct super_block *sb = dentry->d_sb;

								Honza
-- 
Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
SUSE Labs, CR
