From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 02/14] rseq: Introduce restartable sequences system call
 (v13)
Date: Wed, 16 May 2018 18:24:54 +0200
Message-ID: <20180516162454.GJ12198@hirez.programming.kicks-ass.net>
References: <20180430224433.17407-1-mathieu.desnoyers@efficios.com>
 <20180430224433.17407-3-mathieu.desnoyers@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180430224433.17407-3-mathieu.desnoyers@efficios.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Andy Lutomirski <luto@amacapital.net>, Dave Watson <davejwatson@fb.com>, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Paul Turner <pjt@google.com>, Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Andrew Hunter <ahh@google.com>, Andi Kleen <andi@firstfloor.org>, Chris Lameter <cl@linux.com>, Ben Maurer <bmaurer@fb.com>, Steven Rostedt <rostedt@goodmis.org>, Josh Triplett <josh@joshtriplett.org>, Linus Torvalds <torvalds@linux-foundation.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>
List-Id: linux-api@vger.kernel.org

On Mon, Apr 30, 2018 at 06:44:21PM -0400, Mathieu Desnoyers wrote:
> Expose a new system call allowing each thread to register one userspace
> memory area to be used as an ABI between kernel and user-space for two
> purposes: user-space restartable sequences and quick access to read the
> current CPU number value from user-space.

> ---
>  MAINTAINERS                 |  11 ++
>  arch/Kconfig                |   7 +
>  fs/exec.c                   |   1 +
>  include/linux/sched.h       | 134 +++++++++++++++++
>  include/linux/syscalls.h    |   4 +-
>  include/trace/events/rseq.h |  57 +++++++
>  include/uapi/linux/rseq.h   | 133 +++++++++++++++++
>  init/Kconfig                |  23 +++
>  kernel/Makefile             |   1 +
>  kernel/fork.c               |   2 +
>  kernel/rseq.c               | 357 ++++++++++++++++++++++++++++++++++++++++++++
>  kernel/sched/core.c         |   2 +
>  kernel/sys_ni.c             |   3 +
>  13 files changed, 734 insertions(+), 1 deletion(-)
>  create mode 100644 include/trace/events/rseq.h
>  create mode 100644 include/uapi/linux/rseq.h
>  create mode 100644 kernel/rseq.c
> 

Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
