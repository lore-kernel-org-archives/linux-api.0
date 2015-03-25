From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 0/5] Enhancements to twl4030 phy to support better
 charging - V2
Date: Thu, 26 Mar 2015 08:22:19 +1100
Message-ID: <20150326082219.510ac598@notabene.brown>
References: <20150322223307.21765.62974.stgit@notabene.brown>
	<551325B0.1090308@ti.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/AHclShDpLF5lqoM3nS2HXrz"; protocol="application/pgp-signature"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <551325B0.1090308@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: NeilBrown <neil@brown.name>, Tony Lindgren <tony@atomide.com>, linux-api@vger.kernel.org, GTA04 owners <gta04-owner@goldelico.com>, linux-kernel@vger.kernel.org, Pavel Machek <pavel@ucw.cz>
List-Id: linux-api@vger.kernel.org

--Sig_/AHclShDpLF5lqoM3nS2HXrz
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 26 Mar 2015 02:46:32 +0530 Kishon Vijay Abraham I <kishon@ti.com>
wrote:

> Hi,
>=20
> On Monday 23 March 2015 04:05 AM, NeilBrown wrote:
> > Hi Kishon,
> >  I wonder if you could queue the following for the next merge window.
> >  They allow the twl4030 phy to provide more information to the
> >  twl4030 battery charger.
> >  There are only minimal changes since the first version, particularly
> >  documentation has been improved.
>=20
> There are quite a few things in this series which use the USB PHY library
> interface which is kindof deprecated. We should try and use the Generic P=
HY
> library for all of them. It would also be better to add features to the
> PHY framework if the we can't achieve something with the existing PHY
> framework.

Hi,
 are you able to more specific at all?  What is the "USB PHY library"?
Where exactly is the "PHY framework"?

I know none of the history here and while I could try to guess I suspect
there is an even chance I would get wrong.
I'm happy to do the work but I want to be sure of what you are asking.

Thanks,
NeilBrown

--Sig_/AHclShDpLF5lqoM3nS2HXrz
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVRMnCznsnt1WYoG5AQImFA/+PYQUVixQLC9OZWXfk6s+LdPUV4jeJSGz
neePIVtHh4kUb98WQGUDdUy4oJc2EPk3vMFAfWwCpg3F/RQN+dJbSfRFuu7Kl+Qo
W8gYKtai2jJa/TwAZ7dMTN66KhBnrCmlEMOn+CUpd9NQAGpOPKMyYEUenwmm0d3T
kNQH8NegWc54eVqE52pRqAZpFekf7dQ7WAkTllsUAdeOQQUOgLK1QxY4mWbMGEmc
FrKW/2IkydPE8XallZcYH+xAIYufNquUpP8Z7lcpX14U7mwlJSrO/snlip6csQ7f
lzpgob4pkiQvPE1tw7xQyKgwcLa4wuyHj5wey5mp5enLq82DRhJ6QABUkq/6CDEC
pBHYhi6zgV0JN202vDR8XDnMfazDY1IzhnyC/Raylr5IhOLaP5IHAhHb6vhk7XL1
nBQC3BOoEU5sCjn0uHec/HWEN372125gBGj7hVeNvqyNAS6an74ITETPhr91oIOT
qJ206p9QQzpjek7RQgHCGSP5DaCwzhPTimYQLhdkPg9cO4h5Cg59QgjvO7T5+ugk
4DhcHEdZePsAbx3xsIftIi8J2Xymk6QoheK+HWGjT2HwhTWbjFkwpejZOU0ZYazt
jSageJi/M52LIHoNU34fGKISZB2ZptvSH2suX0R8S2FCSJdjk++vn7geC5o3ZMrF
bYun8kPvGWY=
=yqMy
-----END PGP SIGNATURE-----

--Sig_/AHclShDpLF5lqoM3nS2HXrz--
