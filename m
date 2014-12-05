From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] arch: uapi: asm: mman.h: Let MADV_FREE have same value
 for all architectures
Date: Thu, 4 Dec 2014 16:14:46 -0800
Message-ID: <20141205001446.GC10064@birch.djwong.org>
References: <5480E715.3020900@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-arch-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5480E715.3020900@gmail.com>
Sender: linux-arch-owner@vger.kernel.org
To: Chen Gang <gang.chen.5i5j@gmail.com>
Cc: "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "rth@twiddle.net" <rth@twiddle.net>, "ink@jurassic.park.msu.ru" <ink@jurassic.park.msu.ru>, "mattst88@gmail.com" <mattst88@gmail.com>, Ralf Baechle <ralf@linux-mips.org>, "jejb@parisc-linux.org" <jejb@parisc-linux.org>, "deller@gmx.de" <deller@gmx.de>, "chris@zankel.net" <chris@zankel.net>, "jcmvbkbc@gmail.com" <jcmvbkbc@gmail.com>, Arnd Bergmann <arnd@arndb.de>, minchan@kernel.org, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Fri, Dec 05, 2014 at 06:58:29AM +0800, Chen Gang wrote:
> For uapi, need try to let all macros have same value, and MADV_FREE is
> added into main branch recently, so need redefine MADV_FREE for it.
> 
> At present, '8' can be shared with all architectures, so redefine it to
> '8'.

Hmmm... you might want to talk to the dietlibc people if you do this:

$ grep -rn MADV_FREE /usr/include/
/usr/include/diet/sys/mman.h:101:#define MADV_FREE      0x5             /* (Solaris) contents can be freed */

Though the sole definition only exists on sparc/powerpc/powerpc64, so who
knows...

--D

> 
> Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
> ---
>  arch/alpha/include/uapi/asm/mman.h     | 2 +-
>  arch/mips/include/uapi/asm/mman.h      | 2 +-
>  arch/parisc/include/uapi/asm/mman.h    | 2 +-
>  arch/xtensa/include/uapi/asm/mman.h    | 2 +-
>  include/uapi/asm-generic/mman-common.h | 2 +-
>  5 files changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/alpha/include/uapi/asm/mman.h b/arch/alpha/include/uapi/asm/mman.h
> index 836fbd4..0b8a5de 100644
> --- a/arch/alpha/include/uapi/asm/mman.h
> +++ b/arch/alpha/include/uapi/asm/mman.h
> @@ -44,9 +44,9 @@
>  #define MADV_WILLNEED	3		/* will need these pages */
>  #define	MADV_SPACEAVAIL	5		/* ensure resources are available */
>  #define MADV_DONTNEED	6		/* don't need these pages */
> -#define MADV_FREE	7		/* free pages only if memory pressure */
>  
>  /* common/generic parameters */
> +#define MADV_FREE	8		/* free pages only if memory pressure */
>  #define MADV_REMOVE	9		/* remove these pages & resources */
>  #define MADV_DONTFORK	10		/* don't inherit across fork */
>  #define MADV_DOFORK	11		/* do inherit across fork */
> diff --git a/arch/mips/include/uapi/asm/mman.h b/arch/mips/include/uapi/asm/mman.h
> index 106e741..d247f54 100644
> --- a/arch/mips/include/uapi/asm/mman.h
> +++ b/arch/mips/include/uapi/asm/mman.h
> @@ -67,9 +67,9 @@
>  #define MADV_SEQUENTIAL 2		/* expect sequential page references */
>  #define MADV_WILLNEED	3		/* will need these pages */
>  #define MADV_DONTNEED	4		/* don't need these pages */
> -#define MADV_FREE	5		/* free pages only if memory pressure */
>  
>  /* common parameters: try to keep these consistent across architectures */
> +#define MADV_FREE	8		/* free pages only if memory pressure */
>  #define MADV_REMOVE	9		/* remove these pages & resources */
>  #define MADV_DONTFORK	10		/* don't inherit across fork */
>  #define MADV_DOFORK	11		/* do inherit across fork */
> diff --git a/arch/parisc/include/uapi/asm/mman.h b/arch/parisc/include/uapi/asm/mman.h
> index 6cb8db7..700d83f 100644
> --- a/arch/parisc/include/uapi/asm/mman.h
> +++ b/arch/parisc/include/uapi/asm/mman.h
> @@ -40,9 +40,9 @@
>  #define MADV_SPACEAVAIL 5               /* insure that resources are reserved */
>  #define MADV_VPS_PURGE  6               /* Purge pages from VM page cache */
>  #define MADV_VPS_INHERIT 7              /* Inherit parents page size */
> -#define MADV_FREE	8		/* free pages only if memory pressure */
>  
>  /* common/generic parameters */
> +#define MADV_FREE	8		/* free pages only if memory pressure */
>  #define MADV_REMOVE	9		/* remove these pages & resources */
>  #define MADV_DONTFORK	10		/* don't inherit across fork */
>  #define MADV_DOFORK	11		/* do inherit across fork */
> diff --git a/arch/xtensa/include/uapi/asm/mman.h b/arch/xtensa/include/uapi/asm/mman.h
> index 1b19f25..77eaca4 100644
> --- a/arch/xtensa/include/uapi/asm/mman.h
> +++ b/arch/xtensa/include/uapi/asm/mman.h
> @@ -80,9 +80,9 @@
>  #define MADV_SEQUENTIAL	2		/* expect sequential page references */
>  #define MADV_WILLNEED	3		/* will need these pages */
>  #define MADV_DONTNEED	4		/* don't need these pages */
> -#define MADV_FREE	5		/* free pages only if memory pressure */
>  
>  /* common parameters: try to keep these consistent across architectures */
> +#define MADV_FREE	8		/* free pages only if memory pressure */
>  #define MADV_REMOVE	9		/* remove these pages & resources */
>  #define MADV_DONTFORK	10		/* don't inherit across fork */
>  #define MADV_DOFORK	11		/* do inherit across fork */
> diff --git a/include/uapi/asm-generic/mman-common.h b/include/uapi/asm-generic/mman-common.h
> index 7a94102..8695959 100644
> --- a/include/uapi/asm-generic/mman-common.h
> +++ b/include/uapi/asm-generic/mman-common.h
> @@ -34,9 +34,9 @@
>  #define MADV_SEQUENTIAL	2		/* expect sequential page references */
>  #define MADV_WILLNEED	3		/* will need these pages */
>  #define MADV_DONTNEED	4		/* don't need these pages */
> -#define MADV_FREE	5		/* free pages only if memory pressure */
>  
>  /* common parameters: try to keep these consistent across architectures */
> +#define MADV_FREE	8		/* free pages only if memory pressure */
>  #define MADV_REMOVE	9		/* remove these pages & resources */
>  #define MADV_DONTFORK	10		/* don't inherit across fork */
>  #define MADV_DOFORK	11		/* do inherit across fork */
> -- 
> 1.9.3
> --
> To unsubscribe from this list: send the line "unsubscribe linux-api" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
