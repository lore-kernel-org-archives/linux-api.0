From: Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH v2 3/8] lib/uuid: introduce few more generic helpers for
 UUID
Date: Tue, 05 Apr 2016 13:51:50 +0300
Message-ID: <1459853510.12843.8.camel@linux.intel.com>
References: <1459776610-68469-1-git-send-email-andriy.shevchenko@linux.intel.com>
	 <1459776610-68469-4-git-send-email-andriy.shevchenko@linux.intel.com>
	 <20160404164029.9c72a93cb29d619766fbb2d2@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160404164029.9c72a93cb29d619766fbb2d2-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Rasmus Villemoes <linux-qQsb+v5E8BnlAoU/VqSP6n9LOBIZ5rWg@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Mon, 2016-04-04 at 16:40 -0700, Andrew Morton wrote:
> On Mon,=C2=A0=C2=A04 Apr 2016 16:30:05 +0300 Andy Shevchenko <andriy.=
shevchenko
> @linux.intel.com> wrote:
>=20
> >=20
> > There are new helpers in this patch:
> >=20
> > uuid_is_valid		checks if a UUID is valid
> > uuid_be_to_bin		converts from string to binary (big
> > endian)
> > uuid_le_to_bin		converts from string to binary
> > (little endian)
> 	>=C2=A0
> >=20
> > They will be used in future, i.e. in the following patches in the
> > series.
> >=20
> > This also moves indices arrays to lib/uuid.c to be shared accross
> > modules.
> >=20
> > ...
> >=20
> > --- a/include/linux/uuid.h
> > +++ b/include/linux/uuid.h
> Nit:
>=20
> >=20
> > +/**
> > +=C2=A0=C2=A0* uuid_is_valid - checks if UUID string valid
> > +=C2=A0=C2=A0* @uuid:	UUID string to check
> > +=C2=A0=C2=A0*
> > +=C2=A0=C2=A0* Description:
> > +=C2=A0=C2=A0* It checks if the UUID string is following the format=
:
> > +=C2=A0=C2=A0*	xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
> > +=C2=A0=C2=A0* where x is a hex digit.
> > +=C2=A0=C2=A0*
> > +=C2=A0=C2=A0* Return: 0 on success, %-EINVAL otherwise.
> > +=C2=A0=C2=A0*/
> > +int uuid_is_valid(const char *uuid)
> > +{
> > +	unsigned int i;
> > +
> > +	if (strnlen(uuid, UUID_STRING_LEN) < UUID_STRING_LEN)
> > +		return -EINVAL;
> > +
> > +	for (i =3D 0; i < UUID_STRING_LEN; i++) {
> > +		if (i =3D=3D 8 || i =3D=3D 13 || i =3D=3D 18 || i =3D=3D 23) {
> > +			if (uuid[i] !=3D '-')
> > +				return -EINVAL;
> > +		} else if (!isxdigit(uuid[i])) {
> > +			return -EINVAL;
> > +		}
> > +	}
> Could add
>=20
> 	if (uuid[i])
> 		return -EINVAL;
>=20
> here and lose the additional pass across the input (strlen).

Others suggested a boolean. I would send a fixup later.

>=20
> >=20
> > +	return 0;
> > +}
> >=20
> > ...
> >=20

--=20
Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Intel Finland Oy
