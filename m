From: Stepan Golosunov <stepan@golosunov.pp.ru>
Subject: Re: [PATCH 1/2] y2038: make CONFIG_64BIT_TIME unconditional
Date: Sat, 27 Apr 2019 13:54:18 +0400
Message-ID: <20190427095418.344yoomf5nwznatd@sghpc.golosunov.pp.ru>
References: <20190426142531.1378357-1-arnd@arndb.de>
 <20190427004653.3cecd1cb@jawa>
Mime-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Transfer-Encoding: 8bit
Return-path: <libc-alpha-return-101632-glibc-alpha=m.gmane.org@sourceware.org>
List-Unsubscribe: <mailto:libc-alpha-unsubscribe-glibc-alpha=m.gmane.org@sourceware.org>
List-Subscribe: <mailto:libc-alpha-subscribe@sourceware.org>
List-Archive: <http://sourceware.org/ml/libc-alpha/>
List-Post: <mailto:libc-alpha@sourceware.org>
List-Help: <mailto:libc-alpha-help@sourceware.org>, <http://sourceware.org/ml/#faqs>
Sender: libc-alpha-owner@sourceware.org
Content-Disposition: inline
In-Reply-To: <20190427004653.3cecd1cb@jawa>
To: Lukasz Majewski <lukma@denx.de>
Cc: Arnd Bergmann <arnd@arndb.de>, Thomas Gleixner <tglx@linutronix.de>, Joseph Myers <joseph@codesourcery.com>, libc-alpha@sourceware.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, Deepa Dinamani <deepa.kernel@gmail.com>
List-Id: linux-api@vger.kernel.org

27.04.2019 в 00:46:53 +0200 Lukasz Majewski написал:
> Hi Arnd,
> 
> > As Stepan Golosunov points out, we made a small mistake in the
> > get_timespec64() function in the kernel. It was originally added under
> > the assumption that CONFIG_64BIT_TIME would get enabled on all 32-bit
> > and 64-bit architectures, but when I did the conversion, I only turned
> > it on for 32-bit ones.
> > 
> > The effect is that the get_timespec64() function never clears the
> > upper half of the tv_nsec field for 32-bit tasks in compat mode.
> > Clearing this is required for POSIX compliant behavior of functions
> > that pass a 'timespec' structure with a 64-bit tv_sec and a 32-bit
> > tv_nsec, plus uninitialized padding.

> At least for my setup (32bit ARM with 64 bit time support) this patch is
> not fixing anything.

The patch is not supposed to fix anything on 32-bit architectures as
in-kernel struct timespec64 has 32-bit tv_nsec there.  Thus truncation
should happen automatically.  I also missed that fact when I was
reading get_timespec64 code.

(I am wondering whether such trucation is undefined behaviour in C and
whether there should be sign-extension instead of zeroing-out for the
in_compat_syscall() case though.)

> > The easiest fix for linux-5.1 is to just make the Kconfig symbol
> > unconditional, as it was originally intended. As a follow-up,
> > we should remove any #ifdef CONFIG_64BIT_TIME completely.
> > 
> > Link:
> > https://lore.kernel.org/lkml/20190422090710.bmxdhhankurhafxq@sghpc.golosunov.pp.ru/
> > Cc: Lukasz Majewski <lukma@denx.de> Cc: Stepan Golosunov
> > <stepan@golosunov.pp.ru> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> > ---
> > Please apply this one as a bugfix for 5.1
> > ---
> >  arch/Kconfig | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/arch/Kconfig b/arch/Kconfig
> > index 33687dddd86a..9092e0ffe4d3 100644
> > --- a/arch/Kconfig
> > +++ b/arch/Kconfig
> > @@ -764,7 +764,7 @@ config COMPAT_OLD_SIGACTION
> >  	bool
> >  
> >  config 64BIT_TIME
> > -	def_bool ARCH_HAS_64BIT_TIME
> > +	def_bool y
> >  	help
> >  	  This should be selected by all architectures that need to
> > support new system calls with a 64-bit time_t. This is relevant on
> > all 32-bit
