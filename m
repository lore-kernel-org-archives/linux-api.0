From: "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>
Subject: Re: [PATCH v23 17/22] richacl: Automatic Inheritance
Date: Tue, 12 Jul 2016 15:11:42 -0400
Message-ID: <20160712191142.GE449@fieldses.org>
References: <1467294433-3222-1-git-send-email-agruenba@redhat.com>
 <1467294433-3222-18-git-send-email-agruenba@redhat.com>
 <1468324560.7798.14.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1468324560.7798.14.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Andreas Gruenbacher <agruenba-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Andreas Dilger <adilger.kernel-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>, Trond Myklebust <trond.myklebust-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>, Anna Schumaker <anna.schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>, Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, xfs-VZNHf3L845pBDgjK7y7TUQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Tue, Jul 12, 2016 at 07:56:00AM -0400, Jeff Layton wrote:
> On Thu, 2016-06-30 at 15:47 +0200, Andreas Gruenbacher wrote:
> > Automatic Inheritance (AI) allows changes to the acl of a directory=
 to
> > propagate down to children.
> >=20
> > This is mostly implemented in user space: when a process changes th=
e
> > permissions of a directory and Automatic Inheritance is enabled for=
 that
> > directory, the process must propagate those changes to all children=
,
> > recursively.
> >=20
> > The kernel enables this by keeping track of which permissions have =
been
> > inherited at create time.=C2=A0=C2=A0In addition, it makes sure tha=
t permission
> > propagation is turned off when the permissions are set explicitly (=
for
> > example, upon create or chmod).
> >=20
> > Automatic Inheritance works as follows:
> >=20
> > =C2=A0- When the RICHACL_AUTO_INHERIT flag in the acl of a file or =
directory
> > =C2=A0=C2=A0=C2=A0is not set, the file or directory is not affected=
 by AI.
> >=20
> > =C2=A0- When the RICHACL_AUTO_INHERIT flag in the acl of a director=
y is set
> > =C2=A0=C2=A0=C2=A0and a file or subdirectory is created in that dir=
ectory, the
> > =C2=A0=C2=A0=C2=A0inherited acl will have the RICHACL_AUTO_INHERIT =
flag set, and all
> > =C2=A0=C2=A0=C2=A0inherited aces will have the RICHACE_INHERITED_AC=
E flag set.=C2=A0=C2=A0This
> > =C2=A0=C2=A0=C2=A0allows user space to distinguish between aces whi=
ch have been
> > =C2=A0=C2=A0=C2=A0inherited and aces which have been explicitly add=
ed.
> >=20
> > =C2=A0- When the RICHACL_PROTECTED acl flag in the acl of a file or=
 directory
