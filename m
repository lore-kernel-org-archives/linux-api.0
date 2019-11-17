From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: Re: [PATCH v25 01/12] Linux Random Number Generator
Date: Sun, 17 Nov 2019 11:30:13 +0100
Message-ID: <9486573.CV9Qe9s7RZ@positron.chronox.de>
References: <6157374.ptSnyUpaCn@positron.chronox.de> <2645285.kI0haNqfm4@positron.chronox.de> <alpine.DEB.2.21.1911161216540.14348@nanos.tec.linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.21.1911161216540.14348@nanos.tec.linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-crypto@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, linux-api@vger.kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>, "Alexander E. Patrakov" <patrakov@gmail.com>, "Ahmed S. Darwish" <darwish.07@gmail.com>, "Theodore Y. Ts'o" <tytso@mit.edu>, Willy Tarreau <w@1wt.eu>, Matthew Garrett <mjg59@srcf.ucam.org>, Vito Caputo <vcaputo@pengaru.com>, Andreas Dilger <adilger.kernel@dilger.ca>, Jan Kara <jack@suse.cz>, Ray Strode <rstrode@redhat.com>, William Jon McCann <mccann@jhu.edu>, zhangjs <zachary@baishancloud.com>, Andy Lutomirski <luto@kernel.org>, Florian Weimer <fweimer@redhat.com>, Lennart Poettering <mzxreary@0pointer.de>, Nicolai Stange <nstange@sus>
List-Id: linux-api@vger.kernel.org

Am Samstag, 16. November 2019, 12:25:21 CET schrieb Thomas Gleixner:

Hi Thomas,

> On Sat, 16 Nov 2019, Stephan M=FCller wrote:
> > +/**
> > + * Hot code path - Callback for interrupt handler
> > + */
> > +void add_interrupt_randomness(int irq, int irq_flags)
> > +{
> > +	lrng_time_process();
> > +
> > +	if (!lrng_pool_highres_timer()) {
> > +		struct pt_regs *regs =3D get_irq_regs();
> > +		static atomic_t reg_idx =3D ATOMIC_INIT(0);
> > +		u64 ip;
> > +
> > +		lrng_pool_lfsr_u32(jiffies);
> > +		lrng_pool_lfsr_u32(irq);
> > +		lrng_pool_lfsr_u32(irq_flags);
> > +
> > +		if (regs) {
> > +			u32 *ptr =3D (u32 *)regs;
> > +			int reg_ptr =3D atomic_add_return_relaxed(1, &reg_idx);
> > +			size_t n =3D (sizeof(struct pt_regs) / sizeof(u32));
> > +
> > +			ip =3D instruction_pointer(regs);
> > +			lrng_pool_lfsr_u32(*(ptr + (reg_ptr % n)));
> > +		} else
> > +			ip =3D _RET_IP_;
> > +
> > +		lrng_pool_lfsr_u32(ip >> 32);
> > +		lrng_pool_lfsr_u32(ip);
> > +	}
>=20
> Is there a way to avoid all that processing right in the interrupt hot
> path and just store the raw data for later processing?

The main code path is lrng_time_process(). This code is streamlined as you=
=20
already suggested: it is very lightweight to the interrupt handler. Compare=
d=20
to the existing /dev/random implementation it is about 50% faster.

When measuring the lrng_time_process, it takes on one particular test syste=
m=20
on average about 65 cycles where on that very same system the=20
add_interrupt_randomness code path from the existing /dev/random takes on=20
average about 97 cycles.

The additional code you see in the add_interrupt_randomness is only execute=
d=20
if lrng_pool_highres_timer is not set. This is not set if the LRNG does not=
=20
find a high-resolution time stamp, i.e. random_get_entropy() returns 0. As =
on=20
most architectures this is now set, this code path is not executed.

This additional code path serves as an emergency code to collect some data=
=20
that smells random and having entropy but not having really much.

It may be a bit more stremlined but since it is hardly used, I left it as i=
t=20
is so far. Do you see the need to streamline it more at this time?

Thanks a lot.


Ciao
Stephan
