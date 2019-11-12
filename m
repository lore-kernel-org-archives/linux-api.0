From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: Re: [PATCH v24 01/12] Linux Random Number Generator
Date: Tue, 12 Nov 2019 03:25:03 +0100
Message-ID: <9370249.4lZBqg7Imc@positron.chronox.de>
References: <6157374.ptSnyUpaCn@positron.chronox.de> <2369119.jSEA3qhmGI@positron.chronox.de> <alpine.DEB.2.21.1911120041060.1833@nanos.tec.linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.21.1911120041060.1833@nanos.tec.linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-crypto@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, linux-api@vger.kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>, "Alexander E. Patrakov" <patrakov@gmail.com>, "Ahmed S. Darwish" <darwish.07@gmail.com>, "Theodore Y. Ts'o" <tytso@mit.edu>, Willy Tarreau <w@1wt.eu>, Matthew Garrett <mjg59@srcf.ucam.org>, Vito Caputo <vcaputo@pengaru.com>, Andreas Dilger <adilger.kernel@dilger.ca>, Jan Kara <jack@suse.cz>, Ray Strode <rstrode@redhat.com>, William Jon McCann <mccann@jhu.edu>, zhangjs <zachary@baishancloud.com>, Andy Lutomirski <luto@kernel.org>, Florian Weimer <fweimer@redhat.com>, Lennart Poettering <mzxreary@0pointer.de>, Nicolai Stange <nstange@sus>
List-Id: linux-api@vger.kernel.org

Am Dienstag, 12. November 2019, 00:54:16 CET schrieb Thomas Gleixner:

Hi Thomas,

> Stephan,
>=20
> On Mon, 11 Nov 2019, Stephan M=FCller wrote:
>=20
> thanks for Cc'ing me. I'll have a look at the technical details at later
> point in time.=20

Thank you very much for considering a review.

> While skimming through the patches I noticed, that you
> thankfully added the SPDX license identifiers, but
>=20
> > @@ -0,0 +1,105 @@
> > +// SPDX-License-Identifier: GPL-2.0 OR BSD-2-Clause
> > +/*
> > + * LRNG Fast Noise Source: CPU-based noise source
> > + *
> > + * Copyright (C) 2016 - 2019, Stephan Mueller <smueller@chronox.de>
> > + *
> > + * THIS SOFTWARE IS PROVIDED ``AS IS'' AND ANY EXPRESS OR IMPLIED
> > + * WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
> > + * OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE, ALL OF
> > + * WHICH ARE HEREBY DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR BE
> > + * LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
> > + * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT
> > + * OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
> > + * BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
> > + * LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
> > + * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE
> > + * USE OF THIS SOFTWARE, EVEN IF NOT ADVISED OF THE POSSIBILITY OF SUCH
> > + * DAMAGE.
>=20
> we really want to get rid of these boiler plate disclaimers as they are
> already implicit by the SPDX license identifier and provide no real
> value.
>=20
> Aside of that, the above disclaimer has even a slightly different wording
> than the standard BSD-2-Clause disclaimer which is going to cause even mo=
re
> headaches as automated scanner tools will detect that and someone has to =
go
> through that unreadable uppercase yelling mess and figure out whether it's
> a legaly substantial difference.
>=20
> Can you please get rid of those?

Absolutely. I have removed that boiler plate disclaimer from all files.

Though I hope it is acceptable to wait for further comments before a=20
resubmission.

Thank you very much.

Ciao
Stephan
