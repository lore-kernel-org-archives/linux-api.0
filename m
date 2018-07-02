From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC PATCH for 4.18] rseq: use __u64 for rseq_cs fields, validate
 user inputs
Date: Mon, 2 Jul 2018 15:45:01 -0700
Message-ID: <CA+55aFxrX+wRoe+5HDaTrRXg1K-Qpks4jJ9Buc_OevoG8hoGFw@mail.gmail.com>
References: <20180702223143.4663-1-mathieu.desnoyers@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180702223143.4663-1-mathieu.desnoyers@efficios.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>, Paul McKenney <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Andy Lutomirski <luto@amacapital.net>, Dave Watson <davejwatson@fb.com>, Paul Turner <pjt@google.com>, Andrew Morton <akpm@linux-foundation.org>, Russell King - ARM Linux <linux@arm.linux.org.uk>, Ingo Molnar <mingo@redhat.com>, Peter Anvin <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>, Christoph Lameter <cl@linux.com>, Ben Maurer <bmaurer@fb.com>, Steven Rostedt <rostedt@goodmis.org>, Josh Triplett <josh@joshtriplett.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>
List-Id: linux-api@vger.kernel.org

On Mon, Jul 2, 2018 at 3:31 PM Mathieu Desnoyers
<mathieu.desnoyers@efficios.com> wrote:
>
> Change the rseq ABI so rseq_cs start_ip, post_commit_offset and abort_ip
> fields are seen as 64-bit fields by both 32-bit and 64-bit kernels rather
> that ignoring the 32 upper bits on 32-bit kernels. This ensures we have a
> consistent behavior for a 32-bit binary executed on 32-bit kernels and in
> compat mode on 64-bit kernels.

Actually, now that I see this again, I react to:


> +static int check_rseq_cs_padding(struct task_struct *t)
> +{
> +       u32 pad;
> +       int ret;
> +
> +       ret = __get_user(pad, &t->rseq->rseq_cs_padding);
> +       if (ret)
> +               return ret;
> +       if (pad)
> +               return -EINVAL;
> +       return 0;
> +}

This is all wrong.

Just make "rseq_cs" be an __u64" too. That will clean up everything,
and user space will have a much easier time filling it in too, since
it's just one field. Instead of having to remember about the "let's
fill in padding for 32-bit cases".

Then the rseq_get_rseq_cs() will be

        __u64 rseq_cs;

        ret = get_user(rseq_cs, &t->rseq->rseq_cs);
        if (ret)
                return ret;
        ptr = (void *)rseq_cs;
        if (rseq_cs != (unsigned long)ptr)
                return -EINVAL;

and it's all good, no #ifdef's etc needed.

Hmm?

Sorry for the bike-shedding, but this is now the last remaining user
of that LINUX_FIELD_u32_u64, so let's just get rid of it entirely, ok?

Then we can also get rid of that silly uapi/linux/types_32_64.h header
file entirely.

That would be *lovely*. Simpler code, simpler and less error-prone
interfaces, and one less specialized header file.

              Linus
