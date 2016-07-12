From: Jeff Layton <jlayton@redhat.com>
Subject: Re: [PATCH v23 19/22] richacl: Add richacl xattr handler
Date: Tue, 12 Jul 2016 08:13:30 -0400
Message-ID: <1468325610.7798.23.camel@redhat.com>
References: <1467294433-3222-1-git-send-email-agruenba@redhat.com>
	 <1467294433-3222-20-git-send-email-agruenba@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1467294433-3222-20-git-send-email-agruenba@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andreas Gruenbacher <agruenba@redhat.com>, Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@infradead.org>, Theodore Ts'o <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>, "J. Bruce Fields" <bfields@fieldses.org>, Trond Myklebust <trond.myklebust@primarydata.com>, Anna Schumaker <anna.schumaker@netapp.com>, Dave Chinner <david@fromorbit.com>, linux-ext4@vger.kernel.org, xfs@oss.sgi.com, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org, linux-cifs@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Thu, 2016-06-30 at 15:47 +0200, Andreas Gruenbacher wrote:
> Add richacl xattr handler implementing the xattr operations based on =
the
> get_richacl and set_richacl inode operations.
>=20
> Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
> ---
> =C2=A0fs/richacl.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0| 22 +++++++++=
+++++++
> =C2=A0fs/richacl_xattr.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0| 61 +++++++++++++++++++++++++++++++++++++++=
++++
> =C2=A0include/linux/richacl.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
|=C2=A0=C2=A01 +
> =C2=A0include/linux/richacl_xattr.h |=C2=A0=C2=A02 ++
> =C2=A04 files changed, 86 insertions(+)
>=20
> diff --git a/fs/richacl.c b/fs/richacl.c
> index 40e4af9..b7d7104 100644
> --- a/fs/richacl.c
> +++ b/fs/richacl.c
> @@ -549,6 +549,28 @@ out:
> =C2=A0EXPORT_SYMBOL_GPL(richacl_permission);
> =C2=A0
> =C2=A0/**
> + * set_richacl=C2=A0=C2=A0-=C2=A0=C2=A0set the richacl of an inode
> + * @inode:	inode whose richacl to set
> + * @acl:	access control list
> + */
> +int
> +set_richacl(struct inode *inode, struct richacl *acl)
> +{
> +	if (!IS_RICHACL(inode))
> +		return -EOPNOTSUPP;
> +	if (!inode->i_op->set_richacl)
> +		return -EOPNOTSUPP;
> +
> +	if (!uid_eq(current_fsuid(), inode->i_uid) &&
> +	=C2=A0=C2=A0=C2=A0=C2=A0inode_permission(inode, MAY_CHMOD) &&
> +	=C2=A0=C2=A0=C2=A0=C2=A0!capable(CAP_FOWNER))
> +		return -EPERM;
> +
> +	return inode->i_op->set_richacl(inode, acl);
> +}
> +EXPORT_SYMBOL(set_richacl);
> +
> +/**
> =C2=A0 * __richacl_chmod=C2=A0=C2=A0-=C2=A0=C2=A0update the file mask=
s to reflect the new mode
> =C2=A0 * @acl:	access control list
> =C2=A0 * @mode:	new file permission bits including the file type
> diff --git a/fs/richacl_xattr.c b/fs/richacl_xattr.c
> index dc1ad36..5eb4aba 100644
> --- a/fs/richacl_xattr.c
> +++ b/fs/richacl_xattr.c
> @@ -18,7 +18,9 @@
> =C2=A0#include=20
> =C2=A0#include=20
> =C2=A0#include=20
> +#include=20
> =C2=A0#include=20
> +#include=20
> =C2=A0
> =C2=A0/**
> =C2=A0 * richacl_from_xattr=C2=A0=C2=A0-=C2=A0=C2=A0convert a richacl=
 xattr into the in-memory representation
> @@ -159,3 +161,62 @@ richacl_to_xattr(struct user_namespace *user_ns,
> =C2=A0	return real_size;
> =C2=A0}
> =C2=A0EXPORT_SYMBOL_GPL(richacl_to_xattr);
> +
> +static bool
> +richacl_xattr_list(struct dentry *dentry)
> +{
> +	return IS_RICHACL(d_backing_inode(dentry));
> +}
> +
> +static int
> +richacl_xattr_get(const struct xattr_handler *handler,
> +		=C2=A0=C2=A0struct dentry *unused, struct inode *inode,
> +		=C2=A0=C2=A0const char *name, void *buffer, size_t buffer_size)
> +{
> +	struct richacl *acl;
> +	int error;
> +
> +	if (*name)
> +		return -EINVAL;
> +	if (!IS_RICHACL(inode))
> +		return -EOPNOTSUPP;
> +	if (S_ISLNK(inode->i_mode))
> +		return -EOPNOTSUPP;
> +	acl =3D get_richacl(inode);
> +	if (IS_ERR(acl))
> +		return PTR_ERR(acl);
> +	if (acl =3D=3D NULL)
> +		return -ENODATA;
> +	error =3D richacl_to_xattr(current_user_ns(), acl, buffer, buffer_s=
ize);
> +	richacl_put(acl);
> +	return error;
> +}
> +
> +static int
> +richacl_xattr_set(const struct xattr_handler *handler,
> +		=C2=A0=C2=A0struct dentry *unused, struct inode *inode,
> +		=C2=A0=C2=A0const char *name, const void *value, size_t size,
> +		=C2=A0=C2=A0int flags)
> +{
> +	struct richacl *acl =3D NULL;
> +	int ret;
> +
> +	if (value) {
> +		acl =3D richacl_from_xattr(current_user_ns(), value, size,
> +					=C2=A0-EINVAL);
> +		if (IS_ERR(acl))
> +			return PTR_ERR(acl);
> +	}
> +
> +	ret =3D set_richacl(inode, acl);
> +	richacl_put(acl);
> +	return ret;
> +}
> +
> +struct xattr_handler richacl_xattr_handler =3D {
> +	.name =3D XATTR_NAME_RICHACL,
> +	.list =3D richacl_xattr_list,
> +	.get =3D richacl_xattr_get,
> +	.set =3D richacl_xattr_set,
> +};
> +EXPORT_SYMBOL(richacl_xattr_handler);
> diff --git a/include/linux/richacl.h b/include/linux/richacl.h
> index a442372..e7db066 100644
> --- a/include/linux/richacl.h
> +++ b/include/linux/richacl.h
> @@ -206,5 +206,6 @@ extern int richacl_chmod(struct inode *, umode_t)=
;
> =C2=A0extern int richacl_equiv_mode(const struct richacl *, umode_t *=
);
> =C2=A0extern struct richacl *richacl_inherit(const struct richacl *, =
int);
> =C2=A0extern struct richacl *richacl_create(umode_t *, struct inode *=
);
> +extern int set_richacl(struct inode *, struct richacl *);
> =C2=A0
> =C2=A0#endif /* __RICHACL_H */
> diff --git a/include/linux/richacl_xattr.h b/include/linux/richacl_xa=
ttr.h
> index 0efa14b..6c6adb1 100644
> --- a/include/linux/richacl_xattr.h
> +++ b/include/linux/richacl_xattr.h
> @@ -26,4 +26,6 @@ extern size_t richacl_xattr_size(const struct richa=
cl *);
> =C2=A0extern int richacl_to_xattr(struct user_namespace *, const stru=
ct richacl *,
> =C2=A0			=C2=A0=C2=A0=C2=A0=C2=A0void *, size_t);
> =C2=A0
> +extern struct xattr_handler richacl_xattr_handler;
> +
> =C2=A0#endif /* __RICHACL_XATTR_H */

Cue same refrain about syscalls vs. xattrs. Otherwise:

Reviewed-by: Jeff Layton <jlayton@redhat.com>
