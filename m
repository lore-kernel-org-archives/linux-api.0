From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 1/4] Adds general codes to enforces project quota limits
Date: Wed, 24 Sep 2014 18:08:43 +0200
Message-ID: <20140924160843.GB27000@quack.suse.cz>
References: <1411567470-31799-1-git-send-email-lixi@ddn.com>
 <1411567470-31799-2-git-send-email-lixi@ddn.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1411567470-31799-2-git-send-email-lixi@ddn.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Li Xi <pkuelelixi@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, linux-api@vger.kernel.org, tytso@mit.edu, adilger@dilger.ca, jack@suse.cz, viro@zeniv.linux.org.uk, hch@infradead.org, dmonakhov@openvz.org
List-Id: linux-api@vger.kernel.org

On Wed 24-09-14 22:04:27, Li Xi wrote:
> This patch adds support for a new quota type PRJQUOTA for project quota
> enforcement. Also a new method get_projid() is added into dquot_operations
> structure.
> 
> Signed-off-by: Li Xi <lixi@ddn.com>
> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
> ---
>  fs/quota/dquot.c           |   16 ++++++++++++++--
>  fs/quota/quota.c           |    5 ++++-
>  fs/quota/quotaio_v2.h      |    6 ++++--
>  include/linux/quota.h      |    2 ++
>  include/uapi/linux/quota.h |    6 ++++--
>  5 files changed, 28 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/quota/dquot.c b/fs/quota/dquot.c
> index f2d0eee..8d0c270 100644
> --- a/fs/quota/dquot.c
> +++ b/fs/quota/dquot.c
> @@ -1154,8 +1154,8 @@ static int need_print_warning(struct dquot_warn *warn)
>  			return uid_eq(current_fsuid(), warn->w_dq_id.uid);
>  		case GRPQUOTA:
>  			return in_group_p(warn->w_dq_id.gid);
> -		case PRJQUOTA:	/* Never taken... Just make gcc happy */
> -			return 0;
> +		case PRJQUOTA:
> +			return 1;
>  	}
>  	return 0;
>  }
> @@ -1394,6 +1394,9 @@ static void __dquot_initialize(struct inode *inode, int type)
>  	/* First get references to structures we might need. */
>  	for (cnt = 0; cnt < MAXQUOTAS; cnt++) {
>  		struct kqid qid;
> +		kprojid_t projid;
> +		int rc;
> +
>  		got[cnt] = NULL;
>  		if (type != -1 && cnt != type)
>  			continue;
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
>  		}
>  		got[cnt] = dqget(sb, qid);
>  	}
  Looking into dquot.c you seem to be missing a change to do_get_dqblk()
where setting of di->d_flags needs to handle PRJQUOTA now as well.

> diff --git a/fs/quota/quota.c b/fs/quota/quota.c
> index 7562164..cce7371 100644
> --- a/fs/quota/quota.c
> +++ b/fs/quota/quota.c
> @@ -30,7 +30,10 @@ static int check_quotactl_permission(struct super_block *sb, int type, int cmd,
>  	case Q_XGETQSTATV:
>  	case Q_XQUOTASYNC:
>  		break;
> -	/* allow to query information for dquots we "own" */
> +	/*
> +	 * allow to query information for dquots we "own"
> +	 * always allow quota check for project quota
  The last sentense should probably be:
"always allow querying project quota"
> +	 */
>  	case Q_GETQUOTA:
>  	case Q_XGETQUOTA:
>  		if ((type == USRQUOTA && uid_eq(current_euid(), make_kuid(current_user_ns(), id))) ||
  But looking at the code, you need to add there

|| type == PRJQUOTA

  don't you?


								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
