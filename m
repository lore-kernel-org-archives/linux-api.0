From: Ivan Ivanov <qmastery16@gmail.com>
Subject: Re: Can we drop upstream Linux x32 support?
Date: Wed, 12 Dec 2018 21:50:23 +0300
Message-ID: <CAAaskFA5cssU+fGAOUJO4u5XYBP6XYtSeWRhaSAr3BqOBTYjmw@mail.gmail.com>
References: <CALCETrXoRAibsbWa9nfbDrt0iEuebMnCMhSFg-d9W-J2g8mDjw@mail.gmail.com>
 <CAHk-=wi_Kp=3XmGDdzmadzFSPFvuL+aAJ6ZPAR=o4z=KwYT2vw@mail.gmail.com>
 <Pine.BSM.4.64L.1812112150480.21176@herc.mirbsd.org> <CALCETrWgpAX7FV23zHmid83SsgnwFMKD4a_-xSEgB6v0kJR5sA@mail.gmail.com>
 <Pine.BSM.4.64L.1812112327500.21176@herc.mirbsd.org> <CALCETrXf0rmadycxmpGxd41qP9X+PAjyGHTwbGhKyp6oMKMRrA@mail.gmail.com>
 <Pine.BSM.4.64L.1812120231410.21176@herc.mirbsd.org> <CAK8P3a3yurujkdic98H02j0YfctSBf9NeXQreLZVhTzsttoc9g@mail.gmail.com>
 <alpine.DEB.2.21.1812121811080.21643@digraph.polyomino.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.21.1812121811080.21643@digraph.polyomino.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: joseph@codesourcery.com
Cc: arnd@arndb.de, tg@mirbsd.de, luto@kernel.org, Linus Torvalds <torvalds@linux-foundation.org>, x86@kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-api@vger.kernel.org, hpa@zytor.com, peterz@infradead.org, bp@alien8.de, fweimer@redhat.com, vapier@gentoo.org, hjl.tools@gmail.com, dalias@libc.org, x32@buildd.debian.org, will.deacon@arm.com, catalin.marinas@arm.com
List-Id: linux-api@vger.kernel.org

Please don't drop x86 support from the Linux kernel ! You may not
realize it, but there are plenty of people who care about x86 systems.
I have a good old Pentium 4 based computer which is 32-bit, using it
for some weird Linux experiments + retro gaming, and if I can't run
new Linux kernels there - it would be SAD
=D1=81=D1=80, 12 =D0=B4=D0=B5=D0=BA. 2018 =D0=B3. =D0=B2 21:15, Joseph Myer=
s <joseph@codesourcery.com>:
>
> On Wed, 12 Dec 2018, Arnd Bergmann wrote:
>
> > > MIPS had o32, n32, n64 since like forever.
> >
> > o32 and n32 are practically the same, the only difference on the
> > syscall ABI that I can see are the actual syscall numbers, and
> > the 'struct sigcontext' definition.
>
> And for syscalls that have 64-bit arguments, n32 generally passes those i=
n
> a single register (like n64), not pairs of registers (like o32).  But,
> yes, userspace structure layout for n32 is generally much closer to o32
> than to n64.
>
> --
> Joseph S. Myers
> joseph@codesourcery.com
