From: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH v6 bpf-next 07/11] tracepoint: introduce
 kernel_tracepoint_find_by_name
Date: Tue, 27 Mar 2018 10:07:11 -0400
Message-ID: <20180327100711.0ec7aafb@gandalf.local.home>
References: <20180327024706.2064725-1-ast@fb.com>
        <20180327024706.2064725-8-ast@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180327024706.2064725-8-ast@fb.com>
Sender: netdev-owner@vger.kernel.org
To: Alexei Starovoitov <ast@fb.com>
Cc: davem@davemloft.net, daniel@iogearbox.net, torvalds@linux-foundation.org, peterz@infradead.org, netdev@vger.kernel.org, kernel-team@fb.com, linux-api@vger.kernel.org, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
List-Id: linux-api@vger.kernel.org

On Mon, 26 Mar 2018 19:47:02 -0700
Alexei Starovoitov <ast@fb.com> wrote:

> From: Alexei Starovoitov <ast@kernel.org>
> 
> introduce kernel_tracepoint_find_by_name() helper to let bpf core
> find tracepoint by name and later attach bpf probe to a tracepoint
> 
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>

Reviewed-by: Steven Rostedt (VMware) <rostedt@goodmis.org>

Thanks for doing this Alexei!

One nit below.


> ---
>  include/linux/tracepoint.h | 6 ++++++
>  kernel/tracepoint.c        | 9 +++++++++
>  2 files changed, 15 insertions(+)
> 
> diff --git a/include/linux/tracepoint.h b/include/linux/tracepoint.h
> index c92f4adbc0d7..a00b84473211 100644
> --- a/include/linux/tracepoint.h
> +++ b/include/linux/tracepoint.h
> @@ -43,6 +43,12 @@ tracepoint_probe_unregister(struct tracepoint *tp, void *probe, void *data);
>  extern void
>  for_each_kernel_tracepoint(void (*fct)(struct tracepoint *tp, void *priv),
>  		void *priv);
> +#ifdef CONFIG_TRACEPOINTS
> +struct tracepoint *kernel_tracepoint_find_by_name(const char *name);
> +#else
> +static inline struct tracepoint *
> +kernel_tracepoint_find_by_name(const char *name) { return NULL; }
> +#endif
>  
>  #ifdef CONFIG_MODULES
>  struct tp_module {
> diff --git a/kernel/tracepoint.c b/kernel/tracepoint.c
> index 671b13457387..e2a9a0391ae2 100644
> --- a/kernel/tracepoint.c
> +++ b/kernel/tracepoint.c
> @@ -528,6 +528,15 @@ void for_each_kernel_tracepoint(void (*fct)(struct tracepoint *tp, void *priv),
>  }
>  EXPORT_SYMBOL_GPL(for_each_kernel_tracepoint);
>  
> +struct tracepoint *kernel_tracepoint_find_by_name(const char *name)
> +{
> +	struct tracepoint * const *tp = __start___tracepoints_ptrs;
> +
> +	for (; tp < __stop___tracepoints_ptrs; tp++)
> +		if (!strcmp((*tp)->name, name))
> +			return *tp;


Usually for cases like this, we prefer to add brackets for the for
block, as it's not a single line below it.

	for (; tp < __stop__tracepoints_ptrs; tp++) {
		if (!strcmp((*tp)->name, name))
			return *tp;
	}

-- Steve


	

> +	return NULL;
> +}
>  #ifdef CONFIG_HAVE_SYSCALL_TRACEPOINTS
>  
>  /* NB: reg/unreg are called while guarded with the tracepoints_mutex */
