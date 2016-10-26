From: Michael Cree <mcree@orcon.net.nz>
Subject: Re: [PATCH 2/3] ARM: convert to generated system call tables
Date: Wed, 26 Oct 2016 20:04:30 +1300
Message-ID: <20161026070430.e2tkbzza5lk4lgju@tower>
References: <E1bwa6s-0004ZY-4k@rmk-PC.armlinux.org.uk>
 <3851270.xZRcP9hae0@wuerfel>
 <20161025091210.rjfhvq4mqtuquei5@tower>
 <4146248.jXuviLlvH5@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-alpha-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4146248.jXuviLlvH5@wuerfel>
Sender: linux-alpha-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: Russell King - ARM Linux <linux@armlinux.org.uk>, linux-arm-kernel@lists.infradead.org, linux-arch <linux-arch@vger.kernel.org>, linux-api <linux-api@vger.kernel.org>, linux-alpha@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Tue, Oct 25, 2016 at 12:28:16PM +0200, Arnd Bergmann wrote:
> On Tuesday, October 25, 2016 10:12:10 PM CEST Michael Cree wrote:
> > On Fri, Oct 21, 2016 at 03:06:45PM +0200, Arnd Bergmann wrote:
> > > I see your point, but I think there are serious issues with the current
> > > approach as well:
> > > 
> > > - a lot of the less common architectures just don't get updated
> > >   in time, out of 22 architectures that don't use asm-generic/unistd.h,
> > >   only 12 have pwritev2 in linux-next, and only three have pkey_mprotect
> > > 
> > > - some architectures that add all syscalls sometimes make a mistake
> > >   and forget one, e.g. alpha apparently never added __NR_bpf, but it
> > >   did add the later __NR_execveat.
> > 
> > __NR_bpf was not forgotten on Alpha.  It was not wired up because
> > extra architecture support is needed which has not been implemented.
> > 
> > But maybe we should just wire it up to sys_ni_syscall in the meantime
> > so a syscall number is reserved for it, and user space can call it to
> > get -ENOSYS returned.
> 
> Ah, I must have misinterpreted the code then. I assumed that the
> bpf syscall always works on all architectures, but that only the
> jit compiler for it required architecture specific code to make it
> more efficient.

Oh.  When someone posted wiring up of syscalls on Alpha some time
back I raised a query about seccomp then someone else (I can't be
bothered looking up the old emails, it doesn't really matter)
said bpf was in the same basket, so the patch was re-submitted with
neither of those syscalls.

> sys_seccomp is another one that falls into a similar category, but
> it already depends on HAVE_ARCH_SECCOMP_FILTER, and most other
> architectures have assigned a syscall number but not set this symbol.
> This one will actually allow you to set strict seccomp mode even
> without the Kconfig symbol, just not allow to set a filter.

We have got way behind on syscalls on Alpha and I was just in the
process of wiring them up and testing them, so I will include both
seccomp and bpf in that.

Cheers
Michael.
