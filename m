From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] prctl: implement PR_GET_ENDIAN for all architectures
Date: Tue, 31 Jan 2017 16:26:24 -0800
Message-ID: <20170131162624.5a85ec47c6ee22e5cc03c4eb@linux-foundation.org>
References: <20170128111310.GA13389@ls3530.fritz.box>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-parisc-owner@vger.kernel.org>
In-Reply-To: <20170128111310.GA13389@ls3530.fritz.box>
Sender: linux-parisc-owner@vger.kernel.org
To: Helge Deller <deller@gmx.de>
Cc: linux-kernel@vger.kernel.org, linux-parisc@vger.kernel.org, Michael Kerrisk <mtk.manpages@googlemail.com>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Sat, 28 Jan 2017 12:13:10 +0100 Helge Deller <deller@gmx.de> wrote:

> The prctl(PR_GET_ENDIAN) syscall was added to Kernel 2.6.18, but
> implemented for PowerPC only.
> This trivial patch adds support for this syscall for all other architectures.

Seems reasonable.  I guess.  Why is this needed?

The man page will need updating.  It says "PowerPC only".

> 
> diff --git a/kernel/sys.c b/kernel/sys.c
> index 842914e..5818e5e 100644
> --- a/kernel/sys.c
> +++ b/kernel/sys.c
> @@ -79,9 +79,6 @@
>  #ifndef GET_FPEXC_CTL
>  # define GET_FPEXC_CTL(a, b)	(-EINVAL)
>  #endif
> -#ifndef GET_ENDIAN
> -# define GET_ENDIAN(a, b)	(-EINVAL)
> -#endif
>  #ifndef SET_ENDIAN
>  # define SET_ENDIAN(a, b)	(-EINVAL)
>  #endif
> @@ -2136,7 +2133,13 @@ SYSCALL_DEFINE5(prctl, int, option, unsigned long, arg2, unsigned long, arg3,
>  			return -EFAULT;
>  		break;
>  	case PR_GET_ENDIAN:
> +#ifdef GET_ENDIAN
>  		error = GET_ENDIAN(me, arg2);
> +#elif defined(__BIG_ENDIAN)
> +		error = put_user(PR_ENDIAN_BIG, (unsigned int __user *)arg2);
> +#else
> +		error = put_user(PR_ENDIAN_LITTLE, (unsigned int __user *)arg2);
> +#endif
>  		break;
>  	case PR_SET_ENDIAN:
>  		error = SET_ENDIAN(me, arg2);
