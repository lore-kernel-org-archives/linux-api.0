From: Han Xu <han.xu-3arQi8VN3Tc@public.gmane.org>
Subject: Re: [PATCH v5 34/50] mtd: nand: gpmi: switch to mtd_ooblayout_ops
Date: Tue, 12 Apr 2016 22:41:17 +0000
Message-ID: <DB5PR0401MB1845C0E3F0CD67BD2A32DD9497950@DB5PR0401MB1845.eurprd04.prod.outlook.com>
References: <1459354505-32551-1-git-send-email-boris.brezillon@free-electrons.com>
	<1459354505-32551-35-git-send-email-boris.brezillon@free-electrons.com>
	<DB5PR0401MB1845A6EE26FD2734CDBBE20F97950@DB5PR0401MB1845.eurprd04.prod.outlook.com>,<20160413003146.4deb6017@bbrezillon>
Reply-To: han.xu-3arQi8VN3Tc@public.gmane.org
Mime-Version: 1.0
Content-Type: multipart/alternative;
	boundary="_000_DB5PR0401MB1845C0E3F0CD67BD2A32DD9497950DB5PR0401MB1845_"
Return-path: <linux-sunxi+bncBCBMF4HBYUEBBE7TWW4AKGQEUHXG7RY-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
Sender: linux-sunxi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
In-Reply-To: <20160413003146.4deb6017@bbrezillon>
Content-Language: en-US
List-Post: <https://groups.google.com/group/linux-sunxi/post>, <mailto:linux-sunxi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <https://groups.google.com/support/>, <mailto:linux-sunxi+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Archive: <https://groups.google.com/group/linux-sunxi
List-Subscribe: <https://groups.google.com/group/linux-sunxi/subscribe>, <mailto:linux-sunxi+subscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <mailto:googlegroups-manage+1076902468213+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>,
 <https://groups.google.com/group/linux-sunxi/subscribe>
To: Boris Brezillon <boris.brezillon-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>
Cc: David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Brian Norris <computersforpeace-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-mtd-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-mtd-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, Daniel
 Mack <daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org>, Haojian Zhuang <haojian.zhuang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Robert
 Jarzmik <robert.jarzmik-GANU6spQydw@public.gmane.org>, Kukjin Kim <kgene-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Krzysztof
 Kozlowski <k.kozlowski-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, "linux-samsung-soc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-samsung-soc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, Ralf Baechle <ralf-6z/3iImG2C8G8FEW9MqTrA@public.gmane.org>, "linux-mips-6z/3iImG2C8G8FEW9MqTrA@public.gmane.org" <linux-mips-6z/3iImG2C8G8FEW9MqTrA@public.gmane.org>, Nicolas Ferre <nicolas.ferre-AIFe0yeh4nAAvxtiuMwx3w@public.gmane.org>, Jean-Christophe Plagniol-Villard <plagnioj-sclMFOaUSTBWk0Htik3J/w@public.gmane.org>, Alexandre Belloni <alexandre.belloni-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>, Wenyou Yang <wenyou.yang-AIFe0yeh4nAAvxtiuMwx3w@public.gmane.org>, Josh Wu <rainyfeeling-1ViLX0X+lBJBDgjK7y7TUQ@public.gmane.org>, Ezequiel Garcia <ezequ>
List-Id: linux-api@vger.kernel.org

--_000_DB5PR0401MB1845C0E3F0CD67BD2A32DD9497950DB5PR0401MB1845_
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable




________________________________
From: Boris Brezillon <boris.brezillon-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>
Sent: Tuesday, April 12, 2016 4:31 PM
To: Han Xu
Cc: David Woodhouse; Brian Norris; linux-mtd-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org; Richard W=
einberger; Daniel Mack; Haojian Zhuang; Robert Jarzmik; Kukjin Kim; Krzyszt=
of Kozlowski; linux-samsung-soc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; linux-arm-kernel-IAPFreCvJWMP3drIcvDWNA@public.gmane.org=
radead.org; Ralf Baechle; linux-mips-6z/3iImG2C8G8FEW9MqTrA@public.gmane.org; Nicolas Ferre; Jean-Ch=
ristophe Plagniol-Villard; Alexandre Belloni; Wenyou Yang; Josh Wu; Ezequie=
l Garcia; Maxime Ripard; Chen-Yu Tsai; linux-sunxi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org; Stefan=
 Agner; Kyungmin Park; Greg Kroah-Hartman; devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org; linu=
