From: Thorsten Glaser <tg@mirbsd.de>
Subject: Re: Can we drop upstream Linux x32 support?
Date: Wed, 12 Dec 2018 02:33:56 +0000 (UTC)
Message-ID: <Pine.BSM.4.64L.1812120231410.21176@herc.mirbsd.org>
References: <CALCETrXoRAibsbWa9nfbDrt0iEuebMnCMhSFg-d9W-J2g8mDjw@mail.gmail.com>
 <CAHk-=wi_Kp=3XmGDdzmadzFSPFvuL+aAJ6ZPAR=o4z=KwYT2vw@mail.gmail.com>
 <Pine.BSM.4.64L.1812112150480.21176@herc.mirbsd.org>
 <CALCETrWgpAX7FV23zHmid83SsgnwFMKD4a_-xSEgB6v0kJR5sA@mail.gmail.com>
 <Pine.BSM.4.64L.1812112327500.21176@herc.mirbsd.org>
 <CALCETrXf0rmadycxmpGxd41qP9X+PAjyGHTwbGhKyp6oMKMRrA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CALCETrXf0rmadycxmpGxd41qP9X+PAjyGHTwbGhKyp6oMKMRrA@mail.gmail.com>
Content-Language: de-DE-1901, en-GB
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>, Borislav Petkov <bp@alien8.de>, Florian Weimer <fweimer@redhat.com>, Mike Frysinger <vapier@gentoo.org>, "H. J. Lu" <hjl.tools@gmail.com>, Rich Felker <dalias@libc.org>, x32@buildd.debian.org, Arnd Bergmann <arnd@arndb.de>, Will Deacon <will.deacon@arm.com>, Catalin Marinas <catalin.marinas@arm.com>
List-Id: linux-api@vger.kernel.org

Andy Lutomirski dixit:

>That’s the thing, though: the whole generic kernel compat
>infrastructure assumes there are at most two ABIs: native and, if
>enabled and relevant, compat. x32 breaks this entirely.

MIPS had o32, n32, n64 since like forever.

ARM has old ABI, EABI and now 64-bit.

Other architectures are yet to come.

>IMO the real right solution would be to push the whole problem to
>userspace: get an ILP32 system working with almost or entirely LP64

Is this a reflex of Linux kernel developers? ;-)

I doubt that userspace is the right place for this, remember
the recent glibc vs. syscalls debate. It would also need to
multiply across various libcs.

>How hard would it be to have __attribute__((ilp64)), with an optional
>warning if any embedded structs are not ilp64?  This plus a wrapper to

You mean LP64. Impossible, because LP64 vs. ILP32 is not the only
difference between amd64 and x32.

bye,
//mirabilos
-- 
I believe no one can invent an algorithm. One just happens to hit upon it
when God enlightens him. Or only God invents algorithms, we merely copy them.
If you don't believe in God, just consider God as Nature if you won't deny
existence.		-- Coywolf Qi Hunt
