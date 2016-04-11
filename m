From: Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>
Subject: Re: uapi elf: delete unused macros
Date: Mon, 11 Apr 2016 23:05:06 +1000 (AEST)
Message-ID: <3qk9Jy6NyYz9sC4@ozlabs.org>
References: <563CBD1B.1060407@gmail.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <563CBD1B.1060407-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: =?utf-8?b?5oWV5Yas5Lqu?= <mudongliangabcd-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, benh-XVmvHMARGAS8U2dJNN8I7kB+6BGkLq7r@public.gmane.org, paulus-eUNUBHrolfbYtjvyW6yDsg@public.gmane.orgmudongliangabcd-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, takahiro.akashi-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linuxppc-dev-uLR06cmDAlY/bJ5BZ2RsiQ@public.gmane.org, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Fri, 2015-06-11 at 14:45:47 UTC, =?utf-8?b?5oWV5Yas5Lqu?= wrote:
> >From 13f516acc709d88d3162e92bc891c8e39cc9fc1a Mon Sep 17 00:00:00 2001
> From: mudongliang <mudongliangabcd-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Date: Fri, 6 Nov 2015 14:35:19 +0800
> Subject: [PATCH] unify the comment form and delete unused macros
> 
> diff --git a/include/uapi/linux/elf.h b/include/uapi/linux/elf.h
> index 71e1d0e..ff81b20 100644
> --- a/include/uapi/linux/elf.h
> +++ b/include/uapi/linux/elf.h
> @@ -342,15 +342,13 @@ typedef struct elf64_shdr {
>  #define	ELFCLASSNONE	0		/* EI_CLASS */
>  #define	ELFCLASS32	1
>  #define	ELFCLASS64	2
> -#define	ELFCLASSNUM	3
>  
> -#define ELFDATANONE	0		/* e_ident[EI_DATA] */
> +#define ELFDATANONE	0		/* EI_DATA */
>  #define ELFDATA2LSB	1
>  #define ELFDATA2MSB	2
>  
> -#define EV_NONE		0		/* e_version, EI_VERSION */
> +#define EV_NONE		0		/* EI_VERSION */
>  #define EV_CURRENT	1
> -#define EV_NUM		2

How do you know there isn't a userspace program somewhere that's using this
definition?

cheers
