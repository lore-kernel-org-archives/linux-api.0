From: Jeff Layton <jlayton@redhat.com>
Subject: Re: [PATCH v23 15/22] richacl: Check if an acl is equivalent to a
 file mode
Date: Tue, 12 Jul 2016 07:39:34 -0400
Message-ID: <1468323574.7798.8.camel@redhat.com>
References: <1467294433-3222-1-git-send-email-agruenba@redhat.com>
	 <1467294433-3222-16-git-send-email-agruenba@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1467294433-3222-16-git-send-email-agruenba@redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Andreas Gruenbacher <agruenba@redhat.com>, Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@infradead.org>, Theodore Ts'o <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>, "J. Bruce Fields" <bfields@fieldses.org>, Trond Myklebust <trond.myklebust@primarydata.com>, Anna Schumaker <anna.schumaker@netapp.com>, Dave Chinner <david@fromorbit.com>, linux-ext4@vger.kernel.org, xfs@oss.sgi.com, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org, linux-cifs@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Thu, 2016-06-30 at 15:47 +0200, Andreas Gruenbacher wrote:
> ACLs are considered equivalent to file modes if they only consist of
> owner@, group@, and everyone@ entries, the owner@ permissions do not
> depend on whether the owner is a member in the owning group, and no
> inheritance flags are set.=C2=A0=C2=A0This test is used to avoid stor=
ing richacls
> if the acl can be computed from the file permission bits.
>=20
> Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
> Reviewed-by: J. Bruce Fields <bfields@redhat.com>
> ---
> =C2=A0fs/richacl.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0| 104 ++++++++++++++++++++++++++++++++++++++++++++=
++++
> =C2=A0include/linux/richacl.h |=C2=A0=C2=A0=C2=A01 +
> =C2=A02 files changed, 105 insertions(+)
>=20
> diff --git a/fs/richacl.c b/fs/richacl.c
> index ba110a6..e8a383b 100644
> --- a/fs/richacl.c
> +++ b/fs/richacl.c
> @@ -618,3 +618,107 @@ richacl_chmod(struct inode *inode, umode_t mode=
)
> =C2=A0	return retval;
> =C2=A0}
> =C2=A0EXPORT_SYMBOL(richacl_chmod);
> +
> +/**
> + * richacl_equiv_mode=C2=A0=C2=A0-=C2=A0=C2=A0compute the mode equiv=
alent of @acl
> + *
> + * An acl is considered equivalent to a file mode if it only consist=
s of
> + * owner@, group@, and everyone@ entries and the owner@ permissions =
do not
> + * depend on whether the owner is a member in the owning group.
> + */
> +int
> +richacl_equiv_mode(const struct richacl *acl, umode_t *mode_p)
> +{
> +	umode_t mode =3D *mode_p;
> +
> +	/*
> +	=C2=A0* The RICHACE_DELETE_CHILD flag is meaningless for non-direct=
ories, so
> +	=C2=A0* we ignore it.
> +	=C2=A0*/
> +	unsigned int x =3D S_ISDIR(mode) ? 0 : RICHACE_DELETE_CHILD;
> +	struct {
> +		unsigned int allowed;
> +		unsigned int defined;=C2=A0=C2=A0/* allowed or denied */
> +	} owner =3D {
> +		.defined =3D RICHACE_POSIX_ALWAYS_ALLOWED |
> +			=C2=A0=C2=A0=C2=A0RICHACE_POSIX_OWNER_ALLOWED=C2=A0=C2=A0| x,
> +	}, group =3D {
> +		.defined =3D RICHACE_POSIX_ALWAYS_ALLOWED | x,
> +	}, everyone =3D {
> +		.defined =3D RICHACE_POSIX_ALWAYS_ALLOWED | x,
> +	};
> +	const struct richace *ace;
> +
> +	if (acl->a_flags & ~(RICHACL_WRITE_THROUGH | RICHACL_MASKED))
> +		return -1;
> +
> +	richacl_for_each_entry(ace, acl) {
> +		if (ace->e_flags & ~RICHACE_SPECIAL_WHO)
> +			return -1;
> +
> +		if (richace_is_owner(ace) || richace_is_everyone(ace)) {
> +			x =3D ace->e_mask & ~owner.defined;
> +			if (richace_is_allow(ace)) {
> +				unsigned int group_denied =3D
> +					group.defined & ~group.allowed;
> +
> +				if (x & group_denied)
> +					return -1;
> +				owner.allowed |=3D x;
> +			} else /* if (richace_is_deny(ace)) */ {
> +				if (x & group.allowed)
> +					return -1;
> +			}
> +			owner.defined |=3D x;
> +
> +			if (richace_is_everyone(ace)) {
> +				x =3D ace->e_mask;
> +				if (richace_is_allow(ace)) {
> +					group.allowed |=3D
> +						x & ~group.defined;
> +					everyone.allowed |=3D
> +						x & ~everyone.defined;
> +				}
> +				group.defined |=3D x;
> +				everyone.defined |=3D x;
> +			}
> +		} else if (richace_is_group(ace)) {
> +			x =3D ace->e_mask & ~group.defined;
> +			if (richace_is_allow(ace))
> +				group.allowed |=3D x;
> +			group.defined |=3D x;
> +		} else
> +			return -1;
> +	}
> +
> +	if (group.allowed & ~owner.defined)
> +		return -1;
> +
> +	if (acl->a_flags & RICHACL_MASKED) {
> +		if (acl->a_flags & RICHACL_WRITE_THROUGH) {
> +			owner.allowed =3D acl->a_owner_mask;
> +			everyone.allowed =3D acl->a_other_mask;
> +		} else {
> +			owner.allowed &=3D acl->a_owner_mask;
> +			everyone.allowed &=3D acl->a_other_mask;
> +		}
> +		group.allowed &=3D acl->a_group_mask;
> +	}
> +
> +	mode =3D (mode & ~S_IRWXUGO) |
> +	=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0(richacl_mask_to_mode(own=
er.allowed) << 6) |
> +	=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0(richacl_mask_to_mode(gro=
up.allowed) << 3) |
> +		richacl_mask_to_mode(everyone.allowed);
> +
> +	/* Mask flags we can ignore */
> +	x =3D S_ISDIR(mode) ? 0 : RICHACE_DELETE_CHILD;
> +
> +	if (((richacl_mode_to_mask(mode >> 6) ^ owner.allowed)=C2=A0=C2=A0=C2=
=A0=C2=A0& ~x) ||
> +	=C2=A0=C2=A0=C2=A0=C2=A0((richacl_mode_to_mask(mode >> 3) ^ group.a=
llowed)=C2=A0=C2=A0=C2=A0=C2=A0& ~x) ||
> +	=C2=A0=C2=A0=C2=A0=C2=A0((richacl_mode_to_mask(mode)=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0^ everyone.allowed) & ~x))
> +		return -1;
> +
> +	*mode_p =3D mode;
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(richacl_equiv_mode);
> diff --git a/include/linux/richacl.h b/include/linux/richacl.h
> index db82fab..9212edb 100644
> --- a/include/linux/richacl.h
> +++ b/include/linux/richacl.h
> @@ -191,5 +191,6 @@ extern unsigned int richacl_want_to_mask(unsigned=
 int);
> =C2=A0extern void richacl_compute_max_masks(struct richacl *);
> =C2=A0extern int richacl_permission(struct inode *, const struct rich=
acl *, int);
> =C2=A0extern int richacl_chmod(struct inode *, umode_t);
> +extern int richacl_equiv_mode(const struct richacl *, umode_t *);
> =C2=A0
> =C2=A0#endif /* __RICHACL_H */

Reviewed-by: Jeff Layton <jlayton@redhat.com>
--
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel=
" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
