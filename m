From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v23 11/22] vfs: Cache base_acl objects in inodes
Date: Tue, 05 Jul 2016 11:56:03 -0400
Message-ID: <1467734163.3800.43.camel@redhat.com>
References: <1467294433-3222-1-git-send-email-agruenba@redhat.com>
	 <1467294433-3222-12-git-send-email-agruenba@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1467294433-3222-12-git-send-email-agruenba-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andreas Gruenbacher <agruenba-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Andreas Dilger <adilger.kernel-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>, "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>, Trond Myklebust <trond.myklebust-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>, Anna Schumaker <anna.schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>, Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, xfs-VZNHf3L845pBDgjK7y7TUQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andreas Dilger <adilger-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thu, 2016-06-30 at 15:47 +0200, Andreas Gruenbacher wrote:
> POSIX ACLs and richacls are both objects allocated by kmalloc() with =
a
> reference count which are freed by kfree_rcu().=C2=A0=C2=A0An inode c=
an either
> cache an access and a default POSIX ACL, or a richacl (richacls do no=
t
> have default acls).=C2=A0=C2=A0To allow an inode to cache either of t=
he two kinds
> of acls, introduce a new base_acl type and convert i_acl and
> i_default_acl to that type. In most cases, the vfs then doesn't care =
which
> kind of acl an inode caches (if any).
>=20
> Signed-off-by: Andreas Gruenbacher <agruenba-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Cc: Andreas Dilger <adilger-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>
> ---
> =C2=A0drivers/staging/lustre/lustre/llite/llite_lib.c |=C2=A0=C2=A02 =
+-
> =C2=A0fs/9p/acl.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0|=C2=A0=C2=A08 +--
> =C2=A0fs/f2fs/acl.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0|=C2=A0=C2=A04 +-
> =C2=A0fs/inode.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0| 32 +++++++++++-
> =C2=A0fs/jffs2/acl.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0|=C2=A0=C2=A06 ++-
> =C2=A0fs/namei.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0| 33 ++++++------
> =C2=A0fs/nfs/nfs3acl.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
| 14 ++---
> =C2=A0fs/posix_acl.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0| 69 +++++++------------------
> =C2=A0fs/richacl.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0|=C2=A0=C2=A04 +-
> =C2=A0include/linux/fs.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0| 41 +++=
++++++++++--
> =C2=A0include/linux/posix_acl.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0| 21 ++++----
> =C2=A0include/linux/richacl.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0|=C2=A0=C2=A09 ++--
> =C2=A012 files changed, 139 insertions(+), 104 deletions(-)
>=20
> diff --git a/drivers/staging/lustre/lustre/llite/llite_lib.c b/driver=
s/staging/lustre/lustre/llite/llite_lib.c
> index 96c7e9f..7819a7c 100644
> --- a/drivers/staging/lustre/lustre/llite/llite_lib.c
> +++ b/drivers/staging/lustre/lustre/llite/llite_lib.c
> @@ -1087,7 +1087,7 @@ void ll_clear_inode(struct inode *inode)
> =C2=A0	}
> =C2=A0#ifdef CONFIG_FS_POSIX_ACL
> =C2=A0	else if (lli->lli_posix_acl) {
> -		LASSERT(atomic_read(&lli->lli_posix_acl->a_refcount) =3D=3D 1);
> +		LASSERT(base_acl_refcount(&lli->lli_posix_acl->a_base) =3D=3D 1);
> =C2=A0		LASSERT(!lli->lli_remote_perms);
> =C2=A0		posix_acl_release(lli->lli_posix_acl);
> =C2=A0		lli->lli_posix_acl =3D NULL;
> diff --git a/fs/9p/acl.c b/fs/9p/acl.c
> index 0576eae..1ce572f 100644
> --- a/fs/9p/acl.c
> +++ b/fs/9p/acl.c
> @@ -87,14 +87,14 @@ int v9fs_get_acl(struct inode *inode, struct p9_f=
id *fid)
> =C2=A0
> =C2=A0static struct posix_acl *v9fs_get_cached_acl(struct inode *inod=
e, int type)
> =C2=A0{
> -	struct posix_acl *acl;
> +	struct base_acl *base_acl;
> =C2=A0	/*
> =C2=A0	=C2=A0* 9p Always cache the acl value when
> =C2=A0	=C2=A0* instantiating the inode (v9fs_inode_from_fid)
> =C2=A0	=C2=A0*/
> -	acl =3D get_cached_acl(inode, type);
> -	BUG_ON(is_uncached_acl(acl));
> -	return acl;
> +	base_acl =3D get_cached_acl(inode, type);
> +	BUG_ON(is_uncached_acl(base_acl));
> +	return posix_acl(base_acl);
> =C2=A0}
> =C2=A0
> =C2=A0struct posix_acl *v9fs_iop_get_acl(struct inode *inode, int typ=
e)
> diff --git a/fs/f2fs/acl.c b/fs/f2fs/acl.c
> index a31c7e8..6079017 100644
> --- a/fs/f2fs/acl.c
> +++ b/fs/f2fs/acl.c
> @@ -267,7 +267,7 @@ static struct posix_acl *f2fs_acl_clone(const str=
uct posix_acl *acl,
> =C2=A0				sizeof(struct posix_acl_entry);
> =C2=A0		clone =3D kmemdup(acl, size, flags);
> =C2=A0		if (clone)
> -			atomic_set(&clone->a_refcount, 1);
> +			base_acl_init(&clone->a_base);
> =C2=A0	}
> =C2=A0	return clone;
> =C2=A0}
> @@ -279,7 +279,7 @@ static int f2fs_acl_create_masq(struct posix_acl =
*acl, umode_t *mode_p)
> =C2=A0	umode_t mode =3D *mode_p;
> =C2=A0	int not_equiv =3D 0;
> =C2=A0
> -	/* assert(atomic_read(acl->a_refcount) =3D=3D 1); */
> +	/* assert(base_acl_refcount(&acl->a_base) =3D=3D 1); */
> =C2=A0
> =C2=A0	FOREACH_ACL_ENTRY(pa, acl, pe) {
> =C2=A0		switch(pa->e_tag) {
> diff --git a/fs/inode.c b/fs/inode.c
> index 4ccbc21..40c03a7 100644
> --- a/fs/inode.c
> +++ b/fs/inode.c
> @@ -240,14 +240,42 @@ void __destroy_inode(struct inode *inode)
> =C2=A0
> =C2=A0#ifdef CONFIG_FS_POSIX_ACL
> =C2=A0	if (inode->i_acl && !is_uncached_acl(inode->i_acl))
> -		posix_acl_release(inode->i_acl);
> +		base_acl_put(inode->i_acl);
> =C2=A0	if (inode->i_default_acl && !is_uncached_acl(inode->i_default_=
acl))
> -		posix_acl_release(inode->i_default_acl);
> +		base_acl_put(inode->i_default_acl);
> =C2=A0#endif
> =C2=A0	this_cpu_dec(nr_inodes);
> =C2=A0}
> =C2=A0EXPORT_SYMBOL(__destroy_inode);
> =C2=A0
> +#ifdef CONFIG_FS_POSIX_ACL
> +struct base_acl *__get_cached_acl(struct base_acl **p)
> +{
> +	struct base_acl *base_acl;
> +
> +	for (;;) {
> +		rcu_read_lock();
> +		base_acl =3D rcu_dereference(*p);
> +		if (!base_acl || is_uncached_acl(base_acl) ||
> +		=C2=A0=C2=A0=C2=A0=C2=A0atomic_inc_not_zero(&base_acl->ba_refcount=
))
> +			break;
> +		rcu_read_unlock();
> +		cpu_relax();
> +	}
> +	rcu_read_unlock();
> +	return base_acl;
> +}
> +

I know this is basically copied from the existing get_cached_acl
function, but I'm a little uneasy with the above (and also with the
existing code that does the same thing).

