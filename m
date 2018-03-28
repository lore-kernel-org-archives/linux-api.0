From: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH v7 bpf-next 06/10] tracepoint: compute num_args at build
 time
Date: Wed, 28 Mar 2018 13:04:07 -0400
Message-ID: <20180328130407.7476cf17@gandalf.local.home>
References: <20180328021105.4061744-1-ast@fb.com>
        <20180328021105.4061744-7-ast@fb.com>
        <1074829260.1986.1522244964935.JavaMail.zimbra@efficios.com>
        <67c5f9b4-b24a-2806-e8d6-8b5241c66d6e@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <67c5f9b4-b24a-2806-e8d6-8b5241c66d6e@fb.com>
Sender: netdev-owner@vger.kernel.org
To: Alexei Starovoitov <ast@fb.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, "David S. Miller" <davem@davemloft.net>, Daniel Borkmann <daniel@iogearbox.net>, Linus Torvalds <torvalds@linux-foundation.org>, Peter Zijlstra <peterz@infradead.org>, netdev <netdev@vger.kernel.org>, kernel-team <kernel-team@fb.com>, linux-api <linux-api@vger.kernel.org>, Josh Poimboeuf <jpoimboe@redhat.com>
List-Id: linux-api@vger.kernel.org

On Wed, 28 Mar 2018 09:43:56 -0700
Alexei Starovoitov <ast@fb.com> wrote:
> >
> > Given that only eBPF needs this parameter count, we can move
> > it to the struct bpf_raw_event_map newly introduced by Steven,
> > right ? This would reduce bloat of struct tracepoint. For instance,
> > we don't need to keep this count around when eBPF is configured
> > out.  
> 
> Makes sense. That is indeed cleaner. Will respin.
> 
> What I don't like though is 'bloat' argument.
> 'u32 num_args' padded to 8-byte takes exactly the same amount
> of space in 'struct tracepoint' and in 'struct bpf_raw_event_map'
> The number of these structures is the same as well
> and chances that tracepoints are on while bpf is off are slim.
> More so few emails ago you said:
> "I'm perfectly fine with adding the "num_args" stuff. I think it's
> really useful. It's only the for_each_kernel_tracepoint change for
> which I'm trying to understand the rationale."

I don't really care which one it goes in. The padding bloat is the same
for both :-/  But I wonder if we can shrink it by doing a trick that
Josh did in one of his patches. That is, to use a 32bit offset instead
of a direct pointer. Since you are only accessing core kernel
tracepoints.

Thus, we could have

struct bpf_raw_event_map {
	u32			tp_offset;
	u32			num_args;
	void			*bpf_func;
};

and have:

	u64 tp_offset = (u64)tp - (u64)_sdata;

	if (WARN_ON(tp_offset > UINT_MAX)
		return -EINVAL;

	 btp->tp_offset = (u32)tp_offset;

And to get the tp, all you need to do is:

	tp = (struct tracepoint *)(btp->tp_offset + (unsigned long)_sdata);

I've been thinking of doing this for other parts of the tracepoints and
ftrace code.

BTW, thanks for changing your code. I really appreciate it.

-- Steve
