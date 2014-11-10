From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [v6 2/4] ext4: adds project ID support
Date: Mon, 10 Nov 2014 15:21:33 -0700
Message-ID: <C174C64E-66E8-405D-903A-C7C162E23AE4@dilger.ca>
References: <1415468619-31851-1-git-send-email-lixi@ddn.com> <1415468619-31851-3-git-send-email-lixi@ddn.com>
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Content-Type: multipart/signed; boundary="Apple-Mail=_FBCB4B69-B3BD-487E-9660-AE69D2F5AE1C"; protocol="application/pgp-signature"; micalg=pgp-sha1
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1415468619-31851-3-git-send-email-lixi@ddn.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Li Xi <pkuelelixi@gmail.com>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-ext4@vger.kernel.org, linux-api@vger.kernel.org, tytso@mit.edu, jack@suse.cz, viro@zeniv.linux.org.uk, hch@infradead.org, dmonakhov@openvz.org
List-Id: linux-api@vger.kernel.org


--Apple-Mail=_FBCB4B69-B3BD-487E-9660-AE69D2F5AE1C
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Nov 8, 2014, at 10:43 AM, Li Xi <pkuelelixi@gmail.com> wrote:
> This patch adds a new internal field of ext4 inode to save project
> identifier. Also a new flag EXT4_INODE_PROJINHERIT is added for
> inheriting project ID from parent directory.
>=20
> Signed-off-by: Li Xi <lixi@ddn.com>
>=20
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index c55a1fa..d30dfa6 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -386,16 +386,18 @@ struct flex_groups {
> #define EXT4_EA_INODE_FL	        0x00200000 /* Inode used for =
large EA */
> #define EXT4_EOFBLOCKS_FL		0x00400000 /* Blocks allocated =
beyond EOF */
> #define EXT4_INLINE_DATA_FL		0x10000000 /* Inode has inline =
data. */
> +#define EXT4_PROJINHERIT_FL		0x20000000 /* Create with =
parents projid */

This should probably be defined in uapi/linux/fs.h:

 #define FS_DIRECTIO_FL			0x00100000 /* Use direct i/o */
 #define FS_NOCOW_FL			0x00800000 /* Do not cow file */
*/
+#define FS_PROJINHERIT_FL		0x20000000 /* Create with parent =
projid */
 #define FS_RESERVED_FL			0x80000000 /* reserved for ext2 =
lib=20

and then here in fs/ext4/ext4.h header define it like:

 #define EXT4_EOFBLOCKS_FL		0x00400000 /* Blocks allocated =
beyond EOF */
 #define EXT4_INLINE_DATA_FL		0x10000000 /* Inode has inline =
data. */
+#define EXT4_PROJINHERIT_FL	FS_PROJINHERIT_FL  /* Create with parent =
projid */

so it is more clear that it is coming from the VFS definition.  That =
also
allows accessing the PROJINHERIT flag with the normal chattr tool.

It wouldn't be a bad idea to add the other values that migrated from
ext4.h into uapi/linux/fs.h back into ext4.h in a similar manner (e.g.
FS_DIRECTIO_FL, FS_NOCOW_FL, in a separate patch) so the gaps in these =
values are explained.

> #define EXT4_RESERVED_FL		0x80000000 /* reserved for ext4 =
lib */
>=20
> -#define EXT4_FL_USER_VISIBLE		0x004BDFFF /* User visible flags =
*/
> -#define EXT4_FL_USER_MODIFIABLE		0x004380FF /* User =
modifiable flags */
> +#define EXT4_FL_USER_VISIBLE		0x204BDFFF /* User visible flags =
*/
> +#define EXT4_FL_USER_MODIFIABLE		0x204380FF /* User =
modifiable flags */
>=20
> /* Flags that should be inherited by new inodes from their parent. */
> #define EXT4_FL_INHERITED (EXT4_SECRM_FL | EXT4_UNRM_FL | =
EXT4_COMPR_FL |\
> 			   EXT4_SYNC_FL | EXT4_NODUMP_FL | =
EXT4_NOATIME_FL |\
> 			   EXT4_NOCOMPR_FL | EXT4_JOURNAL_DATA_FL |\
> -			   EXT4_NOTAIL_FL | EXT4_DIRSYNC_FL)
> +			   EXT4_NOTAIL_FL | EXT4_DIRSYNC_FL |\
> +			   EXT4_PROJINHERIT_FL)
>=20
> /* Flags that are appropriate for regular files (all but dir-specific =
ones). */
> #define EXT4_REG_FLMASK (~(EXT4_DIRSYNC_FL | EXT4_TOPDIR_FL))
> @@ -443,6 +445,7 @@ enum {
> 	EXT4_INODE_EA_INODE	=3D 21,	/* Inode used for large EA */
> 	EXT4_INODE_EOFBLOCKS	=3D 22,	/* Blocks allocated beyond EOF =
*/
> 	EXT4_INODE_INLINE_DATA	=3D 28,	/* Data in inode. */
> +	EXT4_INODE_PROJINHERIT	=3D 29,	/* Create with parents projid */
> 	EXT4_INODE_RESERVED	=3D 31,	/* reserved for ext4 lib */
> };
>=20
> @@ -694,6 +697,7 @@ struct ext4_inode {
> 	__le32  i_crtime;       /* File Creation time */
> 	__le32  i_crtime_extra; /* extra FileCreationtime (nsec << 2 | =
epoch) */
> 	__le32  i_version_hi;	/* high 32 bits for 64-bit version */
> +	__le32  i_projid;	/* Project ID */
> };
>=20
> struct move_extent {
> @@ -943,6 +947,7 @@ struct ext4_inode_info {
>=20
> 	/* Precomputed uuid+inum+igen checksum for seeding inode =
checksums */
> 	__u32 i_csum_seed;
> +	kprojid_t i_projid;
> };
>=20
> /*
> @@ -1526,6 +1531,7 @@ static inline void ext4_clear_state_flags(struct =
ext4_inode_info *ei)
>  * GDT_CSUM bits are mutually exclusive.
>  */
> #define EXT4_FEATURE_RO_COMPAT_METADATA_CSUM	0x0400
> +#define EXT4_FEATURE_RO_COMPAT_PROJECT		0x1000 /* =
Project quota */
>=20
> #define EXT4_FEATURE_INCOMPAT_COMPRESSION	0x0001
> #define EXT4_FEATURE_INCOMPAT_FILETYPE		0x0002
> @@ -1575,7 +1581,8 @@ static inline void ext4_clear_state_flags(struct =
ext4_inode_info *ei)
> 					 =
EXT4_FEATURE_RO_COMPAT_HUGE_FILE |\
> 					 EXT4_FEATURE_RO_COMPAT_BIGALLOC =
|\
> 					 =
EXT4_FEATURE_RO_COMPAT_METADATA_CSUM|\
> -					 EXT4_FEATURE_RO_COMPAT_QUOTA)
> +					 EXT4_FEATURE_RO_COMPAT_QUOTA |\
> +					 EXT4_FEATURE_RO_COMPAT_PROJECT)
>=20
> /*
>  * Default values for user and/or group using reserved blocks
> @@ -1583,6 +1590,11 @@ static inline void =
ext4_clear_state_flags(struct ext4_inode_info *ei)
> #define	EXT4_DEF_RESUID		0
> #define	EXT4_DEF_RESGID		0
>=20
> +/*
> + * Default project ID
> + */
> +#define	EXT4_DEF_PROJID		0
> +
> #define EXT4_DEF_INODE_READAHEAD_BLKS	32
>=20
> /*
> @@ -2135,6 +2147,7 @@ extern int ext4_zero_partial_blocks(handle_t =
*handle, struct inode *inode,
> 			     loff_t lstart, loff_t lend);
> extern int ext4_page_mkwrite(struct vm_area_struct *vma, struct =
vm_fault *vmf);
> extern qsize_t *ext4_get_reserved_space(struct inode *inode);
> +extern int ext4_get_projid(struct inode *inode, kprojid_t *projid);
> extern void ext4_da_update_reserve_space(struct inode *inode,
> 					int used, int quota_claim);
>=20
> diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
> index ac644c3..fefb948 100644
> --- a/fs/ext4/ialloc.c
> +++ b/fs/ext4/ialloc.c
> @@ -756,6 +756,12 @@ struct inode *__ext4_new_inode(handle_t *handle, =
struct inode *dir,
> 		inode->i_gid =3D dir->i_gid;
> 	} else
> 		inode_init_owner(inode, dir, mode);
> +	if (EXT4_HAS_RO_COMPAT_FEATURE(sb, =
EXT4_FEATURE_RO_COMPAT_PROJECT) &&
> +	    ext4_test_inode_flag(dir, EXT4_INODE_PROJINHERIT)) {
> +		ei->i_projid =3D EXT4_I(dir)->i_projid;
> +	} else {
> +		ei->i_projid =3D make_kprojid(&init_user_ns, =
EXT4_DEF_PROJID);
> +	}
> 	dquot_initialize(inode);
>=20
> 	if (!goal)
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 3356ab5..1c440be 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -3886,6 +3886,14 @@ static inline void ext4_iget_extra_inode(struct =
inode *inode,
> 		EXT4_I(inode)->i_inline_off =3D 0;
> }
>=20
> +int ext4_get_projid(struct inode *inode, kprojid_t *projid)
> +{
> +	if (!EXT4_HAS_RO_COMPAT_FEATURE(inode->i_sb, =
EXT4_FEATURE_RO_COMPAT_PROJECT))
> +		return -EOPNOTSUPP;
> +	*projid =3D EXT4_I(inode)->i_projid;
> +	return 0;
> +}
> +
> struct inode *ext4_iget(struct super_block *sb, unsigned long ino)
> {
> 	struct ext4_iloc iloc;
> @@ -3897,6 +3905,7 @@ struct inode *ext4_iget(struct super_block *sb, =
unsigned long ino)
> 	int block;
> 	uid_t i_uid;
> 	gid_t i_gid;
> +	projid_t i_projid;
>=20
> 	inode =3D iget_locked(sb, ino);
> 	if (!inode)
> @@ -3946,12 +3955,18 @@ struct inode *ext4_iget(struct super_block =
*sb, unsigned long ino)
> 	inode->i_mode =3D le16_to_cpu(raw_inode->i_mode);
> 	i_uid =3D (uid_t)le16_to_cpu(raw_inode->i_uid_low);
> 	i_gid =3D (gid_t)le16_to_cpu(raw_inode->i_gid_low);
> +	if (EXT4_HAS_RO_COMPAT_FEATURE(sb, =
EXT4_FEATURE_RO_COMPAT_PROJECT))
> +		i_projid =3D (projid_t)le32_to_cpu(raw_inode->i_projid);
> +	else
> +		i_projid =3D EXT4_DEF_PROJID;
> +
> 	if (!(test_opt(inode->i_sb, NO_UID32))) {
> 		i_uid |=3D le16_to_cpu(raw_inode->i_uid_high) << 16;
> 		i_gid |=3D le16_to_cpu(raw_inode->i_gid_high) << 16;
> 	}
> 	i_uid_write(inode, i_uid);
> 	i_gid_write(inode, i_gid);
> +	ei->i_projid =3D make_kprojid(&init_user_ns, i_projid);;
> 	set_nlink(inode, le16_to_cpu(raw_inode->i_links_count));
>=20
> 	ext4_clear_state_flags(ei);	/* Only relevant on 32-bit archs =
*/
> @@ -4181,6 +4196,7 @@ static int ext4_do_update_inode(handle_t =
*handle,
> 	int need_datasync =3D 0, set_large_file =3D 0;
> 	uid_t i_uid;
> 	gid_t i_gid;
> +	projid_t i_projid;
>=20
> 	spin_lock(&ei->i_raw_lock);
>=20
> @@ -4193,6 +4209,7 @@ static int ext4_do_update_inode(handle_t =
*handle,
> 	raw_inode->i_mode =3D cpu_to_le16(inode->i_mode);
> 	i_uid =3D i_uid_read(inode);
> 	i_gid =3D i_gid_read(inode);
> +	i_projid =3D from_kprojid(&init_user_ns, ei->i_projid);
> 	if (!(test_opt(inode->i_sb, NO_UID32))) {
> 		raw_inode->i_uid_low =3D =
cpu_to_le16(low_16_bits(i_uid));
> 		raw_inode->i_gid_low =3D =
cpu_to_le16(low_16_bits(i_gid));
> @@ -4272,6 +4289,18 @@ static int ext4_do_update_inode(handle_t =
*handle,
> 		}
> 	}
>=20
> +	BUG_ON(!EXT4_HAS_RO_COMPAT_FEATURE(inode->i_sb,
> +			EXT4_FEATURE_RO_COMPAT_PROJECT) &&
> +	       i_projid !=3D EXT4_DEF_PROJID);
> +	if (i_projid !=3D EXT4_DEF_PROJID &&
> +	    (EXT4_INODE_SIZE(inode->i_sb) <=3D EXT4_GOOD_OLD_INODE_SIZE =
||
> +	     (!EXT4_FITS_IN_INODE(raw_inode, ei, i_projid)))) {
> +		spin_unlock(&ei->i_raw_lock);
> +		err =3D -EFBIG;
> +		goto out_brelse;
> +	}
> +	raw_inode->i_projid =3D cpu_to_le32(i_projid);
> +
> 	ext4_inode_csum_set(inode, raw_inode, ei);
>=20
> 	spin_unlock(&ei->i_raw_lock);
> diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
> index 4262118..160a743 100644
> --- a/fs/ext4/namei.c
> +++ b/fs/ext4/namei.c
> @@ -2939,6 +2939,11 @@ static int ext4_link(struct dentry *old_dentry,
> 	if (inode->i_nlink >=3D EXT4_LINK_MAX)
> 		return -EMLINK;
>=20
> +	if ((ext4_test_inode_flag(dir, EXT4_INODE_PROJINHERIT)) &&
> +	    (!projid_eq(EXT4_I(dir)->i_projid,
> +			EXT4_I(old_dentry->d_inode)->i_projid)))
> +		return -EXDEV;
> +
> 	dquot_initialize(dir);
>=20
> retry:
> @@ -3218,6 +3223,11 @@ static int ext4_rename(struct inode *old_dir, =
struct dentry *old_dentry,
> 	int credits;
> 	u8 old_file_type;
>=20
> +	if ((ext4_test_inode_flag(new_dir, EXT4_INODE_PROJINHERIT)) &&
> +	    (!projid_eq(EXT4_I(new_dir)->i_projid,
> +			EXT4_I(old_dentry->d_inode)->i_projid)))
> +		return -EXDEV;
> +
> 	dquot_initialize(old.dir);
> 	dquot_initialize(new.dir);
>=20
> @@ -3396,6 +3406,13 @@ static int ext4_cross_rename(struct inode =
*old_dir, struct dentry *old_dentry,
> 	u8 new_file_type;
> 	int retval;
>=20
> +	if ((ext4_test_inode_flag(new_dir, EXT4_INODE_PROJINHERIT)) &&
> +	    ((!projid_eq(EXT4_I(new_dir)->i_projid,
> +			 EXT4_I(old_dentry->d_inode)->i_projid)) ||
> +	     (!projid_eq(EXT4_I(old_dir)->i_projid,
> +			 EXT4_I(new_dentry->d_inode)->i_projid))))
> +		return -EXDEV;
> +
> 	dquot_initialize(old.dir);
> 	dquot_initialize(new.dir);
>=20
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index 2c9e686..d8a348d 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -1077,6 +1077,7 @@ static const struct dquot_operations =
ext4_quota_operations =3D {
> 	.write_info	=3D ext4_write_info,
> 	.alloc_dquot	=3D dquot_alloc,
> 	.destroy_dquot	=3D dquot_destroy,
> +	.get_projid	=3D ext4_get_projid,
> };
>=20
> static const struct quotactl_ops ext4_qctl_operations =3D {
> --=20
> 1.7.1
>=20


Cheers, Andreas






--Apple-Mail=_FBCB4B69-B3BD-487E-9660-AE69D2F5AE1C
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBVGE6bXKl2rkXzB/gAQJ2Gg//UHUUVSUq+k3OaG0PjAz9Hn9+ROI7QclW
jJD3Dn27DTlyx1mqK/4Y4+VLlfFPLGBqOzidTa9/XzmlmZK7d0NZkMghXwiNQ5V3
4gs/XT8VbzCH1pAYA90vCA11frLbEFIpi0Mlv8+btoVgxGleYH+d+USTMRrMZY9X
EWa/DzqbXVc6pGGMIWwjniia2N3cGyXoU0Q8PhlVyIq4+zqToG7J+ewe15f+pG9E
g3HhN+TBj/6+8YB80RTford1pSGLRZqwxL9olherueCos6gCaFW4WnyozZE7HHia
BEWRcFcG7WM4khd8tnIAMQluRP74hONcwzwePKP9PDWz0JIwUJy1Ru1wf3JALCDW
aU8eL+2MqRS5UetxQsl5lFu8iphwFhqR3WVLBiVsymyhqNVyZLR40NxQxdep36j5
o44ZHIcSi4WapgXZSj5IfdLbD2XlAsyaxiTC6rlMiiBgcLZjr6VE2BLfIx21lCFW
vJ/r1uaSSUBQkuyhLt+WLEZzRurnuqJQ73AQFB2Zka08ck6ITYeDg4r3aAKq5Y0Q
Lmn2L4sP56BkM9dxrmNYpXrbLPr8v1WbTCfoqkQRKBd8cIRDUrt9sqOCesexkRXY
bzLrLz2BheGIhCH29U8fTmD2nXJ1EgS4TTvRwH7cQEgGBMe7gROt+TiPu59UiTiv
T3rYr3rogcE=
=7tHT
-----END PGP SIGNATURE-----

--Apple-Mail=_FBCB4B69-B3BD-487E-9660-AE69D2F5AE1C--
