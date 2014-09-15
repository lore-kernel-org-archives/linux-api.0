From: Lee Jones <lee.jones-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v6 0/8] charger/mfd: max14577: Add support for MAX77836
Date: Mon, 15 Sep 2014 23:52:20 +0100
Message-ID: <20140915225220.GH25162@lee--X1>
References: <1410504840-23543-1-git-send-email-k.kozlowski@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1410504840-23543-1-git-send-email-k.kozlowski-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Krzysztof Kozlowski <k.kozlowski-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Cc: Sebastian Reichel <sre-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Dmitry Eremin-Solenikov <dbaryshkov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Samuel Ortiz <sameo-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-pm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Liam Girdwood <lgirdwood-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Mark Brown <broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Ian Campbell <ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org>, Kumar Gala <galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Kyungmin Park <kyungmin.park-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, Marek Szyprowski <m.szyprowski-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, Bartlomiej Zolnierkiewicz <b.zolnierkie-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Fri, 12 Sep 2014, Krzysztof Kozlowski wrote:
> This is a sixth version of patches adding support for
> MAX77836 device to the max14577 drivers.
>=20
> This patchset has been on the lists for quite long time and was alrea=
dy
> reviewed by all necessary maintainers except power supply.
> I need acks from power supply subsystem (patches: 3, 5-8).

Give this set a few more days for the Power guys to respond.  If they
don't, ping me and I will just apply the set.

> Generally this should be pulled at once but some parts may be split
> and pulled separately in following batches:
>  - Patches 1 and 2: as MFD prerequisites,
>  - Patches 3-5: adding actual charger code, depends on 1 and 2,
>  - Patch 6: fuel-gauge, independent,
>  - Patches 7 and 8: only documentation.
>=20
> Lee Jones said he can take the set through his tree. Still I need ack=
s
> from power subsystem.
>=20
> Everything rebased on Linus' tree (v3.17-rc2-9-g68e370289c29).
>=20
> Changes since v5
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> 1. 5/8: Remove 'inline' from functions (suggested by Andrew Morton).
> 2. Add Andrew Morton's acks.
>=20
> Changes since v4
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> 1. Add Lee Jones' acks to patch 1 and 2 (mfd).
> 2. power max17040 6/8: Remove duplicated (and not used) value of id
>    in array of i2c_device_id. (suggested by Lee Jones)
>=20
> Changes since v3
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> 1. Split MFD changes into separate new patches:
>    1/8: mfd: max14577: Add defines for MAX77836 charger
>    2/8: Map charger device to its own of_node
>    Suggested by Lee Jones.
>=20
> Changes since v2
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> 1. charger: Use sysfs instead of DTS for setting the fast charge time=
r.
>    The charger driver now selects the CONFIG_SYSFS and exports
>    a DEVICE_ATTR. (suggested by Mark Rutland)
> 2. Add patch 6 with documentation of exported sysfs entry for fast
>    charge timer.
> 3. charger 3/6: Add missing 'break' in switch parsing valid values
>    for fast charge timer.
>=20
> Changes since v1
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> 1. charger 3/5: Add an error message for each unsuccessful parse of D=
T
>    property (suggested by Mark Rutland).
> 2. charger 3/5: Use 'u32' type for storing values from DT (suggested
>    by Mark Rutland).
> 3. charger 3/5: Remove an error message for memory allocation failure=
=2E
>=20
>=20
> The patchset (first and second part of the MAX77836 drivers) has been
> on the lists since January. Changelog for the first part of the drive=
rs
> (merged):
> https://www.mail-archive.com/linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org/msg628696.h=
tml
>=20
>=20
> Best regards,
> Krzysztof Kozlowski
>=20
>=20
> Krzysztof Kozlowski (8):
>   mfd: max14577: Add defines for MAX77836 charger
>   mfd: max14577: Map charger device to its own of_node
>   charger: max14577: Add support for MAX77836 charger
>   regulator/mfd: max14577: Export symbols for calculating charger
>     current
>   charger: max14577: Configure battery-dependent settings from DTS an=
d
>     sysfs
>   power: max17040: Add ID for MAX77836 Fuel Gauge block
>   devicetree: mfd: max14577: Add device tree bindings document
>   Documentation: charger: max14577: Document exported sysfs entry
>=20
>  Documentation/ABI/testing/sysfs-class-power        |  14 +
>  Documentation/devicetree/bindings/mfd/max14577.txt | 146 ++++++++
>  drivers/mfd/max14577.c                             | 100 +++++-
>  drivers/power/Kconfig                              |   5 +-
>  drivers/power/max14577_charger.c                   | 370 +++++++++++=
++++++++--
>  drivers/power/max17040_battery.c                   |   3 +-
>  drivers/regulator/max14577.c                       |  80 +----
>  include/linux/mfd/max14577-private.h               |  95 ++++--
>  include/linux/mfd/max14577.h                       |  30 ++
>  9 files changed, 704 insertions(+), 139 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/mfd/max14577.tx=
t
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
