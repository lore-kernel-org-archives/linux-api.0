From: Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH v6 3/6] task_isolation: support PR_TASK_ISOLATION_STRICT
 mode
Date: Wed, 26 Aug 2015 11:36:51 +0100
Message-ID: <20150826103651.GA30466@arm.com>
References: <1440532555-15492-1-git-send-email-cmetcalf@ezchip.com>
 <1440532555-15492-4-git-send-email-cmetcalf@ezchip.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-doc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1440532555-15492-4-git-send-email-cmetcalf@ezchip.com>
Sender: linux-doc-owner@vger.kernel.org
To: Chris Metcalf <cmetcalf@ezchip.com>
Cc: Gilad Ben Yossef <giladb@ezchip.com>, Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>, Tejun Heo <tj@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Christoph Lameter <cl@linux.com>, Viresh Kumar <viresh.kumar@linaro.org>, Catalin Marinas <Catalin.Marinas@arm.com>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

Hi Chris,

On Tue, Aug 25, 2015 at 08:55:52PM +0100, Chris Metcalf wrote:
> With task_isolation mode, the task is in principle guaranteed not to
> be interrupted by the kernel, but only if it behaves.  In particular,
> if it enters the kernel via system call, page fault, or any of a
> number of other synchronous traps, it may be unexpectedly exposed
> to long latencies.  Add a simple flag that puts the process into
> a state where any such kernel entry is fatal.
> 
> To allow the state to be entered and exited, we ignore the prctl()
> syscall so that we can clear the bit again later, and we ignore
> exit/exit_group to allow exiting the task without a pointless signal
> killing you as you try to do so.
> 
> This change adds the syscall-detection hooks only for x86, arm64,
> and tile.
> 
> The signature of context_tracking_exit() changes to report whether
> we, in fact, are exiting back to user space, so that we can track
> user exceptions properly separately from other kernel entries.
> 
> Signed-off-by: Chris Metcalf <cmetcalf@ezchip.com>
> ---
>  arch/arm64/kernel/ptrace.c       |  5 +++++
>  arch/tile/kernel/ptrace.c        |  5 ++++-
>  arch/x86/kernel/ptrace.c         |  2 ++
>  include/linux/context_tracking.h | 11 ++++++++---
>  include/linux/isolation.h        | 16 ++++++++++++++++
>  include/uapi/linux/prctl.h       |  1 +
>  kernel/context_tracking.c        |  9 ++++++---
>  kernel/isolation.c               | 38 ++++++++++++++++++++++++++++++++++++++
>  8 files changed, 80 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/arm64/kernel/ptrace.c b/arch/arm64/kernel/ptrace.c
> index d882b833dbdb..e3d83a12f3cf 100644
> --- a/arch/arm64/kernel/ptrace.c
> +++ b/arch/arm64/kernel/ptrace.c
> @@ -37,6 +37,7 @@
>  #include <linux/regset.h>
>  #include <linux/tracehook.h>
>  #include <linux/elf.h>
> +#include <linux/isolation.h>
>  
>  #include <asm/compat.h>
>  #include <asm/debug-monitors.h>
> @@ -1150,6 +1151,10 @@ static void tracehook_report_syscall(struct pt_regs *regs,
>  
>  asmlinkage int syscall_trace_enter(struct pt_regs *regs)
>  {
> +	/* Ensure we report task_isolation violations in all circumstances. */
> +	if (test_thread_flag(TIF_NOHZ) && task_isolation_strict())

This is going to force us to check TIF_NOHZ on the syscall slowpath even
when CONFIG_TASK_ISOLATION=n.

> +		task_isolation_syscall(regs->syscallno);
> +
>  	/* Do the secure computing check first; failures should be fast. */

Here we have the usual priority problems with all the subsystems that
hook into the syscall path. If a prctl is later rewritten to a different
syscall, do you care about catching it? Either way, the comment about
doing secure computing "first" needs fixing.

Cheers,

Will
