From: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Subject: Re: [PATCH 2/3] ARM: convert to generated system call tables
Date: Tue, 25 Oct 2016 12:28:16 +0200
Message-ID: <4146248.jXuviLlvH5@wuerfel>
References: <E1bwa6s-0004ZY-4k@rmk-PC.armlinux.org.uk> <3851270.xZRcP9hae0@wuerfel> <20161025091210.rjfhvq4mqtuquei5@tower>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161025091210.rjfhvq4mqtuquei5@tower>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Michael Cree <mcree-q3Ck4f9/EBK9koe0gwxAeg@public.gmane.org>
Cc: Russell King - ARM Linux <linux-I+IVW8TIWO2tmTQ+vhA3Yw@public.gmane.org>, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-arch <linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-alpha-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Tuesday, October 25, 2016 10:12:10 PM CEST Michael Cree wrote:
> On Fri, Oct 21, 2016 at 03:06:45PM +0200, Arnd Bergmann wrote:
> > I see your point, but I think there are serious issues with the current
> > approach as well:
> > 
> > - a lot of the less common architectures just don't get updated
> >   in time, out of 22 architectures that don't use asm-generic/unistd.h,
> >   only 12 have pwritev2 in linux-next, and only three have pkey_mprotect
> > 
> > - some architectures that add all syscalls sometimes make a mistake
> >   and forget one, e.g. alpha apparently never added __NR_bpf, but it
> >   did add the later __NR_execveat.
> 
> __NR_bpf was not forgotten on Alpha.  It was not wired up because
> extra architecture support is needed which has not been implemented.
> 
> But maybe we should just wire it up to sys_ni_syscall in the meantime
> so a syscall number is reserved for it, and user space can call it to
> get -ENOSYS returned.

Ah, I must have misinterpreted the code then. I assumed that the
bpf syscall always works on all architectures, but that only the
jit compiler for it required architecture specific code to make it
more efficient.

The implementation of sys_bfp is compile-time selectable at the moment
and falls back to sys_no_syscall if CONFIG_BPF_SYSCALL is disabled.
If it doesn't work on Alpha, maybe that symbol could have a "depends
on !ALPHA" or "depends on BPF_SUPPORT"?

sys_seccomp is another one that falls into a similar category, but
it already depends on HAVE_ARCH_SECCOMP_FILTER, and most other
architectures have assigned a syscall number but not set this symbol.
This one will actually allow you to set strict seccomp mode even
without the Kconfig symbol, just not allow to set a filter.

	Arnd
