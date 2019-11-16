From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH v25 10/12] LRNG - add TRNG support
Date: Sat, 16 Nov 2019 08:09:09 -0800
Message-ID: <DDB907EA-3FCC-40C7-B55B-A84BC77FD7A1@amacapital.net>
References: <5390778.VeFRgus4bQ@positron.chronox.de>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <5390778.VeFRgus4bQ@positron.chronox.de>
Sender: linux-kernel-owner@vger.kernel.org
To: =?utf-8?Q?Stephan_M=C3=BCller?= <smueller@chronox.de>
Cc: Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-crypto@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, linux-api@vger.kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>, "Alexander E. Patrakov" <patrakov@gmail.com>, "Ahmed S. Darwish" <darwish.07@gmail.com>, "Theodore Y. Ts'o" <tytso@mit.edu>, Willy Tarreau <w@1wt.eu>, Matthew Garrett <mjg59@srcf.ucam.org>, Vito Caputo <vcaputo@pengaru.com>, Andreas Dilger <adilger.kernel@dilger.ca>, Jan Kara <jack@suse.cz>, Ray Strode <rstrode@redhat.com>, William Jon McCann <mccann@jhu.edu>, zhangjs <zachary@baishancloud.com>, Andy Lutomirski <luto@kernel.org>, Florian Weimer <fweimer@redhat.com>, Lennart Poettering <mzxreary@0pointer.de>, Nicolai Stange <nstange@sus>
List-Id: linux-api@vger.kernel.org



> On Nov 16, 2019, at 1:40 AM, Stephan M=C3=BCller <smueller@chronox.de> wro=
te:
>=20
> =EF=BB=BFThe True Random Number Generator (TRNG) provides a random number
> generator with prediction resistance (SP800-90A terminology) or an NTG.1
> (AIS 31 terminology).
>=20

...

> The secondary DRNGs seed from the TRNG if it is present. In addition,
> the /dev/random device accesses the TRNG.
>=20
> If the TRNG is disabled, the secondary DRNGs seed from the entropy pool
> and /dev/random behaves like getrandom(2).

As mentioned before, I don=E2=80=99t like this API.  An application that, fo=
r some reason, needs a TRNG, should have an API by which it either gets a TR=
NG or an error. Similarly, an application that wants cryptographically secur=
e random numbers efficiently should have an API that does that.  With your d=
esign, /dev/random tries to cater to both use cases, but one of the use case=
s fails depending on kernel config.

I think /dev/random should wait for enough entropy to initialize the system b=
ut should not block after that. A TRNG should have an entirely new API that i=
s better than /dev/random.
