From: Vincent Chen <deanbo422@gmail.com>
Subject: Re: [REVIEW][PATCH 05/17] signal/nds32: Use force_sig(SIGILL) in do_revisn
Date: Wed, 25 Apr 2018 20:10:22 +0800
Message-ID: <CAJsyPhyDeafwUQxXgnZ9Rfj6nwYrU_Kgyfv8DQ2q0BkwW25BBw@mail.gmail.com>
References: <878t9ilmhv.fsf@xmission.com> <20180420010408.24438-5-ebiederm@xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180420010408.24438-5-ebiederm@xmission.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-arch <linux-arch@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-api@vger.kernel.org, Vincent Chen <vincentc@andestech.com>, Greentime Hu <greentime@andestech.com>, Arnd Bergmann <arnd@arndb.de>
List-Id: linux-api@vger.kernel.org

2018-04-20 9:03 GMT+08:00 Eric W. Biederman <ebiederm@xmission.com>:
> As originally committed do_revisn would deliver a siginfo for SIGILL
> with an si_code composed of random stack contents.  That makes no
> sense and is not something userspace can depend on.  So simplify
> the code and just use "force_sig(SIG_ILL, current)" instead.
>
> Fixes: 2923f5ea7738 ("nds32: Exception handling")
> Cc: Vincent Chen <vincentc@andestech.com>
> Cc: Greentime Hu <greentime@andestech.com>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
> ---
>  arch/nds32/kernel/traps.c | 5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)
>
> diff --git a/arch/nds32/kernel/traps.c b/arch/nds32/kernel/traps.c
> index 65961bf91d64..8e9a5b1f6234 100644
> --- a/arch/nds32/kernel/traps.c
> +++ b/arch/nds32/kernel/traps.c
> @@ -356,14 +356,11 @@ void do_dispatch_tlb_misc(unsigned long entry, unsigned long addr,
>
>  void do_revinsn(struct pt_regs *regs)
>  {
> -       siginfo_t si;
>         pr_emerg("Reserved Instruction\n");
>         show_regs(regs);
>         if (!user_mode(regs))
>                 do_exit(SIGILL);
> -       si.si_signo = SIGILL;
> -       si.si_errno = 0;
> -       force_sig_info(SIGILL, &si, current);
> +       force_sig(SIGILL, current);
>  }
>
>  #ifdef CONFIG_ALIGNMENT_TRAP
> --
> 2.14.1
>

You are right we do not store any valuable information in sigingo_t now.
However, We hope more information can be recorded by force_sig_fault()
as below instead of calling force_sig() directly.

-        force_sig(SIGILL, current);
+        force_sig_fault(SIGILL, ILL_ILLTRP,
+                        (void __user *)instruction_pointer(regs), current);

Thanks

Vincent Chen
