From: David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>
Subject: Re: Removing __kernel_old_uid_t, git_t, dev_t
Date: Mon, 30 Mar 2009 14:11:56 -0700 (PDT)
Message-ID: <20090330.141156.62568451.davem@davemloft.net>
References: <200903301558.10598.arnd@arndb.de>
	<10f740e80903300741h387e6342veba0ccceea6714e9@mail.gmail.com>
	<200903301717.57184.arnd@arndb.de>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <200903301717.57184.arnd-r2nGTMty4D4@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: arnd-r2nGTMty4D4@public.gmane.org
Cc: geert.uytterhoeven-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, michal.simek-g5w7nrANp4BDPfheJLI6IQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

From: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Date: Mon, 30 Mar 2009 17:17:56 +0200

> dma_addr_t is a big mess that was traditionally defined per
> architecture, in lots of wrong ways, including the misconception
> of dma64_addr_t. Sparc64 still uses a 32 bit dma_addr_t, possibly
> because it always uses an IOMMU (?). It can save some space in
> scatterlists, but might come back to bite us if someone tries
> to build a sparc64 system with actual 64-bit DMA.

There is no reason to use anything larger than a 32-bit DMA address
type on sparc64, and using 32-bit saves lots of space in many
data structures so I am unlikely to ever change this. :-)
--
To unsubscribe from this list: send the line "unsubscribe linux-api" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
