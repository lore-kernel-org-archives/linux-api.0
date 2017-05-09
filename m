From: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH 6/8] nowait aio: ext4
Date: Tue, 9 May 2017 16:57:54 +0200
Message-ID: <20170509145754.GG21467@quack2.suse.cz>
References: <20170509122219.31756-1-rgoldwyn@suse.de>
 <20170509122219.31756-7-rgoldwyn@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170509122219.31756-7-rgoldwyn-l3A5Bk7waGM@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Goldwyn Rodrigues <rgoldwyn-l3A5Bk7waGM@public.gmane.org>
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jack-IBi9RG/b67k@public.gmane.org, hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org, avi-VrcmuVmyx1hWk0Htik3J/w@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, tom.leiming-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Goldwyn Rodrigues <rgoldwyn-IBi9RG/b67k@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Tue 09-05-17 07:22:17, Goldwyn Rodrigues wrote:
> From: Goldwyn Rodrigues <rgoldwyn-IBi9RG/b67k@public.gmane.org>
> 
> Return EAGAIN if any of the following checks fail for direct I/O:
>   + i_rwsem is lockable
>   + Writing beyond end of file (will trigger allocation)
>   + Blocks are not allocated at the write location
> 
> Signed-off-by: Goldwyn Rodrigues <rgoldwyn-IBi9RG/b67k@public.gmane.org>

The patch looks good. You can add:

Reviewed-by: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>

								Honza

> ---
>  fs/ext4/file.c | 20 ++++++++++++++++----
>  1 file changed, 16 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/ext4/file.c b/fs/ext4/file.c
> index cefa9835f275..2efdc6d4d3e8 100644
> --- a/fs/ext4/file.c
> +++ b/fs/ext4/file.c
> @@ -216,7 +216,13 @@ ext4_file_write_iter(struct kiocb *iocb, struct iov_iter *from)
>  		return ext4_dax_write_iter(iocb, from);
>  #endif
>  
> -	inode_lock(inode);
> +	if (iocb->ki_flags & IOCB_NOWAIT) {
> +		if (!inode_trylock(inode))
> +			return -EAGAIN;
> +	} else {
> +		inode_lock(inode);
> +	}
> +
>  	ret = ext4_write_checks(iocb, from);
>  	if (ret <= 0)
>  		goto out;
> @@ -235,9 +241,15 @@ ext4_file_write_iter(struct kiocb *iocb, struct iov_iter *from)
>  
>  	iocb->private = &overwrite;
>  	/* Check whether we do a DIO overwrite or not */
> -	if (o_direct && ext4_should_dioread_nolock(inode) && !unaligned_aio &&
> -	    ext4_overwrite_io(inode, iocb->ki_pos, iov_iter_count(from)))
> -		overwrite = 1;
> +	if (o_direct && !unaligned_aio) {
> +		if (ext4_overwrite_io(inode, iocb->ki_pos, iov_iter_count(from))) {
> +			if (ext4_should_dioread_nolock(inode))
> +				overwrite = 1;
> +		} else if (iocb->ki_flags & IOCB_NOWAIT) {
> +			ret = -EAGAIN;
> +			goto out;
> +		}
> +	}
>  
>  	ret = __generic_file_write_iter(iocb, from);
>  	inode_unlock(inode);
> -- 
> 2.12.0
> 
-- 
Jan Kara <jack-IBi9RG/b67k@public.gmane.org>
SUSE Labs, CR
