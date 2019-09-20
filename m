From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH RFC v4 1/1] random: WARN on large getrandom() waits and introduce getrandom2()
Date: Fri, 20 Sep 2019 12:52:28 -0700
Message-ID: <C5BE6F0F-15B1-404B-A490-5B4E5C8C61A0@amacapital.net>
References: <20190920193740.GD1889@1wt.eu>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190920193740.GD1889@1wt.eu>
Sender: linux-kernel-owner@vger.kernel.org
To: Willy Tarreau <w@1wt.eu>
Cc: Andy Lutomirski <luto@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, "Ahmed S. Darwish" <darwish.07@gmail.com>, Lennart Poettering <mzxreary@0pointer.de>, "Theodore Y. Ts'o" <tytso@mit.edu>, "Eric W. Biederman" <ebiederm@xmission.com>, "Alexander E. Patrakov" <patrakov@gmail.com>, Michael Kerrisk <mtk.manpages@gmail.com>, Matthew Garrett <mjg59@srcf.ucam.org>, lkml <linux-kernel@vger.kernel.org>, Ext4 Developers List <linux-ext4@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, linux-man <linux-man@vger.kernel.org>
List-Id: linux-api@vger.kernel.org



> On Sep 20, 2019, at 12:37 PM, Willy Tarreau <w@1wt.eu> wrote:
>=20
> =EF=BB=BFOn Fri, Sep 20, 2019 at 12:22:17PM -0700, Andy Lutomirski wrote:
>> Perhaps userland could register a helper that takes over and does
>> something better?
>=20
> If userland sees the failure it can do whatever the developer/distro
> packager thought suitable for the system facing this condition.
>=20
>> But I think the kernel really should do something
>> vaguely reasonable all by itself.
>=20
> Definitely, that's what Linus' proposal was doing. Sleeping for some time
> is what I call "vaguely reasonable".

I don=E2=80=99t buy it. We have existing programs that can deadlock on boot.=
 Just throwing -EAGAIN at them in a syscall that didn=E2=80=99t previously b=
lock does not strike me as reasonable.

>=20
>> If nothing else, we want the ext4
>> patch that provoked this whole discussion to be applied,
>=20
> Oh absolutely!
>=20
>> which means
>> that we need to unbreak userspace somehow, and returning garbage it to
>> is not a good choice.
>=20
> It depends how it's used. I'd claim that we certainly use randoms for
> other things (such as ASLR/hashtables) *before* using them to generate
> long lived keys thus we can have a bit more time to get some more
> entropy before reaching the point of producing these keys.

The problem is that we don=E2=80=99t know what userspace is doing with the o=
utput from getrandom(..., 0), so I think we have to be conservative. New ker=
nels need to work with old user code. It=E2=80=99s okay if they=E2=80=99re s=
lower to boot than they could be.

>=20
>> Here are some possible approaches that come to mind:
>>=20
>> int count;
>> while (crng isn't inited) {
>>  msleep(1);
>> }
>>=20
>> and modify add_timer_randomness() to at least credit a tiny bit to
>> crng_init_cnt.
>=20
> Without a timeout it's sure we'll still face some situations where
> it blocks forever, which is the current problem.

The point is that we keep the timer running by looping like this, which shou=
ld cause add_timer_randomness() to get called continuously, which should pre=
vent the deadlock.  I assume the deadlock is because we go into nohz-idle an=
d we sit there with nothing happening at all.

>=20
>> Or we do something like intentionally triggering readahead on some
>> offset on the root block device.
>=20
> You don't necessarily have such a device, especially when you're
> in an initramfs. It's precisely where userland can be smarter. When
> the caller is sfdisk for example, it does have more chances to try
> to perform I/O than when it's a tiny http server starting to present
> a configuration page.

What I mean is: allow user code to register a usermode helper that helps get=
 entropy. Or just convince distros to bundle some useful daemon that starts a=
t early boot and lives in the initramfs.
