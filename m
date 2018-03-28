From: Alexei Starovoitov <ast@fb.com>
Subject: Re: [PATCH v6 bpf-next 08/11] bpf: introduce BPF_RAW_TRACEPOINT
Date: Tue, 27 Mar 2018 17:00:23 -0700
Message-ID: <b0763759-3f8b-317b-5fb4-600648495462@fb.com>
References: <20180327024706.2064725-1-ast@fb.com>
 <20180327024706.2064725-9-ast@fb.com>
 <20180327130211.284c8924@gandalf.local.home>
 <20180327131143.4b83534c@gandalf.local.home>
 <20180327145824.602dfdec@gandalf.local.home>
 <20180327170438.77c0f8fd@gandalf.local.home>
 <563f7fa0-5fea-00d3-1eb3-fa00d8cf7e29@fb.com>
 <430531879.1792.1522192417816.JavaMail.zimbra@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <430531879.1792.1522192417816.JavaMail.zimbra@efficios.com>
Sender: netdev-owner@vger.kernel.org
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: rostedt <rostedt@goodmis.org>, "David S. Miller" <davem@davemloft.net>, Daniel Borkmann <daniel@iogearbox.net>, Linus Torvalds <torvalds@linux-foundation.org>, Peter Zijlstra <peterz@infradead.org>, netdev <netdev@vger.kernel.org>, kernel-team <kernel-team@fb.com>, linux-api <linux-api@vger.kernel.org>, Kees Cook <keescook@chromium.org>
List-Id: linux-api@vger.kernel.org

On 3/27/18 4:13 PM, Mathieu Desnoyers wrote:
> ----- On Mar 27, 2018, at 6:48 PM, Alexei Starovoitov ast@fb.com wrote:
>
>> On 3/27/18 2:04 PM, Steven Rostedt wrote:
>>>
>>> +#ifdef CONFIG_BPF_EVENTS
>>> +#define BPF_RAW_TP() . = ALIGN(8);		\
>
> Given that the section consists of a 16-bytes structure elements
> on architectures with 8 bytes pointers, this ". = ALIGN(8)" should
> be turned into a STRUCT_ALIGN(), especially given that the compiler
> is free to up-align the structure on 32 bytes.

STRUCT_ALIGN fixed the 'off by 8' issue with kasan,
but it fails without kasan too.
For some reason the whole region __start__bpf_raw_tp - __stop__bpf_raw_tp
comes inited with cccc:
[   22.703562] i 1 btp ffffffff8288e530 btp->tp cccccccccccccccc func 
cccccccccccccccc
[   22.704638] i 2 btp ffffffff8288e540 btp->tp cccccccccccccccc func 
cccccccccccccccc
[   22.705599] i 3 btp ffffffff8288e550 btp->tp cccccccccccccccc func 
cccccccccccccccc
[   22.706551] i 4 btp ffffffff8288e560 btp->tp cccccccccccccccc func 
cccccccccccccccc
[   22.707503] i 5 btp ffffffff8288e570 btp->tp cccccccccccccccc func 
cccccccccccccccc
[   22.708452] i 6 btp ffffffff8288e580 btp->tp cccccccccccccccc func 
cccccccccccccccc
[   22.709406] i 7 btp ffffffff8288e590 btp->tp cccccccccccccccc func 
cccccccccccccccc
[   22.710368] i 8 btp ffffffff8288e5a0 btp->tp cccccccccccccccc func 
cccccccccccccccc

while gdb shows that everything is good inside vmlinux
for exactly these addresses.
Some other linker magic missing?
