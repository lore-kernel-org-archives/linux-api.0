From: Alexei Starovoitov <ast@fb.com>
Subject: Re: [PATCH v6 bpf-next 08/11] bpf: introduce BPF_RAW_TRACEPOINT
Date: Tue, 27 Mar 2018 11:45:34 -0700
Message-ID: <f071b59d-5d67-0eb6-c5b1-68094b0a5118@fb.com>
References: <20180327024706.2064725-1-ast@fb.com>
 <20180327024706.2064725-9-ast@fb.com>
 <20180327130211.284c8924@gandalf.local.home>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180327130211.284c8924@gandalf.local.home>
Sender: netdev-owner@vger.kernel.org
To: Steven Rostedt <rostedt@goodmis.org>
Cc: davem@davemloft.net, daniel@iogearbox.net, torvalds@linux-foundation.org, peterz@infradead.org, netdev@vger.kernel.org, kernel-team@fb.com, linux-api@vger.kernel.org, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Kees Cook <keescook@chromium.org>
List-Id: linux-api@vger.kernel.org

On 3/27/18 10:02 AM, Steven Rostedt wrote:
> On Mon, 26 Mar 2018 19:47:03 -0700
> Alexei Starovoitov <ast@fb.com> wrote:
>
>
>> Ctrl-C of tracing daemon or cmdline tool that uses this feature
>> will automatically detach bpf program, unload it and
>> unregister tracepoint probe.
>>
>> On the kernel side for_each_kernel_tracepoint() is used
>
> You need to update the change log to state
> kernel_tracepoint_find_by_name().

ahh. right. will do.

>> +#undef DECLARE_EVENT_CLASS
>> +#define DECLARE_EVENT_CLASS(call, proto, args, tstruct, assign, print)	\
>> +/* no 'static' here. The bpf probe functions are global */		\
>> +notrace void								\
>
> I'm curious to why you have notrace here? Since it is separate from
> perf and ftrace, for debugging purposes, it could be useful to allow
> function tracing to this function.

To avoid unnecessary overhead. And I don't think it's useful to trace 
them. They're tiny jump functions of one or two instructions.
Really no point wasting mentry on them.


>> +static int bpf_raw_tracepoint_open(const union bpf_attr *attr)
>> +{
>> +	struct bpf_raw_tracepoint *raw_tp;
>> +	struct tracepoint *tp;
>> +	struct bpf_prog *prog;
>> +	char tp_name[128];
>> +	int tp_fd, err;
>> +
>> +	if (strncpy_from_user(tp_name, u64_to_user_ptr(attr->raw_tracepoint.name),
>> +			      sizeof(tp_name) - 1) < 0)
>> +		return -EFAULT;
>> +	tp_name[sizeof(tp_name) - 1] = 0;
>> +
>> +	tp = kernel_tracepoint_find_by_name(tp_name);
>> +	if (!tp)
>> +		return -ENOENT;
>> +
>> +	raw_tp = kmalloc(sizeof(*raw_tp), GFP_USER | __GFP_ZERO);
>
> Please use kzalloc(), instead of open coding the "__GPF_ZERO"

right. will do

>
> Could you add some comments here to explain what the below is doing.

To write a proper comment I need to understand it and I don't.
That's the reason why I didn't put in in common header,
because it would require proper comment on what it is and
how one can use it.
I'm expecting Daniel to follow up on this.

>> +#define UNPACK(...)			__VA_ARGS__
>> +#define REPEAT_1(FN, DL, X, ...)	FN(X)
>> +#define REPEAT_2(FN, DL, X, ...)	FN(X) UNPACK DL REPEAT_1(FN, DL, __VA_ARGS__)
>> +#define REPEAT_3(FN, DL, X, ...)	FN(X) UNPACK DL REPEAT_2(FN, DL, __VA_ARGS__)
>> +#define REPEAT_4(FN, DL, X, ...)	FN(X) UNPACK DL REPEAT_3(FN, DL, __VA_ARGS__)
>> +#define REPEAT_5(FN, DL, X, ...)	FN(X) UNPACK DL REPEAT_4(FN, DL, __VA_ARGS__)
>> +#define REPEAT_6(FN, DL, X, ...)	FN(X) UNPACK DL REPEAT_5(FN, DL, __VA_ARGS__)
>> +#define REPEAT_7(FN, DL, X, ...)	FN(X) UNPACK DL REPEAT_6(FN, DL, __VA_ARGS__)
>> +#define REPEAT_8(FN, DL, X, ...)	FN(X) UNPACK DL REPEAT_7(FN, DL, __VA_ARGS__)
>> +#define REPEAT_9(FN, DL, X, ...)	FN(X) UNPACK DL REPEAT_8(FN, DL, __VA_ARGS__)
>> +#define REPEAT_10(FN, DL, X, ...)	FN(X) UNPACK DL REPEAT_9(FN, DL, __VA_ARGS__)
>> +#define REPEAT_11(FN, DL, X, ...)	FN(X) UNPACK DL REPEAT_10(FN, DL, __VA_ARGS__)
>> +#define REPEAT_12(FN, DL, X, ...)	FN(X) UNPACK DL REPEAT_11(FN, DL, __VA_ARGS__)
>> +#define REPEAT(X, FN, DL, ...)		REPEAT_##X(FN, DL, __VA_ARGS__)
>> +

>> +
>> +	snprintf(buf, sizeof(buf), "__bpf_trace_%s", tp->name);
>> +	addr = kallsyms_lookup_name(buf);
>> +	if (!addr)
>> +		return -ENOENT;
>> +
>> +	return tracepoint_probe_register(tp, (void *)addr, prog);
>
> You are putting in a hell of a lot of trust with kallsyms returning
> properly. I can see this being very fragile. This is calling a function
> based on the result of kallsyms. I'm sure the security folks would love
> this.
>
> There's a few things to make this a bit more robust. One is to add a
> table that points to all __bpf_trace_* functions, and verify that the
> result from kallsyms is in that table.
>
> Honestly, I think this is too much of a short cut and a hack. I know
> you want to keep it "simple" and save space, but you really should do
> it the same way ftrace and perf do it. That is, create a section and
> have all tracepoints create a structure that holds a pointer to the
> tracepoint and to the bpf probe function. Then you don't even need the
> kernel_tracepoint_find_by_name(), you just iterate over your table and
> you get the tracepoint and the bpf function associated to it.
>
> Relying on kallsyms to return an address to execute is just way too
> extreme and fragile for my liking.

Wasting extra 8bytes * number_of_tracepoints just for lack of trust
in kallsyms doesn't sound like good trade off to me.
If kallsyms are inaccurate all sorts of things will break:
kprobes, livepatch, etc.
I'd rather suggest for ftrace to use kallsyms approach as well
and reduce memory footprint.
