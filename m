From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC PATCH for 4.18 1/2] rseq: validate rseq_cs fields are < TASK_SIZE
Date: Mon, 2 Jul 2018 13:22:49 -0700
Message-ID: <CA+55aFwvsNY7eLm3OevWQvijPN_HQA4KgfZ5k-RTVPjD8MKppg@mail.gmail.com>
References: <20180628162359.9054-1-mathieu.desnoyers@efficios.com>
 <CA+55aFwJWxsE_LL=-8WgB7uH_mYeMSu=boWF4N5KdOW673g4hA@mail.gmail.com>
 <247789350.9741.1530288432573.JavaMail.zimbra@efficios.com>
 <CA+55aFz8KyVqFsVnp-6g+thz7vmm5nK_FSdRTPSks7gsNVNRdQ@mail.gmail.com>
 <184287091.10022.1530301738384.JavaMail.zimbra@efficios.com>
 <CALCETrXqjrCoHX1KyL0iKGBaAZSGJb1cVdNN1gNigJ8DW9LF8w@mail.gmail.com>
 <1527399163.10673.1530541966296.JavaMail.zimbra@efficios.com>
 <CALCETrVeu_V-3K8OfKv9QixrWBJs+q866yb=e96sC76SS4hxYg@mail.gmail.com>
 <84003252.10754.1530558015813.JavaMail.zimbra@efficios.com>
 <CALCETrVMhU8SrZBXOXxJerrZpQ71A_f_cRBCU=Lmj_KPV0+rRA@mail.gmail.com>
 <CA+55aFy2rxnLhbqGtz0wxW_u=x_A1zHZBNP8ZC5P12_AHyb3PA@mail.gmail.com> <CALCETrWps4Bvd_hGviEZ+60nQFr5ovp2A0+afDWg-QOHB9x7cA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CALCETrWps4Bvd_hGviEZ+60nQFr5ovp2A0+afDWg-QOHB9x7cA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Lutomirski <luto@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Thomas Gleixner <tglx@linutronix.de>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>, Paul McKenney <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Dave Watson <davejwatson@fb.com>, Paul Turner <pjt@google.com>, Andrew Morton <akpm@linux-foundation.org>, Russell King - ARM Linux <linux@arm.linux.org.uk>, Ingo Molnar <mingo@redhat.com>, Peter Anvin <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>, Christoph Lameter <cl@linux.com>, Ben Maurer <bmaurer@fb.com>, Steven Rostedt <rostedt@goodmis.org>, Josh Triplett <josh@joshtriplett.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@ar>
List-Id: linux-api@vger.kernel.org

On Mon, Jul 2, 2018 at 1:13 PM Andy Lutomirski <luto@kernel.org> wrote:
>
> Like this:
>
> diff --git a/arch/x86/entry/common.c b/arch/x86/entry/common.c
> index 3b2490b81918..ec40223c8856 100644
> --- a/arch/x86/entry/common.c
> +++ b/arch/x86/entry/common.c
> @@ -170,6 +170,26 @@ static void exit_to_usermode_loop(struct pt_regs
> *regs, u32 cached_flags)
>          if (cached_flags & _TIF_USER_RETURN_NOTIFY)
>              fire_user_return_notifiers();
>
> +        if (unlikely(!user_64bit_mode(regs) &&
> +                 (regs->ip & 0xffffffff00000000ull))) {

I'd be afraid that code generation is atrocious. So more something like this:

    static noinline send_sigsegv(..) { }

    ...
    if (unlikely(!user_64bit_mode(regs)) {
        if (unlikely(*(1+(u32 *)&regs->ip)))
            send_sigsegv(tsk);

to make sure it doesn't do crazy big constants in the normal path, and
doesn't allocate silly stack frames.

But as mentioned, I'm not entirely convinced this is worth it. But I
wasn't sure it's worth it for rseq.

So basically, *if* we do these kinds of checks, I'd personally rather
do a *generic* "we don't return to garbage 64-bit values in compat
mode" than have special case code that is only for rseq and is truly
irrelevant to all normal cases.

The generic case might even be worth a test-case. And if we do that,
we should probably check that we don't do something odd like
sign-extending the %rip value we load from stack for signal return
etc, that just happens to work because nobody cared about the upper
bits.

So there's a lot of these kinds of small details that are of
questionable importance, but might in theory be worth it.

                  Linus
