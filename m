From: Andy Lutomirski <luto@kernel.org>
Subject: Re: Can we drop upstream Linux x32 support?
Date: Wed, 12 Dec 2018 08:39:53 -0800
Message-ID: <CALCETrUYn=S=hmJ0tKdm2LoSgkWchY2_65sH7hJZp7wfS30giw@mail.gmail.com>
References: <CALCETrXoRAibsbWa9nfbDrt0iEuebMnCMhSFg-d9W-J2g8mDjw@mail.gmail.com>
 <CAHk-=wi_Kp=3XmGDdzmadzFSPFvuL+aAJ6ZPAR=o4z=KwYT2vw@mail.gmail.com>
 <Pine.BSM.4.64L.1812112150480.21176@herc.mirbsd.org> <CALCETrWgpAX7FV23zHmid83SsgnwFMKD4a_-xSEgB6v0kJR5sA@mail.gmail.com>
 <Pine.BSM.4.64L.1812112327500.21176@herc.mirbsd.org> <CALCETrXf0rmadycxmpGxd41qP9X+PAjyGHTwbGhKyp6oMKMRrA@mail.gmail.com>
 <Pine.BSM.4.64L.1812120231410.21176@herc.mirbsd.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <Pine.BSM.4.64L.1812120231410.21176@herc.mirbsd.org>
Sender: linux-kernel-owner@vger.kernel.org
To: tg@mirbsd.de
Cc: Andrew Lutomirski <luto@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>, Borislav Petkov <bp@alien8.de>, Florian Weimer <fweimer@redhat.com>, Mike Frysinger <vapier@gentoo.org>, "H. J. Lu" <hjl.tools@gmail.com>, Rich Felker <dalias@libc.org>, x32@buildd.debian.org, Arnd Bergmann <arnd@arndb.de>, Will Deacon <will.deacon@arm.com>, Catalin Marinas <catalin.marinas@arm.com>
List-Id: linux-api@vger.kernel.org

> On Dec 11, 2018, at 6:33 PM, Thorsten Glaser <tg@mirbsd.de> wrote:
>
> Andy Lutomirski dixit:
>

>
>> IMO the real right solution would be to push the whole problem to
>> userspace: get an ILP32 system working with almost or entirely LP64
>
> Is this a reflex of Linux kernel developers? ;-)
>
> I doubt that userspace is the right place for this, remember
> the recent glibc vs. syscalls debate. It would also need to
> multiply across various libcs.
>
>> How hard would it be to have __attribute__((ilp64)), with an optional
>> warning if any embedded structs are not ilp64?  This plus a wrapper to
>
> You mean LP64. Impossible, because LP64 vs. ILP32 is not the only
> difference between amd64 and x32.

I mean LP64.  And I'm not suggesting that ILP32 is the only difference
between x32 and x86_64, nor am I suggesting that a technique like this
would implement x32 -- I'm suggesting it would implement something
better than x32.

The kernel, as a practical matter, supports two ABIs on 64-bit builds:
LP64 and ILP32.  ILP32 is what the kernel calls "compat".  ("compat"
comes with other baggage -- it generally has a 32-bit signal frame,
syscall arguments are mostly limited to 32 bits, etc.)  Allowing a
user program that runs in 64-bit mode to issue compat syscalls is not
really a big deal.  x86_64 has allowed this forever using int $0x80 --
it's just slow.  Adding a faster mechanism would be straightforward.
As I understand it, the arm64 ilp32 proposal involves using a genuine
ILP32 model for user code, so the syscalls will all (except for signal
handling) go through the compat path.

x32 is not this at all.  The kernel ABI part of x32 isn't ILP32.  It's
IP32, 32-bit size_t, and *64-bit* long.  The core kernel doesn't
really support this.  The only good things I can think of about it are
that (a) it proves that somewhat odd ABIs are possible, at least in
principle, and (b) three users have come out of the woodwork to say
that they use it.

I'm proposing another alternative.  Given that x32 already proves that
the user bitness model doesn't have to match the kernel model (in x32,
user "long" is 32-bit but the kernel ABI "long" is 64-bit), I'm
proposing extending this to just make the kernel ABI be LP64.  So
__kernel_size_t would be 64-bit and pointers in kernel data structures
would be 64-bit.  In other words, most or all of the kernel ABI would
just match x86_64.

As far as I can tell, the only thing that really needs unusual
toolchain features here is that C doesn't have an extra-wide pointer
type.  The kernel headers would need a way to say "this pointer is
still logically a pointer, and user code may assume that it's 32 bits,
but it has 8-byte alignment."

So I guess I'm proposing that people who really like x32 and are
willing to invest effort it in instead invest some effort into getting
something similar to work using the normal x86_64 syscalls.  And I'm
hinting to the ARM folks on the thread that they consider this
approach for arm64.

There's an added benefit to my proposal over x32.  With my proposal,
an ILP32 program could plausibly call into a true 64-bit C library
using a straightforward FFI translation.
>
> bye,
> //mirabilos
> --
> I believe no one can invent an algorithm. One just happens to hit upon it
> when God enlightens him. Or only God invents algorithms, we merely copy them.
> If you don't believe in God, just consider God as Nature if you won't deny
> existence.        -- Coywolf Qi Hunt
