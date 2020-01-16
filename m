From: Stephan Mueller <smueller-T9tCv8IpfcWELgA04lAiVw@public.gmane.org>
Subject: Re: [PATCH v28 01/12] Linux Random Number Generator
Date: Thu, 16 Jan 2020 08:22:05 +0100
Message-ID: <5851701.o564lLvvJa@tauon.chronox.de>
References: <6157374.ptSnyUpaCn@positron.chronox.de> <2211028.KG5F5qfgHC@positron.chronox.de> <3a8d5d2d-d54f-cf18-0c93-dbe8cd91ed12@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <3a8d5d2d-d54f-cf18-0c93-dbe8cd91ed12-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Randy Dunlap <rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, "Alexander E. Patrakov" <patrakov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Ahmed S. Darwish" <darwish.07-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Theodore Y. Ts'o" <tytso-3s7WtUTddSA@public.gmane.org>, Willy Tarreau <w@1wt.eu>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, Vito Caputo <vcaputo-IiWei5kqaphBDgjK7y7TUQ@public.gmane.org>, Andreas Dilger <adilger.kernel-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, Ray Strode <rstrode-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, William Jon McCann <mccann-4GNroTWusrE@public.gmane.org>, zhangjs <zachary-+jQ8zvd9CV5SzTKKI/wJ2A@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Florian Weimer <fweimer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Lennart Poettering <mzxreary-uLTowLwuiw4b1SvskN2V4Q@public.gmane.org>, Nicolai Stange <nstange@sus>
List-Id: linux-api@vger.kernel.org

Am Donnerstag, 16. Januar 2020, 01:11:40 CET schrieb Randy Dunlap:

Hi Randy,

