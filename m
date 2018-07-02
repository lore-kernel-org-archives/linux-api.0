From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [RFC PATCH for 4.18 1/2] rseq: use __u64 for rseq_cs fields,
 validate abort_ip < TASK_SIZE
Date: Mon, 2 Jul 2018 18:16:45 -0400 (EDT)
Message-ID: <1051917568.10818.1530569805468.JavaMail.zimbra@efficios.com>
References: <20180702204058.819-1-mathieu.desnoyers@efficios.com> <CA+55aFzH+4=Aeh_P1ptFn5nVm7yFuEGpxUJ0kNB-sUHVOv8rcw@mail.gmail.com> <1307337131.10790.1530565424717.JavaMail.zimbra@efficios.com> <CA+55aFwuBef8ajmeE-mw=6YHwYOQdnCMir7h2ebWxOzNrSQQFw@mail.gmail.com> <522686232.10814.1530569002544.JavaMail.zimbra@efficios.com> <CA+55aFz5cq5uP7VFwAmo3BimHyMdu_FQnbxZG3i66_qZXCkjNg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CA+55aFz5cq5uP7VFwAmo3BimHyMdu_FQnbxZG3i66_qZXCkjNg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel <linux-kernel@vger.kernel.org>, linux-api <linux-api@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Andy Lutomirski <luto@amacapital.net>, Dave Watson <davejwatson@fb.com>, Paul Turner <pjt@google.com>, Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>, Chris Lameter <cl@linux.com>, Ben Maurer <bmaurer@fb.com>, rostedt <rostedt@goodmis.org>, Josh Triplett <josh@joshtriplett.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Michael Kerrisk <mtk.ma>
List-Id: linux-api@vger.kernel.org

----- On Jul 2, 2018, at 6:08 PM, Linus Torvalds torvalds@linux-foundation.org wrote:

> On Mon, Jul 2, 2018 at 3:03 PM Mathieu Desnoyers
> <mathieu.desnoyers@efficios.com> wrote:
>>
>>         if (__get_user(ptr, &t->rseq->rseq_cs))
>>                 return -EINVAL;
>>         if (check_rseq_cs_padding(t))
>>                 return -EINVAL;
> 
> Small nit.
> 
> I think the _actual_ user access faults should return -EFAULT, and
> then the *validation* checks should return -EINVAL.
> 
> So when the "copy_from_user()" fails, that's -EFAULT, but when you
> have (rseq_cs->start_ip >= TASK_SIZE), that's -EINVAL.

Fair enough.

> 
> That said, nothing actually cares or exposes the error number, I
> think. Afaik, all the callers just check "did it work" or not.

Indeed, it's a static function and callers just check for zero/nonzero.

> 
> So this is more a "let's be consistent" than anything that matters.

Allright, here is the function updated accordingly:

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
        if (check_rseq_cs_padding(t))
                return -EINVAL;
        if (!ptr) {
                memset(rseq_cs, 0, sizeof(*rseq_cs));
                return 0;
        }
        urseq_cs = (struct rseq_cs __user *)ptr;
        if (copy_from_user(rseq_cs, urseq_cs, sizeof(*rseq_cs)))
                return -EFAULT;

        if (rseq_cs->start_ip >= TASK_SIZE ||
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
        ret = get_user(sig, usig);
        if (ret)
                return ret;

        if (current->rseq_sig != sig) {
                printk_ratelimited(KERN_WARNING
                        "Possible attack attempt. Unexpected rseq signature 0x%x, expecting 0x%x (pid=%d, addr=%p).\n",
                        sig, current->rseq_sig, current->pid, usig);
                return -EINVAL;
        }
        return 0;
}

Thanks for the feedback!

Mathieu


-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
