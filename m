From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [RFC PATCH for 4.17 02/21] rseq: Introduce restartable sequences
 system call (v12)
Date: Wed, 28 Mar 2018 13:22:25 +0200
Message-ID: <20180328112225.GT4043@hirez.programming.kicks-ass.net>
References: <20180327160542.28457-1-mathieu.desnoyers@efficios.com>
 <20180327160542.28457-3-mathieu.desnoyers@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180327160542.28457-3-mathieu.desnoyers@efficios.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Andy Lutomirski <luto@amacapital.net>, Dave Watson <davejwatson@fb.com>, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Paul Turner <pjt@google.com>, Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Andrew Hunter <ahh@google.com>, Andi Kleen <andi@firstfloor.org>, Chris Lameter <cl@linux.com>, Ben Maurer <bmaurer@fb.com>, Steven Rostedt <rostedt@goodmis.org>, Josh Triplett <josh@joshtriplett.org>, Linus Torvalds <torvalds@linux-foundation.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>
List-Id: linux-api@vger.kernel.org

On Tue, Mar 27, 2018 at 12:05:23PM -0400, Mathieu Desnoyers wrote:
> +/*
> + * struct rseq_cs is aligned on 4 * 8 bytes to ensure it is always
> + * contained within a single cache-line. It is usually declared as
> + * link-time constant data.
> + */
> +struct rseq_cs {
> +	/* Version of this structure. */
> +	uint32_t version;
> +	/* enum rseq_cs_flags */
> +	uint32_t flags;
> +	LINUX_FIELD_u32_u64(start_ip);
> +	/* Offset from start_ip. */
> +	LINUX_FIELD_u32_u64(post_commit_offset);
> +	LINUX_FIELD_u32_u64(abort_ip);
> +} __attribute__((aligned(4 * sizeof(uint64_t))));

What's with the uint32_t ? The normal Linux API type is __u32 afaik.
