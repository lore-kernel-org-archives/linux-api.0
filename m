From: Alexei Starovoitov <ast@fb.com>
Subject: Re: [PATCH bpf-next] bpf, tracing: unbreak lttng
Date: Mon, 26 Mar 2018 15:35:56 -0700
Message-ID: <761ce9e6-aea4-01d8-8ff0-a17ad8a92526@fb.com>
References: <20180326220845.678423-1-ast@kernel.org>
 <1523827268.612.1522103407744.JavaMail.zimbra@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1523827268.612.1522103407744.JavaMail.zimbra@efficios.com>
Sender: netdev-owner@vger.kernel.org
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Alexei Starovoitov <ast@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>, Daniel Borkmann <daniel@iogearbox.net>, Linus Torvalds <torvalds@linux-foundation.org>, Peter Zijlstra <peterz@infradead.org>, rostedt <rostedt@goodmis.org>, netdev <netdev@vger.kernel.org>, kernel-team <kernel-team@fb.com>, linux-api <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On 3/26/18 3:30 PM, Mathieu Desnoyers wrote:
> ----- On Mar 26, 2018, at 6:08 PM, Alexei Starovoitov ast@kernel.org wrote:
> [...]
>>
>> #ifdef CONFIG_TRACEPOINTS
>> -void *
>> -for_each_kernel_tracepoint(void *(*fct)(struct tracepoint *tp, void *priv),
>> +void
>> +for_each_kernel_tracepoint(void (*fct)(struct tracepoint *tp, void *priv),
>> 			   void *priv);
>> +struct tracepoint *kernel_tracepoint_find_by_name(const char *name);
>> #else
>> -static inline void *
>> -for_each_kernel_tracepoint(void *(*fct)(struct tracepoint *tp, void *priv),
>> +static inline void
>> +for_each_kernel_tracepoint(void (*fct)(struct tracepoint *tp, void *priv),
>> 			   void *priv)
>> {
>> 	return NULL;
>> }
>
> This patch is not reverting to the old code properly. It introduces a
> static inline void function that returns NULL. Please compile-test
> with CONFIG_TRACEPOINTS=n before submitting a patch involving tracepoints.

right. good catch. v2 is coming.
