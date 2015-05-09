From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH 5/6] nohz: support PR_DATAPLANE_STRICT mode
Date: Sat, 9 May 2015 00:28:44 -0700
Message-ID: <CALCETrUoptUPVUxL87jUgry1pFac0rDPpnZ790zDKyK4a0FARA@mail.gmail.com>
References: <1431107927-13998-1-git-send-email-cmetcalf@ezchip.com> <1431107927-13998-6-git-send-email-cmetcalf@ezchip.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <1431107927-13998-6-git-send-email-cmetcalf@ezchip.com>
Sender: linux-doc-owner@vger.kernel.org
To: Chris Metcalf <cmetcalf@ezchip.com>
Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@redhat.com>, Rik van Riel <riel@redhat.com>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Tejun Heo <tj@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Steven Rostedt <rostedt@goodmis.org>, Christoph Lameter <cl@linux.com>, Gilad Ben Yossef <giladb@ezchip.com>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On May 8, 2015 11:44 PM, "Chris Metcalf" <cmetcalf@ezchip.com> wrote:
>
> With QUIESCE mode, the task is in principle guaranteed not to be
> interrupted by the kernel, but only if it behaves.  In particular,
> if it enters the kernel via system call, page fault, or any of
> a number of other synchronous traps, it may be unexpectedly
> exposed to long latencies.  Add a simple flag that puts the process
> into a state where any such kernel entry is fatal.
>
> To allow the state to be entered and exited, we add an internal
> bit to current->dataplane_flags that is set when prctl() sets the
> flags.  That way, when we are exiting the kernel after calling
> prctl() to forbid future kernel exits, we don't get immediately
> killed.

Is there any reason this can't already be addressed in userspace using
/proc/interrupts or perf_events?  ISTM the real goal here is to detect
when we screw up and fail to avoid an interrupt, and killing the task
seems like overkill to me.

Also, can we please stop further torturing the exit paths?  We have a
disaster of assembly code that calls into syscall_trace_leave and
do_notify_resume.  Those functions, in turn, *both* call user_enter
(WTF?), and on very brief inspection user_enter makes it into the nohz
code through multiple levels of indirection, which, with these
patches, has yet another conditionally enabled helper, which does this
new stuff.  It's getting to be impossible to tell what happens when we
exit to user space any more.

Also, I think your code is buggy.  There's no particular guarantee
that user_enter is only called once between sys_prctl and the final
exit to user mode (see the above WTF), so you might spuriously kill
the process.

Also, I think that most users will be quite surprised if "strict
dataplane" code causes any machine check on the system to kill your
dataplane task.  Similarly, a user accidentally running perf record -a
probably should have some reasonable semantics.  /proc/interrupts gets
that right as is.  Sure, MCEs will hurt your RT performance, but Intel
screwed up the way that MCEs work, so we should make do.

--Andy
