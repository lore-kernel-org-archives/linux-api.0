From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 0/5] Enhancements to twl4030 phy to support better
 charging - V2
Date: Wed, 1 Apr 2015 15:41:02 +1100
Message-ID: <20150401154102.5f57ec1e@notabene.brown>
References: <20150322223307.21765.62974.stgit@notabene.brown>
 <551325B0.1090308@ti.com>
 <20150326082219.510ac598@notabene.brown>
 <55134BEE.7050406@ti.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/DGq.As5MUZf_apZek+CmM_="; protocol="application/pgp-signature"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <55134BEE.7050406@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: NeilBrown <neil@brown.name>, Tony Lindgren <tony@atomide.com>, linux-api@vger.kernel.org, GTA04 owners <gta04-owner@goldelico.com>, linux-kernel@vger.kernel.org, Pavel Machek <pavel@ucw.cz>
List-Id: linux-api@vger.kernel.org

--Sig_/DGq.As5MUZf_apZek+CmM_=
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 26 Mar 2015 05:29:42 +0530 Kishon Vijay Abraham I <kishon@ti.com>
wrote:

> Hi NeilBrown,
>=20
> On Thursday 26 March 2015 02:52 AM, NeilBrown wrote:
> > On Thu, 26 Mar 2015 02:46:32 +0530 Kishon Vijay Abraham I <kishon@ti.co=
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

I've had a look at the code with these issues in mind, and there is one iss=
ue
that I'm not sure about.

In phy-twl4030-usb, the usb_phy is used to hold a reference to the
'struct otg', and for passing cable state changes to the notifier.

The former probably has to stay until musb can keep a reference to the otg,
separate form the usb_phy.  The latter can be changed to use extcon - to
some extent.  I actually have patches to do that from a couple of years bac=
k,
but I never proceeded with them.

The problem is that one thing that needs to be communicated to the charger =
is
the max current that was negotiated by a "Standard Downstream Port".
This could be 500mA from a powered hum, or much less from an unpowered hub.
(Currently the usb gadget code does negotiated between different
possibilities, but it could and hopefully will one day).

With the notifier chain there is an easy way to communicate the allowed
current once it is negotiated. e.g. ab8500_usb_set_power() does this.

'struct phy' has no equivalent of the 'set_power' callback  which 'struct
usb_phy' provides, and extcon has no mechanism (that I can see) for
communicating a number - just binary cable states.

Presumably a 'set_power' method could be added to 'struct phy' so the
usb-core can communicate the number to the phy, but it is not clear to me h=
ow
the 'phy' can communicate it to the charger.
The 'phy' could provide an API to request the current negotiated max curren=
t,
but there still needs to be a way to let the charger know that this has
changed.
That could in theory be done via extcon, by having a secondary
'USB_connected' cable type, but it isn't really a cable type and pretending
that it is seems wrong.

Any suggestions?

Thanks,
NeilBrown

--Sig_/DGq.As5MUZf_apZek+CmM_=
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVRt23jnsnt1WYoG5AQJrRw//Ub9d5FidIATyHhbNt7i0JdrXGa7LLZaA
ZIAWbvtN9IS2D0/m2ltjTY+zdclUdNpG2aje5tw0vDYPJkviuzxG6XDVeIgqOArM
LfsdtOebPBV4gW4DWimwpVbftp/D+65x3FBBti1Vh9ISBwLC4bXpkH8IamjroxOU
3k96CYkMeJhi8TWSR2fOnsL3pnydcP+PSvvmjTNsqS1ApTe8S7ULouerOWMxTEQO
QDJap4w/48NFitiF96yxXPO4S5l+u6i1/TRRN1bUy7uIfXXiq5aGHrh16e6+esR4
H5uLZmSGOZUDA8PmGifEZjTRyPYdUul89z5A2nD0y4DIPr494XfiPWCRhjHwWPwd
MEB/VgWOJBFFz4HzbeSNQubgFJJuGad5O9+oyc0jsfgE7/MwsJ9SNdLLVmYaATqy
GPbhjeH6kwt4ZC4O8AGGNdz0u/qGEFASwxCLXoPDhFwYOoeGSeLbaezWFyEwKMq/
E0M16teU9Fvyudbcq1m+luLg414Vplahp82umnKWRyFQR6NyzBo+g/fUGJDSmWjd
pGQu3eFpNC05RWKGaEbcv6r6BPd8DIg2v0IESg/Tao0GTqViDUIv2y4VixsaN5Da
/9c6RqVy8myYjCMudf7Y8/pW+iLLXDaDrBhbC0hpaNsMJpKYfqHmN3aenSmqq4bD
FR/aQZc7yZc=
=/INZ
-----END PGP SIGNATURE-----

--Sig_/DGq.As5MUZf_apZek+CmM_=--
