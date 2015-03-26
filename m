From: NeilBrown <neilb-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [PATCH 0/5] Enhancements to twl4030 phy to support better
 charging - V2
Date: Thu, 26 Mar 2015 11:16:13 +1100
Message-ID: <20150326111613.6f24f5f5@notabene.brown>
References: <20150322223307.21765.62974.stgit@notabene.brown>
	<551325B0.1090308@ti.com>
	<20150326082219.510ac598@notabene.brown>
	<55134BEE.7050406@ti.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/OIqd=Adl2q/mT1dx3hZxWZ="; protocol="application/pgp-signature"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <55134BEE.7050406-l0cyMroinI0@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kishon Vijay Abraham I <kishon-l0cyMroinI0@public.gmane.org>
Cc: NeilBrown <neil-+NVA1uvv1dVBDLzU/O5InQ@public.gmane.org>, Tony Lindgren <tony-4v6yS6AI5VpBDgjK7y7TUQ@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, GTA04 owners <gta04-owner-xXXSsgcRVICgSpxsJD1C4w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Pavel Machek <pavel-+ZI9xUNit7I@public.gmane.org>
List-Id: linux-api@vger.kernel.org

--Sig_/OIqd=Adl2q/mT1dx3hZxWZ=
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 26 Mar 2015 05:29:42 +0530 Kishon Vijay Abraham I <kishon-l0cyMroinI0@public.gmane.org>
wrote:

> Hi NeilBrown,
>=20
> On Thursday 26 March 2015 02:52 AM, NeilBrown wrote:
> > On Thu, 26 Mar 2015 02:46:32 +0530 Kishon Vijay Abraham I <kishon-Bv2c3lPp1Ag@public.gmane.org=
m>
> > wrote:
> >=20
> >> Hi,
> >>
> >> On Monday 23 March 2015 04:05 AM, NeilBrown wrote:
> >>> Hi Kishon,
> >>>  I wonder if you could queue the following for the next merge window.
> >>>  They allow the twl4030 phy to provide more information to the
> >>>  twl4030 battery charger.
> >>>  There are only minimal changes since the first version, particularly
> >>>  documentation has been improved.
> >>
> >> There are quite a few things in this series which use the USB PHY libr=
ary
> >> interface which is kindof deprecated. We should try and use the Generi=
c PHY
> >> library for all of them. It would also be better to add features to the
> >> PHY framework if the we can't achieve something with the existing PHY
> >> framework.
> >=20
> > Hi,
> >  are you able to more specific at all?  What is the "USB PHY library"?
> > Where exactly is the "PHY framework"?
>=20
> There is a USB PHY library that exists in drivers/usb/phy/phy.c and there=
 is
> a Generic PHY framework that is present in drivers/phy/phy-core.c. twl4030
> actually supports both the framework.
>=20
> In your patch whatever uses struct usb_phy uses the old USB PHY library a=
nd
> whatever uses struct phy uses the generic PHY framework. (Actually your p=
atch
> does not use the PHY framework at all). We want to deprecate using the US=
B PHY
> library and make everyone use the generic PHY framework. Adding features
> to a driver using the USB PHY library will make the transition to generic=
 PHY
> framework a bit more difficult.
>=20
> Now all the features that is supported in the USB PHY library may not be
> supported by the PHY framework. So we should start extending the PHY fram=
ework
> instead of using the USB PHY library.
>=20
> One think I noticed in your driver is using atomic notifier chain. IMO ex=
tcon
> framework should be used in twl4030 USB driver to notify the controller d=
river
> instead of using USB PHY notifier. For all other things we have to see if=
 it
> can be added in the PHY framework.

Thanks a lot - exactly what I wanted.
I agree about extcon - I'll be very happy to make that work properly for tw=
l.

I'll let you know when I have something for review.

Thanks,
NeilBrown

--Sig_/OIqd=Adl2q/mT1dx3hZxWZ=
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVRNPzTnsnt1WYoG5AQJSzxAAw3x3JpB1bI7HYk8GHJq1p/o4Ks50BX97
WETjzAbYLDr8kyf9IbZmdKyuPZ8A7qWrA1L7oP2P/5vaHpdsMndwl7L2tWWpCzhR
R5+bUwr54bo4hirvJG2LGjkwRokfHcRzdwpJXkkr+hNkXBkzGRpQYL638s1fewk/
jHnQJyJlKooMjxNjKpdQQeppUDsTrvPo/Gr2ZU5ll/b2wmv73TXQuRW1vcId5U19
/hVC70FV/zSeCxKf1EKPUsVyqRKZiBc5cD3LfUbLLXPfYnyTXUJHLmPsPJGYX41A
HGMG6p9TX8tUHUOszkFr6z9h+ge5K8sGwgc0KlYj1Z25zqmRvFCsP6ZJGHPN25Fo
xIHgfSIvlHFtvyMa8rvnOXul4RpTgZNbVEJcEQXof0pon5LfNQ2crEkymXZsY+cn
PLQ6Y2b2/caD2TjV0bNt/rWP5138nou2y+2il8mDRwDAA9f9kbCBYExTTKtywQSA
R8vSeV3spPwU7HajYPYT9iud8PTyxcL5/tYgayEPS8mWDJHvbL8eJGLmr2vkljFO
+r0a4w2yQHFYw1qr1A2IkqlwcY7CPUBXwqcnqEkmZbKkImxSEGmldRnb+LGf8pJd
1r3OqTlzuQg8Fs9VWiy9VsU4jU5t0POArtj8vw8WCK6nLocv9DIn8EL+v89IhYZB
5Bsdgl/4x3o=
=bnVz
-----END PGP SIGNATURE-----

--Sig_/OIqd=Adl2q/mT1dx3hZxWZ=--
