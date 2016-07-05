From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v23 08/22] richacl: Compute maximum file masks from an
 acl
Date: Tue, 05 Jul 2016 10:22:17 -0400
Message-ID: <1467728537.3800.32.camel@redhat.com>
References: <1467294433-3222-1-git-send-email-agruenba@redhat.com>
	 <1467294433-3222-9-git-send-email-agruenba@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1467294433-3222-9-git-send-email-agruenba-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andreas Gruenbacher <agruenba-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Andreas Dilger <adilger.kernel-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>, "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>, Trond Myklebust <trond.myklebust-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>, Anna Schumaker <anna.schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>, Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, xfs-VZNHf3L845pBDgjK7y7TUQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Thu, 2016-06-30 at 15:46 +0200, Andreas Gruenbacher wrote:
> Compute upper bound owner, group, and other file masks with as few
> permissions as possible without denying any permissions that the NFSv=
4
> acl in a richacl grants.
>=20
> This algorithm is used when a file inherits an acl at create time and
> when an acl is set via a mechanism that does not provide file masks
> (such as setting an acl via nfsd).=C2=A0=C2=A0When user-space sets an=
 acl via
> setxattr, the extended attribute already includes the file masks.
>=20
> Setting an acl also sets the file mode permission bits: they are
> determined by the file masks; see richacl_masks_to_mode().
>=20
> Signed-off-by: Andreas Gruenbacher <agruenba-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Reviewed-by: J. Bruce Fields <bfields-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
> =C2=A0fs/richacl.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0| 157 ++++++++++++++++++++++++++++++++++++++++++++=
++++
> =C2=A0include/linux/richacl.h |=C2=A0=C2=A0=C2=A01 +
> =C2=A02 files changed, 158 insertions(+)
>=20
> diff --git a/fs/richacl.c b/fs/richacl.c
> index d0a4135..056228f 100644
> --- a/fs/richacl.c
> +++ b/fs/richacl.c
> @@ -181,3 +181,160 @@ richacl_want_to_mask(unsigned int want)
> =C2=A0	return mask;
> =C2=A0}
> =C2=A0EXPORT_SYMBOL_GPL(richacl_want_to_mask);
> +
> +/*
> + * Note: functions like richacl_allowed_to_who(), richacl_group_clas=
s_allowed(),
> + * and richacl_compute_max_masks() iterate through the entire acl in=
 reverse
> + * order as an optimization.
> + *
> + * In the standard algorithm, aces are considered in forward order.=C2=
=A0=C2=A0When a
> + * process matches an ace, the permissions in the ace are either all=
owed or
> + * denied depending on the ace type.=C2=A0=C2=A0Once a permission ha=
s been allowed or
> + * denied, it is no longer considered in further aces.
> + *
> + * By iterating through the acl in reverse order, we can compute the=
 same
> + * result without having to keep track of which permissions have bee=
n allowed
> + * and denied already.
> + */
>=20

Clever!


