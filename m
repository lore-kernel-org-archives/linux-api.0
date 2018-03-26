From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [PATCH bpf-next] bpf, tracing: unbreak lttng
Date: Mon, 26 Mar 2018 18:30:07 -0400 (EDT)
Message-ID: <1523827268.612.1522103407744.JavaMail.zimbra@efficios.com>
References: <20180326220845.678423-1-ast@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180326220845.678423-1-ast@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Alexei Starovoitov <ast@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>, Daniel Borkmann <daniel@iogearbox.net>, Linus Torvalds <torvalds@linux-foundation.org>, Peter Zijlstra <peterz@infradead.org>, rostedt <rostedt@goodmis.org>, netdev <netdev@vger.kernel.org>, kernel-team <kernel-team@fb.com>, linux-api <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

----- On Mar 26, 2018, at 6:08 PM, Alexei Starovoitov ast@kernel.org wrote:
[...]
> 
> #ifdef CONFIG_TRACEPOINTS
> -void *
> -for_each_kernel_tracepoint(void *(*fct)(struct tracepoint *tp, void *priv),
> +void
> +for_each_kernel_tracepoint(void (*fct)(struct tracepoint *tp, void *priv),
> 			   void *priv);
> +struct tracepoint *kernel_tracepoint_find_by_name(const char *name);
> #else
> -static inline void *
> -for_each_kernel_tracepoint(void *(*fct)(struct tracepoint *tp, void *priv),
> +static inline void
> +for_each_kernel_tracepoint(void (*fct)(struct tracepoint *tp, void *priv),
> 			   void *priv)
> {
> 	return NULL;
> }

This patch is not reverting to the old code properly. It introduces a
static inline void function that returns NULL. Please compile-test
with CONFIG_TRACEPOINTS=n before submitting a patch involving tracepoints.

But this patch should not even be needed in the first place, because it
partially reverts changes that were introduced in the bpf-next tree without
any Acked-by from the tracing maintainers. I don't see any need to obfuscate
the git log of tracepoint.{c,h}.

Thanks,

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
