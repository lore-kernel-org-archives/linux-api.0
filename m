From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH v2 3/8] lib/uuid: introduce few more generic helpers for
 UUID
Date: Mon, 04 Apr 2016 16:55:50 -0700
Message-ID: <1459814150.2138.3.camel@perches.com>
References: <1459776610-68469-1-git-send-email-andriy.shevchenko@linux.intel.com>
	 <1459776610-68469-4-git-send-email-andriy.shevchenko@linux.intel.com>
	 <20160404164029.9c72a93cb29d619766fbb2d2@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160404164029.9c72a93cb29d619766fbb2d2@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Theodore Ts'o <tytso@mit.edu>, Matt Fleming <matt@codeblueprint.co.uk>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Mon, 2016-04-04 at 16:40 -0700, Andrew Morton wrote:
> On Mon,=A0=A04 Apr 2016 16:30:05 +0300 Andy Shevchenko  wrote:
>=20
> >=20
> > There are new helpers in this patch:
> >=20
> > uuid_is_valid		checks if a UUID is valid
> > uuid_be_to_bin		converts from string to binary (big endian)
> > uuid_le_to_bin		converts from string to binary (little endian)
> 	>=A0
> >=20
> > They will be used in future, i.e. in the following patches in the s=
eries.
> >=20
> > This also moves indices arrays to lib/uuid.c to be shared accross m=
odules.
> >=20
> > ...
> >=20
> > --- a/include/linux/uuid.h
> > +++ b/include/linux/uuid.h
> Nit:
>=20
> >=20
> > +/**
> > +=A0=A0* uuid_is_valid - checks if UUID string valid
> > +=A0=A0* @uuid:	UUID string to check
> > +=A0=A0*
> > +=A0=A0* Description:
> > +=A0=A0* It checks if the UUID string is following the format:
> > +=A0=A0*	xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
> > +=A0=A0* where x is a hex digit.
> > +=A0=A0*
> > +=A0=A0* Return: 0 on success, %-EINVAL otherwise.
> > +=A0=A0*/
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

nit2:

Could make this return bool.
