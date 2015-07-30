From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH v8 4/6] block: loop: prepare for supporing direct IO
Date: Thu, 30 Jul 2015 08:09:00 -0700
Message-ID: <20150730150900.GA13082@infradead.org>
References: <1438256184-23645-1-git-send-email-ming.lei@canonical.com>
 <1438256184-23645-5-git-send-email-ming.lei@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1438256184-23645-5-git-send-email-ming.lei-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ming Lei <ming.lei-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dave Kleikamp <dave.kleikamp-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Zach Brown <zab-ugsP4Wv/S6ZeoWH0uzbU5w@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Maxim Patlasov <mpatlasov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Thu, Jul 30, 2015 at 07:36:22AM -0400, Ming Lei wrote:
> This patches provides one interface for enabling direct IO
> from user space:
> 
> 	- userspace(such as losetup) can pass 'file' which is
> 	opened/fcntl as O_DIRECT
> 
> Also __loop_update_dio() is introduced to check if direct I/O
> can be used on current loop setting.
> 
> The last big change is to introduce LO_FLAGS_DIRECT_IO flag
> for userspace to know if direct IO is used to access backing
> file.

Maybe i'm missing something because I was too busy to follow the
current discussion, but this still doesn't check that the loop
device sector size is aligned to the sector size of the underlying
filesystem.

E.g. with this you could create a loop device with a 512 byte
sector size on a filesystem with 4k sector size, and it would attempt
to use direct I/O and fail.

> +	unsigned dio_align = inode->i_sb->s_bdev ?
> +		(bdev_io_min(inode->i_sb->s_bdev) - 1) : 0;
> +
> +	/*
> +	 * We support direct I/O only if lo_offset is aligned
> +	 * with the min I/O size of backing device.
> +	 *
> +	 * Request's offset and size will be checked in I/O path.
> +	 */
> +	if (dio) {
> +		if (!dio_align || (lo->lo_offset & dio_align))
> +			use_dio = false;

Also this means you'll never use direct I/O on network filesystems,
which really would benefit from it.
