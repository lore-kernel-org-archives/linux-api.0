From: Jeff Layton <jlayton@redhat.com>
Subject: Re: [PATCH v23 20/22] vfs: Add richacl permission checking
Date: Tue, 12 Jul 2016 08:13:54 -0400
Message-ID: <1468325634.7798.24.camel@redhat.com>
References: <1467294433-3222-1-git-send-email-agruenba@redhat.com>
	 <1467294433-3222-21-git-send-email-agruenba@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1467294433-3222-21-git-send-email-agruenba@redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Andreas Gruenbacher <agruenba@redhat.com>, Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@infradead.org>, Theodore Ts'o <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>, "J. Bruce Fields" <bfields@fieldses.org>, Trond Myklebust <trond.myklebust@primarydata.com>, Anna Schumaker <anna.schumaker@netapp.com>, Dave Chinner <david@fromorbit.com>, linux-ext4@vger.kernel.org, xfs@oss.sgi.com, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org, linux-cifs@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Thu, 2016-06-30 at 15:47 +0200, Andreas Gruenbacher wrote:
> Hook the richacl permission checking function into the vfs.
>=20
> Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
> ---
> =C2=A0fs/namei.c | 54 +++++++++++++++++++++++++++++++++++++++++++++++=
+++++--
> =C2=A01 file changed, 52 insertions(+), 2 deletions(-)
>=20
> diff --git a/fs/namei.c b/fs/namei.c
> index 7a822d0..48c9958 100644
> --- a/fs/namei.c
> +++ b/fs/namei.c
> @@ -34,6 +34,7 @@
> =C2=A0#include=20
> =C2=A0#include=20
> =C2=A0#include=20
> +#include=20
> =C2=A0#include=20
> =C2=A0#include=20
> =C2=A0#include=20
> @@ -256,7 +257,43 @@ void putname(struct filename *name)
> =C2=A0		__putname(name);
> =C2=A0}
> =C2=A0
> -static int check_acl(struct inode *inode, int mask)
> +static int check_richacl(struct inode *inode, int mask)
> +{
> +#ifdef CONFIG_FS_RICHACL
> +	if (mask & MAY_NOT_BLOCK) {
> +		struct base_acl *base_acl;
> +
> +		base_acl =3D rcu_dereference(inode->i_acl);
> +		if (!base_acl)
> +			goto no_acl;
> +		/* no ->get_richacl() calls in RCU mode... */
> +		if (is_uncached_acl(base_acl))
> +			return -ECHILD;
> +		return richacl_permission(inode, richacl(base_acl),
> +					=C2=A0=C2=A0mask & ~MAY_NOT_BLOCK);
> +	} else {
> +		struct richacl *acl;
> +
> +		acl =3D get_richacl(inode);
> +		if (IS_ERR(acl))
> +			return PTR_ERR(acl);
> +		if (acl) {
> +			int error =3D richacl_permission(inode, acl, mask);
> +			richacl_put(acl);
> +			return error;
> +		}
> +	}
> +no_acl:
> +#endif

nit: Can you move the above to a static inline or something that become=
s a noop when the config var is turned off?

> +	if (mask & (MAY_DELETE_SELF | MAY_TAKE_OWNERSHIP |
> +		=C2=A0=C2=A0=C2=A0=C2=A0MAY_CHMOD | MAY_SET_TIMES)) {
> +		/* File permission bits cannot grant this. */
> +		return -EACCES;
> +	}
> +	return -EAGAIN;
> +}
> +
> +static int check_posix_acl(struct inode *inode, int mask)
> =C2=A0{
> =C2=A0#ifdef CONFIG_FS_POSIX_ACL
> =C2=A0	if (mask & MAY_NOT_BLOCK) {
> @@ -294,11 +331,24 @@ static int acl_permission_check(struct inode *i=
node, int mask)
> =C2=A0{
> =C2=A0	unsigned int mode =3D inode->i_mode;
> =C2=A0
> +	/*
> +	=C2=A0* With POSIX ACLs, the (mode & S_IRWXU) bits exactly match th=
e owner
> +	=C2=A0* permissions, and we can skip checking posix acls for the ow=
ner.
> +	=C2=A0* With richacls, the owner may be granted fewer permissions t=
han the
> +	=C2=A0* mode bits seem to suggest (for example, append but not writ=
e), and
> +	=C2=A0* we always need to check the richacl.
> +	=C2=A0*/
> +
> +	if (IS_RICHACL(inode)) {
> +		int error =3D check_richacl(inode, mask);
> +		if (error !=3D -EAGAIN)
> +			return error;
> +	}
> =C2=A0	if (likely(uid_eq(current_fsuid(), inode->i_uid)))
> =C2=A0		mode >>=3D 6;
> =C2=A0	else {
> =C2=A0		if (IS_POSIXACL(inode) && (mode & S_IRWXG)) {
> -			int error =3D check_acl(inode, mask);
> +			int error =3D check_posix_acl(inode, mask);
> =C2=A0			if (error !=3D -EAGAIN)
> =C2=A0				return error;
> =C2=A0		}

Looks fine other than the nit above:

Reviewed-by: Jeff Layton <jlayton@redhat.com>
--
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel=
" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
