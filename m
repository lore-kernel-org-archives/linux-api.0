From: Dmitry Monakhov <dmonakhov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Subject: Re: [v15 1/4] ext4: adds project ID support
Date: Wed, 23 Sep 2015 15:34:54 +0300
Message-ID: <87io71titt.fsf@openvz.org>
References: <1442146833-13652-1-git-send-email-lixi@ddn.com> <1442146833-13652-2-git-send-email-lixi@ddn.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha512; protocol="application/pgp-signature"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1442146833-13652-2-git-send-email-lixi-LfVdkaOWEx8@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Li Xi <pkuelelixi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tytso-3s7WtUTddSA@public.gmane.org, adilger-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org, jack-AlSwsSmVLrQ@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org
List-Id: linux-api@vger.kernel.org

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Li Xi <pkuelelixi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> writes:

> This patch adds a new internal field of ext4 inode to save project
> identifier. Also a new flag EXT4_INODE_PROJINHERIT is added for
> inheriting project ID from parent directory.
>
> Signed-off-by: Li Xi <lixi-LfVdkaOWEx8@public.gmane.org>
> Reviewed-by: Andreas Dilger <adilger-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>
> Reviewed-by: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
> ---
>  fs/ext4/ext4.h          |   21 +++++++++++++++++----
>  fs/ext4/ialloc.c        |    7 +++++++
>  fs/ext4/inode.c         |   28 ++++++++++++++++++++++++++++
>  fs/ext4/namei.c         |   19 +++++++++++++++++++
>  fs/ext4/super.c         |    1 +
>  include/uapi/linux/fs.h |    1 +
>  6 files changed, 73 insertions(+), 4 deletions(-)
>
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index fd1f28b..96d6e4c 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -374,16 +374,18 @@ struct flex_groups {
>  #define EXT4_EA_INODE_FL	        0x00200000 /* Inode used for large EA */
>  #define EXT4_EOFBLOCKS_FL		0x00400000 /* Blocks allocated beyond EOF */
>  #define EXT4_INLINE_DATA_FL		0x10000000 /* Inode has inline data. */
> +#define EXT4_PROJINHERIT_FL		0x20000000 /* Create with parents projid */
>  #define EXT4_RESERVED_FL		0x80000000 /* reserved for ext4 lib */
>=20=20
> -#define EXT4_FL_USER_VISIBLE		0x004BDFFF /* User visible flags */
> -#define EXT4_FL_USER_MODIFIABLE		0x004380FF /* User modifiable flags */
> +#define EXT4_FL_USER_VISIBLE		0x304BDFFF /* User visible flags */
> +#define EXT4_FL_USER_MODIFIABLE		0x204380FF /* User modifiable flags */
>=20=20
>  /* Flags that should be inherited by new inodes from their parent. */
>  #define EXT4_FL_INHERITED (EXT4_SECRM_FL | EXT4_UNRM_FL | EXT4_COMPR_FL =
|\
>  			   EXT4_SYNC_FL | EXT4_NODUMP_FL | EXT4_NOATIME_FL |\
>  			   EXT4_NOCOMPR_FL | EXT4_JOURNAL_DATA_FL |\
> -			   EXT4_NOTAIL_FL | EXT4_DIRSYNC_FL)
> +			   EXT4_NOTAIL_FL | EXT4_DIRSYNC_FL |\
> +			   EXT4_PROJINHERIT_FL)
>=20=20
>  /* Flags that are appropriate for regular files (all but dir-specific on=
es). */
>  #define EXT4_REG_FLMASK (~(EXT4_DIRSYNC_FL | EXT4_TOPDIR_FL))
> @@ -431,6 +433,7 @@ enum {
>  	EXT4_INODE_EA_INODE	=3D 21,	/* Inode used for large EA */
>  	EXT4_INODE_EOFBLOCKS	=3D 22,	/* Blocks allocated beyond EOF */
>  	EXT4_INODE_INLINE_DATA	=3D 28,	/* Data in inode. */
> +	EXT4_INODE_PROJINHERIT	=3D 29,	/* Create with parents projid */
>  	EXT4_INODE_RESERVED	=3D 31,	/* reserved for ext4 lib */
>  };
>=20=20
> @@ -692,6 +695,7 @@ struct ext4_inode {
>  	__le32  i_crtime;       /* File Creation time */
>  	__le32  i_crtime_extra; /* extra FileCreationtime (nsec << 2 | epoch) */
>  	__le32  i_version_hi;	/* high 32 bits for 64-bit version */
> +	__le32  i_projid;	/* Project ID */
So you are about to extend dist_inode structure(not xattr). I do understand=
 that
his is ridiculous question for 15'th version of the patch, but still.
Personally I think that his is good idea, but can not find a
confirmation from Theodore and Jan that they are agree with that.
Guys please ACK that statement explicitly,so later we can  refer on this ma=
il as decision made.
>  };
>=20=20
>  struct move_extent {
> @@ -952,6 +956,7 @@ struct ext4_inode_info {
>  	/* Encryption params */
>  	struct ext4_crypt_info *i_crypt_info;
>  #endif
> +	kprojid_t i_projid;
>  };
>=20=20
>  /*
> @@ -1566,6 +1571,7 @@ static inline int ext4_encrypted_inode(struct inode=
 *inode)
>   */
>  #define EXT4_FEATURE_RO_COMPAT_METADATA_CSUM	0x0400
>  #define EXT4_FEATURE_RO_COMPAT_READONLY		0x1000
> +#define EXT4_FEATURE_RO_COMPAT_PROJECT		0x2000
>=20=20
>  #define EXT4_FEATURE_INCOMPAT_COMPRESSION	0x0001
>  #define EXT4_FEATURE_INCOMPAT_FILETYPE		0x0002
> @@ -1617,7 +1623,8 @@ static inline int ext4_encrypted_inode(struct inode=
 *inode)
>  					 EXT4_FEATURE_RO_COMPAT_HUGE_FILE |\
>  					 EXT4_FEATURE_RO_COMPAT_BIGALLOC |\
>  					 EXT4_FEATURE_RO_COMPAT_METADATA_CSUM|\
> -					 EXT4_FEATURE_RO_COMPAT_QUOTA)
> +					 EXT4_FEATURE_RO_COMPAT_QUOTA |\
> +					 EXT4_FEATURE_RO_COMPAT_PROJECT)
>=20=20
>  /*
>   * Default values for user and/or group using reserved blocks
> @@ -1625,6 +1632,11 @@ static inline int ext4_encrypted_inode(struct inod=
e *inode)
>  #define	EXT4_DEF_RESUID		0
>  #define	EXT4_DEF_RESGID		0
>=20=20
> +/*
> + * Default project ID
> + */
> +#define	EXT4_DEF_PROJID		0
> +
>  #define EXT4_DEF_INODE_READAHEAD_BLKS	32
>=20=20
>  /*
> @@ -2317,6 +2329,7 @@ extern int ext4_zero_partial_blocks(handle_t *handl=
e, struct inode *inode,
>  			     loff_t lstart, loff_t lend);
>  extern int ext4_page_mkwrite(struct vm_area_struct *vma, struct vm_fault=
 *vmf);
>  extern qsize_t *ext4_get_reserved_space(struct inode *inode);
> +extern int ext4_get_projid(struct inode *inode, kprojid_t *projid);
>  extern void ext4_da_update_reserve_space(struct inode *inode,
>  					int used, int quota_claim);
>=20=20
> diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
> index 619bfc1..692b50f 100644
> --- a/fs/ext4/ialloc.c
> +++ b/fs/ext4/ialloc.c
> @@ -769,6 +769,13 @@ struct inode *__ext4_new_inode(handle_t *handle, str=
uct inode *dir,
>  		inode->i_gid =3D dir->i_gid;
>  	} else
>  		inode_init_owner(inode, dir, mode);
> +
> +	if (EXT4_HAS_RO_COMPAT_FEATURE(sb, EXT4_FEATURE_RO_COMPAT_PROJECT) &&
> +	    ext4_test_inode_flag(dir, EXT4_INODE_PROJINHERIT))
> +		ei->i_projid =3D EXT4_I(dir)->i_projid;
> +	else
> +		ei->i_projid =3D make_kprojid(&init_user_ns, EXT4_DEF_PROJID);
> +
>  	err =3D dquot_initialize(inode);
>  	if (err)
>  		goto out;
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 612fbcf..5836a3d 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -4035,6 +4035,14 @@ static inline void ext4_iget_extra_inode(struct in=
ode *inode,
>  		EXT4_I(inode)->i_inline_off =3D 0;
>  }
>=20=20
> +int ext4_get_projid(struct inode *inode, kprojid_t *projid)
> +{
> +	if (!EXT4_HAS_RO_COMPAT_FEATURE(inode->i_sb, EXT4_FEATURE_RO_COMPAT_PRO=
JECT))
> +		return -EOPNOTSUPP;
> +	*projid =3D EXT4_I(inode)->i_projid;
> +	return 0;
> +}
> +
>  struct inode *ext4_iget(struct super_block *sb, unsigned long ino)
>  {
>  	struct ext4_iloc iloc;
> @@ -4046,6 +4054,7 @@ struct inode *ext4_iget(struct super_block *sb, uns=
igned long ino)
>  	int block;
>  	uid_t i_uid;
>  	gid_t i_gid;
> +	projid_t i_projid;
>=20=20
>  	inode =3D iget_locked(sb, ino);
>  	if (!inode)
> @@ -4095,12 +4104,20 @@ struct inode *ext4_iget(struct super_block *sb, u=
nsigned long ino)
>  	inode->i_mode =3D le16_to_cpu(raw_inode->i_mode);
>  	i_uid =3D (uid_t)le16_to_cpu(raw_inode->i_uid_low);
>  	i_gid =3D (gid_t)le16_to_cpu(raw_inode->i_gid_low);
> +	if (EXT4_HAS_RO_COMPAT_FEATURE(sb, EXT4_FEATURE_RO_COMPAT_PROJECT) &&
> +	    EXT4_INODE_SIZE(sb) > EXT4_GOOD_OLD_INODE_SIZE &&
> +	    EXT4_FITS_IN_INODE(raw_inode, ei, i_projid))
> +		i_projid =3D (projid_t)le32_to_cpu(raw_inode->i_projid);
> +	else
> +		i_projid =3D EXT4_DEF_PROJID;
> +
>  	if (!(test_opt(inode->i_sb, NO_UID32))) {
>  		i_uid |=3D le16_to_cpu(raw_inode->i_uid_high) << 16;
>  		i_gid |=3D le16_to_cpu(raw_inode->i_gid_high) << 16;
>  	}
>  	i_uid_write(inode, i_uid);
>  	i_gid_write(inode, i_gid);
> +	ei->i_projid =3D make_kprojid(&init_user_ns, i_projid);
>  	set_nlink(inode, le16_to_cpu(raw_inode->i_links_count));
>=20=20
>  	ext4_clear_state_flags(ei);	/* Only relevant on 32-bit archs */
> @@ -4398,6 +4415,7 @@ static int ext4_do_update_inode(handle_t *handle,
>  	int need_datasync =3D 0, set_large_file =3D 0;
>  	uid_t i_uid;
>  	gid_t i_gid;
> +	projid_t i_projid;
>=20=20
>  	spin_lock(&ei->i_raw_lock);
>=20=20
> @@ -4410,6 +4428,7 @@ static int ext4_do_update_inode(handle_t *handle,
>  	raw_inode->i_mode =3D cpu_to_le16(inode->i_mode);
>  	i_uid =3D i_uid_read(inode);
>  	i_gid =3D i_gid_read(inode);
> +	i_projid =3D from_kprojid(&init_user_ns, ei->i_projid);
>  	if (!(test_opt(inode->i_sb, NO_UID32))) {
>  		raw_inode->i_uid_low =3D cpu_to_le16(low_16_bits(i_uid));
>  		raw_inode->i_gid_low =3D cpu_to_le16(low_16_bits(i_gid));
> @@ -4488,6 +4507,15 @@ static int ext4_do_update_inode(handle_t *handle,
>  				cpu_to_le16(ei->i_extra_isize);
>  		}
>  	}
> +
> +	BUG_ON(!EXT4_HAS_RO_COMPAT_FEATURE(inode->i_sb,
> +			EXT4_FEATURE_RO_COMPAT_PROJECT) &&
> +	       i_projid !=3D EXT4_DEF_PROJID);
> +
> +	if (EXT4_INODE_SIZE(inode->i_sb) > EXT4_GOOD_OLD_INODE_SIZE &&
> +	    EXT4_FITS_IN_INODE(raw_inode, ei, i_projid))
> +		raw_inode->i_projid =3D cpu_to_le32(i_projid);
> +
>  	ext4_inode_csum_set(inode, raw_inode, ei);
>  	spin_unlock(&ei->i_raw_lock);
>  	if (inode->i_sb->s_flags & MS_LAZYTIME)
> diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
> index 9f61e76..61694ad 100644
> --- a/fs/ext4/namei.c
> +++ b/fs/ext4/namei.c
> @@ -3215,6 +3215,12 @@ static int ext4_link(struct dentry *old_dentry,
>  	if (ext4_encrypted_inode(dir) &&
>  	    !ext4_is_child_context_consistent_with_parent(dir, inode))
>  		return -EPERM;
> +
> +       if ((ext4_test_inode_flag(dir, EXT4_INODE_PROJINHERIT)) &&
> +	   (!projid_eq(EXT4_I(dir)->i_projid,
> +		       EXT4_I(old_dentry->d_inode)->i_projid)))
> +		return -EXDEV;
> +
>  	err =3D dquot_initialize(dir);
>  	if (err)
>  		return err;
> @@ -3496,6 +3502,11 @@ static int ext4_rename(struct inode *old_dir, stru=
ct dentry *old_dentry,
>  	int credits;
>  	u8 old_file_type;
>=20=20
> +	if ((ext4_test_inode_flag(new_dir, EXT4_INODE_PROJINHERIT)) &&
> +	    (!projid_eq(EXT4_I(new_dir)->i_projid,
> +			EXT4_I(old_dentry->d_inode)->i_projid)))
> +		return -EXDEV;
> +
>  	retval =3D dquot_initialize(old.dir);
>  	if (retval)
>  		return retval;
> @@ -3705,6 +3716,14 @@ static int ext4_cross_rename(struct inode *old_dir=
, struct dentry *old_dentry,
>  							   new.inode)))
>  		return -EPERM;
>=20=20
> +	if ((ext4_test_inode_flag(new_dir, EXT4_INODE_PROJINHERIT) &&
> +	     !projid_eq(EXT4_I(new_dir)->i_projid,
> +			EXT4_I(old_dentry->d_inode)->i_projid)) ||
> +	    (ext4_test_inode_flag(old_dir, EXT4_INODE_PROJINHERIT) &&
> +	     !projid_eq(EXT4_I(old_dir)->i_projid,
> +			EXT4_I(new_dentry->d_inode)->i_projid)))
> +		return -EXDEV;
> +
>  	retval =3D dquot_initialize(old.dir);
>  	if (retval)
>  		return retval;
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index a63c7b0..d07445e 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -1097,6 +1097,7 @@ static const struct dquot_operations ext4_quota_ope=
rations =3D {
>  	.write_info	=3D ext4_write_info,
>  	.alloc_dquot	=3D dquot_alloc,
>  	.destroy_dquot	=3D dquot_destroy,
> +	.get_projid	=3D ext4_get_projid,
>  };
>=20=20
>  static const struct quotactl_ops ext4_qctl_operations =3D {
> diff --git a/include/uapi/linux/fs.h b/include/uapi/linux/fs.h
> index 9b964a5..f15d980 100644
> --- a/include/uapi/linux/fs.h
> +++ b/include/uapi/linux/fs.h
> @@ -197,6 +197,7 @@ struct inodes_stat_t {
>  #define FS_EXTENT_FL			0x00080000 /* Extents */
>  #define FS_DIRECTIO_FL			0x00100000 /* Use direct i/o */
>  #define FS_NOCOW_FL			0x00800000 /* Do not cow file */
> +#define FS_PROJINHERIT_FL		0x20000000 /* Create with parents projid */
>  #define FS_RESERVED_FL			0x80000000 /* reserved for ext2 lib */
>=20=20
>  #define FS_FL_USER_VISIBLE		0x0003DFFF /* User visible flags */
> --=20
> 1.7.1

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQEcBAEBCgAGBQJWApxuAAoJELhyPTmIL6kB1JEH/2glmj263uKYw5aPpVIFf8G/
O18sF5aaPbx0jTJcJGnZX7mWI3mTe7Se5ZWM+nClz/pHu3wN0xLr5eyRKswgSBlP
hrFwpXGD3FveB13RfN7WIBTY1f9KvxqU9vUk7SDWmPhstsyVv0X7BRs3JhET+Gqk
nxSuGw0XvtihzEGSUmSf0TWS0kPxwmCIB9gXUt+o5uUJUlj2PEPJiA4In0SnBxmu
vJ+qpqtMpgJveh9HoIkeKNqTkTr2BShBGcx2EQ0p3G62msBE9XBjAkpLBFr95IWC
vq4YmuwETcxZncmHLv8GscixDXgvaFcmz9AR8OGREQJRB7f18x876LUIkGmG0dQ=
=HJqg
-----END PGP SIGNATURE-----
--=-=-=--
