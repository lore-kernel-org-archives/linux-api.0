From: Boris Brezillon <boris.brezillon-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>
Subject: [PATCH v3 00/52] mtd: rework ECC layout definition
Date: Fri, 26 Feb 2016 01:57:08 +0100
Message-ID: <1456448280-27788-1-git-send-email-boris.brezillon@free-electrons.com>
Reply-To: boris.brezillon-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-sunxi+bncBCIPJ6FA2QLBBLOGX23AKGQEDPLGAGQ-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Post: <https://groups.google.com/group/linux-sunxi/post>, <mailto:linux-sunxi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <https://groups.google.com/support/>, <mailto:linux-sunxi+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Archive: <https://groups.google.com/group/linux-sunxi
Sender: linux-sunxi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
List-Subscribe: <https://groups.google.com/group/linux-sunxi/subscribe>, <mailto:linux-sunxi+subscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <mailto:googlegroups-manage+1076902468213+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>,
 <https://groups.google.com/group/linux-sunxi/subscribe>
To: David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Brian Norris <computersforpeace-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-mtd-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
Cc: Daniel Mack <daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org>, Haojian Zhuang <haojian.zhuang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Robert Jarzmik <robert.jarzmik-GANU6spQydw@public.gmane.org>, Kukjin Kim <kgene-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Krzysztof Kozlowski <k.kozlowski-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, linux-samsung-soc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Ralf Baechle <ralf-6z/3iImG2C8G8FEW9MqTrA@public.gmane.org>, linux-mips-6z/3iImG2C8G8FEW9MqTrA@public.gmane.org, Nicolas Ferre <nicolas.ferre-AIFe0yeh4nAAvxtiuMwx3w@public.gmane.org>, Jean-Christophe Plagniol-Villard <plagnioj-sclMFOaUSTBWk0Htik3J/w@public.gmane.org>, Alexandre Belloni <alexandre.belloni-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>, Wenyou Yang <wenyou.yang-AIFe0yeh4nAAvxtiuMwx3w@public.gmane.org>, Josh Wu <rainyfeeling-1ViLX0X+lBJBDgjK7y7TUQ@public.gmane.org>, Ezequiel Garcia <ezequiel.garcia-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>, Maxime Ripard <maxime.ripard-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>, Chen-Yu Tsai <wens-jdAy2FN1RRM@public.gmane.org>, linux-sunxi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, Stefan Agner <stefan-XLVq0VzYD2Y@public.gmane.org>, Kyungmin Park <kyungmin.park-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org
List-Id: linux-api@vger.kernel.org

Hello,

This patchset aims at getting rid of the nand_ecclayout limitations.
struct nand_ecclayout is defining fixed eccpos and oobfree arrays which
can only be increased by modifying the MTD_MAX_ECCPOS_ENTRIES_LARGE and
MTD_MAX_OOBFREE_ENTRIES_LARGE macros.
This approach forces us to modify the macro values each time we add a
new NAND chip with a bigger OOB area, and increasing these arrays also
penalize all platforms, even those who only support small NAND devices
(with small OOB area).

The idea to overcome this limitation, is to define the ECC/OOB layout
by the mean of two functions: ->ecc() and ->free(), which will
basically return the same information has those stored in the
nand_ecclayout struct.

Another advantage of this solution is that ECC layouts are usually
following a repetitive pattern (i.e. leave X bytes free and put Y bytes
of ECC per ECC chunk), which allows one to implement the ->ecc()
and ->free() functions with a simple logic that can be applied
to any size of OOB.

Patches 1 to 4 are just cleanups or trivial fixes that can be taken
independently.

Also note that the last two commits are removing the nand_ecclayout
definition, thus preventing any new driver to use this structure.
Of course, this step can be delayed if some of the previous patches
are not accepted.

Best Regards,

Boris

Changes since v2:
- fixed a few bugs in the core and driver implementations

