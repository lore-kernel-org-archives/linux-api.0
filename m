From: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Subject: Re: [PATCH v4 2/3] Add preadv and pwritev system calls.
Date: Thu, 18 Dec 2008 13:34:33 +0100
Message-ID: <200812181334.33719.arnd@arndb.de>
References: <1229600542-11585-1-git-send-email-kraxel@redhat.com> <1229600542-11585-3-git-send-email-kraxel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1229600542-11585-3-git-send-email-kraxel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Content-Disposition: inline
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Gerd Hoffmann <kraxel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Thursday 18 December 2008, Gerd Hoffmann wrote:
> This prototype has one problem though:  On 32bit archs is the (64bit)
> offset argument unaligned, which the syscall ABI of several archs
> doesn't allow to do.  At least s390 needs a wrapper in glibc to handle
> this.  As we'll need a wrappers in glibc anyway I've decided to push
> problem to glibc entriely and use a syscall prototype which works
> without arch-specific wrappers inside the kernel:  The offset argument
> is explicitly splitted into two 32bit values.

Obviously, the interface looks good to me now.

Please remember to add the function prototypes to
include/linux/syscalls.h.

> +asmlinkage ssize_t
> +compat_sys_preadv(unsigned long fd, const struct compat_iovec __user *vec,
> +                  unsigned long vlen, u32 pos_high, u32 pos_low)
> +{
> +        loff_t pos = ((loff_t)pos_high << 32) | pos_low;

This is whitespace damaged, as are the other four functions in the
same place.

> +	struct file *file;
> +	ssize_t ret = -EBADF;
> +
> +	if (pos < 0)
> +		return -EINVAL;
> +
> +	file = fget(fd);
> +	if (!file)
> +		return -EBADF;

Any reason for using fget() here, but fget_light() in sys_preadv?

> +	if (!(file->f_mode & FMODE_READ))
> +		goto out;
> +
> +	ret = -EINVAL;
> +	if (!file->f_op || (!file->f_op->aio_read && !file->f_op->read))
> +		goto out;

Maybe this logic could get moved into a compat_readv() function,
similar to vfs_readv(). The advantage would be that we can make
the native and compat paths more similar.

	Arnd <><
--
To unsubscribe from this list: send the line "unsubscribe linux-api" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
