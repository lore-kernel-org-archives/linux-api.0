From: Florian Weimer <fweimer@redhat.com>
Subject: Re: Can we drop upstream Linux x32 support?
Date: Tue, 11 Dec 2018 11:37:58 +0100
Message-ID: <87in00z6ux.fsf@oldenburg2.str.redhat.com>
References: <CALCETrXoRAibsbWa9nfbDrt0iEuebMnCMhSFg-d9W-J2g8mDjw@mail.gmail.com>
        <70bb54b2-8ed3-b5ee-c02d-6ef66c4f27eb@physik.fu-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <70bb54b2-8ed3-b5ee-c02d-6ef66c4f27eb@physik.fu-berlin.de> (John
        Paul Adrian Glaubitz's message of "Tue, 11 Dec 2018 11:29:14 +0100")
Sender: linux-kernel-owner@vger.kernel.org
To: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc: Andy Lutomirski <luto@kernel.org>, X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>, Borislav Petkov <bp@alien8.de>, Mike Frysinger <vapier@gentoo.org>, "H. J. Lu" <hjl.tools@gmail.com>, Rich Felker <dalias@libc.org>, x32@buildd.debian.org, Arnd Bergmann <arnd@arndb.de>, Will Deacon <will.deacon@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Linus Torvalds <torvalds@linux-foundation.org>
List-Id: linux-api@vger.kernel.org

* John Paul Adrian Glaubitz:

> As for the enterprise support, this seems to be correct. I don't know
> of any enterprise distribution with x32 support either.

Me neither.  I would expect a pure userspace port, with limitations in
what ioctls you can use, and perhaps support from GCC to share more APIs
with the kernel.

(I do not know of any plans to work on this.)

> I'm not terribly opposed to this change. I'm usually for keeping support
> for things that people are using, but the maintenance is a huge burden
> to upstream projects, I'm fine with letting it go.

Thank you for sharing your perspective.

> If x32 is eventually to be removed, we should also take care of removing
> x32 support from userland code. From the top of my head, this would at least
> concern:
>
>  * OpenJDK

Note that OpenJDK (well, Hotspot) has its own 32-bit pointer support for
the Java heap (compressed oops), so only the native code parts (and JNI)
benefit from x32 anyway.

Thanks,
Florian
