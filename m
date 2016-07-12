From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v23 14/22] richacl: Update the file masks in chmod()
Date: Tue, 12 Jul 2016 07:36:56 -0400
Message-ID: <1468323416.7798.7.camel@redhat.com>
References: <1467294433-3222-1-git-send-email-agruenba@redhat.com>
	 <1467294433-3222-15-git-send-email-agruenba@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1467294433-3222-15-git-send-email-agruenba-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andreas Gruenbacher <agruenba-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Andreas Dilger <adilger.kernel-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>, "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>, Trond Myklebust <trond.myklebust-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>, Anna Schumaker <anna.schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>, Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, xfs-VZNHf3L845pBDgjK7y7TUQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Thu, 2016-06-30 at 15:47 +0200, Andreas Gruenbacher wrote:
> Doing a chmod() sets the file mode, which includes the file permissio=
n
> bits.=C2=A0=C2=A0When a file has a richacl, the permissions that the =
richacl
> grants need to be limited to what the new file permission bits allow.
>=20
> This is done by setting the file masks in the richacl to what the fil=
e
> permission bits map to.=C2=A0=C2=A0The richacl access check algorithm=
 takes the
> file masks into account, which ensures that the richacl cannot grant =
too
> many permissions.
>=20
> It is possible to explicitly add permissions to the file masks which =
go
> beyond what the file permission bits can grant (like the
> RICHACE_WRITE_ACL permission).=C2=A0=C2=A0The POSIX.1 standard calls =
this an
> alternate file access control mechanism.=C2=A0=C2=A0A subsequent chmo=
d() would
> ensure that those permissions are disabled again.
>=20
> Signed-off-by: Andreas Gruenbacher <agruenba-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Reviewed-by: J. Bruce Fields <bfields-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
> =C2=A0fs/richacl.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0| 71 +++++++++++++++++++++++++++++++++++++++++++++=
++++
> =C2=A0include/linux/richacl.h |=C2=A0=C2=A01 +
> =C2=A02 files changed, 72 insertions(+)
>=20
> diff --git a/fs/richacl.c b/fs/richacl.c
> index b2a03c1..ba110a6 100644
> --- a/fs/richacl.c
> +++ b/fs/richacl.c
> @@ -547,3 +547,74 @@ out:
> =C2=A0	return denied ? -EACCES : 0;
> =C2=A0}
> =C2=A0EXPORT_SYMBOL_GPL(richacl_permission);
> +
> +/**
> + * __richacl_chmod=C2=A0=C2=A0-=C2=A0=C2=A0update the file masks to =
reflect the new mode
> + * @acl:	access control list
> + * @mode:	new file permission bits including the file type
> + *
> + * Return a copy of @acl where the file masks have been replaced by =
the file
> + * masks corresponding to the file permission bits in @mode, or retu=
rns @acl
> + * itself if the file masks are already up to date.=C2=A0=C2=A0Takes=
 over a reference
> + * to @acl.
> + */
> +static struct richacl *
> +__richacl_chmod(struct richacl *acl, umode_t mode)
> +{
> +	unsigned int x =3D S_ISDIR(mode) ? 0 : RICHACE_DELETE_CHILD;
> +	unsigned int owner_mask, group_mask, other_mask;
> +	struct richacl *clone;
> +
> +	owner_mask =3D richacl_mode_to_mask(mode >> 6) & ~x;
> +	group_mask =3D richacl_mode_to_mask(mode >> 3) & ~x;
> +	other_mask =3D richacl_mode_to_mask(mode)=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0& ~x;
> +
> +	if (acl->a_owner_mask =3D=3D owner_mask &&
> +	=C2=A0=C2=A0=C2=A0=C2=A0acl->a_group_mask =3D=3D group_mask &&
> +	=C2=A0=C2=A0=C2=A0=C2=A0acl->a_other_mask =3D=3D other_mask &&
> +	=C2=A0=C2=A0=C2=A0=C2=A0(acl->a_flags & RICHACL_MASKED) &&
> +	=C2=A0=C2=A0=C2=A0=C2=A0(acl->a_flags & RICHACL_WRITE_THROUGH))
> +		return acl;
> +
> +	clone =3D richacl_clone(acl, GFP_KERNEL);
> +	richacl_put(acl);
> +	if (!clone)
> +		return ERR_PTR(-ENOMEM);
> +
> +	clone->a_flags |=3D (RICHACL_WRITE_THROUGH | RICHACL_MASKED);
> +	clone->a_owner_mask =3D owner_mask;
> +	clone->a_group_mask =3D group_mask;
> +	clone->a_other_mask =3D other_mask;
> +
> +	return clone;
> +}
> +
> +/**
> + * richacl_chmod=C2=A0=C2=A0-=C2=A0=C2=A0filesystem chmod helper
> + * @inode:	inode whose file permission bits to change
> + * @mode:	new file permission bits including the file type
> + *
> + * Helper for filesystems to use to perform a chmod on the richacl o=
f an inode.
> + */
> +int
> +richacl_chmod(struct inode *inode, umode_t mode)
> +{
> +	struct richacl *acl;
> +	int retval;
> +
> +	if (S_ISLNK(mode))
> +		return -EOPNOTSUPP;
> +	if (!inode->i_op->set_richacl)
> +		return -EOPNOTSUPP;
> +	acl =3D get_richacl(inode);
> +	if (IS_ERR_OR_NULL(acl))
> +		return PTR_ERR(acl);
> +	acl =3D __richacl_chmod(acl, mode);
> +	if (IS_ERR(acl))
> +		return PTR_ERR(acl);
> +	retval =3D inode->i_op->set_richacl(inode, acl);
> +	richacl_put(acl);
> +
> +	return retval;
> +}
> +EXPORT_SYMBOL(richacl_chmod);
> diff --git a/include/linux/richacl.h b/include/linux/richacl.h
> index 3e05c94..db82fab 100644
> --- a/include/linux/richacl.h
> +++ b/include/linux/richacl.h
> @@ -190,5 +190,6 @@ extern unsigned int richacl_mode_to_mask(umode_t)=
;
> =C2=A0extern unsigned int richacl_want_to_mask(unsigned int);
> =C2=A0extern void richacl_compute_max_masks(struct richacl *);
> =C2=A0extern int richacl_permission(struct inode *, const struct rich=
acl *, int);
> +extern int richacl_chmod(struct inode *, umode_t);
> =C2=A0
> =C2=A0#endif /* __RICHACL_H */

Acked-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
