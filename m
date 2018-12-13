From: Rich Felker <dalias@libc.org>
Subject: Re: Can we drop upstream Linux x32 support?
Date: Thu, 13 Dec 2018 11:28:28 -0500
Message-ID: <20181213162828.GW23599@brightrain.aerifal.cx>
References: <CALCETrWgpAX7FV23zHmid83SsgnwFMKD4a_-xSEgB6v0kJR5sA@mail.gmail.com>
 <Pine.BSM.4.64L.1812112327500.21176@herc.mirbsd.org>
 <CALCETrXf0rmadycxmpGxd41qP9X+PAjyGHTwbGhKyp6oMKMRrA@mail.gmail.com>
 <Pine.BSM.4.64L.1812120231410.21176@herc.mirbsd.org>
 <CALCETrUYn=S=hmJ0tKdm2LoSgkWchY2_65sH7hJZp7wfS30giw@mail.gmail.com>
 <20181212165237.GT23599@brightrain.aerifal.cx>
 <CALCETrV6+YAazq7vY_aR=4kXc4ykXb1Se7hgvHeEVJtbZ91=Qg@mail.gmail.com>
 <20181213124025.bczxzj6ez34joo6v@localhost>
 <20181213155744.GU23599@brightrain.aerifal.cx>
 <87o99pl8es.fsf@oldenburg2.str.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87o99pl8es.fsf@oldenburg2.str.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Florian Weimer <fweimer@redhat.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Andy Lutomirski <luto@kernel.org>, tg@mirbsd.de, Linus Torvalds <torvalds@linux-foundation.org>, X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>, Borislav Petkov <bp@alien8.de>, Mike Frysinger <vapier@gentoo.org>, "H. J. Lu" <hjl.tools@gmail.com>, x32@buildd.debian.org, Arnd Bergmann <arnd@arndb.de>, Will Deacon <will.deacon@arm.com>
List-Id: linux-api@vger.kernel.org

On Thu, Dec 13, 2018 at 05:04:59PM +0100, Florian Weimer wrote:
> * Rich Felker:
> 
> >> If the compiler can handle the zeroing, that would be great, though not
> >> sure how (some __attribute__((zero)) which generates a type constructor
> >> for such structure; it kind of departs from what the C language offers).
> >
> > The compiler fundamentally can't. At the very least it would require
> > effective type tracking, which requires shadow memory and is even more
> > controversial than -fstrict-aliasing (because in a sense it's a
> > stronger version thereof).
> 
> It's possible to do it with the right types.  See _Bool on 32-bit Darwin
> PowerPC for an example, which is four bytes instead of the usual one.
> 
> Similarly, we could have integer types with trap representations.
> Whether it is a good idea is a different matter, but the amount of
> compiler magic required is actually limited.

If you do this you just have LP64 with value range restricted to
32-bit. This does not accomplish anything useful since it uses just as
much memory as normal LP64 but you don't get anything beneficial out
of it.

Rich