> > =C2=A0=C2=A0=C2=A0is set, AI will not modify the acl.=C2=A0=C2=A0Th=
is does not affect propagation
> > =C2=A0=C2=A0=C2=A0of permissions from the file to its children (if =
the file is a
> > =C2=A0=C2=A0=C2=A0directory).
> >=20
> > Linux does not have a way of creating files or directories without =
setting the
> > file permission bits, so all files created inside a directory with
> > RICHACL_AUTO_INHERIT set will have the RICHACL_PROTECTED flag set.=C2=
=A0=C2=A0This
> > effectively disables Automatic Inheritance.
> >=20
> > Protocols which support creating files without specifying permissio=
ns can
> > explicitly clear the RICHACL_PROTECTED flag after creating a file a=
nd reset the
> > file masks to "undo" applying the create mode; see richacl_compute_=
max_masks().
> > They should set the RICHACL_DEFAULTED flag.=C2=A0=C2=A0(A mechanism=
 that would allow to
> > indicate to the kernel to ignore the create mode in the first place=
 when there
> > are inherited permissions would be nice to have.)
> >=20
> > Signed-off-by: Andreas Gruenbacher <agruenba-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > ---
> > =C2=A0fs/richacl.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0| 20 +++++++++++++++=
++++-
> > =C2=A0include/linux/richacl.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0| =
12 ++++++++++++
> > =C2=A0include/uapi/linux/richacl.h | 11 ++++++++++-
> > =C2=A03 files changed, 41 insertions(+), 2 deletions(-)
> >=20
> > diff --git a/fs/richacl.c b/fs/richacl.c
> > index 29eaf89..40e4af9 100644
> > --- a/fs/richacl.c
> > +++ b/fs/richacl.c
> > @@ -573,7 +573,8 @@ __richacl_chmod(struct richacl *acl, umode_t mo=
de)
> > =C2=A0	=C2=A0=C2=A0=C2=A0=C2=A0acl->a_group_mask =3D=3D group_mask =
&&
> > =C2=A0	=C2=A0=C2=A0=C2=A0=C2=A0acl->a_other_mask =3D=3D other_mask =
&&
> > =C2=A0	=C2=A0=C2=A0=C2=A0=C2=A0(acl->a_flags & RICHACL_MASKED) &&
> > -	=C2=A0=C2=A0=C2=A0=C2=A0(acl->a_flags & RICHACL_WRITE_THROUGH))
> > +	=C2=A0=C2=A0=C2=A0=C2=A0(acl->a_flags & RICHACL_WRITE_THROUGH) &&
> > +	=C2=A0=C2=A0=C2=A0=C2=A0(!richacl_is_auto_inherit(acl) || richacl=
_is_protected(acl)))
> > =C2=A0		return acl;
> > =C2=A0
> > =C2=A0	clone =3D richacl_clone(acl, GFP_KERNEL);
> > @@ -585,6 +586,8 @@ __richacl_chmod(struct richacl *acl, umode_t mo=
de)
> > =C2=A0	clone->a_owner_mask =3D owner_mask;
> > =C2=A0	clone->a_group_mask =3D group_mask;
> > =C2=A0	clone->a_other_mask =3D other_mask;
> > +	if (richacl_is_auto_inherit(clone))
> > +		clone->a_flags |=3D RICHACL_PROTECTED;
> > =C2=A0
> > =C2=A0	return clone;
> > =C2=A0}
> > @@ -800,6 +803,14 @@ richacl_inherit(const struct richacl *dir_acl,=
 int isdir)
