From: NeilBrown <neilb-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [PATCH 0/5] Enhancements to twl4030 phy to support better
 charging - V2
Date: Sat, 4 Apr 2015 11:28:16 +1100
Message-ID: <20150404112816.025d233b@notabene.brown>
References: <20150322223307.21765.62974.stgit@notabene.brown>
	<551325B0.1090308@ti.com>
	<20150326082219.510ac598@notabene.brown>
	<55134BEE.7050406@ti.com>
	<20150401154102.5f57ec1e@notabene.brown>
	<551E97CE.4000501@ti.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/8h=E08/kvIkLphM=9=.5yiV"; protocol="application/pgp-signature"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <551E97CE.4000501-l0cyMroinI0@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kishon Vijay Abraham I <kishon-l0cyMroinI0@public.gmane.org>
Cc: NeilBrown <neil-+NVA1uvv1dVBDLzU/O5InQ@public.gmane.org>, Tony Lindgren <tony-4v6yS6AI5VpBDgjK7y7TUQ@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, GTA04 owners <gta04-owner-xXXSsgcRVICgSpxsJD1C4w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Pavel Machek <pavel-+ZI9xUNit7I@public.gmane.org>, cw00.choi-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, myungjoo.ham-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org
List-Id: linux-api@vger.kernel.org

--Sig_/8h=E08/kvIkLphM=9=.5yiV
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 3 Apr 2015 19:08:22 +0530 Kishon Vijay Abraham I <kishon-l0cyMroinI0@public.gmane.org>
wrote:

> +Extcon MAINTAINERS
>=20
> Hi,
>=20
> On Wednesday 01 April 2015 10:11 AM, NeilBrown wrote:
> > On Thu, 26 Mar 2015 05:29:42 +0530 Kishon Vijay Abraham I <kishon-Bv2c3lPp1Ag@public.gmane.org=
m>
> > wrote:
> >
> >> Hi NeilBrown,
> >>
> >> On Thursday 26 March 2015 02:52 AM, NeilBrown wrote:
> >>> On Thu, 26 Mar 2015 02:46:32 +0530 Kishon Vijay Abraham I <kishon@ti.=
com>
> >>> wrote:
> >>>
> >>>> Hi,
> >>>>
> >>>> On Monday 23 March 2015 04:05 AM, NeilBrown wrote:
> >>>>> Hi Kishon,
> >>>>>   I wonder if you could queue the following for the next merge wind=
ow.
> >>>>>   They allow the twl4030 phy to provide more information to the
> >>>>>   twl4030 battery charger.
> >>>>>   There are only minimal changes since the first version, particula=
rly
> >>>>>   documentation has been improved.
> >>>>
> >>>> There are quite a few things in this series which use the USB PHY li=
brary
> >>>> interface which is kindof deprecated. We should try and use the Gene=
ric PHY
> >>>> library for all of them. It would also be better to add features to =
the
> >>>> PHY framework if the we can't achieve something with the existing PHY
> >>>> framework.
> >>>
> >>> Hi,
> >>>   are you able to more specific at all?  What is the "USB PHY library=
"?
> >>> Where exactly is the "PHY framework"?
> >>
> >> There is a USB PHY library that exists in drivers/usb/phy/phy.c and th=
ere is
> >> a Generic PHY framework that is present in drivers/phy/phy-core.c. twl=
4030
> >> actually supports both the framework.
> >>
> >> In your patch whatever uses struct usb_phy uses the old USB PHY librar=
y and
> >> whatever uses struct phy uses the generic PHY framework. (Actually you=
r patch
> >> does not use the PHY framework at all). We want to deprecate using the=
 USB PHY
> >> library and make everyone use the generic PHY framework. Adding featur=
es
> >> to a driver using the USB PHY library will make the transition to gene=
ric PHY
> >> framework a bit more difficult.
> >>
> >> Now all the features that is supported in the USB PHY library may not =
be
> >> supported by the PHY framework. So we should start extending the PHY f=
ramework
> >> instead of using the USB PHY library.
> >>
> >> One think I noticed in your driver is using atomic notifier chain. IMO=
 extcon
> >> framework should be used in twl4030 USB driver to notify the controlle=
r driver
> >> instead of using USB PHY notifier. For all other things we have to see=
 if it
> >> can be added in the PHY framework.
> >
> > I've had a look at the code with these issues in mind, and there is one=
 issue
> > that I'm not sure about.
> >
> > In phy-twl4030-usb, the usb_phy is used to hold a reference to the
> > 'struct otg', and for passing cable state changes to the notifier.
>=20
> right now we directly call omap_musb_mailbox no? we don't use notifiers r=
ight?

Correct, and omap_musb_set_mailbox uses the notifier chain.=20
phy-twl4030-usb does=20
	ATOMIC_INIT_NOTIFIER_HEAD(&twl->phy.notifier);
That is the only place the current phy code interacts with the notifier cha=
in.


> >
> > The former probably has to stay until musb can keep a reference to the =
otg,
> > separate form the usb_phy.  The latter can be changed to use extcon - to
> > some extent.  I actually have patches to do that from a couple of years=
 back,
