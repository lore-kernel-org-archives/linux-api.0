From: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Subject: Re: [RFC PATCH v7 1/7] Restartable sequences system call
Date: Wed, 10 Aug 2016 01:13:42 -0700
Message-ID: <CALCETrVLi4Wdca7r_3xVCOJENFi9U7aPa_Ru303muRbEttufRA@mail.gmail.com>
References: <1469135662-31512-1-git-send-email-mathieu.desnoyers@efficios.com>
 <1469135662-31512-2-git-send-email-mathieu.desnoyers@efficios.com>
 <CALCETrVq3hgLbADcx_4g6gGgp7Hf-WnnWA8gg68tPZTv2wfbDg@mail.gmail.com>
 <1806206514.82247.1469502139408.JavaMail.zimbra@efficios.com>
 <20160803122717.GL6862@twins.programming.kicks-ass.net> <CALCETrWw0M9YLWTR7_ruxY8cW9_5XRONdw1QN+_pBp0Y63L8pA@mail.gmail.com>
 <20160804042710.GA13232@tardis.cn.ibm.com> <CALCETrW7t89BWXW5JbWyLVciKS1HJMXe7feopM31wkqL4AtoFA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CALCETrW7t89BWXW5JbWyLVciKS1HJMXe7feopM31wkqL4AtoFA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Boqun Feng <boqun.feng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Russell King <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>, Dave Watson <davejwatson-b10kYP2dOMg@public.gmane.org>, Chris Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Ben Maurer <bmaurer-b10kYP2dOMg@public.gmane.org>, rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Wed, Aug 3, 2016 at 10:03 PM, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org> wrote:
> On Wed, Aug 3, 2016 at 9:27 PM, Boqun Feng <boqun.feng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>> On Wed, Aug 03, 2016 at 09:37:57AM -0700, Andy Lutomirski wrote:
>>> On Wed, Aug 3, 2016 at 5:27 AM, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> wrote:
>>> > On Tue, Jul 26, 2016 at 03:02:19AM +0000, Mathieu Desnoyers wrote:
>>> >> We really care about preemption here. Every migration implies a
>>> >> preemption from a user-space perspective. If we would only care
>>> >> about keeping the CPU id up-to-date, hooking into migration would be
>>> >> enough. But since we want atomicity guarantees for restartable
>>> >> sequences, we need to hook into preemption.
>>> >
>>> >> It allows user-space to perform update operations on per-cpu data without
>>> >> requiring heavy-weight atomic operations.
>>> >
>>> > Well, a CMPXCHG without LOCK prefix isn't all that expensive on x86.
>>> >
>>> > It is however on PPC and possibly other architectures, so in name of
>>> > simplicity supporting only the one variant makes sense.
>>> >
>>>
>>> I wouldn't want to depend on CMPXCHG.  But imagine we had primitives
>>> that were narrower than the full abort-on-preemption primitive.
>>> Specifically, suppose we had abort if (actual cpu != expected_cpu ||
>>> *aptr != aval).  We could do things like:
>>>
>>> expected_cpu = cpu;
>>> aval = NULL;  // disarm for now
>>> begin();
>>> aval = event_count[cpu] + 1;
>>> event_count[cpu] = aval;
>>> event_count[cpu]++;
>>
>> This line is redundant, right? Because it will guarantee a failure even
>> in no-contention cases.
>>
>>>
>>> ... compute something ...
>>>
>>> // arm the rest of it
>>> aptr = &event_count[cpu];
>>> if (*aptr != aval)
>>>   goto fail;
>>>
>>> *thing_im_writing = value_i_computed;
>>> end();
>>>
>>> The idea here is that we don't rely on the scheduler to increment the
>>> event count at all, which means that we get to determine the scope of
>>> what kinds of access conflicts we care about ourselves.
>>>
>>
>> If we increase the event count in userspace, how could we prevent two
>> userspace threads from racing on the event_count[cpu] field? For
>> example:
>>
>>         CPU 0
>>         ================
>>         {event_count[0] is initially 0}
>>
>>         [Thread 1]
>>         begin();
>>         aval = event_count[cpu] + 1; // 1
>>
>>         (preempted)
>>         [Thread 2]
>>         begin();
>>         aval = event_count[cpu] + 1; // 1, too
>>         event_count[cpu] = aval; // event_count[0] is 1
>>
>
> You're right :(  This would work with an xadd instruction, but that's
> very slow and doesn't exist on most architectures.  It could also work
> if we did:

Thinking about this slightly more, maybe it does work.  We could use
basically the same mechanism to allow the kernel to restart if the
specific sequence:

aval = event_count[cpu] + 1
event_count[cpu] = avall

gets preempted by setting aptr = &event_count[cpu] and aval to
event_count[cpu], like this (although I might have screwed up any
number of small details):

aptr = &event_count[cpu];
barrier();
aval = event_count[cpu];
barrier();
tmp = aval + 1;
event_count[cpu] = tmp;
/* preemption here will cause an unnecessary retry, but that's okay */
aval = tmp;

--Andy
