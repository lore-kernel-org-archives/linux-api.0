From: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH v8 bpf-next 6/9] bpf: introduce BPF_RAW_TRACEPOINT
Date: Wed, 28 Mar 2018 15:34:35 -0400
Message-ID: <20180328153435.5e733957@gandalf.local.home>
References: <20180328190540.370956-1-ast@kernel.org>
        <20180328190540.370956-7-ast@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180328190540.370956-7-ast@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Alexei Starovoitov <ast@kernel.org>
Cc: davem@davemloft.net, daniel@iogearbox.net, torvalds@linux-foundation.org, peterz@infradead.org, mathieu.desnoyers@efficios.com, netdev@vger.kernel.org, kernel-team@fb.com, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Wed, 28 Mar 2018 12:05:37 -0700
Alexei Starovoitov <ast@kernel.org> wrote:

> +++ b/include/linux/tracepoint-defs.h
> @@ -35,4 +35,10 @@ struct tracepoint {
>  	struct tracepoint_func __rcu *funcs;
>  };
>  
> +struct bpf_raw_event_map {
> +	struct tracepoint	*tp;
> +	void			*bpf_func;
> +	u32			num_args;
> +} __aligned(32);
> +

If you prefer v7, I'm fine with that. For cache issues, I can pull out
the funcs from the tracepoint structure like I posted.

Mathieu, your thoughts?

-- Steve
