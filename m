From: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH 1/4] Adds general codes to enforces project quota limits
Date: Tue, 30 Sep 2014 22:07:21 +0200
Message-ID: <20140930200721.GA6593@quack.suse.cz>
References: <1411567470-31799-1-git-send-email-lixi@ddn.com>
 <1411567470-31799-2-git-send-email-lixi@ddn.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1411567470-31799-2-git-send-email-lixi-LfVdkaOWEx8@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Li Xi <pkuelelixi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tytso-3s7WtUTddSA@public.gmane.org, adilger-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org, jack-AlSwsSmVLrQ@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, dmonakhov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Wed 24-09-14 22:04:27, Li Xi wrote:
> @@ -1413,6 +1416,15 @@ static void __dquot_initialize(struct inode *inode, int type)
>  		case GRPQUOTA:
>  			qid = make_kqid_gid(inode->i_gid);
>  			break;
> +		case PRJQUOTA:
> +			/* Project ID is not supported */
> +			if (!inode->i_sb->dq_op->get_projid)
> +				continue;
> +			rc = inode->i_sb->dq_op->get_projid(inode, &projid);
> +			if (rc)
> +				continue;
> +			qid = make_kqid_projid(projid);
> +			break;
  I realized one more thing: We don't want to check ->get_projid() here.
Rather we should check ->get_projid() when turning quota on in
quota_quotaon() and return -EINVAL when ->get_projid() isn't set - that way
user is early notified the fs doesn't support project quotas. Then here
in __dquot_initialize() we can just check sb_has_quota_active(sb, PRJQUOTA).

								Honza
-- 
Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
SUSE Labs, CR
