From: Krzysztof Kozlowski <k.kozlowski-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [RESEND PATCH v3 1/6] charger: max14577: Add support for MAX77836
 charger
Date: Wed, 27 Aug 2014 16:01:29 +0200
Message-ID: <1409148089.25748.5.camel@AMDC1943>
References: <1409146282-25075-1-git-send-email-k.kozlowski@samsung.com>
 <1409146282-25075-2-git-send-email-k.kozlowski@samsung.com>
 <20140827135218.GG6364@lee--X1>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-reply-to: <20140827135218.GG6364@lee--X1>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Lee Jones <lee.jones-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Sebastian Reichel <sre-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Dmitry Eremin-Solenikov <dbaryshkov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-pm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Samuel Ortiz <sameo-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Liam Girdwood <lgirdwood-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Mark Brown <broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Ian Campbell <ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org>, Kumar Gala <galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Kyungmin Park <kyungmin.park-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, Marek Szyprowski <m.szyprowski-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, Bartlomiej Zolnierkiewicz <b.zolnierkie-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, Anton Vorontsov <anton-9xeibp6oKSgdnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On =C5=9Bro, 2014-08-27 at 14:52 +0100, Lee Jones wrote:
> On Wed, 27 Aug 2014, Krzysztof Kozlowski wrote:
>=20
> > Add support for MAX77836 charger to the max14577 driver. The MAX778=
36
> > charger is almost the same as 14577 model except:
> >  - No dead-battery detection;
> >  - Support for special charger (like in MAX77693);
> >  - Support for DX over-voltage protection (like in MAX77693);
> >  - Lower values of charging current (two times lower current for
> >    slow/fast charge, much lower EOC current);
> >  - Slightly different values in ChgTyp field of STATUS2 register. O=
n
> >    MAX14577 0x6 is reserved and 0x7 dead battery. On the MAX77836 t=
he
> >    0x6 means special charger and 0x7 is reserved. Regardless of the=
se
> >    differences the driver maps them to one enum max14577_muic_charg=
er_type.
> >=20
> > Signed-off-by: Krzysztof Kozlowski <k.kozlowski-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
> > Cc: Kyungmin Park <kyungmin.park-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
> > Cc: Anton Vorontsov <anton-9xeibp6oKSgdnm+yROfE0A@public.gmane.org>
> > Cc: Dmitry Eremin-Solenikov <dbaryshkov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> > Cc: David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
> > Acked-by: Lee Jones <lee.jones-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> > ---
> >  drivers/power/Kconfig                |  4 +-
> >  drivers/power/max14577_charger.c     | 77 ++++++++++++++++++++++++=
+++++-------
> >  include/linux/mfd/max14577-private.h | 54 ++++++++++++++++++------=
-
>=20
> Not quite so important here, but better to break these out too.  We
> can arrange ourselves to that the set can go in together.  Just make
> sure it's bisectable.

Are you sure? This will result in a patch which adds some
code/symbols/defines used only by next (future) patch. Independent appl=
y
of such patch still won't make any sense because there won't be any use=
r
of this code.


Best regards,
Krzysztof
