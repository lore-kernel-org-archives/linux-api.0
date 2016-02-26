From: Boris Brezillon <boris.brezillon-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCH v3 07/52] mtd: nand: core: use
 mtd_ooblayout_xxx() helpers where appropriate
Date: Fri, 26 Feb 2016 16:10:54 +0100
Message-ID: <20160226161054.3477cd4b@bbrezillon>
References: <1456448280-27788-1-git-send-email-boris.brezillon@free-electrons.com>
	<1456448280-27788-8-git-send-email-boris.brezillon@free-electrons.com>
	<56D0629C.9080805@imgtec.com>
Reply-To: boris.brezillon-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-sunxi+bncBCIPJ6FA2QLBBC6WYG3AKGQEAJLGI4A-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
In-Reply-To: <56D0629C.9080805-1AXoQHu6uovQT0dZR+AlfA@public.gmane.org>
List-Post: <https://groups.google.com/group/linux-sunxi/post>, <mailto:linux-sunxi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <https://groups.google.com/support/>, <mailto:linux-sunxi+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Archive: <https://groups.google.com/group/linux-sunxi
Sender: linux-sunxi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
List-Subscribe: <https://groups.google.com/group/linux-sunxi/subscribe>, <mailto:linux-sunxi+subscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <mailto:googlegroups-manage+1076902468213+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>,
 <https://groups.google.com/group/linux-sunxi/subscribe>
To: Harvey Hunt <harvey.hunt-1AXoQHu6uovQT0dZR+AlfA@public.gmane.org>
Cc: David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Brian Norris <computersforpeace-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-mtd-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Daniel Mack <daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org>, Haojian Zhuang <haojian.zhuang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Robert Jarzmik <robert.jarzmik-GANU6spQydw@public.gmane.org>, Kukjin Kim <kgene-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Krzysztof Kozlowski <k.kozlowski-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, linux-samsung-soc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Ralf Baechle <ralf-6z/3iImG2C8G8FEW9MqTrA@public.gmane.org>, linux-mips-6z/3iImG2C8G8FEW9MqTrA@public.gmane.org, Nicolas Ferre <nicolas.ferre-AIFe0yeh4nAAvxtiuMwx3w@public.gmane.org>, Jean-Christophe Plagniol-Villard <plagnioj-sclMFOaUSTBWk0Htik3J/w@public.gmane.org>, Alexandre Belloni <alexandre.belloni-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>, Wenyou Yang <wenyou.yang-AIFe0yeh4nAAvxtiuMwx3w@public.gmane.org>, Josh Wu <rainyfeeling-1ViLX0X+lBJBDgjK7y7TUQ@public.gmane.org>, Ezequiel Garcia <ezequiel.garcia-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>, Maxime Ripard <maxime.ripard-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>, Chen-Yu Tsai <wens-jdAy2FN1RRM@public.gmane.org>, linux-sunxi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, Stefan Agner <stefan-XLVq0VzYD2Y@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hi Harvey,

On Fri, 26 Feb 2016 14:35:08 +0000
Harvey Hunt <harvey.hunt-1AXoQHu6uovQT0dZR+AlfA@public.gmane.org> wrote:

