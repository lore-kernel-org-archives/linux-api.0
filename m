From: Han Xu <han.xu-3arQi8VN3Tc@public.gmane.org>
Subject: Re: [PATCH v5 34/50] mtd: nand: gpmi: switch to mtd_ooblayout_ops
Date: Tue, 12 Apr 2016 22:27:58 +0000
Message-ID: <DB5PR0401MB1845A6EE26FD2734CDBBE20F97950@DB5PR0401MB1845.eurprd04.prod.outlook.com>
References: <1459354505-32551-1-git-send-email-boris.brezillon@free-electrons.com>,<1459354505-32551-35-git-send-email-boris.brezillon@free-electrons.com>
Reply-To: han.xu-3arQi8VN3Tc@public.gmane.org
Mime-Version: 1.0
Content-Type: multipart/alternative;
	boundary="_000_DB5PR0401MB1845A6EE26FD2734CDBBE20F97950DB5PR0401MB1845_"
Return-path: <linux-sunxi+bncBAABBOPRWW4AKGQEGVVJBOQ-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
Sender: linux-sunxi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
In-Reply-To: <1459354505-32551-35-git-send-email-boris.brezillon-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>
Content-Language: en-US
List-Post: <https://groups.google.com/group/linux-sunxi/post>, <mailto:linux-sunxi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <https://groups.google.com/support/>, <mailto:linux-sunxi+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Archive: <https://groups.google.com/group/linux-sunxi
List-Subscribe: <https://groups.google.com/group/linux-sunxi/subscribe>, <mailto:linux-sunxi+subscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <mailto:googlegroups-manage+1076902468213+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>,
 <https://groups.google.com/group/linux-sunxi/subscribe>
To: Boris Brezillon <boris.brezillon-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Brian Norris <computersforpeace-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-mtd-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-mtd-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, Richard
 Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>
Cc: Daniel Mack <daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org>, Haojian Zhuang <haojian.zhuang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Robert Jarzmik <robert.jarzmik-GANU6spQydw@public.gmane.org>, Kukjin
 Kim <kgene-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Krzysztof Kozlowski <k.kozlowski-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, "linux-samsung-soc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-samsung-soc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, Ralf Baechle <ralf-6z/3iImG2C8G8FEW9MqTrA@public.gmane.org>, "linux-mips-6z/3iImG2C8G8FEW9MqTrA@public.gmane.org" <linux-mips-6z/3iImG2C8G8FEW9MqTrA@public.gmane.org>, Nicolas Ferre <nicolas.ferre-AIFe0yeh4nAAvxtiuMwx3w@public.gmane.org>, Jean-Christophe Plagniol-Villard <plagnioj-sclMFOaUSTBWk0Htik3J/w@public.gmane.org>, Alexandre Belloni <alexandre.belloni-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>, Wenyou Yang <wenyou.yang-AIFe0yeh4nAAvxtiuMwx3w@public.gmane.org>, Josh Wu <rainyfeeling-1ViLX0X+lBJBDgjK7y7TUQ@public.gmane.org>, Ezequiel Garcia <ezequiel.garcia-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>, Maxime Ripard <maxime.ripard-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>, Chen-Yu Tsai <wens-jdAy2FN1RRM@public.gmane.org>, "linux-sunxi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org" <linux-sunxi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>, Stefan
List-Id: linux-api@vger.kernel.org

--_000_DB5PR0401MB1845A6EE26FD2734CDBBE20F97950DB5PR0401MB1845_
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable




________________________________
From: Boris Brezillon <boris.brezillon-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>
Sent: Wednesday, March 30, 2016 10:14 AM
To: David Woodhouse; Brian Norris; linux-mtd-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org; Boris Bre=
zillon; Richard Weinberger
Cc: Daniel Mack; Haojian Zhuang; Robert Jarzmik; Kukjin Kim; Krzysztof Kozl=
owski; linux-samsung-soc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; linux-arm-kernel-IAPFreCvJWM7uuMidbF8XQ@public.gmane.org=
org; Ralf Baechle; linux-mips-6z/3iImG2C8G8FEW9MqTrA@public.gmane.org; Nicolas Ferre; Jean-Christoph=
e Plagniol-Villard; Alexandre Belloni; Wenyou Yang; Josh Wu; Ezequiel Garci=
a; Maxime Ripard; Chen-Yu Tsai; linux-sunxi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org; Stefan Agner;=
 Kyungmin Park; Greg Kroah-Hartman; devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org; linux-kerne=
