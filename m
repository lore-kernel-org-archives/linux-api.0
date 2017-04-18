From: David Sterba <dsterba-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH 8/8] nowait aio: btrfs
Date: Tue, 18 Apr 2017 13:39:02 +0200
Message-ID: <20170418113902.GS4781@twin.jikos.cz>
References: <20170414120257.8932-1-rgoldwyn@suse.de>
 <20170414120257.8932-9-rgoldwyn@suse.de>
Reply-To: dsterba-AlSwsSmVLrQ@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170414120257.8932-9-rgoldwyn-l3A5Bk7waGM@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Goldwyn Rodrigues <rgoldwyn-l3A5Bk7waGM@public.gmane.org>
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jack-IBi9RG/b67k@public.gmane.org, hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org, avi-VrcmuVmyx1hWk0Htik3J/w@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, tom.leiming-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Goldwyn Rodrigues <rgoldwyn-IBi9RG/b67k@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Fri, Apr 14, 2017 at 07:02:57AM -0500, Goldwyn Rodrigues wrote:
> From: Goldwyn Rodrigues <rgoldwyn-IBi9RG/b67k@public.gmane.org>
> 
> Return EAGAIN if any of the following checks fail
>  + i_rwsem is not lockable
>  + NODATACOW or PREALLOC is not set
>  + Cannot nocow at the desired location
>  + Writing beyond end of file which is not allocated
> 
> Signed-off-by: Goldwyn Rodrigues <rgoldwyn-IBi9RG/b67k@public.gmane.org>

Acked-by: David Sterba <dsterba-IBi9RG/b67k@public.gmane.org>

> +	if ((iocb->ki_flags & IOCB_NOWAIT) &&
> +			(iocb->ki_flags & IOCB_DIRECT)) {
> +		/* Don't sleep on inode rwsem */
> +		if (!inode_trylock(inode))
> +			return -EAGAIN;
> +		/*
> +		 * We will allocate space in case nodatacow is not set,
> +		 * so bail
> +		 */
> +		if (!(BTRFS_I(inode)->flags & (BTRFS_INODE_NODATACOW |
> +					      BTRFS_INODE_PREALLOC)) ||
> +		    check_can_nocow(BTRFS_I(inode), pos, &count) <= 0) {
> +			inode_unlock(inode);
> +			return -EAGAIN;
> +		}
> +	} else

	} else {

> +		inode_lock(inode);

	}
