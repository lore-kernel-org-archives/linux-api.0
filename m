From: Jeff Layton <jlayton@redhat.com>
Subject: Re: [PATCH v23 06/22] richacl: In-memory representation and helper
 functions
Date: Tue, 05 Jul 2016 07:34:08 -0400
Message-ID: <1467718448.3800.16.camel@redhat.com>
References: <1467294433-3222-1-git-send-email-agruenba@redhat.com>
	 <1467294433-3222-7-git-send-email-agruenba@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1467294433-3222-7-git-send-email-agruenba@redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Andreas Gruenbacher <agruenba@redhat.com>, Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@infradead.org>, Theodore Ts'o <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>, "J. Bruce Fields" <bfields@fieldses.org>, Trond Myklebust <trond.myklebust@primarydata.com>, Anna Schumaker <anna.schumaker@netapp.com>, Dave Chinner <david@fromorbit.com>, linux-ext4@vger.kernel.org, xfs@oss.sgi.com, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org, linux-cifs@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Thu, 2016-06-30 at 15:46 +0200, Andreas Gruenbacher wrote:
> A richacl consists of an NFSv4 acl and an owner, group, and other mas=
k.
> These three masks correspond to the owner, group, and other file
> permission bits, but they contain NFSv4 permissions instead of POSIX
> permissions.
>=20
> Each entry in the NFSv4 acl applies to the file owner (OWNER@), the
> owning group (GROUP@), everyone (EVERYONE@), or to a specific uid or
> gid.
>=20
> As in the standard POSIX file permission model, each process is the
> owner, group, or other file class.=C2=A0=C2=A0A richacl grants a requ=
ested access
> only if the NFSv4 acl in the richacl grants the access (according to =
the
> NFSv4 permission check algorithm), and the file mask that applies to =
the
> process includes the requested permissions.
>=20
> Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
> Reviewed-by: J. Bruce Fields <bfields@redhat.com>
> ---
> =C2=A0fs/Makefile=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0|=C2=A0=C2=A0=C2=A0=
1 +
> =C2=A0fs/richacl.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0|=C2=A0=C2=A065 ++++=
++++++++++++
> =C2=A0include/linux/richacl.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0| 17=
9 +++++++++++++++++++++++++++++++++++++++++++
> =C2=A0include/uapi/linux/Kbuild=C2=A0=C2=A0=C2=A0=C2=A0|=C2=A0=C2=A0=C2=
=A01 +
> =C2=A0include/uapi/linux/richacl.h |=C2=A0=C2=A099 ++++++++++++++++++=
++++++
> =C2=A05 files changed, 345 insertions(+)
> =C2=A0create mode 100644 fs/richacl.c
> =C2=A0create mode 100644 include/linux/richacl.h
> =C2=A0create mode 100644 include/uapi/linux/richacl.h
>=20
> diff --git a/fs/Makefile b/fs/Makefile
> index 85b6e13..2b3e6f1 100644
> --- a/fs/Makefile
> +++ b/fs/Makefile
> @@ -49,6 +49,7 @@ obj-$(CONFIG_COREDUMP)		+=3D coredump.o
> =C2=A0obj-$(CONFIG_SYSCTL)		+=3D drop_caches.o
> =C2=A0
> =C2=A0obj-$(CONFIG_FHANDLE)		+=3D fhandle.o
> +obj-$(CONFIG_FS_RICHACL)	+=3D richacl.o
> =C2=A0
> =C2=A0obj-y				+=3D quota/
> =C2=A0
> diff --git a/fs/richacl.c b/fs/richacl.c
> new file mode 100644
> index 0000000..bcc6591
> --- /dev/null
> +++ b/fs/richacl.c
> @@ -0,0 +1,65 @@
> +/*
> + * Copyright (C) 2006, 2010=C2=A0=C2=A0Novell, Inc.
> + * Copyright (C) 2015=C2=A0=C2=A0Red Hat, Inc.
> + * Written by Andreas Gruenbacher <agruenba@redhat.com>
> + *
> + * This program is free software; you can redistribute it and/or mod=
ify it
> + * under the terms of the GNU General Public License as published by=
 the
> + * Free Software Foundation; either version 2, or (at your option) a=
ny
> + * later version.
> + *
> + * This program is distributed in the hope that it will be useful, b=
ut
> + * WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.=C2=A0=C2=A0S=
ee the GNU
> + * General Public License for more details.
> + */
> +
> +#include=20
> +#include=20
> +#include=20
> +#include=20
> +#include=20
> +
> +/**
> + * richacl_alloc=C2=A0=C2=A0-=C2=A0=C2=A0allocate a richacl
> + * @count:	number of entries
> + */
> +struct richacl *
> +richacl_alloc(int count, gfp_t gfp)
> +{
> +	size_t size =3D sizeof(struct richacl) + count * sizeof(struct rich=
ace);
> +	struct richacl *acl =3D kzalloc(size, gfp);
> +
> +	if (acl) {
> +		atomic_set(&acl->a_refcount, 1);
> +		acl->a_count =3D count;
> +	}
> +	return acl;
> +}
> +EXPORT_SYMBOL_GPL(richacl_alloc);
> +

