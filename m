From: Rich Felker <dalias@libc.org>
Subject: Re: Can we drop upstream Linux x32 support?
Date: Thu, 13 Dec 2018 11:02:42 -0500
Message-ID: <20181213160242.GV23599@brightrain.aerifal.cx>
References: <CALCETrXoRAibsbWa9nfbDrt0iEuebMnCMhSFg-d9W-J2g8mDjw@mail.gmail.com>
 <70bb54b2-8ed3-b5ee-c02d-6ef66c4f27eb@physik.fu-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <70bb54b2-8ed3-b5ee-c02d-6ef66c4f27eb@physik.fu-berlin.de>
Sender: linux-kernel-owner@vger.kernel.org
To: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc: Andy Lutomirski <luto@kernel.org>, X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>, Borislav Petkov <bp@alien8.de>, Florian Weimer <fweimer@redhat.com>, Mike Frysinger <vapier@gentoo.org>, "H. J. Lu" <hjl.tools@gmail.com>, x32@buildd.debian.org, Arnd Bergmann <arnd@arndb.de>, Will Deacon <will.deacon@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Linus Torvalds <torvalds@linux-foundation.org>
List-Id: linux-api@vger.kernel.org

On Tue, Dec 11, 2018 at 11:29:14AM +0100, John Paul Adrian Glaubitz wrote:
> I can't say anything about the syscall interface. However, what I do know
> is that the weird combination of a 32-bit userland with a 64-bit kernel
> interface is sometimes causing issues. For example, application code usually
> expects things like time_t to be 32-bit on a 32-bit system. However, this
> isn't the case for x32 which is why code fails to build.

I don't see any basis for this claim about expecting time_t to be
32-bit. I've encountered some programs that "implicitly assume" this
by virtue of assuming they can cast time_t to long to print it, or
similar. IIRC this was an issue in busybox at one point; I'm not sure
if it's been fixed. But any software that runs on non-Linux unices has
long been corrected. If not, 2038 is sufficiently close that catching
and correcting any such remaining bugs is more useful than covering
them up and making the broken code work as expected.

Rich
