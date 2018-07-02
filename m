From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC PATCH for 4.18 1/2] rseq: use __u64 for rseq_cs fields,
 validate abort_ip < TASK_SIZE
Date: Mon, 2 Jul 2018 14:20:16 -0700
Message-ID: <CA+55aFwuBef8ajmeE-mw=6YHwYOQdnCMir7h2ebWxOzNrSQQFw@mail.gmail.com>
References: <20180702204058.819-1-mathieu.desnoyers@efficios.com>
 <CA+55aFzH+4=Aeh_P1ptFn5nVm7yFuEGpxUJ0kNB-sUHVOv8rcw@mail.gmail.com> <1307337131.10790.1530565424717.JavaMail.zimbra@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1307337131.10790.1530565424717.JavaMail.zimbra@efficios.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>, Paul McKenney <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Andy Lutomirski <luto@amacapital.net>, Dave Watson <davejwatson@fb.com>, Paul Turner <pjt@google.com>, Andrew Morton <akpm@linux-foundation.org>, Russell King - ARM Linux <linux@arm.linux.org.uk>, Ingo Molnar <mingo@redhat.com>, Peter Anvin <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>, Christoph Lameter <cl@linux.com>, Ben Maurer <bmaurer@fb.com>, Steven Rostedt <rostedt@goodmis.org>, Josh Triplett <josh@joshtriplett.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>
List-Id: linux-api@vger.kernel.org

On Mon, Jul 2, 2018 at 2:03 PM Mathieu Desnoyers
<mathieu.desnoyers@efficios.com> wrote:
>
>         /* Ensure that abort_ip is not in the critical section. */
>         if (rseq_cs->abort_ip - rseq_cs->start_ip < rseq_cs->post_commit_offset)
>                 return -EINVAL;
> ...
> What underflow issues are you concerned with ?

That.

Looking closer, it looks like what you want to do is

     if (rseq_cs->abort_ip >= rseq_cs->start_ip && rseq_cs->abort_ip <
rseq_cs->start_ip + rseq_cs->post_commit_offset)

but you're not actually verifying that the range you're testing is
even vlid, because "rseq_cs->start_ip + rseq_cs->post_commit_offset"
could be something invalid that overflowed (or, put another way, the
subtraction you did on both sides to get the simplified version
underflowed).

So to actually get the range check you want, you should check the
overflow/underflow condition. Maybe it ends up being

        if (rseq_cs->start_ip + rseq_cs->post_commit_offset < rseq_cs->start_ip)
                return -EINVAL;

after which your simplified conditional looks fine.

But I think you should also do

        if (rseq_cs->start_ip + rseq_cs->post_commit_offset > TASK_SIZE)
                return -EINVAL;

to make sure the range is valid in the first place.

             Linus