I imagine we could have a lot of these at any given time. It might be
nice to consider how to do this with dedicated slabcaches for better
packing, but I think that would add to the complexity, unfortunately.

> +/**
> + * richacl_clone=C2=A0=C2=A0-=C2=A0=C2=A0create a copy of a richacl
> + */
> +struct richacl *
> +richacl_clone(const struct richacl *acl, gfp_t gfp)
> +{
> +	int count =3D acl->a_count;
> +	size_t size =3D sizeof(struct richacl) + count * sizeof(struct rich=
ace);
> +	struct richacl *dup =3D kmalloc(size, gfp);
> +
> +	if (dup) {
> +		memcpy(dup, acl, size);
> +		atomic_set(&dup->a_refcount, 1);
> +	}
> +	return dup;
> +}
> +
> +/**
> + * richace_copy=C2=A0=C2=A0-=C2=A0=C2=A0copy an acl entry
> + */
> +void
> +richace_copy(struct richace *to, const struct richace *from)
> +{
> +	memcpy(to, from, sizeof(struct richace));
> +}
> diff --git a/include/linux/richacl.h b/include/linux/richacl.h
> new file mode 100644
> index 0000000..edb8480
> --- /dev/null
> +++ b/include/linux/richacl.h
> @@ -0,0 +1,179 @@
> +/*
> + * Copyright (C) 2006, 2010=C2=A0=C2=A0Novell, Inc.
> + * Copyright (C) 2015=C2=A0=C2=A0Red Hat, Inc.
> + * Written by Andreas Gruenbacher <agruenba@redhat.com>
> + *
> + * This program is free software; you can redistribute it and/or mod=
ify it
> + * under the terms of the GNU General Public License as published by=
 the
> + * Free Software Foundation; either version 2, or (at your option) a=
ny
> + * later version.
> + *
> + * This program is distributed in the hope that it will be useful, b=
ut
> + * WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.=C2=A0=C2=A0S=
ee the GNU
> + * General Public License for more details.
> + */
> +
> +#ifndef __RICHACL_H
> +#define __RICHACL_H
> +
> +#include=20
> +
> +struct richace {
> +	unsigned short	e_type;
> +	unsigned short	e_flags;
> +	unsigned int	e_mask;
> +	union {
> +		kuid_t		uid;
> +		kgid_t		gid;
> +		unsigned int	special;
> +	} e_id;
> +};
> +
> +struct richacl {
> +	atomic_t	a_refcount;
> +	unsigned int	a_owner_mask;
> +	unsigned int	a_group_mask;
> +	unsigned int	a_other_mask;
> +	unsigned short	a_count;
> +	unsigned short	a_flags;
> +	struct richace	a_entries[0];
> +};
> +
> +#define richacl_for_each_entry(_ace, _acl)			\
> +	for (_ace =3D (_acl)->a_entries;				\
> +	=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0_ace !=3D (_acl)->a_entries + (_acl)-=
>a_count;	\
> +	=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0_ace++)
> +
> +#define richacl_for_each_entry_reverse(_ace, _acl)		\
> +	for (_ace =3D (_acl)->a_entries + (_acl)->a_count - 1;	\
> +	=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0_ace !=3D (_acl)->a_entries - 1;			\
> +	=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0_ace--)
> +
> +/**
> + * richacl_get=C2=A0=C2=A0-=C2=A0=C2=A0grab another reference to a r=
ichacl handle
> + */
> +static inline struct richacl *
> +richacl_get(struct richacl *acl)
> +{
> +	if (acl)
> +		atomic_inc(&acl->a_refcount);
> +	return acl;
> +}
> +
> +/**
> + * richacl_put=C2=A0=C2=A0-=C2=A0=C2=A0free a richacl handle
> + */
> +static inline void
> +richacl_put(struct richacl *acl)
> +{
> +	if (acl && atomic_dec_and_test(&acl->a_refcount))
> +		kfree(acl);
> +}
> +
> +/**
> + * richace_is_owner=C2=A0=C2=A0-=C2=A0=C2=A0check if @ace is an OWNE=
R@ entry
> + */
> +static inline bool
> +richace_is_owner(const struct richace *ace)
> +{
> +	return (ace->e_flags & RICHACE_SPECIAL_WHO) &&
> +	=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0ace->e_id.special =3D=3D =
RICHACE_OWNER_SPECIAL_ID;
> +}
> +
> +/**
> + * richace_is_group=C2=A0=C2=A0-=C2=A0=C2=A0check if @ace is a GROUP=
@ entry
> + */
> +static inline bool
> +richace_is_group(const struct richace *ace)
> +{
> +	return (ace->e_flags & RICHACE_SPECIAL_WHO) &&
> +	=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0ace->e_id.special =3D=3D =
RICHACE_GROUP_SPECIAL_ID;
> +}
> +
> +/**
> + * richace_is_everyone=C2=A0=C2=A0-=C2=A0=C2=A0check if @ace is an E=
VERYONE@ entry
> + */
> +static inline bool
> +richace_is_everyone(const struct richace *ace)
> +{
> +	return (ace->e_flags & RICHACE_SPECIAL_WHO) &&
> +	=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0ace->e_id.special =3D=3D =
RICHACE_EVERYONE_SPECIAL_ID;
> +}
> +
> +/**
> + * richace_is_unix_user=C2=A0=C2=A0-=C2=A0=C2=A0check if @ace applie=
s to a specific user
> + */
> +static inline bool
> +richace_is_unix_user(const struct richace *ace)
> +{
> +	return !(ace->e_flags & RICHACE_SPECIAL_WHO) &&
> +	=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0!(ace->e_flags & RICHACE_=
IDENTIFIER_GROUP);
> +}
> +
> +/**
> + * richace_is_unix_group=C2=A0=C2=A0-=C2=A0=C2=A0check if @ace appli=
es to a specific group
> + */
> +static inline bool
> +richace_is_unix_group(const struct richace *ace)
> +{
> +	return !(ace->e_flags & RICHACE_SPECIAL_WHO) &&
> +	=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0(ace->e_flags & RICHACE_I=
DENTIFIER_GROUP);
> +}
> +
> +/**
> + * richace_is_inherit_only=C2=A0=C2=A0-=C2=A0=C2=A0check if @ace is =
for inheritance only
> + *
> + * ACEs with the %RICHACE_INHERIT_ONLY_ACE flag set have no effect d=
uring
> + * permission checking.
> + */
> +static inline bool
> +richace_is_inherit_only(const struct richace *ace)
> +{
> +	return ace->e_flags & RICHACE_INHERIT_ONLY_ACE;
> +}
> +
> +/**
> + * richace_is_inheritable=C2=A0=C2=A0-=C2=A0=C2=A0check if @ace is i=
nheritable
> + */
> +static inline bool
> +richace_is_inheritable(const struct richace *ace)
> +{
> +	return ace->e_flags & (RICHACE_FILE_INHERIT_ACE |
> +			=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0RICHACE_DIRECTORY_INHER=
IT_ACE);
> +}
> +
> +/**
> + * richace_is_allow=C2=A0=C2=A0-=C2=A0=C2=A0check if @ace is an %ALL=
OW type entry
> + */
> +static inline bool
> +richace_is_allow(const struct richace *ace)
> +{
> +	return ace->e_type =3D=3D RICHACE_ACCESS_ALLOWED_ACE_TYPE;
> +}
> +
> +/**
> + * richace_is_deny=C2=A0=C2=A0-=C2=A0=C2=A0check if @ace is a %DENY =
type entry
> + */
> +static inline bool
> +richace_is_deny(const struct richace *ace)
> +{
> +	return ace->e_type =3D=3D RICHACE_ACCESS_DENIED_ACE_TYPE;
> +}
> +
> +/**
> + * richace_is_same_identifier=C2=A0=C2=A0-=C2=A0=C2=A0are both ident=
ifiers the same?
> + */
> +static inline bool
> +richace_is_same_identifier(const struct richace *a, const struct ric=
hace *b)
> +{
> +	return !((a->e_flags ^ b->e_flags) &
> +		=C2=A0(RICHACE_SPECIAL_WHO | RICHACE_IDENTIFIER_GROUP)) &&
> +	=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0!memcmp(&a->e_id, &b->e_i=
d, sizeof(a->e_id));
> +}
> +
> +extern struct richacl *richacl_alloc(int, gfp_t);
> +extern struct richacl *richacl_clone(const struct richacl *, gfp_t);
> +extern void richace_copy(struct richace *, const struct richace *);
> +
> +#endif /* __RICHACL_H */
> diff --git a/include/uapi/linux/Kbuild b/include/uapi/linux/Kbuild
> index 8bdae34..abeaa98 100644
> --- a/include/uapi/linux/Kbuild
> +++ b/include/uapi/linux/Kbuild
> @@ -355,6 +355,7 @@ header-y +=3D reboot.h
> =C2=A0header-y +=3D reiserfs_fs.h
> =C2=A0header-y +=3D reiserfs_xattr.h
> =C2=A0header-y +=3D resource.h
> +header-y +=3D richacl.h
> =C2=A0header-y +=3D rfkill.h
> =C2=A0header-y +=3D rio_mport_cdev.h
> =C2=A0header-y +=3D romfs_fs.h
> diff --git a/include/uapi/linux/richacl.h b/include/uapi/linux/richac=
l.h
> new file mode 100644
> index 0000000..08856f8
> --- /dev/null
> +++ b/include/uapi/linux/richacl.h
> @@ -0,0 +1,99 @@
> +/*
> + * Copyright (C) 2006, 2010=C2=A0=C2=A0Novell, Inc.
> + * Copyright (C) 2015=C2=A0=C2=A0Red Hat, Inc.
> + * Written by Andreas Gruenbacher <agruenba@redhat.com>
> + *
> + * This file is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU Lesser General Public
> + * License as published by the Free Software Foundation; either
> + * version 2.1 of the License, or (at your option) any later version=
=2E
> + *
> + * This file is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.=C2=A0=C2=A0S=
ee the GNU
> + * Lesser General Public License for more details.
> + */
> +
> +#ifndef __UAPI_RICHACL_H
> +#define __UAPI_RICHACL_H
> +
> +/* a_flags values */
> +#define RICHACL_WRITE_THROUGH			0x40
> +#define RICHACL_MASKED				0x80
> +
> +/* e_type values */
> +#define RICHACE_ACCESS_ALLOWED_ACE_TYPE		0x0000
> +#define RICHACE_ACCESS_DENIED_ACE_TYPE		0x0001
> +
> +/* e_flags bitflags */
> +#define RICHACE_FILE_INHERIT_ACE		0x0001
> +#define RICHACE_DIRECTORY_INHERIT_ACE		0x0002
> +#define RICHACE_NO_PROPAGATE_INHERIT_ACE	0x0004
> +#define RICHACE_INHERIT_ONLY_ACE		0x0008
> +#define RICHACE_IDENTIFIER_GROUP		0x0040
> +#define RICHACE_SPECIAL_WHO			0x4000
> +
> +/* e_mask bitflags */
> +#define RICHACE_READ_DATA			0x00000001
> +#define RICHACE_LIST_DIRECTORY			0x00000001
> +#define RICHACE_WRITE_DATA			0x00000002
> +#define RICHACE_ADD_FILE			0x00000002
> +#define RICHACE_APPEND_DATA			0x00000004
> +#define RICHACE_ADD_SUBDIRECTORY		0x00000004
> +#define RICHACE_READ_NAMED_ATTRS		0x00000008
> +#define RICHACE_WRITE_NAMED_ATTRS		0x00000010
> +#define RICHACE_EXECUTE				0x00000020
> +#define RICHACE_DELETE_CHILD			0x00000040
> +#define RICHACE_READ_ATTRIBUTES			0x00000080
> +#define RICHACE_WRITE_ATTRIBUTES		0x00000100
> +#define RICHACE_WRITE_RETENTION			0x00000200
> +#define RICHACE_WRITE_RETENTION_HOLD		0x00000400
> +#define RICHACE_DELETE				0x00010000
> +#define RICHACE_READ_ACL			0x00020000
> +#define RICHACE_WRITE_ACL			0x00040000
> +#define RICHACE_WRITE_OWNER			0x00080000
> +#define RICHACE_SYNCHRONIZE			0x00100000
> +
> +/* e_id values */
> +#define RICHACE_OWNER_SPECIAL_ID		0
> +#define RICHACE_GROUP_SPECIAL_ID		1
> +#define RICHACE_EVERYONE_SPECIAL_ID		2
> +
> +#define RICHACL_VALID_FLAGS (					\
> +	RICHACL_WRITE_THROUGH |					\
> +	RICHACL_MASKED )
> +
> +#define RICHACE_VALID_FLAGS (					\
> +	RICHACE_FILE_INHERIT_ACE |				\
> +	RICHACE_DIRECTORY_INHERIT_ACE |				\
> +	RICHACE_NO_PROPAGATE_INHERIT_ACE |			\
> +	RICHACE_INHERIT_ONLY_ACE |				\
> +	RICHACE_IDENTIFIER_GROUP |				\
> +	RICHACE_SPECIAL_WHO )
> +
> +#define RICHACE_INHERITANCE_FLAGS (				\
> +	RICHACE_FILE_INHERIT_ACE |				\
> +	RICHACE_DIRECTORY_INHERIT_ACE |				\
> +	RICHACE_NO_PROPAGATE_INHERIT_ACE |			\
> +	RICHACE_INHERIT_ONLY_ACE )
> +
> +/* Valid RICHACE_* flags for directories and non-directories */
> +#define RICHACE_VALID_MASK (					\
> +	RICHACE_READ_DATA | RICHACE_LIST_DIRECTORY |		\
> +	RICHACE_WRITE_DATA | RICHACE_ADD_FILE |			\
> +	RICHACE_APPEND_DATA | RICHACE_ADD_SUBDIRECTORY |	\
> +	RICHACE_READ_NAMED_ATTRS |				\
> +	RICHACE_WRITE_NAMED_ATTRS |				\
> +	RICHACE_EXECUTE |					\
> +	RICHACE_DELETE_CHILD |					\
> +	RICHACE_READ_ATTRIBUTES |				\
> +	RICHACE_WRITE_ATTRIBUTES |				\
> +	RICHACE_WRITE_RETENTION |				\
> +	RICHACE_WRITE_RETENTION_HOLD |				\
> +	RICHACE_DELETE |					\
> +	RICHACE_READ_ACL |					\
> +	RICHACE_WRITE_ACL |					\
> +	RICHACE_WRITE_OWNER |					\
> +	RICHACE_SYNCHRONIZE )
> +
> +#endif /* __UAPI_RICHACL_H */

Reviewed-by: Jeff Layton <jlayton@redhat.com>
--
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel=
" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
