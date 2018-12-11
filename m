From: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Subject: Re: Can we drop upstream Linux x32 support?
Date: Tue, 11 Dec 2018 11:29:14 +0100
Message-ID: <70bb54b2-8ed3-b5ee-c02d-6ef66c4f27eb@physik.fu-berlin.de>
References: <CALCETrXoRAibsbWa9nfbDrt0iEuebMnCMhSFg-d9W-J2g8mDjw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CALCETrXoRAibsbWa9nfbDrt0iEuebMnCMhSFg-d9W-J2g8mDjw@mail.gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@kernel.org>, X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>, Borislav Petkov <bp@alien8.de>, Florian Weimer <fweimer@redhat.com>, Mike Frysinger <vapier@gentoo.org>, "H. J. Lu" <hjl.tools@gmail.com>, Rich Felker <dalias@libc.org>, x32@buildd.debian.org, Arnd Bergmann <arnd@arndb.de>, Will Deacon <will.deacon@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Linus Torvalds <torvalds@linux-foundation.org>
List-Id: linux-api@vger.kernel.org

Hello!

I'm Debian's principal maintainer of the x32 port.

On 12/11/18 2:23 AM, Andy Lutomirski wrote:
> 1. It's not entirely clear that it has users.  As far as I know, it's
> supported on Gentoo and Debian, and the Debian popcon graph for x32
> has been falling off dramatically.  I don't think that any enterprise
> distro has ever supported x32.

There are definitely some users of this port. I don't know the actual
number, but I hear from users from time to time. As for the popcon
curve, I wouldn't say it has dropped dramatically as it was never
high in the first place.

> https://popcon.debian.org/stat/sub-x32.png

It seems that the highest number of recorded users was 18 and it's
now down to 7. Keep in mind though that popcon participation is
opt-in, so the actual number of users should be higher. According
to popcon, there are also only 172331 Debian installations on x86_64:

> https://popcon.debian.org/

As for the enterprise support, this seems to be correct. I don't know
of any enterprise distribution with x32 support either.

> 2. The way that system calls work is very strange.  Most syscalls on
> x32 enter through their *native* (i.e. not COMPAT_SYSCALL_DEFINE)
> entry point, and this is intentional.  For example, adjtimex() uses
> the native entry, not the compat entry, because x32's struct timex
> matches the x86_64 layout.  But a handful of syscalls have separate
> entry points -- these are the syscalls starting at 512.  These enter
> through the COMPAT_SYSCALL_DEFINE entry points.
> 
> The x32 syscalls that are *not* in the 512 range violate all semblance
> of kernel syscall convention.  In the syscall handlers,
> in_compat_syscall() returns true, but the COMPAT_SYSCALL_DEFINE entry
> is not invoked.   This is nutty and risks breaking things when people
> refactor their syscall implementations.  And no one tests these
> things.  Similarly, if someone calls any of the syscalls below 512 but
> sets bit 31 in RAX, then the native entry will be called with
> in_compat_set().
> 
> Conversely, if you call a syscall in the 512 range with bit 31
> *clear*, then the compat entry is set with in_compat_syscall()
> *clear*.  This is also nutty.

I can't say anything about the syscall interface. However, what I do know
is that the weird combination of a 32-bit userland with a 64-bit kernel
interface is sometimes causing issues. For example, application code usually
expects things like time_t to be 32-bit on a 32-bit system. However, this
isn't the case for x32 which is why code fails to build.

Additionally, x32 support in many applications is either rudimentary
or broken. For example, while LLVM has support for x32, the backend
isn't really stable on this target meaning that compilers like clang
or Rust are partially broken or crash. I'm not sure whether anyone
is interested in fixing this.

It's also that the performance benefits of x32 are often eaten up by
the fact that none of the scripted languages that I know of provide
a JIT that supports x32. Thus, things like Javascript are either
unsupported or slow on x32.

> I propose that we make CONFIG_X86_X32 depend on BROKEN for a release
> or two and then remove all the code if no one complains.  If anyone
> wants to re-add it, IMO they're welcome to do so, but they need to do
> it in a way that is maintainable.

I'm not terribly opposed to this change. I'm usually for keeping support
for things that people are using, but the maintenance is a huge burden
to upstream projects, I'm fine with letting it go.

There are other architectures in the kernel like Alpha, HPPA, M68K, PowerPC,
SH and SPARC that I care much more about than x32.

If x32 is eventually to be removed, we should also take care of removing
x32 support from userland code. From the top of my head, this would at least
concern:

 * OpenJDK
 * LLVM
 * gcc
 * glibc
 * Rust
 * binutils

I can take care of these once I know about the decision regarding the kernel.
Usually, it's a matter of grepping the commit history for "x32" and revert
the corresponding commits.

Thanks,
Adrian

-- 
 .''`.  John Paul Adrian Glaubitz
: :' :  Debian Developer - glaubitz@debian.org
`. `'   Freie Universitaet Berlin - glaubitz@physik.fu-berlin.de
  `-    GPG: 62FF 8A75 84E0 2956 9546  0006 7426 3B37 F5B5 F913
