From: Boris Brezillon <boris.brezillon@free-electrons.com>
Subject: Re: [PATCH v3 00/52] mtd: rework ECC layout definition
Date: Fri, 26 Feb 2016 03:16:00 +0100
Message-ID: <20160226031600.15ad27ba@bbrezillon>
References: <1456448280-27788-1-git-send-email-boris.brezillon@free-electrons.com>
	<d968b867f4d7f603581a0ff83e07c15c@agner.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-samsung-soc-owner@vger.kernel.org>
In-Reply-To: <d968b867f4d7f603581a0ff83e07c15c@agner.ch>
Sender: linux-samsung-soc-owner@vger.kernel.org
To: Stefan Agner <stefan@agner.ch>
Cc: David Woodhouse <dwmw2@infradead.org>, Brian Norris <computersforpeace@gmail.com>, linux-mtd@lists.infradead.org, Daniel Mack <daniel@zonque.org>, Haojian Zhuang <haojian.zhuang@gmail.com>, Robert Jarzmik <robert.jarzmik@free.fr>, Kukjin Kim <kgene@kernel.org>, Krzysztof Kozlowski <k.kozlowski@samsung.com>, linux-samsung-soc@vger.kernel.org, linux-arm-kernel@lists.infradead.org, Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org, Nicolas Ferre <nicolas.ferre@atmel.com>, Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>, Alexandre Belloni <alexandre.belloni@free-electrons.com>, Wenyou Yang <wenyou.yang@atmel.com>, Josh Wu <rainyfeeling@outlook.com>, Ezequiel Garcia <ezequiel.garcia@free-electrons.com>, Maxime Ripard <maxime.ripard@free-electrons.com>, Chen-Yu Tsai <wens@csie.org>, linux-sunxi@googlegroups.com, Kyungmin Park <kyungmin.park@samsung.co>
List-Id: linux-api@vger.kernel.org

On Thu, 25 Feb 2016 17:27:23 -0800
Stefan Agner <stefan@agner.ch> wrote:

> Hi Boris,
> 
> On 2016-02-25 16:57, Boris Brezillon wrote:
> > Hello,
> > 
> > This patchset aims at getting rid of the nand_ecclayout limitations.
> > struct nand_ecclayout is defining fixed eccpos and oobfree arrays which
> > can only be increased by modifying the MTD_MAX_ECCPOS_ENTRIES_LARGE and
> > MTD_MAX_OOBFREE_ENTRIES_LARGE macros.
> > This approach forces us to modify the macro values each time we add a
> > new NAND chip with a bigger OOB area, and increasing these arrays also
> > penalize all platforms, even those who only support small NAND devices
> > (with small OOB area).
> > 
> > The idea to overcome this limitation, is to define the ECC/OOB layout
> > by the mean of two functions: ->ecc() and ->free(), which will
> > basically return the same information has those stored in the
> > nand_ecclayout struct.
> > 
> > Another advantage of this solution is that ECC layouts are usually
> > following a repetitive pattern (i.e. leave X bytes free and put Y bytes
> > of ECC per ECC chunk), which allows one to implement the ->ecc()
> > and ->free() functions with a simple logic that can be applied
> > to any size of OOB.
> > 
> > Patches 1 to 4 are just cleanups or trivial fixes that can be taken
> > independently.
> > 
> > Also note that the last two commits are removing the nand_ecclayout
> > definition, thus preventing any new driver to use this structure.
> > Of course, this step can be delayed if some of the previous patches
> > are not accepted.
> 
> Is the patch set somewhere available to pull from?

Yes, it's here [1].

> 
> Do I see things right that patch 21/52 contains the crucial function
> nand_ooblayout_ecc_lp which calculate the ECC position? (for those who
> do not provide mtd_ooblayout_ops anyway...)

You're correct. This implementation is here for NAND controller drivers
relying on the linux default ECC layout (the one used when soft ECC is
selected, or when not layout is specified). This layout is just putting
all ECC bytes at the end of the OOB area.

[1]https://github.com/bbrezillon/linux-0day/tree/nand/ecclayout

-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com
