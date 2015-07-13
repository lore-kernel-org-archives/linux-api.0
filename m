From: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Subject: Re: [PATCH v4 2/5] nohz: support PR_CPU_ISOLATED_STRICT mode
Date: Mon, 13 Jul 2015 14:47:13 -0700
Message-ID: <CALCETrUvg+Dix=jG2_1J=mgQC+uRk4dthCYDcb4E5ooEfQjqtQ@mail.gmail.com>
References: <1436817481-8732-1-git-send-email-cmetcalf@ezchip.com> <1436817481-8732-3-git-send-email-cmetcalf@ezchip.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1436817481-8732-3-git-send-email-cmetcalf-d5a29ZRxExrQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chris Metcalf <cmetcalf-d5a29ZRxExrQT0dZR+AlfA@public.gmane.org>
Cc: Gilad Ben Yossef <giladb-d5a29ZRxExrQT0dZR+AlfA@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Viresh Kumar <viresh.kumar-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, "linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Mon, Jul 13, 2015 at 12:57 PM, Chris Metcalf <cmetcalf-d5a29ZRxExrQT0dZR+AlfA@public.gmane.org> wrote:
> With cpu_isolated mode, the task is in principle guaranteed not to be
> interrupted by the kernel, but only if it behaves.  In particular, if it
> enters the kernel via system call, page fault, or any of a number of other
> synchronous traps, it may be unexpectedly exposed to long latencies.
> Add a simple flag that puts the process into a state where any such
> kernel entry is fatal.
>

To me, this seems like the wrong design.  If nothing else, it seems
too much like an abusable anti-debugging mechanism.  I can imagine
some per-task flag "I think I shouldn't be interrupted now" and a
tracepoint that fires if the task is interrupted with that flag set.
But the strong cpu isolation stuff requires systemwide configuration,
and I think that monitoring that it works should work similarly.

More comments below.

> Signed-off-by: Chris Metcalf <cmetcalf-d5a29ZRxExrQT0dZR+AlfA@public.gmane.org>
> ---
>  arch/arm64/kernel/ptrace.c       |  4 ++++
>  arch/tile/kernel/ptrace.c        |  6 +++++-
>  arch/x86/kernel/ptrace.c         |  2 ++
>  include/linux/context_tracking.h | 11 ++++++++---
>  include/linux/tick.h             | 16 ++++++++++++++++
>  include/uapi/linux/prctl.h       |  1 +
>  kernel/context_tracking.c        |  9 ++++++---
>  kernel/time/tick-sched.c         | 38 ++++++++++++++++++++++++++++++++++++++
>  8 files changed, 80 insertions(+), 7 deletions(-)
>
> diff --git a/arch/arm64/kernel/ptrace.c b/arch/arm64/kernel/ptrace.c
> index d882b833dbdb..7315b1579cbd 100644
> --- a/arch/arm64/kernel/ptrace.c
> +++ b/arch/arm64/kernel/ptrace.c
> @@ -1150,6 +1150,10 @@ static void tracehook_report_syscall(struct pt_regs *regs,
>
>  asmlinkage int syscall_trace_enter(struct pt_regs *regs)
>  {
> +       /* Ensure we report cpu_isolated violations in all circumstances. */
> +       if (test_thread_flag(TIF_NOHZ) && tick_nohz_cpu_isolated_strict())
> +               tick_nohz_cpu_isolated_syscall(regs->syscallno);

IMO this is pointless.  If a user wants a syscall to kill them, use
seccomp.  The kernel isn't at fault if the user does a syscall when it
didn't want to enter the kernel.


> @@ -35,8 +36,12 @@ static inline enum ctx_state exception_enter(void)
>                 return 0;
>
>         prev_ctx = this_cpu_read(context_tracking.state);
> -       if (prev_ctx != CONTEXT_KERNEL)
> -               context_tracking_exit(prev_ctx);
> +       if (prev_ctx != CONTEXT_KERNEL) {
> +               if (context_tracking_exit(prev_ctx)) {
> +                       if (tick_nohz_cpu_isolated_strict())
> +                               tick_nohz_cpu_isolated_exception();
> +               }
> +       }

NACK.  I'm cautiously optimistic that an x86 kernel 4.3 or newer will
simply never call exception_enter.  It certainly won't call it
frequently unless something goes wrong with the patches that are
already in -tip.

> --- a/kernel/context_tracking.c
> +++ b/kernel/context_tracking.c
> @@ -147,15 +147,16 @@ NOKPROBE_SYMBOL(context_tracking_user_enter);
>   * This call supports re-entrancy. This way it can be called from any exception
>   * handler without needing to know if we came from userspace or not.
>   */
> -void context_tracking_exit(enum ctx_state state)
> +bool context_tracking_exit(enum ctx_state state)
>  {
>         unsigned long flags;
> +       bool from_user = false;
>

IMO the internal context tracking API (e.g. context_tracking_exit) are
mostly of the form "hey context tracking: I don't really know what
you're doing or what I'm doing, but let me call you and make both of
us feel better."  You're making it somewhat worse: now it's all of the
above plus "I don't even know whether I just entered the kernel --
maybe you have a better idea".

Starting with 4.3, x86 kernels will know *exactly* when they enter the
kernel.  All of this context tracking what-was-my-previous-state stuff
will remain until someone kills it, but when it goes away we'll get a
nice performance boost.

So, no, let's implement this for real if we're going to implement it.

--Andy
