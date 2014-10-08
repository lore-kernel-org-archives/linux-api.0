From: Steven Newbury <steve-MOftb3VP07atmTQ+vhA3Yw@public.gmane.org>
Subject: Re: [PATCH v9 1/3] drm: rockchip: Add basic drm driver
Date: Wed, 08 Oct 2014 14:31:25 +0100
Message-ID: <1412775085.2797.10.camel@snewbury.org.uk>
References: <1412081870-27535-1-git-send-email-mark.yao@rock-chips.com>
		 <1412082181-27703-1-git-send-email-mark.yao@rock-chips.com>
		 <542AB0B2.6000207@samsung.com> <54336474.1010503@rock-chips.com>
		 <54338484.5070809@samsung.com> <1412720776.2797.8.camel@snewbury.org.uk>
	 <543490A8.7030807@rock-chips.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-X3UhQ3efMecwITDeaM/h"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <543490A8.7030807-TNX95d0MmH7DzftRWevZcw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mark yao <mark.yao-TNX95d0MmH7DzftRWevZcw@public.gmane.org>
Cc: Andrzej Hajda <a.hajda-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, heiko-4mtYJXux2i+zQB+pC5nmwQ@public.gmane.org, Boris BREZILLON <boris.brezillon-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>, David Airlie <airlied-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Rob Clark <robdclark-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Daniel Vetter <daniel-/w4YWyX8dFk@public.gmane.org>, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Ian Campbell <ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org>, Kumar Gala <galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Randy Dunlap <rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Grant Likely <grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Rom Lemarchand <romlem-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kever.yang-TNX95d0MmH7DzftRWevZcw@public.gmane.org, dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, dianders-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, xjq-TNX95d0MmH7DzftRWevZcw@public.gmane.org, zyw-TNX95d0MmH7DzftRWevZcw@public.gmane.org, cym-TNX95d0MmH7DzftRWevZcw@public.gmane.org, linux-rockchip-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, kfx-TNX95d0MmH7DzftRWevZcw@public.gmane.org, wxt-TNX95d0MmH7DzftRWevZcw@public.gmane.org, huangtao-TNX95d0MmH7DzftRWevZcw@public.gmane.org, devicetree@v
List-Id: linux-api@vger.kernel.org


--=-X3UhQ3efMecwITDeaM/h
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2014-10-08 at 09:17 +0800, Mark yao wrote:
> Hi Steven
>      I'm glad to see you to discuss about rk29xx.
>=20
> On 2014=E5=B9=B410=E6=9C=8808=E6=97=A5 06:26, Steven Newbury wrote:
> > I've just been discussing how this relates to rk29xx on #etnaviv. =20
> > I
> > looked through the patch and it's good to see it's not limited to
> > supporting Mali GPUs.  I see no reason this wouldn't be compatible
> > with etna_viv for rk29xx (or future Rockchip designs with=20
> > alternative
> > GPUs) as long as the rest of the infrastructure to support rk29 is=20
> > in
> > place iommu (ARM SMMU?) driver, for example.
> Now the drm driver only test on rk3288, and future when we add
> compatible for rk29xx, we
> would consider to add a non-iommu path for it.
That's great! I'm working on trying to update the rk29 driver support.=20
 Getting it supported where possible with the new drivers would make=20
it much easier, hopefully such that simply creating a new dts file=20
would produce a working kernel for any useful hardware out there.

> > IMHO it's vital to keep a logical separation between the video=20
> > display
> > hardware and the graphics processor on SoCs.
> Sure, the graphics processor maybe change in different solutions,
> logical separation is that we
> try to keep.

--=-X3UhQ3efMecwITDeaM/h
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEABECAAYFAlQ1PLEACgkQGcb56gMuC63rJwCfRFIwyIj6FOSIqULpaJIrWWl9
MioAnj0lnUS5+25TZ24KHThJQOk68I8v
=FDMG
-----END PGP SIGNATURE-----

--=-X3UhQ3efMecwITDeaM/h--
