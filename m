From: Alexei Starovoitov <ast@fb.com>
Subject: Re: [PATCH bpf-next 3/5] bpf: introduce BPF_RAW_TRACEPOINT
Date: Mon, 5 Mar 2018 17:28:28 -0800
Message-ID: <dbac65a5-0e3c-7098-b9cb-1f2f5b9aee9f@fb.com>
References: <20180301041957.399230-1-ast@kernel.org>
 <20180301041957.399230-4-ast@kernel.org>
 <56cd9ef9-41b0-dc89-fa49-92a459796515@iogearbox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <56cd9ef9-41b0-dc89-fa49-92a459796515@iogearbox.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Daniel Borkmann <daniel@iogearbox.net>, Alexei Starovoitov <ast@kernel.org>, davem@davemloft.net
Cc: torvalds@linux-foundation.org, peterz@infradead.org, mingo@kernel.org, rostedt@goodmis.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On 3/5/18 3:56 PM, Daniel Borkmann wrote:
> On 03/01/2018 05:19 AM, Alexei Starovoitov wrote:
>> Introduce BPF_PROG_TYPE_RAW_TRACEPOINT bpf program type to access
>> kernel internal arguments of the tracepoints in their raw form.
>>
>> From bpf program point of view the access to the arguments look like:
>> struct bpf_raw_tracepoint_args {
>>        __u64 args[0];
>> };
>>
>> int bpf_prog(struct bpf_raw_tracepoint_args *ctx)
>> {
>>   // program can read args[N] where N depends on tracepoint
>>   // and statically verified at program load+attach time
>> }
>>
>> kprobe+bpf infrastructure allows programs access function arguments.
>> This feature allows programs access raw tracepoint arguments.
>>
>> Similar to proposed 'dynamic ftrace events' there are no abi guarantees
>> to what the tracepoints arguments are and what their meaning is.
>> The program needs to type cast args properly and use bpf_probe_read()
>> helper to access struct fields when argument is a pointer.
>>
>> For every tracepoint __bpf_trace_##call function is prepared.
>> In assembler it looks like:
>> (gdb) disassemble __bpf_trace_xdp_exception
>> Dump of assembler code for function __bpf_trace_xdp_exception:
>>    0xffffffff81132080 <+0>:     mov    %ecx,%ecx
>>    0xffffffff81132082 <+2>:     jmpq   0xffffffff811231f0 <bpf_trace_run3>
>>
>> where
>>
>> TRACE_EVENT(xdp_exception,
>>         TP_PROTO(const struct net_device *dev,
>>                  const struct bpf_prog *xdp, u32 act),
>>
>> The above assembler snippet is casting 32-bit 'act' field into 'u64'
>> to pass into bpf_trace_run3(), while 'dev' and 'xdp' args are passed as-is.
>> All of ~500 of __bpf_trace_*() functions are only 5-10 byte long
>> and in total this approach adds 7k bytes to .text and 8k bytes
>> to .rodata since the probe funcs need to appear in kallsyms.
>> The alternative of having __bpf_trace_##call being global in kallsyms
>> could have been to keep them static and add another pointer to these
>> static functions to 'struct trace_event_class' and 'struct trace_event_call',
>> but keeping them global simplifies implementation and keeps it indepedent
>> from the tracing side.
>>
>> Also such approach gives the lowest possible overhead
>> while calling trace_xdp_exception() from kernel C code and
>> transitioning into bpf land.
>
> Awesome work! Just a few comments below.
>
>> Since tracepoint+bpf are used at speeds of 1M+ events per second
>> this is very valuable optimization.
>>
>> Since ftrace and perf side are not involved the new
>> BPF_RAW_TRACEPOINT_OPEN sys_bpf command is introduced
>> that returns anon_inode FD of 'bpf-raw-tracepoint' object.
>>
>> The user space looks like:
>> // load bpf prog with BPF_PROG_TYPE_RAW_TRACEPOINT type
>> prog_fd = bpf_prog_load(...);
>> // receive anon_inode fd for given bpf_raw_tracepoint
>> raw_tp_fd = bpf_raw_tracepoint_open("xdp_exception");
>> // attach bpf program to given tracepoint
>> bpf_prog_attach(prog_fd, raw_tp_fd, BPF_RAW_TRACEPOINT);
>>
>> Ctrl-C of tracing daemon or cmdline tool that uses this feature
>> will automatically detach bpf program, unload it and
>> unregister tracepoint probe.
>>
>> On the kernel side for_each_kernel_tracepoint() is used
>> to find a tracepoint with "xdp_exception" name
>> (that would be __tracepoint_xdp_exception record)
>>
>> Then kallsyms_lookup_name() is used to find the addr
>> of __bpf_trace_xdp_exception() probe function.
>>
>> And finally tracepoint_probe_register() is used to connect probe
>> with tracepoint.
>>
>> Addition of bpf_raw_tracepoint doesn't interfere with ftrace and perf
>> tracepoint mechanisms. perf_event_open() can be used in parallel
>> on the same tracepoint.
>> Also multiple bpf_raw_tracepoint_open("foo") are permitted.
>> Each raw_tp_fd allows to attach one bpf program, so multiple
>> user space processes can open their own raw_tp_fd with their own
>> bpf program. The kernel will execute all tracepoint probes
>> and all attached bpf programs.
>>
>> In the future bpf_raw_tracepoints can be extended with
>> query/introspection logic.
>>
>> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
...
>> +static int bpf_raw_tracepoint_open(const union bpf_attr *attr)
>> +{
>> +	struct bpf_raw_tracepoint *raw_tp;
>> +	struct tracepoint *tp;
>> +	char tp_name[128];
>> +
>> +	if (strncpy_from_user(tp_name, u64_to_user_ptr(attr->raw_tracepoint.name),
>> +			      sizeof(tp_name) - 1) < 0)
>> +		return -EFAULT;
>> +	tp_name[sizeof(tp_name) - 1] = 0;
>> +
>> +	tp = for_each_kernel_tracepoint(__find_tp, tp_name);
>> +	if (!tp)
>> +		return -ENOENT;
>> +
>> +	raw_tp = kmalloc(sizeof(*raw_tp), GFP_USER | __GFP_ZERO);
>> +	if (!raw_tp)
>> +		return -ENOMEM;
>> +	raw_tp->tp = tp;
>> +
>> +	return anon_inode_getfd("bpf-raw-tracepoint", &bpf_raw_tp_fops, raw_tp,
>> +				O_CLOEXEC);
>
> When anon_inode_getfd() fails to get you an fd, then you leak raw_tp here.

good catch. will fix.

>>  		break;
>> +	case BPF_RAW_TRACEPOINT_OPEN:
>> +		err = bpf_raw_tracepoint_open(&attr);
>
> With regards to above attach_raw_tp() comment, why not having single
> BPF_RAW_TRACEPOINT_OPEN command already passing BPF fd along with the
> tp name? Is there a concrete reason/use-case why it's split that way?

The use case is to attach the same bpf prog to multiple raw_tp,
but with your suggestion it will work as well,
so yeah will change to that since it simplifies uapi and avoids
the race in attach.

Thank you for review.
