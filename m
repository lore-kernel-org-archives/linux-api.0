From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH v7 1/5] vfs: Prepare for adding a new preadv/pwritev with user flags.
Date: Mon, 16 Mar 2015 15:05:58 -0600
Message-ID: <C1C6BDE4-9FDC-4E07-B2CE-714E16B39B99@dilger.ca>
References: <cover.1426528417.git.milosz@adfin.com> <cover.1426528417.git.milosz@adfin.com> <cbe6f9910ed4603916c1082c47944c96330d4a15.1426528417.git.milosz@adfin.com>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2070.6\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Return-path: <owner-linux-aio@kvack.org>
In-Reply-To: <cbe6f9910ed4603916c1082c47944c96330d4a15.1426528417.git.milosz@adfin.com>
Sender: owner-linux-aio@kvack.org
To: Milosz Tanski <milosz@adfin.com>
Cc: linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org, linux-aio@kvack.org, Mel Gorman <mgorman@suse.de>, Volker Lendecke <Volker.Lendecke@sernet.de>, Tejun Heo <tj@kernel.org>, Jeff Moyer <jmoyer@redhat.com>, Theodore Ts'o <tytso@mit.edu>, Al Viro <viro@zeniv.linux.org.uk>, linux-api@vger.kernel.org, Michael Kerrisk <mtk.manpages@gmail.com>, linux-arch@vger.kernel.org, Dave Chinner <david@fromorbit.com>, Andrew Morton <akpm@linux-foundation.org>
List-Id: linux-api@vger.kernel.org

On Mar 16, 2015, at 12:27 PM, Milosz Tanski <milosz@adfin.com> wrote:
>=20
> Plumbing the flags argument through the vfs code so they can be passed
> down to __generic_file_(read/write)_iter function that do the acctual =
work.
>=20
> Signed-off-by: Milosz Tanski <milosz@adfin.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Jeff Moyer <jmoyer@redhat.com>
>=20
> diff --git a/fs/read_write.c b/fs/read_write.c
> index 8e1b687..b53bb59 100644
> --- a/fs/read_write.c
> +++ b/fs/read_write.c
> @@ -711,7 +711,8 @@ unsigned long iov_shorten(struct iovec *iov, =
unsigned long nr_segs, size_t to)
> EXPORT_SYMBOL(iov_shorten);
>=20
> static ssize_t do_iter_readv_writev(struct file *filp, int rw, const =
struct iovec *iov,
> -		unsigned long nr_segs, size_t len, loff_t *ppos, =
iter_fn_t fn)
> +		unsigned long nr_segs, size_t len, loff_t *ppos, =
iter_fn_t fn,
> +		int flags)

Using "int flags" as an argument is too generic IMHO.  We have sooo many
different "int flags" arguments, but there is no easy way to figure out
which flags are being used.  A better solution is to declare a named =
enum:

enum iov_iter {
	RWF_NONBLOCK =3D 0x00000001,	/* only access pages in cache */
};

and use "enum iov_iter flags" as the function argument (or even =
"iter_flags"
if you wanted to make it that much easier to understand).  That makes
it immediately clear to the reader and the compiler what the valid flag
values are here, and it works with tags, etc.

Thoughts?

Cheers, Andreas


