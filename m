From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH 2/4] statx: Ext4: Return enhanced file attributes [ver #2]
Date: Fri, 18 Nov 2016 11:02:42 -0700
Message-ID: <5479CD25-51FA-437C-91F7-7204BFE70A6C@dilger.ca>
References: <147948603103.5122.1043337990092830185.stgit@warthog.procyon.org.uk> <147948604541.5122.3541255475695384526.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Content-Type: multipart/signed; boundary="Apple-Mail=_269AD1CD-BB8B-4F2D-92C8-5FED269CDFA4"; protocol="application/pgp-signature"; micalg=pgp-sha256
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <147948604541.5122.3541255475695384526.stgit@warthog.procyon.org.uk>
Sender: linux-fsdevel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org


--Apple-Mail=_269AD1CD-BB8B-4F2D-92C8-5FED269CDFA4
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii


> On Nov 18, 2016, at 9:20 AM, David Howells <dhowells@redhat.com> =
wrote:
>=20
> Return enhanced file attributes from the Ext4 filesystem.  This =
includes
> the following:
>=20
> (1) The inode creation time (i_crtime) as stx_btime, setting =
STATX_BTIME.
>=20
> (2) Certain FS_xxx_FL flags are mapped to stx_attribute flags.
>=20
> This requires that all ext4 inodes have a getattr call, not just some =
of
> them, so to this end, split the ext4_getattr() function and only call =
part
> of it where appropriate.
>=20
> Example output:
>=20
> 	[root@andromeda ~]# touch foo
> 	[root@andromeda ~]# chattr +ai foo
> 	[root@andromeda ~]# /tmp/test-statx foo
> 	statx(foo) =3D 0
> 	results=3Dfff
> 	  Size: 0               Blocks: 0          IO Block: 4096    =
regular file
> 	Device: 08:12           Inode: 2101950     Links: 1
> 	Access: (0644/-rw-r--r--)  Uid:     0   Gid:     0
> 	Access: 2016-02-11 17:08:29.031795451+0000
> 	Modify: 2016-02-11 17:08:29.031795451+0000
> 	Change: 2016-02-11 17:11:11.987790114+0000
> 	 Birth: 2016-02-11 17:08:29.031795451+0000
> 	Attributes: 0000000000000030 (-------- -------- -------- =
-------- -------- -------- -------- --ai----)
> 	IO-blocksize: blksize=3D4096
>=20
> Signed-off-by: David Howells <dhowells@redhat.com>

Reviewed-by: Andreas Dilger <adilger@dilger.ca>

> ---
>=20
> fs/ext4/ext4.h    |    2 ++
> fs/ext4/file.c    |    2 +-
> fs/ext4/inode.c   |   36 +++++++++++++++++++++++++++++++++---
> fs/ext4/namei.c   |    2 ++
> fs/ext4/symlink.c |    2 ++
> 5 files changed, 40 insertions(+), 4 deletions(-)
>=20
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index 282a51b07c57..f65e4a560c4c 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -2485,6 +2485,8 @@ extern int  ext4_getattr(struct vfsmount *mnt, =
struct dentry *dentry,
> 				struct kstat *stat);
> extern void ext4_evict_inode(struct inode *);
> extern void ext4_clear_inode(struct inode *);
> +extern int  ext4_file_getattr(struct vfsmount *mnt, struct dentry =
*dentry,
> +			      struct kstat *stat);
> extern int  ext4_sync_inode(handle_t *, struct inode *);
> extern void ext4_dirty_inode(struct inode *, int);
> extern int ext4_change_inode_journal_flag(struct inode *, int);
> diff --git a/fs/ext4/file.c b/fs/ext4/file.c
> index 2a822d30e73f..20bab4b0d6fc 100644
> --- a/fs/ext4/file.c
> +++ b/fs/ext4/file.c
> @@ -705,7 +705,7 @@ const struct file_operations ext4_file_operations =
=3D {
>=20
> const struct inode_operations ext4_file_inode_operations =3D {
> 	.setattr	=3D ext4_setattr,
> -	.getattr	=3D ext4_getattr,
> +	.getattr	=3D ext4_file_getattr,
> 	.listxattr	=3D ext4_listxattr,
> 	.get_acl	=3D ext4_get_acl,
> 	.set_acl	=3D ext4_set_acl,
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 9c064727ed62..fd7d5f918cc3 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -5229,11 +5229,41 @@ int ext4_setattr(struct dentry *dentry, struct =
iattr *attr)
> int ext4_getattr(struct vfsmount *mnt, struct dentry *dentry,
> 		 struct kstat *stat)
> {
> -	struct inode *inode;
> -	unsigned long long delalloc_blocks;
> +	struct inode *inode =3D d_inode(dentry);
> +	struct ext4_inode *raw_inode;
> +	struct ext4_inode_info *ei =3D EXT4_I(inode);
> +	unsigned int flags;
> +
> +	if (EXT4_FITS_IN_INODE(raw_inode, ei, i_crtime)) {
> +		stat->result_mask |=3D STATX_BTIME;
> +		stat->btime.tv_sec =3D ei->i_crtime.tv_sec;
> +		stat->btime.tv_nsec =3D ei->i_crtime.tv_nsec;
> +	}
> +
> +	ext4_get_inode_flags(ei);
> +	flags =3D ei->i_flags & EXT4_FL_USER_VISIBLE;
> +	if (flags & EXT4_APPEND_FL)
> +		stat->attributes |=3D STATX_ATTR_APPEND;
> +	if (flags & EXT4_COMPR_FL)
> +		stat->attributes |=3D STATX_ATTR_COMPRESSED;
> +	if (flags & EXT4_ENCRYPT_FL)
> +		stat->attributes |=3D STATX_ATTR_ENCRYPTED;
> +	if (flags & EXT4_IMMUTABLE_FL)
> +		stat->attributes |=3D STATX_ATTR_IMMUTABLE;
> +	if (flags & EXT4_NODUMP_FL)
> +		stat->attributes |=3D STATX_ATTR_NODUMP;
>=20
> -	inode =3D d_inode(dentry);
> 	generic_fillattr(inode, stat);
> +	return 0;
> +}
> +
> +int ext4_file_getattr(struct vfsmount *mnt, struct dentry *dentry,
> +		      struct kstat *stat)
> +{
> +	struct inode *inode =3D dentry->d_inode;
> +	u64 delalloc_blocks;
> +
> +	ext4_getattr(mnt, dentry, stat);
>=20
> 	/*
> 	 * If there is inline data in the inode, the inode will normally =
not
> diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
> index 104f8bfba718..e115281fb8c5 100644
> --- a/fs/ext4/namei.c
> +++ b/fs/ext4/namei.c
> @@ -3882,6 +3882,7 @@ const struct inode_operations =
ext4_dir_inode_operations =3D {
> 	.tmpfile	=3D ext4_tmpfile,
> 	.rename		=3D ext4_rename2,
> 	.setattr	=3D ext4_setattr,
> +	.getattr	=3D ext4_getattr,
> 	.listxattr	=3D ext4_listxattr,
> 	.get_acl	=3D ext4_get_acl,
> 	.set_acl	=3D ext4_set_acl,
> @@ -3890,6 +3891,7 @@ const struct inode_operations =
ext4_dir_inode_operations =3D {
>=20
> const struct inode_operations ext4_special_inode_operations =3D {
> 	.setattr	=3D ext4_setattr,
> +	.getattr	=3D ext4_getattr,
> 	.listxattr	=3D ext4_listxattr,
> 	.get_acl	=3D ext4_get_acl,
> 	.set_acl	=3D ext4_set_acl,
> diff --git a/fs/ext4/symlink.c b/fs/ext4/symlink.c
> index 557b3b0d668c..209b833633e2 100644
> --- a/fs/ext4/symlink.c
> +++ b/fs/ext4/symlink.c
> @@ -93,6 +93,7 @@ const struct inode_operations =
ext4_symlink_inode_operations =3D {
> 	.readlink	=3D generic_readlink,
> 	.get_link	=3D page_get_link,
> 	.setattr	=3D ext4_setattr,
> +	.getattr	=3D ext4_getattr,
> 	.listxattr	=3D ext4_listxattr,
> };
>=20
> @@ -100,5 +101,6 @@ const struct inode_operations =
ext4_fast_symlink_inode_operations =3D {
> 	.readlink	=3D generic_readlink,
> 	.get_link	=3D simple_get_link,
> 	.setattr	=3D ext4_setattr,
> +	.getattr	=3D ext4_getattr,
> 	.listxattr	=3D ext4_listxattr,
> };
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe =
linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Cheers, Andreas






--Apple-Mail=_269AD1CD-BB8B-4F2D-92C8-5FED269CDFA4
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBWC9CQ3Kl2rkXzB/gAQjqXBAAgJlVzNGtKNmlz9x6M6Ksb29+G5DFuJ8r
q7Xhp8UZ9OXtiHaGsDgy9ZVLaamPISFOW787ojH4FfzOUuQsbOL5DcwpCmYQRjIx
N0sznMiCJO0rpcde0dMtnshI1tjhOjfMzEfDgfOfC0imzNqS3E1XggSqzz8hSOce
bbjFWHFUE+hGcoE5W6XJyyv7h2EH+OhPQzIpkWpxr8ZojJmK9Sl4x1VjXmQqmvG6
5X3eiFCco5luXNct2IqcGirQcGINOCRN0kx+0wwB4Z3cYUbLFBY1qV8TZ0vkPzCQ
RK4ANu8bmAFxK2G/suoROY2Yo6u/CEsgPWAV9pKj/CaeTcUT7vXCsomGDZWAalc+
kiTitC1pzFs3Mrvc+BmY4NNaFzO15ILpc3Zqu0dC8Th77l3Jys1y2zXyThICwhEG
uReabE+gT7JapiG5vpfKMDhDuOi8Yly6H4T4jRPd6jKFWGbewliRDQbMbXr9WNp+
htDuXbrDz4NjJTvV6sQy0Y/6n0QURpzxZc4yfjmBHUF5IMEFYOvH2tQISf4hye4v
TG1z0tz1L08HcZpC/YX6b/cGwIwpZlj7pMzBPg48Q3eB0sJuAfmEk+9u7ndreSjP
5e5jbAGOBWkY56xHQ+jjIHmOYBllVWte8mNaTwB8Gx6mNmCfW9jzcdZMtnc4aBhO
c4bNzGdfCkQ=
=ozUw
-----END PGP SIGNATURE-----

--Apple-Mail=_269AD1CD-BB8B-4F2D-92C8-5FED269CDFA4--