> +
> +/**
> + * richacl_allowed_to_who=C2=A0=C2=A0-=C2=A0=C2=A0permissions allowe=
d to a specific who value
> + *
> + * Compute the maximum mask values allowed to a specific who value, =
taking
> + * everyone@ aces into account.
> + */
> +static unsigned int richacl_allowed_to_who(struct richacl *acl,
> +					=C2=A0=C2=A0=C2=A0struct richace *who)
> +{
> +	struct richace *ace;
> +	unsigned int allowed =3D 0;
> +
> +	richacl_for_each_entry_reverse(ace, acl) {
> +		if (richace_is_inherit_only(ace))
> +			continue;
> +		if (richace_is_same_identifier(ace, who) ||
> +		=C2=A0=C2=A0=C2=A0=C2=A0richace_is_everyone(ace)) {
> +			if (richace_is_allow(ace))
> +				allowed |=3D ace->e_mask;
> +			else if (richace_is_deny(ace))
> +				allowed &=3D ~ace->e_mask;
> +		}
> +	}
> +	return allowed;
> +}
> +
> +/**
> + * richacl_group_class_allowed=C2=A0=C2=A0-=C2=A0=C2=A0maximum permi=
ssions of the group class
> + *
> + * Compute the maximum mask values allowed to a process in the group=
 class
> + * (i.e., a process which is not the owner but is in the owning grou=
p or
> + * matches a user or group acl entry).=C2=A0=C2=A0This includes perm=
issions granted or
> + * denied by everyone@ aces.
> + *
> + * See richacl_compute_max_masks().
> + */
> +static unsigned int richacl_group_class_allowed(struct richacl *acl)
> +{
> +	struct richace *ace;
> +	unsigned int everyone_allowed =3D 0, group_class_allowed =3D 0;
> +	int had_group_ace =3D 0;
> +
> +	richacl_for_each_entry_reverse(ace, acl) {
> +		if (richace_is_inherit_only(ace) ||
> +		=C2=A0=C2=A0=C2=A0=C2=A0richace_is_owner(ace))
> +			continue;
> +
> +		if (richace_is_everyone(ace)) {
> +			if (richace_is_allow(ace))
> +				everyone_allowed |=3D ace->e_mask;
> +			else if (richace_is_deny(ace))
> +				everyone_allowed &=3D ~ace->e_mask;
> +		} else {
> +			group_class_allowed |=3D
> +				richacl_allowed_to_who(acl, ace);
> +
> +			if (richace_is_group(ace))
> +				had_group_ace =3D 1;
> +		}
> +	}
> +	/*
> +	=C2=A0* If the acl doesn't contain any group@ aces, richacl_allowed=
_to_who()
> +	=C2=A0* wasn't called for the owning group.=C2=A0=C2=A0We could mak=
e that call now, but
> +	=C2=A0* we already know the result (everyone_allowed).
> +	=C2=A0*/
> +	if (!had_group_ace)
> +		group_class_allowed |=3D everyone_allowed;
> +	return group_class_allowed;
> +}
> +
> +/**
> + * richacl_compute_max_masks=C2=A0=C2=A0-=C2=A0=C2=A0compute upper b=
ound masks
> + *
> + * Computes upper bound owner, group, and other masks so that none o=
f the
> + * permissions allowed by the acl are disabled.
> + *
> + * We don't make assumptions about who the owner is so that the owne=
r can
> + * change with no effect on the file masks or file mode permission b=
its; this
> + * means that we must assume that all entries can match the owner.
> + */
> +void richacl_compute_max_masks(struct richacl *acl)
> +{
> +	unsigned int gmask =3D ~0;
> +	struct richace *ace;
> +
> +	/*
> +	=C2=A0* @gmask contains all permissions which the group class is ev=
er
> +	=C2=A0* allowed.=C2=A0=C2=A0We use it to avoid adding permissions t=
o the group mask
> +	=C2=A0* from everyone@ allow aces which the group class is always d=
enied
> +	=C2=A0* through other aces.=C2=A0=C2=A0For example, the following a=
cl would otherwise
> +	=C2=A0* result in a group mask of rw:
> +	=C2=A0*
> +	=C2=A0*	group@:w::deny
> +	=C2=A0*	everyone@:rw::allow
> +	=C2=A0*
> +	=C2=A0* Avoid computing @gmask for acls which do not include any gr=
oup class
> +	=C2=A0* deny aces: in such acls, the group class is never denied an=
y
> +	=C2=A0* permissions from everyone@ allow aces, and the group class =
cannot
> +	=C2=A0* have fewer permissions than the other class.
> +	=C2=A0*/
> +
> +restart:
> +	acl->a_owner_mask =3D 0;
> +	acl->a_group_mask =3D 0;
> +	acl->a_other_mask =3D 0;
> +
> +	richacl_for_each_entry_reverse(ace, acl) {
> +		if (richace_is_inherit_only(ace))
> +			continue;
> +
> +		if (richace_is_owner(ace)) {
> +			if (richace_is_allow(ace))
> +				acl->a_owner_mask |=3D ace->e_mask;
> +			else if (richace_is_deny(ace))
> +				acl->a_owner_mask &=3D ~ace->e_mask;
> +		} else if (richace_is_everyone(ace)) {
> +			if (richace_is_allow(ace)) {
> +				acl->a_owner_mask |=3D ace->e_mask;
> +				acl->a_group_mask |=3D ace->e_mask & gmask;
> +				acl->a_other_mask |=3D ace->e_mask;
> +			} else if (richace_is_deny(ace)) {
> +				acl->a_owner_mask &=3D ~ace->e_mask;
> +				acl->a_group_mask &=3D ~ace->e_mask;
> +				acl->a_other_mask &=3D ~ace->e_mask;
> +			}
> +		} else {
> +			if (richace_is_allow(ace)) {
> +				acl->a_owner_mask |=3D ace->e_mask & gmask;
> +				acl->a_group_mask |=3D ace->e_mask & gmask;
> +			} else if (richace_is_deny(ace) && gmask =3D=3D ~0) {
> +				gmask =3D richacl_group_class_allowed(acl);
> +				if (likely(gmask !=3D ~0))
> +					/* should always be true */
> +					goto restart;
> +			}
> +		}
> +	}
> +
> +	acl->a_flags &=3D ~(RICHACL_WRITE_THROUGH | RICHACL_MASKED);
> +}
> +EXPORT_SYMBOL_GPL(richacl_compute_max_masks);
> diff --git a/include/linux/richacl.h b/include/linux/richacl.h
> index 9102ef0..3559b2c 100644
> --- a/include/linux/richacl.h
> +++ b/include/linux/richacl.h
> @@ -178,5 +178,6 @@ extern void richace_copy(struct richace *, const =
struct richace *);
> =C2=A0extern int richacl_masks_to_mode(const struct richacl *);
> =C2=A0extern unsigned int richacl_mode_to_mask(umode_t);
> =C2=A0extern unsigned int richacl_want_to_mask(unsigned int);
> +extern void richacl_compute_max_masks(struct richacl *);
> =C2=A0
> =C2=A0#endif /* __RICHACL_H */

Reviewed-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