> > but I never proceeded with them.
> >
> > The problem is that one thing that needs to be communicated to the char=
ger is
> > the max current that was negotiated by a "Standard Downstream Port".
> > This could be 500mA from a powered hum, or much less from an unpowered =
hub.
> > (Currently the usb gadget code does negotiated between different
> > possibilities, but it could and hopefully will one day).
> >
> > With the notifier chain there is an easy way to communicate the allowed
> > current once it is negotiated. e.g. ab8500_usb_set_power() does this.
> >
> > 'struct phy' has no equivalent of the 'set_power' callback  which 'stru=
ct
> > usb_phy' provides, and extcon has no mechanism (that I can see) for
> > communicating a number - just binary cable states.
>=20
> Chanwoo Choi, Can this be modified so that we can communicate numbers lik=
e in
> the case of EXTCON_CHARGE_DOWNSTREAM?
> >
> > Presumably a 'set_power' method could be added to 'struct phy' so the
> > usb-core can communicate the number to the phy, but it is not clear to =
me how
> > the 'phy' can communicate it to the charger.
>=20
> Should the PHY be involved in all this? We can make the gadget driver
> directly communicate the value to the charger no?
> > The 'phy' could provide an API to request the current negotiated max cu=
rrent,
> > but there still needs to be a way to let the charger know that this has
> > changed.
> > That could in theory be done via extcon, by having a secondary
> > 'USB_connected' cable type, but it isn't really a cable type and preten=
ding
> > that it is seems wrong.
>=20
> I think EXTCON_CHARGE_DOWNSTREAM was created for that purpose. Chanwoo?
>=20

EXTCON_CHARGE_DOWNSTREAM is something quite different.

There are roughly three ways that the USB gadget can determine what sort of
thing has been plugged in to it and what current it can draw.

 - it can look at the resistance between the ID pin and GROUND.  This is a
   physical property of the cable and it makes a lot of sense of EXTCON
   to report different cables based on different resistances.

 - it can look at the voltage provided on different pins.  If it detects a
   certain voltage on D- when it asserts a voltage on D+, it can know
   that it is a Charging Downstream Port (EXTCON_CHARGE_DOWNSTREAM).  This
   might be a property of the cable (shorting D- to D+ can achieve this) or
   might be a property of the attached device.  It makes some sense for
   EXTCON to report cable type based on this sort of information.

 - it can wait for the connected host to initiate a USB session and select a
   particular profile.  That profile will include a "MaxPower" field.  When
   the host selects that profile, the gadget knows it is allowed to draw th=
at
   much power ("current" really, measured in mA).

So EXTCON_CHARGE_DOWNSTREAM fits into the second category.  My question is
about the third category.
I need this "MaxPower" number to be communicated from the USB core to the
charger driver, presumably via the "phy" driver.

With "usb_phy", there is a ->set_power() callback to communicate from
usb-core to phy, and a notifier chain to communicate from phy to charger.
With "phy" there is nothing.

extcon _could_ be used to communicate the MaxPower, but I'm not sure it mak=
es
sense.  It is a property of the power available on the cable, not a property
of the cable itself, or something that can be deduced from the properties of
the cable.

I guess I could get musb_gadget_vbus_draw(), or usb_phy_set_power(), to call
the notifier chain directly.  But if usb_phy is being deprecated, that isn't
a long-term solution.

Thanks,
NeilBrown


--Sig_/8h=E08/kvIkLphM=9=.5yiV
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVR8wIDnsnt1WYoG5AQKe+w//UjqwY8ocbTuR1Fa5jNI8JasS81vDCi+s
h9/gskGZ5HckdMUaRq7vD8FubUpBIKRevOHAcxwh8KiTq/jCt5XCqnClv02M8P+s
6CbYfmpxTmAXY80H8JnBglRPJkyBaEuhwjIuY0JyxR/js+RAhLgZa9ELKMXfx7+N
JVVLuZ7n4FeQ7TX7wbvFR7qt+/xf2/uCIjIL45d6iqS3Z5SkOqZEA8RHj2L3pY00
hunIMVYY3v2J+2ZsrmqDGurc8d98jWOm6OraUtYXyByH6ZF1tG3EE0Xa78su9L7p
BSklAWXL4heB7+Os9xlSEzkuqIdFmq/oomys8/AAngEFHcGenWSxrnq6xLIDTEfh
s6e9zzxCaiTWhVlp4U7uPWbmypwR9IHSFSEJhR0J4W97VNKxDT6TrTjXAK5lFVCI
seQgIsqzU1TWi/Sm4spZ8yXgjzmViQmuvOITbIHJDYu8vYHHb0/6HTW21S03l1ox
GFWBr1xWQkEtXNU9U2A77REkFw92WONDaVPp1tm9kHIhzMl5K1FFKyksFQQwnAR9
QLTO1H/NU/+Dnlh7zZttAJwW6rCiiT8z3PwMMEksxqRfyNGNr9H9/2Zgjenoaom3
qlMbpxk4xq/CrgCqN7kEL9Z75W3ulaCV3C9tBv2+OC3vIDCS/IX8zrUiR7pJ1Eyg
ozK8RhXtSi8=
=WM1X
-----END PGP SIGNATURE-----

--Sig_/8h=E08/kvIkLphM=9=.5yiV--
