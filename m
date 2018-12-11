From: Andy Lutomirski <luto@kernel.org>
Subject: Can we drop upstream Linux x32 support?
Date: Mon, 10 Dec 2018 17:23:39 -0800
Message-ID: <CALCETrXoRAibsbWa9nfbDrt0iEuebMnCMhSFg-d9W-J2g8mDjw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>, Borislav Petkov <bp@alien8.de>, Florian Weimer <fweimer@redhat.com>, Mike Frysinger <vapier@gentoo.org>, "H. J. Lu" <hjl.tools@gmail.com>, Rich Felker <dalias@libc.org>, x32@buildd.debian.org, Arnd Bergmann <arnd@arndb.de>, Will Deacon <will.deacon@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Linus Torvalds <torvalds@linux-foundation.org>
List-Id: linux-api@vger.kernel.org

Hi all-

I'm seriously considering sending a patch to remove x32 support from
upstream Linux.  Here are some problems with it:

1. It's not entirely clear that it has users.  As far as I know, it's
supported on Gentoo and Debian, and the Debian popcon graph for x32
has been falling off dramatically.  I don't think that any enterprise
distro has ever supported x32.

2. The way that system calls work is very strange.  Most syscalls on
x32 enter through their *native* (i.e. not COMPAT_SYSCALL_DEFINE)
entry point, and this is intentional.  For example, adjtimex() uses
the native entry, not the compat entry, because x32's struct timex
matches the x86_64 layout.  But a handful of syscalls have separate
entry points -- these are the syscalls starting at 512.  These enter
through the COMPAT_SYSCALL_DEFINE entry points.

The x32 syscalls that are *not* in the 512 range violate all semblance
of kernel syscall convention.  In the syscall handlers,
in_compat_syscall() returns true, but the COMPAT_SYSCALL_DEFINE entry
is not invoked.   This is nutty and risks breaking things when people
refactor their syscall implementations.  And no one tests these
things.  Similarly, if someone calls any of the syscalls below 512 but
sets bit 31 in RAX, then the native entry will be called with
in_compat_set().

Conversely, if you call a syscall in the 512 range with bit 31
*clear*, then the compat entry is set with in_compat_syscall()
*clear*.  This is also nutty.

Finally, the kernel has a weird distinction between CONFIG_X86_X32_ABI
and and CONFIG_X86_X32, which I suspect results in incorrect builds if
the host doesn't have an x32 toolchain installed.

I propose that we make CONFIG_X86_X32 depend on BROKEN for a release
or two and then remove all the code if no one complains.  If anyone
wants to re-add it, IMO they're welcome to do so, but they need to do
it in a way that is maintainable.

--Andy
