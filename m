From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH v3 0/8] Rework random blocking
Date: Fri, 27 Dec 2019 07:29:20 +0800
Message-ID: <26B7EEAE-1166-4B45-9534-E00C5B2767C1@amacapital.net>
References: <20191226140423.GB3158@mit.edu>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20191226140423.GB3158@mit.edu>
Sender: linux-kernel-owner@vger.kernel.org
To: "Theodore Y. Ts'o" <tytso@mit.edu>
Cc: Stephan Mueller <smueller@chronox.de>, Andy Lutomirski <luto@kernel.org>, LKML <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Kees Cook <keescook@chromium.org>, "Jason A. Donenfeld" <Jason@zx2c4.com>, "Ahmed S. Darwish" <darwish.07@gmail.com>, Lennart Poettering <mzxreary@0pointer.de>, "Eric W. Biederman" <ebiederm@xmission.com>, "Alexander E. Patrakov" <patrakov@gmail.com>, Michael Kerrisk <mtk.manpages@gmail.com>, Willy Tarreau <w@1wt.eu>, Matthew Garrett <mjg59@srcf.ucam.org>, Ext4 Developers List <linux-ext4@vger.kernel.org>, linux-man <linux-man@vger.kernel.org>
List-Id: linux-api@vger.kernel.org


>> On Dec 26, 2019, at 10:04 PM, Theodore Y. Ts'o <tytso@mit.edu> wrote:
>>=20
>> =EF=BB=BFOn Thu, Dec 26, 2019 at 01:03:34PM +0100, Stephan Mueller wrote:=

>> Agreed. I was just trying to outline that the removal of the blocking_poo=
l is
>> a good thing. Even when we decide that random.c should receive a TRNG, we=
 do
>> not need to re-add a blocking pool, but can easily use the existing ChaCh=
a20
>> DRNG (most likely with its own instance).
>=20
> Well, it depends on what you mean by "TRNG" --- the ChaCha20 DRNG only
> has a state of 256 bits.  So if you want to only depend on "true
> entropy" you can't extract more than 256 bits without violating that
> assumption, at least if you're using a very strict definition of TRNG.
>=20
> By getting rid of the blocking pool, and making /dev/random work like
> getrandom with flags set to 0, we're effectively abandoning any kind
> of assertion that /dev/random is some kind of TRNG.  This is not
> insane; this is what the *BSD's have always done.
>=20
> But once we do this, and /dev/random takes on the semantics of "block
> until the CRNG has been initialized, and then it won't block after
> that", if we change it so that it now has some different semantics,
> such as "one you extract a 256-bit key, the read from /dev/random will
> block until we can refill it, which might take seconds, minutes or
> hours", will be considered a regression, and we can't do that.

I don=E2=80=99t think Stephan was proposing that. He was proposing a way to i=
mplement a new interface that blocks.

>=20
> Of course, we can hope that people will be using getrandom() and there
> will be very few new users of the /dev/random pathname.  But nothing
> is ever guaranteed..
>=20
>                       - Ted
