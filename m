From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [RFC PATCH for 4.18 1/2] rseq: use __u64 for rseq_cs fields,
 validate abort_ip < TASK_SIZE
Date: Mon, 2 Jul 2018 18:03:22 -0400 (EDT)
Message-ID: <522686232.10814.1530569002544.JavaMail.zimbra@efficios.com>
References: <20180702204058.819-1-mathieu.desnoyers@efficios.com> <CA+55aFzH+4=Aeh_P1ptFn5nVm7yFuEGpxUJ0kNB-sUHVOv8rcw@mail.gmail.com> <1307337131.10790.1530565424717.JavaMail.zimbra@efficios.com> <CA+55aFwuBef8ajmeE-mw=6YHwYOQdnCMir7h2ebWxOzNrSQQFw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CA+55aFwuBef8ajmeE-mw=6YHwYOQdnCMir7h2ebWxOzNrSQQFw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel <linux-kernel@vger.kernel.org>, linux-api <linux-api@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Andy Lutomirski <luto@amacapital.net>, Dave Watson <davejwatson@fb.com>, Paul Turner <pjt@google.com>, Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>, Chris Lameter <cl@linux.com>, Ben Maurer <bmaurer@fb.com>, rostedt <rostedt@goodmis.org>, Josh Triplett <josh@joshtriplett.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Michael Kerrisk <mtk.ma>
List-Id: linux-api@vger.kernel.org

----- On Jul 2, 2018, at 5:20 PM, Linus Torvalds torvalds@linux-foundation.org wrote:

> On Mon, Jul 2, 2018 at 2:03 PM Mathieu Desnoyers
> <mathieu.desnoyers@efficios.com> wrote:
>>
>>         /* Ensure that abort_ip is not in the critical section. */
>>         if (rseq_cs->abort_ip - rseq_cs->start_ip < rseq_cs->post_commit_offset)
>>                 return -EINVAL;
>> ...
>> What underflow issues are you concerned with ?
> 
> That.
> 
> Looking closer, it looks like what you want to do is
> 
>     if (rseq_cs->abort_ip >= rseq_cs->start_ip && rseq_cs->abort_ip <
> rseq_cs->start_ip + rseq_cs->post_commit_offset)
> 
> but you're not actually verifying that the range you're testing is
> even vlid, because "rseq_cs->start_ip + rseq_cs->post_commit_offset"
> could be something invalid that overflowed (or, put another way, the
> subtraction you did on both sides to get the simplified version
> underflowed).
> 
> So to actually get the range check you want, you should check the
> overflow/underflow condition. Maybe it ends up being
> 
>        if (rseq_cs->start_ip + rseq_cs->post_commit_offset < rseq_cs->start_ip)
>                return -EINVAL;
> 
> after which your simplified conditional looks fine.
> 
> But I think you should also do
> 
>        if (rseq_cs->start_ip + rseq_cs->post_commit_offset > TASK_SIZE)
>                return -EINVAL;
> 
> to make sure the range is valid in the first place.

Taking into account your comments, and adding also an extra check for
rseq_cs->start_ip >= TASK_SIZE, and restricting the end of range
rseq_cs->start_ip + rseq_cs->post_commit_offset to exclude TASK_SIZE
(>= rather than >), the resulting function now looks like this:

static int rseq_get_rseq_cs(struct task_struct *t, struct rseq_cs *rseq_cs)
{
        struct rseq_cs __user *urseq_cs;
        unsigned long ptr;
        u32 __user *usig;
        u32 sig;

        if (__get_user(ptr, &t->rseq->rseq_cs))
                return -EINVAL;
        if (check_rseq_cs_padding(t))
                return -EINVAL;
        if (!ptr) {
                memset(rseq_cs, 0, sizeof(*rseq_cs));
                return 0;
        }
        urseq_cs = (struct rseq_cs __user *)ptr;
        if (copy_from_user(rseq_cs, urseq_cs, sizeof(*rseq_cs)) ||
            rseq_cs->start_ip >= TASK_SIZE ||
            rseq_cs->start_ip + rseq_cs->post_commit_offset >= TASK_SIZE ||
            rseq_cs->abort_ip >= TASK_SIZE ||
            rseq_cs->version > 0)
                return -EINVAL;

        /* Check for overflow. */
        if (rseq_cs->start_ip + rseq_cs->post_commit_offset < rseq_cs->start_ip)
                return -EINVAL;
        /* Ensure that abort_ip is not in the critical section. */
        if (rseq_cs->abort_ip - rseq_cs->start_ip < rseq_cs->post_commit_offset)
                return -EINVAL;

        usig = (u32 __user *)(unsigned long)(rseq_cs->abort_ip - sizeof(u32));
        if (get_user(sig, usig))
                return -EINVAL;

        if (current->rseq_sig != sig) {
                printk_ratelimited(KERN_WARNING
                        "Possible attack attempt. Unexpected rseq signature 0x%x, expecting 0x%x (pid=%d, addr=%p).\n",
                        sig, current->rseq_sig, current->pid, usig);
                return -EINVAL;
        }
        return 0;
}

The end of range exclusion with (rseq_cs->start_ip + rseq_cs->post_commit_offset >= TASK_SIZE)
stems from the reasoning that we need a valid user-space instruction _after_ the range, so
having the range end exactly at the very last byte of TASK_SIZE would require to have a
user-space instruction at TASK_SIZE, which is not valid.

Does it capture your intent ?

Thanks,

Mathieu


-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
