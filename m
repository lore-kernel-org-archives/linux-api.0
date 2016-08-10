From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [RFC PATCH v7 1/7] Restartable sequences system call
Date: Wed, 10 Aug 2016 14:04:53 +0000 (UTC)
Message-ID: <821822611.7093.1470837893291.JavaMail.zimbra@efficios.com>
References: <1469135662-31512-1-git-send-email-mathieu.desnoyers@efficios.com> <20160803131940.GM6862@twins.programming.kicks-ass.net> <656745027.6624.1470773200334.JavaMail.zimbra@efficios.com> <20160809213314.GK30192@twins.programming.kicks-ass.net> <427989454.6732.1470782507345.JavaMail.zimbra@efficios.com> <20160810075044.GJ6879@twins.programming.kicks-ass.net> <1431024781.7024.1470835564859.JavaMail.zimbra@efficios.com> <20160810133306.GO30192@twins.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160810133306.GO30192@twins.programming.kicks-ass.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Peter Zijlstra <peterz@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, linux-kernel <linux-kernel@vger.kernel.org>, linux-api <linux-api@vger.kernel.org>, Paul Turner <pjt@google.com>, Andrew Hunter <ahh@google.com>, Andy Lutomirski <luto@amacapital.net>, Andi Kleen <andi@firstfloor.org>, Dave Watson <davejwatson@fb.com>, Chris Lameter <cl@linux.com>, Ben Maurer <bmaurer@fb.com>, rostedt <rostedt@goodmis.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Josh Triplett <josh@joshtriplett.org>, Linus Torvalds <torvalds@linux-foundation.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Michael Kerrisk <mtk.manpages@gmail.com>, Boqun Feng <boqun.feng@gmail.com>
List-Id: linux-api@vger.kernel.org

----- On Aug 10, 2016, at 9:33 AM, Peter Zijlstra peterz@infradead.org wrote:

> On Wed, Aug 10, 2016 at 01:26:04PM +0000, Mathieu Desnoyers wrote:
> 
>> static bool rseq_update_cpu_id_event_counter(struct task_struct *t)
>> {
>>         union rseq_cpu_event u;
>> 
>>         u.e.cpu_id = raw_smp_processor_id();
>>         u.e.event_counter = ++t->rseq_event_counter;
>>         if (__put_user(u.v, &t->rseq->u.v))
>>                 return false;
>>         trace_rseq_inc(t->rseq_event_counter);
> 
> I had not previously noticed the trace_* muck, but I would suggest
> passing in t and leaving it up to the tracepoint implementation to pick
> out the value.

OK, fixed.

> 
> Also, since this not only increments (it also updates the cpu number)
> the naming is 'wrong'.

I'll rename the event to "rseq_update" then, and have two fields:
cpu_id and event_counter.

Thanks,

Mathieu

> 
>>         return true;
> > }

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
