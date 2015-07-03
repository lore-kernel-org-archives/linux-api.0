From: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Subject: Re: [RFC 5/8] kmsg: device support in mem class
Date: Fri, 3 Jul 2015 08:39:00 -0700
Message-ID: <20150703153900.GB11227@kroah.com>
References: <1435920595-30879-1-git-send-email-m.niesluchow@samsung.com>
 <1435920595-30879-6-git-send-email-m.niesluchow@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1435920595-30879-6-git-send-email-m.niesluchow-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Marcin Niesluchowski <m.niesluchow-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Cc: linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Petr Mladek <pmladek-AlSwsSmVLrQ@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Kay Sievers <kay-tD+1rO4QERM@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Joe Perches <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>, Karol Lewandowski <k.lewandowsk-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, Bartlomiej Zolnierkiewicz <b.zolnierkie-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Fri, Jul 03, 2015 at 12:49:52PM +0200, Marcin Niesluchowski wrote:
> Mem class is current class in which kmsg device is holded in.
> 
> Mem class is exteded by kmsg_sys devices handling.
> 
> Signed-off-by: Marcin Niesluchowski <m.niesluchow-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
> ---
>  drivers/char/mem.c | 20 ++++++++++++++++++--
>  1 file changed, 18 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/char/mem.c b/drivers/char/mem.c
> index e518040..8d5ba0d 100644
> --- a/drivers/char/mem.c
> +++ b/drivers/char/mem.c
> @@ -815,7 +815,11 @@ static int memory_open(struct inode *inode, struct file *filp)
>  
>  	minor = iminor(inode);
>  	if (minor >= ARRAY_SIZE(devlist))
> +#ifdef CONFIG_PRINTK
> +		minor = KMSG_MINOR;
> +#else
>  		return -ENXIO;
> +#endif

Ick, you are going to have to come up with a better api if you want this
to be able to be merged.  I don't want to see #ifdef in .c files, as
these changes just make things much messier.

> @@ -837,8 +841,20 @@ static const struct file_operations memory_fops = {
>  
>  static char *mem_devnode(struct device *dev, umode_t *mode)
>  {
> -	if (mode && devlist[MINOR(dev->devt)].mode)
> -		*mode = devlist[MINOR(dev->devt)].mode;
> +	int minor;
> +
> +	if (!mode)
> +		return NULL;
> +
> +	minor = MINOR(dev->devt);
> +
> +#ifdef CONFIG_PRINTK
> +	if (minor >= ARRAY_SIZE(devlist))
> +		kmsg_sys_mode(minor, mode);
> +	else
> +#endif

Ick, not ok.

greg k-h