> Hi,
>=20
> On 1/15/20 2:31 AM, Stephan M=C3=BCller wrote:
> > CC: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
> > CC: "Alexander E. Patrakov" <patrakov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> > CC: "Ahmed S. Darwish" <darwish.07-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> > CC: "Theodore Y. Ts'o" <tytso-3s7WtUTddSA@public.gmane.org>
> > CC: Willy Tarreau <w@1wt.eu>
> > CC: Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>
> > CC: Vito Caputo <vcaputo-IiWei5kqaphBDgjK7y7TUQ@public.gmane.org>
> > CC: Andreas Dilger <adilger.kernel-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>
> > CC: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
> > CC: Ray Strode <rstrode-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > CC: William Jon McCann <mccann-4GNroTWusrE@public.gmane.org>
> > CC: zhangjs <zachary-+jQ8zvd9CV5SzTKKI/wJ2A@public.gmane.org>
> > CC: Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> > CC: Florian Weimer <fweimer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > CC: Lennart Poettering <mzxreary-uLTowLwuiw4b1SvskN2V4Q@public.gmane.org>
> > CC: Nicolai Stange <nstange-l3A5Bk7waGM@public.gmane.org>
> > Mathematical aspects Reviewed-by: "Peter, Matthias"
> > <matthias.peter-AKRvH3fzEZsb1SvskN2V4Q@public.gmane.org> Reviewed-by: Marcelo Henrique Cerri
> > <marcelo.cerri-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
> > Reviewed-by: Roman Drahtmueller <draht-UTA6Eu5RHcbyVfKhlJ+g5A@public.gmane.org>
> > Tested-by: Roman Drahtm=C3=BCller <draht-UTA6Eu5RHcbyVfKhlJ+g5A@public.gmane.org>
> > Tested-by: Marcelo Henrique Cerri <marcelo.cerri-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
> > Tested-by: Neil Horman <nhorman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > Signed-off-by: Stephan Mueller <smueller-T9tCv8IpfcWELgA04lAiVw@public.gmane.org>
> > ---
> >=20
> >  MAINTAINERS                         |   7 +
> >  drivers/char/Kconfig                |   2 +
> >  drivers/char/Makefile               |   9 +-
> >  drivers/char/lrng/Kconfig           |  67 +++
> >  drivers/char/lrng/Makefile          |   9 +
> >  drivers/char/lrng/lrng_archrandom.c |  94 ++++
> >  drivers/char/lrng/lrng_aux.c        | 148 +++++++
> >  drivers/char/lrng/lrng_chacha20.c   | 265 ++++++++++++
> >  drivers/char/lrng/lrng_chacha20.h   |  25 ++
> >  drivers/char/lrng/lrng_drng.c       | 400 +++++++++++++++++
> >  drivers/char/lrng/lrng_interfaces.c | 638 ++++++++++++++++++++++++++++
> >  drivers/char/lrng/lrng_internal.h   | 296 +++++++++++++
> >  drivers/char/lrng/lrng_lfsr.h       | 152 +++++++
> >  drivers/char/lrng/lrng_pool.c       | 588 +++++++++++++++++++++++++
> >  drivers/char/lrng/lrng_sw_noise.c   | 102 +++++
> >  drivers/char/lrng/lrng_sw_noise.h   |  57 +++
> >  include/linux/lrng.h                |  63 +++
> >  17 files changed, 2921 insertions(+), 1 deletion(-)
> >  create mode 100644 drivers/char/lrng/Kconfig
> >  create mode 100644 drivers/char/lrng/Makefile
> >  create mode 100644 drivers/char/lrng/lrng_archrandom.c
> >  create mode 100644 drivers/char/lrng/lrng_aux.c
> >  create mode 100644 drivers/char/lrng/lrng_chacha20.c
> >  create mode 100644 drivers/char/lrng/lrng_chacha20.h
> >  create mode 100644 drivers/char/lrng/lrng_drng.c
> >  create mode 100644 drivers/char/lrng/lrng_interfaces.c
> >  create mode 100644 drivers/char/lrng/lrng_internal.h
> >  create mode 100644 drivers/char/lrng/lrng_lfsr.h
> >  create mode 100644 drivers/char/lrng/lrng_pool.c
> >  create mode 100644 drivers/char/lrng/lrng_sw_noise.c
> >  create mode 100644 drivers/char/lrng/lrng_sw_noise.h
> >  create mode 100644 include/linux/lrng.h
> >=20
> > diff --git a/drivers/char/lrng/Kconfig b/drivers/char/lrng/Kconfig
> > new file mode 100644
> > index 000000000000..56f13efd3592
> > --- /dev/null
> > +++ b/drivers/char/lrng/Kconfig
> > @@ -0,0 +1,67 @@
> > +# SPDX-License-Identifier: GPL-2.0
> > +#
> > +# Linux Random Number Generator configuration
> > +#
> > +
> > +menuconfig LRNG
> > +	bool "Linux Random Number Generator"
>=20
> This should probably depend on CRYPTO and/or some other CRYPTO_xxx symbol=
s.
> Or (worst case) select them.  :(

It does not - all CRYPTO related code is limited into the lrng_drbg.c,=20
lrng_kcapi.c and lrng_jent.c which are all guarded by a Kconfig option.
>=20
> This message (when CONFIG_CRYPTO is disabled and no crypto facilities are
> enabled) should be avoidable when the correct Kconfig entries are used:
>=20
> ../drivers/char/lrng/lrng_drbg.c:38:2: error: #error "Unknown DRBG in use"
>  #error "Unknown DRBG in use"

Right - this should now be fixed with a depends on CRYPTO for the=20
aforementioned 3 C files which have an equal entry in Kconfig.
>=20
> > +	help
> > +	  The Linux Random Number Generator (LRNG) is the replacement
> > +	  of the existing /dev/random provided with drivers/char/random.c.
> > +	  It generates entropy from different noise sources and
> > +	  delivers significant entropy during boot.
> > +
> > +if LRNG
> > +
> > +choice
> > +	prompt "LRNG Entropy Pool Size"
> > +	default LRNG_POOL_SIZE_4096
> > +	help
> > +	  Select the size of the LRNG entropy pool. The size of the
> > +	  entropy pool is relevant for the amount of entropy that
> > +	  the LRNG can maintain as a maximum. The larger the size
> > +	  of the entropy pool is the more entropy can be maintained
> > +	  but the less often older entropic values are overwritten
> > +	  with new entropy.
> > +
> > +	config LRNG_POOL_SIZE_512
> > +		bool "512 bits"
> > +
> > +	config LRNG_POOL_SIZE_1024
> > +		bool "1024 bits"
> > +
> > +	config LRNG_POOL_SIZE_2048
> > +		bool "2048 bits"
> > +
> > +	config LRNG_POOL_SIZE_4096
> > +		bool "4096 bits (default)"
> > +
> > +	config LRNG_POOL_SIZE_8192
> > +		bool "8192 bits"
> > +
> > +	config LRNG_POOL_SIZE_16384
> > +		bool "16384 bits"
> > +
> > +	config LRNG_POOL_SIZE_32768
> > +		bool "32768 bits"
> > +
> > +	config LRNG_POOL_SIZE_65536
> > +		bool "65536 bits"
> > +
> > +	config LRNG_POOL_SIZE_131072
> > +		bool "131072 bits"
> > +endchoice
> > +
> > +config LRNG_POOL_SIZE
> > +	int
> > +	default 0 if LRNG_POOL_SIZE_512
> > +	default 1 if LRNG_POOL_SIZE_1024
> > +	default 2 if LRNG_POOL_SIZE_2048
> > +	default 3 if LRNG_POOL_SIZE_4096
> > +	default 4 if LRNG_POOL_SIZE_8192
> > +	default 5 if LRNG_POOL_SIZE_16384
> > +	default 6 if LRNG_POOL_SIZE_32768
> > +	default 7 if LRNG_POOL_SIZE_65536
> > +	default 8 if LRNG_POOL_SIZE_131072
> > +
> > +endif # LRNG
> >=20
> > diff --git a/drivers/char/lrng/lrng_archrandom.c
> > b/drivers/char/lrng/lrng_archrandom.c new file mode 100644
> > index 000000000000..eeba708d025f
> > --- /dev/null
> > +++ b/drivers/char/lrng/lrng_archrandom.c
> > @@ -0,0 +1,94 @@
> > +// SPDX-License-Identifier: GPL-2.0 OR BSD-2-Clause
> > +/*
> > + * LRNG Fast Noise Source: CPU-based noise source
> > + *
> > + * Copyright (C) 2016 - 2020, Stephan Mueller <smueller-T9tCv8IpfcWELgA04lAiVw@public.gmane.org>
> > + */
> > +
> > +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> > +
> > +#include <linux/random.h>
> > +
> > +#include "lrng_internal.h"
> > +
> > +/*
> > + * Estimated entropy of data is a 32th of
> > LRNG_DRNG_SECURITY_STRENGTH_BITS. + * As we have no ability to review t=
he
> > implementation of those noise sources, + * it is prudent to have a
> > conservative estimate here.
> > + */
> > +#define LRNG_ARCHRANDOM_DEFAULT_STRENGTH
> > (LRNG_DRNG_SECURITY_STRENGTH_BITS>>5) +#define
> > LRNG_ARCHRANDOM_TRUST_CPU_STRENGTH LRNG_DRNG_SECURITY_STRENGTH_BITS
> > +#ifdef CONFIG_RANDOM_TRUST_CPU
> > +static u32 archrandom =3D LRNG_ARCHRANDOM_TRUST_CPU_STRENGTH;
> > +#else
> > +static u32 archrandom =3D LRNG_ARCHRANDOM_DEFAULT_STRENGTH;
> > +#endif
> > +module_param(archrandom, uint, 0644);
> > +MODULE_PARM_DESC(archrandom, "Entropy in bits of 256 data bits from CPU
> > noise " +			     "source (e.g. RDRAND)");
>=20
> Please put the string on one line like several other MODULE_PARM_DESC() a=
re
> done:
>=20
> +MODULE_PARM_DESC(archrandom,
> +		"Entropy in bits of 256 data bits from CPU noise source (e.g.=20
RDRAND)");

Done.
>=20
>=20
> With CONFIG_CRYPTO disabled, these warnings happen:
>=20
> WARNING: unmet direct dependencies detected for CRYPTO_DRBG_MENU
>   Depends on [n]: CRYPTO [=3Dn]
>   Selected by [m]:
>   - LRNG_DRBG [=3Dm] && LRNG [=3Dy] && LRNG_DRNG_SWITCH [=3Dy]
>=20
> WARNING: unmet direct dependencies detected for CRYPTO_RNG
>   Depends on [n]: CRYPTO [=3Dn]
>   Selected by [m]:
>   - LRNG_KCAPI [=3Dm] && LRNG [=3Dy] && LRNG_DRNG_SWITCH [=3Dy]
>=20
> ../drivers/char/lrng/lrng_drbg.c: In function =E2=80=98lrng_hash_name=E2=
=80=99:
> ../drivers/char/lrng/lrng_drbg.c:225:1: warning: control reaches end of
> non-void function [-Wreturn-type] }
>  ^
> ../drivers/char/lrng/lrng_drbg.c: In function =E2=80=98lrng_drbg_name=E2=
=80=99:
> ../drivers/char/lrng/lrng_drbg.c:220:1: warning: control reaches end of
> non-void function [-Wreturn-type] }
>  ^
>=20
> and build errors happen also, which can be prevented with Kconfig fixes.

With the changes to the Kconfig file as explained in the other emails, I ca=
n=20
successfully compile the LRNG without the crypto API being enabled.

Thank you for pointing that one out.

Ciao
Stephan
