From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v23 10/22] posix_acl: Improve xattr fixup code
Date: Tue, 05 Jul 2016 11:38:50 -0400
Message-ID: <1467733130.3800.36.camel@redhat.com>
References: <1467294433-3222-1-git-send-email-agruenba@redhat.com>
	 <1467294433-3222-11-git-send-email-agruenba@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1467294433-3222-11-git-send-email-agruenba-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andreas Gruenbacher <agruenba-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Andreas Dilger <adilger.kernel-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>, "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>, Trond Myklebust <trond.myklebust-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>, Anna Schumaker <anna.schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>, Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, xfs-VZNHf3L845pBDgjK7y7TUQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Thu, 2016-06-30 at 15:47 +0200, Andreas Gruenbacher wrote:
> Both XATTR_NAME_POSIX_ACL_ACCESS and XATTR_NAME_POSIX_ACL_DEFAULT hav=
e
> the same XATTR_SYSTEM_PREFIX prefix; don't check for the same prefix
> repeatedly.
>=20
> Signed-off-by: Andreas Gruenbacher <agruenba-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Reviewed-by: Steve French <steve.french-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>
> ---
> =C2=A0fs/xattr.c | 29 +++++++++++++++++++++++------
> =C2=A01 file changed, 23 insertions(+), 6 deletions(-)
>=20
> diff --git a/fs/xattr.c b/fs/xattr.c
> index 4beafc4..61ac218 100644
> --- a/fs/xattr.c
> +++ b/fs/xattr.c
> @@ -295,6 +295,16 @@ out:
> =C2=A0}
> =C2=A0EXPORT_SYMBOL_GPL(vfs_removexattr);
> =C2=A0
> +static void
> +fix_xattr_from_user(const char *kname, void *kvalue, size_t size)
> +{
> +	if (strncmp(kname, XATTR_SYSTEM_PREFIX, XATTR_SYSTEM_PREFIX_LEN))
> +		return;
> +	kname +=3D XATTR_SYSTEM_PREFIX_LEN;
> +	if (!strcmp(kname, XATTR_POSIX_ACL_ACCESS) ||
> +	=C2=A0=C2=A0=C2=A0=C2=A0!strcmp(kname, XATTR_POSIX_ACL_DEFAULT))
> +		posix_acl_fix_xattr_from_user(kvalue, size);
> +}
> =C2=A0
> =C2=A0/*
> =C2=A0 * Extended attribute SET operations
> @@ -329,9 +339,7 @@ setxattr(struct dentry *d, const char __user *nam=
e, const void __user *value,
> =C2=A0			error =3D -EFAULT;
> =C2=A0			goto out;
> =C2=A0		}
> -		if ((strcmp(kname, XATTR_NAME_POSIX_ACL_ACCESS) =3D=3D 0) ||
> -		=C2=A0=C2=A0=C2=A0=C2=A0(strcmp(kname, XATTR_NAME_POSIX_ACL_DEFAUL=
T) =3D=3D 0))
> -			posix_acl_fix_xattr_from_user(kvalue, size);
> +		fix_xattr_from_user(kname, kvalue, size);
> =C2=A0	}
> =C2=A0
> =C2=A0	error =3D vfs_setxattr(d, kname, kvalue, size, flags);
> @@ -396,6 +404,17 @@ SYSCALL_DEFINE5(fsetxattr, int, fd, const char _=
_user *, name,
> =C2=A0	return error;
> =C2=A0}
> =C2=A0
> +static void
> +fix_xattr_to_user(const char *kname, void *kvalue, size_t size)
> +{
> +	if (strncmp(kname, XATTR_SYSTEM_PREFIX, XATTR_SYSTEM_PREFIX_LEN))
> +		return;
> +	kname +=3D XATTR_SYSTEM_PREFIX_LEN;
> +	if (!strcmp(kname, XATTR_POSIX_ACL_ACCESS) ||
> +	=C2=A0=C2=A0=C2=A0=C2=A0!strcmp(kname, XATTR_POSIX_ACL_DEFAULT))
> +		posix_acl_fix_xattr_to_user(kvalue, size);
> +}
> +
> =C2=A0/*
> =C2=A0 * Extended attribute GET operations
> =C2=A0 */
> @@ -426,9 +445,7 @@ getxattr(struct dentry *d, const char __user *nam=
e, void __user *value,
> =C2=A0
> =C2=A0	error =3D vfs_getxattr(d, kname, kvalue, size);
> =C2=A0	if (error > 0) {
> -		if ((strcmp(kname, XATTR_NAME_POSIX_ACL_ACCESS) =3D=3D 0) ||
> -		=C2=A0=C2=A0=C2=A0=C2=A0(strcmp(kname, XATTR_NAME_POSIX_ACL_DEFAUL=
T) =3D=3D 0))
> -			posix_acl_fix_xattr_to_user(kvalue, size);
> +		fix_xattr_to_user(kname, kvalue, size);
> =C2=A0		if (size && copy_to_user(value, kvalue, error))
> =C2=A0			error =3D -EFAULT;
> =C2=A0	} else if (error =3D=3D -ERANGE && size >=3D XATTR_SIZE_MAX) {

Might be nice to move this one to the head of the queue. I don't see it
as being a controversial change, and it could go in before the rest of
the patches.

Reviewed-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
