From: Jann Horn <jann-XZ1E9jl8jIdeoWH0uzbU5w@public.gmane.org>
Subject: Re: [PATCH v5] fuse: Add support for passthrough read/write
Date: Mon, 1 Feb 2016 20:15:56 +0100
Message-ID: <20160201191555.GA3524@pc.thejh.net>
References: <56AFAA5B.3000006@codeaurora.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="h31gzZEtNLTqOjlF"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <56AFAA5B.3000006-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Nikhilesh Reddy <reddyn-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Cc: torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, Miklos Szeredi <miklos-sUDqSbJrdHQHWmgEVkV9KA@public.gmane.org>, fuse-devel <fuse-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, jack-AlSwsSmVLrQ@public.gmane.org, Antonio SJ Musumeci <trapexit-wGTF+nt6ur047o9RxwvyTQ@public.gmane.org>, sven.utcke-Mmb7MZpHnFY@public.gmane.org, Nikolaus Rath <nikolaus-BTH8mxji4b0@public.gmane.org>, Jann Horn <jannhorn-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org>, Mike Shal <marfey-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org


--h31gzZEtNLTqOjlF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Feb 01, 2016 at 10:56:27AM -0800, Nikhilesh Reddy wrote:
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
> +	ff = iocb->ki_filp->private_data;
> +	fuse_file = iocb->ki_filp;
> +	passthrough_filp = ff->passthrough_filp;
> +
> +	/* lock passthrough file to prevent it from being released */
> +	get_file(passthrough_filp);
> +	iocb->ki_filp = passthrough_filp;
> +	fuse_inode = fuse_file->f_path.dentry->d_inode;
> +	passthrough_inode = file_inode(passthrough_filp);
> +
> +	if (do_write) {
> +		if (!passthrough_filp->f_op->write_iter)
> +			return -EIO;
> +		ret_val = passthrough_filp->f_op->write_iter(iocb, iter);
> +
> +		if (ret_val >= 0 || ret_val == -EIOCBQUEUED) {
> +			fsstack_copy_inode_size(fuse_inode, passthrough_inode);
> +			fsstack_copy_attr_times(fuse_inode, passthrough_inode);
> +		}
> +	} else {
> +		if (!passthrough_filp->f_op->read_iter)
> +			return -EIO;
> +		ret_val = passthrough_filp->f_op->read_iter(iocb, iter);
> +		if (ret_val >= 0 || ret_val == -EIOCBQUEUED)
> +			fsstack_copy_attr_atime(fuse_inode, passthrough_inode);
> +	}
> +
> +	iocb->ki_filp = fuse_file;
> +
> +	/* unlock passthrough file */
> +	fput(passthrough_filp);

Why the get_file() and fput() in this method? This doesn't look right. There
is no lock you're releasing between get_file() and fput(). What are they
intended for?

--h31gzZEtNLTqOjlF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJWr67rAAoJED4KNFJOeCOouPwP/RzRIIdISeJOFQeM4AmRNum6
xVqZu5avIJtRX4+GFJe/WkErXege5Okue3FipyXM8obEzrVutjjHByKfAtf4QZOO
JMPPu4rejQtVRMAEYMfWrXMNCi0bjVpdVyqA3cDzuzhefETYuJikUhU+VmAB9r+e
L0nvKUqpDMlKi/2/N+Cjctpaq9Kx7qCCo9P33PNngrKCw9gGF9g9zs+eBV8hF6Ax
44az3ifEUYcrxiEOX8mSwa/mkPHz6jsfVq+M8Zdra8KEZR0LnYkqWFdjrWpCiHgs
bKObABAc9E3zeqKAnX+iepdJCkaoKt0LTZ6p4ceFQu2OPVH8K8SGNchEQNJ31Bq8
HkFzm9K0qPvezkbFdORUbg3px0dqgAxIkwzSaZZimRNZGeDIqUzxpQo+S0KahQCf
QKIa1Y0Qooq/fBpga2zG93+eldcEcu2d7RdBN13oh56rnoajDdACW4G0M/bRFnVo
f2rZAxHeSq3KC0Sit7TQPLwQnsU+HGuNqzpE8R1HXbIzxfdLKjfAjm50asFw5N0i
1C2B483B6S6gYa7B7V/+uKdbex8tWkO2lLP5MaaAvtRtOQUCWOu7b3Y649mqKkSy
L6qlC39BtdIwsS6N9ovBgK58ccceODTlwD0YbQteXBsqPt+FqZSZD0Qx8WYY+xyK
MCLwpvY4svvCEYL6Q2sL
=Uqkx
-----END PGP SIGNATURE-----

--h31gzZEtNLTqOjlF--
