From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH v28 07/12] LRNG - add kernel crypto API PRNG extension
Date: Thu, 16 Jan 2020 07:54:00 +0100
Message-ID: <6088699.12EYreDE7o@tauon.chronox.de>
References: <6157374.ptSnyUpaCn@positron.chronox.de> <526421170.FD02tCEzJt@positron.chronox.de> <d98e7a45-3d1b-8119-1ed0-87aea0f3c6f3@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <d98e7a45-3d1b-8119-1ed0-87aea0f3c6f3@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-crypto@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, linux-api@vger.kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>, "Alexander E. Patrakov" <patrakov@gmail.com>, "Ahmed S. Darwish" <darwish.07@gmail.com>, "Theodore Y. Ts'o" <tytso@mit.edu>, Willy Tarreau <w@1wt.eu>, Matthew Garrett <mjg59@srcf.ucam.org>, Vito Caputo <vcaputo@pengaru.com>, Andreas Dilger <adilger.kernel@dilger.ca>, Jan Kara <jack@suse.cz>, Ray Strode <rstrode@redhat.com>, William Jon McCann <mccann@jhu.edu>, zhangjs <zachary@baishancloud.com>, Andy Lutomirski <luto@kernel.org>, Florian Weimer <fweimer@redhat.com>, Lennart Poettering <mzxreary@0pointer.de>, Nicolai Stange <nstange@sus>
List-Id: linux-api@vger.kernel.org

Am Donnerstag, 16. Januar 2020, 01:15:46 CET schrieb Randy Dunlap:

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
> >  drivers/char/lrng/Kconfig      |  10 +
> >  drivers/char/lrng/Makefile     |   1 +
> >  drivers/char/lrng/lrng_kcapi.c | 327 +++++++++++++++++++++++++++++++++
> >  3 files changed, 338 insertions(+)
> >  create mode 100644 drivers/char/lrng/lrng_kcapi.c
> >=20
> > diff --git a/drivers/char/lrng/Kconfig b/drivers/char/lrng/Kconfig
> > index 15fb623d9d1f..0d070a3897dd 100644
> > --- a/drivers/char/lrng/Kconfig
> > +++ b/drivers/char/lrng/Kconfig
> > @@ -80,6 +80,16 @@ config LRNG_DRBG
> >=20
> >  	  Enable the SP800-90A DRBG support for the LRNG. Once the
> >  	  module is loaded, output from /dev/random, /dev/urandom,
> >  	  getrandom(2), or get_random_bytes is provided by a DRBG.
> >=20
> > +
> > +config LRNG_KCAPI
> > +	tristate "Kernel Crypto API support for the LRNG"
> > +	select CRYPTO_RNG
>=20
> Don't select CRYPTO_RNG unless you know that CRYPTO is set/enabled.

I added "depends on CRYPTO"
>=20
> > +	help
> > +	  Enable the support for generic pseudo-random number
> > +	  generators offered by the kernel crypto API with the
> > +	  LRNG. Once the module is loaded, output from /dev/random,
> > +	  /dev/urandom, getrandom(2), or get_random_bytes is
> > +	  provided by the selected kernel crypto API RNG.
> >=20
> >  endif # LRNG_DRNG_SWITCH
> > =20
> >  endif # LRNG

Thank you.

Ciao
Stephan
