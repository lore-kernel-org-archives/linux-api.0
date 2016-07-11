From: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH review 08/12] quota: Ensure qids map to the filesystem
Date: Mon, 11 Jul 2016 12:14:24 +0200
Message-ID: <20160711101424.GH12410@quack2.suse.cz>
References: <874m82bptc.fsf@x220.int.ebiederm.org>
	<20160706181212.16267-1-ebiederm@xmission.com>
	<20160706181212.16267-8-ebiederm@xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160706181212.16267-8-ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/containers/>
List-Post: <mailto:containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Cc: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, Seth Forshee <seth.forshee-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jann Horn <jann-XZ1E9jl8jIdeoWH0uzbU5w@public.gmane.org>, Djalal Harouni <tixxdz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Wed 06-07-16 13:12:08, Eric W. Biederman wrote:
> Introduce the helper qid_has_mapping and use it to ensure that the
> quota system only considers qids that map to the filesystems
> s_user_ns.
> 
> In practice for quota supporting filesystems today this is the exact
> same check as qid_valid.  As only 0xffffffff aka (qid_t)-1 does not
> map into init_user_ns.
> 
> Replace the qid_valid calls with qid_has_mapping as values come in
> from userspace.  This is harmless today and it prepares the quota
> system to work on filesystems with quotas but mounted by unprivileged
> users.
> 
> Call qid_has_mapping from dqget.  This ensures the passed in qid has a
> prepresentation on the underlying filesystem.  Previously this was
> unnecessary as filesystesm never had qids that could not map.  With
> the introduction of filesystems outside of s_user_ns this will not
> remain true.
> 
> All of this ensures the quota code never has to deal with qids that
> don't map to the underlying filesystem.

Does this and the following patch make sense when we actually don't allow
quotas when s_user_ns is set? If things are untested, they will get broken
so I think it is wiser to do the conversion only once we decide quota
should be supported for namespaces != init_user_ns. Or do I miss something?

								Honza

> 
> Cc: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
> Acked-by: Seth Forshee <seth.forshee-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
> Signed-off-by: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
> ---
>  fs/quota/dquot.c      |  3 +++
>  fs/quota/quota.c      | 12 ++++++------
>  include/linux/quota.h | 10 ++++++++++
>  3 files changed, 19 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/quota/dquot.c b/fs/quota/dquot.c
> index ff21980d0119..74706b6aa747 100644
> --- a/fs/quota/dquot.c
> +++ b/fs/quota/dquot.c
> @@ -841,6 +841,9 @@ struct dquot *dqget(struct super_block *sb, struct kqid qid)
>  	unsigned int hashent = hashfn(sb, qid);
>  	struct dquot *dquot, *empty = NULL;
>  
> +	if (!qid_has_mapping(sb->s_user_ns, qid))
> +		return ERR_PTR(-EINVAL);
> +
>          if (!sb_has_quota_active(sb, qid.type))
>  		return ERR_PTR(-ESRCH);
>  we_slept:
> diff --git a/fs/quota/quota.c b/fs/quota/quota.c
> index 0f10ee9892ce..73f6f4cf0a21 100644
> --- a/fs/quota/quota.c
> +++ b/fs/quota/quota.c
> @@ -211,7 +211,7 @@ static int quota_getquota(struct super_block *sb, int type, qid_t id,
>  	if (!sb->s_qcop->get_dqblk)
>  		return -ENOSYS;
>  	qid = make_kqid(current_user_ns(), type, id);
> -	if (!qid_valid(qid))
> +	if (!qid_has_mapping(sb->s_user_ns, qid))
>  		return -EINVAL;
>  	ret = sb->s_qcop->get_dqblk(sb, qid, &fdq);
>  	if (ret)
> @@ -237,7 +237,7 @@ static int quota_getnextquota(struct super_block *sb, int type, qid_t id,
>  	if (!sb->s_qcop->get_nextdqblk)
>  		return -ENOSYS;
>  	qid = make_kqid(current_user_ns(), type, id);
> -	if (!qid_valid(qid))
> +	if (!qid_has_mapping(sb->s_user_ns, qid))
>  		return -EINVAL;
>  	ret = sb->s_qcop->get_nextdqblk(sb, &qid, &fdq);
>  	if (ret)
> @@ -288,7 +288,7 @@ static int quota_setquota(struct super_block *sb, int type, qid_t id,
>  	if (!sb->s_qcop->set_dqblk)
>  		return -ENOSYS;
>  	qid = make_kqid(current_user_ns(), type, id);
> -	if (!qid_valid(qid))
> +	if (!qid_has_mapping(sb->s_user_ns, qid))
>  		return -EINVAL;
>  	copy_from_if_dqblk(&fdq, &idq);
>  	return sb->s_qcop->set_dqblk(sb, qid, &fdq);
> @@ -581,7 +581,7 @@ static int quota_setxquota(struct super_block *sb, int type, qid_t id,
>  	if (!sb->s_qcop->set_dqblk)
>  		return -ENOSYS;
>  	qid = make_kqid(current_user_ns(), type, id);
> -	if (!qid_valid(qid))
> +	if (!qid_has_mapping(sb->s_user_ns, qid))
>  		return -EINVAL;
>  	/* Are we actually setting timer / warning limits for all users? */
>  	if (from_kqid(&init_user_ns, qid) == 0 &&
> @@ -642,7 +642,7 @@ static int quota_getxquota(struct super_block *sb, int type, qid_t id,
>  	if (!sb->s_qcop->get_dqblk)
>  		return -ENOSYS;
>  	qid = make_kqid(current_user_ns(), type, id);
> -	if (!qid_valid(qid))
> +	if (!qid_has_mapping(sb->s_user_ns, qid))
>  		return -EINVAL;
>  	ret = sb->s_qcop->get_dqblk(sb, qid, &qdq);
>  	if (ret)
> @@ -669,7 +669,7 @@ static int quota_getnextxquota(struct super_block *sb, int type, qid_t id,
>  	if (!sb->s_qcop->get_nextdqblk)
>  		return -ENOSYS;
>  	qid = make_kqid(current_user_ns(), type, id);
> -	if (!qid_valid(qid))
> +	if (!qid_has_mapping(sb->s_user_ns, qid))
>  		return -EINVAL;
>  	ret = sb->s_qcop->get_nextdqblk(sb, &qid, &qdq);
>  	if (ret)
> diff --git a/include/linux/quota.h b/include/linux/quota.h
> index 9dfb6bce8c9e..1db16ee39b31 100644
> --- a/include/linux/quota.h
> +++ b/include/linux/quota.h
> @@ -179,6 +179,16 @@ static inline struct kqid make_kqid_projid(kprojid_t projid)
>  	return kqid;
>  }
>  
> +/**
> + *	qid_has_mapping - Report if a qid maps into a user namespace.
> + *	@ns:  The user namespace to see if a value maps into.
> + *	@qid: The kernel internal quota identifier to test.
> + */
> +static inline bool qid_has_mapping(struct user_namespace *ns, struct kqid qid)
> +{
> +	return from_kqid(ns, qid) != (qid_t) -1;
> +}
> +
>  
>  extern spinlock_t dq_data_lock;
>  
> -- 
> 2.8.3
> 
-- 
Jan Kara <jack-IBi9RG/b67k@public.gmane.org>
SUSE Labs, CR