> {
> 	struct kiocb kiocb;
> 	struct iov_iter iter;
> @@ -720,6 +721,7 @@ static ssize_t do_iter_readv_writev(struct file =
*filp, int rw, const struct iove
> 	init_sync_kiocb(&kiocb, filp);
> 	kiocb.ki_pos =3D *ppos;
> 	kiocb.ki_nbytes =3D len;
> +	kiocb.ki_rwflags =3D flags;
>=20
> 	iov_iter_init(&iter, rw, iov, nr_segs, len);
> 	ret =3D fn(&kiocb, &iter);
> @@ -858,7 +860,8 @@ out:
>=20
> static ssize_t do_readv_writev(int type, struct file *file,
> 			       const struct iovec __user * uvector,
> -			       unsigned long nr_segs, loff_t *pos)
> +			       unsigned long nr_segs, loff_t *pos,
> +			       int flags)
> {
> 	size_t tot_len;
> 	struct iovec iovstack[UIO_FASTIOV];
> @@ -892,7 +895,7 @@ static ssize_t do_readv_writev(int type, struct =
file *file,
>=20
> 	if (iter_fn)
> 		ret =3D do_iter_readv_writev(file, type, iov, nr_segs, =
tot_len,
> -						pos, iter_fn);
> +						pos, iter_fn, flags);
> 	else if (fnv)
> 		ret =3D do_sync_readv_writev(file, iov, nr_segs, =
tot_len,
> 						pos, fnv);
> @@ -915,27 +918,27 @@ out:
> }
>=20
> ssize_t vfs_readv(struct file *file, const struct iovec __user *vec,
> -		  unsigned long vlen, loff_t *pos)
> +		  unsigned long vlen, loff_t *pos, int flags)
> {
> 	if (!(file->f_mode & FMODE_READ))
> 		return -EBADF;
> 	if (!(file->f_mode & FMODE_CAN_READ))
> 		return -EINVAL;
>=20
> -	return do_readv_writev(READ, file, vec, vlen, pos);
> +	return do_readv_writev(READ, file, vec, vlen, pos, flags);
> }
>=20
> EXPORT_SYMBOL(vfs_readv);
>=20
> ssize_t vfs_writev(struct file *file, const struct iovec __user *vec,
> -		   unsigned long vlen, loff_t *pos)
> +		   unsigned long vlen, loff_t *pos, int flags)
> {
> 	if (!(file->f_mode & FMODE_WRITE))
> 		return -EBADF;
> 	if (!(file->f_mode & FMODE_CAN_WRITE))
> 		return -EINVAL;
>=20
> -	return do_readv_writev(WRITE, file, vec, vlen, pos);
> +	return do_readv_writev(WRITE, file, vec, vlen, pos, flags);
> }
>=20
> EXPORT_SYMBOL(vfs_writev);
> @@ -948,7 +951,7 @@ SYSCALL_DEFINE3(readv, unsigned long, fd, const =
struct iovec __user *, vec,
>=20
> 	if (f.file) {
> 		loff_t pos =3D file_pos_read(f.file);
> -		ret =3D vfs_readv(f.file, vec, vlen, &pos);
> +		ret =3D vfs_readv(f.file, vec, vlen, &pos, 0);
> 		if (ret >=3D 0)
> 			file_pos_write(f.file, pos);
> 		fdput_pos(f);
> @@ -968,7 +971,7 @@ SYSCALL_DEFINE3(writev, unsigned long, fd, const =
struct iovec __user *, vec,
>=20
> 	if (f.file) {
> 		loff_t pos =3D file_pos_read(f.file);
> -		ret =3D vfs_writev(f.file, vec, vlen, &pos);
> +		ret =3D vfs_writev(f.file, vec, vlen, &pos, 0);
> 		if (ret >=3D 0)
> 			file_pos_write(f.file, pos);
> 		fdput_pos(f);
> @@ -1000,7 +1003,7 @@ SYSCALL_DEFINE5(preadv, unsigned long, fd, const =
struct iovec __user *, vec,
> 	if (f.file) {
> 		ret =3D -ESPIPE;
> 		if (f.file->f_mode & FMODE_PREAD)
> -			ret =3D vfs_readv(f.file, vec, vlen, &pos);
> +			ret =3D vfs_readv(f.file, vec, vlen, &pos, 0);
> 		fdput(f);
> 	}
>=20
> @@ -1024,7 +1027,7 @@ SYSCALL_DEFINE5(pwritev, unsigned long, fd, =
const struct iovec __user *, vec,
> 	if (f.file) {
> 		ret =3D -ESPIPE;
> 		if (f.file->f_mode & FMODE_PWRITE)
> -			ret =3D vfs_writev(f.file, vec, vlen, &pos);
> +			ret =3D vfs_writev(f.file, vec, vlen, &pos, 0);
> 		fdput(f);
> 	}
>=20
> @@ -1072,7 +1075,7 @@ static ssize_t compat_do_readv_writev(int type, =
struct file *file,
>=20
> 	if (iter_fn)
> 		ret =3D do_iter_readv_writev(file, type, iov, nr_segs, =
tot_len,
> -						pos, iter_fn);
> +						pos, iter_fn, 0);
> 	else if (fnv)
> 		ret =3D do_sync_readv_writev(file, iov, nr_segs, =
tot_len,
> 						pos, fnv);
> diff --git a/fs/splice.c b/fs/splice.c
> index 7968da9..ee3fd4c 100644
> --- a/fs/splice.c
> +++ b/fs/splice.c
> @@ -576,7 +576,7 @@ static ssize_t kernel_readv(struct file *file, =
const struct iovec *vec,
> 	old_fs =3D get_fs();
> 	set_fs(get_ds());
> 	/* The cast to a user pointer is valid due to the set_fs() */
> -	res =3D vfs_readv(file, (const struct iovec __user *)vec, vlen, =
&pos);
> +	res =3D vfs_readv(file, (const struct iovec __user *)vec, vlen, =
&pos, 0);
> 	set_fs(old_fs);
>=20
> 	return res;
> diff --git a/include/linux/aio.h b/include/linux/aio.h
> index d9c92da..9c1d499 100644
> --- a/include/linux/aio.h
> +++ b/include/linux/aio.h
> @@ -52,6 +52,8 @@ struct kiocb {
> 	 * this is the underlying eventfd context to deliver events to.
> 	 */
> 	struct eventfd_ctx	*ki_eventfd;
> +
> +	int			ki_rwflags;
> };
>=20
> static inline bool is_sync_kiocb(struct kiocb *kiocb)
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index b4d71b5..c018335 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -1619,9 +1619,9 @@ extern ssize_t __vfs_read(struct file *, char =
__user *, size_t, loff_t *);
> extern ssize_t vfs_read(struct file *, char __user *, size_t, loff_t =
*);
> extern ssize_t vfs_write(struct file *, const char __user *, size_t, =
loff_t *);
> extern ssize_t vfs_readv(struct file *, const struct iovec __user *,
> -		unsigned long, loff_t *);
> +		unsigned long, loff_t *, int);
> extern ssize_t vfs_writev(struct file *, const struct iovec __user *,
> -		unsigned long, loff_t *);
> +		unsigned long, loff_t *, int);
>=20
> struct super_operations {
>    	struct inode *(*alloc_inode)(struct super_block *sb);
> --=20
> 1.9.1
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe =
linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Cheers, Andreas





--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
