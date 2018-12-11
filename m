From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: Can we drop upstream Linux x32 support?
Date: Tue, 11 Dec 2018 10:02:45 +0100
Message-ID: <CAK8P3a0adxnXr9JLfpR5MBeEJXSCK2Rt4w7NFLUUwO6s6LBVPQ@mail.gmail.com>
References: <CALCETrXoRAibsbWa9nfbDrt0iEuebMnCMhSFg-d9W-J2g8mDjw@mail.gmail.com>
 <CAMe9rOp0m5sn59AsD2F2i2Ad2tb7ufPU1mMg-vUOfh+TnGMeaw@mail.gmail.com> <CALCETrU5xw61=me1YcTO3VPzjNEZahMPpi-20-oiSGs+CHcj4g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CALCETrU5xw61=me1YcTO3VPzjNEZahMPpi-20-oiSGs+CHcj4g@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@kernel.org>
Cc: "H.J. Lu" <hjl.tools@gmail.com>, the arch/x86 maintainers <x86@kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>, Borislav Petkov <bp@alien8.de>, Florian Weimer <fweimer@redhat.com>, vapier@gentoo.org, Rich Felker <dalias@libc.org>, x32@buildd.debian.org, Will Deacon <will.deacon@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Linus Torvalds <torvalds@linux-foundation.org>
List-Id: linux-api@vger.kernel.org

On Tue, Dec 11, 2018 at 6:35 AM Andy Lutomirski <luto@kernel.org> wrote:
> On Mon, Dec 10, 2018 at 7:15 PM H.J. Lu <hjl.tools@gmail.com> wrote:
> > On Mon, Dec 10, 2018 at 5:23 PM Andy Lutomirski <luto@kernel.org> wrote:
> Right.  My question wasn't whether x32 had developers -- it was
> whether it had users.  If the only users are a small handful of people
> who keep the toolchain and working and some people who benchmark it,
> then I think the case for keeping it in upstream Linux is a bit weak.

+1

> > > Conversely, if you call a syscall in the 512 range with bit 31
> > > *clear*, then the compat entry is set with in_compat_syscall()
> > > *clear*.  This is also nutty.
> >
> > This is to share syscalls between LP64 and ILP32 (x32) in x86-64 kernel.
> >
>
> I tried to understand what's going on.  As far as I can tell, most of
> the magic is the fact that __kernel_long_t and __kernel_ulong_t are
> 64-bit as seen by x32 user code.  This means that a decent number of
> uapi structures are the same on x32 and x86_64.  Syscalls that only
> use structures like this should route to the x86_64 entry points.  But
> the implementation is still highly dubious -- in_compat_syscall() will
> be *true* in such system calls,

I think the fundamental issue was that the intention had always been
to use only the 64-bit entry points for system calls, but the most
complex one we have -- ioctl() -- has to use the compat entry point
because device drivers define their own data structures using 'long'
and pointer members and they need translation, as well as
matching in_compat_syscall() checks. This in turn breaks down
again whenever a driver defines an ioctl command that takes
a __kernel_long_t or a derived type like timespec as its argument.

> which means that, if someone changes:
>
...
> where one argument has x32 and x86_64 matching but the other has x32
> and x86_32 matching.
>
> This whole thing seems extremely fragile.

It definitely is. We have lots of workarounds specifically for
x32 in device drivers, but in the time_t conversion for y2038
I still found ones that had not been caught earlier, and for each
y2038 conversion that someone did to a driver or syscall, we have
to make sure that it doesn't break x32 in the process.

         Arnd
