From: Jeff Layton <jlayton@redhat.com>
Subject: Re: [PATCH v23 17/22] richacl: Automatic Inheritance
Date: Tue, 12 Jul 2016 07:56:00 -0400
Message-ID: <1468324560.7798.14.camel@redhat.com>
References: <1467294433-3222-1-git-send-email-agruenba@redhat.com>
	 <1467294433-3222-18-git-send-email-agruenba@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-ext4-owner@vger.kernel.org>
In-Reply-To: <1467294433-3222-18-git-send-email-agruenba@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
To: Andreas Gruenbacher <agruenba@redhat.com>, Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@infradead.org>, Theodore Ts'o <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>, "J. Bruce Fields" <bfields@fieldses.org>, Trond Myklebust <trond.myklebust@primarydata.com>, Anna Schumaker <anna.schumaker@netapp.com>, Dave Chinner <david@fromorbit.com>, linux-ext4@vger.kernel.org, xfs@oss.sgi.com, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org, linux-cifs@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Thu, 2016-06-30 at 15:47 +0200, Andreas Gruenbacher wrote:
> Automatic Inheritance (AI) allows changes to the acl of a directory t=
o
> propagate down to children.
>=20
> This is mostly implemented in user space: when a process changes the
> permissions of a directory and Automatic Inheritance is enabled for t=
hat
> directory, the process must propagate those changes to all children,
> recursively.
>=20
> The kernel enables this by keeping track of which permissions have be=
en
> inherited at create time.=C2=A0=C2=A0In addition, it makes sure that =
permission
> propagation is turned off when the permissions are set explicitly (fo=
r
> example, upon create or chmod).
>=20
> Automatic Inheritance works as follows:
>=20
> =C2=A0- When the RICHACL_AUTO_INHERIT flag in the acl of a file or di=
rectory
> =C2=A0=C2=A0=C2=A0is not set, the file or directory is not affected b=
y AI.
>=20
> =C2=A0- When the RICHACL_AUTO_INHERIT flag in the acl of a directory =
is set
> =C2=A0=C2=A0=C2=A0and a file or subdirectory is created in that direc=
tory, the
> =C2=A0=C2=A0=C2=A0inherited acl will have the RICHACL_AUTO_INHERIT fl=
ag set, and all
> =C2=A0=C2=A0=C2=A0inherited aces will have the RICHACE_INHERITED_ACE =
flag set.=C2=A0=C2=A0This
> =C2=A0=C2=A0=C2=A0allows user space to distinguish between aces which=
 have been
> =C2=A0=C2=A0=C2=A0inherited and aces which have been explicitly added=
=2E
>=20
> =C2=A0- When the RICHACL_PROTECTED acl flag in the acl of a file or d=
irectory
> =C2=A0=C2=A0=C2=A0is set, AI will not modify the acl.=C2=A0=C2=A0This=
 does not affect propagation
> =C2=A0=C2=A0=C2=A0of permissions from the file to its children (if th=
e file is a
> =C2=A0=C2=A0=C2=A0directory).
>=20
> Linux does not have a way of creating files or directories without se=
tting the
> file permission bits, so all files created inside a directory with
> RICHACL_AUTO_INHERIT set will have the RICHACL_PROTECTED flag set.=C2=
=A0=C2=A0This
> effectively disables Automatic Inheritance.
>=20
> Protocols which support creating files without specifying permissions=
 can
> explicitly clear the RICHACL_PROTECTED flag after creating a file and=
 reset the
> file masks to "undo" applying the create mode; see richacl_compute_ma=
x_masks().
> They should set the RICHACL_DEFAULTED flag.=C2=A0=C2=A0(A mechanism t=
hat would allow to
> indicate to the kernel to ignore the create mode in the first place w=
hen there
> are inherited permissions would be nice to have.)
>=20
> Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
> ---
> =C2=A0fs/richacl.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0| 20 +++++++++++++++=
++++-
> =C2=A0include/linux/richacl.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0| 12=
 ++++++++++++
