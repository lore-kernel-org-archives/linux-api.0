From: Joseph Myers <joseph@codesourcery.com>
Subject: Re: Can we drop upstream Linux x32 support?
Date: Thu, 13 Dec 2018 18:42:45 +0000
Message-ID: <alpine.DEB.2.21.1812131833430.2735@digraph.polyomino.org.uk>
References: <CAHk-=wi_Kp=3XmGDdzmadzFSPFvuL+aAJ6ZPAR=o4z=KwYT2vw@mail.gmail.com>        <Pine.BSM.4.64L.1812112150480.21176@herc.mirbsd.org>        <CALCETrWgpAX7FV23zHmid83SsgnwFMKD4a_-xSEgB6v0kJR5sA@mail.gmail.com>        <Pine.BSM.4.64L.1812112327500.21176@herc.mirbsd.org>
        <CALCETrXf0rmadycxmpGxd41qP9X+PAjyGHTwbGhKyp6oMKMRrA@mail.gmail.com>        <Pine.BSM.4.64L.1812120231410.21176@herc.mirbsd.org>        <CALCETrUYn=S=hmJ0tKdm2LoSgkWchY2_65sH7hJZp7wfS30giw@mail.gmail.com>        <20181212165237.GT23599@brightrain.aerifal.cx>
        <CALCETrV6+YAazq7vY_aR=4kXc4ykXb1Se7hgvHeEVJtbZ91=Qg@mail.gmail.com>        <20181213124025.bczxzj6ez34joo6v@localhost>        <20181213155744.GU23599@brightrain.aerifal.cx> <87o99pl8es.fsf@oldenburg2.str.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <87o99pl8es.fsf@oldenburg2.str.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Florian Weimer <fweimer@redhat.com>
Cc: Rich Felker <dalias@libc.org>, Catalin Marinas <catalin.marinas@arm.com>, Andy Lutomirski <luto@kernel.org>, tg@mirbsd.de, Linus Torvalds <torvalds@linux-foundation.org>, X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>, Borislav Petkov <bp@alien8.de>, Mike Frysinger <vapier@gentoo.org>, "H. J. Lu" <hjl.tools@gmail.com>, x32@buildd.debian.org, Arnd Bergmann <arnd@arndb.de>, Will Deacon <will.deacon@arm.com>
List-Id: linux-api@vger.kernel.org

On Thu, 13 Dec 2018, Florian Weimer wrote:

> Similarly, we could have integer types with trap representations.

C++2a will require two's complement representation for integer types, with 
no trap representations (other than for bool, where only 0 and 1 are valid 
representations).  It seems very plausible that C will follow.

-- 
Joseph S. Myers
joseph@codesourcery.com
