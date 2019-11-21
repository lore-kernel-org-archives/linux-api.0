From: Neil Horman <nhorman@redhat.com>
Subject: Re: [PATCH v25 09/12] LRNG - add Jitter RNG fast noise source
Date: Thu, 21 Nov 2019 09:19:30 -0500
Message-ID: <20191121141930.GB27405@hmswarspite.think-freely.org>
References: <6157374.ptSnyUpaCn@positron.chronox.de>
 <2377947.mlgTlHak1g@positron.chronox.de>
 <20191120133303.GA28341@hmswarspite.think-freely.org>
 <1844272.AK0ElEJLVa@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1844272.AK0ElEJLVa@positron.chronox.de>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Stephan =?iso-8859-1?Q?M=FCller?= <smueller@chronox.de>
Cc: Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-crypto@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, linux-api@vger.kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>, "Alexander E. Patrakov" <patrakov@gmail.com>, "Ahmed S. Darwish" <darwish.07@gmail.com>, "Theodore Y. Ts'o" <tytso@mit.edu>, Willy Tarreau <w@1wt.eu>, Matthew Garrett <mjg59@srcf.ucam.org>, Vito Caputo <vcaputo@pengaru.com>, Andreas Dilger <adilger.kernel@dilger.ca>, Jan Kara <jack@suse.cz>, Ray Strode <rstrode@redhat.com>, William Jon McCann <mccann@jhu.edu>, zhangjs <zachary@baishancloud.com>, Andy Lutomirski <luto@kernel.org>, Florian Weimer <fweimer@redhat.com>, Lennart Poettering <mzxreary@0pointer.de>, Nicolai Stange <nstange@sus>
List-Id: linux-api@vger.kernel.org

