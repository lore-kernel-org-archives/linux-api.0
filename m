From: Lee Jones <lee.jones-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v4 0/4] power: Add max77693 charger driver
Date: Sun, 18 Jan 2015 18:00:02 +0000
Message-ID: <20150118180002.GJ3574@x1>
References: <1420453019-28614-1-git-send-email-k.kozlowski@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1420453019-28614-1-git-send-email-k.kozlowski-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Krzysztof Kozlowski <k.kozlowski-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Cc: Sebastian Reichel <sre-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Dmitry Eremin-Solenikov <dbaryshkov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Samuel Ortiz <sameo-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-pm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Tell us what you need?

> Changes since v3
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> 1. Patch 3/4: Don't create platform data structure for charger settin=
gs
>    because driver won't be used on non-DT SoCs (its for Exynos based
>    Trats2).
> 2. Patch 3/4: Drop Sebastian's ack [1] because of change above.
>=20
> Changes since v2
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> 1. Add ack from Sebastian Reichel (charger driver).
> 2. Drop patch "mfd: max77693: Map charger device to its own of_node"
>    (applied by Lee Jones).
>=20
>=20
> Changes since v1
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> 1. Add patch 2/5: mfd: max77693: Map charger device to its own of_nod=
e
>    (forgot to send it in v1)
> 2. Remove patches for DTS and configs. I'll send them later.
> 3. Add ack from Lee Jones (patch 3/5).
>=20
>=20
> Description
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> The patchset adds max77693 charger driver present on Trats2 board
> (and Galaxy S III). The driver configures battery charger and exposes
> power supply interface.
>=20
> Driver is necessary to provide full charging stack on Trats2 device
> (extcon, charger-manager etc.).
>=20
> [1] https://lkml.org/lkml/2014/10/27/774
>=20
>=20
> Best regards,
> Krzysztof
>=20
>=20
>=20
> Krzysztof Kozlowski (4):
>   devicetree: power/mfd: max77693: Document new bindings for charger
>   mfd: max77693: Add defines for MAX77693 charger driver
>   power: max77693: Add charger driver for Maxim 77693
>   Documentation: power: max77693-charger: Document exported sysfs ent=
ry
>=20
>  Documentation/ABI/testing/sysfs-class-power        |  42 ++
>  Documentation/devicetree/bindings/mfd/max77693.txt |  45 ++
>  drivers/power/Kconfig                              |   6 +
>  drivers/power/Makefile                             |   1 +
>  drivers/power/max77693_charger.c                   | 758 +++++++++++=
++++++++++
>  include/linux/mfd/max77693-private.h               | 108 +++
>  6 files changed, 960 insertions(+)
>  create mode 100644 drivers/power/max77693_charger.c
>=20

--=20
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org =E2=94=82 Open source software for ARM SoCs
=46ollow Linaro: Facebook | Twitter | Blog
--
To unsubscribe from this list: send the line "unsubscribe devicetree" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
