From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: Re: [PATCH v25 12/12] LRNG - add interface for gathering of raw entropy
Date: Wed, 20 Nov 2019 10:01:23 +0100
Message-ID: <1606105.I1uVafPBki@positron.chronox.de>
References: <6157374.ptSnyUpaCn@positron.chronox.de> <3610406.x8mDjznOIz@positron.chronox.de> <ea5e2cf5-d622-03c1-eb96-7f7e4893ae04@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <ea5e2cf5-d622-03c1-eb96-7f7e4893ae04@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-crypto@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, linux-api@vger.kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>, "Alexander E. Patrakov" <patrakov@gmail.com>, "Ahmed S. Darwish" <darwish.07@gmail.com>, "Theodore Y. Ts'o" <tytso@mit.edu>, Willy Tarreau <w@1wt.eu>, Matthew Garrett <mjg59@srcf.ucam.org>, Vito Caputo <vcaputo@pengaru.com>, Andreas Dilger <adilger.kernel@dilger.ca>, Jan Kara <jack@suse.cz>, Ray Strode <rstrode@redhat.com>, William Jon McCann <mccann@jhu.edu>, zhangjs <zachary@baishancloud.com>, Andy Lutomirski <luto@kernel.org>, Florian Weimer <fweimer@redhat.com>, Lennart Poettering <mzxreary@0pointer.de>, Nicolai Stange <nstange@sus>
List-Id: linux-api@vger.kernel.org

Am Dienstag, 19. November 2019, 18:17:55 CET schrieb Randy Dunlap:

Hi Randy,

> Hi,
>=20
> On 11/16/19 1:38 AM, Stephan M=FCller wrote:
> > diff --git a/drivers/char/lrng/Kconfig b/drivers/char/lrng/Kconfig
> > index e6ca3acc1e48..4ccc710832ef 100644
> > --- a/drivers/char/lrng/Kconfig
> > +++ b/drivers/char/lrng/Kconfig
> > @@ -169,4 +169,20 @@ config LRNG_APT_CUTOFF
> >=20
> >  	default 325 if !LRNG_APT_BROKEN
> >  	default 32 if LRNG_APT_BROKEN
> >=20
> > +config LRNG_TESTING
> > +	bool "Enable entropy test interface to LRNG noise source"
> > +	select CONFIG_DEBUG_FS
>=20
> 	That should be spelled as DEBUG_FS and preferably would be "depends on"
> 	instead of 'select'.

=46ixed.

Thank you very much.

Ciao
Stephan
