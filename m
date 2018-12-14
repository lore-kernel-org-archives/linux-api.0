From: Rich Felker <dalias@libc.org>
Subject: Re: Can we drop upstream Linux x32 support?
Date: Fri, 14 Dec 2018 11:55:35 -0500
Message-ID: <20181214165535.GZ23599@brightrain.aerifal.cx>
References: <CALCETrXoRAibsbWa9nfbDrt0iEuebMnCMhSFg-d9W-J2g8mDjw@mail.gmail.com>
 <70bb54b2-8ed3-b5ee-c02d-6ef66c4f27eb@physik.fu-berlin.de>
 <20181213160242.GV23599@brightrain.aerifal.cx>
 <c8987b31-ed79-acef-a300-31ebf2c29d2e@petrovitsch.priv.at>
 <20181214161732.GY23599@brightrain.aerifal.cx>
 <87mup8gj1y.fsf@oldenburg2.str.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87mup8gj1y.fsf@oldenburg2.str.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Florian Weimer <fweimer@redhat.com>
Cc: Bernd Petrovitsch <bernd@petrovitsch.priv.at>, John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>, Andy Lutomirski <luto@kernel.org>, X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>, Borislav Petkov <bp@alien8.de>, Mike Frysinger <vapier@gentoo.org>, "H. J. Lu" <hjl.tools@gmail.com>, x32@buildd.debian.org, Arnd Bergmann <arnd@arndb.de>, Will Deacon <will.deacon@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Linus Torvalds <torvalds@linux-foundation.org>
List-Id: linux-api@vger.kernel.org

On Fri, Dec 14, 2018 at 05:38:33PM +0100, Florian Weimer wrote:
> * Rich Felker:
> 
> > This is all useless (and wrong since tv_nsec is required to have type
> > long as part of C and POSIX, regardless of ILP32-vs-LP64; that's a bug
> > in glibc's x32).
> 
> We should be able to fix standards if they prove unworkable in practice.
> In my opinion, if standards require complex solutions where an obvious
> and simple solution exists, then standards are wrong.

The requirement doesn't mandate complex solutions. There's nothing
complex about tv_nsec being long. long is the smallest type that C
guarantees to be large enough to store the range of values, which is
forever fixed and can't grow (because the definition of "nano" prefix
is fixed :). The type has been long ever since the structure was
introduced, and its being long means that there's lots of (correct!)
code using %ld (e.g. ".%.9ld" to format results as a decimal without
using floating point approximations) to print it. There might also be
code taking pointers to it to pass to functions, etc.

The only reason a "complex" need arises is that Linux did something
horribly wrong here, ignoring the specified type, when introducing an
obscure subarch that almost nobody uses. This kind of mistake is
becoming a theme in Linux (see also: msghdr). Application authors
should not have to pay the price for fixing this by retrofitting yet
another silly type like "snseconds_t" or something into programs to
accommodate the mistakes of x32.

Rich
