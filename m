From: Josh Triplett <josh@joshtriplett.org>
Subject: Re: [PATCH 0/2] Support compiling out the prctl syscall
Date: Tue, 8 Nov 2016 19:42:09 -0800
Message-ID: <20161109034209.i5ok4cy2apjp3mpk@x>
References: <cover.c693f10dfc19e12c214758e4b13ca9b4e4cf9668.1478650356.git-series.josh@joshtriplett.org>
 <3032452.SC5nD8WpIB@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <3032452.SC5nD8WpIB@wuerfel>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, Kees Cook <keescook@chromium.org>, Johannes Weiner <hannes@cmpxchg.org>, Ingo Molnar <mingo@kernel.org>, Andy Lutomirski <luto@kernel.org>, Petr Mladek <pmladek@suse.com>, Thomas Garnier <thgarnie@google.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Nicolas Pitre <nicolas.pitre@linaro.org>, Zefan Li <lizefan@huawei.com>, Li Bin <huawei.libin@huawei.com>, "Eric W. Biederman" <ebiederm@xmission.com>, Dmitry Vyukov <dvyukov@google.com>, Ralf Baechle <ralf@linux-mips.org>, Alex Thorlton <athorlton@sgi.com>, Michal Hocko <mhocko@suse.com>, Mateusz Guzik <mguzik@redhat.com>, Cyrill Gorcunov <gorcunov@openvz.org>, John Stultz <john.stultz@linaro.org>, Al Viro <viro@zeniv.linux.org.uk>, Zach
List-Id: linux-api@vger.kernel.org

On Wed, Nov 09, 2016 at 01:26:53AM +0100, Arnd Bergmann wrote:
> On Tuesday, November 8, 2016 4:17:47 PM CET Josh Triplett wrote:
> > Some embedded systems can do without the prctl syscall, saving some space.
> > 
> > This also avoids regular increases in tinyconfig size as people add more
> > non-optional functionality to prctl (observed via the 0-day kernel
> > infrastructure).
> > 
> > The first patch moves prctl and all its helpers into a separate source file,
> > kernel/prctl.c, to allow making it optional via the Makefile without any
> > ifdefs.  The second patch adds the Kconfig option to make prctl optional.
> > 
> > Josh Triplett (2):
> >   kernel: Move prctl and helpers from kernel/sys.c to new kernel/prctl.c
> >   kernel: Support compiling out the prctl syscall
> > 
> 
> Both of these look really nice to me. Another syscall that comes to
> mind as a candidate to be made optional is ptrace, and I've added
> Nicolas Pitre to Cc here, as he has looked into this before.

I've looked at that as well; it's a rather more complex patch, as
several other bits of the kernel hook into ptrace or otherwise depend on
ptrace.  (And ptrace_may_access will need to stick around even when
ptrace doesn't.)

- Josh Triplett