x-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; punnaiah choudary kalluri; Priit Laes; Kamal Dasu=
; bcm-kernel-feedback-list-dY08KVG/lbpWk0Htik3J/w@public.gmane.org; linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Harvey =
Hunt; Archit Taneja; b45815-KZfg59tc24xl57MIdRCFDg@public.gmane.org; Huang Shijie
Subject: Re: [PATCH v5 34/50] mtd: nand: gpmi: switch to mtd_ooblayout_ops

On Tue, 12 Apr 2016 22:27:58 +0000
Han Xu <han.xu-3arQi8VN3Tc@public.gmane.org> wrote:

>
> I am fine with all gpmi patch set and tested on i.MX6Q, just found anothe=
r issue in gpmi driver.
> The patch was sent, refer to https://patchwork.ozlabs.org/patch/609755/

Oh, was it related to the changes introduced by this series?

No, previous code used all page space so I couldn't test your change, I cha=
nged the code to get
correct free oob space.

>
>
> Acked-by: Han Xu <han.xu-3arQi8VN3Tc@public.gmane.org>
> Tested-by: Han Xu <han.xu-3arQi8VN3Tc@public.gmane.org>
> --
> 2.5.0
>



--
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com

--=20
You received this message because you are subscribed to the Google Groups "=
linux-sunxi" group.
To unsubscribe from this group and stop receiving emails from it, send an e=
mail to linux-sunxi+unsubscribe-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
For more options, visit https://groups.google.com/d/optout.

--_000_DB5PR0401MB1845C0E3F0CD67BD2A32DD9497950DB5PR0401MB1845_
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
<b>Sent:</b> Tuesday, April 12, 2016 4:31 PM<br>
<b>To:</b> Han Xu<br>
<b>Cc:</b> David Woodhouse; Brian Norris; linux-mtd-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org; Ri=
chard Weinberger; Daniel Mack; Haojian Zhuang; Robert Jarzmik; Kukjin Kim; =
Krzysztof Kozlowski; linux-samsung-soc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; linux-arm-kernel@li=
sts.infradead.org; Ralf Baechle;
 linux-mips-6z/3iImG2C8G8FEW9MqTrA@public.gmane.org; Nicolas Ferre; Jean-Christophe Plagniol-Villard=
; Alexandre Belloni; Wenyou Yang; Josh Wu; Ezequiel Garcia; Maxime Ripard; =
Chen-Yu Tsai; linux-sunxi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org; Stefan Agner; Kyungmin Park; Gr=
eg Kroah-Hartman; devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org;
 linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; punnaiah choudary kalluri; Priit Laes; Kamal=
 Dasu; bcm-kernel-feedback-list-dY08KVG/lbpWk0Htik3J/w@public.gmane.org; linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Ha=
rvey Hunt; Archit Taneja; b45815-KZfg59tc24xl57MIdRCFDg@public.gmane.org; Huang Shijie<br>
<b>Subject:</b> Re: [PATCH v5 34/50] mtd: nand: gpmi: switch to mtd_ooblayo=
ut_ops</font>
<div>&nbsp;</div>
</div>
</div>
<font size=3D"2"><span style=3D"font-size:10pt;">
<div class=3D"PlainText">On Tue, 12 Apr 2016 22:27:58 &#43;0000<br>
Han Xu &lt;han.xu-3arQi8VN3Tc@public.gmane.org&gt; wrote:<br>
<br>
&gt; <br>
&gt; I am fine with all gpmi patch set and tested on i.MX6Q, just found ano=
ther issue in gpmi driver.<br>
&gt; The patch was sent, refer to <a href=3D"https://patchwork.ozlabs.org/p=
atch/609755/" id=3D"LPlnk157403">
https://patchwork.ozlabs.org/patch/609755/</a><br>
<br>
Oh, was it related to the changes introduced by this series?<br>
<br>
No, previous code used all page space so I couldn't test your change,&nbsp;=
I changed the code to get</div>
<div class=3D"PlainText">correct free oob&nbsp;space.</div>
<div class=3D"PlainText"><br>
&gt; <br>
&gt; <br>
&gt; Acked-by: Han Xu &lt;han.xu-3arQi8VN3Tc@public.gmane.org&gt;<br>
&gt; Tested-by: Han Xu &lt;han.xu-3arQi8VN3Tc@public.gmane.org&gt;<br>
&gt; --<br>
&gt; 2.5.0<br>
&gt; <br>
<br>
<br>
<br>
-- <br>
Boris Brezillon, Free Electrons<br>
Embedded Linux and Kernel engineering<br>
<a href=3D"http://free-electrons.com">http://free-electrons.com</a><br>
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

--_000_DB5PR0401MB1845C0E3F0CD67BD2A32DD9497950DB5PR0401MB1845_--
