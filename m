From: Jeff Layton <jlayton@redhat.com>
Subject: Re: [PATCH v23 07/22] richacl: Permission mapping functions
Date: Tue, 05 Jul 2016 09:39:46 -0400
Message-ID: <1467725986.3800.22.camel@redhat.com>
References: <1467294433-3222-1-git-send-email-agruenba@redhat.com>
	 <1467294433-3222-8-git-send-email-agruenba@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-ext4-owner@vger.kernel.org>
In-Reply-To: <1467294433-3222-8-git-send-email-agruenba@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
To: Andreas Gruenbacher <agruenba@redhat.com>, Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@infradead.org>, Theodore Ts'o <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>, "J. Bruce Fields" <bfields@fieldses.org>, Trond Myklebust <trond.myklebust@primarydata.com>, Anna Schumaker <anna.schumaker@netapp.com>, Dave Chinner <david@fromorbit.com>, linux-ext4@vger.kernel.org, xfs@oss.sgi.com, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org, linux-cifs@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Thu, 2016-06-30 at 15:46 +0200, Andreas Gruenbacher wrote:
> We need to map from POSIX permissions to NFSv4 permissions when a
> chmod() is done, from NFSv4 permissions to POSIX permissions when an =
acl
> is set (which implicitly sets the file permission bits), and from the
> MAY_READ/MAY_WRITE/MAY_EXEC/MAY_APPEND flags to NFSv4 permissions whe=
n
> doing an access check in a richacl.
>=20
> Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
> Reviewed-by: J. Bruce Fields <bfields@redhat.com>
> ---
> =C2=A0fs/richacl.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0| 118 ++++++++++++++=
+++++++++++++++++++++++++++++
> =C2=A0include/linux/richacl.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0|=C2=
=A0=C2=A0=C2=A03 ++
> =C2=A0include/uapi/linux/richacl.h |=C2=A0=C2=A044 ++++++++++++++++
> =C2=A03 files changed, 165 insertions(+)
>=20
> diff --git a/fs/richacl.c b/fs/richacl.c
> index bcc6591..d0a4135 100644
> --- a/fs/richacl.c
> +++ b/fs/richacl.c
> @@ -63,3 +63,121 @@ richace_copy(struct richace *to, const struct ric=
hace *from)
> =C2=A0{
> =C2=A0	memcpy(to, from, sizeof(struct richace));
> =C2=A0}
> +
> +/*
> + * richacl_mask_to_mode=C2=A0=C2=A0-=C2=A0=C2=A0compute the file per=
mission bits from mask
> + * @mask:	%RICHACE_* permission mask
> + *
> + * Compute the file permission bits corresponding to a particular se=
t of
> + * richacl permissions.
> + *
> + * See richacl_masks_to_mode().
> + */
> +static int
> +richacl_mask_to_mode(unsigned int mask)
> +{
> +	int mode =3D 0;
> +
> +	if (mask & RICHACE_POSIX_MODE_READ)
> +		mode |=3D S_IROTH;
> +	if (mask & RICHACE_POSIX_MODE_WRITE)
> +		mode |=3D S_IWOTH;
> +	if (mask & RICHACE_POSIX_MODE_EXEC)
> +		mode |=3D S_IXOTH;
> +
> +	return mode;
> +}
> +
> +/**
> + * richacl_masks_to_mode=C2=A0=C2=A0-=C2=A0=C2=A0compute file permis=
sion bits from file masks
> + *
> + * When setting a richacl, we set the file permission bits to indica=
te maximum
> + * permissions: for example, we set the Write permission when a mask=
 contains
> + * RICHACE_APPEND_DATA even if it does not also contain RICHACE_WRIT=
E_DATA.
> + *
> + * Permissions which are not in RICHACE_POSIX_MODE_READ,
> + * RICHACE_POSIX_MODE_WRITE, or RICHACE_POSIX_MODE_EXEC cannot be re=
presented
> + * in the file permission bits.=C2=A0=C2=A0Such permissions can stil=
l be effective, but
> + * not for new files or after a chmod(); they must be explicitly ena=
bled in the
> + * richacl.
> + */
> +int
> +richacl_masks_to_mode(const struct richacl *acl)
> +{
> +	return richacl_mask_to_mode(acl->a_owner_mask) << 6 |
> +	=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0richacl_mask_to_mode(acl-=
>a_group_mask) << 3 |
> +	=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0richacl_mask_to_mode(acl-=
>a_other_mask);
> +}
> +EXPORT_SYMBOL_GPL(richacl_masks_to_mode);
> +
> +/**
> + * richacl_mode_to_mask=C2=A0=C2=A0- compute a file mask from the lo=
west three mode bits
> + * @mode:	mode to convert to richacl permissions
> + *
> + * When the file permission bits of a file are set with chmod(), thi=
s specifies
> + * the maximum permissions that processes will get.=C2=A0=C2=A0All p=
ermissions beyond
> + * that will be removed from the file masks, and become ineffective.
> + */
> +unsigned int
> +richacl_mode_to_mask(umode_t mode)
> +{
> +	unsigned int mask =3D 0;
> +
> +	if (mode & S_IROTH)
> +		mask |=3D RICHACE_POSIX_MODE_READ;
> +	if (mode & S_IWOTH)
> +		mask |=3D RICHACE_POSIX_MODE_WRITE;
> +	if (mode & S_IXOTH)
> +		mask |=3D RICHACE_POSIX_MODE_EXEC;
> +
> +	return mask;
> +}
> +
> +/**
> + * richacl_want_to_mask=C2=A0=C2=A0- convert the iop->permission wan=
t argument to a mask
> + * @want:	@want argument of the permission inode operation
> + *
> + * When checking for append, @want is (MAY_WRITE | MAY_APPEND).
> + *
> + * Richacls use the iop->may_create and iop->may_delete hooks which =
are used
> + * for checking if creating and deleting files is allowed.=C2=A0=C2=A0=
These hooks do not
> + * use richacl_want_to_mask(), so we do not have to deal with mappin=
g MAY_WRITE
> + * to RICHACE_ADD_FILE, RICHACE_ADD_SUBDIRECTORY, and RICHACE_DELETE=
_CHILD
> + * here.
> + */

