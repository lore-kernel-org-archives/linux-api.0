From: Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH v1 06/10] device property: switch to use UUID API
Date: Fri, 08 Apr 2016 13:00:38 +0300
Message-ID: <1460109638.6620.41.camel@linux.intel.com>
References: <1455711448-124103-1-git-send-email-andriy.shevchenko@linux.intel.com>
	 <1455711448-124103-7-git-send-email-andriy.shevchenko@linux.intel.com>
	 <7544228.v4QPX4F7J7@vostro.rjw.lan>
	 <1456495897.13244.144.camel@linux.intel.com>
	 <1460047286.6620.26.camel@linux.intel.com>
	 <877fg828lr.fsf@yhuang-dev.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <877fg828lr.fsf-5/hDr2MS57EDqwDYnZuMFFaTQe2KTcn/@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Huang, Ying" <ying.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "Rafael J. Wysocki" <rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org>, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Jani Nikula <jani.nikula-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, David Airlie <airlied-cv59FeDIM0c@public.gmane.org>, Benjamin Tissoires <benjamin.tissoires-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Bjorn Helgaas <bhelgaas-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mathias Nyman <mathias.nyman-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Lv Zheng <lv.zheng-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mark Brown <broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zhang Rui <rui.zhang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mika Westerberg <mika.westerberg-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Rasmus Villemoes <linux-qQsb+v5E8BnlAoU/VqSP6n9LOBIZ5rWg@public.gmane.org>, linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Fri, 2016-04-08 at 09:27 +0800, Huang, Ying wrote:
> Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org> writes:
>=20
> >=20
> > On Fri, 2016-02-26 at 16:11 +0200, Andy Shevchenko wrote:
> > >=20
> > > On Thu, 2016-02-18 at 01:03 +0100, Rafael J. Wysocki wrote:
> > > >=20
> > > >=20
> > > > On Wednesday, February 17, 2016 02:17:24 PM Andy Shevchenko
> > > > wrote:
> > > > >=20
> > > > >=20
> > > > > Switch to use a generic UUID API instead of custom approach.
> > > > > It
> > > > > allows to
> > > > > define UUIDs, compare them, and validate.
> > > []
> > >=20
> > Summon initial author of the UUID library.
> >=20
> > Summary: the API of comparison functions is rather strange. What th=
e
> > point to not take pointers directly? (Moreover I hope compiler too
> > clever not to make a copy of constant arguments there)
> >=20
> > I could only imagine the case you are trying to avoid temporary
> > variables for constants like NULL_UUID.
> >=20
> > Issue with this is the ugliness in the users of that, in
> > particularly
> > present in ACPI (drivers/acpi/apei/ghes.c).
> >=20
> > I would like to have more clear interface for that. Perhaps we may
> > add
> > something like
> >=20
> > cmp_p(pointer, non-pointer);
> > cmp_pp(pointer, pointer);
> >=20
> > to not break existing API for now.
> >=20
> > It would be useful for many cases in the kernel.
> You can take a look at the drivers/acpi/apei/erst.c for uuid_le_cmp
> usage.
>=20
> #define
> CPER_CREATOR_PSTORE=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0\
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0UUID_LE(0x75a574e3, 0=
x5052, 0x4b29, 0x8a, 0x8e, 0xbe,
> 0x2c,=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0\
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A00x64, 0x90, 0xb8, 0x9d)
>=20
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (uuid_le_cmp(rcd->=
hdr.creator_id, CPER_CREATOR_PSTORE) !=3D
> 0)
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0goto skip;
>=20
> Looks better?

I don't quite understand the issues with=C2=A0

if (uuid_le_cmp(&rcd->hdr.creator_id, &CPER_CREATOR_PSTORE) !=3D 0)

or, like I mentioned previously, we may introduce _cmp_p() and use like

if (uuid_le_cmp_p(&rcd->hdr.creator_id, CPER_CREATOR_PSTORE) !=3D 0)

if it looks better (again, I don't know if compiler is going to copy th=
e last argument).

>=20
> This is the typical use case in mind when I write the uuid.h.
>=20
> As for uuid_le_cmp usage in drivers/acpi/apei/ghes.c,
>=20
> 		if (!uuid_le_cmp(*(uuid_le *)gdata->section_type,
> 				=C2=A0CPER_SEC_PLATFORM_MEM)) {

Ditto

if (!uuid_le_cmp_p((uuid_le *)gdata->section_type,
CPER_SEC_PLATFORM_MEM)) {

>=20
> The code looks not good mainly because acpi_hest_generic_data is not
> defined with uuid_le in mind.
>=20
> struct acpi_hest_generic_data {
> 	u8 section_type[16];
> 	u32 error_severity;
> 	u16 revision;
> 	u8 validation_bits;
> 	u8 flags;
> 	u32 error_data_length;
> 	u8 fru_id[16];
> 	u8 fru_text[20];
> };
>=20
> If section_type was defined as uuid_le instead of u8[16], the
> uuid_le_cmp usage would look better.=C2=A0=C2=A0So I suggest to use u=
uid_le/be
> in
> data structure definition in new code if possible.

This is understandable for such structures, but we might get a UUID fro=
m
a buffer which is pointer to u8. It's not possible to convert to uuid_*
since it's too generic stuff and might require to introduce
ACPI_TYPE_UUID with standardization and all necessary work. Apparently
not the shortest way.

>=20
> Best Regards,
> Huang, Ying
>=20
> >=20
> > >=20
> > > >=20
> > > >=20
> > > > >=20
> > > > >=20
> > > > > +static const uuid_le ads_uuid =3D
> > > > > +	UUID_LE(0xdbb8e3e6, 0x5886, 0x4ba6,
> > > > > +		0x87, 0x95, 0x13, 0x19, 0xf5, 0x2a, 0x96,
> > > > > 0x6b);
> > > > > =C2=A0
> > > > > =C2=A0static bool acpi_enumerate_nondev_subnodes(acpi_handle =
scope,
> > > > > =C2=A0					=C2=A0=C2=A0=C2=A0const union
> > > > > acpi_object
> > > > > *desc,
> > > > > @@ -138,7 +136,7 @@ static bool
> > > > > acpi_enumerate_nondev_subnodes(acpi_handle scope,
> > > > > =C2=A0		=C2=A0=C2=A0=C2=A0=C2=A0|| links->type !=3D ACPI_TYPE=
_PACKAGE)
> > > > > =C2=A0			break;
> > > > > =C2=A0
> > > > > -		if (memcmp(uuid->buffer.pointer, ads_uuid,
> > > > > sizeof(ads_uuid)))
> > > > > +		if (uuid_le_cmp(*(uuid_le *)uuid-
> > > > > >buffer.pointer,
> > > > > ads_uuid))
> > > > Maybe it's too late, but I don't quite understand the pointer
> > > > manipulations here.
> > > >=20
> > > > I can see why you need a type conversion (although it looks
> > > > ugly),
> > > > but why do you
> > > > need to dereference it too?
> > > The function takes that kind of type on input. The other variants
> > > are
> > > not compiled.
> > > Perhaps we better change uuid_{lb}e_cmp() first to take normal
> > > pointers, though I think the initial idea was to get type checkin=
g
> > > at
> > > compile time.
> > >=20

--=20
Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Intel Finland Oy
