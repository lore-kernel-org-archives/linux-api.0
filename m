From: Thorsten Glaser <tg@mirbsd.de>
Subject: Re: Can we drop upstream Linux x32 support?
Date: Tue, 11 Dec 2018 21:59:48 +0000 (UTC)
Message-ID: <Pine.BSM.4.64L.1812112155170.21176@herc.mirbsd.org>
References: <CALCETrXoRAibsbWa9nfbDrt0iEuebMnCMhSFg-d9W-J2g8mDjw@mail.gmail.com>
 <70bb54b2-8ed3-b5ee-c02d-6ef66c4f27eb@physik.fu-berlin.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <70bb54b2-8ed3-b5ee-c02d-6ef66c4f27eb@physik.fu-berlin.de>
Content-Language: de-DE-1901, en-GB
Sender: linux-kernel-owner@vger.kernel.org
To: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc: Andy Lutomirski <luto@kernel.org>, X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>, Borislav Petkov <bp@alien8.de>, Florian Weimer <fweimer@redhat.com>, Mike Frysinger <vapier@gentoo.org>, "H. J. Lu" <hjl.tools@gmail.com>, Rich Felker <dalias@libc.org>, x32@buildd.debian.org, Arnd Bergmann <arnd@arndb.de>, Will Deacon <will.deacon@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Linus Torvalds <torvalds@linux-foundation.org>
List-Id: linux-api@vger.kernel.org

John Paul Adrian Glaubitz dixit:

>I can't say anything about the syscall interface. However, what I do know
>is that the weird combination of a 32-bit userland with a 64-bit kernel
>interface is sometimes causing issues. For example, application code usually

Yes, but more and more ${foo}64ilp32 architectures are popping up.

>Additionally, x32 support in many applications is either rudimentary

If a signal is sent that this kind of architectures will stay, some
people might be convinced to fix that.

>It's also that the performance benefits of x32 are often eaten up by
>the fact that none of the scripted languages that I know of provide

Non-JITted languages like yours truly’s shell do benefit from it,
though. (mksh works just fine on LP64 but its internal structures
pack massively better on ILP32, for example.)

>If x32 is eventually to be removed, we should also take care of removing
>x32 support from userland code. From the top of my head, this would at least

I don’t think so. The patches also contain
– stuff to support 64-bit time_t on 32-bit architectures, e.g:
- bugfixes like printf("%lld", (long long)timet_value) instead
  of assuming time_t fits into a long (also important for other
  operating systems…)
- generally switching from generic types like long to specific
  types like size_t, ptrdiff_t, etc.
- there was one more but after having written two eMails I forgot it
- oh and, of course, they lay the base for e.g. amd64ilp32 support

bye,
//mirabilos
-- 
FWIW, I'm quite impressed with mksh interactively. I thought it was much
*much* more bare bones. But it turns out it beats the living hell out of
ksh93 in that respect. I'd even consider it for my daily use if I hadn't
wasted half my life on my zsh setup. :-) -- Frank Terbeck in #!/bin/mksh
