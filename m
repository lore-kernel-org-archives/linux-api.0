From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH v3 0/8] Rework random blocking
Date: Thu, 26 Dec 2019 20:46:52 +0800
Message-ID: <E464D551-1631-4EA8-ADFB-852E16D29CA9@amacapital.net>
References: <4820831.xlnk3tY4r2@tauon.chronox.de>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4820831.xlnk3tY4r2@tauon.chronox.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Cc: Andy Lutomirski <luto@kernel.org>, Ted Ts'o <tytso@mit.edu>, LKML <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Kees Cook <keescook@chromium.org>, "Jason A. Donenfeld" <Jason@zx2c4.com>, "Ahmed S. Darwish" <darwish.07@gmail.com>, Lennart Poettering <mzxreary@0pointer.de>, "Eric W. Biederman" <ebiederm@xmission.com>, "Alexander E. Patrakov" <patrakov@gmail.com>, Michael Kerrisk <mtk.manpages@gmail.com>, Willy Tarreau <w@1wt.eu>, Matthew Garrett <mjg59@srcf.ucam.org>, Ext4 Developers List <linux-ext4@vger.kernel.org>, linux-man <linux-man@vger.kernel.org>
List-Id: linux-api@vger.kernel.org



> On Dec 26, 2019, at 8:04 PM, Stephan Mueller <smueller@chronox.de> wrote:
>=20
> =EF=BB=BFAm Donnerstag, 26. Dezember 2019, 12:12:29 CET schrieb Andy Lutom=
irski:
>=20
> Hi Andy,
>=20
>>>> On Dec 26, 2019, at 5:29 PM, Stephan M=C3=BCller <smueller@chronox.de> w=
rote:
>>>=20
>>> =EF=BB=BFAm Montag, 23. Dezember 2019, 09:20:43 CET schrieb Andy Lutomir=
ski:
>>>=20
>>> Hi Andy,
>>>=20
>>>> There are some open questions and future work here:
>>>>=20
>>>> Should the kernel provide an interface to get software-generated
>>>> "true random" numbers?  I can think of only one legitimate reason to
>>>> use such an interface: compliance with government standards.  If the
>>>> kernel provides such an interface going forward, I think it should
>>>> be a brand new character device, and it should have a default mode
>>>> 0440 or similar.  Software-generated "true random numbers" are a
>>>> very limited resource, and resource exhaustion is a big deal.  Ask
>>>> anyone who has twiddled their thumbs while waiting for gnupg to
>>>> generate a key.  If we think the kernel might do such a thing, then
>>>> patches 5-8 could be tabled for now.
>>>=20
>>> What about offering a compile-time option to enable or disable such code=
?
>>> Note, with the existing random.c code base, there is no need to have a
>>> separate blocking_pool. The ChaCha20 DRNG could be used for that very sa=
me
>>> purpose, provided that in case these true random numbers are generated
>>> when
>>> the Chacha20 DRNG received an equal amount of "unused" entropy.
>>=20
>> This scares me. The DRNG should be simple and easy to understand. If we=E2=
=80=99re
>> tapping extra numbers in some weird way, then I would be more comfortable=

>> with some clear assurance that this doesn=E2=80=99t break the security. I=
f we=E2=80=99re
>> tapping numbers in the same way as normal urandom, then I don=E2=80=99t r=
eally see
>> the point.
>=20
> Agreed. I was just trying to outline that the removal of the blocking_pool=
 is=20
> a good thing. Even when we decide that random.c should receive a TRNG, we d=
o=20
> not need to re-add a blocking pool, but can easily use the existing ChaCha=
20=20
> DRNG (most likely with its own instance).

Fair enough.

>=20
>>>> Alternatively, perhaps the kernel should instead provide a
>>>> privileged interface to read out raw samples from the various
>>>> entropy sources, and users who care could have a user daemon that
>>>> does something intelligent with them.  This would push the mess of
>>>> trying to comply with whatever standards are involved to userspace.
>>>> Userspace could then export "true randomness" via CUSE if it is so
>>>> inclined, or could have a socket with a well-known name, or whatever
>>>> else seems appropriate.
>>>=20
>>> With the patch set v26 of my LRNG I offer another possible alternative
>>> avoiding any additional character device file and preventing the
>>> starvation of legitimate use cases: the LRNG has an entropy pool that
>>> leaves different levels of entropy in the pool depending on the use case=
s
>>> of this data.
>>>=20
>>> If an unprivileged caller requests true random data, at least 1024 bits o=
f
>>> entropy is left in the pool. I.e. all entropy above that point is
>>> available
>>> for this request type. Note, even namespaces fall into this category
>>> considering that unprivileged users can create a user name space in whic=
h
>>> they can become root.
>>=20
>> This doesn=E2=80=99t solve the problem. If two different users run stupid=
 programs
>> like gnupg, they will starve each other.
>=20
> But such scenario will always occur, will it not? If there are two callers=
 for=20
> a limited resource, they will content if one "over-uses" the resource. My i=
dea=20
> was to provide an interface where its use does not starve other more relev=
ant=20
> use cases (e.g. seeding of the DRNGs). I.e. a user of a TRNG has the right=
 to=20
> be DoSed - that is the price to pay when using this concept.

Maybe I=E2=80=99m just cynical, but I expect that, if the feature is availab=
le to everyone, then lots of user programmers will use it even though they d=
on=E2=80=99t need to.  If, on the other hand, there is a barrier to entry, t=
hen people will be more likely to stop and think.

Even gnupg could have been more clever =E2=80=94 when generating a 4096-bit R=
SA key, there is no actual need for 4096 bits of entropy, however entropy is=
 defined. 256 bits would have been more than adequate.

(FWIW, my personal view is that 512 bits, in the sense of =E2=80=9Cthe distr=
ibution being sampled produces no output with probability greater than about=
 2^-512=E2=80=9D, is a good upper limit for even the most paranoid.  This is=
 because it=E2=80=99s reasonable to assume that an attacker can=E2=80=99t do=
 more than 2^128 operations. As djb has noted, multi-target attacks mean tha=
t you can amplify success probability in some cases by a factor that won=E2=80=
=99t exceed 2^128.  Some day, quantum computers might square-root everything=
, giving 512 bits. Actually, quantum computers won=E2=80=99t square root eve=
rything, but much more complicated analysis is needed to get a believable bo=
und.)

=E2=80=94Andy
