From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH v28 06/12] LRNG - add SP800-90A DRBG extension
Date: Thu, 16 Jan 2020 07:55:40 +0100
Message-ID: <54845098.RitduxjIfl@tauon.chronox.de>
References: <6157374.ptSnyUpaCn@positron.chronox.de> <12396284.QuoJzrrf7p@positron.chronox.de> <55a89cdf-e36d-fb36-29fa-46ebfb139294@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-crypto-owner@vger.kernel.org>
In-Reply-To: <55a89cdf-e36d-fb36-29fa-46ebfb139294@infradead.org>
Sender: linux-crypto-owner@vger.kernel.org
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-crypto@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, linux-api@vger.kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>, "Alexander E. Patrakov" <patrakov@gmail.com>, "Ahmed S. Darwish" <darwish.07@gmail.com>, "Theodore Y. Ts'o" <tytso@mit.edu>, Willy Tarreau <w@1wt.eu>, Matthew Garrett <mjg59@srcf.ucam.org>, Vito Caputo <vcaputo@pengaru.com>, Andreas Dilger <adilger.kernel@dilger.ca>, Jan Kara <jack@suse.cz>, Ray Strode <rstrode@redhat.com>, William Jon McCann <mccann@jhu.edu>, zhangjs <zachary@baishancloud.com>, Andy Lutomirski <luto@kernel.org>, Florian Weimer <fweimer@redhat.com>, Lennart Poettering <mzxreary@0pointer.de>, Nicolai Stange <nstange@sus>
List-Id: linux-api@vger.kernel.org

Am Donnerstag, 16. Januar 2020, 01:14:35 CET schrieb Randy Dunlap:

Hi Randy,

> On 1/15/20 2:33 AM, Stephan M=FCller wrote:
> > CC: "Eric W. Biederman" <ebiederm@xmission.com>
> > CC: "Alexander E. Patrakov" <patrakov@gmail.com>
> > CC: "Ahmed S. Darwish" <darwish.07@gmail.com>
> > CC: "Theodore Y. Ts'o" <tytso@mit.edu>
> > CC: Willy Tarreau <w@1wt.eu>
> > CC: Matthew Garrett <mjg59@srcf.ucam.org>
> > CC: Vito Caputo <vcaputo@pengaru.com>
> > CC: Andreas Dilger <adilger.kernel@dilger.ca>
> > CC: Jan Kara <jack@suse.cz>
> > CC: Ray Strode <rstrode@redhat.com>
> > CC: William Jon McCann <mccann@jhu.edu>
> > CC: zhangjs <zachary@baishancloud.com>
> > CC: Andy Lutomirski <luto@kernel.org>
> > CC: Florian Weimer <fweimer@redhat.com>
> > CC: Lennart Poettering <mzxreary@0pointer.de>
> > CC: Nicolai Stange <nstange@suse.de>
> > Reviewed-by: Roman Drahtmueller <draht@schaltsekun.de>
> > Tested-by: Roman Drahtm=FCller <draht@schaltsekun.de>
> > Tested-by: Marcelo Henrique Cerri <marcelo.cerri@canonical.com>
> > Tested-by: Neil Horman <nhorman@redhat.com>
> > Signed-off-by: Stephan Mueller <smueller@chronox.de>
> > ---
> >=20
> >  drivers/char/lrng/Kconfig     |  11 ++
> >  drivers/char/lrng/Makefile    |   1 +
> >  drivers/char/lrng/lrng_drbg.c | 260 ++++++++++++++++++++++++++++++++++
> >  3 files changed, 272 insertions(+)
> >  create mode 100644 drivers/char/lrng/lrng_drbg.c
> >=20
> > diff --git a/drivers/char/lrng/Kconfig b/drivers/char/lrng/Kconfig
> > index cb701bb0b8b6..15fb623d9d1f 100644
> > --- a/drivers/char/lrng/Kconfig
> > +++ b/drivers/char/lrng/Kconfig
> > @@ -71,4 +71,15 @@ menuconfig LRNG_DRNG_SWITCH
> >=20
> >  	  accessible via the external interfaces. With this configuration
> >  	  option other DRNGs can be selected and loaded at runtime.
> >=20
> > +if LRNG_DRNG_SWITCH
> > +config LRNG_DRBG
> > +	tristate "SP800-90A support for the LRNG"
> > +	select CRYPTO_DRBG_MENU
> > +	select CRYPTO_CMAC if CRYPTO_DRBG_CTR
>=20
> Don't select these if CRYPTO is not already set/enabled.
> It causes Kconfig warnings and possible build errors.

I added "depends on CRYPTO"
>=20
> > +	help
> > +	  Enable the SP800-90A DRBG support for the LRNG. Once the
> > +	  module is loaded, output from /dev/random, /dev/urandom,
> > +	  getrandom(2), or get_random_bytes is provided by a DRBG.
> > +endif # LRNG_DRNG_SWITCH
> > +
> >=20
> >  endif # LRNG
> >=20
> > diff --git a/drivers/char/lrng/lrng_drbg.c b/drivers/char/lrng/lrng_drb=
g.c
> > new file mode 100644
> > index 000000000000..8bf2badb1fe0
> > --- /dev/null
> > +++ b/drivers/char/lrng/lrng_drbg.c
> > @@ -0,0 +1,260 @@
> > +// SPDX-License-Identifier: GPL-2.0 OR BSD-2-Clause
> > +/*
> > + * Backend for the LRNG providing the cryptographic primitives using t=
he
> > + * kernel crypto API and its DRBG.
> > + *
> > + * Copyright (C) 2016 - 2020, Stephan Mueller <smueller@chronox.de>
> > + */
> > +
> > +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> > +
> > +#include <crypto/drbg.h>
> > +#include <linux/init.h>
> > +#include <linux/module.h>
> > +#include <linux/lrng.h>
> > +
> > +/*
> > + * Define a DRBG plus a hash / MAC used to extract data from the entro=
py
> > pool. + * For LRNG_HASH_NAME you can use a hash or a MAC (HMAC or CMAC)
> > of your choice + * (Note, you should use the suggested selections below
> > -- using SHA-1 or MD5 + * is not wise). The idea is that the used cipher
> > primitive can be selected to + * be the same as used for the DRBG. I.e.
> > the LRNG only uses one cipher + * primitive using the same cipher
> > implementation with the options offered in + * the following. This mean=
s,
> > if the CTR DRBG is selected and AES-NI is present, + * both the CTR DRBG
> > and the selected cmac(aes) use AES-NI.
> > + *
> > + * The security strengths of the DRBGs are all 256 bits according to
> > + * SP800-57 section 5.6.1.
> > + *
> > + * This definition is allowed to be changed.
> > + */
> > +#ifdef CONFIG_CRYPTO_DRBG_CTR
> > +static unsigned int lrng_drbg_type =3D 0;
> > +#elif defined CONFIG_CRYPTO_DRBG_HMAC
> > +static unsigned int lrng_drbg_type =3D 1;
> > +#elif defined CONFIG_CRYPTO_DRBG_HASH
> > +static unsigned int lrng_drbg_type =3D 2;
> > +#else
> > +#error "Unknown DRBG in use"
> > +#endif
> > +
> > +/* The parameter must be r/o in sysfs as otherwise races appear. */
> > +module_param(lrng_drbg_type, uint, 0444);
> > +MODULE_PARM_DESC(lrng_drbg_type, "DRBG type used for LRNG (0->CTR_DRBG=
, "
> > +				 "1->HMAC_DRBG, 2->Hash_DRBG)");
>=20
> One line for the string, please, not split.

Changed

Thank you.

Ciao
Stephan
