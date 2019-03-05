From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH for 5.1 0/3] Restartable Sequences updates for 5.1
Date: Tue, 5 Mar 2019 22:49:59 +0100
Message-ID: <20190305214958.GP32477@hirez.programming.kicks-ass.net>
References: <20190305194755.2602-1-mathieu.desnoyers@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190305194755.2602-1-mathieu.desnoyers@efficios.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Andy Lutomirski <luto@amacapital.net>, Dave Watson <davejwatson@fb.com>, Paul Turner <pjt@google.com>, Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>, Chris Lameter <cl@linux.com>, Ben Maurer <bmaurer@fb.com>, Steven Rostedt <rostedt@goodmis.org>, Josh Triplett <josh@joshtriplett.org>, Linus Torvalds <torvalds@linux-foundation.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Michael Kerrisk <mtk.manpages@gm>
List-Id: linux-api@vger.kernel.org

On Tue, Mar 05, 2019 at 02:47:52PM -0500, Mathieu Desnoyers wrote:
> Mathieu Desnoyers (3):
>   rseq: cleanup: Reflect removal of event counter in comments
>   rseq: cleanup: remove rseq_len from task_struct
>   rseq/selftests: Adapt number of threads to the number of detected cpus
> 
>  arch/arm/kernel/signal.c                       | 3 +--
>  arch/x86/kernel/signal.c                       | 5 +----
>  include/linux/sched.h                          | 4 ----
>  kernel/rseq.c                                  | 9 +++------
>  tools/testing/selftests/rseq/run_param_test.sh | 7 +++++--
>  5 files changed, 10 insertions(+), 18 deletions(-)

Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
