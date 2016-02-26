From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: Re: [PATCH v1 10/10] efivars: use generic UUID library
Date: Fri, 26 Feb 2016 16:29:11 +0200
Message-ID: <1456496951.13244.147.camel@linux.intel.com>
References: <1455711448-124103-1-git-send-email-andriy.shevchenko@linux.intel.com>
	 <1455711448-124103-11-git-send-email-andriy.shevchenko@linux.intel.com>
	 <20160218150727.GK2651@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-acpi-owner@vger.kernel.org>
In-Reply-To: <20160218150727.GK2651@codeblueprint.co.uk>
Sender: linux-acpi-owner@vger.kernel.org
To: Matt Fleming <matt@codeblueprint.co.uk>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Theodore Ts'o <tytso@mit.edu>, Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Jani Nikula <jani.nikula@linux.intel.com>, David Airlie <airlied@linux.ie>, Benjamin Tissoires <benjamin.tissoires@redhat.com>, Bjorn Helgaas <bhelgaas@google.com>, Mathias Nyman <mathias.nyman@intel.com>, Lv Zheng <lv.zheng@intel.com>, Mark Brown <broonie@kernel.org>, Zhang Rui <rui.zhang@intel.com>, Mika Westerberg <mika.westerberg@linux.intel.com>, Andrew Morton <akpm@linux-foundation.org>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org, linux-efi@vger.kernel.org, linux-api@vger.kernel.org, linux-nvdimm@lists.01.org
List-Id: linux-api@vger.kernel.org

On Thu, 2016-02-18 at 15:07 +0000, Matt Fleming wrote:
> On Wed, 17 Feb, at 02:17:28PM, Andy Shevchenko wrote:
> > Instead of opencoding let's use generic UUID library functions
> > here.
> >=20
> > Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> > ---
> > =C2=A0fs/efivarfs/inode.c | 40 +++---------------------------------=
----
> > =C2=A01 file changed, 3 insertions(+), 37 deletions(-)
> >=20
> > diff --git a/fs/efivarfs/inode.c b/fs/efivarfs/inode.c
> > index 3381b9d..b579e3a 100644
> > --- a/fs/efivarfs/inode.c
> > +++ b/fs/efivarfs/inode.c
> > @@ -11,6 +11,7 @@
> > =C2=A0#include <linux/fs.h>
> > =C2=A0#include <linux/ctype.h>
> > =C2=A0#include <linux/slab.h>
> > +#include <linux/uuid.h>
> > =C2=A0
> > =C2=A0#include "internal.h"
> > =C2=A0
> > @@ -44,11 +45,7 @@ struct inode *efivarfs_get_inode(struct
> > super_block *sb,
> > =C2=A0 */
> > =C2=A0bool efivarfs_valid_name(const char *str, int len)
> > =C2=A0{
> > -	static const char dashes[EFI_VARIABLE_GUID_LEN] =3D {
> > -		[8] =3D 1, [13] =3D 1, [18] =3D 1, [23] =3D 1
> > -	};
> > =C2=A0	const char *s =3D str + len - EFI_VARIABLE_GUID_LEN;
> > -	int i;
> > =C2=A0
> > =C2=A0	/*
> > =C2=A0	=C2=A0* We need a GUID, plus at least one letter for the
> > variable name,
> > @@ -66,37 +63,7 @@ bool efivarfs_valid_name(const char *str, int
> > len)
> > =C2=A0	=C2=A0*
> > =C2=A0	=C2=A0*	12345678-1234-1234-1234-123456789abc
> > =C2=A0	=C2=A0*/
> > -	for (i =3D 0; i < EFI_VARIABLE_GUID_LEN; i++) {
> > -		if (dashes[i]) {
> > -			if (*s++ !=3D '-')
> > -				return false;
> > -		} else {
> > -			if (!isxdigit(*s++))
> > -				return false;
> > -		}
> > -	}
> > -
> > -	return true;
> > -}
> > -
> > -static void efivarfs_hex_to_guid(const char *str, efi_guid_t
> > *guid)
> > -{
> > -	guid->b[0] =3D hex_to_bin(str[6]) << 4 | hex_to_bin(str[7]);
> > -	guid->b[1] =3D hex_to_bin(str[4]) << 4 | hex_to_bin(str[5]);
> > -	guid->b[2] =3D hex_to_bin(str[2]) << 4 | hex_to_bin(str[3]);
> > -	guid->b[3] =3D hex_to_bin(str[0]) << 4 | hex_to_bin(str[1]);
> > -	guid->b[4] =3D hex_to_bin(str[11]) << 4 |
> > hex_to_bin(str[12]);
> > -	guid->b[5] =3D hex_to_bin(str[9]) << 4 |
> > hex_to_bin(str[10]);
> > -	guid->b[6] =3D hex_to_bin(str[16]) << 4 |
> > hex_to_bin(str[17]);
> > -	guid->b[7] =3D hex_to_bin(str[14]) << 4 |
> > hex_to_bin(str[15]);
> > -	guid->b[8] =3D hex_to_bin(str[19]) << 4 |
> > hex_to_bin(str[20]);
> > -	guid->b[9] =3D hex_to_bin(str[21]) << 4 |
> > hex_to_bin(str[22]);
> > -	guid->b[10] =3D hex_to_bin(str[24]) << 4 |
> > hex_to_bin(str[25]);
> > -	guid->b[11] =3D hex_to_bin(str[26]) << 4 |
> > hex_to_bin(str[27]);
> > -	guid->b[12] =3D hex_to_bin(str[28]) << 4 |
> > hex_to_bin(str[29]);
> > -	guid->b[13] =3D hex_to_bin(str[30]) << 4 |
> > hex_to_bin(str[31]);
> > -	guid->b[14] =3D hex_to_bin(str[32]) << 4 |
> > hex_to_bin(str[33]);
> > -	guid->b[15] =3D hex_to_bin(str[34]) << 4 |
> > hex_to_bin(str[35]);
> > +	return uuid_is_valid(s);
> > =C2=A0}
>=20
> I think you've confused yourself here. You've inverted the return
> value meaning for efivarfs_valid_name().
>=20
> Normally I would expect this change to be correct but uuid_is_valid()
> returns 0 for success, -EINVAL for failure. Either the function is
> misnamed or the return value semantics are wrong.

Oops, thanks for noticing this. Right the return value should be
aligned.

--=20
Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Intel Finland Oy

--
To unsubscribe from this list: send the line "unsubscribe linux-acpi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
