From: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH v6 bpf-next 08/11] bpf: introduce BPF_RAW_TRACEPOINT
Date: Tue, 27 Mar 2018 13:02:11 -0400
Message-ID: <20180327130211.284c8924@gandalf.local.home>
References: <20180327024706.2064725-1-ast@fb.com>
        <20180327024706.2064725-9-ast@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180327024706.2064725-9-ast@fb.com>
Sender: netdev-owner@vger.kernel.org
To: Alexei Starovoitov <ast@fb.com>
Cc: davem@davemloft.net, daniel@iogearbox.net, torvalds@linux-foundation.org, peterz@infradead.org, netdev@vger.kernel.org, kernel-team@fb.com, linux-api@vger.kernel.org, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Kees Cook <keescook@chromium.org>
List-Id: linux-api@vger.kernel.org

On Mon, 26 Mar 2018 19:47:03 -0700
Alexei Starovoitov <ast@fb.com> wrote:


> Ctrl-C of tracing daemon or cmdline tool that uses this feature
> will automatically detach bpf program, unload it and
> unregister tracepoint probe.
> 
> On the kernel side for_each_kernel_tracepoint() is used

You need to update the change log to state
kernel_tracepoint_find_by_name().

But looking at the code, I really think you should do it properly and
not rely on a hack that finds your function via kallsyms lookup and
then executing the address it returns.

> to find a tracepoint with "xdp_exception" name
> (that would be __tracepoint_xdp_exception record)
> 
> Then kallsyms_lookup_name() is used to find the addr
> of __bpf_trace_xdp_exception() probe function.
> 
> And finally tracepoint_probe_register() is used to connect probe
> with tracepoint.
> 
> Addition of bpf_raw_tracepoint doesn't interfere with ftrace and perf
> tracepoint mechanisms. perf_event_open() can be used in parallel
> on the same tracepoint.
> Multiple bpf_raw_tracepoint_open("xdp_exception", prog_fd) are permitted.
> Each with its own bpf program. The kernel will execute
> all tracepoint probes and all attached bpf programs.
> 
> In the future bpf_raw_tracepoints can be extended with
> query/introspection logic.
> 
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> ---
>  include/linux/bpf_types.h    |   1 +
>  include/linux/trace_events.h |  37 +++++++++
>  include/trace/bpf_probe.h    |  87 ++++++++++++++++++++
>  include/trace/define_trace.h |   1 +
>  include/uapi/linux/bpf.h     |  11 +++
>  kernel/bpf/syscall.c         |  78 ++++++++++++++++++
>  kernel/trace/bpf_trace.c     | 188 +++++++++++++++++++++++++++++++++++++++++++
>  7 files changed, 403 insertions(+)
>  create mode 100644 include/trace/bpf_probe.h
> 
>


