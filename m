From: Andreas Dilger <adilger-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>
Subject: Re: [PATCH 2/4] statx: Ext4: Return enhanced file attributes [ver #3]
Date: Wed, 23 Nov 2016 10:59:49 -0700
Message-ID: <16F32527-C6DF-4CD2-B257-F0A50C07FE09@dilger.ca>
References: <147986254484.19139.8038609825799670925.stgit@warthog.procyon.org.uk> <147986255921.19139.6012507332848890196.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Content-Type: multipart/signed; boundary="Apple-Mail=_5B543111-5A43-44D7-A5EB-E3FD91898E21"; protocol="application/pgp-signature"; micalg=pgp-sha256
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <147986255921.19139.6012507332848890196.stgit-S6HVgzuS8uM4Awkfq6JHfwNdhmdF6hFW@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org


--Apple-Mail=_5B543111-5A43-44D7-A5EB-E3FD91898E21
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Nov 22, 2016, at 5:55 PM, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
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
> Signed-off-by: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Reviewed-by: Andreas Dilger <adilger-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>

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
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Cheers, Andreas






--Apple-Mail=_5B543111-5A43-44D7-A5EB-E3FD91898E21
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBWDXZF3Kl2rkXzB/gAQjgPQ/8DqqnJNKGJu4dssGPWrbn2ETBoTTmYMfj
F2ca5n3ExuOkFGsY53NaQEgk5xkLTTD41vk5r5L5sxWyKrWAuRhehK4HcjRHgpvY
1eC8jIeudJkb+h2shs9Ur9uiQzS9ZmsToBwOwpa9o4Ke599nL03xtqueAxETn7X5
Ml2NqX/cLTtOOWs3J+YyIQO30Rf/WJm7tsDSbJ1sus4FSFSE4HVdL4IAeRDwEBhX
VSvXhGX65FrIanGY25xU+LuR+3KrhjEXswl6PTBg33ZbSn4xSRkkt6522s8tLBzn
h+F2JMb2QRVe40GmWDbyNjfaEWPgLT+gWpZhZoamMk2LcTKWnu9M3objgxJEpV4N
YhW616/EIbbxOZBSH84dJIG1+ZtcC3FuVf+Bt4R6KrEOlca76hIqJ51czNngBd3W
4/WHY/kh0nRrk48aQEzT/Mf5MfBSSarVXHVtY2lr8pTGyGFWYVEJqnufpbH20O0+
NSGi+Ly7Rcp+Qz5KOp0nKDeSTxCfsBB9jPz48lHNrKtXPn1e3Mpy2Ae7r3fk8vG4
BWsBe0MND7UrkO4hqqnoqXuV+ycpXJKkTqaequNcIhNSNkda73K4p0P1cGonpu18
+tQFC4ncEtn2EY/u62T/VYu2/el/7FepJ6zfC3InIoHAUtkEFBY4DsvFqmMXNpTS
C0qOR9NDndA=
=K6NM
-----END PGP SIGNATURE-----

--Apple-Mail=_5B543111-5A43-44D7-A5EB-E3FD91898E21--
