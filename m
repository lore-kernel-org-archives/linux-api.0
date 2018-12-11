From: hpa@zytor.com
Subject: Re: Can we drop upstream Linux x32 support?
Date: Mon, 10 Dec 2018 18:22:56 -0800
Message-ID: <DC97ED04-0FAB-4A4E-BD24-456B5A0978DF@zytor.com>
References: <CALCETrXoRAibsbWa9nfbDrt0iEuebMnCMhSFg-d9W-J2g8mDjw@mail.gmail.com> <CAHk-=wi_Kp=3XmGDdzmadzFSPFvuL+aAJ6ZPAR=o4z=KwYT2vw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAHk-=wi_Kp=3XmGDdzmadzFSPFvuL+aAJ6ZPAR=o4z=KwYT2vw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>, Andrew Lutomirski <luto@kernel.org>
Cc: the arch/x86 maintainers <x86@kernel.org>, Linux List Kernel Mailing <linux-kernel@vger.kernel.org>, linux-api@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>, bp@alien8.de, fweimer@redhat.com, vapier@gentoo.org, hjl.tools@gmail.com, dalias@libc.org, x32@buildd.debian.org, Arnd Bergmann <arnd@arndb.de>, Will Deacon <will.deacon@arm.com>, Catalin Marinas <catalin.marinas@arm.com>
List-Id: linux-api@vger.kernel.org

On December 10, 2018 5:40:33 PM PST, Linus Torvalds <torvalds@linux-foundation.org> wrote:
>On Mon, Dec 10, 2018 at 5:23 PM Andy Lutomirski <luto@kernel.org>
>wrote:
>>
>> I'm seriously considering sending a patch to remove x32 support from
>> upstream Linux.  Here are some problems with it:
>
>I talked to Arnd (I think - we were talking about all the crazy ABI's,
>but maybe it was with somebody else) about exactly this in Edinburgh.
>
>Apparently the main real use case is for extreme benchmarking. It's
>the only use-case where the complexity of maintaining a whole
>development environment and distro is worth it, it seems. Apparently a
>number of Spec submissions have been done with the x32 model.
>
>I'm not opposed to trying to sunset the support, but let's see who
>complains..
>
>              Linus

The use case aside, I need to address the technical issues in this post; some of the behaviors that Andy is pointing out area quite intentional, even if they are perhaps somewhat confusing at first glance. That being said, some were due to tradeoffs that might have been wrong.
-- 
Sent from my Android device with K-9 Mail. Please excuse my brevity.