This comment is confusing as I don't see any may_create or may_delete
iops in the final patchset. Do you mean may_create() and may_delete()
here?

> +unsigned int
> +richacl_want_to_mask(unsigned int want)
> +{
> +	unsigned int mask =3D 0;
> +
> +	if (want & MAY_READ)
> +		mask |=3D RICHACE_READ_DATA;
> +	if (want & MAY_DELETE_SELF)
> +		mask |=3D RICHACE_DELETE;
> +	if (want & MAY_TAKE_OWNERSHIP)
> +		mask |=3D RICHACE_WRITE_OWNER;
> +	if (want & MAY_CHMOD)
> +		mask |=3D RICHACE_WRITE_ACL;
> +	if (want & MAY_SET_TIMES)
> +		mask |=3D RICHACE_WRITE_ATTRIBUTES;
> +	if (want & MAY_EXEC)
> +		mask |=3D RICHACE_EXECUTE;
> +	/*
> +	=C2=A0* differentiate MAY_WRITE from these request
> +	=C2=A0*/
> +	if (want & (MAY_APPEND |
> +		=C2=A0=C2=A0=C2=A0=C2=A0MAY_CREATE_FILE | MAY_CREATE_DIR |
> +		=C2=A0=C2=A0=C2=A0=C2=A0MAY_DELETE_CHILD)) {
> +		if (want & MAY_APPEND)
> +			mask |=3D RICHACE_APPEND_DATA;
> +		if (want & MAY_CREATE_FILE)
> +			mask |=3D RICHACE_ADD_FILE;
> +		if (want & MAY_CREATE_DIR)
> +			mask |=3D RICHACE_ADD_SUBDIRECTORY;
> +		if (want & MAY_DELETE_CHILD)
> +			mask |=3D RICHACE_DELETE_CHILD;
> +	} else if (want & MAY_WRITE)
> +		mask |=3D RICHACE_WRITE_DATA;
> +	return mask;
> +}
> +EXPORT_SYMBOL_GPL(richacl_want_to_mask);
> diff --git a/include/linux/richacl.h b/include/linux/richacl.h
> index edb8480..9102ef0 100644
> --- a/include/linux/richacl.h
> +++ b/include/linux/richacl.h
> @@ -175,5 +175,8 @@ richace_is_same_identifier(const struct richace *=
a, const struct richace *b)
> =C2=A0extern struct richacl *richacl_alloc(int, gfp_t);
> =C2=A0extern struct richacl *richacl_clone(const struct richacl *, gf=
p_t);
> =C2=A0extern void richace_copy(struct richace *, const struct richace=
 *);
