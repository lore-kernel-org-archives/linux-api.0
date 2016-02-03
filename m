From: Jann Horn <jann@thejh.net>
Subject: Re: [PATCH v5] fuse: Add support for passthrough read/write
Date: Wed, 3 Feb 2016 20:56:44 +0100
Message-ID: <20160203195644.GB991@pc.thejh.net>
References: <56AFAA5B.3000006@codeaurora.org>
 <20160201191555.GA3524@pc.thejh.net>
 <56AFB1F3.8090902@codeaurora.org>
 <20160201194526.GA11837@pc.thejh.net>
 <56B24F7C.4060703@codeaurora.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="rS8CxjVDS/+yyDmU"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <56B24F7C.4060703@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Nikhilesh Reddy <reddyn@codeaurora.org>
Cc: torvalds@linux-foundation.org, Miklos Szeredi <miklos@szeredi.hu>, fuse-devel <fuse-devel@lists.sourceforge.net>, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, gregkh@linuxfoundation.org, linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk, Richard Weinberger <richard@nod.at>, Theodore Ts'o <tytso@mit.edu>, jack@suse.cz, Antonio SJ Musumeci <trapexit@spawn.link>, sven.utcke@gmx.de, Nikolaus Rath <nikolaus@rath.org>, Jann Horn <jannhorn@googlemail.com>, Mike Shal <marfey@gmail.com>
List-Id: linux-api@vger.kernel.org


--rS8CxjVDS/+yyDmU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Feb 03, 2016 at 11:05:32AM -0800, Nikhilesh Reddy wrote:
> On 02/01/2016 11:45 AM, Jann Horn wrote:
> >On Mon, Feb 01, 2016 at 11:28:51AM -0800, Nikhilesh Reddy wrote:
> >>On Mon 01 Feb 2016 11:15:56 AM PST, Jann Horn wrote:
> >>>On Mon, Feb 01, 2016 at 10:56:27AM -0800, Nikhilesh Reddy wrote:
> >>>>diff --git a/fs/fuse/passthrough.c b/fs/fuse/passthrough.c
> >>>[...]
> >>>>+static ssize_t fuse_passthrough_read_write_iter(struct kiocb *iocb,
> >>>>+					    struct iov_iter *iter, int do_write)
> >>>>+{
> >>>>+	ssize_t ret_val;
> >>>>+	struct fuse_file *ff;
> >>>>+	struct file *fuse_file, *passthrough_filp;
> >>>>+	struct inode *fuse_inode, *passthrough_inode;
> >>>>+
> >>>>+	ff = iocb->ki_filp->private_data;
> >>>>+	fuse_file = iocb->ki_filp;
> >>>>+	passthrough_filp = ff->passthrough_filp;
> >>>>+
> >>>>+	/* lock passthrough file to prevent it from being released */
> >>>>+	get_file(passthrough_filp);
> >>>>+	iocb->ki_filp = passthrough_filp;
> >>>>+	fuse_inode = fuse_file->f_path.dentry->d_inode;
> >>>>+	passthrough_inode = file_inode(passthrough_filp);
> >>>>+
> >>>>+	if (do_write) {
> >>>>+		if (!passthrough_filp->f_op->write_iter)
> >>>>+			return -EIO;
> >>>>+		ret_val = passthrough_filp->f_op->write_iter(iocb, iter);
> >>>>+
> >>>>+		if (ret_val >= 0 || ret_val == -EIOCBQUEUED) {
> >>>>+			fsstack_copy_inode_size(fuse_inode, passthrough_inode);
> >>>>+			fsstack_copy_attr_times(fuse_inode, passthrough_inode);
> >>>>+		}
> >>>>+	} else {
> >>>>+		if (!passthrough_filp->f_op->read_iter)
> >>>>+			return -EIO;
> >>>>+		ret_val = passthrough_filp->f_op->read_iter(iocb, iter);
> >>>>+		if (ret_val >= 0 || ret_val == -EIOCBQUEUED)
> >>>>+			fsstack_copy_attr_atime(fuse_inode, passthrough_inode);
> >>>>+	}
> >>>>+
> >>>>+	iocb->ki_filp = fuse_file;
> >>>>+
> >>>>+	/* unlock passthrough file */
> >>>>+	fput(passthrough_filp);
> >>>
> >>>Why the get_file() and fput() in this method? This doesn't look right. There
> >>>is no lock you're releasing between get_file() and fput(). What are they
> >>>intended for?
> >>
> >>Hi
> >>
> >>Thanks for reviewing the code.
> >>
> >>The passthrough file could be released under our feet say  if the userspace
> >>fuse daemon crashed or was killed  ( while we are processing the read or the
> >>write) causing bad things to happen.
> >>The calls here are to increase the count temporarily  and then decrease it
> >>so that we dont release in the middle of a write and everything is
> >>gracefully handled...
> >>
> >>I have a comment right before the get_file call above saying the same thing.
> >>Please let me know if you have any more questions.
> >
> >If that is the case, why can't the passthrough file be released before the
> >get_file() call, e.g. while the core processing the filesystem read request
> >is entering fuse_passthrough_read_write_iter()?
> >
> >As far as I can tell, you can drop the get_file() and fput() calls.
> >fuse_setup_passthrough() already took a reference to the file for you, that
> >reference can only be dropped in fuse_passthrough_release(), and the VFS
> >ensures that no release call happens while a read or write is pending.
> >
> I just feel uncomfortable with dropping them. I thought they could be
> released ( i/o ) takes longer than the actual execution... but if i can be
> sure of it then maybe..

These get_file() and fput() calls aren't useful.

And I think they can lead to a reference count leak, which would lead to a
use-after-free vulnerability on 32bit kernels, because you forgot to fput()
in the error cases where you return -EIO.

--rS8CxjVDS/+yyDmU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJWslt8AAoJED4KNFJOeCOofB4QALo+37742Esivfpg6lvCFfws
Zi5Ngr9TKo4p5gzqLvERY+HBP0hmKAhmutF9UUqPy60Q5tXG3sA2DNCdn1DU6eSc
0x2jmaqhXT7SHJ9Yfxrrn1oLDQI5eBJJA4/tZ8ce7wfnIvKBQHXsDYqzTYxY1oq9
EwX+phL/GgRKRdIwNfqca31NxhiKNqXkU9ya+RqtcJf1CPB/JLGx/WOYFnt+KUMN
5ciSIk5r/DlKZ9DRR3/KFyBPXKznJVkJDwfNRDlLJtTA6jIrE0fEH1KxYw4lx/EZ
OmZaB9SDXaf54k5VXrzN0op39dSmxhi5emw//lKkDzZjgJcl8P1QFxXyhfAW61bc
dCHEQUIQElmB5z139jCBc+UcG55VQ9D7C0MggpypbbYhSznG4UbvxpfMsJFsRSXE
ZhkQDx2IKt4hLGXq10nRFyt6UolbUI0mGL4wradLFnsL6Q3UACiU0tgis4rQGLUn
gRd9VgVACHDv9/rpcepcjVbSo0+S/goYgycAkQanEiX52plU566SzBZc7ssSZNsr
vgOYi+fbtVFvFMc1xtX8bskEgBUnK5eCx6sXsvoi2vfiDhZwUADFfvcf0SpdA+Fh
yt3+KK9pe8z8d266BarmzImz9IGNIVFc/d5g2axCTP10BZWZoNo7vD8ULMKiVUXA
ysk8TBdDt55u7OTd6iwu
=6BtD
-----END PGP SIGNATURE-----

--rS8CxjVDS/+yyDmU--
