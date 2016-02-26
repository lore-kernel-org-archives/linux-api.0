From: Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH v1 06/10] device property: switch to use UUID API
Date: Fri, 26 Feb 2016 16:28:10 +0200
Message-ID: <1456496890.13244.146.camel@linux.intel.com>
References: <1455711448-124103-1-git-send-email-andriy.shevchenko@linux.intel.com>
	 <1455711448-124103-7-git-send-email-andriy.shevchenko@linux.intel.com>
	 <20160218110754.GG1742@lahna.fi.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160218110754.GG1742-3PARRvDOhMZrdx17CPfAsdBPR1lH4CV8@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mika Westerberg <mika.westerberg-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: "Rafael J. Wysocki" <rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org>, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Jani Nikula <jani.nikula-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, David Airlie <airlied-cv59FeDIM0c@public.gmane.org>, Benjamin Tissoires <benjamin.tissoires-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Bjorn Helgaas <bhelgaas-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mathias Nyman <mathias.nyman-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Lv Zheng <lv.zheng-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mark Brown <broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zhang Rui <rui.zhang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Rasmus Villemoes <linux-qQsb+v5E8BnlAoU/VqSP6n9LOBIZ5rWg@public.gmane.org>, linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Thu, 2016-02-18 at 13:07 +0200, Mika Westerberg wrote:
> On Wed, Feb 17, 2016 at 02:17:24PM +0200, Andy Shevchenko wrote:
> > Switch to use a generic UUID API instead of custom approach. It
> > allows to
> > define UUIDs, compare them, and validate.
> >=20
> > Signed-off-by: Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> > ---
> > =C2=A0drivers/acpi/property.c | 18 ++++++++----------
> > =C2=A01 file changed, 8 insertions(+), 10 deletions(-)
> >=20
> > diff --git a/drivers/acpi/property.c b/drivers/acpi/property.c
> > index 2aee416..1e75305 100644
> > --- a/drivers/acpi/property.c
> > +++ b/drivers/acpi/property.c
> > @@ -25,15 +25,13 @@ static int acpi_data_get_property_array(struct
> > acpi_device_data *data,
> > =C2=A0					const union acpi_object
> > **obj);
> > =C2=A0
> > =C2=A0/* ACPI _DSD device properties UUID: daffd814-6eba-4d8c-8a91-
> > bc9bbf4aa301 */
> > -static const u8 prp_uuid[16] =3D {
> > -	0x14, 0xd8, 0xff, 0xda, 0xba, 0x6e, 0x8c, 0x4d,
> > -	0x8a, 0x91, 0xbc, 0x9b, 0xbf, 0x4a, 0xa3, 0x01
> > -};
> > +static const uuid_le prp_uuid =3D
> > +	UUID_LE(0xdaffd814, 0x6eba, 0x4d8c,
> > +		0x8a, 0x91, 0xbc, 0x9b, 0xbf, 0x4a, 0xa3, 0x01);
> > =C2=A0/* ACPI _DSD data subnodes UUID: dbb8e3e6-5886-4ba6-8795-
> > 1319f52a966b */
> > -static const u8 ads_uuid[16] =3D {
> > -	0xe6, 0xe3, 0xb8, 0xdb, 0x86, 0x58, 0xa6, 0x4b,
> > -	0x87, 0x95, 0x13, 0x19, 0xf5, 0x2a, 0x96, 0x6b
> > -};
> > +static const uuid_le ads_uuid =3D
> > +	UUID_LE(0xdbb8e3e6, 0x5886, 0x4ba6,
> > +		0x87, 0x95, 0x13, 0x19, 0xf5, 0x2a, 0x96, 0x6b);
>=20
> This looks better than the original but it is still not too readable.
>=20
> I think it would be better to have uuid as string like:
>=20
> static const char *ads_uuid =3D "dbb8e3e6-5886-4ba6-8795-1319f52a966b=
";
>=20
> and then convert that to the right byte presentation when first time
> used. That would match the uuid format in the ACPI (and device
> properties) spec. and thus make it easier to read and understand.

Yes we can do this on slow paths. Or in cases where we know that
conversion happens only once.


--=20
Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Intel Finland Oy
