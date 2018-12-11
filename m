From: Andy Lutomirski <luto@kernel.org>
Subject: Re: Can we drop upstream Linux x32 support?
Date: Mon, 10 Dec 2018 21:35:02 -0800
Message-ID: <CALCETrU5xw61=me1YcTO3VPzjNEZahMPpi-20-oiSGs+CHcj4g@mail.gmail.com>
References: <CALCETrXoRAibsbWa9nfbDrt0iEuebMnCMhSFg-d9W-J2g8mDjw@mail.gmail.com>
 <CAMe9rOp0m5sn59AsD2F2i2Ad2tb7ufPU1mMg-vUOfh+TnGMeaw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAMe9rOp0m5sn59AsD2F2i2Ad2tb7ufPU1mMg-vUOfh+TnGMeaw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "H. J. Lu" <hjl.tools@gmail.com>
Cc: Andrew Lutomirski <luto@kernel.org>, X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>, Borislav Petkov <bp@alien8.de>, Florian Weimer <fweimer@redhat.com>, Mike Frysinger <vapier@gentoo.org>, Rich Felker <dalias@libc.org>, x32@buildd.debian.org, Arnd Bergmann <arnd@arndb.de>, Will Deacon <will.deacon@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Linus Torvalds <torvalds@linux-foundation.org>
List-Id: linux-api@vger.kernel.org

On Mon, Dec 10, 2018 at 7:15 PM H.J. Lu <hjl.tools@gmail.com> wrote:
>
> On Mon, Dec 10, 2018 at 5:23 PM Andy Lutomirski <luto@kernel.org> wrote:
> >
> > Hi all-
> >
> > I'm seriously considering sending a patch to remove x32 support from
> > upstream Linux.  Here are some problems with it:
> >
> > 1. It's not entirely clear that it has users.  As far as I know, it's
> > supported on Gentoo and Debian, and the Debian popcon graph for x32
> > has been falling off dramatically.  I don't think that any enterprise
> > distro has ever supported x32.
>
> I have been posting x32 GCC results for years:
>
> https://gcc.gnu.org/ml/gcc-testresults/2018-12/msg01358.html

Right.  My question wasn't whether x32 had developers -- it was
whether it had users.  If the only users are a small handful of people
who keep the toolchain and working and some people who benchmark it,
then I think the case for keeping it in upstream Linux is a bit weak.

>
> > 2. The way that system calls work is very strange.  Most syscalls on
> > x32 enter through their *native* (i.e. not COMPAT_SYSCALL_DEFINE)
> > entry point, and this is intentional.  For example, adjtimex() uses
> > the native entry, not the compat entry, because x32's struct timex
> > matches the x86_64 layout.  But a handful of syscalls have separate
>
> This becomes less an issue with 64-bit time_t.
>
> > entry points -- these are the syscalls starting at 512.  These enter
> > throuh the COMPAT_SYSCALL_DEFINE entry points.
> >
> > The x32 syscalls that are *not* in the 512 range violate all semblance
> > of kernel syscall convention.  In the syscall handlers,
> > in_compat_syscall() returns true, but the COMPAT_SYSCALL_DEFINE entry
> > is not invoked.   This is nutty and risks breaking things when people
> > refactor their syscall implementations.  And no one tests these
> > things.  Similarly, if someone calls any of the syscalls below 512 but
> > sets bit 31 in RAX, then the native entry will be called with
> > in_compat_set().
> >
> > Conversely, if you call a syscall in the 512 range with bit 31
> > *clear*, then the compat entry is set with in_compat_syscall()
> > *clear*.  This is also nutty.
>
> This is to share syscalls between LP64 and ILP32 (x32) in x86-64 kernel.
>

I tried to understand what's going on.  As far as I can tell, most of
the magic is the fact that __kernel_long_t and __kernel_ulong_t are
64-bit as seen by x32 user code.  This means that a decent number of
uapi structures are the same on x32 and x86_64.  Syscalls that only
use structures like this should route to the x86_64 entry points.  But
the implementation is still highly dubious -- in_compat_syscall() will
be *true* in such system calls, which means that, if someone changes:

SYSCALL_DEFINE1(some_func, struct some_struct __user *, ptr)
{
  /* x32 goes here, but it's entirely non-obvious unless you read the
x86 syscall table */
  native impl;
}

COMPAT_SYSCALL_DEFINE1(some_func, struct compat_some_struct __user *, ptr)
{
  compat impl;
}

to the Obviously Equivalent (tm):

SYSCALL_DEFINE1(some_func, struct some_struct __user *, ptr)
{
  struct some_struct kernel_val;
  if (in_compat_syscall()) {
    get_compat_some_struct(&kernel_val, ptr);
  } else {
    copy_from_user(&kernel_val, ptr, sizeof(struct some_struct));
  }
  do the work;
}

then x32 breaks.

And I don't even know how x32 is supposed to support some hypothetical
syscall like this:

long sys_nasty(struct adjtimex *a, struct iovec *b);

where one argument has x32 and x86_64 matching but the other has x32
and x86_32 matching.

This whole thing seems extremely fragile.
