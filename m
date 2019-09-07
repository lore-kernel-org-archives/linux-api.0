From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH v12 11/12] open: openat2(2) syscall
Date: Sat, 7 Sep 2019 11:15:09 -0700
Message-ID: <EE7399FD-7587-407B-B628-1D92CFD6B120@amacapital.net>
References: <20190904201933.10736-1-cyphar@cyphar.com> <20190904201933.10736-12-cyphar@cyphar.com> <7236f382d72130f2afbbe8940e72cc67e5c6dce0.camel@kernel.org> <CAHk-=whZx97Nm-gUK0ppofj2RA2LLz2vmaDUTKSSV-+yYB9q_Q@mail.gmail.com> <C81D6D29-F6BF-48E6-A15E-3ABCB2C992E5@amacapital.net> <CAHk-=whe90Ec_RRrMRLE0=bJOHNS9YmVwcytVxmrfK3oCuZF6A@mail.gmail.com>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
        charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAHk-=whe90Ec_RRrMRLE0=bJOHNS9YmVwcytVxmrfK3oCuZF6A@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jeff Layton <jlayton@kernel.org>, Aleksa Sarai <cyphar@cyphar.com>, Al Viro <viro@zeniv.linux.org.uk>, "J. Bruce Fields" <bfields@fieldses.org>, Arnd Bergmann <arnd@arndb.de>, David Howells <dhowells@redhat.com>, Shuah Khan <shuah@kernel.org>, Shuah Khan <skhan@linuxfoundation.org>, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Christian Brauner <christian@brauner.io>, Eric Biederman <ebiederm@xmission.com>, Andy Lutomirski <luto@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Alexei Starovoitov <ast@kernel.org>, Kees Cook <keescook@chromium.org>, Jann Horn <jannh@google.com>, Tycho Andersen <tycho@tycho.ws>, David Drysdale <drysdale@google.com>, Chanho Min <chanho.min@lge.com>, Oleg Nesterov <oleg@redhat.com>
List-Id: linux-api@vger.kernel.org


> On Sep 7, 2019, at 10:45 AM, Linus Torvalds <torvalds@linux-foundation.org=
> wrote:
>=20
>> On Sat, Sep 7, 2019 at 10:42 AM Andy Lutomirski <luto@amacapital.net> wro=
te:
>>=20
>> Linus, you rejected resolveat() because you wanted a *nice* API
>=20
> No. I rejected resoveat() because it was a completely broken garbage
> API that couldn't do even basic stuff right (like O_CREAT).
>=20
> We have a ton of flag space in the new openat2() model, we might as
> well leave the old flags alone that people are (a) used to and (b) we
> have code to support _anyway_.
>=20
> Making up a new flag namespace is only going to cause us - and users -
> more work, and more confusion. For no actual advantage. It's not going
> to be "cleaner". It's just going to be worse.
>=20
>=20

If we keep all the flag bits in the same mask with the same values, then we=E2=
=80=99re stuck with O_RDONLY=3D0 and everything that implies.  We=E2=80=99ll=
 have UPGRADE_READ that works differently from the missing plain-old-READ bi=
t, and we can=E2=80=99t express execute-only-no-read-or-write. This sucks.

Can we at least split the permission bits into their own mask and make bits 0=
 and 1 illegal in the main set of flags in openat2?

There=E2=80=99s another thread going on right now about adding a bit along t=
he lines of =E2=80=9CMAYEXEC=E2=80=9D, and one of the conclusions was that i=
t should wait for openat2 so that it can have same semantics. If we=E2=80=99=
re stuck with O_RDONLY and friends, then MAYEXEC is doomed to being at least=
 a bit nonsensical.

As an analogy, AMD64 introduced bigger PTEs but kept the same nonsense encod=
ing of read and write permission. And then we got NX, and now we=E2=80=99re g=
etting little holes in the encoding stolen by CET to mean new silly things. =
 I don=E2=80=99t know if you=E2=80=99ve been following the various rounds of=
 patches, but it is truly horrible. The mapping from meaning to the actual b=
its is *shit*, and AMD64 should have made a clean break instead.

open()=E2=80=99s permission bits are basically the same situation. And the k=
ernel *already* has a non-type-safe translation layer. Please, please let op=
enat2() at least get rid of the turd in open()=E2=80=99s bits 0 and 1.
