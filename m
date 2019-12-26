From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: Re: [PATCH v3 0/8] Rework random blocking
Date: Thu, 26 Dec 2019 10:29:00 +0100
Message-ID: <9872655.prSdhymlXK@positron.chronox.de>
References: <cover.1577088521.git.luto@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1577088521.git.luto@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@kernel.org>
Cc: Ted Ts'o <tytso@mit.edu>, LKML <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Kees Cook <keescook@chromium.org>, "Jason A. Donenfeld" <Jason@zx2c4.com>, "Ahmed S. Darwish" <darwish.07@gmail.com>, Lennart Poettering <mzxreary@0pointer.de>, "Eric W. Biederman" <ebiederm@xmission.com>, "Alexander E. Patrakov" <patrakov@gmail.com>, Michael Kerrisk <mtk.manpages@gmail.com>, Willy Tarreau <w@1wt.eu>, Matthew Garrett <mjg59@srcf.ucam.org>, Ext4 Developers List <linux-ext4@vger.kernel.org>, linux-man <linux-man@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

Am Montag, 23. Dezember 2019, 09:20:43 CET schrieb Andy Lutomirski:

Hi Andy,
>=20
> There are some open questions and future work here:
>=20
> Should the kernel provide an interface to get software-generated
> "true random" numbers?  I can think of only one legitimate reason to
> use such an interface: compliance with government standards.  If the
> kernel provides such an interface going forward, I think it should
> be a brand new character device, and it should have a default mode
> 0440 or similar.  Software-generated "true random numbers" are a
> very limited resource, and resource exhaustion is a big deal.  Ask
> anyone who has twiddled their thumbs while waiting for gnupg to
> generate a key.  If we think the kernel might do such a thing, then
> patches 5-8 could be tabled for now.

What about offering a compile-time option to enable or disable such code?=20
Note, with the existing random.c code base, there is no need to have a=20
separate blocking_pool. The ChaCha20 DRNG could be used for that very same=
=20
purpose, provided that in case these true random numbers are generated when=
=20
the Chacha20 DRNG received an equal amount of "unused" entropy.
>=20
> Alternatively, perhaps the kernel should instead provide a
> privileged interface to read out raw samples from the various
> entropy sources, and users who care could have a user daemon that
> does something intelligent with them.  This would push the mess of
> trying to comply with whatever standards are involved to userspace.
> Userspace could then export "true randomness" via CUSE if it is so
> inclined, or could have a socket with a well-known name, or whatever
> else seems appropriate.

With the patch set v26 of my LRNG I offer another possible alternative=20
avoiding any additional character device file and preventing the starvation=
 of=20
legitimate use cases: the LRNG has an entropy pool that leaves different=20
levels of entropy in the pool depending on the use cases of this data.

If an unprivileged caller requests true random data, at least 1024 bits of=
=20
entropy is left in the pool. I.e. all entropy above that point is available=
=20
for this request type. Note, even namespaces fall into this category=20
considering that unprivileged users can create a user name space in which t=
hey=20
can become root.

If a non-blocking DRNG serving /dev/urandom or getrandom(2) needs reseeding=
,=20
at least 512 bits of entropy is left in the pool. Each DRNG seeding operati=
on=20
requires at least 128 bits and at most 256 bits of entropy. This means that=
 at=20
least 2 reseed operations worth of entropy is found in the entropy pool eve=
n=20
though massive amount of true random numbers are requested by unprivileged=
=20
users.

If a privileged caller requests true random numbers, the entropy pool is=20
allowed to be exhausted.

Access to the true random number generator is provided with getrandom(2) an=
d=20
the GRND_TRUERANDOM flag. If the true random number generator (TRNG) is not=
=20
compiled or not present, -EOPNOTSUPP is returned.

Entire patch set:

Reviewed-by: Stephan M=FCller <smueller@chronox.de>

Ciao
Stephan
