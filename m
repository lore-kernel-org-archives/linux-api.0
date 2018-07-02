From: Andy Lutomirski <luto@kernel.org>
Subject: Re: [RFC PATCH for 4.18 1/2] rseq: validate rseq_cs fields are < TASK_SIZE
Date: Mon, 2 Jul 2018 13:12:51 -0700
Message-ID: <CALCETrWps4Bvd_hGviEZ+60nQFr5ovp2A0+afDWg-QOHB9x7cA@mail.gmail.com>
References: <20180628162359.9054-1-mathieu.desnoyers@efficios.com>
 <CA+55aFwJWxsE_LL=-8WgB7uH_mYeMSu=boWF4N5KdOW673g4hA@mail.gmail.com>
 <247789350.9741.1530288432573.JavaMail.zimbra@efficios.com>
 <CA+55aFz8KyVqFsVnp-6g+thz7vmm5nK_FSdRTPSks7gsNVNRdQ@mail.gmail.com>
 <184287091.10022.1530301738384.JavaMail.zimbra@efficios.com>
 <CALCETrXqjrCoHX1KyL0iKGBaAZSGJb1cVdNN1gNigJ8DW9LF8w@mail.gmail.com>
 <1527399163.10673.1530541966296.JavaMail.zimbra@efficios.com>
 <CALCETrVeu_V-3K8OfKv9QixrWBJs+q866yb=e96sC76SS4hxYg@mail.gmail.com>
 <84003252.10754.1530558015813.JavaMail.zimbra@efficios.com>
 <CALCETrVMhU8SrZBXOXxJerrZpQ71A_f_cRBCU=Lmj_KPV0+rRA@mail.gmail.com> <CA+55aFy2rxnLhbqGtz0wxW_u=x_A1zHZBNP8ZC5P12_AHyb3PA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CA+55aFy2rxnLhbqGtz0wxW_u=x_A1zHZBNP8ZC5P12_AHyb3PA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Andrew Lutomirski <luto@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>, Paul McKenney <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Dave Watson <davejwatson@fb.com>, Paul Turner <pjt@google.com>, Andrew Morton <akpm@linux-foundation.org>, Russell King - ARM Linux <linux@arm.linux.org.uk>, Ingo Molnar <mingo@redhat.com>, Peter Anvin <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>, Christoph Lameter <cl@linux.com>, Ben Maurer <bmaurer@fb.com>, Steven Rostedt <rostedt@goodmis.org>, Josh Triplett <josh@joshtriplett.org>, Catalin Marinas <catalin.marinas@>
List-Id: linux-api@vger.kernel.org

On Mon, Jul 2, 2018 at 12:31 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Mon, Jul 2, 2018 at 12:02 PM Andy Lutomirski <luto@amacapital.net> wrote:
>>
>> Works for me.  Linus, any objection?
>
> I think the 4.19 stage may be overkill, but I don't hate it, so no
> real objections.
>
> If the main reason for this is that we silently clear the upper bits
> when returning to compat mode, I actually think that a better fix
> would be to just fix that. We shouldn't silently ignore bogus data in
> the return path.
>
> But I don't care enough, I think.

Like this:

diff --git a/arch/x86/entry/common.c b/arch/x86/entry/common.c
index 3b2490b81918..ec40223c8856 100644
--- a/arch/x86/entry/common.c
+++ b/arch/x86/entry/common.c
@@ -170,6 +170,26 @@ static void exit_to_usermode_loop(struct pt_regs
*regs, u32 cached_flags)
         if (cached_flags & _TIF_USER_RETURN_NOTIFY)
             fire_user_return_notifiers();

+        if (unlikely(!user_64bit_mode(regs) &&
+                 (regs->ip & 0xffffffff00000000ull))) {
+            siginfo_t info;
+            struct task_struct *tsk = current;
+
+            /* I haven't thought about this *that* hard. */
+            clear_siginfo(&info);
+            tsk->thread.cr2    = regs->ip;
+            tsk->thread.trap_nr = X86_TRAP_PF;
+            tsk->thread.error_code = X86_PF_USER | X86_PF_INSTR;
+            info.si_signo = SIGSEGV;
+            info.si_errno = 0;
+            info.si_code = SEGV_MAPERR;
+            info.si_addr = (void __user *)regs->ip;
+            /* si_addr_lsb? */
+            force_sig_info(SIGSEGV, &info, tsk);
+
+            /* And we'll go through the loop again. */
+        }
+
         /* Disable IRQs and retry */
         local_irq_disable();

It's whitespace damaged and barely tested, but it seems to at least
not be completely busted.  I don't really love doing this, though.
