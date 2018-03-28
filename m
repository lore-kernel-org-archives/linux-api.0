From: Alexei Starovoitov <ast@fb.com>
Subject: Re: [PATCH v7 bpf-next 06/10] tracepoint: compute num_args at build
 time
Date: Wed, 28 Mar 2018 11:03:24 -0700
Message-ID: <80d7af37-10ef-28d7-f03f-27b4b5849cd1@fb.com>
References: <20180328021105.4061744-1-ast@fb.com>
 <20180328021105.4061744-7-ast@fb.com>
 <1074829260.1986.1522244964935.JavaMail.zimbra@efficios.com>
 <67c5f9b4-b24a-2806-e8d6-8b5241c66d6e@fb.com>
 <20180328130407.7476cf17@gandalf.local.home>
 <fdcb0bf0-f896-ffb3-b9de-0b17f5f70fc6@fb.com>
 <20180328133830.3d5d74d3@gandalf.local.home>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180328133830.3d5d74d3@gandalf.local.home>
Sender: netdev-owner@vger.kernel.org
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, "David S. Miller" <davem@davemloft.net>, Daniel Borkmann <daniel@iogearbox.net>, Linus Torvalds <torvalds@linux-foundation.org>, Peter Zijlstra <peterz@infradead.org>, netdev <netdev@vger.kernel.org>, kernel-team <kernel-team@fb.com>, linux-api <linux-api@vger.kernel.org>, Josh Poimboeuf <jpoimboe@redhat.com>
List-Id: linux-api@vger.kernel.org

On 3/28/18 10:38 AM, Steven Rostedt wrote:
> On Wed, 28 Mar 2018 10:10:34 -0700
> Alexei Starovoitov <ast@fb.com> wrote:
>
>
>>> and have:
>>>
>>> 	u64 tp_offset = (u64)tp - (u64)_sdata;
>>>
>>> 	if (WARN_ON(tp_offset > UINT_MAX)
>>> 		return -EINVAL;
>>>
>>> 	 btp->tp_offset = (u32)tp_offset;
>>
>> above math has to be build time constant, so warn_on likely
>> won't work.
>
> Right, it would require a BUILD_BUG_ON.
>
>> imo the whole thing is too fragile and obscure.
>> I suggest to compress this 8 bytes * num_of_tracepoints later.
>> Especially would be good to do it in one way for
>> bpf_raw_event_map, ftrace and other places.
>
> Fair enough. We can defer this shrinkage to another time. I only
> suggested it here over your concern for the added bloat.

Actually, I will take it back.
I think the current shape of the patch is better.
struct tracepoint is aligned to 32-bytes by linker
Though sizeof(struct tracepoint) == 48 it actually consumes 64 bytes
of memory.
(gdb) p (void*)&__tracepoint_sys_enter - (void*)&__tracepoint_sys_exit
$3 = 64

Adding num_args to 'struct tracepoint' makes it sizeof==56,
but it still takes 64-bytes in memory.

In this patch sizeof(struct bpf_raw_tp_map) == 16 and
(gdb) p (void*)&__bpf_trace_tp_map_sys_enter - 
(void*)&__bpf_trace_tp_map_sys_exit
$3 = 16

so it consumes exactly the same 16-bytes.
If we add 'u32 num_args' to it, it will have
sizeof(struct bpf_raw_tp_map) == 24 and will consume 32-bytes
of memory.

So clearly adding num_args to struct tracepont gives zero additional
bloat vs before this patch set, whereas moving it to
struct bpf_raw_tp_map will add 16 * num_of_tracepoints bytes of memory.

I can live with this overhead if Mathieu insists,
but I prefer to keep it in 'struct tracepoint'.

Thoughts?