On Wed, Nov 20, 2019 at 09:07:13PM +0100, Stephan M=FCller wrote:
> Am Mittwoch, 20. November 2019, 14:33:03 CET schrieb Neil Horman:
>=20
> Hi Neil,
>=20
> > On Sat, Nov 16, 2019 at 10:36:52AM +0100, Stephan M=FCller wrote:
> > > The Jitter RNG fast noise source implemented as part of the kernel
> > > crypto API is queried for 256 bits of entropy at the time the seed
> > > buffer managed by the LRNG is about to be filled.
> > >=20
> > > CC: "Eric W. Biederman" <ebiederm@xmission.com>
> > > CC: "Alexander E. Patrakov" <patrakov@gmail.com>
> > > CC: "Ahmed S. Darwish" <darwish.07@gmail.com>
> > > CC: "Theodore Y. Ts'o" <tytso@mit.edu>
> > > CC: Willy Tarreau <w@1wt.eu>
> > > CC: Matthew Garrett <mjg59@srcf.ucam.org>
> > > CC: Vito Caputo <vcaputo@pengaru.com>
> > > CC: Andreas Dilger <adilger.kernel@dilger.ca>
> > > CC: Jan Kara <jack@suse.cz>
> > > CC: Ray Strode <rstrode@redhat.com>
> > > CC: William Jon McCann <mccann@jhu.edu>
> > > CC: zhangjs <zachary@baishancloud.com>
> > > CC: Andy Lutomirski <luto@kernel.org>
> > > CC: Florian Weimer <fweimer@redhat.com>
> > > CC: Lennart Poettering <mzxreary@0pointer.de>
> > > CC: Nicolai Stange <nstange@suse.de>
> > > Reviewed-by: Marcelo Henrique Cerri <marcelo.cerri@canonical.com>
> > > Reviewed-by: Roman Drahtmueller <draht@schaltsekun.de>
> > > Tested-by: Roman Drahtm=FCller <draht@schaltsekun.de>
> > > Tested-by: Marcelo Henrique Cerri <marcelo.cerri@canonical.com>
> > > Tested-by: Neil Horman <nhorman@redhat.com>
> > > Signed-off-by: Stephan Mueller <smueller@chronox.de>
> > > ---
> > >=20
> > >  drivers/char/lrng/Kconfig     | 11 +++++
> > >  drivers/char/lrng/Makefile    |  1 +
> > >  drivers/char/lrng/lrng_jent.c | 88 +++++++++++++++++++++++++++++++++=
++
> > >  3 files changed, 100 insertions(+)
> > >  create mode 100644 drivers/char/lrng/lrng_jent.c
> > >=20
> > > diff --git a/drivers/char/lrng/Kconfig b/drivers/char/lrng/Kconfig
> > > index 03e6e2ec356b..80fc723c67d2 100644
> > > --- a/drivers/char/lrng/Kconfig
> > > +++ b/drivers/char/lrng/Kconfig
> > > @@ -80,4 +80,15 @@ config LRNG_KCAPI
> > >=20
> > >  =09  provided by the selected kernel crypto API RNG.
> > > =20
> > >  endif # LRNG_DRNG_SWITCH
> > >=20
> > > +config LRNG_JENT
> > > +=09bool "Enable Jitter RNG as LRNG Seed Source"
> > > +=09select CRYPTO_JITTERENTROPY
> > > +=09help
> > > +=09  The Linux RNG may use the Jitter RNG as noise source. Enabling
> > > +=09  this option enables the use of the Jitter RNG. Its default
> > > +=09  entropy level is 16 bits of entropy per 256 data bits delivered
> > > +=09  by the Jitter RNG. This entropy level can be changed at boot
> > > +=09  time or at runtime with the lrng_base.jitterrng configuration
> > > +=09  variable.
> > > +
> > >=20
> > >  endif # LRNG
> > >=20
> > > diff --git a/drivers/char/lrng/Makefile b/drivers/char/lrng/Makefile
> > > index 027b6ea51c20..a87d800c9aae 100644
> > > --- a/drivers/char/lrng/Makefile
> > > +++ b/drivers/char/lrng/Makefile
> > > @@ -13,3 +13,4 @@ obj-$(CONFIG_SYSCTL)=09=09+=3D lrng_proc.o
> > >=20
> > >  obj-$(CONFIG_LRNG_DRNG_SWITCH)=09+=3D lrng_switch.o
> > >  obj-$(CONFIG_LRNG_DRBG)=09=09+=3D lrng_drbg.o
> > >  obj-$(CONFIG_LRNG_KCAPI)=09+=3D lrng_kcapi.o
> > >=20
> > > +obj-$(CONFIG_LRNG_JENT)=09=09+=3D lrng_jent.o
> > > diff --git a/drivers/char/lrng/lrng_jent.c b/drivers/char/lrng/lrng_j=
ent.c
> > > new file mode 100644
> > > index 000000000000..43114a44b8f5
> > > --- /dev/null
> > > +++ b/drivers/char/lrng/lrng_jent.c
> > > @@ -0,0 +1,88 @@
> > > +// SPDX-License-Identifier: GPL-2.0 OR BSD-2-Clause
> > > +/*
> > > + * LRNG Fast Noise Source: Jitter RNG
> > > + *
> > > + * Copyright (C) 2016 - 2019, Stephan Mueller <smueller@chronox.de>
> > > + */
> > > +
> > > +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> > > +
> > > +#include "lrng_internal.h"
> > > +
> > > +/*
> > > + * Estimated entropy of data is a 16th of
> > > LRNG_DRNG_SECURITY_STRENGTH_BITS. + * Albeit a full entropy assessmen=
t is
> > > provided for the noise source indicating + * that it provides high
> > > entropy rates and considering that it deactivates + * when it detects
> > > insufficient hardware, the chosen under estimation of + * entropy is
> > > considered to be acceptable to all reviewers.
> > > + */
> > > +static u32 jitterrng =3D LRNG_DRNG_SECURITY_STRENGTH_BITS>>4;
> > > +module_param(jitterrng, uint, 0644);
> > > +MODULE_PARM_DESC(jitterrng, "Entropy in bits of 256 data bits from J=
itter
> > > " +=09=09=09    "RNG noise source");
> > > +
> > > +/**
> > > + * Get Jitter RNG entropy
> > > + *
> > > + * @outbuf buffer to store entropy
> > > + * @outbuflen length of buffer
> > > + * @return > 0 on success where value provides the added entropy in =
bits
> > > + *=09   0 if no fast source was available
> > > + */
> > > +struct rand_data;
> > > +struct rand_data *jent_lrng_entropy_collector(void);
> > > +int jent_read_entropy(struct rand_data *ec, unsigned char *data,
> > > +=09=09      unsigned int len);
> > > +static struct rand_data *lrng_jent_state;
> > > +
> > > +u32 lrng_get_jent(u8 *outbuf, unsigned int outbuflen)
> > > +{
> > > +=09int ret;
> > > +=09u32 ent_bits =3D jitterrng;
> > > +=09unsigned long flags;
> > > +=09static DEFINE_SPINLOCK(lrng_jent_lock);
> > > +=09static int lrng_jent_initialized =3D 0;
> > > +
> > > +=09spin_lock_irqsave(&lrng_jent_lock, flags);
> > > +
> > > +=09if (!ent_bits || (lrng_jent_initialized =3D=3D -1)) {
> > > +=09=09spin_unlock_irqrestore(&lrng_jent_lock, flags);
> > > +=09=09return 0;
> > > +=09}
> > > +
> >=20
> > this works, but I think you can avoid the use of the spin lock on the r=
ead
> > calls here.  If you assign a global pointer to the value of
> > &lrng_jent_state on init, you can just take the spinlock on assignment,=
 and
> > assume its stable after that (which it should be given that its only ev=
er
> > going to point to a static data structure).
>=20
> It is correct that the lock protects the assignment of the data structure=
.
>=20
> But the Jitter RNG itself is not multi-threaded. So, a form of serializat=
ion=20
> is needed to also "read" data from the Jitter RNG using one and the same=
=20
> state.
>=20
> Granted, there is a serialization in the current code as the=20
> lrng_pool_trylock() is taken before the Jitter RNG is called by=20
> lrng_fill_seed_buffer which effectively serializes all requests to also t=
he=20
> Jitter RNG. But this is coincidence in this case. I would think, however,=
 that=20
> this coincidence could easily lead to programming errors further down the=
 road=20
> when the spinlock is not present and that trylock() is moved to some plac=
e=20
> else considering that this trylock() is meant to protect reading the entr=
opy=20
> pool and not the Jitter RNG.
>=20
> As the reading of the Jitter RNG is always performed in process context, =
I=20
> think having this additional spin lock against possible programming error=
s=20
> should not lead to performance regressions.
>=20
> What do you think?
>=20
I take your meaning that each random device needs protection, and yes, each=
 of
the random devices (trng and sdrng) have their own locking.  But it also ap=
pears
to me that each of those random devices contains its own private copy of th=
e
entropy_buf (they're statically declared on the stack in lrng_trng_seed and
_lrng_sdrng_seed), so while the additional locking doesn't necessecarily hu=
rt,
I'm struggling to see why the additional work is needed.  If ever you have =
a
situation in which multiple rngs want want to share an entropy buffer, yes,=
 you
would need that lock, or some other protection, but I don't see the need
immediately.

Neil

> Thank you for your review!
>=20
> Ciao
> Stephan
>=20
>=20
