From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH v27 12/12] LRNG - add power-on and runtime self-tests
Date: Fri, 10 Jan 2020 08:48:22 +0100
Message-ID: <4114256.cnP6sY5xnJ@tauon.chronox.de>
References: <6157374.ptSnyUpaCn@positron.chronox.de> <2355906.JbblJTOqSk@positron.chronox.de> <2f225250-c1e1-c6e1-026c-9c63853ab7d1@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <2f225250-c1e1-c6e1-026c-9c63853ab7d1@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-crypto@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, linux-api@vger.kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>, "Alexander E. Patrakov" <patrakov@gmail.com>, "Ahmed S. Darwish" <darwish.07@gmail.com>, "Theodore Y. Ts'o" <tytso@mit.edu>, Willy Tarreau <w@1wt.eu>, Matthew Garrett <mjg59@srcf.ucam.org>, Vito Caputo <vcaputo@pengaru.com>, Andreas Dilger <adilger.kernel@dilger.ca>, Jan Kara <jack@suse.cz>, Ray Strode <rstrode@redhat.com>, William Jon McCann <mccann@jhu.edu>, zhangjs <zachary@baishancloud.com>, Andy Lutomirski <luto@kernel.org>, Florian Weimer <fweimer@redhat.com>, Lennart Poettering <mzxreary@0pointer.de>, Nicolai Stange <nstange@sus>
List-Id: linux-api@vger.kernel.org

Am Freitag, 10. Januar 2020, 01:22:51 CET schrieb Randy Dunlap:

Hi Randy,

> Hi,
>=20
> On 1/9/20 12:35 AM, Stephan M=FCller wrote:
> > ---
> >=20
> >  drivers/char/lrng/Kconfig         |  25 ++
> >  drivers/char/lrng/Makefile        |   1 +
> >  drivers/char/lrng/lrng_selftest.c | 418 ++++++++++++++++++++++++++++++
> >  3 files changed, 444 insertions(+)
> >  create mode 100644 drivers/char/lrng/lrng_selftest.c
> >=20
> > diff --git a/drivers/char/lrng/Kconfig b/drivers/char/lrng/Kconfig
> > index 394066aa5a86..e9827e7df715 100644
> > --- a/drivers/char/lrng/Kconfig
> > +++ b/drivers/char/lrng/Kconfig
> > @@ -175,4 +175,29 @@ config LRNG_TESTING
> >=20
> >  	  If unsure, say N.
> >=20
> > +config LRNG_SELFTEST
> > +	bool "Enable power-on and on-demand self-tests"
> > +	help
> > +	  The power-on self tests are executed during boot time
>=20
> 	               self-tests

=46ixed in all occurrences. Thank you.
>=20
> > +	  covering the ChaCha20 DRNG, the LFSR processing and the
> > +	  time stamp management of the LRNG.
> > +
> > +	  The on-demand self-tests are triggered by writing any
> > +	  value into the SysFS file selftest_status. At the same
> > +	  time, when reading this file, the test status is
> > +	  returned. A zero indicates that all tests were executed
> > +	  successfully.
> > +
> > +	  If unsure, say Y.
> > +
> > +if LRNG_SELFTEST
> > +
> > +config LRNG_SELFTEST_PANIC
> > +	bool "Panic the kernel upon self-test failure"
> > +	help
> > +	  If the option is enabled, the kernel is terminated if an
> > +	  LRNG power-on self-test failure is detected.
> > +
> > +endif # LRNG_SELFTEST
> > +
> >=20
> >  endif # LRNG



Ciao
Stephan
