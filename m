From: Stafford Horne <shorne@gmail.com>
Subject: Re: [PATCH 2/2] [RFC] disable -Wattribute-alias warning for
 SYSCALL_DEFINEx()
Date: Tue, 12 Jun 2018 06:19:53 +0900
Message-ID: <20180611211953.GJ3652@lianli.shorne-pla.net>
References: <20171205153259.2522368-1-arnd@arndb.de>
 <20171205160651.2920270-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171205160651.2920270-1-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kbuild@vger.kernel.org, Michal Marek <michal.lkml@markovi.net>, Masahiro Yamada <yamada.masahiro@socionext.com>, Douglas Anderson <dianders@chromium.org>, Al Viro <viro@zeniv.linux.org.uk>, Heiko Carstens <heiko.carstens@de.ibm.com>, Mauro Carvalho Chehab <mchehab@kernel.org>, Matthew Wilcox <matthew@wil.cx>, Matthias Kaehlcke <mka@chromium.org>, Deepa Dinamani <deepa.kernel@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, Frederic Weisbecker <fweisbec@gmail.com>, Stephan Mueller <smueller@chronox.de>, "David S. Miller" <davem@davemloft.net>, Yonghong Song <yhs@fb.com>, Thomas Garnier <thgarnie@google.com>, David Howells <dhowells@redhat.com>, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Tue, Dec 05, 2017 at 05:06:31PM +0100, Arnd Bergmann wrote:
> gcc-8 warns for every single definition of a system call entry
> point, e.g.:
> 
> include/linux/compat.h:56:18: error: 'compat_sys_rt_sigprocmask' alias between functions of incompatible types 'long int(int,  compat_sigset_t *, compat_sigset_t *, compat_size_t)' {aka 'long int(int,  struct <anonymous> *, struct <anonymous> *, unsigned int)'} and 'long int(long int,  long int,  long int,  long int)' [-Werror=attribute-alias]
>   asmlinkage long compat_sys##name(__MAP(x,__SC_DECL,__VA_ARGS__))\
>                   ^~~~~~~~~~
> include/linux/compat.h:45:2: note: in expansion of macro 'COMPAT_SYSCALL_DEFINEx'
>   COMPAT_SYSCALL_DEFINEx(4, _##name, __VA_ARGS__)
>   ^~~~~~~~~~~~~~~~~~~~~~
> kernel/signal.c:2601:1: note: in expansion of macro 'COMPAT_SYSCALL_DEFINE4'
>  COMPAT_SYSCALL_DEFINE4(rt_sigprocmask, int, how, compat_sigset_t __user *, nset,
>  ^~~~~~~~~~~~~~~~~~~~~~
> include/linux/compat.h:60:18: note: aliased declaration here
>   asmlinkage long compat_SyS##name(__MAP(x,__SC_LONG,__VA_ARGS__))\
>                   ^~~~~~~~~~
> 
> The new warning seems reasonable in principle, but it doesn't
> help us here, since we rely on the type mismatch to sanitize the
> system call arguments. After I reported this as GCC PR82435, a new
> -Wno-attribute-alias option was added that could be used to turn the
> warning off globally on the command line, but I'd prefer to do it a
> little more fine-grained.
> 
> Interestingly, turning a warning off and on again inside of
> a single macro doesn't always work, in this case I had to add
> an extra statement inbetween and decided to copy the __SC_TEST
> one from the native syscall to the compat syscall macro.  See
> https://gcc.gnu.org/bugzilla/show_bug.cgi?id=83256 for more details
> about this.
> 
> Link: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=82435
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Hi Arnd,

What ever happened to this patch?  I am compiline the kernel with the new
OpenRISC GCC backend port https://github.com/stffrdhrn/gcc/commits/or1k-port,
which is based on gcc 9.0.0 and seeing similar 'alias between functions of
incompatible types' warnings.

I found this old patch which seems will fix the issue, but it seems to not have
been merged.  Did we find another solution?

Case in point, when I build x86 64 on gcc 8.1.1, I am not seeing the warnings.
Is this not an issue for x86?

-Stafford
