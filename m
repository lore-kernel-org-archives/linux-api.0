From: Li RongQing <roy.qing.li-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] audit.h: remove the macro AUDIT_ARCH_ARMEB definition
Date: Wed, 25 Mar 2015 08:01:12 +0800
Message-ID: <CAJFZqHzxXyuzi7Z9WawYKfFnTMfYfsRL0Qnt276p_t-AV9GB2A@mail.gmail.com>
References: <1426827329-27976-1-git-send-email-roy.qing.li@gmail.com>
	<CAHC9VhR5VcaCtLG9hdVS2gZRWxVmdnpbK+fJwm6wCA8qyLebUQ@mail.gmail.com>
	<CAJFZqHxdPEhX+9z-FYUMvTF_6LVgK=gOetq0zT4UTZSgUGRqCQ@mail.gmail.com>
	<CAJFZqHxfq0DSjKn-uqhT+pAeJ9u8ym2Mr=wsqvPyX7sCicPGZA@mail.gmail.com>
	<CAHC9VhTbxf_u2FXkcdqofkhywbgrrjjUo_W7yqWXFm=wSJBOAQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAHC9VhTbxf_u2FXkcdqofkhywbgrrjjUo_W7yqWXFm=wSJBOAQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Paul Moore <paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org>
Cc: Eric Paris <eparis-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-audit-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Wed, Mar 25, 2015 at 5:16 AM, Paul Moore <paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org> wrote:
> [NOTE: Adding the linux-arm folks to this thread just in case they are
> interested.]
>
> I'm not an ARM expert, but the kernel #define for AUDIT_ARCH_ARMEB
> (below) seems reasonable to me based on the other audit machine
> definitions.  There is clearly a mismatch between the kernel and the
> audit userspace, but I wonder if the issue should be addressed in the
> userspace tools.  Further, you mention kernel 3.14, what happens with
> kernel 3.19 and the most recent audit userspace tools?
>
>   > grep "AUDIT_ARCH_ARMEB" include/uapi/linux/audit.h
>   #define AUDIT_ARCH_ARMEB        (EM_ARM)


1.
if no the below commit, audit-2.3.2 is working;
but after the below commit, audit-2.3.2 is not working.

commit 2f978366984a418f38fcf44137be1fbc5a89cfd9
Author: Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>
Date:   Fri May 4 17:53:52 2012 +0100

    ARM: 7412/1: audit: use only AUDIT_ARCH_ARM regardless of endianness

    The machine endianness has no direct correspondence to the syscall ABI,
    so use only AUDIT_ARCH_ARM when identifying the ABI to the audit tools
    in userspace.

    Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
    Signed-off-by: Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>
    Signed-off-by: Russell King <rmk+kernel-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>

diff --git a/arch/arm/kernel/ptrace.c b/arch/arm/kernel/ptrace.c
index d8dbe9c..9650c14 100644
--- a/arch/arm/kernel/ptrace.c
+++ b/arch/arm/kernel/ptrace.c
@@ -906,12 +906,6 @@ long arch_ptrace(struct task_struct *child, long request,
        return ret;
 }

-#ifdef __ARMEB__
-#define AUDIT_ARCH_NR AUDIT_ARCH_ARMEB
-#else
-#define AUDIT_ARCH_NR AUDIT_ARCH_ARM
-#endif
-
 asmlinkage int syscall_trace(int why, struct pt_regs *regs, int scno)
 {
        unsigned long ip;
@@ -919,7 +913,7 @@ asmlinkage int syscall_trace(int why, struct
pt_regs *regs, int scno)
        if (why)
                audit_syscall_exit(regs);
        else
-               audit_syscall_entry(AUDIT_ARCH_NR, scno, regs->ARM_r0,
+               audit_syscall_entry(AUDIT_ARCH_ARM, scno, regs->ARM_r0,
                                    regs->ARM_r1, regs->ARM_r2, regs->ARM_r3);

        if (!test_thread_flag(TIF_SYSCALL_TRACE))


2.

The latest audit has the changeset of 931 [Improve ARM and AARCH64 support],
so audit can work again.


-Roy