The ba_refcount and ba_rcu are unioned. Once you've done the final
base_acl_put on the object, the you'll end up calling kfree_rcu which
is going to clobber the ba_refcount. How is it then safe to rely on it
still being zero for the atomic_inc_not_zero? ISTM that it would be
safer to make those separate fields and not union them.

=2E..or am I missing something that prevents that?

> +void __forget_cached_acl(struct base_acl **p)
> +{
> +	struct base_acl *old;
> +
> +	old =3D xchg(p, ACL_NOT_CACHED);
> +	if (!is_uncached_acl(old))
> +		base_acl_put(old);
> +}
> +#endif
> +
> =C2=A0static void i_callback(struct rcu_head *head)
> =C2=A0{
> =C2=A0	struct inode *inode =3D container_of(head, struct inode, i_rcu=
);
> diff --git a/fs/jffs2/acl.c b/fs/jffs2/acl.c
> index bc2693d..6c11909 100644
> --- a/fs/jffs2/acl.c
> +++ b/fs/jffs2/acl.c
> @@ -292,13 +292,15 @@ int jffs2_init_acl_post(struct inode *inode)
> =C2=A0	int rc;
> =C2=A0
> =C2=A0	if (inode->i_default_acl) {
> -		rc =3D __jffs2_set_acl(inode, JFFS2_XPREFIX_ACL_DEFAULT, inode->i_=
default_acl);
> +		rc =3D __jffs2_set_acl(inode, JFFS2_XPREFIX_ACL_DEFAULT,
> +				=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0posix_acl(inode->i_default_acl));
> =C2=A0		if (rc)
> =C2=A0			return rc;
> =C2=A0	}
> =C2=A0
> =C2=A0	if (inode->i_acl) {
> -		rc =3D __jffs2_set_acl(inode, JFFS2_XPREFIX_ACL_ACCESS, inode->i_a=
cl);
> +		rc =3D __jffs2_set_acl(inode, JFFS2_XPREFIX_ACL_ACCESS,
> +				=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0posix_acl(inode->i_acl));
> =C2=A0		if (rc)
> =C2=A0			return rc;
> =C2=A0	}
> diff --git a/fs/namei.c b/fs/namei.c
> index 663933e..7a822d0 100644
> --- a/fs/namei.c
> +++ b/fs/namei.c
> @@ -259,25 +259,28 @@ void putname(struct filename *name)
> =C2=A0static int check_acl(struct inode *inode, int mask)
> =C2=A0{
> =C2=A0#ifdef CONFIG_FS_POSIX_ACL
> -	struct posix_acl *acl;
> -
> =C2=A0	if (mask & MAY_NOT_BLOCK) {
> -		acl =3D get_cached_acl_rcu(inode, ACL_TYPE_ACCESS);
> -	=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (!acl)
> +		struct base_acl *base_acl;
> +
> +		base_acl =3D rcu_dereference(inode->i_acl);
> +	=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (!base_acl)
> =C2=A0	=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0return -EAGAIN;
> =C2=A0		/* no ->get_acl() calls in RCU mode... */
> -		if (is_uncached_acl(acl))
> +		if (is_uncached_acl(base_acl))
> =C2=A0			return -ECHILD;
> -	=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0return posix_acl_pe=
rmission(inode, acl, mask & ~MAY_NOT_BLOCK);
> -	}
> -
> -	acl =3D get_acl(inode, ACL_TYPE_ACCESS);
> -	if (IS_ERR(acl))
> -		return PTR_ERR(acl);
> -	if (acl) {
> -	=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0int error =3D posix=
_acl_permission(inode, acl, mask);
> -	=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0posix_acl_release(a=
cl);
> -	=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0return error;
> +	=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0return posix_acl_pe=
rmission(inode, posix_acl(base_acl),
> +					=C2=A0=C2=A0=C2=A0=C2=A0mask & ~MAY_NOT_BLOCK);
> +	} else {
> +		struct posix_acl *acl;
> +
> +		acl =3D get_acl(inode, ACL_TYPE_ACCESS);
> +		if (IS_ERR(acl))
> +			return PTR_ERR(acl);
> +		if (acl) {
> +			int error =3D posix_acl_permission(inode, acl, mask);
> +			posix_acl_release(acl);
> +			return error;
> +		}
> =C2=A0	}
> =C2=A0#endif
> =C2=A0
> diff --git a/fs/nfs/nfs3acl.c b/fs/nfs/nfs3acl.c
> index 720d92f5..2b70944 100644
> --- a/fs/nfs/nfs3acl.c
> +++ b/fs/nfs/nfs3acl.c
> @@ -16,28 +16,28 @@
> =C2=A0 * caching get_acl results in a race-free way.=C2=A0=C2=A0See f=
s/posix_acl.c:get_acl()
> =C2=A0 * for explanations.
> =C2=A0 */
> -static void nfs3_prepare_get_acl(struct posix_acl **p)
> +static void nfs3_prepare_get_acl(struct base_acl **p)
> =C2=A0{
> -	struct posix_acl *sentinel =3D uncached_acl_sentinel(current);
> +	struct base_acl *sentinel =3D uncached_acl_sentinel(current);
> =C2=A0
> =C2=A0	if (cmpxchg(p, ACL_NOT_CACHED, sentinel) !=3D ACL_NOT_CACHED) =
{
> =C2=A0		/* Not the first reader or sentinel already in place. */
> =C2=A0	}
> =C2=A0}
> =C2=A0
> -static void nfs3_complete_get_acl(struct posix_acl **p, struct posix=
_acl *acl)
> +static void nfs3_complete_get_acl(struct base_acl **p, struct posix_=
acl *acl)
> =C2=A0{
> -	struct posix_acl *sentinel =3D uncached_acl_sentinel(current);
> +	struct base_acl *sentinel =3D uncached_acl_sentinel(current);
> =C2=A0
> =C2=A0	/* Only cache the ACL if our sentinel is still in place. */
> =C2=A0	posix_acl_dup(acl);
> -	if (cmpxchg(p, sentinel, acl) !=3D sentinel)
> +	if (cmpxchg(p, sentinel, &acl->a_base) !=3D sentinel)
> =C2=A0		posix_acl_release(acl);
> =C2=A0}
> =C2=A0
> -static void nfs3_abort_get_acl(struct posix_acl **p)
> +static void nfs3_abort_get_acl(struct base_acl **p)
> =C2=A0{
> -	struct posix_acl *sentinel =3D uncached_acl_sentinel(current);
> +	struct base_acl *sentinel =3D uncached_acl_sentinel(current);
> =C2=A0
> =C2=A0	/* Remove our sentinel upon failure. */
> =C2=A0	cmpxchg(p, sentinel, ACL_NOT_CACHED);
> diff --git a/fs/posix_acl.c b/fs/posix_acl.c
> index edc452c..1b685a1 100644
> --- a/fs/posix_acl.c
> +++ b/fs/posix_acl.c
> @@ -21,7 +21,7 @@
> =C2=A0#include=20
> =C2=A0#include=20
> =C2=A0
> -static struct posix_acl **acl_by_type(struct inode *inode, int type)
> +static inline struct base_acl **acl_by_type(struct inode *inode, int=
 type)
> =C2=A0{
> =C2=A0	switch (type) {
> =C2=A0	case ACL_TYPE_ACCESS:
> @@ -33,51 +33,23 @@ static struct posix_acl **acl_by_type(struct inod=
e *inode, int type)
> =C2=A0	}
> =C2=A0}
> =C2=A0
> -struct posix_acl *get_cached_acl(struct inode *inode, int type)
> +struct base_acl *get_cached_acl(struct inode *inode, int type)
> =C2=A0{
> -	struct posix_acl **p =3D acl_by_type(inode, type);
> -	struct posix_acl *acl;
> -
> -	for (;;) {
> -		rcu_read_lock();
> -		acl =3D rcu_dereference(*p);
> -		if (!acl || is_uncached_acl(acl) ||
> -		=C2=A0=C2=A0=C2=A0=C2=A0atomic_inc_not_zero(&acl->a_refcount))
> -			break;
> -		rcu_read_unlock();
> -		cpu_relax();
> -	}
> -	rcu_read_unlock();
> -	return acl;
> +	return __get_cached_acl(acl_by_type(inode, type));
> =C2=A0}
> =C2=A0EXPORT_SYMBOL(get_cached_acl);
> =C2=A0
> -struct posix_acl *get_cached_acl_rcu(struct inode *inode, int type)
> -{
> -	return rcu_dereference(*acl_by_type(inode, type));
> -}
> -EXPORT_SYMBOL(get_cached_acl_rcu);
> -
> =C2=A0void set_cached_acl(struct inode *inode, int type, struct posix=
_acl *acl)
> =C2=A0{
> -	struct posix_acl **p =3D acl_by_type(inode, type);
> -	struct posix_acl *old;
> +	struct base_acl **p =3D acl_by_type(inode, type);
> +	struct base_acl *old;
> =C2=A0
> -	old =3D xchg(p, posix_acl_dup(acl));
> +	old =3D xchg(p, &posix_acl_dup(acl)->a_base);
> =C2=A0	if (!is_uncached_acl(old))
> -		posix_acl_release(old);
> +		base_acl_put(old);
> =C2=A0}
> =C2=A0EXPORT_SYMBOL(set_cached_acl);
> =C2=A0
> -static void __forget_cached_acl(struct posix_acl **p)
> -{
> -	struct posix_acl *old;
> -
> -	old =3D xchg(p, ACL_NOT_CACHED);
> -	if (!is_uncached_acl(old))
> -		posix_acl_release(old);
> -}
> -
> =C2=A0void forget_cached_acl(struct inode *inode, int type)
> =C2=A0{
> =C2=A0	__forget_cached_acl(acl_by_type(inode, type));
> @@ -93,25 +65,24 @@ EXPORT_SYMBOL(forget_all_cached_acls);
> =C2=A0
> =C2=A0struct posix_acl *get_acl(struct inode *inode, int type)
> =C2=A0{
> -	void *sentinel;
> -	struct posix_acl **p;
> +	struct base_acl **p =3D acl_by_type(inode, type);
> +	struct base_acl *sentinel, *base_acl;
> =C2=A0	struct posix_acl *acl;
> =C2=A0
> +	if (!IS_POSIXACL(inode))
> +		return NULL;
> +
> =C2=A0	/*
> =C2=A0	=C2=A0* The sentinel is used to detect when another operation =
like
> =C2=A0	=C2=A0* set_cached_acl() or forget_cached_acl() races with get=
_acl().
> =C2=A0	=C2=A0* It is guaranteed that is_uncached_acl(sentinel) is tru=
e.
> =C2=A0	=C2=A0*/
> =C2=A0
> -	acl =3D get_cached_acl(inode, type);
> -	if (!is_uncached_acl(acl))
> -		return acl;
> -
> -	if (!IS_POSIXACL(inode))
> -		return NULL;
> +	base_acl =3D __get_cached_acl(p);
> +	if (!is_uncached_acl(base_acl))
> +		return posix_acl(base_acl);
> =C2=A0
> =C2=A0	sentinel =3D uncached_acl_sentinel(current);
> -	p =3D acl_by_type(inode, type);
> =C2=A0
> =C2=A0	/*
> =C2=A0	=C2=A0* If the ACL isn't being read yet, set our sentinel.=C2=A0=
=C2=A0Otherwise, the
> @@ -151,7 +122,7 @@ struct posix_acl *get_acl(struct inode *inode, in=
t type)
> =C2=A0	=C2=A0* Cache the result, but only if our sentinel is still in=
 place.
> =C2=A0	=C2=A0*/
> =C2=A0	posix_acl_dup(acl);
> -	if (unlikely(cmpxchg(p, sentinel, acl) !=3D sentinel))
> +	if (unlikely(cmpxchg(p, sentinel, &acl->a_base) !=3D sentinel))
> =C2=A0		posix_acl_release(acl);
> =C2=A0	return acl;
> =C2=A0}
> @@ -163,7 +134,7 @@ EXPORT_SYMBOL(get_acl);
> =C2=A0void
> =C2=A0posix_acl_init(struct posix_acl *acl, int count)
> =C2=A0{
> -	atomic_set(&acl->a_refcount, 1);
> +	base_acl_init(&acl->a_base);
> =C2=A0	acl->a_count =3D count;
> =C2=A0}
> =C2=A0EXPORT_SYMBOL(posix_acl_init);
> @@ -196,7 +167,7 @@ posix_acl_clone(const struct posix_acl *acl, gfp_=
t flags)
> =C2=A0		=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0sizeof(struct posix_acl_entry);
> =C2=A0		clone =3D kmemdup(acl, size, flags);
> =C2=A0		if (clone)
> -			atomic_set(&clone->a_refcount, 1);
> +			base_acl_init(&clone->a_base);
> =C2=A0	}
> =C2=A0	return clone;
> =C2=A0}
> @@ -418,7 +389,7 @@ static int posix_acl_create_masq(struct posix_acl=
 *acl, umode_t *mode_p)
> =C2=A0	umode_t mode =3D *mode_p;
> =C2=A0	int not_equiv =3D 0;
> =C2=A0
> -	/* assert(atomic_read(acl->a_refcount) =3D=3D 1); */
> +	/* assert(base_acl_refcount(&acl->a_base) =3D=3D 1); */
> =C2=A0
> =C2=A0	FOREACH_ACL_ENTRY(pa, acl, pe) {
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0switch(pa->e_tag) {
> @@ -473,7 +444,7 @@ static int __posix_acl_chmod_masq(struct posix_ac=
l *acl, umode_t mode)
> =C2=A0	struct posix_acl_entry *group_obj =3D NULL, *mask_obj =3D NULL=
;
> =C2=A0	struct posix_acl_entry *pa, *pe;
> =C2=A0
> -	/* assert(atomic_read(acl->a_refcount) =3D=3D 1); */
> +	/* assert(base_acl_refcount(&acl->a_base) =3D=3D 1); */
> =C2=A0
> =C2=A0	FOREACH_ACL_ENTRY(pa, acl, pe) {
> =C2=A0		switch(pa->e_tag) {
> diff --git a/fs/richacl.c b/fs/richacl.c
> index cb0ef3f..8971ead 100644
> --- a/fs/richacl.c
> +++ b/fs/richacl.c
> @@ -31,7 +31,7 @@ richacl_alloc(int count, gfp_t gfp)
> =C2=A0	struct richacl *acl =3D kzalloc(size, gfp);
> =C2=A0
> =C2=A0	if (acl) {
> -		atomic_set(&acl->a_refcount, 1);
> +		base_acl_init(&acl->a_base);
> =C2=A0		acl->a_count =3D count;
> =C2=A0	}
> =C2=A0	return acl;
> @@ -50,7 +50,7 @@ richacl_clone(const struct richacl *acl, gfp_t gfp)
> =C2=A0
> =C2=A0	if (dup) {
> =C2=A0		memcpy(dup, acl, size);
> -		atomic_set(&dup->a_refcount, 1);
> +		base_acl_init(&dup->a_base);
> =C2=A0	}
> =C2=A0	return dup;
> =C2=A0}
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index bb36561..06a30b0 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -582,17 +582,23 @@ static inline void mapping_allow_writable(struc=
t address_space *mapping)
> =C2=A0#define i_size_ordered_init(inode) do { } while (0)
> =C2=A0#endif
> =C2=A0
> +struct base_acl {
> +	union {
> +		atomic_t ba_refcount;
> +		struct rcu_head ba_rcu;
> +	};
> +};
> =C2=A0struct posix_acl;
> =C2=A0#define ACL_NOT_CACHED ((void *)(-1))
> =C2=A0
> -static inline struct posix_acl *
> +static inline struct base_acl *
> =C2=A0uncached_acl_sentinel(struct task_struct *task)
> =C2=A0{
> =C2=A0	return (void *)task + 1;
> =C2=A0}
> =C2=A0
> =C2=A0static inline bool
> -is_uncached_acl(struct posix_acl *acl)
> +is_uncached_acl(struct base_acl *acl)
> =C2=A0{
> =C2=A0	return (long)acl & 1;
> =C2=A0}
> @@ -613,9 +619,9 @@ struct inode {
> =C2=A0	kgid_t			i_gid;
> =C2=A0	unsigned int		i_flags;
> =C2=A0
> -#ifdef CONFIG_FS_POSIX_ACL
> -	struct posix_acl	*i_acl;
> -	struct posix_acl	*i_default_acl;
> +#if defined(CONFIG_FS_POSIX_ACL)
> +	struct base_acl		*i_acl;
> +	struct base_acl		*i_default_acl;
> =C2=A0#endif
> =C2=A0
> =C2=A0	const struct inode_operations	*i_op;
> @@ -3193,4 +3199,29 @@ static inline bool dir_relax_shared(struct ino=
de *inode)
> =C2=A0extern bool path_noexec(const struct path *path);
> =C2=A0extern void inode_nohighmem(struct inode *inode);
> =C2=A0
> +static inline void base_acl_get(struct base_acl *acl)
> +{
> +	if (acl)
> +		atomic_inc(&acl->ba_refcount);
> +}
> +
> +static inline void base_acl_put(struct base_acl *acl)
> +{
> +	if (acl && atomic_dec_and_test(&acl->ba_refcount))
> +		kfree_rcu(acl, ba_rcu);
> +}
> +
> +static inline void base_acl_init(struct base_acl *acl)
> +{
> +	atomic_set(&acl->ba_refcount, 1);
> +}
> +
> +static inline int base_acl_refcount(struct base_acl *acl)
> +{
> +	return atomic_read(&acl->ba_refcount);
> +}
> +
> +extern struct base_acl *__get_cached_acl(struct base_acl **);
> +extern void __forget_cached_acl(struct base_acl **);
> +
> =C2=A0#endif /* _LINUX_FS_H */
> diff --git a/include/linux/posix_acl.h b/include/linux/posix_acl.h
> index 5b5a80c..daf84fa 100644
> --- a/include/linux/posix_acl.h
> +++ b/include/linux/posix_acl.h
> @@ -43,10 +43,7 @@ struct posix_acl_entry {
> =C2=A0};
> =C2=A0
> =C2=A0struct posix_acl {
> -	union {
> -		atomic_t		a_refcount;
> -		struct rcu_head		a_rcu;
> -	};
> +	struct base_acl		a_base;=C2=A0=C2=A0/* must be first, see posix_acl=
_release() */
> =C2=A0	unsigned int		a_count;
> =C2=A0	struct posix_acl_entry	a_entries[0];
> =C2=A0};
> @@ -61,8 +58,7 @@ struct posix_acl {
> =C2=A0static inline struct posix_acl *
> =C2=A0posix_acl_dup(struct posix_acl *acl)
> =C2=A0{
> -	if (acl)
> -		atomic_inc(&acl->a_refcount);
> +	base_acl_get(&acl->a_base);
> =C2=A0	return acl;
> =C2=A0}
> =C2=A0
> @@ -72,10 +68,16 @@ posix_acl_dup(struct posix_acl *acl)
> =C2=A0static inline void
> =C2=A0posix_acl_release(struct posix_acl *acl)
> =C2=A0{
> -	if (acl && atomic_dec_and_test(&acl->a_refcount))
> -		kfree_rcu(acl, a_rcu);
> +	BUILD_BUG_ON(offsetof(struct posix_acl, a_base) !=3D 0);
> +	base_acl_put(&acl->a_base);
> =C2=A0}
> =C2=A0
> +static inline struct posix_acl *
> +posix_acl(struct base_acl *base_acl)
> +{
> +	BUILD_BUG_ON(offsetof(struct posix_acl, a_base) !=3D 0);
> +	return container_of(base_acl, struct posix_acl, a_base);
> +}
> =C2=A0
> =C2=A0/* posix_acl.c */
> =C2=A0
> @@ -99,8 +101,7 @@ extern int posix_acl_create(struct inode *, umode_=
t *, struct posix_acl **,
> =C2=A0extern int simple_set_acl(struct inode *, struct posix_acl *, i=
nt);
> =C2=A0extern int simple_acl_create(struct inode *, struct inode *);
> =C2=A0
> -struct posix_acl *get_cached_acl(struct inode *inode, int type);
> -struct posix_acl *get_cached_acl_rcu(struct inode *inode, int type);
> +struct base_acl *get_cached_acl(struct inode *inode, int type);
> =C2=A0void set_cached_acl(struct inode *inode, int type, struct posix=
_acl *acl);
> =C2=A0void forget_cached_acl(struct inode *inode, int type);
> =C2=A0void forget_all_cached_acls(struct inode *inode);
> diff --git a/include/linux/richacl.h b/include/linux/richacl.h
> index be9fb65..35a5bcb 100644
> --- a/include/linux/richacl.h
> +++ b/include/linux/richacl.h
> @@ -31,7 +31,7 @@ struct richace {
> =C2=A0};
> =C2=A0
> =C2=A0struct richacl {
> -	atomic_t	a_refcount;
> +	struct base_acl	a_base;=C2=A0=C2=A0/* must be first, see richacl_pu=
t() */
> =C2=A0	unsigned int	a_owner_mask;
> =C2=A0	unsigned int	a_group_mask;
> =C2=A0	unsigned int	a_other_mask;
> @@ -56,8 +56,7 @@ struct richacl {
> =C2=A0static inline struct richacl *
> =C2=A0richacl_get(struct richacl *acl)
> =C2=A0{
> -	if (acl)
> -		atomic_inc(&acl->a_refcount);
> +	base_acl_get(&acl->a_base);
> =C2=A0	return acl;
> =C2=A0}
> =C2=A0
> @@ -67,8 +66,8 @@ richacl_get(struct richacl *acl)
> =C2=A0static inline void
> =C2=A0richacl_put(struct richacl *acl)
> =C2=A0{
> -	if (acl && atomic_dec_and_test(&acl->a_refcount))
> -		kfree(acl);
> +	BUILD_BUG_ON(offsetof(struct richacl, a_base) !=3D 0);
> +	base_acl_put(&acl->a_base);
> =C2=A0}
> =C2=A0
> =C2=A0/**

--
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
