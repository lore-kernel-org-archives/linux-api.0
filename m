From: Yu-cheng Yu <yu-cheng.yu@intel.com>
Subject: Re: [RFC PATCH v3 06/24] x86/cet: Control protection exception
 handler
Date: Fri, 31 Aug 2018 09:20:18 -0700
Message-ID: <1535732418.3789.7.camel@intel.com>
References: <20180830143904.3168-1-yu-cheng.yu@intel.com>
         <20180830143904.3168-7-yu-cheng.yu@intel.com>
         <CAG48ez0jvsDw189=YoCCa8tmJUENeUd_ypcP5bYJ+eLMPCYCOQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAG48ez0jvsDw189=YoCCa8tmJUENeUd_ypcP5bYJ+eLMPCYCOQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jann Horn <jannh@google.com>
Cc: the arch/x86 maintainers <x86@kernel.org>, "H . Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, kernel list <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org, Linux-MM <linux-mm@kvack.org>, linux-arch <linux-arch@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>, Andy Lutomirski <luto@amacapital.net>, Balbir Singh <bsingharora@gmail.com>, Cyrill Gorcunov <gorcunov@gmail.com>, Dave Hansen <dave.hansen@linux.intel.com>, Florian Weimer <fweimer@redhat.com>, hjl.tools@gmail.com, Jonathan Corbet <corbet@lwn.net>, keescook@chromium.org, Mike Kravetz <mike.kravetz@oracle.com>, Nadav Amit <nadav.amit@gmail.com>, Oleg Nesterov <oleg@redhat.com>, Pavel Machek <pave>
List-Id: linux-api@vger.kernel.org

On Fri, 2018-08-31 at 17:01 +0200, Jann Horn wrote:

> Is there a reason why all the code in this patch isn't #ifdef'ed
> away
> on builds that don't support CET? It looks like the CET handler is
> hooked up to the IDT conditionally, but the handler code is always
> built?

Yes, in idt.c, it should have been:

#ifdef CONFIG_X86_64
	INTG(X86_TRAP_CP,		control_protection),
#endif

I will fix it.

> > +dotraplinkage void
> > +do_control_protection(struct pt_regs *regs, long error_code)
> > +{
> > +       struct task_struct *tsk;
> > +
> > +       RCU_LOCKDEP_WARN(!rcu_is_watching(), "entry code didn't
> > wake RCU");
> > +       if (notify_die(DIE_TRAP, "control protection fault", regs,
> > +                      error_code, X86_TRAP_CP, SIGSEGV) ==
> > NOTIFY_STOP)
> > +               return;
> > +       cond_local_irq_enable(regs);
> > +
> > +       if (!user_mode(regs))
> > +               die("kernel control protection fault", regs,
> > error_code);
> > +
> > +       if (!static_cpu_has(X86_FEATURE_SHSTK) &&
> > +           !static_cpu_has(X86_FEATURE_IBT))
> > +               WARN_ONCE(1, "CET is disabled but got control "
> > +                         "protection fault\n");
> > +
> > +       tsk = current;
> > +       tsk->thread.error_code = error_code;
> > +       tsk->thread.trap_nr = X86_TRAP_CP;
> > +
> > +       if (show_unhandled_signals && unhandled_signal(tsk,
> > SIGSEGV) &&
> > +           printk_ratelimit()) {
> > +               unsigned int max_err;
> > +
> > +               max_err = ARRAY_SIZE(control_protection_err) - 1;
> > +               if ((error_code < 0) || (error_code > max_err))
> > +                       error_code = 0;
> > +               pr_info("%s[%d] control protection ip:%lx sp:%lx
> > error:%lx(%s)",
> > +                       tsk->comm, task_pid_nr(tsk),
> > +                       regs->ip, regs->sp, error_code,
> > +                       control_protection_err[error_code]);
> > +               print_vma_addr(" in ", regs->ip);
> Shouldn't this be using KERN_CONT, like other callers of
> print_vma_addr(), to get the desired output?

I will change it.
