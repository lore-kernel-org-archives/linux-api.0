From: Florian Weimer <fweimer@redhat.com>
Subject: Re: Can we drop upstream Linux x32 support?
Date: Thu, 13 Dec 2018 17:04:59 +0100
Message-ID: <87o99pl8es.fsf@oldenburg2.str.redhat.com>
References: <CAHk-=wi_Kp=3XmGDdzmadzFSPFvuL+aAJ6ZPAR=o4z=KwYT2vw@mail.gmail.com>
        <Pine.BSM.4.64L.1812112150480.21176@herc.mirbsd.org>
        <CALCETrWgpAX7FV23zHmid83SsgnwFMKD4a_-xSEgB6v0kJR5sA@mail.gmail.com>
        <Pine.BSM.4.64L.1812112327500.21176@herc.mirbsd.org>
        <CALCETrXf0rmadycxmpGxd41qP9X+PAjyGHTwbGhKyp6oMKMRrA@mail.gmail.com>
        <Pine.BSM.4.64L.1812120231410.21176@herc.mirbsd.org>
        <CALCETrUYn=S=hmJ0tKdm2LoSgkWchY2_65sH7hJZp7wfS30giw@mail.gmail.com>
        <20181212165237.GT23599@brightrain.aerifal.cx>
        <CALCETrV6+YAazq7vY_aR=4kXc4ykXb1Se7hgvHeEVJtbZ91=Qg@mail.gmail.com>
        <20181213124025.bczxzj6ez34joo6v@localhost>
        <20181213155744.GU23599@brightrain.aerifal.cx>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181213155744.GU23599@brightrain.aerifal.cx> (Rich Felker's
        message of "Thu, 13 Dec 2018 10:57:44 -0500")
Sender: linux-kernel-owner@vger.kernel.org
To: Rich Felker <dalias@libc.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Andy Lutomirski <luto@kernel.org>, tg@mirbsd.de, Linus Torvalds <torvalds@linux-foundation.org>, X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>, Borislav Petkov <bp@alien8.de>, Mike Frysinger <vapier@gentoo.org>, "H. J. Lu" <hjl.tools@gmail.com>, x32@buildd.debian.org, Arnd Bergmann <arnd@arndb.de>, Will Deacon <will.deacon@arm.com>
List-Id: linux-api@vger.kernel.org

* Rich Felker:

>> If the compiler can handle the zeroing, that would be great, though not
>> sure how (some __attribute__((zero)) which generates a type constructor
>> for such structure; it kind of departs from what the C language offers).
>
> The compiler fundamentally can't. At the very least it would require
> effective type tracking, which requires shadow memory and is even more
> controversial than -fstrict-aliasing (because in a sense it's a
> stronger version thereof).

It's possible to do it with the right types.  See _Bool on 32-bit Darwin
PowerPC for an example, which is four bytes instead of the usual one.

Similarly, we could have integer types with trap representations.
Whether it is a good idea is a different matter, but the amount of
compiler magic required is actually limited.

Thanks,
Florian
