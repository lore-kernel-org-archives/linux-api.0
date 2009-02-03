From: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [PATCH 1/4] Use bit operations for file->f_flags
Date: Tue, 3 Feb 2009 13:37:22 -0800
Message-ID: <20090203133722.9e70de76.akpm@linux-foundation.org>
References: <1233598811-6871-1-git-send-email-corbet@lwn.net>
	<1233598811-6871-2-git-send-email-corbet@lwn.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1233598811-6871-2-git-send-email-corbet-T1hC0tSOHrs@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org, oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org, davidel-AhlLAIvw+VEjIGhXcJzhZg@public.gmane.org, davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org, hch-jcswGhMUV9g@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mpm-VDJrAJ4Gl5ZBDgjK7y7TUQ@public.gmane.org, alan-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org, corbet-T1hC0tSOHrs@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Mon,  2 Feb 2009 11:20:08 -0700
Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org> wrote:

> Turn struct file->f_flags into an unsigned long and use bitops to change
> its contents.  This allows the safe manipulation of these flags without the
> need for locks.  BKL use is removed where possible, but manipulations of
> the FASYNC bit still require it (that will be fixed in a later patch).
> 
> ...
>
> diff --git a/arch/alpha/include/asm/fcntl.h b/arch/alpha/include/asm/fcntl.h
> index 25da001..de7172f 100644
> --- a/arch/alpha/include/asm/fcntl.h
> +++ b/arch/alpha/include/asm/fcntl.h
> @@ -9,13 +9,18 @@
>  #define O_NOCTTY	010000	/* not fcntl */
>  
>  #define O_NONBLOCK	 00004
> +#define NR_O_NONBLOCK	 2
>  #define O_APPEND	 00010
> +#define NR_O_APPEND	 3
>  #define O_SYNC		040000
> +#define NR_O_SYNC	14
>  #define O_DIRECTORY	0100000	/* must be a directory */
>  #define O_NOFOLLOW	0200000 /* don't follow links */
>  #define O_LARGEFILE	0400000 /* will be set by the kernel on every open */
>  #define O_DIRECT	02000000 /* direct disk access - should check with OSF/1 */
> +#define NR_O_DIRECT	19
>  #define O_NOATIME	04000000
> +#define NR_O_NOATIME	20
>  #define O_CLOEXEC	010000000 /* set close_on_exec */
>  
>  #define F_GETLK		7
> diff --git a/arch/arm/include/asm/fcntl.h b/arch/arm/include/asm/fcntl.h
> index a80b660..e74b8d1 100644
> --- a/arch/arm/include/asm/fcntl.h
> +++ b/arch/arm/include/asm/fcntl.h
> @@ -4,6 +4,7 @@
>  #define O_DIRECTORY	 040000	/* must be a directory */
>  #define O_NOFOLLOW	0100000	/* don't follow links */
>  #define O_DIRECT	0200000	/* direct disk access hint - currently ignored */
> +#define NR_O_DIRECT	16
>  #define O_LARGEFILE	0400000
>  
>  #include <asm-generic/fcntl.h>

hm, it's not exactly a vision of splendour, is it.

I suppose we could/should do

#define O_NONBLOCK	(1 << NR_O_NONBLOCK)

but that doesn't prevent people from accidentally doing open-coded &/|
in the future.  Perhaps renaming f_flags to f__flags_atomic (stupid
name?) would help.

> +static void tweak_flags_bit(int nr, int on, unsigned long *flags)
> +{
> +	if (on)
> +		set_bit(nr, flags);
> +	else
> +		clear_bit(nr, flags);
> +}

I see this construct fairly frequently.  I think.  Someone(tm) should
check ;) If correct I guess we should have some generic version, put it
in include/linux/bitops.h.

>  
>  static int setfl(int fd, struct file * filp, unsigned long arg)
>  {
> @@ -187,9 +195,17 @@ static int setfl(int fd, struct file * filp, unsigned long arg)
>  			if (error < 0)
>  				goto out;
>  		}
> +		change_bit(NR_FASYNC, &filp->f_flags);
>  	}
>  
> -	filp->f_flags = (arg & SETFL_MASK) | (filp->f_flags & ~SETFL_MASK);
> +	/*
> +	 * Now that we use bitops we have to tweak each bit individually.
> +	 */
> +	tweak_flags_bit(NR_O_APPEND, arg & O_APPEND, &filp->f_flags);
> +	tweak_flags_bit(NR_O_NONBLOCK, arg & O_NONBLOCK, &filp->f_flags);
> +	tweak_flags_bit(NR_O_NDELAY, arg & O_NDELAY, &filp->f_flags);
> +	tweak_flags_bit(NR_O_DIRECT, arg & O_DIRECT, &filp->f_flags);
> +	tweak_flags_bit(NR_O_NOATIME, arg & O_NOATIME, &filp->f_flags);

Could pass the file* to tweak_flags_bit() - that would generate less
code.  Unless the compiler chooses to inline tweak_flags_bit().

>   out:
>  	unlock_kernel();
>  	return error;
> diff --git a/fs/ioctl.c b/fs/ioctl.c
> index 240ec63..fc0db36 100644
> --- a/fs/ioctl.c
> +++ b/fs/ioctl.c
> @@ -392,22 +392,24 @@ static int file_ioctl(struct file *filp, unsigned int cmd,
>  
>  static int ioctl_fionbio(struct file *filp, int __user *argp)
>  {
> -	unsigned int flag;
>  	int on, error;
>  
>  	error = get_user(on, argp);
>  	if (error)
>  		return error;
> -	flag = O_NONBLOCK;
>  #ifdef __sparc__
>  	/* SunOS compatibility item. */
> -	if (O_NONBLOCK != O_NDELAY)
> -		flag |= O_NDELAY;
> +	if (O_NONBLOCK != O_NDELAY) {
> +		if (on)
> +			set_bit(NR_O_NDELAY, &filp->f_flags);
> +		else
> +			clear_bit(NR_O_NDELAY, &filp->f_flags);

hey, I recognise that!

> +	}
>  #endif
>  	if (on)
> -		filp->f_flags |= flag;
> +		set_bit(NR_O_NONBLOCK, &filp->f_flags);
>  	else
> -		filp->f_flags &= ~flag;
> +		clear_bit(NR_O_NONBLOCK, &filp->f_flags);

and that.


as for the whole patchset: gee, that global lock you had is looking
attractive ;)

--
To unsubscribe from this list: send the line "unsubscribe linux-api" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
