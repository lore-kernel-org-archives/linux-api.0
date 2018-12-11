From: Rich Felker <dalias@libc.org>
Subject: Re: Can we drop upstream Linux x32 support?
Date: Tue, 11 Dec 2018 18:33:16 -0500
Message-ID: <20181211233316.GN23599@brightrain.aerifal.cx>
References: <CALCETrXoRAibsbWa9nfbDrt0iEuebMnCMhSFg-d9W-J2g8mDjw@mail.gmail.com>
 <70bb54b2-8ed3-b5ee-c02d-6ef66c4f27eb@physik.fu-berlin.de>
 <Pine.BSM.4.64L.1812112155170.21176@herc.mirbsd.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.BSM.4.64L.1812112155170.21176@herc.mirbsd.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Thorsten Glaser <tg@mirbsd.de>
Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>, Andy Lutomirski <luto@kernel.org>, X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>, Borislav Petkov <bp@alien8.de>, Florian Weimer <fweimer@redhat.com>, Mike Frysinger <vapier@gentoo.org>, "H. J. Lu" <hjl.tools@gmail.com>, x32@buildd.debian.org, Arnd Bergmann <arnd@arndb.de>, Will Deacon <will.deacon@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Linus Torvalds <torvalds@linux-foundation.org>
List-Id: linux-api@vger.kernel.org

On Tue, Dec 11, 2018 at 09:59:48PM +0000, Thorsten Glaser wrote:
> John Paul Adrian Glaubitz dixit:
> 
> >I can't say anything about the syscall interface. However, what I do know
> >is that the weird combination of a 32-bit userland with a 64-bit kernel
> >interface is sometimes causing issues. For example, application code usually
> 
> Yes, but more and more ${foo}64ilp32 architectures are popping up.
> 
> >Additionally, x32 support in many applications is either rudimentary
> 
> If a signal is sent that this kind of architectures will stay, some
> people might be convinced to fix that.
> 
> >It's also that the performance benefits of x32 are often eaten up by
> >the fact that none of the scripted languages that I know of provide
> 
> Non-JITted languages like yours truly’s shell do benefit from it,
> though. (mksh works just fine on LP64 but its internal structures
> pack massively better on ILP32, for example.)

gcc also benefits massively, up to 2x or more performance improvement
from ILP32, just because you can double your -jN to make. The "or
more" comes from cache utilization also improving. Actually I often
use i486 gcc even on 64-bit systems for this reason, and have observed
this order of improvement despite the lack of registers and worse call
ABI. Presumably x32 would be better, but I've avoided it because of
how buggy it's been in the past.

> >If x32 is eventually to be removed, we should also take care of removing
> >x32 support from userland code. From the top of my head, this would at least
> 
> I don’t think so. The patches also contain
> – stuff to support 64-bit time_t on 32-bit architectures, e.g:
> - bugfixes like printf("%lld", (long long)timet_value) instead
>   of assuming time_t fits into a long (also important for other
>   operating systems…)
> - generally switching from generic types like long to specific
>   types like size_t, ptrdiff_t, etc.
> - there was one more but after having written two eMails I forgot it
> - oh and, of course, they lay the base for e.g. amd64ilp32 support

I would not classify any of that as part of "removing x32 support",
but rather as "reintroducing broken assumptions". I think "removing
x32 support" was intended to mean places where there's
explicitly-x32-specific code or tooling, like asm functions/fragments
in libc, x32 versions of the dispatch asm in mesa, x32 code
generation, etc. Obviously (at least I hope it's obvious) nonportable
assumptions should not be reintroduced regardless of whether x32 is
dropped.

FWIW x32 is nice as a test case for catching such nonportable
assumptions and getting them fixed.

Rich