Changes since v1:
- unified the way of defining ECC and free bytes
- fixed a few bugs in some ->ecc()/->free() implementations
- added new helpers to ease ECC and free bytes manipulation
- separated driver changes in different commits to ease review
- dropped already applied patches

*** BLURB HERE ***

Boris Brezillon (52):
  mtd: kill the ecclayout->oobavail field
  mtd: create an mtd_oobavail() helper and make use of it
  mtd: mtdswap: remove useless if (!mtd->ecclayout) test
  mtd: nand: simplify nand_bch_init() usage
  mtd: add mtd_ooblayout_xxx() helper functions
  mtd: use mtd_ooblayout_xxx() helpers where appropriate
  mtd: nand: core: use mtd_ooblayout_xxx() helpers where appropriate
  mtd: nand: atmel: use mtd_ooblayout_xxx() helpers where appropriate
  mtd: nand: fsl_ifc: use mtd_ooblayout_xxx() helpers where appropriate
  mtd: nand: gpmi: use mtd_ooblayout_xxx() helpers where appropriate
  mtd: nand: lpc32xx: use mtd_ooblayout_xxx() helpers where appropriate
  mtd: nand: omap2: use mtd_ooblayout_xxx() helpers where appropriate
  mtd: onenand: use mtd_ooblayout_xxx() helpers where appropriate
  mtd: add mtd_set_ecclayout() helper function
  mtd: use mtd_set_ecclayout() where appropriate
  mtd: nand: use mtd_set_ecclayout() where appropriate
  mtd: onenand: use mtd_set_ecclayout() where appropriate
  mtd: docg3: use mtd_set_ecclayout() where appropriate
  mtd: create an mtd_ooblayout_ops struct to ease ECC layout definition
  mtd: docg3: switch to mtd_ooblayout_ops
  mtd: nand: implement the default mtd_ooblayout_ops
  mtd: nand: bch: switch to mtd_ooblayout_ops
  mtd: nand: sharpsl: switch to mtd_ooblayout_ops
  mtd: nand: jz4740: switch to mtd_ooblayout_ops
  mtd: nand: atmel: switch to mtd_ooblayout_ops
  mtd: nand: bf5xx: switch to mtd_ooblayout_ops
  mtd: nand: brcm: switch to mtd_ooblayout_ops
  mtd: nand: cafe: switch to mtd_ooblayout_ops
  mtd: nand: davinci: switch to mtd_ooblayout_ops
  mtd: nand: denali: switch to mtd_ooblayout_ops
  mtd: nand: diskonchip: switch to mtd_ooblayout_ops
  mtd: nand: docg4: switch to mtd_ooblayout_ops
  mtd: nand: fsl_elbc: switch to mtd_ooblayout_ops
  mtd: nand: fsl_ifc: switch to mtd_ooblayout_ops
  mtd: nand: fsmc: switch to mtd_ooblayout_ops
  mtd: nand: fsmc: get rid of the fsmc_nand_eccplace struct
  mtd: nand: gpmi: switch to mtd_ooblayout_ops
  mtd: nand: hisi504: switch to mtd_ooblayout_ops
  mtd: nand: jz4780: switch to mtd_ooblayout_ops
  mtd: nand: lpc32xx: switch to mtd_ooblayout_ops
  mtd: nand: mxc: switch to mtd_ooblayout_ops
  mtd: nand: omap2: switch to mtd_ooblayout_ops
  mtd: nand: pxa3xx: switch to mtd_ooblayout_ops
  mtd: nand: s3c2410: switch to mtd_ooblayout_ops
  mtd: nand: sh_flctl: switch to mtd_ooblayout_ops
  mtd: nand: sm_common: switch to mtd_ooblayout_ops
  mtd: nand: sunxi: switch to mtd_ooblayout_ops
  mtd: nand: vf610: switch to mtd_ooblayout_ops
  mtd: onenand: switch to mtd_ooblayout_ops
  staging: mt29f_spinand: switch to mtd_ooblayout_ops
  mtd: nand: kill the ecc->layout field
  mtd: kill the nand_ecclayout struct

 arch/arm/mach-pxa/spitz.c                       |  55 +++-
 arch/mips/include/asm/mach-jz4740/jz4740_nand.h |   2 +-
 arch/mips/jz4740/board-qi_lb60.c                |  87 +++---
 drivers/mtd/devices/docg3.c                     |  51 +++-
 drivers/mtd/mtdchar.c                           | 123 ++++++--
 drivers/mtd/mtdconcat.c                         |   2 +-
 drivers/mtd/mtdcore.c                           | 358 ++++++++++++++++++++++++
 drivers/mtd/mtdpart.c                           |  28 +-
 drivers/mtd/mtdswap.c                           |  24 +-
 drivers/mtd/nand/atmel_nand.c                   | 130 ++++-----
 drivers/mtd/nand/bf5xx_nand.c                   |  51 ++--
 drivers/mtd/nand/brcmnand/brcmnand.c            | 262 ++++++++++-------
 drivers/mtd/nand/cafe_nand.c                    |  45 ++-
 drivers/mtd/nand/davinci_nand.c                 | 118 +++-----
 drivers/mtd/nand/denali.c                       |  51 +++-
 drivers/mtd/nand/diskonchip.c                   |  60 +++-
 drivers/mtd/nand/docg4.c                        |  34 ++-
 drivers/mtd/nand/fsl_elbc_nand.c                |  83 +++---
 drivers/mtd/nand/fsl_ifc_nand.c                 | 245 +++++-----------
 drivers/mtd/nand/fsmc_nand.c                    | 322 ++++++---------------
 drivers/mtd/nand/gpmi-nand/gpmi-nand.c          |  61 ++--
 drivers/mtd/nand/hisi504_nand.c                 |  27 +-
 drivers/mtd/nand/jz4740_nand.c                  |   2 +-
 drivers/mtd/nand/jz4780_nand.c                  |  19 +-
 drivers/mtd/nand/lpc32xx_mlc.c                  |  50 ++--
 drivers/mtd/nand/lpc32xx_slc.c                  |  58 +++-
 drivers/mtd/nand/mxc_nand.c                     | 212 +++++++-------
 drivers/mtd/nand/nand_base.c                    | 344 ++++++++++++-----------
 drivers/mtd/nand/nand_bch.c                     |  46 ++-
 drivers/mtd/nand/omap2.c                        | 241 +++++++++-------
 drivers/mtd/nand/pxa3xx_nand.c                  | 104 ++++---
 drivers/mtd/nand/s3c2410.c                      |  32 ++-
 drivers/mtd/nand/sh_flctl.c                     |  87 ++++--
 drivers/mtd/nand/sharpsl.c                      |   2 +-
 drivers/mtd/nand/sm_common.c                    |  93 ++++--
 drivers/mtd/nand/sunxi_nand.c                   | 114 ++++----
 drivers/mtd/nand/vf610_nfc.c                    |  34 +--
 drivers/mtd/onenand/onenand_base.c              | 262 ++++++++---------
 drivers/mtd/tests/oobtest.c                     |  49 ++--
 drivers/staging/mt29f_spinand/mt29f_spinand.c   |  49 ++--
 fs/jffs2/wbuf.c                                 |   6 +-
 include/linux/mtd/fsmc.h                        |  18 --
 include/linux/mtd/mtd.h                         |  69 ++++-
 include/linux/mtd/nand.h                        |   5 +-
 include/linux/mtd/nand_bch.h                    |   8 +-
 include/linux/mtd/onenand.h                     |   2 -
 include/linux/mtd/sharpsl.h                     |   2 +-
 include/uapi/mtd/mtd-abi.h                      |   2 +-
 48 files changed, 2375 insertions(+), 1754 deletions(-)

-- 
2.1.4
