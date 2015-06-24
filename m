From: Sergey Senozhatsky <sergey.senozhatsky.work-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] st: convert DRIVER_ATTR macros to DRIVER_ATTR_RO
Date: Wed, 24 Jun 2015 15:25:57 +0900
Message-ID: <20150624062557.GA10808@swordfish>
References: <DDB9C85B850785449757F9914A034FCB3F8E9DA4@G4W3219.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <DDB9C85B850785449757F9914A034FCB3F8E9DA4-MCKW7lC+H9ISZAcGdq5asR6epYMZPwEe5NbjCUgZEJk@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Seymour, Shane M" <shane.seymour-VXdhtT5mjnY@public.gmane.org>
Cc: "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org> (gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org)" <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, "linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Kai.Makisara-9Aww8k/80nUxHbG02/KK1g@public.gmane.org" <Kai.Makisara-9Aww8k/80nUxHbG02/KK1g@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On (06/24/15 06:10), Seymour, Shane M wrote:
[..]
>  
>  /* The sysfs driver interface. Read-only at the moment */
> -static ssize_t st_try_direct_io_show(struct device_driver *ddp, char *buf)
> +static ssize_t try_direct_io_show(struct device_driver *ddp, char *buf)
>  {
> -	return snprintf(buf, PAGE_SIZE, "%d\n", try_direct_io);
> +	return sprintf(buf, "%d\n", try_direct_io);
>  }

a nitpick,

per Documentation/filesystems/sysfs.txt

:
: - show() should always use scnprintf().
:

  -ss

> -static DRIVER_ATTR(try_direct_io, S_IRUGO, st_try_direct_io_show, NULL);
> +static DRIVER_ATTR_RO(try_direct_io);
>  
> -static ssize_t st_fixed_buffer_size_show(struct device_driver *ddp, char *buf)
> +static ssize_t fixed_buffer_size_show(struct device_driver *ddp, char *buf)
>  {
> -	return snprintf(buf, PAGE_SIZE, "%d\n", st_fixed_buffer_size);
> +	return sprintf(buf, "%d\n", st_fixed_buffer_size);
>  }
> -static DRIVER_ATTR(fixed_buffer_size, S_IRUGO, st_fixed_buffer_size_show, NULL);
> +static DRIVER_ATTR_RO(fixed_buffer_size);
>  
> -static ssize_t st_max_sg_segs_show(struct device_driver *ddp, char *buf)
> +static ssize_t max_sg_segs_show(struct device_driver *ddp, char *buf)
>  {
> -	return snprintf(buf, PAGE_SIZE, "%d\n", st_max_sg_segs);
> +	return sprintf(buf, "%d\n", st_max_sg_segs);
>  }
> -static DRIVER_ATTR(max_sg_segs, S_IRUGO, st_max_sg_segs_show, NULL);
> +static DRIVER_ATTR_RO(max_sg_segs);
>  
> -static ssize_t st_version_show(struct device_driver *ddd, char *buf)
> +static ssize_t version_show(struct device_driver *ddd, char *buf)
>  {
> -	return snprintf(buf, PAGE_SIZE, "[%s]\n", verstr);
> +	return sprintf(buf, "[%s]\n", verstr);
>  }
> -static DRIVER_ATTR(version, S_IRUGO, st_version_show, NULL);
> +static DRIVER_ATTR_RO(version);
>  
>  static struct attribute *st_drv_attrs[] = {
>  	&driver_attr_try_direct_io.attr,
> --
