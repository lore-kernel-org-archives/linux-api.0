From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] new flag COPY_FILE_RANGE_FILESIZE for copy_file_range()
Date: Sat, 13 Apr 2019 18:02:54 -0700
Message-ID: <20190414010254.GA7408@magnolia>
References: <20190413205439.9623-1-shawn@git.icu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190413205439.9623-1-shawn@git.icu>
Sender: linux-kernel-owner@vger.kernel.org
To: Shawn Landden <shawn@git.icu>
Cc: linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Sat, Apr 13, 2019 at 03:54:39PM -0500, Shawn Landden wrote:

/me pulls out his close-reading glasses and the copy_file_range manpage...

> If flags includes COPY_FILE_RANGE_FILESIZE then the length
> copied is the length of the file. off_in and off_out are
> ignored.  len must be 0 or the file size.

They're ignored?  As in the copy operation reads the number of bytes in
the file referenced by fd_in from fd_in at its current position and is
writes that out to fd_out at its current position?  I don't see why I
would want such an operation...

...but I can see how people could make use of a CFR_ENTIRE_FILE that
would check that both file descriptors are actually regular files, and
if so copy the entire contents of the fd_in file into the same position
in the fd_out file, and then set the fd_out file's length to match.  If
@off_in or @off_out are non-NULL then they'll be updated to the new EOFs
if the copy completes succesfully and @len can be anything.

Also: please update the manual page and the xfstests regression test for
this syscall.

> This implementation saves a call to stat() in the common case
> of copying files. It does not fix any race conditions, but that
> is possible in the future with this interface.
> 
> EAGAIN: If COPY_FILE_RANGE_FILESIZE was passed and len is not 0
> or the file size.

The values are invalid, so why would we tell userspace to try again
instead of the EINVAL that we usually use?

> Signed-off-by: Shawn Landden <shawn@git.icu>
> CC: <linux-api@vger.kernel.org>
> ---
>  fs/read_write.c           | 14 +++++++++++++-
>  include/uapi/linux/stat.h |  4 ++++
>  2 files changed, 17 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/read_write.c b/fs/read_write.c
> index 61b43ad7608e..6d06361f0856 100644
> --- a/fs/read_write.c
> +++ b/fs/read_write.c
> @@ -1557,7 +1557,7 @@ ssize_t vfs_copy_file_range(struct file *file_in, loff_t pos_in,
>  	struct inode *inode_out = file_inode(file_out);
>  	ssize_t ret;
>  
> -	if (flags != 0)
> +	if ((flags & ~COPY_FILE_RANGE_FILESIZE) != 0)

FWIW you might as well shorten the prefix to "CFR_" since nobody else is
using it.

--D

>  		return -EINVAL;
>  
>  	if (S_ISDIR(inode_in->i_mode) || S_ISDIR(inode_out->i_mode))
> @@ -1565,6 +1565,18 @@ ssize_t vfs_copy_file_range(struct file *file_in, loff_t pos_in,
>  	if (!S_ISREG(inode_in->i_mode) || !S_ISREG(inode_out->i_mode))
>  		return -EINVAL;
>  
> +	if (flags & COPY_FILE_RANGE_FILESIZE) {
> +		struct kstat stat;
> +		int error;
> +		error = vfs_getattr(&file_in->f_path, &stat,
> +				    STATX_SIZE, 0);
> +		if (error < 0)
> +			return error;
> +		if (!(len == 0 || len == stat.size))
> +			return -EAGAIN;
> +		len = stat.size;
> +	}
> +
>  	ret = rw_verify_area(READ, file_in, &pos_in, len);
>  	if (unlikely(ret))
>  		return ret;
> diff --git a/include/uapi/linux/stat.h b/include/uapi/linux/stat.h
> index 7b35e98d3c58..1075aa4666ef 100644
> --- a/include/uapi/linux/stat.h
> +++ b/include/uapi/linux/stat.h
> @@ -170,5 +170,9 @@ struct statx {
>  
>  #define STATX_ATTR_AUTOMOUNT		0x00001000 /* Dir: Automount trigger */
>  
> +/*
> + * Flags for copy_file_range()
> + */
> +#define COPY_FILE_RANGE_FILESIZE	0x00000001 /* Copy the full length of the input file */
>  
>  #endif /* _UAPI_LINUX_STAT_H */
> -- 
> 2.20.1
> 
