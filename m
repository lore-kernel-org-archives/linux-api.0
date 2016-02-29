From: Harvey Hunt <harvey.hunt@imgtec.com>
Subject: Re: [PATCH v3 39/52] mtd: nand: jz4780: switch to mtd_ooblayout_ops
Date: Mon, 29 Feb 2016 10:45:56 +0000
Message-ID: <56D42164.9030007@imgtec.com>
References: <1456448280-27788-1-git-send-email-boris.brezillon@free-electrons.com>
 <1456448280-27788-40-git-send-email-boris.brezillon@free-electrons.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-samsung-soc-owner@vger.kernel.org>
In-Reply-To: <1456448280-27788-40-git-send-email-boris.brezillon@free-electrons.com>
Sender: linux-samsung-soc-owner@vger.kernel.org
To: Boris Brezillon <boris.brezillon@free-electrons.com>, David Woodhouse <dwmw2@infradead.org>, Brian Norris <computersforpeace@gmail.com>, linux-mtd@lists.infradead.org
Cc: Daniel Mack <daniel@zonque.org>, Haojian Zhuang <haojian.zhuang@gmail.com>, Robert Jarzmik <robert.jarzmik@free.fr>, Kukjin Kim <kgene@kernel.org>, Krzysztof Kozlowski <k.kozlowski@samsung.com>, linux-samsung-soc@vger.kernel.org, linux-arm-kernel@lists.infradead.org, Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org, Nicolas Ferre <nicolas.ferre@atmel.com>, Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>, Alexandre Belloni <alexandre.belloni@free-electrons.com>, Wenyou Yang <wenyou.yang@atmel.com>, Josh Wu <rainyfeeling@outlook.com>, Ezequiel Garcia <ezequiel.garcia@free-electrons.com>, Maxime Ripard <maxime.ripard@free-electrons.com>, Chen-Yu Tsai <wens@csie.org>, linux-sunxi@googlegroups.com, Stefan Agner <stefan@agner.ch>, Kyungmin Park <kyungmin.park@samsung.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, devel@driverde
List-Id: linux-api@vger.kernel.org

Hi Boris,

On 26/02/16 00:57, Boris Brezillon wrote:
> Implementing the mtd_ooblayout_ops interface is the new way of exposing
> ECC/OOB layout to MTD users.
>
> Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>
> ---
>   drivers/mtd/nand/jz4780_nand.c | 19 +++++--------------
>   1 file changed, 5 insertions(+), 14 deletions(-)
>
> diff --git a/drivers/mtd/nand/jz4780_nand.c b/drivers/mtd/nand/jz4780_nand.c
> index e1c016c..b86a579 100644
> --- a/drivers/mtd/nand/jz4780_nand.c
> +++ b/drivers/mtd/nand/jz4780_nand.c
> @@ -56,8 +56,6 @@ struct jz4780_nand_chip {
>   	struct nand_chip chip;
>   	struct list_head chip_list;
>
> -	struct nand_ecclayout ecclayout;
> -
>   	struct gpio_desc *busy_gpio;
>   	struct gpio_desc *wp_gpio;
>   	unsigned int reading: 1;
> @@ -165,8 +163,7 @@ static int jz4780_nand_init_ecc(struct jz4780_nand_chip *nand, struct device *de
>   	struct nand_chip *chip = &nand->chip;
>   	struct mtd_info *mtd = nand_to_mtd(chip);
>   	struct jz4780_nand_controller *nfc = to_jz4780_nand_controller(chip->controller);
> -	struct nand_ecclayout *layout = &nand->ecclayout;
> -	u32 start, i;
> +	int eccbytes;
>
>   	chip->ecc.bytes = fls((1 + 8) * chip->ecc.size)	*
>   				(chip->ecc.strength / 8);
> @@ -201,23 +198,17 @@ static int jz4780_nand_init_ecc(struct jz4780_nand_chip *nand, struct device *de
>   		return 0;
>
>   	/* Generate ECC layout. ECC codes are right aligned in the OOB area. */
> -	layout->eccbytes = mtd->writesize / chip->ecc.size * chip->ecc.bytes;
> +	eccbytes = mtd->writesize / chip->ecc.size * chip->ecc.bytes;
>
> -	if (layout->eccbytes > mtd->oobsize - 2) {
> +	if (eccbytes > mtd->oobsize - 2) {
>   		dev_err(dev,
>   			"invalid ECC config: required %d ECC bytes, but only %d are available",
> -			layout->eccbytes, mtd->oobsize - 2);
> +			eccbytes, mtd->oobsize - 2);
>   		return -EINVAL;
>   	}
>
> -	start = mtd->oobsize - layout->eccbytes;
> -	for (i = 0; i < layout->eccbytes; i++)
> -		layout->eccpos[i] = start + i;
> -
> -	layout->oobfree[0].offset = 2;
> -	layout->oobfree[0].length = mtd->oobsize - layout->eccbytes - 2;
> +	mtd->ooblayout = &nand_ooblayout_lp_ops;
>
> -	chip->ecc.layout = layout;
>   	return 0;
>   }
>
>

With your patch applied [0] that you gave me earlier in the patchset, I 
am able to boot to userland on my Ci20 (jz4780_{nand,bch}) with a NAND 
rootfs. So, dependant upon that patch (or equivalent) being added to 
this patchset:

Tested-by: Harvey Hunt <harvey.hunt@imgtec.com>

Thanks,

Harvey

[0] http://code.bulix.org/36oytz-91960
