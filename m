From: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH v7 bpf-next 06/10] tracepoint: compute num_args at build
 time
Date: Wed, 28 Mar 2018 15:38:19 -0400
Message-ID: <20180328153819.654c1600@gandalf.local.home>
References: <20180328021105.4061744-1-ast@fb.com>
        <20180328130407.7476cf17@gandalf.local.home>
        <fdcb0bf0-f896-ffb3-b9de-0b17f5f70fc6@fb.com>
        <20180328133830.3d5d74d3@gandalf.local.home>
        <80d7af37-10ef-28d7-f03f-27b4b5849cd1@fb.com>
        <20180328141045.1202afeb@gandalf.local.home>
        <a5c8ff7c-8185-a3fd-89eb-45ddc099c03b@fb.com>
        <20180328145431.687643bc@gandalf.local.home>
        <842190155.225.1522264944386.JavaMail.zimbra@efficios.com>
        <20180328153220.06a132f4@gandalf.local.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180328153220.06a132f4@gandalf.local.home>
Sender: netdev-owner@vger.kernel.org
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Alexei Starovoitov <ast@fb.com>, "David S. Miller" <davem@davemloft.net>, Daniel Borkmann <daniel@iogearbox.net>, Linus Torvalds <torvalds@linux-foundation.org>, Peter Zijlstra <peterz@infradead.org>, netdev <netdev@vger.kernel.org>, kernel-team <kernel-team@fb.com>, linux-api <linux-api@vger.kernel.org>, Josh Poimboeuf <jpoimboe@redhat.com>
List-Id: linux-api@vger.kernel.org

On Wed, 28 Mar 2018 15:32:20 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> -#define __DO_TRACE(tp, proto, args, cond, rcucheck)			\
> +#define __DO_TRACE(name, proto, args, cond, rcucheck)			\
>  	do {								\
>  		struct tracepoint_func *it_func_ptr;			\
>  		void *it_func;						\
> @@ -140,7 +140,7 @@ extern void syscall_unregfunc(void);
>  		if (rcucheck)						\
>  			rcu_irq_enter_irqson();				\
>  		rcu_read_lock_sched_notrace();				\
> -		it_func_ptr = rcu_dereference_sched((tp)->funcs);	\
> +		it_func_ptr = rcu_dereference_sched(__trace_##name##_funcs); \

What we lose in data size, we may make up for in text (which is even
more important). This will remove a dereference in the hot path.

I'll make a few builds and run size on the vmlinux images to see how
this pans out.

-- Steve


>  		if (it_func_ptr) {					\
>  			do {						\
