From: Jann Horn <jann@thejh.net>
Subject: Re: [PATCH v5] fuse: Add support for passthrough read/write
Date: Tue, 2 Feb 2016 09:10:35 +0100
Message-ID: <20160202081035.GA18246@pc.thejh.net>
References: <56AFAA5B.3000006@codeaurora.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="y0ulUmNC+osPPQO6"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <56AFAA5B.3000006@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Nikhilesh Reddy <reddyn@codeaurora.org>
Cc: torvalds@linux-foundation.org, Miklos Szeredi <miklos@szeredi.hu>, fuse-devel <fuse-devel@lists.sourceforge.net>, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, gregkh@linuxfoundation.org, linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk, Richard Weinberger <richard@nod.at>, Theodore Ts'o <tytso@mit.edu>, jack@suse.cz, Antonio SJ Musumeci <trapexit@spawn.link>, sven.utcke@gmx.de, Nikolaus Rath <nikolaus@rath.org>, Jann Horn <jannhorn@googlemail.com>, Mike Shal <marfey@gmail.com>
List-Id: linux-api@vger.kernel.org


--y0ulUmNC+osPPQO6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 01, 2016 at 10:56:27AM -0800, Nikhilesh Reddy wrote:
> Add support for filesystem passthrough read/write of files
> when enabled in userspace through the option FUSE_PASSTHROUGH.
[...]
> diff --git a/fs/fuse/passthrough.c b/fs/fuse/passthrough.c
[...]
> +static ssize_t fuse_passthrough_read_write_iter(struct kiocb *iocb,
> +					    struct iov_iter *iter, int do_write)
> +{
> +	ssize_t ret_val;
> +	struct fuse_file *ff;
> +	struct file *fuse_file, *passthrough_filp;
> +	struct inode *fuse_inode, *passthrough_inode;
> +
> +	ff =3D iocb->ki_filp->private_data;
> +	fuse_file =3D iocb->ki_filp;
> +	passthrough_filp =3D ff->passthrough_filp;
> +
> +	/* lock passthrough file to prevent it from being released */
> +	get_file(passthrough_filp);
> +	iocb->ki_filp =3D passthrough_filp;
> +	fuse_inode =3D fuse_file->f_path.dentry->d_inode;
> +	passthrough_inode =3D file_inode(passthrough_filp);
> +
> +	if (do_write) {
> +		if (!passthrough_filp->f_op->write_iter)
> +			return -EIO;
> +		ret_val =3D passthrough_filp->f_op->write_iter(iocb, iter);

Uh... how do you know at this point that the file is actually writable?
Normally, e.g. vfs_write() will ensure that the file is writable, and
e.g. generic_file_write_iter() won't check for writability as far as I
can tell. This might allow someone to use the passthrough mechanism to
overwrite a file he is only allowed to read, but not write, like
/etc/passwd.

Also, I think this might bypass mandatory locks, the
security_file_permission hook (which seems like a bad idea anyway
though), inotify/fsnotify and sb_start_write.



> +
> +		if (ret_val >=3D 0 || ret_val =3D=3D -EIOCBQUEUED) {
> +			fsstack_copy_inode_size(fuse_inode, passthrough_inode);
> +			fsstack_copy_attr_times(fuse_inode, passthrough_inode);
> +		}
> +	} else {
> +		if (!passthrough_filp->f_op->read_iter)
> +			return -EIO;
> +		ret_val =3D passthrough_filp->f_op->read_iter(iocb, iter);
> +		if (ret_val >=3D 0 || ret_val =3D=3D -EIOCBQUEUED)
> +			fsstack_copy_attr_atime(fuse_inode, passthrough_inode);
> +	}
> +
> +	iocb->ki_filp =3D fuse_file;
> +
> +	/* unlock passthrough file */
> +	fput(passthrough_filp);
> +
> +	return ret_val;
> +}
> +
> +ssize_t fuse_passthrough_read_iter(struct kiocb *iocb, struct iov_iter *=
to)
> +{
> +	return fuse_passthrough_read_write_iter(iocb, to, 0);
> +}
> +
> +ssize_t fuse_passthrough_write_iter(struct kiocb *iocb, struct iov_iter =
*from)
> +{
> +	return fuse_passthrough_read_write_iter(iocb, from, 1);
> +}
> +
> +void fuse_passthrough_release(struct fuse_file *ff)
> +{
> +	if (!(ff->passthrough_filp))
> +		return;
> +
> +	/* Release the passthrough file. */
> +	fput(ff->passthrough_filp);
> +	ff->passthrough_filp =3D NULL;
> +}
> diff --git a/include/uapi/linux/fuse.h b/include/uapi/linux/fuse.h
> index c9aca04..a08933a 100644
> --- a/include/uapi/linux/fuse.h
> +++ b/include/uapi/linux/fuse.h
> @@ -250,6 +250,7 @@ struct fuse_file_lock {
>  #define FUSE_ASYNC_DIO		(1 << 15)
>  #define FUSE_WRITEBACK_CACHE	(1 << 16)
>  #define FUSE_NO_OPEN_SUPPORT	(1 << 17)
> +#define FUSE_PASSTHROUGH	(1 << 18)
> =20
>  /**
>   * CUSE INIT request/reply flags
> @@ -480,7 +481,7 @@ struct fuse_create_in {
>  struct fuse_open_out {
>  	uint64_t	fh;
>  	uint32_t	open_flags;
> -	uint32_t	padding;
> +	int32_t         passthrough_fd;
>  };
> =20
>  struct fuse_release_in {
> --=20
> 1.8.2.1
>=20
>=20
> --=20
> Thanks
> Nikhilesh Reddy
>=20
> Qualcomm Innovation Center, Inc.
> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
> a Linux Foundation Collaborative Project.

--y0ulUmNC+osPPQO6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJWsGR6AAoJED4KNFJOeCOopEIP/Ao4ywNN53Fy3sY+KMSv5Kea
OG4iPYqJOH11Kj2factlo/cNYwkEFbSbAaY61GKG5QMwQN3gydqCETfY+SIqgAaN
jd7uZ0PWouFgeNhn4S43KR/2ZXjYS2TFRG4fYgsb+wdZPm4h3JkbDmwQZq+N0S/m
xCRkOFLaGDw5EO3fveRX2MXvygS/3dwUrXSMcJFE4VABGof7Vc6c/3/M0oW5K5bg
qcRkbjZBj5Q1ALXj/XGmkOrGujx8DTjHXhTQzVxXc4BhAcqdEKYCRLzZ6xqSnr2l
QW0U67A+BpldUYCnonsINNse9wZ5U3yBvZJvqzv4/Z8EjXogxIYF+VPqKBJ/fGl7
Lp34eCS7vyjRrembhMZ+lweSfFqiq3dogOfjk2/6QHxxXaLiCVaFhxYSkzXGY4Ex
3s84BsKfVHL/eR6B9CFRg/oJjoUALvHg0TsI0syOq+HCP9bLExe1kuNmo2ix5XS3
7sTUzRKmJDmcQHNLFoX8ggM9e7FlAvsRS8j2jzTXJRnaULu9Vj+fs0ueBOiQ8LTx
DSdJV5ijxcUMoG+PF/RF2DPsnMgSH7cR2ESQa04sK5yPDpGnj6fLozJxhZ8hdO/y
FGOPZqtSM0kw3zLzI+bIOenKLLh9M9TfHe9BYVOVw8JgPVAhG0pG1ngV/TcoQIGt
FMvXuM4Hn6WvqNxrHt0V
=RSy/
-----END PGP SIGNATURE-----

--y0ulUmNC+osPPQO6--