l@vger.kernel.org; punnaiah choudary kalluri; Priit Laes; Kamal Dasu; bcm-k=
ernel-feedback-list-dY08KVG/lbpWk0Htik3J/w@public.gmane.org; linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Harvey Hunt; A=
rchit Taneja; b45815-KZfg59tc24xl57MIdRCFDg@public.gmane.org; Huang Shijie
Subject: [PATCH v5 34/50] mtd: nand: gpmi: switch to mtd_ooblayout_ops

Implementing the mtd_ooblayout_ops interface is the new way of exposing
ECC/OOB layout to MTD users.

Signed-off-by: Boris Brezillon <boris.brezillon-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>
---
 drivers/mtd/nand/gpmi-nand/gpmi-nand.c | 52 ++++++++++++++++++++++++++----=
----
 1 file changed, 40 insertions(+), 12 deletions(-)

diff --git a/drivers/mtd/nand/gpmi-nand/gpmi-nand.c b/drivers/mtd/nand/gpmi=
-nand/gpmi-nand.c
index 3a29b65..316b5ac 100644
--- a/drivers/mtd/nand/gpmi-nand/gpmi-nand.c
+++ b/drivers/mtd/nand/gpmi-nand/gpmi-nand.c
@@ -47,10 +47,44 @@ static struct nand_bbt_descr gpmi_bbt_descr =3D {
  * We may change the layout if we can get the ECC info from the datasheet,
  * else we will use all the (page + OOB).
  */
-static struct nand_ecclayout gpmi_hw_ecclayout =3D {
-       .eccbytes =3D 0,
-       .eccpos =3D { 0, },
-       .oobfree =3D { {.offset =3D 0, .length =3D 0} }
+static int gpmi_ooblayout_ecc(struct mtd_info *mtd, int section,
+                             struct mtd_oob_region *oobregion)
+{
+       struct nand_chip *chip =3D mtd_to_nand(mtd);
+       struct gpmi_nand_data *this =3D nand_get_controller_data(chip);
+       struct bch_geometry *geo =3D &this->bch_geometry;
+
+       if (section)
+               return -ERANGE;
+
+       oobregion->offset =3D 0;
+       oobregion->length =3D geo->page_size - mtd->writesize;
+
+       return 0;
+}
+
+static int gpmi_ooblayout_free(struct mtd_info *mtd, int section,
+                              struct mtd_oob_region *oobregion)
+{
+       struct nand_chip *chip =3D mtd_to_nand(mtd);
+       struct gpmi_nand_data *this =3D nand_get_controller_data(chip);
+       struct bch_geometry *geo =3D &this->bch_geometry;
+
+       if (section)
+               return -ERANGE;
+
+       /* The available oob size we have. */
+       if (geo->page_size < mtd->writesize + mtd->oobsize) {
+               oobregion->offset =3D geo->page_size - mtd->writesize;
+               oobregion->length =3D mtd->oobsize - oobregion->offset;
+       }
+
+       return 0;
+}
+
+static const struct mtd_ooblayout_ops gpmi_ooblayout_ops =3D {
+       .ecc =3D gpmi_ooblayout_ecc,
+       .free =3D gpmi_ooblayout_free,
 };

 static const struct gpmi_devdata gpmi_devdata_imx23 =3D {
@@ -141,7 +175,6 @@ static int set_geometry_by_ecc_info(struct gpmi_nand_da=
ta *this)
         struct bch_geometry *geo =3D &this->bch_geometry;
         struct nand_chip *chip =3D &this->nand;
         struct mtd_info *mtd =3D nand_to_mtd(chip);
-       struct nand_oobfree *of =3D gpmi_hw_ecclayout.oobfree;
         unsigned int block_mark_bit_offset;

         if (!(chip->ecc_strength_ds > 0 && chip->ecc_step_ds > 0))
@@ -229,12 +262,6 @@ static int set_geometry_by_ecc_info(struct gpmi_nand_d=
ata *this)
         geo->page_size =3D mtd->writesize + geo->metadata_size +
                 (geo->gf_len * geo->ecc_strength * geo->ecc_chunk_count) /=
 8;

-       /* The available oob size we have. */
-       if (geo->page_size < mtd->writesize + mtd->oobsize) {
-               of->offset =3D geo->page_size - mtd->writesize;
-               of->length =3D mtd->oobsize - of->offset;
-       }
-
         geo->payload_size =3D mtd->writesize;

         geo->auxiliary_status_offset =3D ALIGN(geo->metadata_size, 4);
@@ -1841,6 +1868,7 @@ static void gpmi_nand_exit(struct gpmi_nand_data *thi=
s)
 static int gpmi_init_last(struct gpmi_nand_data *this)
 {
         struct nand_chip *chip =3D &this->nand;
+       struct mtd_info *mtd =3D nand_to_mtd(chip);
         struct nand_ecc_ctrl *ecc =3D &chip->ecc;
         struct bch_geometry *bch_geo =3D &this->bch_geometry;
         int ret;
@@ -1862,7 +1890,7 @@ static int gpmi_init_last(struct gpmi_nand_data *this=
)
         ecc->mode       =3D NAND_ECC_HW;
         ecc->size       =3D bch_geo->ecc_chunk_size;
         ecc->strength   =3D bch_geo->ecc_strength;
-       ecc->layout     =3D &gpmi_hw_ecclayout;
+       mtd_set_ooblayout(mtd, &gpmi_ooblayout_ops);

         /*
          * We only enable the subpage read when:

I am fine with all gpmi patch set and tested on i.MX6Q, just found another =
issue in gpmi driver.
The patch was sent, refer to https://patchwork.ozlabs.org/patch/609755/


Acked-by: Han Xu <han.xu-3arQi8VN3Tc@public.gmane.org>
Tested-by: Han Xu <han.xu-3arQi8VN3Tc@public.gmane.org>
--
2.5.0

--=20
You received this message because you are subscribed to the Google Groups "=
linux-sunxi" group.
To unsubscribe from this group and stop receiving emails from it, send an e=
mail to linux-sunxi+unsubscribe-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
For more options, visit https://groups.google.com/d/optout.

--_000_DB5PR0401MB1845A6EE26FD2734CDBBE20F97950DB5PR0401MB1845_
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<html>
<head>
<meta http-equiv=3D"Content-Type" content=3D"text/html; charset=3Diso-8859-=
1">
<style type=3D"text/css" style=3D"display:none;"><!-- P {margin-top:0;margi=
n-bottom:0;} --></style>
</head>
<body dir=3D"ltr">
<div id=3D"divtagdefaultwrapper" style=3D"font-size:12pt;color:#000000;back=
ground-color:#FFFFFF;font-family:Calibri,Arial,Helvetica,sans-serif;">
<p><br>
</p>
<br>
<br>
<div style=3D"color: rgb(0, 0, 0);">
<div>
<hr tabindex=3D"-1" style=3D"display:inline-block; width:98%">
<div id=3D"x_divRplyFwdMsg" dir=3D"ltr"><font face=3D"Calibri, sans-serif" =
color=3D"#000000" style=3D"font-size:11pt"><b>From:</b> Boris Brezillon &lt=
;boris.brezillon-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org&gt;<br>
<b>Sent:</b> Wednesday, March 30, 2016 10:14 AM<br>
<b>To:</b> David Woodhouse; Brian Norris; linux-mtd-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org; Bo=
ris Brezillon; Richard Weinberger<br>
<b>Cc:</b> Daniel Mack; Haojian Zhuang; Robert Jarzmik; Kukjin Kim; Krzyszt=
of Kozlowski; linux-samsung-soc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; linux-arm-kernel-IAPFreCvJWMP3drIcvDWNA@public.gmane.org=
radead.org; Ralf Baechle; linux-mips-6z/3iImG2C8G8FEW9MqTrA@public.gmane.org; Nicolas Ferre; Jean-Ch=
ristophe Plagniol-Villard; Alexandre
 Belloni; Wenyou Yang; Josh Wu; Ezequiel Garcia; Maxime Ripard; Chen-Yu Tsa=
i; linux-sunxi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org; Stefan Agner; Kyungmin Park; Greg Kroah-Ha=
rtman; devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org; linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; punnaiah c=
houdary kalluri; Priit Laes; Kamal
 Dasu; bcm-kernel-feedback-list-dY08KVG/lbpWk0Htik3J/w@public.gmane.org; linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Ha=
rvey Hunt; Archit Taneja; b45815-KZfg59tc24xl57MIdRCFDg@public.gmane.org; Huang Shijie<br>
<b>Subject:</b> [PATCH v5 34/50] mtd: nand: gpmi: switch to mtd_ooblayout_o=
ps</font>
<div>&nbsp;</div>
</div>
</div>
<font size=3D"2"><span style=3D"font-size:10pt;">
<div class=3D"PlainText">Implementing the mtd_ooblayout_ops interface is th=
e new way of exposing<br>
ECC/OOB layout to MTD users.<br>
<br>
Signed-off-by: Boris Brezillon &lt;boris.brezillon-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org&gt;<b=
r>
---<br>
&nbsp;drivers/mtd/nand/gpmi-nand/gpmi-nand.c | 52 &#43;&#43;&#43;&#43;&#43;=
&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;=
&#43;&#43;&#43;&#43;&#43;&#43;--------<br>
&nbsp;1 file changed, 40 insertions(&#43;), 12 deletions(-)<br>
<br>
diff --git a/drivers/mtd/nand/gpmi-nand/gpmi-nand.c b/drivers/mtd/nand/gpmi=
-nand/gpmi-nand.c<br>
index 3a29b65..316b5ac 100644<br>
--- a/drivers/mtd/nand/gpmi-nand/gpmi-nand.c<br>
&#43;&#43;&#43; b/drivers/mtd/nand/gpmi-nand/gpmi-nand.c<br>
@@ -47,10 &#43;47,44 @@ static struct nand_bbt_descr gpmi_bbt_descr =3D {<b=
r>
&nbsp; * We may change the layout if we can get the ECC info from the datas=
heet,<br>
&nbsp; * else we will use all the (page &#43; OOB).<br>
&nbsp; */<br>
-static struct nand_ecclayout gpmi_hw_ecclayout =3D {<br>
-&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; .eccbytes =3D 0,<br>
-&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; .eccpos =3D { 0, },<br>
-&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; .oobfree =3D { {.offset =3D 0, .lengt=
h =3D 0} }<br>
&#43;static int gpmi_ooblayout_ecc(struct mtd_info *mtd, int section,<br>
&#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp; struct mtd_oob_region *oobregion)<br>
&#43;{<br>
&#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; struct nand_chip *chip =3D mtd_to=
_nand(mtd);<br>
&#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; struct gpmi_nand_data *this =3D n=
and_get_controller_data(chip);<br>
&#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; struct bch_geometry *geo =3D &amp=
;this-&gt;bch_geometry;<br>
&#43;<br>
&#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; if (section)<br>
&#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp; return -ERANGE;<br>
&#43;<br>
&#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; oobregion-&gt;offset =3D 0;<br>
&#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; oobregion-&gt;length =3D geo-&gt;=
page_size - mtd-&gt;writesize;<br>
&#43;<br>
&#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; return 0;<br>
&#43;}<br>
&#43;<br>
&#43;static int gpmi_ooblayout_free(struct mtd_info *mtd, int section,<br>
&#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp; struct mtd_oob_region *oobregion)<br>
&#43;{<br>
&#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; struct nand_chip *chip =3D mtd_to=
_nand(mtd);<br>
&#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; struct gpmi_nand_data *this =3D n=
and_get_controller_data(chip);<br>
&#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; struct bch_geometry *geo =3D &amp=
;this-&gt;bch_geometry;<br>
&#43;<br>
&#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; if (section)<br>
&#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp; return -ERANGE;<br>
&#43;<br>
&#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; /* The available oob size we have=
. */<br>
&#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; if (geo-&gt;page_size &lt; mtd-&g=
t;writesize &#43; mtd-&gt;oobsize) {<br>
&#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp; oobregion-&gt;offset =3D geo-&gt;page_size - mtd-&gt;writesi=
ze;<br>
&#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp; oobregion-&gt;length =3D mtd-&gt;oobsize - oobregion-&gt;off=
set;<br>
&#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; }<br>
&#43;<br>
&#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; return 0;<br>
&#43;}<br>
&#43;<br>
&#43;static const struct mtd_ooblayout_ops gpmi_ooblayout_ops =3D {<br>
&#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; .ecc =3D gpmi_ooblayout_ecc,<br>
&#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; .free =3D gpmi_ooblayout_free,<br=
>
&nbsp;};<br>
&nbsp;<br>
&nbsp;static const struct gpmi_devdata gpmi_devdata_imx23 =3D {<br>
@@ -141,7 &#43;175,6 @@ static int set_geometry_by_ecc_info(struct gpmi_nan=
d_data *this)<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; struct bch_geometry *geo =
=3D &amp;this-&gt;bch_geometry;<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; struct nand_chip *chip =3D=
 &amp;this-&gt;nand;<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; struct mtd_info *mtd =3D n=
and_to_mtd(chip);<br>
-&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; struct nand_oobfree *of =3D gpmi_hw_e=
cclayout.oobfree;<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; unsigned int block_mark_bi=
t_offset;<br>
&nbsp;<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; if (!(chip-&gt;ecc_strengt=
h_ds &gt; 0 &amp;&amp; chip-&gt;ecc_step_ds &gt; 0))<br>
@@ -229,12 &#43;262,6 @@ static int set_geometry_by_ecc_info(struct gpmi_na=
nd_data *this)<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; geo-&gt;page_size =3D mtd-=
&gt;writesize &#43; geo-&gt;metadata_size &#43;<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp; (geo-&gt;gf_len * geo-&gt;ecc_strength * geo-&gt;ecc_=
chunk_count) / 8;<br>
&nbsp;<br>
-&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; /* The available oob size we have. */=
<br>
-&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; if (geo-&gt;page_size &lt; mtd-&gt;wr=
itesize &#43; mtd-&gt;oobsize) {<br>
-&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp; of-&gt;offset =3D geo-&gt;page_size - mtd-&gt;writesize;<br>
-&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp; of-&gt;length =3D mtd-&gt;oobsize - of-&gt;offset;<br>
-&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; }<br>
-<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; geo-&gt;payload_size =3D m=
td-&gt;writesize;<br>
&nbsp;<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; geo-&gt;auxiliary_status_o=
ffset =3D ALIGN(geo-&gt;metadata_size, 4);<br>
@@ -1841,6 &#43;1868,7 @@ static void gpmi_nand_exit(struct gpmi_nand_data =
*this)<br>
&nbsp;static int gpmi_init_last(struct gpmi_nand_data *this)<br>
&nbsp;{<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; struct nand_chip *chip =3D=
 &amp;this-&gt;nand;<br>
&#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; struct mtd_info *mtd =3D nand_to_=
mtd(chip);<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; struct nand_ecc_ctrl *ecc =
=3D &amp;chip-&gt;ecc;<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; struct bch_geometry *bch_g=
eo =3D &amp;this-&gt;bch_geometry;<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; int ret;<br>
@@ -1862,7 &#43;1890,7 @@ static int gpmi_init_last(struct gpmi_nand_data *=
this)<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ecc-&gt;mode&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp; =3D NAND_ECC_HW;<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ecc-&gt;size&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp; =3D bch_geo-&gt;ecc_chunk_size;<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ecc-&gt;strength&nbsp;&nbs=
p; =3D bch_geo-&gt;ecc_strength;<br>
-&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ecc-&gt;layout&nbsp;&nbsp;&nbsp;&nbsp=
; =3D &amp;gpmi_hw_ecclayout;<br>
&#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; mtd_set_ooblayout(mtd, &amp;gpmi_=
ooblayout_ops);<br>
&nbsp;<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; /*<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; * We only enable the=
 subpage read when:</div>
<div class=3D"PlainText"><br>
</div>
<div class=3D"PlainText">I am fine with all gpmi patch set and tested on i.=
MX6Q, just found another issue in&nbsp;gpmi driver.&nbsp;</div>
<div class=3D"PlainText">The patch was sent, refer to&nbsp;<a href=3D"https=
://patchwork.ozlabs.org/patch/609755/" id=3D"LPlnk166420" title=3D"https://=
patchwork.ozlabs.org/patch/609755/
Ctrl&#43;Click or tap to follow the link" style=3D"font-size: 10pt;">https:=
//patchwork.ozlabs.org/patch/609755/</a></div>
<div class=3D"PlainText"><br>
</div>
<div class=3D"PlainText"><br>
</div>
<div class=3D"PlainText">Acked-by: Han Xu&nbsp;&lt;han.xu-3arQi8VN3Tc@public.gmane.org&gt;</div>
<div class=3D"PlainText"><span style=3D"font-family: Calibri, Arial, Helvet=
ica, sans-serif; font-size: 13.3333px;">Tested-by: Han Xu</span><span style=
=3D"font-family: Calibri, Arial, Helvetica, sans-serif; font-size: 13.3333p=
x;">&nbsp;&lt;han.xu-3arQi8VN3Tc@public.gmane.org</span><span style=3D"font-family: Calibri, Ari=
al, Helvetica, sans-serif; font-size: 13.3333px;">&gt;</span><br>
-- <br>
2.5.0<br>
<br>
</div>
</span></font></div>
</div>
</body>
</html>

<p></p>

-- <br />
You received this message because you are subscribed to the Google Groups &=
quot;linux-sunxi&quot; group.<br />
To unsubscribe from this group and stop receiving emails from it, send an e=
mail to <a href=3D"mailto:linux-sunxi+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org">linux-s=
unxi+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org</a>.<br />
For more options, visit <a href=3D"https://groups.google.com/d/optout">http=
s://groups.google.com/d/optout</a>.<br />

--_000_DB5PR0401MB1845A6EE26FD2734CDBBE20F97950DB5PR0401MB1845_--
