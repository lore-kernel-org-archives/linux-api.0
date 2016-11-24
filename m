From: Andreas Dilger <adilger-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>
Subject: Re: [PATCH 4/4] statx: AFS: Return enhanced file attributes [ver #3]
Date: Wed, 23 Nov 2016 19:06:30 -0700
Message-ID: <347478EC-7A98-40C0-97EB-2677B6BE1654@dilger.ca>
References: <147986254484.19139.8038609825799670925.stgit@warthog.procyon.org.uk> <147986257312.19139.10417237189956494459.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Content-Type: multipart/signed; boundary="Apple-Mail=_99D2B324-DF18-45E7-B0E6-2D87F25F3FB9"; protocol="application/pgp-signature"; micalg=pgp-sha256
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <147986257312.19139.10417237189956494459.stgit-S6HVgzuS8uM4Awkfq6JHfwNdhmdF6hFW@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org


--Apple-Mail=_99D2B324-DF18-45E7-B0E6-2D87F25F3FB9
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Nov 22, 2016, at 5:56 PM, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>=20
> Return enhanced file attributes from the AFS filesystem.  This =
includes the
> following:
>=20
> (1) STATX_ATTR_AUTOMOUNT will be set on automount directories by =
virtue of
>     S_AUTOMOUNT being set on the inode.  These are referrals to other
>     volumes or other cells.
>=20
> STATX_ATIME, STATX_CTIME and STATX_BLOCKS are cleared as AFS does not
> support them.
>=20
> Example output:
>=20
> 	[root@andromeda ~]# ./samples/statx/test-statx /afs
> 	statx(/afs) =3D 0
> 	results=3D7ef

This decodes to everything except STATX_GID being set:
STATX_TYPE	0x00000001U
STATX_MODE	0x00000002U
STATX_NLINK	0x00000004U
STATX_UID	0x00000008U
!STATX_GID	0x00000010U
STATX_ATIME	0x00000020U
STATX_MTIME	0x00000040U
STATX_CTIME	0x00000080U
STATX_INO	0x00000100U
STATX_SIZE	0x00000200U
STATX_BLOCKS	0x00000400U

> 	Size: 2048      Blocks: 0      IO Block: 4096  directory
> 	Device: 00:25           Inode: 1           Links: 2
> 	Access: (0777/drwxrwxrwx)  Uid:     0   Gid:     0
> 	Access: 2006-05-07 00:21:15.000000000+0100
> 	Modify: 2006-05-07 00:21:15.000000000+0100
> 	Change: 2006-05-07 00:21:15.000000000+0100
> 	IO-blocksize: blksize=3D4096


This is printing Access and Change times, but you write above that
STATX_ATIME, STATX_CTIME, and STATX_BLOCKS are unset for AFS, so they
shouldn't be printed?  Since "results" appear to indicate those flags
are set, and looking at the dump_statx() code appears that they are
checked, it seems this patch isn't doing what you want to clear flags?

Also, it seems that "Gid:  0" is printed even though it is not set in =
stx_mask?  Possibly this example is old?

Cheers, Andreas

> Signed-off-by: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>=20
> fs/afs/inode.c |   11 ++++++-----
> 1 file changed, 6 insertions(+), 5 deletions(-)
>=20
> diff --git a/fs/afs/inode.c b/fs/afs/inode.c
> index 86cc7264c21c..99662045b6fb 100644
> --- a/fs/afs/inode.c
> +++ b/fs/afs/inode.c
> @@ -72,9 +72,9 @@ static int afs_inode_map_status(struct afs_vnode =
*vnode, struct key *key)
> 	inode->i_uid		=3D vnode->status.owner;
> 	inode->i_gid		=3D GLOBAL_ROOT_GID;
> 	inode->i_size		=3D vnode->status.size;
> -	inode->i_ctime.tv_sec	=3D vnode->status.mtime_server;
> -	inode->i_ctime.tv_nsec	=3D 0;
> -	inode->i_atime		=3D inode->i_mtime =3D inode->i_ctime;
> +	inode->i_mtime.tv_sec	=3D vnode->status.mtime_server;
> +	inode->i_mtime.tv_nsec	=3D 0;
> +	inode->i_atime		=3D inode->i_ctime =3D inode->i_mtime;
> 	inode->i_blocks		=3D 0;
> 	inode->i_generation	=3D vnode->fid.unique;
> 	inode->i_version	=3D vnode->status.data_version;
> @@ -375,8 +375,7 @@ int afs_validate(struct afs_vnode *vnode, struct =
key *key)
> /*
>  * read the attributes of an inode
>  */
> -int afs_getattr(struct vfsmount *mnt, struct dentry *dentry,
> -		      struct kstat *stat)
> +int afs_getattr(struct vfsmount *mnt, struct dentry *dentry, struct =
kstat *stat)
> {
> 	struct inode *inode;
>=20
> @@ -385,6 +384,8 @@ int afs_getattr(struct vfsmount *mnt, struct =
dentry *dentry,
> 	_enter("{ ino=3D%lu v=3D%u }", inode->i_ino, =
inode->i_generation);
>=20
> 	generic_fillattr(inode, stat);
> +
> +	stat->result_mask &=3D ~(STATX_ATIME | STATX_CTIME | =
STATX_BLOCKS);
> 	return 0;
> }
>=20
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe =
linux-fsdevel" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Cheers, Andreas






--Apple-Mail=_99D2B324-DF18-45E7-B0E6-2D87F25F3FB9
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBWDZLJnKl2rkXzB/gAQjStBAAs8sAGqgGJndrEGwhwO2tsgDwO4JNYJT4
Dpnej/FDbf8d1C9iwDmwMSGXCpHF13nncFsJn9sW4E5fWff5CMrAMY70dKrDGt+d
ULVuXbkl/jd6P+BZ2o5LGf5YVE2hJxUy1S84qwul7so4O1ErzGAp+koUx9vSMemD
rGw3RreujS2488m9R9WE3vZyc6+YONaWmLC7owEzcepsKAF5Z+yJZfSuIF97a5LN
ry/pk956bEqaGU3ycM8V4RPQyzyUi18AjSeenmUlbC3vSFShKtQ4ULqMrSk6RjAS
y5FHkzZkNCW3WWPpzOteRUNkL+gln8PRdfx0s5zaI3oEegRLSH0FQmjbS/Hgp3+6
d37PqsEa4hrZBEWOairi1U2eXT56AM9+3zTB+rEDVuK9Xv1eMiy1cts5V5GVjuq8
TB5rM++WkTDuw9ljmgWO6I1HCFW/6TjaK3APxes9fUl9uAXGe/6QTxTx+qRrD9Zf
cGy2QzIs+c2YccEXR4zUutCG7Tc2SGnCppGQHiELy4VyvzmlZue3ZvKQ6UgmSLdY
moGSF9jncp6KFeIc6f8h8Gd/u83VBVp8tm66AnAs9PalB9YfGee3zz5e8c41jISt
QvQSe7YpMXqyDG4V1ecOGlPh0nxcXE1E6mcfKaKei2566f8WS4tBKncWio02jEKd
dCC2PjI3G3E=
=u1II
-----END PGP SIGNATURE-----

--Apple-Mail=_99D2B324-DF18-45E7-B0E6-2D87F25F3FB9--
