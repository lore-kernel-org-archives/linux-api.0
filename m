From: Jann Horn <jann-XZ1E9jl8jIdeoWH0uzbU5w@public.gmane.org>
Subject: [PATCH] Don't allow blocking of signals using sigreturn.
Date: Wed, 11 Mar 2015 18:42:04 +0100
Message-ID: <20150311174204.GA5712@pc.thejh.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Russell King <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Jeff Dike <jdike-OPE4K8JWMJJBDgjK7y7TUQ@public.gmane.org>, Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Will Drewry <wad-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
List-Id: linux-api@vger.kernel.org

This prevents processes running under seccomp, including
SECCOMP_MODE_STRICT, from abusing sigreturn() to block
signals other than SIGKILL intended to kill them.
(For example, someone might decide to use alarm() to
restrict the wall-clock runtime of a seccomp-restricted
process.)

A side effect is that after this change, unblocking
signals in a signal handler is a persistent change, not
a change that can be reversed by returning from the
signal handler.

Is that side effect tolerable, or does the patch have to
be rewritten so that removing signals from the signal
mask in a signal handler stays temporary? (That would
probably make it more complicated.)

Or should I throw this patch away and write a patch
for the prctl() manpage instead that documents that
being able to call sigreturn() implies being able to
effectively call sigprocmask(), at least on some
architectures like X86?

(I hope I got the list of recipients right?)

Signed-off-by: Jann Horn <jann-XZ1E9jl8jIdeoWH0uzbU5w@public.gmane.org>
---
 arch/arm/kernel/signal.c     |  2 +-
 arch/arm64/kernel/signal.c   |  2 +-
 arch/arm64/kernel/signal32.c |  2 +-
 arch/x86/ia32/ia32_signal.c  |  4 ++--
 arch/x86/kernel/signal.c     |  6 +++---
 arch/x86/um/signal.c         |  4 ++--
 include/linux/signal.h       |  1 +
 kernel/signal.c              | 16 ++++++++++++++++
 8 files changed, 27 insertions(+), 10 deletions(-)

diff --git a/arch/arm/kernel/signal.c b/arch/arm/kernel/signal.c
index 023ac90..0659e7e 100644
--- a/arch/arm/kernel/signal.c
+++ b/arch/arm/kernel/signal.c
@@ -147,7 +147,7 @@ static int restore_sigframe(struct pt_regs *regs, struct sigframe __user *sf)
 
 	err = __copy_from_user(&set, &sf->uc.uc_sigmask, sizeof(set));
 	if (err == 0)
-		set_current_blocked(&set);
+		unblock_current(&set);
 
 	__get_user_error(regs->ARM_r0, &sf->uc.uc_mcontext.arm_r0, err);
 	__get_user_error(regs->ARM_r1, &sf->uc.uc_mcontext.arm_r1, err);
diff --git a/arch/arm64/kernel/signal.c b/arch/arm64/kernel/signal.c
index 660ccf9..f2f035a 100644
--- a/arch/arm64/kernel/signal.c
+++ b/arch/arm64/kernel/signal.c
@@ -101,7 +101,7 @@ static int restore_sigframe(struct pt_regs *regs,
 
 	err = __copy_from_user(&set, &sf->uc.uc_sigmask, sizeof(set));
 	if (err == 0)
-		set_current_blocked(&set);
+		unblock_current(&set);
 
 	for (i = 0; i < 31; i++)
 		__get_user_error(regs->regs[i], &sf->uc.uc_mcontext.regs[i],
diff --git a/arch/arm64/kernel/signal32.c b/arch/arm64/kernel/signal32.c
index d26fcd4..28332ed 100644
--- a/arch/arm64/kernel/signal32.c
+++ b/arch/arm64/kernel/signal32.c
@@ -306,7 +306,7 @@ static int compat_restore_sigframe(struct pt_regs *regs,
 	err = get_sigset_t(&set, &sf->uc.uc_sigmask);
 	if (err == 0) {
 		sigdelsetmask(&set, ~_BLOCKABLE);
-		set_current_blocked(&set);
+		unblock_current(&set);
 	}
 
 	__get_user_error(regs->regs[0], &sf->uc.uc_mcontext.arm_r0, err);
diff --git a/arch/x86/ia32/ia32_signal.c b/arch/x86/ia32/ia32_signal.c
index d0165c9..09be79c 100644
--- a/arch/x86/ia32/ia32_signal.c
+++ b/arch/x86/ia32/ia32_signal.c
@@ -222,7 +222,7 @@ asmlinkage long sys32_sigreturn(void)
 				    sizeof(frame->extramask))))
 		goto badframe;
 
