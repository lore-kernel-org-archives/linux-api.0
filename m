From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH RFC v4 1/1] random: WARN on large getrandom() waits and introduce getrandom2()
Date: Fri, 20 Sep 2019 11:29:52 -0700
Message-ID: <7D3731D2-348F-4561-A52D-AA7DAAEE258B@amacapital.net>
References: <78a4b774-ef6b-62cb-57db-8e1ff8d29f72@gmail.com>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <78a4b774-ef6b-62cb-57db-8e1ff8d29f72@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Alexander E. Patrakov" <patrakov@gmail.com>
Cc: Andy Lutomirski <luto@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, "Ahmed S. Darwish" <darwish.07@gmail.com>, Lennart Poettering <mzxreary@0pointer.de>, "Theodore Y. Ts'o" <tytso@mit.edu>, "Eric W. Biederman" <ebiederm@xmission.com>, Michael Kerrisk <mtk.manpages@gmail.com>, Willy Tarreau <w@1wt.eu>, Matthew Garrett <mjg59@srcf.ucam.org>, lkml <linux-kernel@vger.kernel.org>, Ext4 Developers List <linux-ext4@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, linux-man <linux-man@vger.kernel.org>
List-Id: linux-api@vger.kernel.org



> On Sep 20, 2019, at 11:15 AM, Alexander E. Patrakov <patrakov@gmail.com> w=
rote:
>=20
> =EF=BB=BF20.09.2019 22:52, Andy Lutomirski =D0=BF=D0=B8=D1=88=D0=B5=D1=82:=

>> I think that, given existing software, we should make two or three
>> changes to fix the basic problems here:
>> 1. Add GRND_INSECURE: at least let new applications do the right thing
>> going forward.
>> 2. Fix what is arguably a straight up kernel bug, not even an ABI
>> issue: when a user program is blocking in getrandom(..., 0), the
>> kernel happily sits there doing absolutely nothing and deadlocks the
>> system as a result.  This IMO isn't an ABI issue -- it's an
>> implementation problem.  How about we make getrandom() (probably
>> actually wait_for_random_bytes()) do something useful to try to seed
>> the RNG if the system is otherwise not doing IO.
>> 3. Optionally, entirely in user code: Get glibc to add new *library*
>> functions: getentropy_secure_blocking() and getentropy_insecure() or
>> whatever they want to call them.  Deprecate getentropy().
>> I think #2 is critical.  Right now, suppose someone has a system that
>> neets to do a secure network request (a la Red Hat's Clevis).  I have
>> no idea what Clevis actually does, but it wouldn't be particularly
>> crazy to do a DH exchange or sign with an EC key to ask some network
>> server to help unlock a dm-crypt volume.  If the system does this at
>> boot, it needs to use getrandom(..., 0), GRND_EXPLICIT, or whatever,
>> because it NEEDS a secure random number.  No about of ABI fiddling
>> will change this.  The kernel should *work* in this case rather than
>> deadlocking.
>=20
> Let me express a little bit of disagreement with the logic here.
>=20
> I do agree that #2 is critical, and the Clevis use case is a perfect examp=
le why it is important. I doubt that it is solvable without trusting jitter e=
ntropy, or without provoking a dummy read on a random block device, just for=
 timings, or maybe some other interaction with the external world - but Will=
y already said "it seems fishy". However, _if_ it is solved, then we don't n=
eed GRND_INSECURE, because solving #2 is equivalent to magically making secu=
re random numbers always available.
>=20
>=20

I beg to differ. There is a big difference between =E2=80=9Cdo your best *ri=
ght now*=E2=80=9D and =E2=80=9Cgive me a real secure result in a vaguely tim=
ely manner=E2=80=9D.

For example, the former is useful for ASLR or hash table randomization. The l=
atter is not.=
