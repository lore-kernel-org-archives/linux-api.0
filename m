From: Nicolas Pitre <nicolas.pitre-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 0/2] Support compiling out the prctl syscall
Date: Tue, 8 Nov 2016 19:30:12 -0500 (EST)
Message-ID: <alpine.LFD.2.20.1611081928540.11818@knanqh.ubzr>
References: <cover.c693f10dfc19e12c214758e4b13ca9b4e4cf9668.1478650356.git-series.josh@joshtriplett.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.c693f10dfc19e12c214758e4b13ca9b4e4cf9668.1478650356.git-series.josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Petr Mladek <pmladek-IBi9RG/b67k@public.gmane.org>, Thomas Garnier <thgarnie-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Li Bin <huawei.libin-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Dmitry Vyukov <dvyukov-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Ralf Baechle <ralf-6z/3iImG2C8G8FEW9MqTrA@public.gmane.org>, Alex Thorlton <athorlton-sJ/iWh9BUns@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Mateusz Guzik <mguzik-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Cyrill Gorcunov <gorcunov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Zach Brown <zab-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Tue, 8 Nov 2016, Josh Triplett wrote:

> Some embedded systems can do without the prctl syscall, saving some space.
> 
> This also avoids regular increases in tinyconfig size as people add more
> non-optional functionality to prctl (observed via the 0-day kernel
> infrastructure).
> 
> The first patch moves prctl and all its helpers into a separate source file,
> kernel/prctl.c, to allow making it optional via the Makefile without any
> ifdefs.  The second patch adds the Kconfig option to make prctl optional.

Excellent.  For both patches:

Acked-by: Nicolas Pitre <nico-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>

> 
> Josh Triplett (2):
>   kernel: Move prctl and helpers from kernel/sys.c to new kernel/prctl.c
>   kernel: Support compiling out the prctl syscall
> 
>  init/Kconfig    |  12 +-
>  kernel/Makefile |   1 +-
>  kernel/prctl.c  | 684 +++++++++++++++++++++++++++++++++++++++++++++++++-
>  kernel/sys.c    | 672 +------------------------------------------------
>  kernel/sys_ni.c |   1 +-
>  5 files changed, 698 insertions(+), 672 deletions(-)
>  create mode 100644 kernel/prctl.c
> 
> base-commit: e3a00f68e426df24a5fb98956a1bd1b23943aa1e
> -- 
> git-series 0.8.11
> 
