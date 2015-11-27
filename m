From: Tomi Valkeinen <tomi.valkeinen@ti.com>
Subject: Re: [RFC PATCH 1/2] drm: add support for for clk and de polarity
Date: Fri, 27 Nov 2015 09:37:50 +0200
Message-ID: <5658084E.7040007@ti.com>
References: <55A67FDB.8010602@gmx.at> <55A6813A.8090706@gmx.at>
 <1448472141.3390.17.camel@pengutronix.de> <56571543.20701@gmx.at>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature";
	boundary="2L1n6QkDqsr0FlKjWKS2ojDVTnw8acTR1"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <56571543.20701@gmx.at>
Sender: linux-kernel-owner@vger.kernel.org
To: Manfred Schlaegl <manfred.schlaegl@gmx.at>, Philipp Zabel <p.zabel@pengutronix.de>
Cc: David Airlie <airlied@linux.ie>, Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>, dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Manfred Schlaegl <manfred.schlaegl@ginzinger.com>, Steve Longerbeam <slongerbeam@gmail.com>, Deepak Das <deepak_das@mentor.com>, Jiada Wang <jiada_wang@mentor.com>, linux-fbdev@vger.kernel.org, Laurent Pinchart <laurent.pinchart@ideasonboard.com>
List-Id: linux-api@vger.kernel.org

--2L1n6QkDqsr0FlKjWKS2ojDVTnw8acTR1
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable



On 26/11/15 16:20, Manfred Schlaegl wrote:
> On 2015-11-25 18:22, Philipp Zabel wrote:
>> Am Mittwoch, den 15.07.2015, 17:50 +0200 schrieb Manfred Schlaegl:
>>> To get full support for parallel and LVDS displays with drm:
>>> Add representation for clock and data enable polarity in drm_display_=
mode
>>> flags (similar to HSYNC/VSYNC polarity) and update conversion functio=
ns
>>> from/to videomode accordingly.
>>>
>>> This is especially important for embedded devices where parallel(RGB)=
 and
>>> LVDS displays are still widely used and drm already plays an importan=
t
>>> role.
>>>
>>> Tested on Freescale i.MX53(parallel) and i.MX6(LVDS).
>>>
>>> Background:
>>> There was the ability to set polarity of clock and data enable signal=
s
>>> in devicetree(display-timing), struct display_timing and struct video=
mode,
>>> but there was no representation for this in struct drm_display_mode.
>>> Example on Freescale i.MX53/i.MX6 SoC's:
>>>  * A parallel display using different clock polarity is set up using
>>>    display-timing in devicetree
>>>  * ipuv3 parallel outputs clock with wrong polarity
>>>
>>> Signed-off-by: Manfred Schlaegl <manfred.schlaegl@gmx.at>
>>
>> Any comments on whether data enable and pixel clock polarity flags can=

>> be added to the visible DRM_MODE_FLAGs, and if not, where else this
>> information should be kept? struct drm_display_info?
>>
>> This patch and the following IPUv3 patch are useful and necessary for
>> quite some panels connected to i.MX SoCs, but adding DRM_MODE_FLAGs is=

>> somewhat out of my jurisdiction.
>>
>> best regards
>> Philipp
>>
>=20
> Good to see that this discussion is triggered.

I seem to have missed this one. This is important for omapdrm also.
We've had similar patch in TI's linux for a while, but I have never had
time to start upstreaming it.

Two comments:

The "pixclock polarity" could be explained a bit, as it's not really
about polarity. This was discussed when the display-timings stuff was
worked on, and display-timings.txt explains what the "pixelclk-active"
property means.

So here I think you could maybe have a comment pointing to
display-timings.txt, or perhaps a short comment about what the flag is.
Or if you come up with a great name for the define, that's good too =3D).=


The other comment is not about this patch as such, but similar flags
that OMAP has, and possibly some other platforms too:

1) sync signals driven on rising or falling edge of pixel clock
2) hsync and vsync happen at the same time or hsync happens first,
followed by vsync

Any other platforms have similar features?

 Tomi


--2L1n6QkDqsr0FlKjWKS2ojDVTnw8acTR1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWWAhOAAoJEPo9qoy8lh71IfwP/02Hnhwv2Q0w0pgyrEGz06kM
5XfjrDXpEiJ7xEjiYGgzFxbw2fOOkv5Cm6HG8+uGApHQYgHtFIW+TjAO5o67XmAC
tRPEgh9wyKJleIsxsBtpvXNfmzlZcu945Vj1UovM804efqzir1Ah33M0ea2nldt/
cXkFNFIqQEm++9jqE/kmrRknxk0F6yptzupaFvj+it1oeS4BnvXCP/QrfY6GhXAT
10cnFv7p9iMrhDXo7DJNkHPCnn1x3YbodlZ4SXsLg26u3wMcdDTv+QUmJTQIdqF4
GuzlrrGG5KMy5t+1xqHT9M1+ZIZVt4gxcEH6/ErKAlsf3BIiW/eHsiLPfqdDxkfR
7ejCyTn84gtD3TiveMBhlplMEt0Ho8qRweIBb3/SQrizMKcM7oGppMwsk8Q998oA
H35JNr85ZM2L/09os/fz4XskiOCw99Ih6vN0ha4AUR1UJDdFVGFkNJXO09VVioCu
doE7t07HYlF2+t+QB9k5AzzM7cdXgg+3EMwMikx+042NMvcY9wH/KoJKZerjoB9W
2WMTlo0BT9Z2e+A9cHmH62T73Uy1rArc83OqRN1QK9GOV1tk2iW5l6PCb1IHC/XI
ir4LR6eXN4NyWk+epv09lnVSiASwKNiBYkI1zf6pa3E0w5xyQMjZFY3XQiEM286K
/p/rEqKNIFxj2Z1+Z7eM
=tIMc
-----END PGP SIGNATURE-----

--2L1n6QkDqsr0FlKjWKS2ojDVTnw8acTR1--
