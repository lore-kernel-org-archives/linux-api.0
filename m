From: Michael Cree <mcree-q3Ck4f9/EBK9koe0gwxAeg@public.gmane.org>
Subject: bpf on Alpha [was Re: [PATCH 2/3] ARM: convert to generated system
 call tables]
Date: Wed, 26 Oct 2016 22:12:50 +1300
Message-ID: <20161026091250.djo6edsgjs7crsmg@tower>
References: <E1bwa6s-0004ZY-4k@rmk-PC.armlinux.org.uk>
 <3851270.xZRcP9hae0@wuerfel>
 <20161025091210.rjfhvq4mqtuquei5@tower>
 <4146248.jXuviLlvH5@wuerfel>
 <20161026070430.e2tkbzza5lk4lgju@tower>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20161026070430.e2tkbzza5lk4lgju@tower>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Russell King - ARM Linux <linux-I+IVW8TIWO2tmTQ+vhA3Yw@public.gmane.org>, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-arch <linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-alpha-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Wed, Oct 26, 2016 at 08:04:30PM +1300, Michael Cree wrote:
> On Tue, Oct 25, 2016 at 12:28:16PM +0200, Arnd Bergmann wrote:
> > On Tuesday, October 25, 2016 10:12:10 PM CEST Michael Cree wrote:
> > > On Fri, Oct 21, 2016 at 03:06:45PM +0200, Arnd Bergmann wrote:
> > > > I see your point, but I think there are serious issues with the current
> > > > approach as well:
> > > > 
> > > > - a lot of the less common architectures just don't get updated
> > > >   in time, out of 22 architectures that don't use asm-generic/unistd.h,
> > > >   only 12 have pwritev2 in linux-next, and only three have pkey_mprotect
> > > > 
> > > > - some architectures that add all syscalls sometimes make a mistake
> > > >   and forget one, e.g. alpha apparently never added __NR_bpf, but it
> > > >   did add the later __NR_execveat.
> > > 
> > > __NR_bpf was not forgotten on Alpha.  It was not wired up because
> > > extra architecture support is needed which has not been implemented.
> > > 
> > > But maybe we should just wire it up to sys_ni_syscall in the meantime
> > > so a syscall number is reserved for it, and user space can call it to
> > > get -ENOSYS returned.
> > 
> > Ah, I must have misinterpreted the code then. I assumed that the
> > bpf syscall always works on all architectures, but that only the
> > jit compiler for it required architecture specific code to make it
> > more efficient.
> 
> Oh.  When someone posted wiring up of syscalls on Alpha some time
> back I raised a query about seccomp then someone else (I can't be
> bothered looking up the old emails, it doesn't really matter)
> said bpf was in the same basket, so the patch was re-submitted with
> neither of those syscalls.
> 
> > sys_seccomp is another one that falls into a similar category, but
> > it already depends on HAVE_ARCH_SECCOMP_FILTER, and most other
> > architectures have assigned a syscall number but not set this symbol.
> > This one will actually allow you to set strict seccomp mode even
> > without the Kconfig symbol, just not allow to set a filter.
> 
> We have got way behind on syscalls on Alpha and I was just in the
> process of wiring them up and testing them, so I will include both
> seccomp and bpf in that.

Having just wired up bpf on an Alpha and run samples/bpf/test_verifier
I get:

#0 add+sub+mul OK
#1 unreachable OK
#2 unreachable2 OK
#3 out of range jump OK

[snip many passing tests]

#69 unpriv: check that printk is disallowed FAIL
failed to load prog 'Invalid argument'
0: (7a) *(u64 *)(r10 -8) = 0
1: (bf) r1 = r10
2: (07) r1 += -8
3: (b7) r2 = 8
4: (bf) r3 = r1
5: (85) call 6
unknown func 6

[snip many more passing tests]

Summary: 101 PASSED, 1 FAILED

Should I be concerned about the failing #69 test?

Cheers
Michael.
