From: Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH v1 06/10] device property: switch to use UUID API
Date: Fri, 26 Feb 2016 16:11:37 +0200
Message-ID: <1456495897.13244.144.camel@linux.intel.com>
References: <1455711448-124103-1-git-send-email-andriy.shevchenko@linux.intel.com>
	 <1455711448-124103-7-git-send-email-andriy.shevchenko@linux.intel.com>
	 <7544228.v4QPX4F7J7@vostro.rjw.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <7544228.v4QPX4F7J7-sKB8Sp2ER+y1GS7QM15AGw@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Rafael J. Wysocki" <rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org>
Cc: Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Jani Nikula <jani.nikula-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, David Airlie <airlied-cv59FeDIM0c@public.gmane.org>, Benjamin Tissoires <benjamin.tissoires-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Bjorn Helgaas <bhelgaas-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mathias Nyman <mathias.nyman-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Lv Zheng <lv.zheng-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mark Brown <broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zhang Rui <rui.zhang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mika Westerberg <mika.westerberg-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Rasmus Villemoes <linux-qQsb+v5E8BnlAoU/VqSP6n9LOBIZ5rWg@public.gmane.org>, linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Thu, 2016-02-18 at 01:03 +0100, Rafael J. Wysocki wrote:
> On Wednesday, February 17, 2016 02:17:24 PM Andy Shevchenko wrote:
> > Switch to use a generic UUID API instead of custom approach. It
> > allows to
> > define UUIDs, compare them, and validate.

[]

> > +static const uuid_le ads_uuid =3D
> > +	UUID_LE(0xdbb8e3e6, 0x5886, 0x4ba6,
> > +		0x87, 0x95, 0x13, 0x19, 0xf5, 0x2a, 0x96, 0x6b);
> > =C2=A0
> > =C2=A0static bool acpi_enumerate_nondev_subnodes(acpi_handle scope,
> > =C2=A0					=C2=A0=C2=A0=C2=A0const union acpi_object
> > *desc,
> > @@ -138,7 +136,7 @@ static bool
> > acpi_enumerate_nondev_subnodes(acpi_handle scope,
> > =C2=A0		=C2=A0=C2=A0=C2=A0=C2=A0|| links->type !=3D ACPI_TYPE_PACKA=
GE)
> > =C2=A0			break;
> > =C2=A0
> > -		if (memcmp(uuid->buffer.pointer, ads_uuid,
> > sizeof(ads_uuid)))
> > +		if (uuid_le_cmp(*(uuid_le *)uuid->buffer.pointer,
> > ads_uuid))
>=20
> Maybe it's too late, but I don't quite understand the pointer
> manipulations here.
>=20
> I can see why you need a type conversion (although it looks ugly),
> but why do you
> need to dereference it too?

The function takes that kind of type on input. The other variants are
not compiled.
Perhaps we better change uuid_{lb}e_cmp() first to take normal
pointers, though I think the initial idea was to get type checking at
compile time.

--=20
Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Intel Finland Oy
