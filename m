From: NeilBrown <neilb-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [PATCH 13/14] twl4030_charger: Increase current carefully while
 watching voltage.
Date: Mon, 30 Mar 2015 08:26:37 +1100
Message-ID: <20150330082637.4bf4832d@notabene.brown>
References: <20150322231635.23789.70149.stgit@notabene.brown>
	<20150322232029.23789.30185.stgit@notabene.brown>
	<20150323212541.GD14779@amd>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/q9BVpzj6P1nFjjCa83u2Kdm"; protocol="application/pgp-signature"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150323212541.GD14779@amd>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Machek <pavel-+ZI9xUNit7I@public.gmane.org>
Cc: NeilBrown <neil-+NVA1uvv1dVBDLzU/O5InQ@public.gmane.org>, Sebastian Reichel <sre-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, GTA04 owners <gta04-owner-xXXSsgcRVICgSpxsJD1C4w@public.gmane.org>, inux-pm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-omap-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Lee Jones <lee.jones-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

--Sig_/q9BVpzj6P1nFjjCa83u2Kdm
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 23 Mar 2015 22:25:41 +0100 Pavel Machek <pavel-+ZI9xUNit7I@public.gmane.org> wrote:

> Hi!
>=20
> > The USB Battery Charging spec (BC1.2) suggests a dedicated
> > charging port can deliver from 0.5 to 5.0A at between 4.75 and 5.25
> > volts.
> >=20
> > To choose the "correct" current voltage setting requires a trial
> > and error approach: try to draw current and see if the voltage drops
> > too low.
> >=20
> > Even with a configured Standard Downstream Port, it may not be possible
> > to reliably pull 500mA - depending on cable quality and source
> > quality I have reports of charging failure due to the voltage dropping
> > too low.
> >=20
> > To address both these concerns, this patch introduce incremental
> > current setting.
> > The current pull from VBUS is increased in steps of 20mA every 100ms
> > until the target is reached or until the measure voltage drops below
> > 4.75V.  If the voltage does go too low, the target current is reduced
> > by 20mA and kept there.
>=20
> Still nervous. If it is possible to overheat the charger, without
> tripping internal fuse, then you'll do it.

If it is possible to overheat the charger without tripping an internal fuse,
then sure the charger is mis-designed - is it not?

Can you suggest an algorithm for determining how much current can safely be
pulled from a charger that would *not* make you nervous?



>=20
> > This applies to currents selected automatically, or to values
> > set via sysfs.  So setting a large value will cause the maximum
> > available to be used - up to the limit of 1.7A imposed by the
> > hardware.
> >
>=20
> > +	printk("v=3D%d cur=3D%d target=3D%d\n", v, bci->usb_cur,
> > +	       bci->usb_cur_target);
>=20
> dev_info() and a bit better message, or drop it for production?

Changed to dev_dbg() - thanks.


>=20
> > +	if (v < USB_MIN_VOLT) {
> > +		/* Back up and stop adjusting. */
> > +		bci->usb_cur -=3D USB_CUR_STEP;
> > +		bci->usb_cur_target =3D bci->usb_cur;
>=20
> More importantly.... how does it work with device drawing power for
> operation, too?
>=20
> Imagine device need 500mA with wifi hotspot, nearly nothing while idle.
>=20
> Idle device. Code will find that it can charge using 1A, backs up to
> 0.9A. User starts hotspot. Now device will draw 1.4A, overloading the
> charger and not charging at all...?

The current being measured and controlled is the current flowing in from the
USB VBUS, not flowing out to the battery.
So I the code choose 0.9A, that is all that will be drawn.

This is a possible issue similar to this though.
If the device is idle and the battery is fully charged, then it won't draw
much current from USB even if we allow it too.
So the algorithm might decide it is OK to draw 1.7A because at that time the
device cannot use more than 200mA, and that doesn't cause the voltage to dr=
op.

Then later when user enabled wifi-hotspot, the current needed might go up
above what the charger can provide.

Maybe I should only increase the limit while the actual current is also
increasing.  Maybe also revisit the setting when the battery starts chargin=
g.

NeilBrown


>=20
> Best regards,
> 									Pavel


--Sig_/q9BVpzj6P1nFjjCa83u2Kdm
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVRhuDTnsnt1WYoG5AQLe4g//QK9Zq3ZUQZi7ZaM1QdbJ9hRo89y3r6TA
6K2GkdCdH24HDN0kQ4VpXjw03+fkaNvbWPJgnz4eTq674bf2dzWzyvZEs3FQiR+C
zZLCI5Ach/s0RwHs1ttNyYYAxCQMLr3aquox1DkBoPNF3PKZ2/y8tiia0RpwZnFe
AT5Fsh3EFxrnl6Ucq5Pmo/2RJxjIp0QzzCPm1K+m0AmY/I/3iY4j+fxuEz/2bSGq
vvTSWjjMEUlgvfP2kHXQ7yNQgULHb3NwYMT8MSACQKFgR2E7/lifoy3EtdAwnIYr
3eq/69o2z+F4d31t786lkG5+7OEJ+aiAIyzIsU943FGVG7D396gbY2MHF0wnPcc/
PhAYu9OqJTJ59a7Nhb47DY13fZH2HJF1jS92p/so5Xknu7Ese0G/RsEm46d4jeP8
E7IN3BveK/XUrjzarPaIGU8t0ujgrEY/hVBm5NrLso2vr+UArLmNS6xsoDcGiBIG
izG7qqprYhAQqAQMinLL9gZwR7jj1niaZhJ2y6AnoLimPFMTmafDr54YByFeTmdJ
XBaFDZg1ooug/LW86mQPSR2tF1Y72mfz8wR7DF9qoRlynb7mRHesL9neYTjspcDQ
H55CnTbk9lHhSaCZWxxzzHdXce4ttBbi5Uyz08kSgl72eWZUvepb7YlU3KlNX/XS
+QZKNsxkDZ4=
=RS80
-----END PGP SIGNATURE-----

--Sig_/q9BVpzj6P1nFjjCa83u2Kdm--