-	set_current_blocked(&set);
+	unblock_current(&set);
 
 	if (ia32_restore_sigcontext(regs, &frame->sc, &ax))
 		goto badframe;
@@ -247,7 +247,7 @@ asmlinkage long sys32_rt_sigreturn(void)
 	if (__copy_from_user(&set, &frame->uc.uc_sigmask, sizeof(set)))
 		goto badframe;
 
-	set_current_blocked(&set);
+	unblock_current(&set);
 
 	if (ia32_restore_sigcontext(regs, &frame->uc.uc_mcontext, &ax))
 		goto badframe;
diff --git a/arch/x86/kernel/signal.c b/arch/x86/kernel/signal.c
index e504246..dcc50c51 100644
--- a/arch/x86/kernel/signal.c
+++ b/arch/x86/kernel/signal.c
@@ -551,7 +551,7 @@ asmlinkage unsigned long sys_sigreturn(void)
 				    sizeof(frame->extramask))))
 		goto badframe;
 
-	set_current_blocked(&set);
+	unblock_current(&set);
 
 	if (restore_sigcontext(regs, &frame->sc, &ax))
 		goto badframe;
@@ -577,7 +577,7 @@ asmlinkage long sys_rt_sigreturn(void)
 	if (__copy_from_user(&set, &frame->uc.uc_sigmask, sizeof(set)))
 		goto badframe;
 
-	set_current_blocked(&set);
+	unblock_current(&set);
 
 	if (restore_sigcontext(regs, &frame->uc.uc_mcontext, &ax))
 		goto badframe;
@@ -789,7 +789,7 @@ asmlinkage long sys32_x32_rt_sigreturn(void)
 	if (__copy_from_user(&set, &frame->uc.uc_sigmask, sizeof(set)))
 		goto badframe;
 
-	set_current_blocked(&set);
+	unblock_current(&set);
 
 	if (restore_sigcontext(regs, &frame->uc.uc_mcontext, &ax))
 		goto badframe;
diff --git a/arch/x86/um/signal.c b/arch/x86/um/signal.c
index 0c8c32b..15bb054 100644
--- a/arch/x86/um/signal.c
+++ b/arch/x86/um/signal.c
@@ -476,7 +476,7 @@ long sys_sigreturn(void)
 	    copy_from_user(&set.sig[1], extramask, sig_size))
 		goto segfault;
 
-	set_current_blocked(&set);
+	unblock_current(&set);
 
 	if (copy_sc_from_user(&current->thread.regs, sc))
 		goto segfault;
@@ -584,7 +584,7 @@ long sys_rt_sigreturn(void)
 	if (copy_from_user(&set, &uc->uc_sigmask, sizeof(set)))
 		goto segfault;
 
-	set_current_blocked(&set);
+	unblock_current(&set);
 
 	if (copy_sc_from_user(&current->thread.regs, &uc->uc_mcontext))
 		goto segfault;
diff --git a/include/linux/signal.h b/include/linux/signal.h
index ab1e039..371dd19 100644
--- a/include/linux/signal.h
+++ b/include/linux/signal.h
@@ -238,6 +238,7 @@ extern int do_sigtimedwait(const sigset_t *, siginfo_t *,
 extern int sigprocmask(int, sigset_t *, sigset_t *);
 extern void set_current_blocked(sigset_t *);
 extern void __set_current_blocked(const sigset_t *);
+extern void unblock_current(const sigset_t *);
 extern int show_unhandled_signals;
 extern int sigsuspend(sigset_t *);
 
diff --git a/kernel/signal.c b/kernel/signal.c
index a390499..48be2ca 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -2544,6 +2544,22 @@ void __set_current_blocked(const sigset_t *newset)
 	spin_unlock_irq(&tsk->sighand->siglock);
 }
 
+/**
+ * unblock_current - change current->blocked mask, but only allow
+ * unblocking of signals.
+ * @newset: new mask
+ *
+ * This method should be used in sigreturn implementations to prevent
+ * seccomp-isolated processes from blocking signals using sigreturn.
+ */
+void unblock_current(const sigset_t *newset)
+{
+	spin_lock_irq(&current->sighand->siglock);
+	sigandsets(&current->blocked, &current->blocked, newset);
+	recalc_sigpending();
+	spin_unlock_irq(&current->sighand->siglock);
+}
+
 /*
  * This is also useful for kernel threads that want to temporarily
  * (or permanently) block certain signals.
-- 
2.1.4
