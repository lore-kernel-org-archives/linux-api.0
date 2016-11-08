From: Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: [PATCH] mm: only enable sys_pkey* when ARCH_HAS_PKEYS
Date: Tue, 8 Nov 2016 13:05:42 +0100
Message-ID: <20161108120542.GG3528@osiris>
References: <1477958904-9903-1-git-send-email-mark.rutland@arm.com>
 <20161104234459.GA18760@remoulade>
 <20161108093042.GC3528@osiris>
 <1596342.1rV5HksyDO@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1596342.1rV5HksyDO@wuerfel>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: Mark Rutland <mark.rutland@arm.com>, Dave Hansen <dave.hansen@linux.intel.com>, linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@techsingularity.net>, Russell King <rmk+kernel@armlinux.org.uk>, Thomas Gleixner <tglx@linutronix.de>, linux-api@vger.kernel.org, linux-arch@vger.kernel.org, linux-mm@kvack.org, torvalds@linux-foundation.org
List-Id: linux-api@vger.kernel.org

On Tue, Nov 08, 2016 at 12:39:28PM +0100, Arnd Bergmann wrote:
> On Tuesday, November 8, 2016 10:30:42 AM CET Heiko Carstens wrote:
> > Three architectures (parisc, powerpc, s390) decided to ignore the system
> > calls completely, but still have the pkey code linked into the kernel
> > image.
> 
> Wouldn't it actually make sense to hook this up to the storage keys
> in the s390 page tables?

We have storage keys per _physical_ page. Not per page within the the table
entries. So this doesn't work unfortunately.
