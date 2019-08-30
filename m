From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH 0/7] Rework random blocking
Date: Thu, 29 Aug 2019 19:01:49 -0700
Message-ID: <B9BEDD92-7EE4-40C9-96D2-389D32B8D040@amacapital.net>
References: <cover.1567126741.git.luto@kernel.org> <20190830014906.GD10779@mit.edu>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
        charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190830014906.GD10779@mit.edu>
Sender: linux-kernel-owner@vger.kernel.org
To: "Theodore Y. Ts'o" <tytso@mit.edu>
Cc: Andy Lutomirski <luto@kernel.org>, Theodore Tso <tytso@google.com>, LKML <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Kees Cook <keescook@chromium.org>, "Jason A. Donenfeld" <Jason@zx2c4.com>
List-Id: linux-api@vger.kernel.org



> On Aug 29, 2019, at 6:49 PM, Theodore Y. Ts'o <tytso@mit.edu> wrote:
>=20
>> On Thu, Aug 29, 2019 at 06:11:35PM -0700, Andy Lutomirski wrote:
>> This series also removes the blocking pool and makes /dev/random
>> work just like getentropy(..., 0) and makes GRND_RANDOM a no-op.  I
>> believe that Linux's blocking pool has outlived its usefulness.
>> Linux's CRNG generates output that is good enough to use even for
>> key generation.  The blocking pool is not stronger in any material
>> way, and keeping it around requires a lot of infrastructure of
>> dubious value.
>=20
> It's too late for the 5.4 cycle for a change of this magnitude, and
> I'd just as soon let this wait until *after* the LTS kernel gets cut.
> The reason for this is because at the moment, there are some PCI
> compliance labs who believe that the "true randomness" of /dev/random
> is necessary for PCI compliance and so they mandate the use of
> /dev/random over /dev/urandom's "cryptographic randomness" for that
> reason.  A lot of things which are thought to be needed for PCI
> compliance that are about as useful as eye of newt and toe of frog,
> but nothing says that PCI compliance (and enterprise customer
> requirements :-) have to make sense.
>=20
> It may be that what we might need to really support people (or stupid
> compliance labs) who have a fetish for "true randomness" to get a
> better interface for hardware random number generators than
> /dev/hwrng.  Specifically, one which allows for a more sane way of
> selecting which hardware random number generator to use if there are
> multiple available, and also one where we mix in some CRNG as a
> whitening step just case the hardware number generator is busted in
> some way.  (And to fix the issue that at the moment, if someone evil
> fakes up a USB device with the USB manufacturer and minor device
> number for a ChosKey device that generates a insecure sequence, it
> will still get blindly trusted by the kernel without any kind of
> authentication of said hardware device.)
>=20
> That probably means we need to come up with a new interface than
> /dev/hwrng, or have some way of configuring /dev/random to use a
> hardware RNG device for those people who really care about "true
> randomness".  The current /dev/hwrng interface and how it is
> configured via sysfs is pretty baroque IMO.
>=20
>                    =20

Hmm. Does this really need to be in the kernel?  ISTM it should be straightf=
orward to write a little CUSE program that grabs bytes from RDSEED or RDRAND=
, TPM, ChaosKey (if enabled, with a usb slot selected!), and whatever other s=
ources are requested and, configurable to satisfy whoever actually cares, mi=
xes some or all with a FIPS-compliant, provably-indististinguishable-from-ra=
ndom, definitely not Dual-EC mixer, and spits out the result.  And filters i=
t and checks all the sources for credibility, and generally does whatever th=
e user actually needs.

And the really over-the-top auditors can symlink it to /dev/random.

Do the PCI folks actually care that it=E2=80=99s in the kernel?


As an aside, the first two patches could plausibly land before the rest of t=
he series if that seems appropriate.=
