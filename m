From: Florian Weimer <fw@deneb.enyo.de>
Subject: Re: [PATCH] uapi: avoid namespace conflict in linux/posix_types.h
Date: Tue, 19 Mar 2019 22:55:20 +0100
Message-ID: <87bm26il6f.fsf@mid.deneb.enyo.de>
References: <20190319165123.3967889-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190319165123.3967889-1-arnd@arndb.de> (Arnd Bergmann's message
        of "Tue, 19 Mar 2019 17:51:09 +0100")
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-api@vger.kernel.org, linux-arch@vger.kernel.org, netdev@vger.kernel.org, Laura Abbott <labbott@redhat.com>, Paul Burton <pburton@wavecomp.com>, Deepa Dinamani <deepa.kernel@gmail.com>, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

* Arnd Bergmann:

> diff --git a/include/uapi/asm-generic/posix_types.h b/include/uapi/asm-generic/posix_types.h
> index f0733a26ebfc..2a8c68ac88ca 100644
> --- a/include/uapi/asm-generic/posix_types.h
> +++ b/include/uapi/asm-generic/posix_types.h
> @@ -77,7 +77,11 @@ typedef __kernel_long_t	__kernel_ptrdiff_t;
>  
>  #ifndef __kernel_fsid_t
>  typedef struct {
> +#ifdef __KERNEL__
>  	int	val[2];
> +#else
> +	int	__kernel_val[2];
> +#endif
>  } __kernel_fsid_t;
>  #endif
>  
> diff --git a/include/uapi/linux/posix_types.h b/include/uapi/linux/posix_types.h
> index 9a7a740b35a2..a5a5cfc38bbf 100644
> --- a/include/uapi/linux/posix_types.h
> +++ b/include/uapi/linux/posix_types.h
> @@ -23,7 +23,7 @@
>  #define __FD_SETSIZE	1024
>  
>  typedef struct {
> -	unsigned long fds_bits[__FD_SETSIZE / (8 * sizeof(long))];
> +	unsigned long __kernel_fds_bits[__FD_SETSIZE / (8 * sizeof(long))];
>  } __kernel_fd_set;
>  
>  /* Type of a signal handler.  */

Both changes look reasonably to me, but I have not tested them.
