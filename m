From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [PATCH v8 bpf-next 6/9] bpf: introduce BPF_RAW_TRACEPOINT
Date: Wed, 28 Mar 2018 15:48:47 -0400 (EDT)
Message-ID: <2000920858.249.1522266527563.JavaMail.zimbra@efficios.com>
References: <20180328190540.370956-1-ast@kernel.org> <20180328190540.370956-7-ast@kernel.org> <20180328153435.5e733957@gandalf.local.home> <2a0f6ac2-b13e-b8ad-31b4-a42909a34efa@fb.com> <20180328154027.569206ba@gandalf.local.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180328154027.569206ba@gandalf.local.home>
Sender: netdev-owner@vger.kernel.org
To: rostedt <rostedt@goodmis.org>
Cc: Alexei Starovoitov <ast@fb.com>, Alexei Starovoitov <ast@kernel.org>, "David S. Miller" <davem@davemloft.net>, Daniel Borkmann <daniel@iogearbox.net>, Linus Torvalds <torvalds@linux-foundation.org>, Peter Zijlstra <peterz@infradead.org>, netdev <netdev@vger.kernel.org>, kernel-team <kernel-team@fb.com>, linux-api <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

----- On Mar 28, 2018, at 3:40 PM, rostedt rostedt@goodmis.org wrote:

> On Wed, 28 Mar 2018 12:38:48 -0700
> Alexei Starovoitov <ast@fb.com> wrote:
> 
>> On 3/28/18 12:34 PM, Steven Rostedt wrote:
>> > On Wed, 28 Mar 2018 12:05:37 -0700
>> > Alexei Starovoitov <ast@kernel.org> wrote:
>> >  
>> >> +++ b/include/linux/tracepoint-defs.h
>> >> @@ -35,4 +35,10 @@ struct tracepoint {
>> >>  	struct tracepoint_func __rcu *funcs;
>> >>  };
>> >>
>> >> +struct bpf_raw_event_map {
>> >> +	struct tracepoint	*tp;
>> >> +	void			*bpf_func;
>> >> +	u32			num_args;
>> >> +} __aligned(32);
>> >> +
>> >
>> > If you prefer v7, I'm fine with that. For cache issues, I can pull out
>> > the funcs from the tracepoint structure like I posted.
>> 
>> I very much prefer to land this v8 as-is and optimize later.
>> 
>> I still have bpfilter/microkernel patches to finish which were
>> practically ready two weeks ago and got delayed but this set.
> 
> Then by all means, you have my Ack. We can optimize later.
> 
> For the whole series... (v7 or v8)
> 
> Acked-by: Steven Rostedt (VMware) <rostedt@goodmis.org>

I'm fine with either v7 or v8 as well.

Thanks,

Mathieu

> 
> Thanks!
> 
> -- Steve

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