> --- a/include/linux/trace_events.h
> +++ b/include/linux/trace_events.h
> @@ -468,6 +468,8 @@ unsigned int trace_call_bpf(struct trace_event_call *call, void *ctx);
>  int perf_event_attach_bpf_prog(struct perf_event *event, struct bpf_prog *prog);
>  void perf_event_detach_bpf_prog(struct perf_event *event);
>  int perf_event_query_prog_array(struct perf_event *event, void __user *info);
> +int bpf_probe_register(struct tracepoint *tp, struct bpf_prog *prog);
> +int bpf_probe_unregister(struct tracepoint *tp, struct bpf_prog *prog);
>  #else
>  static inline unsigned int trace_call_bpf(struct trace_event_call *call, void *ctx)
>  {
> @@ -487,6 +489,14 @@ perf_event_query_prog_array(struct perf_event *event, void __user *info)
>  {
>  	return -EOPNOTSUPP;
>  }
> +static inline int bpf_probe_register(struct tracepoint *tp, struct bpf_prog *p)
> +{
> +	return -EOPNOTSUPP;
> +}
> +static inline int bpf_probe_unregister(struct tracepoint *tp, struct bpf_prog *p)
> +{
> +	return -EOPNOTSUPP;
> +}
>  #endif
>  
>  enum {
> @@ -546,6 +556,33 @@ extern void ftrace_profile_free_filter(struct perf_event *event);
>  void perf_trace_buf_update(void *record, u16 type);
>  void *perf_trace_buf_alloc(int size, struct pt_regs **regs, int *rctxp);
>  
> +void bpf_trace_run1(struct bpf_prog *prog, u64 arg1);
> +void bpf_trace_run2(struct bpf_prog *prog, u64 arg1, u64 arg2);
> +void bpf_trace_run3(struct bpf_prog *prog, u64 arg1, u64 arg2,
> +		    u64 arg3);
> +void bpf_trace_run4(struct bpf_prog *prog, u64 arg1, u64 arg2,
> +		    u64 arg3, u64 arg4);
> +void bpf_trace_run5(struct bpf_prog *prog, u64 arg1, u64 arg2,
> +		    u64 arg3, u64 arg4, u64 arg5);
> +void bpf_trace_run6(struct bpf_prog *prog, u64 arg1, u64 arg2,
> +		    u64 arg3, u64 arg4, u64 arg5, u64 arg6);
> +void bpf_trace_run7(struct bpf_prog *prog, u64 arg1, u64 arg2,
> +		    u64 arg3, u64 arg4, u64 arg5, u64 arg6, u64 arg7);
> +void bpf_trace_run8(struct bpf_prog *prog, u64 arg1, u64 arg2,
> +		    u64 arg3, u64 arg4, u64 arg5, u64 arg6, u64 arg7,
> +		    u64 arg8);
> +void bpf_trace_run9(struct bpf_prog *prog, u64 arg1, u64 arg2,
> +		    u64 arg3, u64 arg4, u64 arg5, u64 arg6, u64 arg7,
> +		    u64 arg8, u64 arg9);
> +void bpf_trace_run10(struct bpf_prog *prog, u64 arg1, u64 arg2,
> +		     u64 arg3, u64 arg4, u64 arg5, u64 arg6, u64 arg7,
> +		     u64 arg8, u64 arg9, u64 arg10);
> +void bpf_trace_run11(struct bpf_prog *prog, u64 arg1, u64 arg2,
> +		     u64 arg3, u64 arg4, u64 arg5, u64 arg6, u64 arg7,
> +		     u64 arg8, u64 arg9, u64 arg10, u64 arg11);
> +void bpf_trace_run12(struct bpf_prog *prog, u64 arg1, u64 arg2,
> +		     u64 arg3, u64 arg4, u64 arg5, u64 arg6, u64 arg7,
> +		     u64 arg8, u64 arg9, u64 arg10, u64 arg11, u64 arg12);
>  void perf_trace_run_bpf_submit(void *raw_data, int size, int rctx,
>  			       struct trace_event_call *call, u64 count,
>  			       struct pt_regs *regs, struct hlist_head *head,
> diff --git a/include/trace/bpf_probe.h b/include/trace/bpf_probe.h
> new file mode 100644
> index 000000000000..d2cc0663e618
> --- /dev/null
> +++ b/include/trace/bpf_probe.h
> @@ -0,0 +1,87 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +
> +#undef TRACE_SYSTEM_VAR
> +
> +#ifdef CONFIG_BPF_EVENTS
> +
> +#undef __entry
> +#define __entry entry
> +
> +#undef __get_dynamic_array
> +#define __get_dynamic_array(field)	\
> +		((void *)__entry + (__entry->__data_loc_##field & 0xffff))
> +
> +#undef __get_dynamic_array_len
> +#define __get_dynamic_array_len(field)	\
> +		((__entry->__data_loc_##field >> 16) & 0xffff)
> +
> +#undef __get_str
> +#define __get_str(field) ((char *)__get_dynamic_array(field))
> +
> +#undef __get_bitmask
> +#define __get_bitmask(field) (char *)__get_dynamic_array(field)
> +
> +#undef __perf_count
> +#define __perf_count(c)	(c)
> +
> +#undef __perf_task
> +#define __perf_task(t)	(t)
> +
> +/* cast any integer, pointer, or small struct to u64 */
> +#define UINTTYPE(size) \
> +	__typeof__(__builtin_choose_expr(size == 1,  (u8)1, \
> +		   __builtin_choose_expr(size == 2, (u16)2, \
> +		   __builtin_choose_expr(size == 4, (u32)3, \
> +		   __builtin_choose_expr(size == 8, (u64)4, \
> +					 (void)5)))))
> +#define __CAST_TO_U64(x) ({ \
> +	typeof(x) __src = (x); \
> +	UINTTYPE(sizeof(x)) __dst; \
> +	memcpy(&__dst, &__src, sizeof(__dst)); \
> +	(u64)__dst; })
> +
> +#define __CAST1(a,...) __CAST_TO_U64(a)
> +#define __CAST2(a,...) __CAST_TO_U64(a), __CAST1(__VA_ARGS__)
> +#define __CAST3(a,...) __CAST_TO_U64(a), __CAST2(__VA_ARGS__)
> +#define __CAST4(a,...) __CAST_TO_U64(a), __CAST3(__VA_ARGS__)
> +#define __CAST5(a,...) __CAST_TO_U64(a), __CAST4(__VA_ARGS__)
> +#define __CAST6(a,...) __CAST_TO_U64(a), __CAST5(__VA_ARGS__)
> +#define __CAST7(a,...) __CAST_TO_U64(a), __CAST6(__VA_ARGS__)
> +#define __CAST8(a,...) __CAST_TO_U64(a), __CAST7(__VA_ARGS__)
> +#define __CAST9(a,...) __CAST_TO_U64(a), __CAST8(__VA_ARGS__)
> +#define __CAST10(a,...) __CAST_TO_U64(a), __CAST9(__VA_ARGS__)
> +#define __CAST11(a,...) __CAST_TO_U64(a), __CAST10(__VA_ARGS__)
> +#define __CAST12(a,...) __CAST_TO_U64(a), __CAST11(__VA_ARGS__)
> +/* tracepoints with more than 12 arguments will hit build error */
> +#define CAST_TO_U64(...) CONCATENATE(__CAST, COUNT_ARGS(__VA_ARGS__))(__VA_ARGS__)
> +
> +#undef DECLARE_EVENT_CLASS
> +#define DECLARE_EVENT_CLASS(call, proto, args, tstruct, assign, print)	\
> +/* no 'static' here. The bpf probe functions are global */		\
> +notrace void								\

I'm curious to why you have notrace here? Since it is separate from
perf and ftrace, for debugging purposes, it could be useful to allow
function tracing to this function.

> +__bpf_trace_##call(void *__data, proto)					\
> +{									\
> +	struct bpf_prog *prog = __data;					\
> +	\
> +	CONCATENATE(bpf_trace_run, COUNT_ARGS(args))(prog, CAST_TO_U64(args));	\
> +}
> +
> +/*
> + * This part is compiled out, it is only here as a build time check
> + * to make sure that if the tracepoint handling changes, the
> + * bpf probe will fail to compile unless it too is updated.
> + */
> +#undef DEFINE_EVENT
> +#define DEFINE_EVENT(template, call, proto, args)			\
> +static inline void bpf_test_probe_##call(void)				\
> +{									\
> +	check_trace_callback_type_##call(__bpf_trace_##template);	\
> +}
> +
> +
> +#undef DEFINE_EVENT_PRINT
> +#define DEFINE_EVENT_PRINT(template, name, proto, args, print)	\
> +	DEFINE_EVENT(template, name, PARAMS(proto), PARAMS(args))
> +
> +#include TRACE_INCLUDE(TRACE_INCLUDE_FILE)
> +#endif /* CONFIG_BPF_EVENTS */
> diff --git a/include/trace/define_trace.h b/include/trace/define_trace.h
> index 96b22ace9ae7..5f8216bc261f 100644
> --- a/include/trace/define_trace.h
> +++ b/include/trace/define_trace.h
> @@ -95,6 +95,7 @@
>  #ifdef TRACEPOINTS_ENABLED
>  #include <trace/trace_events.h>
>  #include <trace/perf.h>
> +#include <trace/bpf_probe.h>
>  #endif
>  
>  #undef TRACE_EVENT
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index 18b7c510c511..1878201c2d77 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -94,6 +94,7 @@ enum bpf_cmd {
>  	BPF_MAP_GET_FD_BY_ID,
>  	BPF_OBJ_GET_INFO_BY_FD,
>  	BPF_PROG_QUERY,
> +	BPF_RAW_TRACEPOINT_OPEN,
>  };
>  
>  enum bpf_map_type {
> @@ -134,6 +135,7 @@ enum bpf_prog_type {
>  	BPF_PROG_TYPE_SK_SKB,
>  	BPF_PROG_TYPE_CGROUP_DEVICE,
>  	BPF_PROG_TYPE_SK_MSG,
> +	BPF_PROG_TYPE_RAW_TRACEPOINT,
>  };
>  
>  enum bpf_attach_type {
> @@ -344,6 +346,11 @@ union bpf_attr {
>  		__aligned_u64	prog_ids;
>  		__u32		prog_cnt;
>  	} query;
> +
> +	struct {
> +		__u64 name;
> +		__u32 prog_fd;
> +	} raw_tracepoint;
>  } __attribute__((aligned(8)));
>  
>  /* BPF helper function descriptions:
> @@ -1152,4 +1159,8 @@ struct bpf_cgroup_dev_ctx {
>  	__u32 minor;
>  };
>  
> +struct bpf_raw_tracepoint_args {
> +	__u64 args[0];
> +};
> +
>  #endif /* _UAPI__LINUX_BPF_H__ */
> diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
> index 3aeb4ea2a93a..7486b450672e 100644
> --- a/kernel/bpf/syscall.c
> +++ b/kernel/bpf/syscall.c
> @@ -1311,6 +1311,81 @@ static int bpf_obj_get(const union bpf_attr *attr)
>  				attr->file_flags);
>  }
>  
> +struct bpf_raw_tracepoint {
> +	struct tracepoint *tp;
> +	struct bpf_prog *prog;
> +};
> +
> +static int bpf_raw_tracepoint_release(struct inode *inode, struct file *filp)
> +{
> +	struct bpf_raw_tracepoint *raw_tp = filp->private_data;
> +
> +	if (raw_tp->prog) {
> +		bpf_probe_unregister(raw_tp->tp, raw_tp->prog);
> +		bpf_prog_put(raw_tp->prog);
> +	}
> +	kfree(raw_tp);
> +	return 0;
> +}
> +
> +static const struct file_operations bpf_raw_tp_fops = {
> +	.release	= bpf_raw_tracepoint_release,
> +	.read		= bpf_dummy_read,
> +	.write		= bpf_dummy_write,
> +};
> +
> +#define BPF_RAW_TRACEPOINT_OPEN_LAST_FIELD raw_tracepoint.prog_fd
> +
> +static int bpf_raw_tracepoint_open(const union bpf_attr *attr)
> +{
> +	struct bpf_raw_tracepoint *raw_tp;
> +	struct tracepoint *tp;
> +	struct bpf_prog *prog;
> +	char tp_name[128];
> +	int tp_fd, err;
> +
> +	if (strncpy_from_user(tp_name, u64_to_user_ptr(attr->raw_tracepoint.name),
> +			      sizeof(tp_name) - 1) < 0)
> +		return -EFAULT;
> +	tp_name[sizeof(tp_name) - 1] = 0;
> +
> +	tp = kernel_tracepoint_find_by_name(tp_name);
> +	if (!tp)
> +		return -ENOENT;
> +
> +	raw_tp = kmalloc(sizeof(*raw_tp), GFP_USER | __GFP_ZERO);

Please use kzalloc(), instead of open coding the "__GPF_ZERO"

> +	if (!raw_tp)
> +		return -ENOMEM;
> +	raw_tp->tp = tp;
> +
> +	prog = bpf_prog_get_type(attr->raw_tracepoint.prog_fd,
> +				 BPF_PROG_TYPE_RAW_TRACEPOINT);
> +	if (IS_ERR(prog)) {
> +		err = PTR_ERR(prog);
> +		goto out_free_tp;
> +	}
> +
> +	err = bpf_probe_register(raw_tp->tp, prog);
> +	if (err)
> +		goto out_put_prog;
> +
> +	raw_tp->prog = prog;
> +	tp_fd = anon_inode_getfd("bpf-raw-tracepoint", &bpf_raw_tp_fops, raw_tp,
> +				 O_CLOEXEC);
> +	if (tp_fd < 0) {
> +		bpf_probe_unregister(raw_tp->tp, prog);
> +		err = tp_fd;
> +		goto out_put_prog;
> +	}
> +	return tp_fd;
> +
> +out_put_prog:
> +	bpf_prog_put(prog);
> +out_free_tp:
> +	kfree(raw_tp);
> +	return err;
> +}
> +
>  #ifdef CONFIG_CGROUP_BPF
>  
>  #define BPF_PROG_ATTACH_LAST_FIELD attach_flags
> @@ -1921,6 +1996,9 @@ SYSCALL_DEFINE3(bpf, int, cmd, union bpf_attr __user *, uattr, unsigned int, siz
>  	case BPF_OBJ_GET_INFO_BY_FD:
>  		err = bpf_obj_get_info_by_fd(&attr, uattr);
>  		break;
> +	case BPF_RAW_TRACEPOINT_OPEN:
> +		err = bpf_raw_tracepoint_open(&attr);
> +		break;
>  	default:
>  		err = -EINVAL;
>  		break;
> diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
> index c634e093951f..00e86aa11360 100644
> --- a/kernel/trace/bpf_trace.c
> +++ b/kernel/trace/bpf_trace.c
> @@ -723,6 +723,86 @@ const struct bpf_verifier_ops tracepoint_verifier_ops = {
>  const struct bpf_prog_ops tracepoint_prog_ops = {
>  };
>  
> +/*
> + * bpf_raw_tp_regs are separate from bpf_pt_regs used from skb/xdp
> + * to avoid potential recursive reuse issue when/if tracepoints are added
> + * inside bpf_*_event_output and/or bpf_get_stack_id
> + */
> +static DEFINE_PER_CPU(struct pt_regs, bpf_raw_tp_regs);
> +BPF_CALL_5(bpf_perf_event_output_raw_tp, struct bpf_raw_tracepoint_args *, args,
> +	   struct bpf_map *, map, u64, flags, void *, data, u64, size)
> +{
> +	struct pt_regs *regs = this_cpu_ptr(&bpf_raw_tp_regs);
> +
> +	perf_fetch_caller_regs(regs);
> +	return ____bpf_perf_event_output(regs, map, flags, data, size);
> +}
> +
> +static const struct bpf_func_proto bpf_perf_event_output_proto_raw_tp = {
> +	.func		= bpf_perf_event_output_raw_tp,
> +	.gpl_only	= true,
> +	.ret_type	= RET_INTEGER,
> +	.arg1_type	= ARG_PTR_TO_CTX,
> +	.arg2_type	= ARG_CONST_MAP_PTR,
> +	.arg3_type	= ARG_ANYTHING,
> +	.arg4_type	= ARG_PTR_TO_MEM,
> +	.arg5_type	= ARG_CONST_SIZE_OR_ZERO,
> +};
> +
> +BPF_CALL_3(bpf_get_stackid_raw_tp, struct bpf_raw_tracepoint_args *, args,
> +	   struct bpf_map *, map, u64, flags)
> +{
> +	struct pt_regs *regs = this_cpu_ptr(&bpf_raw_tp_regs);
> +
> +	perf_fetch_caller_regs(regs);
> +	/* similar to bpf_perf_event_output_tp, but pt_regs fetched differently */
> +	return bpf_get_stackid((unsigned long) regs, (unsigned long) map,
> +			       flags, 0, 0);
> +}
> +
> +static const struct bpf_func_proto bpf_get_stackid_proto_raw_tp = {
> +	.func		= bpf_get_stackid_raw_tp,
> +	.gpl_only	= true,
> +	.ret_type	= RET_INTEGER,
> +	.arg1_type	= ARG_PTR_TO_CTX,
> +	.arg2_type	= ARG_CONST_MAP_PTR,
> +	.arg3_type	= ARG_ANYTHING,
> +};
> +
> +static const struct bpf_func_proto *raw_tp_prog_func_proto(enum bpf_func_id func_id)
> +{
> +	switch (func_id) {
> +	case BPF_FUNC_perf_event_output:
> +		return &bpf_perf_event_output_proto_raw_tp;
> +	case BPF_FUNC_get_stackid:
> +		return &bpf_get_stackid_proto_raw_tp;
> +	default:
> +		return tracing_func_proto(func_id);
> +	}
> +}
> +
> +static bool raw_tp_prog_is_valid_access(int off, int size,
> +					enum bpf_access_type type,
> +					struct bpf_insn_access_aux *info)
> +{
> +	/* largest tracepoint in the kernel has 12 args */
> +	if (off < 0 || off >= sizeof(__u64) * 12)
> +		return false;
> +	if (type != BPF_READ)
> +		return false;
> +	if (off % size != 0)
> +		return false;
> +	return true;
> +}
> +
> +const struct bpf_verifier_ops raw_tracepoint_verifier_ops = {
> +	.get_func_proto  = raw_tp_prog_func_proto,
> +	.is_valid_access = raw_tp_prog_is_valid_access,
> +};
> +
> +const struct bpf_prog_ops raw_tracepoint_prog_ops = {
> +};
> +
>  static bool pe_prog_is_valid_access(int off, int size, enum bpf_access_type type,
>  				    struct bpf_insn_access_aux *info)
>  {
> @@ -896,3 +976,111 @@ int perf_event_query_prog_array(struct perf_event *event, void __user *info)
>  
>  	return ret;
>  }
> +
> +static __always_inline
> +void __bpf_trace_run(struct bpf_prog *prog, u64 *args)
> +{
> +	rcu_read_lock();
> +	preempt_disable();
> +	(void) BPF_PROG_RUN(prog, args);
> +	preempt_enable();
> +	rcu_read_unlock();
> +}
> +

Could you add some comments here to explain what the below is doing.

> +#define UNPACK(...)			__VA_ARGS__
> +#define REPEAT_1(FN, DL, X, ...)	FN(X)
> +#define REPEAT_2(FN, DL, X, ...)	FN(X) UNPACK DL REPEAT_1(FN, DL, __VA_ARGS__)
> +#define REPEAT_3(FN, DL, X, ...)	FN(X) UNPACK DL REPEAT_2(FN, DL, __VA_ARGS__)
> +#define REPEAT_4(FN, DL, X, ...)	FN(X) UNPACK DL REPEAT_3(FN, DL, __VA_ARGS__)
> +#define REPEAT_5(FN, DL, X, ...)	FN(X) UNPACK DL REPEAT_4(FN, DL, __VA_ARGS__)
> +#define REPEAT_6(FN, DL, X, ...)	FN(X) UNPACK DL REPEAT_5(FN, DL, __VA_ARGS__)
> +#define REPEAT_7(FN, DL, X, ...)	FN(X) UNPACK DL REPEAT_6(FN, DL, __VA_ARGS__)
> +#define REPEAT_8(FN, DL, X, ...)	FN(X) UNPACK DL REPEAT_7(FN, DL, __VA_ARGS__)
> +#define REPEAT_9(FN, DL, X, ...)	FN(X) UNPACK DL REPEAT_8(FN, DL, __VA_ARGS__)
> +#define REPEAT_10(FN, DL, X, ...)	FN(X) UNPACK DL REPEAT_9(FN, DL, __VA_ARGS__)
> +#define REPEAT_11(FN, DL, X, ...)	FN(X) UNPACK DL REPEAT_10(FN, DL, __VA_ARGS__)
> +#define REPEAT_12(FN, DL, X, ...)	FN(X) UNPACK DL REPEAT_11(FN, DL, __VA_ARGS__)
> +#define REPEAT(X, FN, DL, ...)		REPEAT_##X(FN, DL, __VA_ARGS__)
> +
> +#define SARG(X)		u64 arg##X
> +#define COPY(X)		args[X] = arg##X
> +
> +#define __DL_COM	(,)
> +#define __DL_SEM	(;)
> +
> +#define __SEQ_0_11	0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11
> +
> +#define BPF_TRACE_DEFN_x(x)						\
> +	void bpf_trace_run##x(struct bpf_prog *prog,			\
> +			      REPEAT(x, SARG, __DL_COM, __SEQ_0_11))	\
> +	{								\
> +		u64 args[x];						\
> +		REPEAT(x, COPY, __DL_SEM, __SEQ_0_11);			\
> +		__bpf_trace_run(prog, args);				\
> +	}								\
> +	EXPORT_SYMBOL_GPL(bpf_trace_run##x)
> +BPF_TRACE_DEFN_x(1);
> +BPF_TRACE_DEFN_x(2);
> +BPF_TRACE_DEFN_x(3);
> +BPF_TRACE_DEFN_x(4);
> +BPF_TRACE_DEFN_x(5);
> +BPF_TRACE_DEFN_x(6);
> +BPF_TRACE_DEFN_x(7);
> +BPF_TRACE_DEFN_x(8);
> +BPF_TRACE_DEFN_x(9);
> +BPF_TRACE_DEFN_x(10);
> +BPF_TRACE_DEFN_x(11);
> +BPF_TRACE_DEFN_x(12);
> +
> +static int __bpf_probe_register(struct tracepoint *tp, struct bpf_prog *prog)
> +{
> +	unsigned long addr;
> +	char buf[128];
> +
> +	/*
> +	 * check that program doesn't access arguments beyond what's
> +	 * available in this tracepoint
> +	 */
> +	if (prog->aux->max_ctx_offset > tp->num_args * sizeof(u64))
> +		return -EINVAL;
> +
> +	snprintf(buf, sizeof(buf), "__bpf_trace_%s", tp->name);
> +	addr = kallsyms_lookup_name(buf);
> +	if (!addr)
> +		return -ENOENT;
> +
> +	return tracepoint_probe_register(tp, (void *)addr, prog);

You are putting in a hell of a lot of trust with kallsyms returning
properly. I can see this being very fragile. This is calling a function
based on the result of kallsyms. I'm sure the security folks would love
this.

There's a few things to make this a bit more robust. One is to add a
table that points to all __bpf_trace_* functions, and verify that the
result from kallsyms is in that table.

Honestly, I think this is too much of a short cut and a hack. I know
you want to keep it "simple" and save space, but you really should do
it the same way ftrace and perf do it. That is, create a section and
have all tracepoints create a structure that holds a pointer to the
tracepoint and to the bpf probe function. Then you don't even need the
kernel_tracepoint_find_by_name(), you just iterate over your table and
you get the tracepoint and the bpf function associated to it.

Relying on kallsyms to return an address to execute is just way too
extreme and fragile for my liking.

-- Steve



> +}
> +
> +int bpf_probe_register(struct tracepoint *tp, struct bpf_prog *prog)
> +{
> +	int err;
> +
> +	mutex_lock(&bpf_event_mutex);
> +	err = __bpf_probe_register(tp, prog);
> +	mutex_unlock(&bpf_event_mutex);
> +	return err;
> +}
> +
> +static int __bpf_probe_unregister(struct tracepoint *tp, struct bpf_prog *prog)
> +{
> +	unsigned long addr;
> +	char buf[128];
> +
> +	snprintf(buf, sizeof(buf), "__bpf_trace_%s", tp->name);
> +	addr = kallsyms_lookup_name(buf);
> +	if (!addr)
> +		return -ENOENT;
> +
> +	return tracepoint_probe_unregister(tp, (void *)addr, prog);
> +}
> +
> +int bpf_probe_unregister(struct tracepoint *tp, struct bpf_prog *prog)
> +{
> +	int err;
> +
> +	mutex_lock(&bpf_event_mutex);
> +	err = __bpf_probe_unregister(tp, prog);
> +	mutex_unlock(&bpf_event_mutex);
> +	return err;
> +}
