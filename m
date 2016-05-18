From: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH v12 06/13] task_isolation: support
 PR_TASK_ISOLATION_STRICT mode
Date: Wed, 18 May 2016 15:44:06 +0200
Message-ID: <20160518134406.GI3193@twins.programming.kicks-ass.net>
References: <1459877922-15512-1-git-send-email-cmetcalf@mellanox.com>
 <1459877922-15512-7-git-send-email-cmetcalf@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1459877922-15512-7-git-send-email-cmetcalf-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chris Metcalf <cmetcalf-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Gilad Ben Yossef <giladb-d5a29ZRxExrQT0dZR+AlfA@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Viresh Kumar <viresh.kumar-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Tue, Apr 05, 2016 at 01:38:35PM -0400, Chris Metcalf wrote:
> +void task_isolation_interrupt(struct task_struct *task, const char *buf)
> +{
> +	siginfo_t info = {};
> +	int sig;
> +
> +	pr_warn("%s/%d: task_isolation strict mode violated by %s\n",
> +		task->comm, task->pid, buf);
> +

So the function name suggests this is called for interrupts, except its
purpose is to deliver a signal.

Now, in case of exceptions the violation isn't necessarily _by_ the task
itself. You might want to change that to report the exception
type/number instead of the affected task.

> +	/* Get the signal number to use. */
> +	sig = PR_TASK_ISOLATION_GET_SIG(task->task_isolation_flags);
> +	if (sig == 0)
> +		sig = SIGKILL;
> +	info.si_signo = sig;
> +
> +	/*
> +	 * Turn off task isolation mode entirely to avoid spamming
> +	 * the process with signals.  It can re-enable task isolation
> +	 * mode in the signal handler if it wants to.
> +	 */
> +	task_isolation_set_flags(task, 0);
> +
> +	send_sig_info(sig, &info, task);
> +}
