From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH review 10/12] dquot: For now explicitly don't support
 filesystems outside of init_user_ns
Date: Mon, 11 Jul 2016 12:09:23 +0200
Message-ID: <20160711100923.GG12410@quack2.suse.cz>
References: <874m82bptc.fsf@x220.int.ebiederm.org>
 <20160706181212.16267-1-ebiederm@xmission.com>
 <20160706181212.16267-10-ebiederm@xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160706181212.16267-10-ebiederm@xmission.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Linux Containers <containers@lists.linux-foundation.org>, Seth Forshee <seth.forshee@canonical.com>, linux-fsdevel@vger.kernel.org, Linux API <linux-api@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, Djalal Harouni <tixxdz@gmail.com>, "Serge E. Hallyn" <serge@hallyn.com>, Andy Lutomirski <luto@amacapital.net>, Jan Kara <jack@suse.cz>, Jann Horn <jann@thejh.net>, Michael Kerrisk <mtk.manpages@gmail.com>
List-Id: linux-api@vger.kernel.org

On Wed 06-07-16 13:12:10, Eric W. Biederman wrote:
> Mostly supporting filesystems outside of init_user_ns is
> s/&init_usre_ns/dquot->dq_sb->s_user_ns/.  An actual need for
> supporting quotas on filesystems outside of s_user_ns is quite a ways
> away and to be done responsibily needs an audit on what can happen
> with hostile quota files.  Until that audit is complete don't attempt
> to support quota files on filesystems outside of s_user_ns.
> 
> Cc: Jan Kara <jack@suse.cz>
> Acked-by: Seth Forshee <seth.forshee@canonical.com>
> Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>

Looks good. You can add:

Acked-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/quota/dquot.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/fs/quota/dquot.c b/fs/quota/dquot.c
> index 74706b6aa747..87197d13cc76 100644
> --- a/fs/quota/dquot.c
> +++ b/fs/quota/dquot.c
> @@ -2271,6 +2271,11 @@ static int vfs_load_quota_inode(struct inode *inode, int type, int format_id,
>  		error = -EINVAL;
>  		goto out_fmt;
>  	}
> +	/* Filesystems outside of init_user_ns not yet supported */
> +	if (sb->s_user_ns != &init_user_ns) {
> +		error = -EINVAL;
> +		goto out_fmt;
> +	}
>  	/* Usage always has to be set... */
>  	if (!(flags & DQUOT_USAGE_ENABLED)) {
>  		error = -EINVAL;
> -- 
> 2.8.3
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
