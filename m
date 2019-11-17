From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: Re: [PATCH v25 10/12] LRNG - add TRNG support
Date: Sun, 17 Nov 2019 12:10:58 +0100
Message-ID: <3159012.PsEOTp9LqO@positron.chronox.de>
References: <5390778.VeFRgus4bQ@positron.chronox.de> <DDB907EA-3FCC-40C7-B55B-A84BC77FD7A1@amacapital.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <DDB907EA-3FCC-40C7-B55B-A84BC77FD7A1@amacapital.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@amacapital.net>
Cc: Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-crypto@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, linux-api@vger.kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>, "Alexander E. Patrakov" <patrakov@gmail.com>, "Ahmed S. Darwish" <darwish.07@gmail.com>, "Theodore Y. Ts'o" <tytso@mit.edu>, Willy Tarreau <w@1wt.eu>, Matthew Garrett <mjg59@srcf.ucam.org>, Vito Caputo <vcaputo@pengaru.com>, Andreas Dilger <adilger.kernel@dilger.ca>, Jan Kara <jack@suse.cz>, Ray Strode <rstrode@redhat.com>, William Jon McCann <mccann@jhu.edu>, zhangjs <zachary@baishancloud.com>, Andy Lutomirski <luto@kernel.org>, Florian Weimer <fweimer@redhat.com>, Lennart Poettering <mzxreary@0pointer.de>, Nicolai Stange <nstange@sus>
List-Id: linux-api@vger.kernel.org

Am Samstag, 16. November 2019, 17:09:09 CET schrieb Andy Lutomirski:

Hi Andy,

> > On Nov 16, 2019, at 1:40 AM, Stephan M=C3=BCller <smueller@chronox.de> =
wrote:
> >=20
> > =EF=BB=BFThe True Random Number Generator (TRNG) provides a random numb=
er
> > generator with prediction resistance (SP800-90A terminology) or an NTG.1
> > (AIS 31 terminology).
>=20
> ...
>=20
> > The secondary DRNGs seed from the TRNG if it is present. In addition,
> > the /dev/random device accesses the TRNG.
> >=20
> > If the TRNG is disabled, the secondary DRNGs seed from the entropy pool
> > and /dev/random behaves like getrandom(2).
>=20
> As mentioned before, I don=E2=80=99t like this API.  An application that,=
 for some
> reason, needs a TRNG, should have an API by which it either gets a TRNG or
> an error. Similarly, an application that wants cryptographically secure
> random numbers efficiently should have an API that does that.  With your
> design, /dev/random tries to cater to both use cases, but one of the use
> cases fails depending on kernel config.
>=20
> I think /dev/random should wait for enough entropy to initialize the syst=
em
> but should not block after that. A TRNG should have an entirely new API
> that is better than /dev/random.

I apologize for the misunderstanding. I assumed we would introduce such /de=
v/
true_random at a later stage.

If you agree, I can certainly add /dev/true_random right now that links wit=
h=20
the TRNG and make /dev/random behave as discussed, i.e. behave exactly like=
=20
getrandom(..., 0);

As this would introduce a new device file now, is there a special process t=
hat=20
I need to follow or do I need to copy? Which major/minor number should I us=
e?

Looking into static const struct memdev devlist[] I see

         [8] =3D { "random", 0666, &random_fops, 0 },
         [9] =3D { "urandom", 0666, &urandom_fops, 0 },

Shall a true_random be added here with [10]?

Ciao
Stephan