> Hi Boris,
> 
> On 26/02/16 00:57, Boris Brezillon wrote:
> > The mtd_ooblayout_xxx() helper functions have been added to avoid direct
> > accesses to the ecclayout field, and thus ease for future reworks.
> > Use these helpers in all places where the oobfree[] and eccpos[] arrays
> > where directly accessed.
> >
> > Signed-off-by: Boris Brezillon <boris.brezillon-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>
> > ---
> >   drivers/mtd/nand/nand_base.c | 183 +++++++++++++++++++------------------------
> >   drivers/mtd/nand/nand_bch.c  |   3 +-
> >   2 files changed, 82 insertions(+), 104 deletions(-)
> >
> > diff --git a/drivers/mtd/nand/nand_base.c b/drivers/mtd/nand/nand_base.c
> > index 91672bf..17504f2 100644
> [...]
> 
> I just pulled your nand/ecclayout branch from github and tested out your 
> latest patchset "mtd: rework ECC layout definition" on a Ci20 
> (jz4780_{nand,bch}) and noticed that my board was failing to boot.
> 
> I bisected to this patch, here is the kernel's output during boot:
> 
> 479556d ("mtd: nand: core: use mtd_ooblayout_xxx() helpers where 
> appropriate"):
> 
> [ 0.256349] nand: device found, Manufacturer ID: 0x2c, Chip ID: 0x88
> [ 0.262860] nand: Micron MT29F64G08CBAAAWP
> [ 0.266970] nand: 8192 MiB, MLC, erase size: 2048 KiB, page size: 8192, 
> OOB size: 448
> [ 0.274856] jz4780-nand 1b000000.nand-controller: using hardware BCH 
> (strength 24, size 1024, bytes 42)
> [ 0.288982] Bad block table not found for chip 0
> [ 0.297673] Bad block table not found for chip 0
> [ 0.302328] Scanning device for bad blocks
> [ 0.320135] Bad eraseblock 90 at 0x00000b400000
> [ 0.324829] Bad eraseblock 91 at 0x00000b600000
> [ 0.931085] Bad eraseblock 4092 at 0x0001ff800000
> [ 0.935947] Bad eraseblock 4093 at 0x0001ffa00000
> [ 0.944878] nand_bbt: error while writing bad block table -34
> [ 0.950666] jz4780-nand: probe of 1b000000.nand-controller failed with 
> error -34
> [ 0.958302] UBI error: cannot open mtd 3, error -19
> [ 0.963002] UBI error: cannot open mtd 4, error -19[ 0.970419] clk: Not 
> disabling unused clocks
> [ 0.975011] UBIFS error (pid: 1): cannot open "ubi1:root", error -19VFS: 
> Cannot open root device "ubi1:root" or unknown-block(0,0): error -19
> [ 0.987810] Please append a correct "root=" boot option; here are the 
> available partitions:
> [ 0.996210] Kernel panic - not syncing: VFS: Unable to mount root fs on 
> unknown-block(0,0)
> [ 1.004498] Rebooting in 10 seconds..
> 
> 6625d32 ("mtd: use mtd_ooblayout_xxx() helpers where appropriate"):
> 
> [ 0.256232] nand: device found, Manufacturer ID: 0x2c, Chip ID: 0x88
> [ 0.262745] nand: Micron MT29F64G08CBAAAWP
> [ 0.266854] nand: 8192 MiB, MLC, erase size: 2048 KiB, page size: 8192, 
> OOB size: 448
> [ 0.274739] jz4780-nand 1b000000.nand-controller: using hardware BCH 
> (strength 24, size 1024, bytes 42)
> [ 0.285993] Bad block table found at page 1048320, version 0x01
> [ 0.294353] Bad block table found at page 1048064, version 0x01
> [ 0.301523] nand_read_bbt: bad block at 0x00000b400000
> [ 0.306677] nand_read_bbt: bad block at 0x00000b600000
> [ 0.312289] 5 ofpart partitions found on MTD device 
> 1b000000.nand-controller.1
> [ 0.319553] Creating 5 MTD partitions on "1b000000.nand-controller.1":
> [ 0.326098] 0x000000000000-0x000000800000 : "u-boot-spl"
> [ 0.331757] 0x000000800000-0x000000a00000 : "u-boot"
> [ 0.337185] 0x000000a00000-0x000000c00000 : "u-boot-env"
> [ 0.342903] 0x000000c00000-0x000004c00000 : "boot"
> [ 0.348109] 0x000004c00000-0x000200000000 : "system"
> [ 0.354284] ubi0 error: ubi_attach_mtd_dev: More than 64 PEBs are needed 
> for fastmap, sorry.
> [...]
> 
> I'll look into this more later today, but wanted to run it by you in 
> case you have any thoughts.

Can you apply this patch [1], and let me know if you see the additional
trace?

Thanks,

Boris

[1]http://code.bulix.org/l2hkl1-91947

-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com
