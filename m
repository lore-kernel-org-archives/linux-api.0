From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [PATCH v7 bpf-next 06/10] tracepoint: compute num_args at build
 time
Date: Wed, 28 Mar 2018 13:14:45 -0400 (EDT)
Message-ID: <754862332.127.1522257285121.JavaMail.zimbra@efficios.com>
References: <20180328021105.4061744-1-ast@fb.com> <20180328021105.4061744-7-ast@fb.com> <1074829260.1986.1522244964935.JavaMail.zimbra@efficios.com> <67c5f9b4-b24a-2806-e8d6-8b5241c66d6e@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <67c5f9b4-b24a-2806-e8d6-8b5241c66d6e@fb.com>
Sender: netdev-owner@vger.kernel.org
To: Alexei Starovoitov <ast@fb.com>
Cc: "David S. Miller" <davem@davemloft.net>, Daniel Borkmann <daniel@iogearbox.net>, Linus Torvalds <torvalds@linux-foundation.org>, Peter Zijlstra <peterz@infradead.org>, rostedt <rostedt@goodmis.org>, netdev <netdev@vger.kernel.org>, kernel-team <kernel-team@fb.com>, linux-api <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

----- On Mar 28, 2018, at 12:43 PM, Alexei Starovoitov ast@fb.com wrote:

> On 3/28/18 6:49 AM, Mathieu Desnoyers wrote:
>> ----- On Mar 27, 2018, at 10:11 PM, Alexei Starovoitov ast@fb.com wrote:
>>
>>> From: Alexei Starovoitov <ast@kernel.org>
>>>
>>> compute number of arguments passed into tracepoint
>>> at compile time and store it as part of 'struct tracepoint'.
>>> The number is necessary to check safety of bpf program access that
>>> is coming in subsequent patch.
>>
>>
>> Hi Alexei,
>>
>> Given that only eBPF needs this parameter count, we can move
>> it to the struct bpf_raw_event_map newly introduced by Steven,
>> right ? This would reduce bloat of struct tracepoint. For instance,
>> we don't need to keep this count around when eBPF is configured
>> out.
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
> 
> I'm guessing now you found out that num_args is not useful to lttng
> and it bloats its data structures?

I'm concerned about kernel configurations with only ftrace and
perf, with eBPF disabled. In those configurations, adding ebpf-specific
fields to struct tracepoint increases the kernel image size needlessly.
LTTng is not my concern in this discussion.

I'm also concerned about adding more and more elements to struct tracepoint
in general. For instance, I'd really like to see the regfunc/unregfunc
fields go away into a different section, allowing us to reduce the size of
struct tracepoint, so we can do a better use of the CPU caches when
tracing is enabled. The "funcs" field needs to be loaded each time a
tracepoint is fired, and therefore needs to be cache-hot. Adding more
cache-cold fields in there degrades cache locality, because "hot"
cache-lines then need to hold more cache-cold data.

> It's ok to change an opinion and I'm completely fine using that as
> a real reason.

Seeing the code of the new eBPF section provided by Steven made me realize
that we could use it to hold the num_args as well, keeping all the eBPF
data nice and tidy together. So yes, this is new information that changed
my opinion on the matter.

> Will repsin, as I said. No problem.

Thanks!

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
