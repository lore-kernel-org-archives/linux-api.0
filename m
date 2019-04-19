From: Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH for 5.1 0/3] Restartable Sequences updates for 5.1
Date: Fri, 19 Apr 2019 12:41:23 +0200
Message-ID: <20190419104123.GB111210@gmail.com>
References: <20190305194755.2602-1-mathieu.desnoyers@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190305194755.2602-1-mathieu.desnoyers@efficios.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Andy Lutomirski <luto@amacapital.net>, Dave Watson <davejwatson@fb.com>, Paul Turner <pjt@google.com>, Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>, Chris Lameter <cl@linux.com>, Ben Maurer <bmaurer@fb.com>, Steven Rostedt <rostedt@goodmis.org>, Josh Triplett <josh@joshtriplett.org>, Linus Torvalds <torvalds@linux-foundation.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>
List-Id: linux-api@vger.kernel.org


* Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:

> Those changes aiming at 5.1 include one comment cleanup, the removal of
> the rseq_len field from the task struct which serves no purpose
> considering that the struct size is fixed by the ABI, and a selftest
> improvement adapting the number of threads to the number of detected
> CPUs, which is nicer for smaller systems.
> 
> Thanks,
> 
> Mathieu
> 
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

Looks good, I've applied these to tip:core/rseq to make sure they don't 
miss the v5.2 merge window.

(Let me know if you wanted to handle this differently.)

Thanks,

	Ingo
