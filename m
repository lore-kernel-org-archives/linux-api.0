From: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCHv2 0/2] clone: Support passing tls argument via C rather
 than pt_regs magic
Date: Tue, 12 May 2015 09:02:39 +0200
Message-ID: <20150512070239.GA30476@gmail.com>
References: <20150511192810.GA11328@jtriplet-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150511192810.GA11328@jtriplet-mobl1>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>
Cc: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
List-Id: linux-api@vger.kernel.org


* Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org> wrote:

> clone has some of the quirkiest syscall handling in the kernel, with 
> a pile of special cases, historical curiosities, and 
> architecture-specific calling conventions.  In particular, clone 
> with CLONE_SETTLS accepts a parameter "tls" that the C entry point 
> completely ignores and some assembly entry points overwrite; 
> instead, the low-level arch-specific code pulls the tls parameter 
> out of the arch-specific register captured as part of pt_regs on 
> entry to the kernel.  That's a massive hack, and it makes the 
> arch-specific code only work when called via the specific existing 
> syscall entry points; because of this hack, any new clone-like 
> system call would have to accept an identical tls argument in 
> exactly the same arch-specific position, rather than providing a 
> unified system call entry point across architectures.
> 
> The first patch allows architectures to handle the tls argument via 
> normal C parameter passing, if they opt in by selecting 
> HAVE_COPY_THREAD_TLS.  The second patch makes 32-bit and 64-bit x86 
> opt into this.
> 
> These two patches came out of the clone4 series, which isn't ready 
> for this merge window, but these first two cleanup patches were 
> entirely uncontroversial and have acks.  I'd like to go ahead and 
> submit these two so that other architectures can begin building on 
> top of this and opting into HAVE_COPY_THREAD_TLS.  However, I'm also 
> happy to wait and send these through the next merge window (along 
> with v3 of clone4) if anyone would prefer that.
> 
> v2: Move co-author from signoffs to a note in the commit message, as
>     required by Ingo Molnar.
> 
> Josh Triplett (2):
>   clone: Support passing tls argument via C rather than pt_regs magic
>   x86: Opt into HAVE_COPY_THREAD_TLS, for both 32-bit and 64-bit
> 
>  arch/Kconfig                 |  7 ++++++
>  arch/x86/Kconfig             |  1 +
>  arch/x86/ia32/ia32entry.S    |  2 +-
>  arch/x86/kernel/process_32.c |  6 ++---
>  arch/x86/kernel/process_64.c |  8 +++----
>  include/linux/sched.h        | 14 +++++++++++
>  include/linux/syscalls.h     |  6 ++---
>  kernel/fork.c                | 55 +++++++++++++++++++++++++++++---------------
>  8 files changed, 69 insertions(+), 30 deletions(-)

So I have no objections if Linus doesn't see a cleaner/better 
approach.

Thanks,

	Ingo
