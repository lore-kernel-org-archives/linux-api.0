From: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH v5 bpf-next 06/10] tracepoint: compute num_args at build
 time
Date: Mon, 26 Mar 2018 11:56:15 -0400
Message-ID: <20180326115615.0ca53410@gandalf.local.home>
References: <20180324023038.938665-1-ast@fb.com>
        <20180324023038.938665-7-ast@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180324023038.938665-7-ast@fb.com>
Sender: netdev-owner@vger.kernel.org
To: Alexei Starovoitov <ast@fb.com>
Cc: davem@davemloft.net, daniel@iogearbox.net, torvalds@linux-foundation.org, peterz@infradead.org, netdev@vger.kernel.org, kernel-team@fb.com, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Fri, 23 Mar 2018 19:30:34 -0700
Alexei Starovoitov <ast@fb.com> wrote:

> +static void *for_each_tracepoint_range(struct tracepoint * const *begin,
> +				       struct tracepoint * const *end,
> +				       void *(*fct)(struct tracepoint *tp, void *priv),
> +				       void *priv)
>  {
>  	struct tracepoint * const *iter;
> +	void *ret;
>  
>  	if (!begin)
> -		return;
> -	for (iter = begin; iter < end; iter++)
> -		fct(*iter, priv);
> +		return NULL;
> +	for (iter = begin; iter < end; iter++) {
> +		ret = fct(*iter, priv);
> +		if (ret)
> +			return ret;

So you just stopped the loop here. You have an inconsistent state. What
about the functions that were called before. How do you undo them? Or
what about the rest that haven't been touched. This function gives no
feedback to the caller.

-- Steve


> +	}
> +	return NULL;
>  }
