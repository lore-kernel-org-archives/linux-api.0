From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [RFC PATCH for 4.17 02/21] rseq: Introduce restartable
 sequences system call (v12)
Date: Wed, 28 Mar 2018 11:03:33 -0400 (EDT)
Message-ID: <49066300.2176.1522249413336.JavaMail.zimbra@efficios.com>
References: <20180327160542.28457-1-mathieu.desnoyers@efficios.com> <20180327160542.28457-3-mathieu.desnoyers@efficios.com> <20180328122946.GU4043@hirez.programming.kicks-ass.net> <20180328125216.GF4129@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180328125216.GF4129@hirez.programming.kicks-ass.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Peter Zijlstra <peterz@infradead.org>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Andy Lutomirski <luto@amacapital.net>, Dave Watson <davejwatson@fb.com>, linux-kernel <linux-kernel@vger.kernel.org>, linux-api <linux-api@vger.kernel.org>, Paul Turner <pjt@google.com>, Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Andrew Hunter <ahh@google.com>, Andi Kleen <andi@firstfloor.org>, Chris Lameter <cl@linux.com>, Ben Maurer <bmaurer@fb.com>, rostedt <rostedt@goodmis.org>, Josh Triplett <josh@joshtriplett.org>, Linus Torvalds <torvalds@linux-foundation.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will>
List-Id: linux-api@vger.kernel.org

----- On Mar 28, 2018, at 8:52 AM, Peter Zijlstra peterz@infradead.org wrote:

> On Wed, Mar 28, 2018 at 02:29:46PM +0200, Peter Zijlstra wrote:
>> > +static int rseq_get_rseq_cs(struct task_struct *t,
>> > +			    unsigned long *start_ip,
>> > +			    unsigned long *post_commit_offset,
>> > +			    unsigned long *abort_ip,
>> > +			    uint32_t *cs_flags)
>> > +{
> 
>> 
>> > +
>> > +	*cs_flags = rseq_cs.flags;
>> > +	*start_ip = rseq_cs.start_ip;
>> > +	*post_commit_offset = rseq_cs.post_commit_offset;
>> > +	*abort_ip = rseq_cs.abort_ip;
>> 
>> Then this becomes a straight struct assignment.
> 
> I initially suggested passing a structure instead of many arguments, but
> then recondidered, mostly because it will be inlined (due to having only
> the one caller) anyway. Still, maybe a struct will work better, I dunno.

I find the result of struct pointer argument cleaner indeed. I'll go for that
approach.

I'll memset rseq_cs to 0 in the following case though, because the caller
expects the content of the structure to be set when rseq_get_rseq_cs() succeeds.

static int rseq_get_rseq_cs(struct task_struct *t, struct rseq_cs *rseq_cs)
{
        struct rseq_cs __user *urseq_cs;
        unsigned long ptr;
        u32 __user *usig;
        u32 sig;
        int ret;

        ret = __get_user(ptr, &t->rseq->rseq_cs);
        if (ret)
                return ret;
        if (!ptr) {
                memset(rseq_cs, 0, sizeof(*rseq_cs));
                return 0;
        }

[...]

Thanks!

Mathieu


-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
