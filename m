From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [PATCH v7 bpf-next 06/10] tracepoint: compute num_args at build
 time
Date: Wed, 28 Mar 2018 15:22:24 -0400 (EDT)
Message-ID: <842190155.225.1522264944386.JavaMail.zimbra@efficios.com>
References: <20180328021105.4061744-1-ast@fb.com> <20180328130407.7476cf17@gandalf.local.home> <fdcb0bf0-f896-ffb3-b9de-0b17f5f70fc6@fb.com> <20180328133830.3d5d74d3@gandalf.local.home> <80d7af37-10ef-28d7-f03f-27b4b5849cd1@fb.com> <20180328141045.1202afeb@gandalf.local.home> <a5c8ff7c-8185-a3fd-89eb-45ddc099c03b@fb.com> <20180328145431.687643bc@gandalf.local.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180328145431.687643bc@gandalf.local.home>
Sender: netdev-owner@vger.kernel.org
To: rostedt <rostedt@goodmis.org>
Cc: Alexei Starovoitov <ast@fb.com>, "David S. Miller" <davem@davemloft.net>, Daniel Borkmann <daniel@iogearbox.net>, Linus Torvalds <torvalds@linux-foundation.org>, Peter Zijlstra <peterz@infradead.org>, netdev <netdev@vger.kernel.org>, kernel-team <kernel-team@fb.com>, linux-api <linux-api@vger.kernel.org>, Josh Poimboeuf <jpoimboe@redhat.com>
List-Id: linux-api@vger.kernel.org


----- On Mar 28, 2018, at 2:54 PM, rostedt rostedt@goodmis.org wrote:

> On Wed, 28 Mar 2018 11:19:34 -0700
> Alexei Starovoitov <ast@fb.com> wrote:
> 
>> On 3/28/18 11:10 AM, Steven Rostedt wrote:
>> > On Wed, 28 Mar 2018 11:03:24 -0700
>> > Alexei Starovoitov <ast@fb.com> wrote:
>> >  
>> >> I can live with this overhead if Mathieu insists,
>> >> but I prefer to keep it in 'struct tracepoint'.
>> >>
>> >> Thoughts?
>> >
>> > I'm fine with keeping it as is. We could probably use it for future
>> > enhancements in perf and ftrace.
>> >
>> > Perhaps, we should just add a:
>> >
>> > #ifdef CONFIG_BPF_EVENTS
>> >
>> > Around the use cases of num_args.
>> 
>> it sounds like a good idea, but implementation wise
>> it will be ifdef CONFIG_BPF_EVENTS around u32 num_args;
>> in struct tracepoint and similar double definition of
>> DEFINE_TRACE_FN. One that uses num_args to init
>> struct tracepoint and one that doesn't ?
>> Feels like serious uglification of already macros heavy code.
>> Also what it will address?
> 
> 32bit bloat ;-)
> 
> But I agree, it's not worth uglifying it.
> 
> -- Steve
> 
> > cache hot/cold argument clearly doesn't apply.

In the current situation I'm fine with adding this extra field
to struct tracepoint. However, we should keep in mind to move
all non-required cache-cold fields to a separate section at
some point. Clearly just this single field won't make a difference
due to other fields and padding.

Thanks,

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
