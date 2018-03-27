From: Alexei Starovoitov <ast@fb.com>
Subject: Re: [PATCH v6 bpf-next 07/11] tracepoint: introduce
 kernel_tracepoint_find_by_name
Date: Tue, 27 Mar 2018 08:53:21 -0700
Message-ID: <8600dbae-389d-dd01-f003-44f1af7dcf0a@fb.com>
References: <20180327024706.2064725-1-ast@fb.com>
 <20180327024706.2064725-8-ast@fb.com>
 <20180327100711.0ec7aafb@gandalf.local.home>
 <1566743692.1117.1522160304471.JavaMail.zimbra@efficios.com>
 <20180327104242.3594bcac@gandalf.local.home>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180327104242.3594bcac@gandalf.local.home>
Sender: netdev-owner@vger.kernel.org
To: Steven Rostedt <rostedt@goodmis.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: "David S. Miller" <davem@davemloft.net>, Daniel Borkmann <daniel@iogearbox.net>, Linus Torvalds <torvalds@linux-foundation.org>, Peter Zijlstra <peterz@infradead.org>, netdev <netdev@vger.kernel.org>, kernel-team <kernel-team@fb.com>, linux-api <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On 3/27/18 7:42 AM, Steven Rostedt wrote:
> On Tue, 27 Mar 2018 10:18:24 -0400 (EDT)
> Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:
>
>> ----- On Mar 27, 2018, at 10:07 AM, rostedt rostedt@goodmis.org wrote:
>>
>>> On Mon, 26 Mar 2018 19:47:02 -0700
>>> Alexei Starovoitov <ast@fb.com> wrote:
>>>
>>>> From: Alexei Starovoitov <ast@kernel.org>
>>>>
>>>> introduce kernel_tracepoint_find_by_name() helper to let bpf core
>>>> find tracepoint by name and later attach bpf probe to a tracepoint
>>>>
>>>> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
>>>
>>> Reviewed-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
>>
>> Steven showed preference for tracepoint_kernel_find_by_name() at some
>> point (starting with a tracepoint_ prefix). I'm find with either of
>> the names.
>
> Yeah, I do prefer tracepoint_kernel_find_by_name() to stay consistent
> with the other tracepoint functions. But we have
> "for_each_kernel_tracepoint()" and not "for_each_tracepoint_kernel()",
> thus we need to pick being consistent with one or the other. One answer
> is to use tracpoint_kernel_find_by_name() and rename the for_each to
> for_each_tracpoint_kernel().

yep. that's exactly the reason I picked kernel_tracepoint_find_by_name()
to match for_each_kernel_tracepoint() naming.

I can certainly send a follow up patch to rename both to
*tracepoint_kernel* and then you can nack it because it breaks lttng :)
but let's do it in a separate thread.

Daniel,
do you mind adding { } as Steven requested while applying or
you want me to resubmit the whole thing?

Thanks!
