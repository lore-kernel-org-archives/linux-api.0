From: Jann Horn <jann@thejh.net>
Subject: Re: [PATCH v5] fuse: Add support for passthrough read/write
Date: Mon, 1 Feb 2016 20:45:26 +0100
Message-ID: <20160201194526.GA11837@pc.thejh.net>
References: <56AFAA5B.3000006@codeaurora.org>
 <20160201191555.GA3524@pc.thejh.net>
 <56AFB1F3.8090902@codeaurora.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="NzB8fVQJ5HfG6fxh"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <56AFB1F3.8090902@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Nikhilesh Reddy <reddyn@codeaurora.org>
Cc: torvalds@linux-foundation.org, Miklos Szeredi <miklos@szeredi.hu>, fuse-devel <fuse-devel@lists.sourceforge.net>, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, gregkh@linuxfoundation.org, linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk, Richard Weinberger <richard@nod.at>, Theodore Ts'o <tytso@mit.edu>, jack@suse.cz, Antonio SJ Musumeci <trapexit@spawn.link>, sven.utcke@gmx.de, Nikolaus Rath <nikolaus@rath.org>, Jann Horn <jannhorn@googlemail.com>, Mike Shal <marfey@gmail.com>
List-Id: linux-api@vger.kernel.org


--NzB8fVQJ5HfG6fxh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 01, 2016 at 11:28:51AM -0800, Nikhilesh Reddy wrote:
> On Mon 01 Feb 2016 11:15:56 AM PST, Jann Horn wrote:
> >On Mon, Feb 01, 2016 at 10:56:27AM -0800, Nikhilesh Reddy wrote:
> >>diff --git a/fs/fuse/passthrough.c b/fs/fuse/passthrough.c
> >[...]
> >>+static ssize_t fuse_passthrough_read_write_iter(struct kiocb *iocb,
> >>+					    struct iov_iter *iter, int do_write)
> >>+{
> >>+	ssize_t ret_val;
> >>+	struct fuse_file *ff;
> >>+	struct file *fuse_file, *passthrough_filp;
> >>+	struct inode *fuse_inode, *passthrough_inode;
> >>+
> >>+	ff =3D iocb->ki_filp->private_data;
> >>+	fuse_file =3D iocb->ki_filp;
> >>+	passthrough_filp =3D ff->passthrough_filp;
> >>+
> >>+	/* lock passthrough file to prevent it from being released */
> >>+	get_file(passthrough_filp);
> >>+	iocb->ki_filp =3D passthrough_filp;
> >>+	fuse_inode =3D fuse_file->f_path.dentry->d_inode;
> >>+	passthrough_inode =3D file_inode(passthrough_filp);
> >>+
> >>+	if (do_write) {
> >>+		if (!passthrough_filp->f_op->write_iter)
> >>+			return -EIO;
> >>+		ret_val =3D passthrough_filp->f_op->write_iter(iocb, iter);
> >>+
> >>+		if (ret_val >=3D 0 || ret_val =3D=3D -EIOCBQUEUED) {
> >>+			fsstack_copy_inode_size(fuse_inode, passthrough_inode);
> >>+			fsstack_copy_attr_times(fuse_inode, passthrough_inode);
> >>+		}
> >>+	} else {
> >>+		if (!passthrough_filp->f_op->read_iter)
> >>+			return -EIO;
> >>+		ret_val =3D passthrough_filp->f_op->read_iter(iocb, iter);
> >>+		if (ret_val >=3D 0 || ret_val =3D=3D -EIOCBQUEUED)
> >>+			fsstack_copy_attr_atime(fuse_inode, passthrough_inode);
> >>+	}
> >>+
> >>+	iocb->ki_filp =3D fuse_file;
> >>+
> >>+	/* unlock passthrough file */
> >>+	fput(passthrough_filp);
> >
> >Why the get_file() and fput() in this method? This doesn't look right. T=
here
> >is no lock you're releasing between get_file() and fput(). What are they
> >intended for?
>=20
> Hi
>=20
> Thanks for reviewing the code.
>=20
> The passthrough file could be released under our feet say  if the userspa=
ce
> fuse daemon crashed or was killed  ( while we are processing the read or =
the
> write) causing bad things to happen.
> The calls here are to increase the count temporarily  and then decrease it
> so that we dont release in the middle of a write and everything is
> gracefully handled...
>=20
> I have a comment right before the get_file call above saying the same thi=
ng.
> Please let me know if you have any more questions.

If that is the case, why can't the passthrough file be released before the
get_file() call, e.g. while the core processing the filesystem read request
is entering fuse_passthrough_read_write_iter()?

As far as I can tell, you can drop the get_file() and fput() calls.
fuse_setup_passthrough() already took a reference to the file for you, that
reference can only be dropped in fuse_passthrough_release(), and the VFS
ensures that no release call happens while a read or write is pending.

--NzB8fVQJ5HfG6fxh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJWr7XWAAoJED4KNFJOeCOo2IcQAK/ef9j1QLV+cRFbl3EvOcvs
fZHhNUFX056OBpXg0RgaDactGdVVqmxPyjbuBtN71s+2aACgSxo7vLcdpWUZYfBg
DoSYTgvI51x6CTje9zcYHV4+vVsZfpv4Ky7UG3WVxKBfP3KpgK17I/W1Y/7e+K98
XKYClOcx/kf27Fe22VHPqctmP5lddmES+nElaOyB8VaxSeXSjRTLQ53AtjkCW/Hx
awn5/OKqwS7N/NEzd9m54ilebI6UtAgeLWoGA8rIBeE5l9nyADZO9dg5gwjTX6x5
NQqwQoEQNlSaP+k6mvAqt647VNgYoy5ZzT4xwxBr36QSGjxg0VvhlkGhPqmZ96K/
XmmoO1Bn9a5mvEgJP/THO5vDObG4SQpTnrlTgbxWO/nebu+HstNCZHMBTZESN8d2
RLe4qPprSgfXM0NIOUNlcFbjxcx4gHa+YQOBIOCm+IlejRriN1jDicQ04BycN+lN
anJEwkXKsuQ77uildIaK6qXPOXprl8tdauW0QlN3CpXXligk/GBPUN+tA9Ywpwtj
Fp2WV9mtfiqGkSSKLiogo2XC/cJRAOt2rIYmXvfIYyfRqGo+DTraUReTKRVNPfKV
ZCJCDiTYpmzMEb7wTYRm8N/RDeXGqHiMTBJaXe8H7pShKq4A4iodxoC6hsN6FwZg
g3OJpdk1njbmxytRyT+p
=rgmI
-----END PGP SIGNATURE-----

--NzB8fVQJ5HfG6fxh--
