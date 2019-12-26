From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH v3 0/8] Rework random blocking
Date: Thu, 26 Dec 2019 12:40:38 +0100
Message-ID: <8794771.pXx7ivobnm@tauon.chronox.de>
References: <cover.1577088521.git.luto@kernel.org> <9872655.prSdhymlXK@positron.chronox.de> <20191226100334.bsh3b3dphs4j4cvx@srcf.ucam.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20191226100334.bsh3b3dphs4j4cvx@srcf.ucam.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Andy Lutomirski <luto@kernel.org>, Ted Ts'o <tytso@mit.edu>, LKML <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Kees Cook <keescook@chromium.org>, "Jason A. Donenfeld" <Jason@zx2c4.com>, "Ahmed S. Darwish" <darwish.07@gmail.com>, Lennart Poettering <mzxreary@0pointer.de>, "Eric W. Biederman" <ebiederm@xmission.com>, "Alexander E. Patrakov" <patrakov@gmail.com>, Michael Kerrisk <mtk.manpages@gmail.com>, Willy Tarreau <w@1wt.eu>, Ext4 Developers List <linux-ext4@vger.kernel.org>, linux-man <linux-man@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

Am Donnerstag, 26. Dezember 2019, 11:03:34 CET schrieb Matthew Garrett:

Hi Matthew,

> On Thu, Dec 26, 2019 at 10:29:00AM +0100, Stephan M=FCller wrote:
> > What about offering a compile-time option to enable or disable such cod=
e?
> > Note, with the existing random.c code base, there is no need to have a
> > separate blocking_pool. The ChaCha20 DRNG could be used for that very s=
ame
> > purpose, provided that in case these true random numbers are generated
> > when
> > the Chacha20 DRNG received an equal amount of "unused" entropy.
>=20
> I think it's reasonable to offer such an option as long as it's made
> clear that it'll break userland and should only be enabled under very
> weird circumstances. We don't want to end up in a situation where
> userland developers feel that they need to code to handle such
> situations - the only people who care about this distinction should be
> in control of their userland stack and able to cope with the
> consequences.

Ok.
>=20
> > If an unprivileged caller requests true random data, at least 1024 bits=
 of
> > entropy is left in the pool. I.e. all entropy above that point is
> > available
> > for this request type. Note, even namespaces fall into this category
> > considering that unprivileged users can create a user name space in whi=
ch
> > they can become root.
>=20
> I also feel like describing any of this as "true random data" is
> misleading. Most of our entropy sources are devices that could, given
> sufficient information, be modelled accurately. We're not sampling
> quantum events here.

I am fine using any terminology that fits.

The terminology I used comes from the German AIS 31:

"""
True RNG: A device or mechanism for which the output values depend on some=
=20
unpredictable source (noise source, entropy source) that produces entropy.

Note: The class of TRNGs splits into two subclasses (PTRNGs and NPTRNGs).
"""

Bottom line, a TRNG produces random numbers at an equal rate as the underly=
ing=20
noise source produces entropy. E.g. if the noise source produces 10 bits of=
=20
entropy, the RNG shall only generate 10 bits of random data.

A physical TRNG (PTRNG) uses a physical phenomenon like shot noise of a dio=
de=20
in a ring oscillator. Commonly, stochastical models can be created for thos=
e=20
noise sources.

A non-physical TRNG (NPTRNG) uses non-physical phenomenons like timing of=20
events as noise source. The random.c or my LRNG are NPTRNGs. For NPTRNGs it=
 is=20
unlikely that there is a stochastical model.


Ciao
Stephan
