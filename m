From: Jeff Moyer <jmoyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 2/7] vfs: vfs: Define new syscalls preadv2,pwritev2
Date: Fri, 26 Feb 2016 16:51:24 -0500
Message-ID: <x4937sfm97n.fsf@segfault.boston.devel.redhat.com>
References: <1456160876-14560-1-git-send-email-hch@lst.de>
	<1456160876-14560-3-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1456160876-14560-3-git-send-email-hch-jcswGhMUV9g@public.gmane.org> (Christoph
	Hellwig's message of "Mon, 22 Feb 2016 18:07:51 +0100")
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, axboe-b10kYP2dOMg@public.gmane.org, milosz-B5zB6C1i6pkAvxtiuMwx3w@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org> writes:

> From: Milosz Tanski <milosz-B5zB6C1i6pkAvxtiuMwx3w@public.gmane.org>
>
> New syscalls that take an flag argument. This change does not add any
> specific flags.

So, it looks like file systems that don't implement read_iter/write_iter
won't get the flags argument passed along.  I don't think that's a big
deal, as such file systems seem to be in-memory file systems, but I
think it warrants mention in the changelog.

Also, I think you added a stray newline below:

> +static long do_compat_pwritev64(unsigned long fd,
>  				   const struct compat_iovec __user *vec,
> -				   unsigned long vlen, loff_t pos)
> +				   unsigned long vlen, loff_t pos, int flags)
>  {
>  	struct fd f;
>  	ssize_t ret;
>  
>  	if (pos < 0)
>  		return -EINVAL;
> +
>  	f = fdget(fd);
>  	if (!f.file)
>  		return -EBADF;
>  	ret = -ESPIPE;
>  	if (f.file->f_mode & FMODE_PWRITE)
> -		ret = compat_writev(f.file, vec, vlen, &pos);
> +		ret = compat_writev(f.file, vec, vlen, &pos, flags);
>  	fdput(f);
>  	return ret;
>  }

Cheers,
Jeff
