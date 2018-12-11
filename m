From: Thorsten Glaser <tg@mirbsd.de>
Subject: Re: Can we drop upstream Linux x32 support?
Date: Tue, 11 Dec 2018 21:53:51 +0000 (UTC)
Message-ID: <Pine.BSM.4.64L.1812112150480.21176@herc.mirbsd.org>
References: <CALCETrXoRAibsbWa9nfbDrt0iEuebMnCMhSFg-d9W-J2g8mDjw@mail.gmail.com>
 <CAHk-=wi_Kp=3XmGDdzmadzFSPFvuL+aAJ6ZPAR=o4z=KwYT2vw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAHk-=wi_Kp=3XmGDdzmadzFSPFvuL+aAJ6ZPAR=o4z=KwYT2vw@mail.gmail.com>
Content-Language: de-DE-1901, en-GB
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Lutomirski <luto@kernel.org>, the arch/x86 maintainers <x86@kernel.org>, Linux List Kernel Mailing <linux-kernel@vger.kernel.org>, linux-api@vger.kernel.org, Peter Anvin <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>, bp@alien8.de, fweimer@redhat.com, vapier@gentoo.org, hjl.tools@gmail.com, dalias@libc.org, x32@buildd.debian.org, Arnd Bergmann <arnd@arndb.de>, Will Deacon <will.deacon@arm.com>, Catalin Marinas <catalin.marinas@arm.com>
List-Id: linux-api@vger.kernel.org

Note: please keep me in Cc because I am not subscribed.

Linus Torvalds dixit:

>I'm not opposed to trying to sunset the support, but let's see who complains..

I will hereby complain.

I’m using Debian/x32 on my main desktop at work, and do
occasionally help out with porting issues. It’s a good
way to make more out of 64-bit machines without going
all 64 bit; it’s also helped me find bugs in software.
It’s a nice architectural idea, and a way forward for
things that are constricted to 32 bits while opening
up stuff like 64-bit time_t without taking up half the
available CPU registers (while more than doubling the
number of the available CPU registers, too).

I was also considering investing a nontrivial amount of
work into porting klibc to x32, since hpa does not wish
to do it himself. Thankfully I have only done a bit yet.

Furthermore, x32 was the first of the many *64ilp32
architectures; I know I’ve seen amd64ilp32 and at least
one other I don’t recall. It will have prototyped many
of the problems users of these will run in, and I’d prefer
to keep it (completely selfish because I don’t wish to
have to crossgrade a whole system yet again).

Thanks for your consideration,
//mirabilos
--  
When he found out that the m68k port was in a pretty bad shape, he did
not, like many before him, shrug and move on; instead, he took it upon
himself to start compiling things, just so he could compile his shell.
How's that for dedication. -- Wouter, about my Debian/m68k revival
