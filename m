From: Florian Weimer <fweimer@redhat.com>
Subject: Re: Can we drop upstream Linux x32 support?
Date: Tue, 11 Dec 2018 12:37:42 +0100
Message-ID: <87efaoxpix.fsf@oldenburg2.str.redhat.com>
References: <CALCETrXoRAibsbWa9nfbDrt0iEuebMnCMhSFg-d9W-J2g8mDjw@mail.gmail.com>
        <CAMe9rOp0m5sn59AsD2F2i2Ad2tb7ufPU1mMg-vUOfh+TnGMeaw@mail.gmail.com>
        <CALCETrU5xw61=me1YcTO3VPzjNEZahMPpi-20-oiSGs+CHcj4g@mail.gmail.com>
        <CAK8P3a0adxnXr9JLfpR5MBeEJXSCK2Rt4w7NFLUUwO6s6LBVPQ@mail.gmail.com>
        <20181211113230.GB35824@arrakis.emea.arm.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181211113230.GB35824@arrakis.emea.arm.com> (Catalin Marinas's
        message of "Tue, 11 Dec 2018 11:32:31 +0000")
Sender: linux-kernel-owner@vger.kernel.org
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Andy Lutomirski <luto@kernel.org>, "H.J. Lu" <hjl.tools@gmail.com>, the arch/x86 maintainers <x86@kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>, Borislav Petkov <bp@alien8.de>, vapier@gentoo.org, Rich Felker <dalias@libc.org>, x32@buildd.debian.org, Will Deacon <will.deacon@arm.com>, Linus Torvalds <torvalds@linux-foundation.org>
List-Id: linux-api@vger.kernel.org

* Catalin Marinas:

> On Tue, Dec 11, 2018 at 10:02:45AM +0100, Arnd Bergmann wrote:
>> On Tue, Dec 11, 2018 at 6:35 AM Andy Lutomirski <luto@kernel.org> wrote:
>> > I tried to understand what's going on.  As far as I can tell, most of
>> > the magic is the fact that __kernel_long_t and __kernel_ulong_t are
>> > 64-bit as seen by x32 user code.  This means that a decent number of
>> > uapi structures are the same on x32 and x86_64.  Syscalls that only
>> > use structures like this should route to the x86_64 entry points.  But
>> > the implementation is still highly dubious -- in_compat_syscall() will
>> > be *true* in such system calls,
>> 
>> I think the fundamental issue was that the intention had always been
>> to use only the 64-bit entry points for system calls, but the most
>> complex one we have -- ioctl() -- has to use the compat entry point
>> because device drivers define their own data structures using 'long'
>> and pointer members and they need translation, as well as
>> matching in_compat_syscall() checks. This in turn breaks down
>> again whenever a driver defines an ioctl command that takes
>> a __kernel_long_t or a derived type like timespec as its argument.
>
> With arm64 ILP32 we tried to avoid the ioctl() problem by having
> __kernel_long_t 32-bit, IOW mimicking the arm32 ABI (compat). The
> biggest pain point is signals where the state is completely different
> from arm32 (more, wider registers) and can't be dealt with by the compat
> layer.

I would expect to approach this from the opposite direction: use 64-bit
types in places where the 64-bit kernel interface uses 64-bit types.
After all, not everyone who is interested in ILP32 has a companion
32-bit architecture which could serve as a model for the application
ABI.

(If there are conflicts with POSIX, then POSIX needs to be fixed to
support this.)

Thanks,
Florian
