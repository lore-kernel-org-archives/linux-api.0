From: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Subject: Re: [PATCH 2/2] kernel: Support compiling out the prctl syscall
Date: Tue, 8 Nov 2016 16:40:02 -0800
Message-ID: <CAGXu5j+V11oF0gcqBQTsBMgetsSdRqLQffobhyEbze82gbW2vA@mail.gmail.com>
References: <cover.c693f10dfc19e12c214758e4b13ca9b4e4cf9668.1478650356.git-series.josh@joshtriplett.org>
 <b5c45594261252a486b891090eba8f10aa7ed329.1478650356.git-series.josh@joshtriplett.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <b5c45594261252a486b891090eba8f10aa7ed329.1478650356.git-series.josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Petr Mladek <pmladek-IBi9RG/b67k@public.gmane.org>, Thomas Garnier <thgarnie-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Nicolas Pitre <nicolas.pitre-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Li Bin <huawei.libin-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Dmitry Vyukov <dvyukov-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Ralf Baechle <ralf-6z/3iImG2C8G8FEW9MqTrA@public.gmane.org>, Alex Thorlton <athorlton-sJ/iWh9BUns@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Mateusz Guzik <mguzik-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Cyrill Gorcunov <gorcunov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Zach Brown <zab@redha>
List-Id: linux-api@vger.kernel.org

On Tue, Nov 8, 2016 at 4:18 PM, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org> wrote:
> Some embedded systems can do without the prctl syscall, saving some
> space.
>
> This also avoids regular increases in tinyconfig size as people add more
> non-optional functionality to prctl (observed via the 0-day kernel
> infrastructure).
>
> bloat-o-meter results:
>
> add/remove: 0/3 grow/shrink: 0/1 up/down: 0/-2143 (-2143)
> function                                     old     new   delta
> offsets                                       23      12     -11
> prctl_set_auxv                                97       -     -97
> sys_prctl                                    794       -    -794
> prctl_set_mm                                1241       -   -1241
> Total: Before=1902583, After=1900440, chg -0.11%
>
> Signed-off-by: Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>

I'm absolutely a fan of doing this, but I wonder how this interacts
with the LSMs that define prctl hooks, etc. I wouldn't expect a system
that didn't want prctl to want an LSM, but maybe the LSMs all need to
depend on CONFIG_PRCTL now?

-Kees

> ---
>  init/Kconfig    | 12 ++++++++++++
>  kernel/Makefile |  3 ++-
>  kernel/sys_ni.c |  1 +
>  3 files changed, 15 insertions(+), 1 deletion(-)
>
> diff --git a/init/Kconfig b/init/Kconfig
> index 34407f1..1dd671c 100644
> --- a/init/Kconfig
> +++ b/init/Kconfig
> @@ -1408,6 +1408,18 @@ config MULTIUSER
>
>           If unsure, say Y here.
>
> +config PRCTL
> +       bool "prctl syscall" if EXPERT
> +       default y
> +       help
> +         This option enables the prctl syscall, used for a variety of
> +         operations on the current process.
> +
> +         If building an embedded system where no applications or libraries use
> +         prctl, you can disable this option to save space.
> +
> +         If unsure, say Y here.
> +
>  config SGETMASK_SYSCALL
>         bool "sgetmask/ssetmask syscalls support" if EXPERT
>         def_bool PARISC || MN10300 || BLACKFIN || M68K || PPC || MIPS || X86 || SPARC || CRIS || MICROBLAZE || SUPERH
> diff --git a/kernel/Makefile b/kernel/Makefile
> index 37c6d4c..43fb4ca 100644
> --- a/kernel/Makefile
> +++ b/kernel/Makefile
> @@ -9,9 +9,10 @@ obj-y     = fork.o exec_domain.o panic.o \
>             extable.o params.o \
>             kthread.o sys_ni.o nsproxy.o \
>             notifier.o ksysfs.o cred.o reboot.o \
> -           async.o range.o smpboot.o ucount.o prctl.o
> +           async.o range.o smpboot.o ucount.o
>
>  obj-$(CONFIG_MULTIUSER) += groups.o
> +obj-$(CONFIG_PRCTL) += prctl.o
>
>  ifdef CONFIG_FUNCTION_TRACER
>  # Do not trace internal ftrace files
> diff --git a/kernel/sys_ni.c b/kernel/sys_ni.c
> index 635482e..84fd646 100644
> --- a/kernel/sys_ni.c
> +++ b/kernel/sys_ni.c
> @@ -175,6 +175,7 @@ cond_syscall(sys_setfsgid);
>  cond_syscall(sys_capget);
>  cond_syscall(sys_capset);
>  cond_syscall(sys_copy_file_range);
> +cond_syscall(sys_prctl);
>
>  /* arch-specific weak syscall entries */
>  cond_syscall(sys_pciconfig_read);
> --
> git-series 0.8.11



-- 
Kees Cook
Nexus Security
