From: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Subject: Re: [PATCH 0/2] Support compiling out the prctl syscall
Date: Wed, 09 Nov 2016 01:26:53 +0100
Message-ID: <3032452.SC5nD8WpIB@wuerfel>
References: <cover.c693f10dfc19e12c214758e4b13ca9b4e4cf9668.1478650356.git-series.josh@joshtriplett.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.c693f10dfc19e12c214758e4b13ca9b4e4cf9668.1478650356.git-series.josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Petr Mladek <pmladek-IBi9RG/b67k@public.gmane.org>, Thomas Garnier <thgarnie-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Nicolas Pitre <nicolas.pitre-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Li Bin <huawei.libin-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Dmitry Vyukov <dvyukov-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Ralf Baechle <ralf-6z/3iImG2C8G8FEW9MqTrA@public.gmane.org>, Alex Thorlton <athorlton-sJ/iWh9BUns@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Mateusz Guzik <mguzik-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Cyrill Gorcunov <gorcunov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Zach
List-Id: linux-api@vger.kernel.org

On Tuesday, November 8, 2016 4:17:47 PM CET Josh Triplett wrote:
> Some embedded systems can do without the prctl syscall, saving some space.
> 
> This also avoids regular increases in tinyconfig size as people add more
> non-optional functionality to prctl (observed via the 0-day kernel
> infrastructure).
> 
> The first patch moves prctl and all its helpers into a separate source file,
> kernel/prctl.c, to allow making it optional via the Makefile without any
> ifdefs.  The second patch adds the Kconfig option to make prctl optional.
> 
> Josh Triplett (2):
>   kernel: Move prctl and helpers from kernel/sys.c to new kernel/prctl.c
>   kernel: Support compiling out the prctl syscall
> 

Both of these look really nice to me. Another syscall that comes to
mind as a candidate to be made optional is ptrace, and I've added
Nicolas Pitre to Cc here, as he has looked into this before.

Another area to look at may be syscalls that are always defined
but that are no longer part of the default syscall table in
include/uapi/asm-generic/unistd.h. Maybe we can have a single
conditional for those.

	Arnd
