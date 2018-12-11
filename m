From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: Can we drop upstream Linux x32 support?
Date: Wed, 12 Dec 2018 00:55:20 +0100
Message-ID: <CAK8P3a1aue66QS32OkZv-j1r3wX4a_iqox=uyHFN=RGoUx_SMg@mail.gmail.com>
References: <CALCETrXoRAibsbWa9nfbDrt0iEuebMnCMhSFg-d9W-J2g8mDjw@mail.gmail.com>
 <CAHk-=wi_Kp=3XmGDdzmadzFSPFvuL+aAJ6ZPAR=o4z=KwYT2vw@mail.gmail.com>
 <Pine.BSM.4.64L.1812112150480.21176@herc.mirbsd.org> <CALCETrWgpAX7FV23zHmid83SsgnwFMKD4a_-xSEgB6v0kJR5sA@mail.gmail.com>
 <Pine.BSM.4.64L.1812112327500.21176@herc.mirbsd.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <Pine.BSM.4.64L.1812112327500.21176@herc.mirbsd.org>
Sender: linux-kernel-owner@vger.kernel.org
To: tg@mirbsd.de
Cc: Andy Lutomirski <luto@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, the arch/x86 maintainers <x86@kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>, Borislav Petkov <bp@alien8.de>, Florian Weimer <fweimer@redhat.com>, vapier@gentoo.org, "H.J. Lu" <hjl.tools@gmail.com>, Rich Felker <dalias@libc.org>, x32@buildd.debian.org, Will Deacon <will.deacon@arm.com>, Catalin Marinas <catalin.marinas@arm.com>
List-Id: linux-api@vger.kernel.org

On Wed, Dec 12, 2018 at 12:38 AM Thorsten Glaser <tg@mirbsd.de> wrote:
>
> Andy Lutomirski dixit:
>
> >What happens if someone adds a struct like:
> >
> >struct nasty_on_x32 {
> >  __kernel_long_t a;
> >  void * __user b;
> >};
> >
> >On x86_64, that's two 8-byte fields.  On x86_32, it's two four-byte
> >fields.  On x32, it's an 8-byte field and a 4-byte field.  Now what?
>
> Yes, that’s indeed ugly. I understand. But don’t we already have
> this problem with architectures which support multiple ABIs at the
> same time? An amd64 kernel with i386 userspace comes to mind, or
> the multiple MIPS ABIs.

The main trouble that I see with x32 is in how it's different
from all the other compat architectures. We have a number
of drivers that support not only two ABIs (native and compat)
but also a third one specifically for x32, and more drivers
that fail on x32 because they never implemented the third
case.

Note that this is not a problem for MIPS n32 and aarch64ilp32,
which generally stick to the regular compat ABI (each compat
architecture has some minor quirks somewhere, much less so
than x32 does).

> >actually do this work.  Instead we get ad hoc fixes for each syscall,
> >along the lines of preadv64v2(), which get done when somebody notices
>
> Yes, that’s absolutely ugly and ridiculous and all kinds of bad.
>
> On the other hand, from my current experience, someone (Arnd?) noticed
> all the currently existing baddies for x32 already and fixed them.

I did some, and others did more, but it's hard to ever do a complete
job, and even harder to prevent new bugs from creeping in.

> New syscalls are indeed an issue, but perhaps something generating
> copyinout stubs could help. This might allow other architectures
> that could do with a new ABI but have until now feared the overhead
> as well. (IIRC, m68k could do with a new ABI that reserves a register
> for TLS, but Geert would know. At the same time, time_t and off_t could
> be bumped to 64 bit. Something like that. If changing sizes of types
> shared between kernel and user spaces is not something feared…)

Creating a completely new ABI for an existing architecutre is generally
something you want to avoid, as this means all existing user space
has to be recompiled.

All architectures support 64-bit off_t already, and soon will support
64-bit time_t as well, at this point (as of this week's linux-next)
we mostly just need to assign a couple of syscall numbers for each
32-bit architectures.

        Arnd
