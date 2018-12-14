From: Rich Felker <dalias@libc.org>
Subject: Re: Can we drop upstream Linux x32 support?
Date: Fri, 14 Dec 2018 11:17:32 -0500
Message-ID: <20181214161732.GY23599@brightrain.aerifal.cx>
References: <CALCETrXoRAibsbWa9nfbDrt0iEuebMnCMhSFg-d9W-J2g8mDjw@mail.gmail.com>
 <70bb54b2-8ed3-b5ee-c02d-6ef66c4f27eb@physik.fu-berlin.de>
 <20181213160242.GV23599@brightrain.aerifal.cx>
 <c8987b31-ed79-acef-a300-31ebf2c29d2e@petrovitsch.priv.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <c8987b31-ed79-acef-a300-31ebf2c29d2e@petrovitsch.priv.at>
Sender: linux-kernel-owner@vger.kernel.org
To: Bernd Petrovitsch <bernd@petrovitsch.priv.at>
Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>, Andy Lutomirski <luto@kernel.org>, X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>, Borislav Petkov <bp@alien8.de>, Florian Weimer <fweimer@redhat.com>, Mike Frysinger <vapier@gentoo.org>, "H. J. Lu" <hjl.tools@gmail.com>, x32@buildd.debian.org, Arnd Bergmann <arnd@arndb.de>, Will Deacon <will.deacon@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Linus Torvalds <torvalds@linux-foundation.org>
List-Id: linux-api@vger.kernel.org

On Fri, Dec 14, 2018 at 03:13:10PM +0100, Bernd Petrovitsch wrote:
> On 13/12/2018 17:02, Rich Felker wrote:
> > On Tue, Dec 11, 2018 at 11:29:14AM +0100, John Paul Adrian Glaubitz wrote:
> >> I can't say anything about the syscall interface. However, what I do know
> >> is that the weird combination of a 32-bit userland with a 64-bit kernel
> >> interface is sometimes causing issues. For example, application code usually
> >> expects things like time_t to be 32-bit on a 32-bit system. However, this
> 
> IMHO this just historically grown (as in "it has been forever that way"
> - it sounds way better in Viennese dialect though;-).
> 
> >> isn't the case for x32 which is why code fails to build.
> > 
> > I don't see any basis for this claim about expecting time_t to be
> > 32-bit. I've encountered some programs that "implicitly assume" this
> > by virtue of assuming they can cast time_t to long to print it, or
> > similar. IIRC this was an issue in busybox at one point; I'm not sure
> > if it's been fixed. But any software that runs on non-Linux unices has
> > long been corrected. If not, 2038 is sufficiently close that catching
> > and correcting any such remaining bugs is more useful than covering
> > them up and making the broken code work as expected.
> 
> Yup, unconditionally providing 64bit
> time_t/timespec/timeval/...-equivalents with libc and syscall support
> also for 32bit architectures (and deprecating all 32bit versions) should
> be the way to go.
> 
> FWIW I have
> ----  snip  ----
> #if defined __x86_64__
> # if defined __ILP32__		// x32
> #  define PRI_time_t	"lld"	// for time_t
> #  define PRI_nsec_t	"lld"	// for tv_nsec in struct timespec
> # else				// x86_64
> #  define PRI_time_t	"ld"	// for time_t
> #  define PRI_nsec_t	"ld"	// for tv_nsec in struct timespec
> # endif
> #else				// i[3-6]68
> # define PRI_time_t	"ld"	// for time_t
> # define PRI_nsec_t	"ld"	// for tv_nsec in struct timespec
> #endif
> ----  snip  ----
> in my userspace code for printf() and friends - I don't know how libc's
> react to such a patch (and I don't care for the name of the macros as
> long it's obviously clear for which type they are).
> I assume/fear we won't get additional modifiers into the relevant
> standards for libc types (as they are far more like pid_t, uid_t etc.).
> And casting to u/intmaxptr_t to get a defined printf()-modifier doesn't
> look appealing to me to "solve" such issues.

This is all useless (and wrong since tv_nsec is required to have type
long as part of C and POSIX, regardless of ILP32-vs-LP64; that's a bug
in glibc's x32). Just do:

	printf("%jd", (intmax_t)t);

Saving 2 or 3 insns (for sign or zero extension) around a call to
printf is not going to make any measurable difference to performance
or any significant difference to size, and it's immeasurably more
readable than the awful PRI* macros and the
adjacent-string-concatenation they rely on.

Rich