> =C2=A0include/uapi/linux/richacl.h | 11 ++++++++++-
> =C2=A03 files changed, 41 insertions(+), 2 deletions(-)
>=20
> diff --git a/fs/richacl.c b/fs/richacl.c
> index 29eaf89..40e4af9 100644
> --- a/fs/richacl.c
> +++ b/fs/richacl.c
> @@ -573,7 +573,8 @@ __richacl_chmod(struct richacl *acl, umode_t mode=
)
> =C2=A0	=C2=A0=C2=A0=C2=A0=C2=A0acl->a_group_mask =3D=3D group_mask &&
> =C2=A0	=C2=A0=C2=A0=C2=A0=C2=A0acl->a_other_mask =3D=3D other_mask &&
> =C2=A0	=C2=A0=C2=A0=C2=A0=C2=A0(acl->a_flags & RICHACL_MASKED) &&
> -	=C2=A0=C2=A0=C2=A0=C2=A0(acl->a_flags & RICHACL_WRITE_THROUGH))
> +	=C2=A0=C2=A0=C2=A0=C2=A0(acl->a_flags & RICHACL_WRITE_THROUGH) &&
> +	=C2=A0=C2=A0=C2=A0=C2=A0(!richacl_is_auto_inherit(acl) || richacl_i=
s_protected(acl)))
> =C2=A0		return acl;
> =C2=A0
> =C2=A0	clone =3D richacl_clone(acl, GFP_KERNEL);
> @@ -585,6 +586,8 @@ __richacl_chmod(struct richacl *acl, umode_t mode=
)
> =C2=A0	clone->a_owner_mask =3D owner_mask;
> =C2=A0	clone->a_group_mask =3D group_mask;
> =C2=A0	clone->a_other_mask =3D other_mask;
> +	if (richacl_is_auto_inherit(clone))
> +		clone->a_flags |=3D RICHACL_PROTECTED;
> =C2=A0
> =C2=A0	return clone;
> =C2=A0}
> @@ -800,6 +803,14 @@ richacl_inherit(const struct richacl *dir_acl, i=
nt isdir)
> =C2=A0			ace++;
> =C2=A0		}
> =C2=A0	}
> +	if (richacl_is_auto_inherit(dir_acl)) {
> +		acl->a_flags =3D RICHACL_AUTO_INHERIT;
> +		richacl_for_each_entry(ace, acl)
> +			ace->e_flags |=3D RICHACE_INHERITED_ACE;
> +	} else {
> +		richacl_for_each_entry(ace, acl)
> +			ace->e_flags &=3D ~RICHACE_INHERITED_ACE;
> +	}
> =C2=A0
> =C2=A0	return acl;
> =C2=A0}
> @@ -828,6 +839,13 @@ richacl_inherit_inode(const struct richacl *dir_=
acl, umode_t *mode_p)
> =C2=A0			richacl_put(acl);
> =C2=A0			acl =3D NULL;
> =C2=A0		} else {
> +			/*
> +			=C2=A0* We need to set RICHACL_PROTECTED because we are
> +			=C2=A0* doing an implicit chmod
> +			=C2=A0*/
> +			if (richacl_is_auto_inherit(acl))
> +				acl->a_flags |=3D RICHACL_PROTECTED;
> +
> =C2=A0			richacl_compute_max_masks(acl);
> =C2=A0			/*
> =C2=A0			=C2=A0* Ensure that the acl will not grant any permissions
> diff --git a/include/linux/richacl.h b/include/linux/richacl.h
> index 7aca1a3..a442372 100644
> --- a/include/linux/richacl.h
> +++ b/include/linux/richacl.h
> @@ -81,6 +81,18 @@ extern void set_cached_richacl(struct inode *, str=
uct richacl *);
> =C2=A0extern void forget_cached_richacl(struct inode *);
> =C2=A0extern struct richacl *get_richacl(struct inode *);
> =C2=A0
> +static inline int
> +richacl_is_auto_inherit(const struct richacl *acl)
> +{
> +	return acl->a_flags & RICHACL_AUTO_INHERIT;
> +}
> +
> +static inline int
> +richacl_is_protected(const struct richacl *acl)
> +{
> +	return acl->a_flags & RICHACL_PROTECTED;
> +}
> +
> =C2=A0/**
> =C2=A0 * richace_is_owner=C2=A0=C2=A0-=C2=A0=C2=A0check if @ace is an=
 OWNER@ entry
> =C2=A0 */
> diff --git a/include/uapi/linux/richacl.h b/include/uapi/linux/richac=
l.h
> index 1ed48ac..8849a53 100644
> --- a/include/uapi/linux/richacl.h
> +++ b/include/uapi/linux/richacl.h
> @@ -18,6 +18,9 @@
> =C2=A0#define __UAPI_RICHACL_H
> =C2=A0
> =C2=A0/* a_flags values */
> +#define RICHACL_AUTO_INHERIT			0x01
> +#define RICHACL_PROTECTED			0x02
> +#define RICHACL_DEFAULTED			0x04
> =C2=A0#define RICHACL_WRITE_THROUGH			0x40
> =C2=A0#define RICHACL_MASKED				0x80
> =C2=A0
> @@ -31,6 +34,7 @@
> =C2=A0#define RICHACE_NO_PROPAGATE_INHERIT_ACE	0x0004
> =C2=A0#define RICHACE_INHERIT_ONLY_ACE		0x0008
> =C2=A0#define RICHACE_IDENTIFIER_GROUP		0x0040
> +#define RICHACE_INHERITED_ACE			0x0080
> =C2=A0#define RICHACE_SPECIAL_WHO			0x4000
> =C2=A0
> =C2=A0/* e_mask bitflags */
> @@ -60,6 +64,9 @@
> =C2=A0#define RICHACE_EVERYONE_SPECIAL_ID		2
> =C2=A0
> =C2=A0#define RICHACL_VALID_FLAGS (					\
> +	RICHACL_AUTO_INHERIT |					\
> +	RICHACL_PROTECTED |					\
> +	RICHACL_DEFAULTED |					\
> =C2=A0	RICHACL_WRITE_THROUGH |					\
> =C2=A0	RICHACL_MASKED )
> =C2=A0
> @@ -69,13 +76,15 @@
> =C2=A0	RICHACE_NO_PROPAGATE_INHERIT_ACE |			\
> =C2=A0	RICHACE_INHERIT_ONLY_ACE |				\
> =C2=A0	RICHACE_IDENTIFIER_GROUP |				\
> +	RICHACE_INHERITED_ACE |					\
> =C2=A0	RICHACE_SPECIAL_WHO )
> =C2=A0
> =C2=A0#define RICHACE_INHERITANCE_FLAGS (				\
> =C2=A0	RICHACE_FILE_INHERIT_ACE |				\
> =C2=A0	RICHACE_DIRECTORY_INHERIT_ACE |				\
> =C2=A0	RICHACE_NO_PROPAGATE_INHERIT_ACE |			\
> -	RICHACE_INHERIT_ONLY_ACE )
> +	RICHACE_INHERIT_ONLY_ACE |				\
> +	RICHACE_INHERITED_ACE )
> =C2=A0
> =C2=A0/* Valid RICHACE_* flags for directories and non-directories */
> =C2=A0#define RICHACE_VALID_MASK (				=09
> \

Barf. AI seems like a trainwreck waiting to happen. What are the
chances that userland is going to get this right?

Still, I do applaud the fact that you're just doing the bare minimum in
kernel to support userland apps that want this. Thanks for not trying
to push the propagation of the changed ACEs into the kernel.

Reviewed-by: Jeff Layton <jlayton@redhat.com>
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
