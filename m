From: Alexei Starovoitov <ast@fb.com>
Subject: Re: [PATCH v5 bpf-next 00/10] bpf, tracing: introduce bpf raw
 tracepoints
Date: Mon, 26 Mar 2018 09:00:33 -0700
Message-ID: <3967d838-e737-ec44-d03b-54f11f85d21b@fb.com>
References: <20180324023038.938665-1-ast@fb.com>
 <c8be6d52-3f86-0402-9fdc-cc98f8e3e940@iogearbox.net>
 <20180326110435.4cdd7e7d@gandalf.local.home>
 <ba96cda5-c4d6-4d66-0128-b7053d25fcd8@iogearbox.net>
 <20180326114725.1999288a@gandalf.local.home>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180326114725.1999288a@gandalf.local.home>
Sender: netdev-owner@vger.kernel.org
To: Steven Rostedt <rostedt@goodmis.org>, Daniel Borkmann <daniel@iogearbox.net>
Cc: davem@davemloft.net, torvalds@linux-foundation.org, peterz@infradead.org, netdev@vger.kernel.org, kernel-team@fb.com, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On 3/26/18 8:47 AM, Steven Rostedt wrote:
> On Mon, 26 Mar 2018 17:32:02 +0200
> Daniel Borkmann <daniel@iogearbox.net> wrote:
>
>> On 03/26/2018 05:04 PM, Steven Rostedt wrote:
>>> On Mon, 26 Mar 2018 10:28:03 +0200
>>> Daniel Borkmann <daniel@iogearbox.net> wrote:
>>>
>>>>> tracepoint    base  kprobe+bpf tracepoint+bpf raw_tracepoint+bpf
>>>>> task_rename   1.1M   769K        947K            1.0M
>>>>> urandom_read  789K   697K        750K            755K
>>>>
>>>> Applied to bpf-next, thanks Alexei!
>>>
>>> Please wait till you have the proper acks. Some of this affects
>>> tracing.
>>
>> Ok, I thought time up to v5 was long enough. Anyway, in case there are
>> objections I can still toss out the series from bpf-next tree worst case
>> should e.g. follow-up fixups not be appropriate.
>
> Yeah, I've been traveling a bit which slowed down my review process
> (trying to catch up).

v1 of this set was posted Feb 28.
imo one month is not an acceptable delay for maintainer to review
the patches. You really need to consider group maintainership as
we do with Daniel for bpf tree.

> My main concern is with patch 6, as there are
> external users of those functions. Although, we generally don't cater
> to out of tree code, we play nice with LTTng, and I don't want to break
> it.

out-of-tree module is out of tree. I'm beyond surprised that you
propose to keep for_each_kernel_tracepoint() as-is with zero in-tree
users in order to keep lttng working.

> I also should probably pull in the patches and run them through my
> tests to make sure they don't have any other side effects.

so let me rephrase.
You're saying that a change to a function with zero in-tree users
can somehow break your tests?
How is that possible?
Does it mean you also have some out-of-tree modules that will break?
and that _is_ the real reason for objection?
