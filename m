From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH v28 09/12] LRNG - add Jitter RNG fast noise source
Date: Thu, 16 Jan 2020 07:51:45 +0100
Message-ID: <6364272.m6LlNysOQA@tauon.chronox.de>
References: <6157374.ptSnyUpaCn@positron.chronox.de> <2704719.5neY5jeiZ3@positron.chronox.de> <e354fe2f-2040-689a-4293-e1d919f14b74@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-crypto-owner@vger.kernel.org>
In-Reply-To: <e354fe2f-2040-689a-4293-e1d919f14b74@infradead.org>
Sender: linux-crypto-owner@vger.kernel.org
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-crypto@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, linux-api@vger.kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>, "Alexander E. Patrakov" <patrakov@gmail.com>, "Ahmed S. Darwish" <darwish.07@gmail.com>, "Theodore Y. Ts'o" <tytso@mit.edu>, Willy Tarreau <w@1wt.eu>, Matthew Garrett <mjg59@srcf.ucam.org>, Vito Caputo <vcaputo@pengaru.com>, Andreas Dilger <adilger.kernel@dilger.ca>, Jan Kara <jack@suse.cz>, Ray Strode <rstrode@redhat.com>, William Jon McCann <mccann@jhu.edu>, zhangjs <zachary@baishancloud.com>, Andy Lutomirski <luto@kernel.org>, Florian Weimer <fweimer@redhat.com>, Lennart Poettering <mzxreary@0pointer.de>, Nicolai Stange <nstange@sus>
List-Id: linux-api@vger.kernel.org

Am Donnerstag, 16. Januar 2020, 01:17:05 CET schrieb Randy Dunlap:

Hi Randy,

> On 1/15/20 2:34 AM, Stephan M=FCller wrote:
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
> > Reviewed-by: Marcelo Henrique Cerri <marcelo.cerri@canonical.com>
> > Reviewed-by: Roman Drahtmueller <draht@schaltsekun.de>
> > Tested-by: Roman Drahtm=FCller <draht@schaltsekun.de>
> > Tested-by: Marcelo Henrique Cerri <marcelo.cerri@canonical.com>
> > Tested-by: Neil Horman <nhorman@redhat.com>
> > Signed-off-by: Stephan Mueller <smueller@chronox.de>
> > ---
> >=20
> >  drivers/char/lrng/Kconfig     | 11 +++++
> >  drivers/char/lrng/Makefile    |  1 +
> >  drivers/char/lrng/lrng_jent.c | 89 +++++++++++++++++++++++++++++++++++
> >  3 files changed, 101 insertions(+)
> >  create mode 100644 drivers/char/lrng/lrng_jent.c
> >=20
> > diff --git a/drivers/char/lrng/Kconfig b/drivers/char/lrng/Kconfig
> > index 0d070a3897dd..10b7cbdb8c8e 100644
> > --- a/drivers/char/lrng/Kconfig
> > +++ b/drivers/char/lrng/Kconfig
> > @@ -92,4 +92,15 @@ config LRNG_KCAPI
> >=20
> >  	  provided by the selected kernel crypto API RNG.
> > =20
> >  endif # LRNG_DRNG_SWITCH
> >=20
> > +config LRNG_JENT
> > +	bool "Enable Jitter RNG as LRNG Seed Source"
> > +	select CRYPTO_JITTERENTROPY
>=20
> Don't select unless CRYPTO is already set/enabled.

I added "depends on=20
>=20
> > +	help
> > +	  The Linux RNG may use the Jitter RNG as noise source. Enabling
> > +	  this option enables the use of the Jitter RNG. Its default
> > +	  entropy level is 16 bits of entropy per 256 data bits delivered
> > +	  by the Jitter RNG. This entropy level can be changed at boot
> > +	  time or at runtime with the lrng_base.jitterrng configuration
> > +	  variable.
> > +
> >=20
> >  endif # LRNG
> >=20
> > diff --git a/drivers/char/lrng/lrng_jent.c b/drivers/char/lrng/lrng_jen=
t.c
> > new file mode 100644
> > index 000000000000..ff0bbe2680c4
> > --- /dev/null
> > +++ b/drivers/char/lrng/lrng_jent.c
> > @@ -0,0 +1,89 @@
> > +// SPDX-License-Identifier: GPL-2.0 OR BSD-2-Clause
> > +/*
> > + * LRNG Fast Noise Source: Jitter RNG
> > + *
> > + * Copyright (C) 2016 - 2020, Stephan Mueller <smueller@chronox.de>
> > + */
> > +
> > +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> > +
> > +#include <linux/types.h>
> > +#include <crypto/internal/jitterentropy.h>
> > +
> > +#include "lrng_internal.h"
> > +
> > +/*
> > + * Estimated entropy of data is a 16th of
> > LRNG_DRNG_SECURITY_STRENGTH_BITS. + * Albeit a full entropy assessment =
is
> > provided for the noise source indicating + * that it provides high
> > entropy rates and considering that it deactivates + * when it detects
> > insufficient hardware, the chosen under estimation of + * entropy is
> > considered to be acceptable to all reviewers.
> > + */
> > +static u32 jitterrng =3D LRNG_DRNG_SECURITY_STRENGTH_BITS>>4;
> > +module_param(jitterrng, uint, 0644);
> > +MODULE_PARM_DESC(jitterrng, "Entropy in bits of 256 data bits from Jit=
ter
> > " +			    "RNG noise source");
>=20
> One line for the string, please, not split to 2 lines.

Changed.

Thank you.

Ciao
Stephan
