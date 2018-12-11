From: Florian Weimer <fweimer@redhat.com>
Subject: Re: Can we drop upstream Linux x32 support?
Date: Tue, 11 Dec 2018 09:16:05 +0100
Message-ID: <871s6o32d6.fsf@oldenburg2.str.redhat.com>
References: <CALCETrXoRAibsbWa9nfbDrt0iEuebMnCMhSFg-d9W-J2g8mDjw@mail.gmail.com>
        <CAHk-=wi_Kp=3XmGDdzmadzFSPFvuL+aAJ6ZPAR=o4z=KwYT2vw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAHk-=wi_Kp=3XmGDdzmadzFSPFvuL+aAJ6ZPAR=o4z=KwYT2vw@mail.gmail.com>
        (Linus Torvalds's message of "Mon, 10 Dec 2018 17:40:33 -0800")
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Lutomirski <luto@kernel.org>, the arch/x86 maintainers <x86@kernel.org>, Linux List Kernel Mailing <linux-kernel@vger.kernel.org>, linux-api@vger.kernel.org, Peter Anvin <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>, bp@alien8.de, vapier@gentoo.org, hjl.tools@gmail.com, dalias@libc.org, x32@buildd.debian.org, Arnd Bergmann <arnd@arndb.de>, Will Deacon <will.deacon@arm.com>, Catalin Marinas <catalin.marinas@arm.com>
List-Id: linux-api@vger.kernel.org

* Linus Torvalds:

> Apparently the main real use case is for extreme benchmarking. It's
> the only use-case where the complexity of maintaining a whole
> development environment and distro is worth it, it seems. Apparently a
> number of Spec submissions have been done with the x32 model.

Are you sure GCC was used for that?

ICC has a 32-bit pointer mode which does not change the (64-bit) kernel
interface.

Thanks,
Florian
