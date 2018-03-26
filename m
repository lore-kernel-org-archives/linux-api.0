From: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH v5 bpf-next 00/10] bpf, tracing: introduce bpf raw
 tracepoints
Date: Mon, 26 Mar 2018 12:16:12 -0400
Message-ID: <20180326121612.06fa539c@gandalf.local.home>
References: <20180324023038.938665-1-ast@fb.com>
        <c8be6d52-3f86-0402-9fdc-cc98f8e3e940@iogearbox.net>
        <20180326110435.4cdd7e7d@gandalf.local.home>
        <ba96cda5-c4d6-4d66-0128-b7053d25fcd8@iogearbox.net>
        <20180326114725.1999288a@gandalf.local.home>
        <3967d838-e737-ec44-d03b-54f11f85d21b@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <3967d838-e737-ec44-d03b-54f11f85d21b@fb.com>
Sender: netdev-owner@vger.kernel.org
To: Alexei Starovoitov <ast@fb.com>
Cc: Daniel Borkmann <daniel@iogearbox.net>, davem@davemloft.net, torvalds@linux-foundation.org, peterz@infradead.org, netdev@vger.kernel.org, kernel-team@fb.com, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Mon, 26 Mar 2018 09:00:33 -0700
Alexei Starovoitov <ast@fb.com> wrote:

> On 3/26/18 8:47 AM, Steven Rostedt wrote:
> > On Mon, 26 Mar 2018 17:32:02 +0200
> > Daniel Borkmann <daniel@iogearbox.net>


> >> On 03/26/2018 05:04 PM, Steven Rostedt wrote:  
> >>> On Mon, 26 Mar 2018 10:28:03 +0200
> >>> Daniel Borkmann <daniel@iogearbox.net> wrote:
> >>>  
> >>>>> tracepoint    base  kprobe+bpf tracepoint+bpf raw_tracepoint+bpf
> >>>>> task_rename   1.1M   769K        947K            1.0M
> >>>>> urandom_read  789K   697K        750K            755K  
> >>>>
> >>>> Applied to bpf-next, thanks Alexei!  
> >>>
> >>> Please wait till you have the proper acks. Some of this affects
> >>> tracing.  
> >>
> >> Ok, I thought time up to v5 was long enough. Anyway, in case there are
> >> objections I can still toss out the series from bpf-next tree worst case
> >> should e.g. follow-up fixups not be appropriate.  
> >
> > Yeah, I've been traveling a bit which slowed down my review process
> > (trying to catch up).  
> 
> v1 of this set was posted Feb 28.

Yep, Where I traveled to the West coast 2/26 - 3/1 (but due to snow
storms, I didn't get home till late 3/2). Then I went back 3/6 and came
home 3/8 (again due to another snow storm, it was 3/9). Then I went to
ELC from 3/11 to 3/15 (Luckily, the third snow storm hit 3/14, and
didn't affect my return trip).

> imo one month is not an acceptable delay for maintainer to review
> the patches. You really need to consider group maintainership as
> we do with Daniel for bpf tree.

Perhaps, (which I talked to Masami about, just need to go through
logistics). But the tracing code isn't high volume, and the three weeks
of traveling for me was a fluke (didn't look at my schedule when I
agreed to make that second one).

> 
> > My main concern is with patch 6, as there are
> > external users of those functions. Although, we generally don't cater
> > to out of tree code, we play nice with LTTng, and I don't want to break
> > it.  
> 
> out-of-tree module is out of tree. I'm beyond surprised that you
> propose to keep for_each_kernel_tracepoint() as-is with zero in-tree
> users in order to keep lttng working.

I'm nice.

> 
> > I also should probably pull in the patches and run them through my
> > tests to make sure they don't have any other side effects.  
> 
> so let me rephrase.
> You're saying that a change to a function with zero in-tree users
> can somehow break your tests?
> How is that possible?
> Does it mean you also have some out-of-tree modules that will break?
> and that _is_ the real reason for objection?

That function isn't what I'm worried about. You changed much more than
that.

-- Steve
