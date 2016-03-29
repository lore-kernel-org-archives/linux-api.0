From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH 07/10] simplify the generic_write_sync prototype
Date: Tue, 29 Mar 2016 13:33:48 -0600
Message-ID: <E85DBB2A-4E22-47AD-9B2B-FB6BD43DC62D@dilger.ca>
References: <1459273054-13478-1-git-send-email-hch@lst.de> <1459273054-13478-8-git-send-email-hch@lst.de>
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Content-Type: multipart/signed; boundary="Apple-Mail=_787CA220-9346-4623-9F3F-81DF5918FD62"; protocol="application/pgp-signature"; micalg=pgp-sha256
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1459273054-13478-8-git-send-email-hch@lst.de>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: viro@ZenIV.linux.org.uk, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org


--Apple-Mail=_787CA220-9346-4623-9F3F-81DF5918FD62
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Mar 29, 2016, at 11:37 AM, Christoph Hellwig <hch@lst.de> wrote:
>=20
> The kiocb already has the new position, so use that.  The only =
interesting
> case is AIO, where we currently don't bother updating ki_pos.  We're =
about
> to free the kiocb after we're done, so we might as well update it to =
make
> everyone's life simpler.
>=20
> While we're at it also return the bytes written argument passed in if
> we were successful so that the boilerplate error switch code in the
> callers can go away.
>=20
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
> fs/block_dev.c     |  8 ++------
> fs/btrfs/file.c    |  7 ++-----
> fs/cifs/file.c     |  7 ++-----
> fs/direct-io.c     | 17 +++++++++--------
> fs/ext4/file.c     |  9 ++-------
> fs/f2fs/file.c     |  9 ++-------
> fs/nfs/direct.c    |  4 +++-
> fs/ntfs/file.c     |  7 ++-----
> fs/udf/file.c      |  4 +---
> fs/xfs/xfs_file.c  |  6 +-----
> include/linux/fs.h | 24 ++++++++++++++++++------
> mm/filemap.c       |  9 ++-------
> 12 files changed, 46 insertions(+), 65 deletions(-)
>=20
> diff --git a/fs/block_dev.c b/fs/block_dev.c
> index 12a48db..2d404c9 100644
> --- a/fs/block_dev.c
> +++ b/fs/block_dev.c
> @@ -1660,12 +1660,8 @@ ssize_t blkdev_write_iter(struct kiocb *iocb, =
struct iov_iter *from)
>=20
> 	blk_start_plug(&plug);
> 	ret =3D __generic_file_write_iter(iocb, from);
> -	if (ret > 0) {
> -		ssize_t err;
> -		err =3D generic_write_sync(iocb, iocb->ki_pos - ret, =
ret);
> -		if (err < 0)
> -			ret =3D err;
> -	}
> +	if (ret > 0)
> +		ret =3D generic_write_sync(iocb, ret);
> 	blk_finish_plug(&plug);
> 	return ret;
> }
> diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
> index ca642fc..587e1d0 100644
> --- a/fs/btrfs/file.c
> +++ b/fs/btrfs/file.c
> @@ -1851,11 +1851,8 @@ static ssize_t btrfs_file_write_iter(struct =
kiocb *iocb,
> 	spin_lock(&BTRFS_I(inode)->lock);
> 	BTRFS_I(inode)->last_sub_trans =3D root->log_transid;
> 	spin_unlock(&BTRFS_I(inode)->lock);
> -	if (num_written > 0) {
> -		err =3D generic_write_sync(iocb, pos, num_written);
> -		if (err < 0)
> -			num_written =3D err;
> -	}
> +	if (num_written > 0)
> +		num_written =3D generic_write_sync(iocb, num_written);
>=20
> 	if (sync)
> 		atomic_dec(&BTRFS_I(inode)->sync_writers);
> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> index b5ce3a5..3b5bb62 100644
> --- a/fs/cifs/file.c
> +++ b/fs/cifs/file.c
> @@ -2687,11 +2687,8 @@ cifs_writev(struct kiocb *iocb, struct iov_iter =
*from)
> out:
> 	inode_unlock(inode);
>=20
> -	if (rc > 0) {
> -		ssize_t err =3D generic_write_sync(iocb, iocb->ki_pos - =
rc, rc);
> -		if (err < 0)
> -			rc =3D err;
> -	}
> +	if (rc > 0)
> +		rc =3D generic_write_sync(iocb, rc);
> 	up_read(&cinode->lock_sem);
> 	return rc;
> }
> diff --git a/fs/direct-io.c b/fs/direct-io.c
> index e9369dd..f8ae0a6 100644
> --- a/fs/direct-io.c
> +++ b/fs/direct-io.c
> @@ -256,6 +256,7 @@ static ssize_t dio_complete(struct dio *dio, =
ssize_t ret, bool is_async)
> 	if (dio->end_io) {
> 		int err;
>=20
> +		// XXX: ki_pos??
> 		err =3D dio->end_io(dio->iocb, offset, ret, =
dio->private);
> 		if (err)
> 			ret =3D err;
> @@ -265,15 +266,15 @@ static ssize_t dio_complete(struct dio *dio, =
ssize_t ret, bool is_async)
> 		inode_dio_end(dio->inode);
>=20
> 	if (is_async) {
> -		if (dio->rw & WRITE) {
> -			int err;
> -
> -			err =3D generic_write_sync(dio->iocb, offset,
> -						 transferred);
> -			if (err < 0 && ret > 0)
> -				ret =3D err;
> -		}
> +		/*
> +		 * generic_write_syncgeneric_write_sync expects ki_pos =
to

"generic_write_sync" repeated in the comment here.

Cheers, Andreas

> +		 * have been updated already, but the submission path =
only
> +		 * does this for synchronous I/O.
> +		 */
> +		dio->iocb->ki_pos +=3D transferred;
>=20
> +		if (dio->rw & WRITE)
> +			ret =3D generic_write_sync(dio->iocb,  =
transferred);
> 		dio->iocb->ki_complete(dio->iocb, ret, 0);
> 	}
>=20
> diff --git a/fs/ext4/file.c b/fs/ext4/file.c
> index ad19af7c..56ac32c 100644
> --- a/fs/ext4/file.c
> +++ b/fs/ext4/file.c
> @@ -169,13 +169,8 @@ ext4_file_write_iter(struct kiocb *iocb, struct =
iov_iter *from)
> 	ret =3D __generic_file_write_iter(iocb, from);
> 	inode_unlock(inode);
>=20
> -	if (ret > 0) {
> -		ssize_t err;
> -
> -		err =3D generic_write_sync(iocb, iocb->ki_pos - ret, =
ret);
> -		if (err < 0)
> -			ret =3D err;
> -	}
> +	if (ret > 0)
> +		ret =3D generic_write_sync(iocb, ret);
> 	if (o_direct)
> 		blk_finish_plug(&plug);
>=20
> diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
> index 407cc57..8f2d65b 100644
> --- a/fs/f2fs/file.c
> +++ b/fs/f2fs/file.c
> @@ -1882,13 +1882,8 @@ static ssize_t f2fs_file_write_iter(struct =
kiocb *iocb, struct iov_iter *from)
> 	}
> 	inode_unlock(inode);
>=20
> -	if (ret > 0) {
> -		ssize_t err;
> -
> -		err =3D generic_write_sync(iocb, iocb->ki_pos - ret, =
ret);
> -		if (err < 0)
> -			ret =3D err;
> -	}
> +	if (ret > 0)
> +		ret =3D generic_write_sync(iocb, ret);
> 	return ret;
> }
>=20
> diff --git a/fs/nfs/direct.c b/fs/nfs/direct.c
> index 20f1530..5f18775 100644
> --- a/fs/nfs/direct.c
> +++ b/fs/nfs/direct.c
> @@ -1054,7 +1054,9 @@ ssize_t nfs_file_direct_write(struct kiocb =
*iocb, struct iov_iter *iter)
> 			if (i_size_read(inode) < iocb->ki_pos)
> 				i_size_write(inode, iocb->ki_pos);
> 			spin_unlock(&inode->i_lock);
> -			generic_write_sync(iocb, pos, result);
> +
> +			/* XXX: should check the generic_write_sync =
retval */
> +			generic_write_sync(iocb, result);
> 		}
> 	}
> 	nfs_direct_req_release(dreq);
> diff --git a/fs/ntfs/file.c b/fs/ntfs/file.c
> index 2655d12..01173d9 100644
> --- a/fs/ntfs/file.c
> +++ b/fs/ntfs/file.c
> @@ -1952,12 +1952,9 @@ static ssize_t ntfs_file_write_iter(struct =
kiocb *iocb, struct iov_iter *from)
> 		written =3D ntfs_perform_write(file, from, =
iocb->ki_pos);
> 	current->backing_dev_info =3D NULL;
> 	inode_unlock(vi);
> -	if (likely(written > 0)) {
> -		err =3D generic_write_sync(iocb, iocb->ki_pos, written);
> -		if (err < 0)
> -			written =3D 0;
> -	}
> 	iocb->ki_pos +=3D written;
> +	if (likely(written > 0))
> +		written =3D generic_write_sync(iocb, written);
> 	return written ? written : err;
> }
>=20
> diff --git a/fs/udf/file.c b/fs/udf/file.c
> index 28e20c4..54d1d1d 100644
> --- a/fs/udf/file.c
> +++ b/fs/udf/file.c
> @@ -152,9 +152,7 @@ out:
>=20
> 	if (retval > 0) {
> 		mark_inode_dirty(inode);
> -		err =3D generic_write_sync(iocb, iocb->ki_pos - retval, =
retval);
> -		if (err < 0)
> -			retval =3D err;
> +		retval =3D generic_write_sync(iocb, retval);
> 	}
>=20
> 	return retval;
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index 31079dc..cfab637 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -903,14 +903,10 @@ xfs_file_write_iter(
> 		ret =3D xfs_file_buffered_aio_write(iocb, from);
>=20
> 	if (ret > 0) {
> -		ssize_t err;
> -
> 		XFS_STATS_ADD(ip->i_mount, xs_write_bytes, ret);
>=20
> 		/* Handle various SYNC-type writes */
> -		err =3D generic_write_sync(iocb, iocb->ki_pos - ret, =
ret);
> -		if (err < 0)
> -			ret =3D err;
> +		ret =3D generic_write_sync(iocb, ret);
> 	}
> 	return ret;
> }
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index b9b1327..661f56a 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -2477,13 +2477,25 @@ extern int filemap_fdatawrite_range(struct =
address_space *mapping,
> extern int vfs_fsync_range(struct file *file, loff_t start, loff_t =
end,
> 			   int datasync);
> extern int vfs_fsync(struct file *file, int datasync);
> -static inline int generic_write_sync(struct kiocb *iocb, loff_t pos, =
loff_t count)
> -{
> -	if (!(iocb->ki_flags & IOCB_DSYNC))
> -		return 0;
> -	return vfs_fsync_range(iocb->ki_filp, pos, pos + count - 1,
> -			       (iocb->ki_flags & IOCB_SYNC) ? 0 : 1);
> +
> +/*
> + * Sync the bytes written if this was a synchronous write.  Expect =
ki_pos
> + * to already be updated for the write, and will return either the =
amount
> + * of bytes passed in, or an error if syncing the file failed.
> + */
> +static inline ssize_t generic_write_sync(struct kiocb *iocb, ssize_t =
count)
> +{
> +	if (iocb->ki_flags & IOCB_DSYNC) {
> +		int ret =3D vfs_fsync_range(iocb->ki_filp,
> +				iocb->ki_pos - count, iocb->ki_pos - 1,
> +				(iocb->ki_flags & IOCB_SYNC) ? 0 : 1);
> +		if (ret)
> +			return ret;
> +	}
> +
> +	return count;
> }
> +
> extern void emergency_sync(void);
> extern void emergency_remount(void);
> #ifdef CONFIG_BLOCK
> diff --git a/mm/filemap.c b/mm/filemap.c
> index cc44b1d..e3a6662 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -2791,13 +2791,8 @@ ssize_t generic_file_write_iter(struct kiocb =
*iocb, struct iov_iter *from)
> 		ret =3D __generic_file_write_iter(iocb, from);
> 	inode_unlock(inode);
>=20
> -	if (ret > 0) {
> -		ssize_t err;
> -
> -		err =3D generic_write_sync(iocb, iocb->ki_pos - ret, =
ret);
> -		if (err < 0)
> -			ret =3D err;
> -	}
> +	if (ret > 0)
> +		ret =3D generic_write_sync(iocb, ret);
> 	return ret;
> }
> EXPORT_SYMBOL(generic_file_write_iter);
> --
> 2.1.4
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe =
linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Cheers, Andreas






--Apple-Mail=_787CA220-9346-4623-9F3F-81DF5918FD62
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBVvrYnXKl2rkXzB/gAQjTxw//bB4SNziOn4imXeJsdNVHMDufhDNWKCQI
GiwY0dgavebqF5woGC/GNcARj8x0Y8pn4fU379CPlzJxeYDa/TRSL3acxuzABs0o
qFqQfX7P1/tLDclPhka2mwFo0k4bmlEHSVmXDV9LljKYOVOWHwgfVw2M+aOIFAO3
JOd1wtN4Gf5uinUHmGqbu2oVaRPwPH6KmsInAsxwxLI6JcPzlLY366Ux1aay89Ne
M+oK66PGrt7Nd00S0dRUuC2Syvxj+QfVG4zB2YVl3C/ymN2Sh9pjbZZO+HLuieLa
aTKoU3iWLyVrpc3HTEMNOOuJ6VB6WzPrCXz7lafwAeCj6H7LoFaHXUWzLybu3ZgJ
29RkM4Dt7zHpvYuNe8rRDIzequfRLEBh78jzWzHzYfFASoCgmCDfmj+wL3wb25vC
+WKro0UxfCd+XRo08rAo+CnTY7jPTrk3WoxDRy5hLZI/ScEYaiP8Myh3pZYKBF2a
YGqBL3p3cbeMNOYiQXA7ifSoWzaXWD2ijk2zTuUbDeVjFOU1b/g38B8BTSdJn3zK
yATy8OH9G3aAYUzYODmRTuMffLFmNyIgE9kQpS62IerksC/EknLsNS9BpuvBQLO3
HziQ8+Pt9fzGEGQ4g1uF8dTr1rXExVLMRn7ggpZUnfHPNaM1cM5MPNlHoHOy+W/8
kNbC6SysWPk=
=yeaA
-----END PGP SIGNATURE-----

--Apple-Mail=_787CA220-9346-4623-9F3F-81DF5918FD62--
