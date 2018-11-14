From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: Official Linux system wrapper library?
Date: Wed, 14 Nov 2018 06:46:47 -0800
Message-ID: <1C1B38FC-1266-4A91-B8F6-20A0C49ED1E2@amacapital.net>
References: <CAKOZuesB4R=dCz4merWQN0FSCGrXmOgUUr4ienSbStBJguNv8g@mail.gmail.com> <bbc12da5-830e-99a7-95e3-d9da42947dc9@gmail.com> <877ehjx447.fsf@oldenburg.str.redhat.com> <CAKOZues5SEESpJU=6MDTrPXTA1KTZFGNQE4Lw4t0fO-WBTU62w@mail.gmail.com> <875zx2vhpd.fsf@oldenburg.str.redhat.com> <CAKOZuetdgk1QYhx1538-98rFpogMin=8DkPnCtU9_=ip23Vk7w@mail.gmail.com> <20181113193859.GJ3505@e103592.cambridge.arm.com> <5853c297-9d84-86e5-dede-aa2957562c6b@arm.com>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
        charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <5853c297-9d84-86e5-dede-aa2957562c6b@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Szabolcs Nagy <Szabolcs.Nagy@arm.com>
Cc: Dave P Martin <Dave.Martin@arm.com>, Daniel Colascione <dancol@google.com>, nd <nd@arm.com>, Florian Weimer <fweimer@redhat.com>, "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>, linux-kernel <linux-kernel@vger.kernel.org>, Joel Fernandes <joelaf@google.com>, Linux API <linux-api@vger.kernel.org>, Willy Tarreau <w@1wt.eu>, Vlastimil Babka <vbabka@suse.cz>, Carlos O'Donell <carlos@redhat.com>, "libc-alpha@sourceware.org" <libc-alpha@sourceware.org>
List-Id: linux-api@vger.kernel.org




> On Nov 14, 2018, at 3:58 AM, Szabolcs Nagy <Szabolcs.Nagy@arm.com> wrote:
>=20
>> On 13/11/18 19:39, Dave Martin wrote:
>>> On Mon, Nov 12, 2018 at 05:19:14AM -0800, Daniel Colascione wrote:
>>> We should adopt a similar approach. Shipping a lower-level
>>> "liblinux.so" tightly bound to the kernel would not only let the
>>> kernel bypass glibc's "editorial discretion" in exposing new
>>> facilities to userspace, but would also allow for tighter user-kernel
>>> integration that one can achieve with a simplistic syscall(2)-style
>>> escape hatch. (For example, for a long time now, I've wanted to go
>>> beyond POSIX and improve the system's signal handling API, and this
>>> improvement requires userspace cooperation.) The vdso is probably too
>>> small and simplistic to serve in this role; I'd want a real library.
>>=20
>> Can you expand on your reasoning here?
>=20
> such lib creates a useless abi+api layer that
> somebody has to maintain and document (with or
> without vdso).

I=E2=80=99m not so sure it=E2=80=99s useless. Historically, POSIX systems ha=
ve, in practice and almost by definition, been very C focused, but the world=
 is changing. A less crufty library could be useful for newer languages:

>=20
> it obviously cannot work together with a posix
> conform libc implementation for which it would
> require knowledge about
>=20
> thread cancellation internals,

Thread cancellation is a big mess, and we only really need to support it bec=
ause on legacy code. The whole mechanism should IMO be considered extremely d=
eprecated.

> potentially TLS
> for errno,

errno is IMO a libc thing, full stop. A lower level library should *not* sup=
port errno.

> know libc types even ones that are
> based on compile time feature macros (and expose
> them in headers in a way that does not collide
> with libc headers),

This one is tricky. I wonder if we could instead get a C compiler extension t=
o set libc declare that a given struct is a layout-compatible variant of ano=
ther.

> abi variants the libc supports
> (e.g. softfp, security hardened abi),

Hmm.

> libc
> internal signals (for anything that's changing
> signal masks),

This is nasty, but see my cancellation comment above.

> thread internals for syscalls that
> require coordination between all user created
> threads (setxid),

We should just deal with this in the kernel. The current state of affairs is=
 nuts.

> libc internal state for syscalls
> that create/destroy threads.

I disagree. If you make or destroy threads behind libc=E2=80=99s back, I thi=
nk you get to keep both pieces.
