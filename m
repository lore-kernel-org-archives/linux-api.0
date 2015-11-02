From: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 3/8] arch: uapi: asm: mman.h: Let MADV_FREE have same
 value for all architectures
Date: Sun, 1 Nov 2015 16:08:27 -0800 (PST)
Message-ID: <alpine.LSU.2.11.1511011542030.11427@eggly.anvils>
References: <1446188504-28023-1-git-send-email-minchan@kernel.org> <1446188504-28023-4-git-send-email-minchan@kernel.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1446188504-28023-4-git-send-email-minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, zhangyanfei-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, KOSAKI Motohiro <kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, "Darrick J. Wong" <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jason Evans <je-b10kYP2dOMg@public.gmane.org>, Daniel Micay <danielmicay-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, yalin.wang2010-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Shaohua Li <shli-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Chen Gang <gang.chen.5i5j-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "rth-hL46jP5Bxq7R7s880joybQ@public.gmane.org" <rth-hL46jP5Bxq7R7s880joybQ@public.gmane.org>, "ink-biIs/Y0ymYJMZLIVYojuPNP0rXTJTi09@public.gmane.org" <ink-biIs/Y0ymYJMZLIVYojuPNP0rXTJTi09@public.gmane.org>, "mattst88-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <mattst88-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Ralf Baechle <ralf@l>
List-Id: linux-api@vger.kernel.org

On Fri, 30 Oct 2015, Minchan Kim wrote:
> From: Chen Gang <gang.chen.5i5j-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> 
> For uapi, need try to let all macros have same value, and MADV_FREE is
> added into main branch recently, so need redefine MADV_FREE for it.
> 
> At present, '8' can be shared with all architectures, so redefine it to
> '8'.
> 
> Cc: rth-hL46jP5Bxq7R7s880joybQ@public.gmane.org <rth-hL46jP5Bxq7R7s880joybQ@public.gmane.org>,
> Cc: ink-biIs/Y0ymYJMZLIVYojuPNP0rXTJTi09@public.gmane.org <ink-biIs/Y0ymYJMZLIVYojuPNP0rXTJTi09@public.gmane.org>
> Cc: mattst88-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org <mattst88-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Cc: Ralf Baechle <ralf-6z/3iImG2C8G8FEW9MqTrA@public.gmane.org>
> Cc: jejb-6jwH94ZQLHl74goWV3ctuw@public.gmane.org <jejb-6jwH94ZQLHl74goWV3ctuw@public.gmane.org>
> Cc: deller-Mmb7MZpHnFY@public.gmane.org <deller-Mmb7MZpHnFY@public.gmane.org>
> Cc: chris-YvXeqwSYzG2sTnJN9+BGXg@public.gmane.org <chris-YvXeqwSYzG2sTnJN9+BGXg@public.gmane.org>
> Cc: jcmvbkbc-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org <jcmvbkbc-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Cc: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
> Cc: linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Acked-by: Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Signed-off-by: Chen Gang <gang.chen.5i5j-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Let me add
Acked-by: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
to this one too.

But I have extended your mail's Cc list: Darrick pointed out earlier
that dietlibc has a Solaris #define MADV_FREE 0x5 in its mman.h,
and that was in the kernel's sparc mman.h up until 2.6.25.  I doubt
that presents any obstacle nowadays, but Dave Miller should be Cc'ed.

I was a little suspicious that 8 is available for MADV_FREE: why did
the common/generic parameters start at 9 instead of 8 back in 2.6.16?
I think the answer is that we had MADV_REMOVE coming in from one
direction, and MADV_DONTFORK coming from another direction, and when
Roland looked for where to start the commons for MADV_DONTFORK, it
appeared that 8 was occupied - by MADV_REMOVE; then a little later
MADV_REMOVE was shifted to become the first of the commons, at 9.

Hugh

> ---
>  arch/alpha/include/uapi/asm/mman.h     | 2 +-
>  arch/mips/include/uapi/asm/mman.h      | 2 +-
>  arch/parisc/include/uapi/asm/mman.h    | 2 +-
>  arch/xtensa/include/uapi/asm/mman.h    | 2 +-
>  include/uapi/asm-generic/mman-common.h | 2 +-
>  5 files changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/alpha/include/uapi/asm/mman.h b/arch/alpha/include/uapi/asm/mman.h
> index 836fbd44f65b..0b8a5de7aee3 100644
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
> index 106e741aa7ee..d247f5457944 100644
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
> index 6cb8db76fd4e..700d83fd9352 100644
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
> index 1b19f25bc567..77eaca434071 100644
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
> index 7a94102b7a02..869595947873 100644
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
> 1.9.1
> 
> 
