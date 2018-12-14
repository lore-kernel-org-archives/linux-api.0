From: Florian Weimer <fweimer@redhat.com>
Subject: Re: Can we drop upstream Linux x32 support?
Date: Fri, 14 Dec 2018 17:38:33 +0100
Message-ID: <87mup8gj1y.fsf@oldenburg2.str.redhat.com>
References: <CALCETrXoRAibsbWa9nfbDrt0iEuebMnCMhSFg-d9W-J2g8mDjw@mail.gmail.com>
        <70bb54b2-8ed3-b5ee-c02d-6ef66c4f27eb@physik.fu-berlin.de>
        <20181213160242.GV23599@brightrain.aerifal.cx>
        <c8987b31-ed79-acef-a300-31ebf2c29d2e@petrovitsch.priv.at>
        <20181214161732.GY23599@brightrain.aerifal.cx>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181214161732.GY23599@brightrain.aerifal.cx> (Rich Felker's
        message of "Fri, 14 Dec 2018 11:17:32 -0500")
Sender: linux-kernel-owner@vger.kernel.org
To: Rich Felker <dalias@libc.org>
Cc: Bernd Petrovitsch <bernd@petrovitsch.priv.at>, John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>, Andy Lutomirski <luto@kernel.org>, X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>, Borislav Petkov <bp@alien8.de>, Mike Frysinger <vapier@gentoo.org>, "H. J. Lu" <hjl.tools@gmail.com>, x32@buildd.debian.org, Arnd Bergmann <arnd@arndb.de>, Will Deacon <will.deacon@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Linus Torvalds <torvalds@linux-foundation.org>
List-Id: linux-api@vger.kernel.org

* Rich Felker:

> This is all useless (and wrong since tv_nsec is required to have type
> long as part of C and POSIX, regardless of ILP32-vs-LP64; that's a bug
> in glibc's x32).

We should be able to fix standards if they prove unworkable in practice.
In my opinion, if standards require complex solutions where an obvious
and simple solution exists, then standards are wrong.

Thanks,
Florian
