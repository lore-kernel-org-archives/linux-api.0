From: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Subject: Re: Removing __kernel_old_uid_t, git_t, dev_t
Date: Tue, 31 Mar 2009 02:26:26 +0200
Message-ID: <200903310226.27480.arnd@arndb.de>
References: <200903301558.10598.arnd@arndb.de> <200903301717.57184.arnd@arndb.de> <20090330.141156.62568451.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20090330.141156.62568451.davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>
Content-Disposition: inline
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>
Cc: geert.uytterhoeven-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, michal.simek-g5w7nrANp4BDPfheJLI6IQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Monday 30 March 2009, David Miller wrote:
> There is no reason to use anything larger than a 32-bit DMA address
> type on sparc64, and using 32-bit saves lots of space in many
> data structures so I am unlikely to ever change this. :-)

Ok, fair enough. So I'll change my asm-generic/types.h to use

#ifndef dma_addr_t
#ifdef CONFIG_PHYS_ADDR_T_64BIT
typedef u64 dma_addr_t;
#else
typedef u32 dma_addr_t;
#endif /* CONFIG_PHYS_ADDR_T_64BIT */
#endif /* dma_addr_t */

If you eventually want to use the the generic version, you
just need to add

#define dma_addr_t dma_addr_t

before the #include. Or you just ignore the asm-generic version
and don't have to do anything.

	Arnd <><
--
To unsubscribe from this list: send the line "unsubscribe linux-api" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
