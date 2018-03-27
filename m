From: Alexei Starovoitov <ast@fb.com>
Subject: Re: [PATCH v6 bpf-next 08/11] bpf: introduce BPF_RAW_TRACEPOINT
Date: Tue, 27 Mar 2018 15:48:35 -0700
Message-ID: <563f7fa0-5fea-00d3-1eb3-fa00d8cf7e29@fb.com>
References: <20180327024706.2064725-1-ast@fb.com>
 <20180327024706.2064725-9-ast@fb.com>
 <20180327130211.284c8924@gandalf.local.home>
 <20180327131143.4b83534c@gandalf.local.home>
 <20180327145824.602dfdec@gandalf.local.home>
 <20180327170438.77c0f8fd@gandalf.local.home>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180327170438.77c0f8fd@gandalf.local.home>
Sender: netdev-owner@vger.kernel.org
To: Steven Rostedt <rostedt@goodmis.org>
Cc: davem@davemloft.net, daniel@iogearbox.net, torvalds@linux-foundation.org, peterz@infradead.org, netdev@vger.kernel.org, kernel-team@fb.com, linux-api@vger.kernel.org, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Kees Cook <keescook@chromium.org>
List-Id: linux-api@vger.kernel.org

On 3/27/18 2:04 PM, Steven Rostedt wrote:
>
> +#ifdef CONFIG_BPF_EVENTS
> +#define BPF_RAW_TP() . = ALIGN(8);		\
> +			 VMLINUX_SYMBOL(__start__bpf_raw_tp) = .;	\
> +			 KEEP(*(__bpf_raw_tp_map))			\
> +			 VMLINUX_SYMBOL(__stop__bpf_raw_tp) = .;

that looks to be correct, but something wrong with it.

Can you try your mini test with kasan on ?

I'm seeing this crash:
test_stacktrace_[   18.760662] start ffffffff84642438 stop ffffffff84644f60
map_raw_tp:PASS:[   18.761467] i 1 btp->tp cccccccccccccccc
prog_load raw tp[   18.762064] kasan: CONFIG_KASAN_INLINE enabled
  0 nsec
[   18.762704] kasan: GPF could be caused by NULL-ptr deref or user 
memory access
[   18.765125] general protection fault: 0000 [#1] SMP KASAN PTI
[   18.765830] Modules linked in:
[   18.778358] Call Trace:
[   18.778674]  bpf_raw_tracepoint_open.isra.27+0x92/0x380

for some reason the start_bpf_raw_tp is off by 8.
Not sure how it works for you.

(gdb) p &__bpf_trace_tp_map_sys_exit
$10 = (struct bpf_raw_event_map *) 0xffffffff84642440 
<__bpf_trace_tp_map_sys_exit>

(gdb)  p &__start__bpf_raw_tp
$7 = (<data variable, no debug info> *) 0xffffffff84642438

(gdb)  p (void*)(&__start__bpf_raw_tp)+8
$11 = (void *) 0xffffffff84642440 <__bpf_trace_tp_map_sys_exit>
