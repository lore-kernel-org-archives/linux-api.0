From: =?iso-8859-1?Q?Cl=E9ment?= Vuchener <clement.vuchener-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2 0/1] Corsair Vengeance K90 driver
Date: Wed, 9 Sep 2015 17:03:46 +0200
Message-ID: <20150909150346.GA7191@untxi.home>
References: <cover.1441641275.git.clement.vuchener@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <cover.1441641275.git.clement.vuchener-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: jikos-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-input-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Mon, Sep 07, 2015 at 05:58:36PM +0200, Cl=E9ment Vuchener wrote:
> I removed the k90_profile class completely. I cannot write a good eno=
ugh ABI with what I know of the keyboard so I am leaving that part out =
of the kernel. If I change my mind in the future, it will be done in an=
other patch.
>=20
> I also fixed a bug I had when unregistering the led device. Work was =
being scheduled after the led device was unregistered.
>=20
> On the name change, I kept a lot of K90 references. As far as I know,=
 the only similar keyboard is the K60 that shares the same firmware but=
 does not have all the special keys and backlight, and for which the hi=
d-generic driver should be enough. The more recent RGB keyboard series =
uses a different protocol from what I have seen from the unofficial use=
rspace driver (CKB from MSC).
Actually, I may have been wrong, other keyboard may share at least the =
incorrect HID usage code part. I will investigate more and send a new p=
atch. I am still interested in comments on this one, especially on the =
choice of key codes for the programmable keys.
>=20
> changes in v2:
>  - Removed the k90_profile class and devices
>  - Renamed driver for a more generic name ("corsair" driver in hid-co=
rsair.c)
>  - Fixed led devices clean up (hang when unplugging and led state res=
et)
>  - Added dependency on USB and LEDS_CLASS in Kconfig
>=20
> Cl=E9ment Vuchener (1):
>   Add Corsair Vengeance K90 driver
>=20
>  Documentation/ABI/testing/sysfs-driver-hid-corsair |  15 +
>  drivers/hid/Kconfig                                |  10 +
>  drivers/hid/Makefile                               |   1 +
>  drivers/hid/hid-core.c                             |   1 +
>  drivers/hid/hid-corsair.c                          | 555 +++++++++++=
++++++++++
>  drivers/hid/hid-ids.h                              |   3 +
>  6 files changed, 585 insertions(+)
>  create mode 100644 Documentation/ABI/testing/sysfs-driver-hid-corsai=
r
>  create mode 100644 drivers/hid/hid-corsair.c
>=20
> --=20
> 2.4.3
>=20