> > =C2=A0			ace++;
> > =C2=A0		}
> > =C2=A0	}
> > +	if (richacl_is_auto_inherit(dir_acl)) {
> > +		acl->a_flags =3D RICHACL_AUTO_INHERIT;
> > +		richacl_for_each_entry(ace, acl)
> > +			ace->e_flags |=3D RICHACE_INHERITED_ACE;
> > +	} else {
> > +		richacl_for_each_entry(ace, acl)
> > +			ace->e_flags &=3D ~RICHACE_INHERITED_ACE;
> > +	}
> > =C2=A0
> > =C2=A0	return acl;
> > =C2=A0}
> > @@ -828,6 +839,13 @@ richacl_inherit_inode(const struct richacl *di=
r_acl, umode_t *mode_p)
> > =C2=A0			richacl_put(acl);
> > =C2=A0			acl =3D NULL;
> > =C2=A0		} else {
> > +			/*
> > +			=C2=A0* We need to set RICHACL_PROTECTED because we are
> > +			=C2=A0* doing an implicit chmod
> > +			=C2=A0*/
> > +			if (richacl_is_auto_inherit(acl))
> > +				acl->a_flags |=3D RICHACL_PROTECTED;
> > +
> > =C2=A0			richacl_compute_max_masks(acl);
> > =C2=A0			/*
> > =C2=A0			=C2=A0* Ensure that the acl will not grant any permissions
> > diff --git a/include/linux/richacl.h b/include/linux/richacl.h
> > index 7aca1a3..a442372 100644
> > --- a/include/linux/richacl.h
> > +++ b/include/linux/richacl.h
> > @@ -81,6 +81,18 @@ extern void set_cached_richacl(struct inode *, s=
truct richacl *);
> > =C2=A0extern void forget_cached_richacl(struct inode *);
> > =C2=A0extern struct richacl *get_richacl(struct inode *);
> > =C2=A0
> > +static inline int
> > +richacl_is_auto_inherit(const struct richacl *acl)
> > +{
> > +	return acl->a_flags & RICHACL_AUTO_INHERIT;
> > +}
> > +
> > +static inline int
> > +richacl_is_protected(const struct richacl *acl)
> > +{
> > +	return acl->a_flags & RICHACL_PROTECTED;
> > +}
> > +
> > =C2=A0/**
> > =C2=A0 * richace_is_owner=C2=A0=C2=A0-=C2=A0=C2=A0check if @ace is =
an OWNER@ entry
> > =C2=A0 */
> > diff --git a/include/uapi/linux/richacl.h b/include/uapi/linux/rich=
acl.h
> > index 1ed48ac..8849a53 100644
> > --- a/include/uapi/linux/richacl.h
> > +++ b/include/uapi/linux/richacl.h
> > @@ -18,6 +18,9 @@
> > =C2=A0#define __UAPI_RICHACL_H
> > =C2=A0
> > =C2=A0/* a_flags values */
> > +#define RICHACL_AUTO_INHERIT			0x01
> > +#define RICHACL_PROTECTED			0x02
> > +#define RICHACL_DEFAULTED			0x04
> > =C2=A0#define RICHACL_WRITE_THROUGH			0x40
> > =C2=A0#define RICHACL_MASKED				0x80
> > =C2=A0
> > @@ -31,6 +34,7 @@
> > =C2=A0#define RICHACE_NO_PROPAGATE_INHERIT_ACE	0x0004
> > =C2=A0#define RICHACE_INHERIT_ONLY_ACE		0x0008
> > =C2=A0#define RICHACE_IDENTIFIER_GROUP		0x0040
> > +#define RICHACE_INHERITED_ACE			0x0080
> > =C2=A0#define RICHACE_SPECIAL_WHO			0x4000
> > =C2=A0
> > =C2=A0/* e_mask bitflags */
> > @@ -60,6 +64,9 @@
> > =C2=A0#define RICHACE_EVERYONE_SPECIAL_ID		2
> > =C2=A0
> > =C2=A0#define RICHACL_VALID_FLAGS (					\
> > +	RICHACL_AUTO_INHERIT |					\
> > +	RICHACL_PROTECTED |					\
> > +	RICHACL_DEFAULTED |					\
> > =C2=A0	RICHACL_WRITE_THROUGH |					\
> > =C2=A0	RICHACL_MASKED )
> > =C2=A0
> > @@ -69,13 +76,15 @@
> > =C2=A0	RICHACE_NO_PROPAGATE_INHERIT_ACE |			\
> > =C2=A0	RICHACE_INHERIT_ONLY_ACE |				\
> > =C2=A0	RICHACE_IDENTIFIER_GROUP |				\
> > +	RICHACE_INHERITED_ACE |					\
> > =C2=A0	RICHACE_SPECIAL_WHO )
> > =C2=A0
> > =C2=A0#define RICHACE_INHERITANCE_FLAGS (				\
> > =C2=A0	RICHACE_FILE_INHERIT_ACE |				\
> > =C2=A0	RICHACE_DIRECTORY_INHERIT_ACE |				\
> > =C2=A0	RICHACE_NO_PROPAGATE_INHERIT_ACE |			\
> > -	RICHACE_INHERIT_ONLY_ACE )
> > +	RICHACE_INHERIT_ONLY_ACE |				\
> > +	RICHACE_INHERITED_ACE )
> > =C2=A0
> > =C2=A0/* Valid RICHACE_* flags for directories and non-directories =
*/
> > =C2=A0#define RICHACE_VALID_MASK (				=09
> > \
>=20
> Barf. AI seems like a trainwreck waiting to happen. What are the
> chances that userland is going to get this right?

This is just taken from Windows, so presumably Samba should do the righ=
t
thing (with one workaround required--see the discussion of PROTECTED in
the changelog).

> Still, I do applaud the fact that you're just doing the bare minimum =
in
> kernel to support userland apps that want this. Thanks for not trying
> to push the propagation of the changed ACEs into the kernel.

Agreed.  But, again, this is just what Windows does.  (I wonder whether
there's an OS that's actually tried do any sort of atomic propagation.)

--b.
