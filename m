From: Jeff Moyer <jmoyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 4/7] vfs: add the RWF_HIPRI flag for preadv2/pwritev2
Date: Fri, 26 Feb 2016 16:56:03 -0500
Message-ID: <x49r3fzkufg.fsf@segfault.boston.devel.redhat.com>
References: <1456160876-14560-1-git-send-email-hch@lst.de>
	<1456160876-14560-5-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1456160876-14560-5-git-send-email-hch-jcswGhMUV9g@public.gmane.org> (Christoph
	Hellwig's message of "Mon, 22 Feb 2016 18:07:53 +0100")
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, axboe-b10kYP2dOMg@public.gmane.org, milosz-B5zB6C1i6pkAvxtiuMwx3w@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org> writes:

> This adds a flag that tells the file system that this is a high priority
> request for which it's worth to poll the hardware.  The flag is purely
> advisory and can be ignored if not supported.

I'm not in love with the HIGHPRI name, but I don't have a better one in
mind.  So...

Acked-by: Jeff Moyer <jmoyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

>
> Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
> ---
>  fs/read_write.c         | 6 ++++--
>  include/linux/fs.h      | 1 +
>  include/uapi/linux/fs.h | 3 +++
>  3 files changed, 8 insertions(+), 2 deletions(-)
>
> diff --git a/fs/read_write.c b/fs/read_write.c
> index 38b9afa..3b3fb22 100644
> --- a/fs/read_write.c
> +++ b/fs/read_write.c
> @@ -697,10 +697,12 @@ static ssize_t do_iter_readv_writev(struct file *filp, struct iov_iter *iter,
>  	struct kiocb kiocb;
>  	ssize_t ret;
>  
> -	if (flags)
> +	if (flags & ~RWF_HIPRI)
>  		return -EOPNOTSUPP;
>  
>  	init_sync_kiocb(&kiocb, filp);
> +	if (flags & RWF_HIPRI)
> +		kiocb.ki_flags |= IOCB_HIPRI;
>  	kiocb.ki_pos = *ppos;
>  
>  	ret = fn(&kiocb, iter);
> @@ -715,7 +717,7 @@ static ssize_t do_loop_readv_writev(struct file *filp, struct iov_iter *iter,
>  {
>  	ssize_t ret = 0;
>  
> -	if (flags)
> +	if (flags & ~RWF_HIPRI)
>  		return -EOPNOTSUPP;
>  
>  	while (iov_iter_count(iter)) {
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index 875277a..a1f731c 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -320,6 +320,7 @@ struct writeback_control;
>  #define IOCB_EVENTFD		(1 << 0)
>  #define IOCB_APPEND		(1 << 1)
>  #define IOCB_DIRECT		(1 << 2)
> +#define IOCB_HIPRI		(1 << 3)
>  
>  struct kiocb {
>  	struct file		*ki_filp;
> diff --git a/include/uapi/linux/fs.h b/include/uapi/linux/fs.h
> index 149bec8..d246339 100644
> --- a/include/uapi/linux/fs.h
> +++ b/include/uapi/linux/fs.h
> @@ -304,4 +304,7 @@ struct fsxattr {
>  #define SYNC_FILE_RANGE_WRITE		2
>  #define SYNC_FILE_RANGE_WAIT_AFTER	4
>  
> +/* flags for preadv2/pwritev2: */
> +#define RWF_HIPRI			0x00000001 /* high priority request, poll if possible */
> +
>  #endif /* _UAPI_LINUX_FS_H */
