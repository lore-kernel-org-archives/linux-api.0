From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v23 13/22] vfs: Cache richacl in struct inode
Date: Wed, 06 Jul 2016 14:57:05 -0400
Message-ID: <1467831425.2908.16.camel@redhat.com>
References: <1467294433-3222-1-git-send-email-agruenba@redhat.com>
	 <1467294433-3222-14-git-send-email-agruenba@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1467294433-3222-14-git-send-email-agruenba-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andreas Gruenbacher <agruenba-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Andreas Dilger <adilger.kernel-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>, "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>, Trond Myklebust <trond.myklebust-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>, Anna Schumaker <anna.schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>, Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, xfs-VZNHf3L845pBDgjK7y7TUQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Thu, 2016-06-30 at 15:47 +0200, Andreas Gruenbacher wrote:
> Cache richacls in struct inode so that this doesn't have to be done
> individually in each filesystem.=C2=A0=C2=A0This is similar to POSIX =
ACLs.
>=20
> Signed-off-by: Andreas Gruenbacher <agruenba-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
> =C2=A0fs/inode.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0| 13 +++++---
> =C2=A0fs/richacl.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0| 81 +++++++++++++++++++++++++++++++++++++++++++++=
++++
> =C2=A0include/linux/fs.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0|=C2=A0=C2=
=A05 ++-
> =C2=A0include/linux/richacl.h | 11 +++++++
> =C2=A04 files changed, 105 insertions(+), 5 deletions(-)
>=20
> diff --git a/fs/inode.c b/fs/inode.c
> index 40c03a7..7dbb09c 100644
> --- a/fs/inode.c
> +++ b/fs/inode.c
> @@ -181,8 +181,11 @@ int inode_init_always(struct super_block *sb, st=
ruct inode *inode)
> =C2=A0	inode->i_private =3D NULL;
> =C2=A0	inode->i_mapping =3D mapping;
> =C2=A0	INIT_HLIST_HEAD(&inode->i_dentry);	/* buggered by rcu freeing =
*/
> -#ifdef CONFIG_FS_POSIX_ACL
> -	inode->i_acl =3D inode->i_default_acl =3D ACL_NOT_CACHED;
> +#if defined(CONFIG_FS_POSIX_ACL) || defined(CONFIG_FS_RICHACL)
> +	inode->i_acl =3D ACL_NOT_CACHED;
> +# if defined(CONFIG_FS_POSIX_ACL)
> +	inode->i_default_acl =3D ACL_NOT_CACHED;
> +# endif
> =C2=A0#endif
> =C2=A0
> =C2=A0#ifdef CONFIG_FSNOTIFY
> @@ -238,17 +241,19 @@ void __destroy_inode(struct inode *inode)
> =C2=A0		atomic_long_dec(&inode->i_sb->s_remove_count);
> =C2=A0	}
> =C2=A0
> -#ifdef CONFIG_FS_POSIX_ACL
> +#if defined(CONFIG_FS_POSIX_ACL) || defined(CONFIG_FS_RICHACL)
> =C2=A0	if (inode->i_acl && !is_uncached_acl(inode->i_acl))
> =C2=A0		base_acl_put(inode->i_acl);
> +# if defined(CONFIG_FS_POSIX_ACL)
> =C2=A0	if (inode->i_default_acl && !is_uncached_acl(inode->i_default_=
acl))
> =C2=A0		base_acl_put(inode->i_default_acl);
> +# endif
> =C2=A0#endif
> =C2=A0	this_cpu_dec(nr_inodes);
> =C2=A0}
> =C2=A0EXPORT_SYMBOL(__destroy_inode);
> =C2=A0
> -#ifdef CONFIG_FS_POSIX_ACL
> +#if defined(CONFIG_FS_POSIX_ACL) || defined(CONFIG_FS_RICHACL)
> =C2=A0struct base_acl *__get_cached_acl(struct base_acl **p)
> =C2=A0{
> =C2=A0	struct base_acl *base_acl;
> diff --git a/fs/richacl.c b/fs/richacl.c
> index 8971ead..b2a03c1 100644
> --- a/fs/richacl.c
> +++ b/fs/richacl.c
> @@ -20,6 +20,87 @@
> =C2=A0#include=20
> =C2=A0#include=20
> =C2=A0
> +void set_cached_richacl(struct inode *inode, struct richacl *acl)
> +{
> +	struct base_acl *old;
> +
> +	old =3D xchg(&inode->i_acl, &richacl_get(acl)->a_base);
> +	if (!is_uncached_acl(old))
> +		base_acl_put(old);
> +}
> +EXPORT_SYMBOL_GPL(set_cached_richacl);
> +
> +void forget_cached_richacl(struct inode *inode)
> +{
> +	__forget_cached_acl(&inode->i_acl);
> +}
> +EXPORT_SYMBOL_GPL(forget_cached_richacl);
> +
> +struct richacl *get_richacl(struct inode *inode)
> +{
> +	struct base_acl *sentinel, *base_acl;
> +	struct richacl *acl;
> +
> +	if (!IS_RICHACL(inode))
> +		return NULL;
> +
> +	/*
> +	=C2=A0* The sentinel is used to detect when another operation like
> +	=C2=A0* set_cached_richacl() or forget_cached_richacl() races with
> +	=C2=A0* get_richacl().
> +	=C2=A0* It is guaranteed that is_uncached_acl(sentinel) is true.
> +	=C2=A0*/
> +
> +	base_acl =3D __get_cached_acl(&inode->i_acl);
> +	if (!is_uncached_acl(base_acl))
> +		return richacl(base_acl);
> +
> +	sentinel =3D uncached_acl_sentinel(current);
> +
> +	/*
> +	=C2=A0* If the ACL isn't being read yet, set our sentinel.=C2=A0=C2=
=A0Otherwise, the
> +	=C2=A0* current value of the ACL will not be ACL_NOT_CACHED and so =
our own
> +	=C2=A0* sentinel will not be set; another task will update the cach=
e.=C2=A0=C2=A0We
> +	=C2=A0* could wait for that other task to complete its job, but it'=
s easier
> +	=C2=A0* to just call ->get_acl to fetch the ACL ourself.=C2=A0=C2=A0=
(This is going to
> +	=C2=A0* be an unlikely race.)
> +	=C2=A0*/
> +	if (cmpxchg(&inode->i_acl, ACL_NOT_CACHED, sentinel) !=3D ACL_NOT_C=
ACHED)
> +		/* fall through */ ;
> +

So you do the same thing regardless of the outcome of the above? Why
bother with the if at all here? Just do the cmpxchg and toss out the
result.

> +	/*
> +	=C2=A0* Normally, the ACL returned by ->get_richacl will be cached.
> +	=C2=A0* A filesystem can prevent that by calling
> +	=C2=A0* forget_cached_richacl(inode) in ->get_richacl.
> +	=C2=A0*
> +	=C2=A0* If the filesystem doesn't have a ->get_richacl function at =
all,
> +	=C2=A0* we'll just create the negative cache entry.
> +	=C2=A0*/
> +	if (!inode->i_op->get_richacl) {
> +		set_cached_richacl(inode, NULL);
> +		return NULL;
> +	}
> +
> +	acl =3D inode->i_op->get_richacl(inode);
> +	if (IS_ERR(acl)) {
> +		/*
> +		=C2=A0* Remove our sentinel so that we don't block future attempts
> +		=C2=A0* to cache the ACL.
> +		=C2=A0*/
> +		cmpxchg(&inode->i_acl, sentinel, ACL_NOT_CACHED);
> +		return acl;
> +	}
> +

So this is sort of icky: only the task that sets the sentinel can set
the cached acl.

You could have one task set the sentinel, call get_richacl and fail, bu=
t then a concurrent task also issues a get_richacl and succeeds. That t=
ask will get its acl, but it doesn't end up getting cached and subseque=
nt callers then have to reissue the request. It would be good if the fi=
rst successful fetch of the acl sets it in the cache.

That said, getting the acl could be pretty expensive with some filesyst=
ems. NFS or CIFS are going to have to do an on the wire call to fetch t=
hem, for instance. I think it would be better to have concurrent caller=
s wait for the first caller's result instead of issuing parallel get_ri=
chacl requests.

> +	/*
> +	=C2=A0* Cache the result, but only if our sentinel is still in plac=
e.
> +	=C2=A0*/
> +	richacl_get(acl);
> +	if (unlikely(cmpxchg(&inode->i_acl, sentinel, &acl->a_base) !=3D se=
ntinel))
> +		richacl_put(acl);
> +	return acl;
> +}
> +EXPORT_SYMBOL_GPL(get_richacl);
> +
> =C2=A0/**
> =C2=A0 * richacl_alloc=C2=A0=C2=A0-=C2=A0=C2=A0allocate a richacl
> =C2=A0 * @count:	number of entries
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index ac96bda..4d72a6d 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -589,6 +589,7 @@ struct base_acl {
> =C2=A0	};
> =C2=A0};
> =C2=A0struct posix_acl;
> +struct richacl;
> =C2=A0#define ACL_NOT_CACHED ((void *)(-1))
> =C2=A0
> =C2=A0static inline struct base_acl *
> @@ -619,9 +620,11 @@ struct inode {
> =C2=A0	kgid_t			i_gid;
> =C2=A0	unsigned int		i_flags;
> =C2=A0
> -#if defined(CONFIG_FS_POSIX_ACL)
> +#if defined(CONFIG_FS_POSIX_ACL) || defined(CONFIG_FS_RICHACL)
> =C2=A0	struct base_acl		*i_acl;
> +# if defined(CONFIG_FS_POSIX_ACL)
> =C2=A0	struct base_acl		*i_default_acl;
> +# endif
> =C2=A0#endif
> =C2=A0

Oh, so if we compile in richacls and not posix acls, we shrink the
inode by a pointer. Nice!

> =C2=A0	const struct inode_operations	*i_op;
> diff --git a/include/linux/richacl.h b/include/linux/richacl.h
> index 35a5bcb..3e05c94 100644
> --- a/include/linux/richacl.h
> +++ b/include/linux/richacl.h
> @@ -70,6 +70,17 @@ richacl_put(struct richacl *acl)
> =C2=A0	base_acl_put(&acl->a_base);
> =C2=A0}
> =C2=A0
> +static inline struct richacl *
> +richacl(struct base_acl *base_acl)
> +{
> +	BUILD_BUG_ON(offsetof(struct richacl, a_base) !=3D 0);
> +	return container_of(base_acl, struct richacl, a_base);
> +}
> +
> +extern void set_cached_richacl(struct inode *, struct richacl *);
> +extern void forget_cached_richacl(struct inode *);
> +extern struct richacl *get_richacl(struct inode *);
> +
> =C2=A0/**
> =C2=A0 * richace_is_owner=C2=A0=C2=A0-=C2=A0=C2=A0check if @ace is an=
 OWNER@ entry
> =C2=A0 */

--=20
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
