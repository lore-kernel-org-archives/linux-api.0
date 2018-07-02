From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC PATCH for 4.18 1/2] rseq: use __u64 for rseq_cs fields,
 validate abort_ip < TASK_SIZE
Date: Mon, 2 Jul 2018 15:08:42 -0700
Message-ID: <CA+55aFz5cq5uP7VFwAmo3BimHyMdu_FQnbxZG3i66_qZXCkjNg@mail.gmail.com>
References: <20180702204058.819-1-mathieu.desnoyers@efficios.com>
 <CA+55aFzH+4=Aeh_P1ptFn5nVm7yFuEGpxUJ0kNB-sUHVOv8rcw@mail.gmail.com>
 <1307337131.10790.1530565424717.JavaMail.zimbra@efficios.com>
 <CA+55aFwuBef8ajmeE-mw=6YHwYOQdnCMir7h2ebWxOzNrSQQFw@mail.gmail.com> <522686232.10814.1530569002544.JavaMail.zimbra@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <522686232.10814.1530569002544.JavaMail.zimbra@efficios.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>, Paul McKenney <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Andy Lutomirski <luto@amacapital.net>, Dave Watson <davejwatson@fb.com>, Paul Turner <pjt@google.com>, Andrew Morton <akpm@linux-foundation.org>, Russell King - ARM Linux <linux@arm.linux.org.uk>, Ingo Molnar <mingo@redhat.com>, Peter Anvin <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>, Christoph Lameter <cl@linux.com>, Ben Maurer <bmaurer@fb.com>, Steven Rostedt <rostedt@goodmis.org>, Josh Triplett <josh@joshtriplett.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>
List-Id: linux-api@vger.kernel.org

On Mon, Jul 2, 2018 at 3:03 PM Mathieu Desnoyers
<mathieu.desnoyers@efficios.com> wrote:
>
>         if (__get_user(ptr, &t->rseq->rseq_cs))
>                 return -EINVAL;
>         if (check_rseq_cs_padding(t))
>                 return -EINVAL;

Small nit.

I think the _actual_ user access faults should return -EFAULT, and
then the *validation* checks should return -EINVAL.

So when the "copy_from_user()" fails, that's -EFAULT, but when you
have (rseq_cs->start_ip >= TASK_SIZE), that's -EINVAL.

That said, nothing actually cares or exposes the error number, I
think. Afaik, all the callers just check "did it work" or not.

So this is more a "let's be consistent" than anything that matters.

             Linus
