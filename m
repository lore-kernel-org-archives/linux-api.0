From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] mm: only enable sys_pkey* when ARCH_HAS_PKEYS
Date: Tue, 08 Nov 2016 12:39:28 +0100
Message-ID: <1596342.1rV5HksyDO@wuerfel>
References: <1477958904-9903-1-git-send-email-mark.rutland@arm.com> <20161104234459.GA18760@remoulade> <20161108093042.GC3528@osiris>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20161108093042.GC3528@osiris>
Sender: linux-kernel-owner@vger.kernel.org
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Mark Rutland <mark.rutland@arm.com>, Dave Hansen <dave.hansen@linux.intel.com>, linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@techsingularity.net>, Russell King <rmk+kernel@armlinux.org.uk>, Thomas Gleixner <tglx@linutronix.de>, linux-api@vger.kernel.org, linux-arch@vger.kernel.org, linux-mm@kvack.org, torvalds@linux-foundation.org
List-Id: linux-api@vger.kernel.org

On Tuesday, November 8, 2016 10:30:42 AM CET Heiko Carstens wrote:
> Three architectures (parisc, powerpc, s390) decided to ignore the system
> calls completely, but still have the pkey code linked into the kernel
> image.

Wouldn't it actually make sense to hook this up to the storage keys
in the s390 page tables?

	Arnd
