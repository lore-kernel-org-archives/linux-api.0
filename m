From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: Re: [PATCH v1 06/10] device property: switch to use UUID API
Date: Thu, 07 Apr 2016 19:41:26 +0300
Message-ID: <1460047286.6620.26.camel@linux.intel.com>
References: <1455711448-124103-1-git-send-email-andriy.shevchenko@linux.intel.com>
	 <1455711448-124103-7-git-send-email-andriy.shevchenko@linux.intel.com>
	 <7544228.v4QPX4F7J7@vostro.rjw.lan>
	 <1456495897.13244.144.camel@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-acpi-owner@vger.kernel.org>
In-Reply-To: <1456495897.13244.144.camel@linux.intel.com>
Sender: linux-acpi-owner@vger.kernel.org
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Huang Ying <ying.huang@intel.com>
Cc: Theodore Ts'o <tytso@mit.edu>, Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Jani Nikula <jani.nikula@linux.intel.com>, David Airlie <airlied@linux.ie>, Benjamin Tissoires <benjamin.tissoires@redhat.com>, Bjorn Helgaas <bhelgaas@google.com>, Mathias Nyman <mathias.nyman@intel.com>, Matt Fleming <matt@codeblueprint.co.uk>, Lv Zheng <lv.zheng@intel.com>, Mark Brown <broonie@kernel.org>, Zhang Rui <rui.zhang@intel.com>, Mika Westerberg <mika.westerberg@linux.intel.com>, Andrew Morton <akpm@linux-foundation.org>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org, linux-efi@vger.kernel.org, linux-api@vger.kernel.org, linux-nvdimm@lists.01.org
List-Id: linux-api@vger.kernel.org

On Fri, 2016-02-26 at 16:11 +0200, Andy Shevchenko wrote:
> On Thu, 2016-02-18 at 01:03 +0100, Rafael J. Wysocki wrote:
> >=20
> > On Wednesday, February 17, 2016 02:17:24 PM Andy Shevchenko wrote:
> > >=20
> > > Switch to use a generic UUID API instead of custom approach. It
> > > allows to
> > > define UUIDs, compare them, and validate.
> []
>=20

Summon initial author of the UUID library.

Summary: the API of comparison functions is rather strange. What the
point to not take pointers directly? (Moreover I hope compiler too
clever not to make a copy of constant arguments there)

I could only imagine the case you are trying to avoid temporary
variables for constants like NULL_UUID.

Issue with this is the ugliness in the users of that, in particularly
present in ACPI (drivers/acpi/apei/ghes.c).

I would like to have more clear interface for that. Perhaps we may add
something like

cmp_p(pointer, non-pointer);
cmp_pp(pointer, pointer);

to not break existing API for now.

It would be useful for many cases in the kernel.

> >=20
> > >=20
> > > +static const uuid_le ads_uuid =3D
> > > +	UUID_LE(0xdbb8e3e6, 0x5886, 0x4ba6,
> > > +		0x87, 0x95, 0x13, 0x19, 0xf5, 0x2a, 0x96, 0x6b);
> > > =C2=A0
> > > =C2=A0static bool acpi_enumerate_nondev_subnodes(acpi_handle scop=
e,
> > > =C2=A0					=C2=A0=C2=A0=C2=A0const union
> > > acpi_object
> > > *desc,
> > > @@ -138,7 +136,7 @@ static bool
> > > acpi_enumerate_nondev_subnodes(acpi_handle scope,
> > > =C2=A0		=C2=A0=C2=A0=C2=A0=C2=A0|| links->type !=3D ACPI_TYPE_PAC=
KAGE)
> > > =C2=A0			break;
> > > =C2=A0
> > > -		if (memcmp(uuid->buffer.pointer, ads_uuid,
> > > sizeof(ads_uuid)))
> > > +		if (uuid_le_cmp(*(uuid_le *)uuid->buffer.pointer,
> > > ads_uuid))
> > Maybe it's too late, but I don't quite understand the pointer
> > manipulations here.
> >=20
> > I can see why you need a type conversion (although it looks ugly),
> > but why do you
> > need to dereference it too?
> The function takes that kind of type on input. The other variants are
> not compiled.
> Perhaps we better change uuid_{lb}e_cmp() first to take normal
> pointers, though I think the initial idea was to get type checking at
> compile time.
>=20

--=20
Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Intel Finland Oy

--
To unsubscribe from this list: send the line "unsubscribe linux-acpi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
