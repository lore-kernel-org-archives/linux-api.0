From: Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>
Subject: Re: F_SETOWN_EX and F_GETLK64 conflict
Date: Fri, 13 Nov 2009 10:32:57 +1100
Message-ID: <20091113103257.1f4f6e12.sfr@canb.auug.org.au>
References: <Pine.LNX.4.64.0910041229300.20203@digraph.polyomino.org.uk>
	<1254691822.21044.9.camel@laptop>
	<20091030161320.17d07dc9.sfr@canb.auug.org.au>
	<20091030162906.fbc1c40b.sfr@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20091030162906.fbc1c40b.sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Linus <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Peter Zijlstra <a.p.zijlstra-/NLkJaSkS4VmR6Xm/wNWPw@public.gmane.org>, "Joseph S. Myers" <joseph-qD8j1LwMmJjtCj0u4l0SBw@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Oleg Nesterov <onestero-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Stephane Eranian <eranian-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org>, Michael Kerrisk <mtk.manpages-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org>, Roland McGrath <roland-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Al Viro <viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Ingo Molnar <mingo-X9Un+BFzKDI@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hi Andrew,

On Fri, 30 Oct 2009 16:29:06 +1100 Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org> wrote:
>
> On Fri, 30 Oct 2009 16:13:20 +1100 Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org> wrote:
> >
> > This is why we have F_LINUX_SPECIFIC_BASE and use it in
> > include/linux/fcntl.h ... it should be used as a base for any new fcntl
> > types since they don't require backward compatibility.
> 
> Something like this (not even built, but pretty obvious):

So I provide an alternative patch (which IMHO is a better one), I get no
comments, and 2 weeks later the original is now in Linus' tree ...

The new fcntl numbers that are being fixed here were only introduced
after v2.6.31, so there is no ABI breakage by changing them.

> From: Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>
> Date: Fri, 30 Oct 2009 16:25:51 +1100
> Subject: [PATCH] fcntl: use consistent valuse for F_SETOWN_EX/F_GETOWN_EX
> 
> This is what F_LINUX_SPECIFIC_BASE was meant for.
> 
> Signed-off-by: Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>
> ---
>  arch/alpha/include/asm/fcntl.h  |    2 --
>  arch/parisc/include/asm/fcntl.h |    2 --
>  include/asm-generic/fcntl.h     |   14 --------------
>  include/linux/fcntl.h           |   12 ++++++++++++
>  4 files changed, 12 insertions(+), 18 deletions(-)
> 
> diff --git a/arch/alpha/include/asm/fcntl.h b/arch/alpha/include/asm/fcntl.h
> index e42823e..25da001 100644
> --- a/arch/alpha/include/asm/fcntl.h
> +++ b/arch/alpha/include/asm/fcntl.h
> @@ -26,8 +26,6 @@
>  #define F_GETOWN	6	/*  for sockets. */
>  #define F_SETSIG	10	/*  for sockets. */
>  #define F_GETSIG	11	/*  for sockets. */
> -#define F_SETOWN_EX	12
> -#define F_GETOWN_EX	13
>  
>  /* for posix fcntl() and lockf() */
>  #define F_RDLCK		1
> diff --git a/arch/parisc/include/asm/fcntl.h b/arch/parisc/include/asm/fcntl.h
> index 5f39d55..1e1c824 100644
> --- a/arch/parisc/include/asm/fcntl.h
> +++ b/arch/parisc/include/asm/fcntl.h
> @@ -28,8 +28,6 @@
>  #define F_SETOWN	12	/*  for sockets. */
>  #define F_SETSIG	13	/*  for sockets. */
>  #define F_GETSIG	14	/*  for sockets. */
> -#define F_GETOWN_EX	15
> -#define F_SETOWN_EX	16
>  
>  /* for posix fcntl() and lockf() */
>  #define F_RDLCK		01
> diff --git a/include/asm-generic/fcntl.h b/include/asm-generic/fcntl.h
> index 0c3dd86..980d6b5 100644
> --- a/include/asm-generic/fcntl.h
> +++ b/include/asm-generic/fcntl.h
> @@ -73,20 +73,6 @@
>  #define F_SETSIG	10	/* for sockets. */
>  #define F_GETSIG	11	/* for sockets. */
>  #endif
> -#ifndef F_SETOWN_EX
> -#define F_SETOWN_EX	12
> -#define F_GETOWN_EX	13
> -#endif
> -
> -#define F_OWNER_TID	0
> -#define F_OWNER_PID	1
> -#define F_OWNER_GID	2
> -
> -struct f_owner_ex {
> -	int	type;
> -	pid_t	pid;
> -};
> -
>  /* for F_[GET|SET]FL */
>  #define FD_CLOEXEC	1	/* actually anything with low bit set goes */
>  
> diff --git a/include/linux/fcntl.h b/include/linux/fcntl.h
> index 8603740..b34c41d 100644
> --- a/include/linux/fcntl.h
> +++ b/include/linux/fcntl.h
> @@ -40,6 +40,18 @@
>                                             unlinking file.  */
>  #define AT_SYMLINK_FOLLOW	0x400   /* Follow symbolic links.  */
>  
> +#define F_SETOWN_EX	(F_LINUX_SPECIFIC_BASE + 7)
> +#define F_GETOWN_EX	(F_LINUX_SPECIFIC_BASE + 8)
> +
> +#define F_OWNER_TID	0
> +#define F_OWNER_PID	1
> +#define F_OWNER_GID	2
> +
> +struct f_owner_ex {
> +	int	type;
> +	pid_t	pid;
> +};
> +
>  #ifdef __KERNEL__
>  
>  #ifndef force_o_largefile

-- 
Cheers,
Stephen Rothwell                    sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org
http://www.canb.auug.org.au/~sfr/