> +extern int richacl_masks_to_mode(const struct richacl *);
> +extern unsigned int richacl_mode_to_mask(umode_t);
> +extern unsigned int richacl_want_to_mask(unsigned int);
> =C2=A0
> =C2=A0#endif /* __RICHACL_H */
> diff --git a/include/uapi/linux/richacl.h b/include/uapi/linux/richac=
l.h
> index 08856f8..1ed48ac 100644
> --- a/include/uapi/linux/richacl.h
> +++ b/include/uapi/linux/richacl.h
> @@ -96,4 +96,48 @@
> =C2=A0	RICHACE_WRITE_OWNER |					\
> =C2=A0	RICHACE_SYNCHRONIZE )
> =C2=A0
> +/*
> + * The POSIX permissions are supersets of the following richacl perm=
issions:
> + *
> + *=C2=A0=C2=A0- MAY_READ maps to READ_DATA or LIST_DIRECTORY, depend=
ing on the type
> + *=C2=A0=C2=A0=C2=A0=C2=A0of the file system object.
> + *
> + *=C2=A0=C2=A0- MAY_WRITE maps to WRITE_DATA or RICHACE_APPEND_DATA =
for files, and to
> + *=C2=A0=C2=A0=C2=A0=C2=A0ADD_FILE, RICHACE_ADD_SUBDIRECTORY, or RIC=
HACE_DELETE_CHILD for directories.
> + *
> + *=C2=A0=C2=A0- MAY_EXECUTE maps to RICHACE_EXECUTE.
> + *
> + *=C2=A0=C2=A0(Some of these richacl permissions have the same bit v=
alues.)
> + */
> +#define RICHACE_POSIX_MODE_READ (			\
> +		RICHACE_READ_DATA |			\
> +		RICHACE_LIST_DIRECTORY)
> +#define RICHACE_POSIX_MODE_WRITE (			\
> +		RICHACE_WRITE_DATA |			\
> +		RICHACE_ADD_FILE |			\
> +		RICHACE_APPEND_DATA |			\
> +		RICHACE_ADD_SUBDIRECTORY |		\
> +		RICHACE_DELETE_CHILD)
> +#define RICHACE_POSIX_MODE_EXEC RICHACE_EXECUTE
> +#define RICHACE_POSIX_MODE_ALL (			\
> +		RICHACE_POSIX_MODE_READ |		\
> +		RICHACE_POSIX_MODE_WRITE |		\
> +		RICHACE_POSIX_MODE_EXEC)
> +
> +/*
> + * These permissions are always allowed no matter what the acl says.
> + */
> +#define RICHACE_POSIX_ALWAYS_ALLOWED (			\
> +		RICHACE_SYNCHRONIZE |			\
> +		RICHACE_READ_ATTRIBUTES |		\
> +		RICHACE_READ_ACL)
> +
> +/*
> + * The owner is implicitly granted these permissions under POSIX.
> + */
> +#define RICHACE_POSIX_OWNER_ALLOWED (			\
> +		RICHACE_WRITE_ATTRIBUTES |		\
> +		RICHACE_WRITE_OWNER |			\
> +		RICHACE_WRITE_ACL)
> +
> =C2=A0#endif /* __UAPI_RICHACL_H */

Other than the confusing comment, this looks ok.

Reviewed-by: Jeff Layton <jlayton@redhat.com>
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
