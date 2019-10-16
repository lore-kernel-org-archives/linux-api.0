From: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCHv7 01/33] ns: Introduce Time Namespace
Date: Wed, 16 Oct 2019 12:39:11 +0200 (CEST)
Message-ID: <alpine.DEB.2.21.1910161230070.2046@nanos.tec.linutronix.de>
References: <20191011012341.846266-1-dima@arista.com> <20191011012341.846266-2-dima@arista.com> <80af93da-d497-81de-2a2a-179bb3bc852d@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <80af93da-d497-81de-2a2a-179bb3bc852d@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: Dmitry Safonov <dima@arista.com>, linux-kernel@vger.kernel.org, Dmitry Safonov <0x7f454c46@gmail.com>, Andrei Vagin <avagin@openvz.org>, Adrian Reber <adrian@lisas.de>, Andy Lutomirski <luto@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Christian Brauner <christian.brauner@ubuntu.com>, Cyrill Gorcunov <gorcunov@openvz.org>, "Eric W. Biederman" <ebiederm@xmission.com>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Jann Horn <jannh@google.com>, Jeff Dike <jdike@addtoit.com>, Oleg Nesterov <oleg@redhat.com>, Pavel Emelyanov <xemul@virtuozzo.com>, Shuah Khan <shuah@kernel.org>, containers@lists.linux-foundation.org, criu@openvz.org, linux-api@vger.kernel.org, x86@kernel.org, Andrei Vagin <avagin@gmail.com>
List-Id: linux-api@vger.kernel.org

On Wed, 16 Oct 2019, Vincenzo Frascino wrote:

< Trim 250+ lines ( 3+ pages) of pointlessly wasted electrons >

> > --- a/init/Kconfig
> > +++ b/init/Kconfig
> > @@ -1096,6 +1096,13 @@ config UTS_NS
> >  	  In this namespace tasks see different info provided with the
> >  	  uname() system call
> >  
> > +config TIME_NS
> > +	bool "TIME namespace"
> > +	default y
> 
> Having CONFIG_TIME_NS "default y" makes so that the option is selected even on
> the architectures that have no support for time namespaces.
> The direct consequence is that the fallbacks defined in this patch are never
> selected and this ends up in kernel compilation errors due to missing symbols.
> 
> The error below shows what happens on arm64 (similar behavior on other
> architectures):
> 
> aarch64-linux-gnu-ld: kernel/time/namespace.o: in function `timens_on_fork':
> kernel/time/namespace.c:321: undefined reference to `vdso_join_timens'
> 
> My proposal is to keep TIME_NS "default n" (just remove "default y"), let the
> architectures that enable time namespaces select it and make CONFIG_TIME_NS
> select GENERIC_VDSO_TIME_NS if arch has HAVE_GENERIC_VDSO.

Nah.

config TIME_NS
	bool "TIME namespace"
	depends on GENERIC_VDSO_TIME_NS
	default y

and in lib/vdso/Kconfig

config GENERIC_VDSO_TIME_NS
	bool

and let architectures which have support for the VDSO bits select it.

< Trim another gazillion of useless lines >

See: https://people.kernel.org/tglx/notes-about-netiquette

Thanks,

	tglx
