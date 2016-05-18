From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v12 04/13] task_isolation: add initial support
Date: Wed, 18 May 2016 15:34:20 +0200
Message-ID: <20160518133420.GG3193@twins.programming.kicks-ass.net>
References: <1459877922-15512-1-git-send-email-cmetcalf@mellanox.com>
 <1459877922-15512-5-git-send-email-cmetcalf@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-doc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1459877922-15512-5-git-send-email-cmetcalf@mellanox.com>
Sender: linux-doc-owner@vger.kernel.org
To: Chris Metcalf <cmetcalf@mellanox.com>
Cc: Gilad Ben Yossef <giladb@ezchip.com>, Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>, Tejun Heo <tj@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Christoph Lameter <cl@linux.com>, Viresh Kumar <viresh.kumar@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Andy Lutomirski <luto@amacapital.net>, Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org, linux-doc@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Tue, Apr 05, 2016 at 01:38:33PM -0400, Chris Metcalf wrote:
> diff --git a/kernel/signal.c b/kernel/signal.c
> index aa9bf00749c1..53e4e62f2778 100644
> --- a/kernel/signal.c
> +++ b/kernel/signal.c
> @@ -34,6 +34,7 @@
>  #include <linux/compat.h>
>  #include <linux/cn_proc.h>
>  #include <linux/compiler.h>
> +#include <linux/isolation.h>
>  
>  #define CREATE_TRACE_POINTS
>  #include <trace/events/signal.h>
> @@ -2213,6 +2214,9 @@ relock:
>  		/* Trace actually delivered signals. */
>  		trace_signal_deliver(signr, &ksig->info, ka);
>  
> +		/* Disable task isolation when delivering a signal. */

Why !? Changelog is quiet on this.

> +		task_isolation_set_flags(current, 0);
> +
>  		if (ka->sa.sa_handler == SIG_IGN) /* Do nothing.  */
>  			continue;
>  		if (ka->sa.sa_handler != SIG_DFL) {
