From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [PATCH bpf-next] bpf, tracing: unbreak lttng
Date: Mon, 26 Mar 2018 18:39:25 -0400 (EDT)
Message-ID: <1959671494.623.1522103965117.JavaMail.zimbra@efficios.com>
References: <20180326220845.678423-1-ast@kernel.org> <20180326181532.587e9e2b@gandalf.local.home> <24d0ff40-c6fd-6349-4a89-dffda22cb596@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <24d0ff40-c6fd-6349-4a89-dffda22cb596@fb.com>
Sender: netdev-owner@vger.kernel.org
To: Alexei Starovoitov <ast@fb.com>
Cc: rostedt <rostedt@goodmis.org>, Alexei Starovoitov <ast@kernel.org>, "David S. Miller" <davem@davemloft.net>, Daniel Borkmann <daniel@iogearbox.net>, Linus Torvalds <torvalds@linux-foundation.org>, Peter Zijlstra <peterz@infradead.org>, netdev <netdev@vger.kernel.org>, kernel-team <kernel-team@fb.com>, linux-api <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

----- On Mar 26, 2018, at 6:25 PM, Alexei Starovoitov ast@fb.com wrote:

> On 3/26/18 3:15 PM, Steven Rostedt wrote:
>> On Mon, 26 Mar 2018 15:08:45 -0700
>> Alexei Starovoitov <ast@kernel.org> wrote:
>>
>>> for_each_kernel_tracepoint() is used by out-of-tree lttng module
>>> and therefore cannot be changed.
>>> Instead introduce kernel_tracepoint_find_by_name() to find
>>> tracepoint by name.
>>>
>>> Fixes: 9e9afbae6514 ("tracepoint: compute num_args at build time")
>>> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
>>
>> I'm curious, why can't you rebase? The first patch was never acked.
> 
> because I think it makes sense to keep such things in the commit log
> and in the separate diff, so next developer is aware of what kind of
> minefield the tracpoints are.
> No wonder some maintainers refuse to add them.

Since when has it become accepted to push commits into maintainer's
subsystems without their acknowledgment first ?

The minefield you are currently walking through appears to be of your
own making, so please just rework your initial patch before it reaches
upstream.

Thanks,

Mathieu



-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
