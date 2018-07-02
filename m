From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [RFC PATCH for 4.18 1/2] rseq: use __u64 for rseq_cs fields,
 validate abort_ip < TASK_SIZE
Date: Mon, 2 Jul 2018 17:03:44 -0400 (EDT)
Message-ID: <1307337131.10790.1530565424717.JavaMail.zimbra@efficios.com>
References: <20180702204058.819-1-mathieu.desnoyers@efficios.com> <CA+55aFzH+4=Aeh_P1ptFn5nVm7yFuEGpxUJ0kNB-sUHVOv8rcw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CA+55aFzH+4=Aeh_P1ptFn5nVm7yFuEGpxUJ0kNB-sUHVOv8rcw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel <linux-kernel@vger.kernel.org>, linux-api <linux-api@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Andy Lutomirski <luto@amacapital.net>, Dave Watson <davejwatson@fb.com>, Paul Turner <pjt@google.com>, Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>, Chris Lameter <cl@linux.com>, Ben Maurer <bmaurer@fb.com>, rostedt <rostedt@goodmis.org>, Josh Triplett <josh@joshtriplett.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Michael Kerrisk <mtk.ma>
List-Id: linux-api@vger.kernel.org

----- On Jul 2, 2018, at 4:52 PM, Linus Torvalds torvalds@linux-foundation.org wrote:

> On Mon, Jul 2, 2018 at 1:41 PM Mathieu Desnoyers
> <mathieu.desnoyers@efficios.com> wrote:
>>
>> -       if (copy_from_user(rseq_cs, urseq_cs, sizeof(*rseq_cs)))
>> +       if (copy_from_user(rseq_cs, urseq_cs, sizeof(*rseq_cs)) ||
>> +           rseq_cs->abort_ip >= TASK_SIZE)
>>                 return -EFAULT;
> 
> I think the abort_ip check should have the same error value as the
> other sanity checks, ie just be of this format:
> 
>>         if (rseq_cs->version > 0)
>>                 return -EINVAL;

OK, so I'll go for -EINVAL.

> 
> also, I think you should check start_ip to be consistent. You kind of
> accidentally do it with the check for
> 
>        if (rseq_cs->abort_ip - rseq_cs->start_ip - rseq_cs->post_commit_offset)

The check is actually:

        /* Ensure that abort_ip is not in the critical section. */
        if (rseq_cs->abort_ip - rseq_cs->start_ip < rseq_cs->post_commit_offset)
                return -EINVAL;

> 
> but honestly, that has underflow issues already, so I think you want
> to basically make the check be
> 
>        if (rseq_cs->abort_ip >= TASK_SIZE)
>                return -EINVAL;

that works.

> 
>        if (rseq_cs->start_ip >= rseq_cs->abort_ip)
>                return -EINVAL;

this one does not work. We need to ensure that abort_ip
is not between [ start_ip, start_ip + post_commit_offset ]. The
check you propose validates that start_ip is below abort_ip,
which is bogus. For instance, abort_ip can very well be in a
different section of the binary, at an address either below
or above start_ip.


> 
> which takes care of checkint  start_ip, and also the underflow for the
> post_commit_offset check.

What underflow issues are you concerned with ?

> 
> If somebody is depending on negative offsets, then that
> post_commit_offset logic is already wrong.
> 
>> +       usig = (u32 __user *)(unsigned long)(rseq_cs->abort_ip - sizeof(u32));
>>         ret = get_user(sig, usig);
> 
> That can underflow too, but I guess we can just rely on get_user()
> getting it right.

Yes, get_user() should handle that one properly.

Thanks,

Mathieu

> 
>                Linus

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
