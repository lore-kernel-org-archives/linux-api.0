From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC PATCH for 4.18 1/2] rseq: use __u64 for rseq_cs fields,
 validate abort_ip < TASK_SIZE
Date: Mon, 2 Jul 2018 13:52:36 -0700
Message-ID: <CA+55aFzH+4=Aeh_P1ptFn5nVm7yFuEGpxUJ0kNB-sUHVOv8rcw@mail.gmail.com>
References: <20180702204058.819-1-mathieu.desnoyers@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180702204058.819-1-mathieu.desnoyers@efficios.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>, Paul McKenney <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Andy Lutomirski <luto@amacapital.net>, Dave Watson <davejwatson@fb.com>, Paul Turner <pjt@google.com>, Andrew Morton <akpm@linux-foundation.org>, Russell King - ARM Linux <linux@arm.linux.org.uk>, Ingo Molnar <mingo@redhat.com>, Peter Anvin <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>, Christoph Lameter <cl@linux.com>, Ben Maurer <bmaurer@fb.com>, Steven Rostedt <rostedt@goodmis.org>, Josh Triplett <josh@joshtriplett.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>
List-Id: linux-api@vger.kernel.org

On Mon, Jul 2, 2018 at 1:41 PM Mathieu Desnoyers
<mathieu.desnoyers@efficios.com> wrote:
>
> -       if (copy_from_user(rseq_cs, urseq_cs, sizeof(*rseq_cs)))
> +       if (copy_from_user(rseq_cs, urseq_cs, sizeof(*rseq_cs)) ||
> +           rseq_cs->abort_ip >= TASK_SIZE)
>                 return -EFAULT;

I think the abort_ip check should have the same error value as the
other sanity checks, ie just be of this format:

>         if (rseq_cs->version > 0)
>                 return -EINVAL;

also, I think you should check start_ip to be consistent. You kind of
accidentally do it with the check for

        if (rseq_cs->abort_ip - rseq_cs->start_ip - rseq_cs->post_commit_offset)

but honestly, that has underflow issues already, so I think you want
to basically make the check be

        if (rseq_cs->abort_ip >= TASK_SIZE)
                return -EINVAL;

        if (rseq_cs->start_ip >= rseq_cs->abort_ip)
                return -EINVAL;

which takes care of checkint  start_ip, and also the underflow for the
post_commit_offset check.

If somebody is depending on negative offsets, then that
post_commit_offset logic is already wrong.

> +       usig = (u32 __user *)(unsigned long)(rseq_cs->abort_ip - sizeof(u32));
>         ret = get_user(sig, usig);

That can underflow too, but I guess we can just rely on get_user()
getting it right.

               Linus
