From: Steven Newbury <steve-MOftb3VP07atmTQ+vhA3Yw@public.gmane.org>
Subject: Re: [PATCH v9 1/3] drm: rockchip: Add basic drm driver
Date: Tue, 07 Oct 2014 23:26:16 +0100
Message-ID: <1412720776.2797.8.camel@snewbury.org.uk>
References: <1412081870-27535-1-git-send-email-mark.yao@rock-chips.com>
	 <1412082181-27703-1-git-send-email-mark.yao@rock-chips.com>
	 <542AB0B2.6000207@samsung.com> <54336474.1010503@rock-chips.com>
	 <54338484.5070809@samsung.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-3Ej4YuX3v57Rb2M1m87J"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <54338484.5070809-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrzej Hajda <a.hajda-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Cc: Mark yao <mark.yao-TNX95d0MmH7DzftRWevZcw@public.gmane.org>, heiko-4mtYJXux2i+zQB+pC5nmwQ@public.gmane.org, Boris BREZILLON <boris.brezillon-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>, David Airlie <airlied-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Rob Clark <robdclark-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Daniel Vetter <daniel-/w4YWyX8dFk@public.gmane.org>, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Ian Campbell <ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org>, Kumar Gala <galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Randy Dunlap <rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Grant Likely <grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Rom Lemarchand <romlem-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kever.yang-TNX95d0MmH7DzftRWevZcw@public.gmane.org, dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, dianders-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, xjq-TNX95d0MmH7DzftRWevZcw@public.gmane.org, zyw-TNX95d0MmH7DzftRWevZcw@public.gmane.org, cym-TNX95d0MmH7DzftRWevZcw@public.gmane.org, linux-rockchip-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, kfx-TNX95d0MmH7DzftRWevZcw@public.gmane.org, wxt-TNX95d0MmH7DzftRWevZcw@public.gmane.org, huangtao-TNX95d0MmH7DzftRWevZcw@public.gmane.org, devicetree@vg
List-Id: linux-api@vger.kernel.org


--=-3Ej4YuX3v57Rb2M1m87J
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I've just been discussing how this relates to rk29xx on #etnaviv.  I=20
looked through the patch and it's good to see it's not limited to=20
supporting Mali GPUs.  I see no reason this wouldn't be compatible=20
with etna_viv for rk29xx (or future Rockchip designs with alternative=20
GPUs) as long as the rest of the infrastructure to support rk29 is in=20
place iommu (ARM SMMU?) driver, for example.

IMHO it's vital to keep a logical separation between the video display=20
hardware and the graphics processor on SoCs.


--=-3Ej4YuX3v57Rb2M1m87J
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEABECAAYFAlQ0aIwACgkQGcb56gMuC61YdQCgroIqzaz6iZoEizQwqvTsmlZd
1SgAnjRCWI26AASReJl6LwPDw2BmKaIK
=WXIm
-----END PGP SIGNATURE-----

--=-3Ej4YuX3v57Rb2M1m87J--
