From: Boris Brezillon <boris.brezillon@free-electrons.com>
Subject: Re: [PATCH] mtd: Expand the ecc placement locations to 1216
Date: Tue, 1 Dec 2015 12:15:12 +0100
Message-ID: <20151201121512.40ce9cce@bbrezillon>
References: <1446742735-20824-1-git-send-email-punnaia@xilinx.com>
	<20151120193342.GX64635@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20151120193342.GX64635@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Brian Norris <computersforpeace@gmail.com>
Cc: Punnaiah Choudary Kalluri <punnaiah.choudary.kalluri@xilinx.com>, dwmw2@infradead.org, michals@xilinx.com, linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, kpc528@gmail.com, kalluripunnaiahchoudary@gmail.com, Punnaiah Choudary Kalluri <punnaia@xilinx.com>
List-Id: linux-api@vger.kernel.org

Brian, Punnaiah,

On Fri, 20 Nov 2015 11:33:42 -0800
Brian Norris <computersforpeace@gmail.com> wrote:

> On Thu, Nov 05, 2015 at 10:28:55PM +0530, Punnaiah Choudary Kalluri wrote:
> > Device like MT29F32G08ABCDBJ4 have a writesize/oobsize of 16K/1216 Bytes.
> > So, increasing the maximum ecc placement locations to 1216
> 
> I'd really prefer not increasing the size of the internal arrays any
> more. The structures should be rewritten to be dynamic.

I already started this migration (you can find the code here [1]). I
was planning to rework this series to make the eccpos definition mimic
what's done for oobfree (as suggested by Brian) before sending it, but
I'm not sure when I'll be able to do that, so if you really need that
quickly I suggest you submit those patches instead of reimplementing
it yourself.

Best Regards,

Boris

[1]https://github.com/bbrezillon/linux-sunxi/commits/nand/ecclayout

-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com
