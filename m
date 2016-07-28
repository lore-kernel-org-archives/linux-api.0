From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [RFC 2/4] Restartable sequences: powerpc architecture support
Date: Thu, 28 Jul 2016 03:13:07 +0000 (UTC)
Message-ID: <2132356373.430.1469675587375.JavaMail.zimbra@efficios.com>
References: <20160727150352.GA32142@tardis.cn.ibm.com> <20160727150517.26983-1-boqun.feng@gmail.com> <20160727150517.26983-2-boqun.feng@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160727150517.26983-2-boqun.feng@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Boqun Feng <boqun.feng@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, linux-api <linux-api@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Paul Turner <pjt@google.com>, Andrew Hunter <ahh@google.com>, Peter Zijlstra <peterz@infradead.org>, Andy Lutomirski <luto@amacapital.net>, Andi Kleen <andi@firstfloor.org>, Dave Watson <davejwatson@fb.com>, Chris Lameter <cl@linux.com>, Ben Maurer <bmaurer@fb.com>, rostedt <rostedt@goodmis.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Josh Triplett <josh@joshtriplett.org>, Linus Torvalds <torvalds@linux-foundation.org>, Michael Ellerman <mpe@ellerman.id.au>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Paul Mackerras <paulus@samba.org>
List-Id: linux-api@vger.kernel.org

----- On Jul 27, 2016, at 11:05 AM, Boqun Feng boqun.feng@gmail.com wrote:

> Call the rseq_handle_notify_resume() function on return to userspace if
> TIF_NOTIFY_RESUME thread flag is set.
> 
> Increment the event counter and perform fixup on the pre-signal when a
> signal is delivered on top of a restartable sequence critical section.

Picked into my patchset. I'm keeping a volatile branch of my current
work at https://github.com/compudj/linux-percpu-dev/tree/rseq-fallback
if you are interested in the progress.

Thanks!

Mathieu

> 
> Signed-off-by: Boqun Feng <boqun.feng@gmail.com>
> ---
> arch/powerpc/Kconfig         | 1 +
> arch/powerpc/kernel/signal.c | 3 +++
> 2 files changed, 4 insertions(+)
> 
> diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
> index 0a9d439bcda6..4e93629c6b84 100644
> --- a/arch/powerpc/Kconfig
> +++ b/arch/powerpc/Kconfig
> @@ -120,6 +120,7 @@ config PPC
> 	select HAVE_PERF_USER_STACK_DUMP
> 	select HAVE_REGS_AND_STACK_ACCESS_API
> 	select HAVE_HW_BREAKPOINT if PERF_EVENTS && PPC_BOOK3S_64
> +	select HAVE_RSEQ
> 	select ARCH_WANT_IPC_PARSE_VERSION
> 	select SPARSE_IRQ
> 	select IRQ_DOMAIN
> diff --git a/arch/powerpc/kernel/signal.c b/arch/powerpc/kernel/signal.c
> index cb64d6feb45a..339d0ebe2906 100644
> --- a/arch/powerpc/kernel/signal.c
> +++ b/arch/powerpc/kernel/signal.c
> @@ -131,6 +131,8 @@ static void do_signal(struct pt_regs *regs)
> 	/* Re-enable the breakpoints for the signal stack */
> 	thread_change_pc(current, regs);
> 
> +	rseq_signal_deliver(regs);
> +
> 	if (is32) {
>         	if (ksig.ka.sa.sa_flags & SA_SIGINFO)
> 			ret = handle_rt_signal32(&ksig, oldset, regs);
> @@ -157,6 +159,7 @@ void do_notify_resume(struct pt_regs *regs, unsigned long
> thread_info_flags)
> 	if (thread_info_flags & _TIF_NOTIFY_RESUME) {
> 		clear_thread_flag(TIF_NOTIFY_RESUME);
> 		tracehook_notify_resume(regs);
> +		rseq_handle_notify_resume(regs);
> 	}
> 
> 	user_enter();
> --
> 2.9.0

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
