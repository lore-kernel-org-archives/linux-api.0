From: Nicolas Ferre <nicolas.ferre-AIFe0yeh4nAAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v5 04/50] mtd: nand: atmel: use mtd_ooblayout_xxx()
 helpers where appropriate
Date: Wed, 13 Apr 2016 17:28:39 +0200
Message-ID: <570E65A7.5000705@atmel.com>
References: <1459354505-32551-1-git-send-email-boris.brezillon@free-electrons.com>
 <1459354505-32551-5-git-send-email-boris.brezillon@free-electrons.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1459354505-32551-5-git-send-email-boris.brezillon-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Boris Brezillon <boris.brezillon-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Brian Norris <computersforpeace-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-mtd-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>
Cc: Daniel Mack <daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org>, Haojian Zhuang <haojian.zhuang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Robert Jarzmik <robert.jarzmik-GANU6spQydw@public.gmane.org>, Kukjin Kim <kgene-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Krzysztof Kozlowski <k.kozlowski-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, linux-samsung-soc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Ralf Baechle <ralf-6z/3iImG2C8G8FEW9MqTrA@public.gmane.org>, linux-mips-6z/3iImG2C8G8FEW9MqTrA@public.gmane.org, Jean-Christophe Plagniol-Villard <plagnioj-sclMFOaUSTBWk0Htik3J/w@public.gmane.org>, Alexandre Belloni <alexandre.belloni-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>, Wenyou Yang <wenyou.yang-AIFe0yeh4nAAvxtiuMwx3w@public.gmane.org>, Josh Wu <rainyfeeling-1ViLX0X+lBJBDgjK7y7TUQ@public.gmane.org>, Ezequiel Garcia <ezequiel.garcia-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>, Maxime Ripard <maxime.ripard-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>, Chen-Yu Tsai <wens-jdAy2FN1RRM@public.gmane.org>, linux-sunxi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, Stefan Agner <stefan-XLVq0VzYD2Y@public.gmane.org>, Kyungmin Park <kyungmin.park-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Le 30/03/2016 18:14, Boris Brezillon a =E9crit :
> The mtd_ooblayout_xxx() helper functions have been added to avoid dir=
ect
> accesses to the ecclayout field, and thus ease for future reworks.
> Use these helpers in all places where the oobfree[] and eccpos[] arra=
ys
> where directly accessed.
>=20
> Signed-off-by: Boris Brezillon <boris.brezillon-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>
> ---
>  drivers/mtd/nand/atmel_nand.c | 48 ++++++++++++++++++++++++++-------=
----------
>  1 file changed, 29 insertions(+), 19 deletions(-)
>=20
> diff --git a/drivers/mtd/nand/atmel_nand.c b/drivers/mtd/nand/atmel_n=
and.c
> index 0b5da72..321d331 100644
> --- a/drivers/mtd/nand/atmel_nand.c
> +++ b/drivers/mtd/nand/atmel_nand.c
> @@ -836,13 +836,16 @@ static void pmecc_correct_data(struct mtd_info =
*mtd, uint8_t *buf, uint8_t *ecc,
>  			dev_dbg(host->dev, "Bit flip in data area, byte_pos: %d, bit_pos:=
 %d, 0x%02x -> 0x%02x\n",
>  				pos, bit_pos, err_byte, *(buf + byte_pos));
>  		} else {
> +			struct mtd_oob_region oobregion;
> +
>  			/* Bit flip in OOB area */
>  			tmp =3D sector_num * nand_chip->ecc.bytes
>  					+ (byte_pos - sector_size);
>  			err_byte =3D ecc[tmp];
>  			ecc[tmp] ^=3D (1 << bit_pos);
> =20
> -			pos =3D tmp + nand_chip->ecc.layout->eccpos[0];
> +			mtd_ooblayout_ecc(mtd, 0, &oobregion);
> +			pos =3D tmp + oobregion.offset;
>  			dev_dbg(host->dev, "Bit flip in OOB, oob_byte_pos: %d, bit_pos: %=
d, 0x%02x -> 0x%02x\n",
>  				pos, bit_pos, err_byte, ecc[tmp]);
>  		}
> @@ -934,7 +937,6 @@ static int atmel_nand_pmecc_read_page(struct mtd_=
info *mtd,
>  	struct atmel_nand_host *host =3D nand_get_controller_data(chip);
>  	int eccsize =3D chip->ecc.size * chip->ecc.steps;
>  	uint8_t *oob =3D chip->oob_poi;
> -	uint32_t *eccpos =3D chip->ecc.layout->eccpos;
>  	uint32_t stat;
>  	unsigned long end_time;
>  	int bitflips =3D 0;
> @@ -956,7 +958,11 @@ static int atmel_nand_pmecc_read_page(struct mtd=
_info *mtd,
> =20
>  	stat =3D pmecc_readl_relaxed(host->ecc, ISR);
>  	if (stat !=3D 0) {
> -		bitflips =3D pmecc_correction(mtd, stat, buf, &oob[eccpos[0]]);
> +		struct mtd_oob_region oobregion;
> +
> +		mtd_ooblayout_ecc(mtd, 0, &oobregion);
> +		bitflips =3D pmecc_correction(mtd, stat, buf,
> +					    &oob[oobregion.offset]);
>  		if (bitflips < 0)
>  			/* uncorrectable errors */
>  			return 0;
> @@ -970,8 +976,8 @@ static int atmel_nand_pmecc_write_page(struct mtd=
_info *mtd,
>  		int page)
>  {
>  	struct atmel_nand_host *host =3D nand_get_controller_data(chip);
> -	uint32_t *eccpos =3D chip->ecc.layout->eccpos;
> -	int i, j;
> +	struct mtd_oob_region oobregion =3D { };
> +	int i, j, section =3D 0;
>  	unsigned long end_time;
> =20
>  	if (!host->nfc || !host->nfc->write_by_sram) {
> @@ -990,11 +996,12 @@ static int atmel_nand_pmecc_write_page(struct m=
td_info *mtd,
> =20
>  	for (i =3D 0; i < chip->ecc.steps; i++) {
>  		for (j =3D 0; j < chip->ecc.bytes; j++) {
> -			int pos;
> +			if (!oobregion.length)
> +				mtd_ooblayout_ecc(mtd, section++, &oobregion);

Here...


> =20
> -			pos =3D i * chip->ecc.bytes + j;
> -			chip->oob_poi[eccpos[pos]] =3D
> +			chip->oob_poi[oobregion.offset++] =3D

=2E.. and there, are you sure to increment the variable inside the
function call or the table index?

I must say that I don't like it at all.


>  				pmecc_readb_ecc_relaxed(host->ecc, i, j);
> +			oobregion.length--;

Simply do it here, it's so much easier to read and fool proof!


>  		}
>  	}
>  	chip->write_buf(mtd, chip->oob_poi, mtd->oobsize);
> @@ -1008,6 +1015,7 @@ static void atmel_pmecc_core_init(struct mtd_in=
fo *mtd)
>  	struct atmel_nand_host *host =3D nand_get_controller_data(nand_chip=
);
>  	uint32_t val =3D 0;
>  	struct nand_ecclayout *ecc_layout;
> +	struct mtd_oob_region oobregion;
> =20
>  	pmecc_writel(host->ecc, CTRL, PMECC_CTRL_RST);
>  	pmecc_writel(host->ecc, CTRL, PMECC_CTRL_DISABLE);
> @@ -1059,9 +1067,10 @@ static void atmel_pmecc_core_init(struct mtd_i=
nfo *mtd)
> =20
>  	ecc_layout =3D nand_chip->ecc.layout;
>  	pmecc_writel(host->ecc, SAREA, mtd->oobsize - 1);
> -	pmecc_writel(host->ecc, SADDR, ecc_layout->eccpos[0]);
> +	mtd_ooblayout_ecc(mtd, 0, &oobregion);
> +	pmecc_writel(host->ecc, SADDR, oobregion.offset);
>  	pmecc_writel(host->ecc, EADDR,
> -			ecc_layout->eccpos[ecc_layout->eccbytes - 1]);
> +		     oobregion.offset + ecc_layout->eccbytes - 1);
>  	/* See datasheet about PMECC Clock Control Register */
>  	pmecc_writel(host->ecc, CLK, 2);
>  	pmecc_writel(host->ecc, IDR, 0xff);
> @@ -1362,12 +1371,12 @@ static int atmel_nand_read_page(struct mtd_in=
fo *mtd, struct nand_chip *chip,
>  {
>  	int eccsize =3D chip->ecc.size;
>  	int eccbytes =3D chip->ecc.bytes;
> -	uint32_t *eccpos =3D chip->ecc.layout->eccpos;
>  	uint8_t *p =3D buf;
>  	uint8_t *oob =3D chip->oob_poi;
>  	uint8_t *ecc_pos;
>  	int stat;
>  	unsigned int max_bitflips =3D 0;
> +	struct mtd_oob_region oobregion =3D {};
> =20
>  	/*
>  	 * Errata: ALE is incorrectly wired up to the ECC controller
> @@ -1385,19 +1394,20 @@ static int atmel_nand_read_page(struct mtd_in=
fo *mtd, struct nand_chip *chip,
>  	chip->read_buf(mtd, p, eccsize);
> =20
>  	/* move to ECC position if needed */
> -	if (eccpos[0] !=3D 0) {
> -		/* This only works on large pages
> -		 * because the ECC controller waits for
> -		 * NAND_CMD_RNDOUTSTART after the
> -		 * NAND_CMD_RNDOUT.
> -		 * anyway, for small pages, the eccpos[0] =3D=3D 0
> +	mtd_ooblayout_ecc(mtd, 0, &oobregion);
> +	if (oobregion.offset !=3D 0) {
> +		/*
> +		 * This only works on large pages because the ECC controller
> +		 * waits for NAND_CMD_RNDOUTSTART after the NAND_CMD_RNDOUT.
> +		 * Anyway, for small pages, the first ECC byte is at offset
> +		 * 0 in the OOB area.
>  		 */
>  		chip->cmdfunc(mtd, NAND_CMD_RNDOUT,
> -				mtd->writesize + eccpos[0], -1);
> +			      mtd->writesize + oobregion.offset, -1);
>  	}
> =20
>  	/* the ECC controller needs to read the ECC just after the data */
> -	ecc_pos =3D oob + eccpos[0];
> +	ecc_pos =3D oob + oobregion.offset;
>  	chip->read_buf(mtd, ecc_pos, eccbytes);
> =20
>  	/* check if there's an error */
>=20


--=20
Nicolas Ferre
