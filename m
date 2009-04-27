From: arnd-r2nGTMty4D4@public.gmane.org
Subject: [RFC 16/17] microblaze: clean up signal handling
Date: Mon, 27 Apr 2009 17:01:30 +0200
Message-ID: <20090427150319.897263693@arndb.de>
References: <20090427142010.587518220@arndb.de>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline; filename=microblaze/0027-microblaze-clean-up-signal-handling.patch
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: john.williams-g5w7nrANp4BDPfheJLI6IQ@public.gmane.org, monstr-pSz03upnqPeHXe+LvDLADg@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, liqin.chen-+XGAvkf1AAHby3iVrkZq2A@public.gmane.org, Sam Ravnborg <sam-uyr5N9Q2VtJg9hUCZPvPmw@public.gmane.org>, Remis Lima Baima <remis.developer-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org>
List-Id: linux-api@vger.kernel.org

When legacy signal handling is disabled, the
arch/microblaze/kernel/signal.c implementation can
be much simpler, as most of it is handled generically
from kernel/signal.c.

This is also a prerequisite for using the generic
asm/unistd.h, which does not provide __NR_sigreturn,
because this macro is referenced by the current signal.c
implementation.

Signed-off-by: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
---
 arch/microblaze/include/asm/signal.h      |  166 	1 +	165 -	0 !
 arch/microblaze/include/asm/syscalls.h    |   13 	4 +	9 -	0 !
 arch/microblaze/include/asm/thread_info.h |   11 	11 +	0 -	0 !
 arch/microblaze/include/asm/unistd.h      |    2 	1 +	1 -	0 !
 arch/microblaze/kernel/signal.c           |  250 	38 +	212 -	0 !
 5 files changed, 55 insertions(+), 387 deletions(-)

Index: linux-2.6/arch/microblaze/include/asm/signal.h
===================================================================
--- linux-2.6.orig/arch/microblaze/include/asm/signal.h
+++ linux-2.6/arch/microblaze/include/asm/signal.h
@@ -1,165 +1 @@
-/*
- * Copyright (C) 2006 Atmark Techno, Inc.
- *	Yasushi SHOJI <yashi-9u97MdVgWv6RbxiC3EKwHAC/G2K4zDHf@public.gmane.org>
- *	Tetsuya OHKAWA <tetsuya-9u97MdVgWv6RbxiC3EKwHAC/G2K4zDHf@public.gmane.org>
- *
- * This file is subject to the terms and conditions of the GNU General Public
- * License. See the file "COPYING" in the main directory of this archive
- * for more details.
- */
-
-#ifndef _ASM_MICROBLAZE_SIGNAL_H
-#define _ASM_MICROBLAZE_SIGNAL_H
-
-#define SIGHUP		1
-#define SIGINT		2
-#define SIGQUIT		3
-#define SIGILL		4
-#define SIGTRAP		5
-#define SIGABRT		6
-#define SIGIOT		6
-#define SIGBUS		7
-#define SIGFPE		8
-#define SIGKILL		9
-#define SIGUSR1		10
-#define SIGSEGV		11
-#define SIGUSR2		12
-#define SIGPIPE		13
-#define SIGALRM		14
-#define SIGTERM		15
-#define SIGSTKFLT	16
-#define SIGCHLD		17
-#define SIGCONT		18
-#define SIGSTOP		19
-#define SIGTSTP		20
-#define SIGTTIN		21
-#define SIGTTOU		22
-#define SIGURG		23
-#define SIGXCPU		24
-#define SIGXFSZ		25
-#define SIGVTALRM	26
-#define SIGPROF		27
-#define SIGWINCH	28
-#define SIGIO		29
-#define SIGPOLL		SIGIO
-/*
-#define SIGLOST		29
-*/
-#define SIGPWR		30
-#define SIGSYS		31
-#define	SIGUNUSED	31
-
-/* These should not be considered constants from userland. */
-#define SIGRTMIN	32
-#define SIGRTMAX	_NSIG
-
-/*
- * SA_FLAGS values:
- *
- * SA_ONSTACK indicates that a registered stack_t will be used.
- * SA_RESTART flag to get restarting signals (which were the default long ago)
- * SA_NOCLDSTOP flag to turn off SIGCHLD when children stop.
- * SA_RESETHAND clears the handler when the signal is delivered.
- * SA_NOCLDWAIT flag on SIGCHLD to inhibit zombies.
- * SA_NODEFER prevents the current signal from being masked in the handler.
- *
- * SA_ONESHOT and SA_NOMASK are the historical Linux names for the Single
- * Unix names RESETHAND and NODEFER respectively.
- */
-#define SA_NOCLDSTOP	0x00000001
-#define SA_NOCLDWAIT	0x00000002
-#define SA_SIGINFO	0x00000004
-#define SA_ONSTACK	0x08000000
-#define SA_RESTART	0x10000000
-#define SA_NODEFER	0x40000000
-#define SA_RESETHAND	0x80000000
-
-#define SA_NOMASK	SA_NODEFER
-#define SA_ONESHOT	SA_RESETHAND
-
-#define SA_RESTORER	0x04000000
-
-/*
- * sigaltstack controls
- */
-#define SS_ONSTACK	1
-#define SS_DISABLE	2
-
-#define MINSIGSTKSZ	2048
-#define SIGSTKSZ	8192
-
-# ifndef __ASSEMBLY__
-# include <linux/types.h>
-# include <asm-generic/signal-defs.h>
-
-/* Avoid too many header ordering problems. */
-struct siginfo;
-
-#  ifdef __KERNEL__
-/*
- * Most things should be clean enough to redefine this at will, if care
- * is taken to make libc match.
- */
-#  define _NSIG		64
-#  define _NSIG_BPW	32
-#  define _NSIG_WORDS	(_NSIG / _NSIG_BPW)
-
-typedef unsigned long old_sigset_t; /* at least 32 bits */
-
-typedef struct {
-	unsigned long sig[_NSIG_WORDS];
-} sigset_t;
-
-struct old_sigaction {
-	__sighandler_t sa_handler;
-	old_sigset_t sa_mask;
-	unsigned long sa_flags;
-	void (*sa_restorer)(void);
-};
-
-struct sigaction {
-	__sighandler_t sa_handler;
-	unsigned long sa_flags;
-	void (*sa_restorer)(void);
-	sigset_t sa_mask; /* mask last for extensibility */
-};
-
-struct k_sigaction {
-	struct sigaction sa;
-};
-
-#  include <asm/sigcontext.h>
-#  undef __HAVE_ARCH_SIG_BITOPS
-
-#  define ptrace_signal_deliver(regs, cookie) do { } while (0)
-
-#  else /* !__KERNEL__ */
-
-/* Here we must cater to libcs that poke about in kernel headers. */
-
-#  define NSIG		32
-typedef unsigned long sigset_t;
-
-struct sigaction {
-	union {
-	__sighandler_t _sa_handler;
-	void (*_sa_sigaction)(int, struct siginfo *, void *);
-	} _u;
-	sigset_t sa_mask;
-	unsigned long sa_flags;
-	void (*sa_restorer)(void);
-};
-
-#  define sa_handler	_u._sa_handler
-#  define sa_sigaction	_u._sa_sigaction
-
-#  endif /* __KERNEL__ */
-
-typedef struct sigaltstack {
-	void *ss_sp;
-	int ss_flags;
-	size_t ss_size;
-} stack_t;
-
-# endif /* __ASSEMBLY__ */
-#endif /* _ASM_MICROBLAZE_SIGNAL_H */
+#include <asm-generic/signal.h>
Index: linux-2.6/arch/microblaze/include/asm/syscalls.h
===================================================================
--- linux-2.6.orig/arch/microblaze/include/asm/syscalls.h
+++ linux-2.6/arch/microblaze/include/asm/syscalls.h
@@ -26,20 +26,15 @@ asmlinkage unsigned long sys_mmap(unsign
 			unsigned long fd, off_t offset);
 
 /* from signal.c */
-asmlinkage int sys_sigsuspend(old_sigset_t mask, struct pt_regs *regs);
-
-asmlinkage int sys_rt_sigsuspend(sigset_t __user *unewset, size_t sigsetsize,
+asmlinkage long sys_rt_sigsuspend(sigset_t __user *unewset, size_t sigsetsize,
 		struct pt_regs *regs);
 
-asmlinkage int sys_sigaction(int sig, const struct old_sigaction *act,
-		struct old_sigaction *oact);
-
-asmlinkage int sys_sigaltstack(const stack_t __user *uss, stack_t __user *uoss,
+asmlinkage long sys_sigaltstack(const stack_t __user *uss, stack_t __user *uoss,
 		struct pt_regs *regs);
 
-asmlinkage int sys_sigreturn(struct pt_regs *regs);
+asmlinkage long sys_rt_sigaction(int sig, const struct sigaction __user * act, struct sigaction __user * oact, size_t sigsetsize);
 
-asmlinkage int sys_rt_sigreturn(struct pt_regs *regs);
+asmlinkage long sys_rt_sigreturn(struct pt_regs *regs);
 
 #endif /* __KERNEL__ */
 #endif /* __ASM_MICROBLAZE_SYSCALLS_H */
Index: linux-2.6/arch/microblaze/include/asm/thread_info.h
===================================================================
--- linux-2.6.orig/arch/microblaze/include/asm/thread_info.h
+++ linux-2.6/arch/microblaze/include/asm/thread_info.h
@@ -154,6 +154,17 @@ static inline struct thread_info *curren
  */
 /* FPU was used by this task this quantum (SMP) */
 #define TS_USEDFPU		0x0001
+#define TS_RESTORE_SIGMASK	0x0002
+
+#ifndef __ASSEMBLY__
+#define HAVE_SET_RESTORE_SIGMASK 1
+static inline void set_restore_sigmask(void)
+{
+	struct thread_info *ti = current_thread_info();
+	ti->status |= TS_RESTORE_SIGMASK;
+	set_bit(TIF_SIGPENDING, (unsigned long *)&ti->flags);
+}
+#endif
 
 #endif /* __KERNEL__ */
 #endif /* _ASM_MICROBLAZE_THREAD_INFO_H */
Index: linux-2.6/arch/microblaze/kernel/signal.c
===================================================================
--- linux-2.6.orig/arch/microblaze/kernel/signal.c
+++ linux-2.6/arch/microblaze/kernel/signal.c
@@ -45,91 +45,7 @@
 
 asmlinkage int do_signal(struct pt_regs *regs, sigset_t *oldset, int in_sycall);
 
-/*
- * Atomically swap in the new signal mask, and wait for a signal.
- */
-asmlinkage int
-sys_sigsuspend(old_sigset_t mask, struct pt_regs *regs)
-{
-	sigset_t saveset;
-
-	mask &= _BLOCKABLE;
-	spin_lock_irq(&current->sighand->siglock);
-	saveset = current->blocked;
-	siginitset(&current->blocked, mask);
-	recalc_sigpending();
-	spin_unlock_irq(&current->sighand->siglock);
-
-	regs->r3 = -EINTR;
-	while (1) {
-		current->state = TASK_INTERRUPTIBLE;
-		schedule();
-		if (do_signal(regs, &saveset, 1))
-			return -EINTR;
-	}
-}
-
-asmlinkage int
-sys_rt_sigsuspend(sigset_t __user *unewset, size_t sigsetsize,
-		struct pt_regs *regs)
-{
-	sigset_t saveset, newset;
-
-	/* XXX: Don't preclude handling different sized sigset_t's. */
-	if (sigsetsize != sizeof(sigset_t))
-		return -EINVAL;
-
-	if (copy_from_user(&newset, unewset, sizeof(newset)))
-		return -EFAULT;
-	sigdelsetmask(&newset, ~_BLOCKABLE);
-	spin_lock_irq(&current->sighand->siglock);
-	saveset = current->blocked;
-	current->blocked = newset;
-	recalc_sigpending();
-	spin_unlock_irq(&current->sighand->siglock);
-
-	regs->r3 = -EINTR;
-	while (1) {
-		current->state = TASK_INTERRUPTIBLE;
-		schedule();
-		if (do_signal(regs, &saveset, 1))
-			return -EINTR;
-	}
-}
-
-asmlinkage int
-sys_sigaction(int sig, const struct old_sigaction *act,
-		struct old_sigaction *oact)
-{
-	struct k_sigaction new_ka, old_ka;
-	int ret;
-
-	if (act) {
-		old_sigset_t mask;
-		if (!access_ok(VERIFY_READ, act, sizeof(*act)) ||
-			__get_user(new_ka.sa.sa_handler, &act->sa_handler) ||
-			__get_user(new_ka.sa.sa_restorer, &act->sa_restorer))
-			return -EFAULT;
-		__get_user(new_ka.sa.sa_flags, &act->sa_flags);
-		__get_user(mask, &act->sa_mask);
-		siginitset(&new_ka.sa.sa_mask, mask);
-	}
-
-	ret = do_sigaction(sig, act ? &new_ka : NULL, oact ? &old_ka : NULL);
-
-	if (!ret && oact) {
-		if (!access_ok(VERIFY_WRITE, oact, sizeof(*oact)) ||
-			__put_user(old_ka.sa.sa_handler, &oact->sa_handler) ||
-			__put_user(old_ka.sa.sa_restorer, &oact->sa_restorer))
-			return -EFAULT;
-		__put_user(old_ka.sa.sa_flags, &oact->sa_flags);
-		__put_user(old_ka.sa.sa_mask.sig[0], &oact->sa_mask);
-	}
-
-	return ret;
-}
-
-asmlinkage int
+asmlinkage long
 sys_sigaltstack(const stack_t __user *uss, stack_t __user *uoss,
 		struct pt_regs *regs)
 {
@@ -139,13 +55,13 @@ sys_sigaltstack(const stack_t __user *us
 /*
  * Do a signal return; undo the signal stack.
  */
-
 struct sigframe {
 	struct sigcontext sc;
 	unsigned long extramask[_NSIG_WORDS-1];
 	unsigned long tramp[2];	/* signal trampoline */
 };
 
+
 struct rt_sigframe {
 	struct siginfo info;
 	struct ucontext uc;
@@ -176,40 +92,7 @@ restore_sigcontext(struct pt_regs *regs,
 	return err;
 }
 
-asmlinkage int sys_sigreturn(struct pt_regs *regs)
-{
-	struct sigframe *frame =
-			(struct sigframe *)(regs->r1 + STATE_SAVE_ARG_SPACE);
-
-	sigset_t set;
-	int rval;
-
-	if (!access_ok(VERIFY_READ, frame, sizeof(*frame)))
-		goto badframe;
-
-	if (__get_user(set.sig[0], &frame->sc.oldmask)
-		|| (_NSIG_WORDS > 1
-		&& __copy_from_user(&set.sig[1], &frame->extramask,
-					sizeof(frame->extramask))))
-		goto badframe;
-
-	sigdelsetmask(&set, ~_BLOCKABLE);
-
-	spin_lock_irq(&current->sighand->siglock);
-	current->blocked = set;
-	recalc_sigpending();
-	spin_unlock_irq(&current->sighand->siglock);
-
-	if (restore_sigcontext(regs, &frame->sc, &rval))
-		goto badframe;
-	return rval;
-
-badframe:
-	force_sig(SIGSEGV, current);
-	return 0;
-}
-
-asmlinkage int sys_rt_sigreturn(struct pt_regs *regs)
+asmlinkage long sys_rt_sigreturn(struct pt_regs *regs)
 {
 	struct rt_sigframe *frame =
 			(struct rt_sigframe *)(regs->r1 + STATE_SAVE_ARG_SPACE);
@@ -290,80 +173,6 @@ get_sigframe(struct k_sigaction *ka, str
 	return (void *)((sp - frame_size) & -8UL);
 }
 
-static void setup_frame(int sig, struct k_sigaction *ka,
-			sigset_t *set, struct pt_regs *regs)
-{
-	struct sigframe *frame;
-	int err = 0;
-	int signal;
-
-	frame = get_sigframe(ka, regs, sizeof(*frame));
-
-	if (!access_ok(VERIFY_WRITE, frame, sizeof(*frame)))
-		goto give_sigsegv;
-
-	signal = current_thread_info()->exec_domain
-		&& current_thread_info()->exec_domain->signal_invmap
-		&& sig < 32
-		? current_thread_info()->exec_domain->signal_invmap[sig]
-		: sig;
-
-	err |= setup_sigcontext(&frame->sc, regs, set->sig[0]);
-
-	if (_NSIG_WORDS > 1) {
-		err |= __copy_to_user(frame->extramask, &set->sig[1],
-					sizeof(frame->extramask));
-	}
-
-	/* Set up to return from userspace. If provided, use a stub
-	 already in userspace. */
-	/* minus 8 is offset to cater for "rtsd r15,8" offset */
-	if (ka->sa.sa_flags & SA_RESTORER) {
-		regs->r15 = ((unsigned long)ka->sa.sa_restorer)-8;
-	} else {
-		/* Note, these encodings are _big endian_! */
-
-		/* addi r12, r0, __NR_sigreturn */
-		err |= __put_user(0x31800000 | __NR_sigreturn ,
-				frame->tramp + 0);
-		/* brki r14, 0x8 */
-		err |= __put_user(0xb9cc0008, frame->tramp + 1);
-
-		/* Return from sighandler will jump to the tramp.
-		 Negative 8 offset because return is rtsd r15, 8 */
-		regs->r15 = ((unsigned long)frame->tramp)-8;
-
-		__invalidate_cache_sigtramp((unsigned long)frame->tramp);
-	}
-
-	if (err)
-		goto give_sigsegv;
-
-	/* Set up registers for signal handler */
-	regs->r1 = (unsigned long) frame - STATE_SAVE_ARG_SPACE;
-
-	/* Signal handler args: */
-	regs->r5 = signal; /* Arg 0: signum */
-	regs->r6 = (unsigned long) &frame->sc; /* arg 1: sigcontext */
-
-	/* Offset of 4 to handle microblaze rtid r14, 0 */
-	regs->pc = (unsigned long)ka->sa.sa_handler;
-
-	set_fs(USER_DS);
-
-#ifdef DEBUG_SIG
-	printk(KERN_INFO "SIG deliver (%s:%d): sp=%p pc=%08lx\n",
-		current->comm, current->pid, frame, regs->pc);
-#endif
-
-	return;
-
-give_sigsegv:
-	if (sig == SIGSEGV)
-		ka->sa.sa_handler = SIG_DFL;
-	force_sig(SIGSEGV, current);
-}
-
 static void setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 			sigset_t *set, struct pt_regs *regs)
 {
@@ -399,21 +208,17 @@ static void setup_rt_frame(int sig, stru
 	/* Set up to return from userspace. If provided, use a stub
 	 already in userspace. */
 	/* minus 8 is offset to cater for "rtsd r15,8" */
-	if (ka->sa.sa_flags & SA_RESTORER) {
-		regs->r15 = ((unsigned long)ka->sa.sa_restorer)-8;
-	} else {
-		/* addi r12, r0, __NR_sigreturn */
-		err |= __put_user(0x31800000 | __NR_rt_sigreturn ,
-				frame->tramp + 0);
-		/* brki r14, 0x8 */
-		err |= __put_user(0xb9cc0008, frame->tramp + 1);
-
-		/* Return from sighandler will jump to the tramp.
-		 Negative 8 offset because return is rtsd r15, 8 */
-		regs->r15 = ((unsigned long)frame->tramp)-8;
+	/* addi r12, r0, __NR_sigreturn */
+	err |= __put_user(0x31800000 | __NR_rt_sigreturn ,
+			frame->tramp + 0);
+	/* brki r14, 0x8 */
+	err |= __put_user(0xb9cc0008, frame->tramp + 1);
+
+	/* Return from sighandler will jump to the tramp.
+	 Negative 8 offset because return is rtsd r15, 8 */
+	regs->r15 = ((unsigned long)frame->tramp)-8;
 
-		__invalidate_cache_sigtramp((unsigned long)frame->tramp);
-	}
+	__invalidate_cache_sigtramp((unsigned long)frame->tramp);
 
 	if (err)
 		goto give_sigsegv;
@@ -472,7 +277,7 @@ do_restart:
  * OK, we're invoking a handler
  */
 
-static void
+static int
 handle_signal(unsigned long sig, struct k_sigaction *ka,
 		siginfo_t *info, sigset_t *oldset, struct pt_regs *regs)
 {
@@ -480,7 +285,7 @@ handle_signal(unsigned long sig, struct 
 	if (ka->sa.sa_flags & SA_SIGINFO)
 		setup_rt_frame(sig, ka, info, oldset, regs);
 	else
-		setup_frame(sig, ka, oldset, regs);
+		setup_rt_frame(sig, ka, NULL, oldset, regs);
 
 	if (ka->sa.sa_flags & SA_ONESHOT)
 		ka->sa.sa_handler = SIG_DFL;
@@ -509,6 +314,7 @@ int do_signal(struct pt_regs *regs, sigs
 	siginfo_t info;
 	int signr;
 	struct k_sigaction ka;
+
 #ifdef DEBUG_SIG
 	printk(KERN_INFO "do signal: %p %p %d\n", regs, oldset, in_syscall);
 	printk(KERN_INFO "do signal2: %lx %lx %ld [%lx]\n", regs->pc, regs->r1,
@@ -523,7 +329,9 @@ int do_signal(struct pt_regs *regs, sigs
 	if (kernel_mode(regs))
 		return 1;
 
-	if (!oldset)
+	if (current_thread_info()->status & TS_RESTORE_SIGMASK)
+		oldset = &current->saved_sigmask;
+	else
 		oldset = &current->blocked;
 
 	signr = get_signal_to_deliver(&info, &ka, regs, NULL);
@@ -531,13 +339,31 @@ int do_signal(struct pt_regs *regs, sigs
 		/* Whee! Actually deliver the signal. */
 		if (in_syscall)
 			handle_restart(regs, &ka, 1);
-		handle_signal(signr, &ka, &info, oldset, regs);
+		if (handle_signal(signr, &ka, &info, oldset, regs)) {
+			/*
+			 * A signal was successfully delivered; the saved
+			 * sigmask will have been stored in the signal frame,
+			 * and will be restored by sigreturn, so we can simply
+			 * clear the TS_RESTORE_SIGMASK flag.
+			 */
+			current_thread_info()->status &=
+			    ~TS_RESTORE_SIGMASK;
+		}
 		return 1;
 	}
 
 	if (in_syscall)
 		handle_restart(regs, NULL, 0);
 
+	/*
+	 * If there's no signal to deliver, we just put the saved sigmask
+	 * back.
+	 */
+	if (current_thread_info()->status & TS_RESTORE_SIGMASK) {
+		current_thread_info()->status &= ~TS_RESTORE_SIGMASK;
+		sigprocmask(SIG_SETMASK, &current->saved_sigmask, NULL);
+	}
+
 	/* Did we come from a system call? */
 	return 0;
 }
Index: linux-2.6/arch/microblaze/include/asm/unistd.h
===================================================================
--- linux-2.6.orig/arch/microblaze/include/asm/unistd.h
+++ linux-2.6/arch/microblaze/include/asm/unistd.h
@@ -408,7 +408,7 @@
 #define __ARCH_WANT_SYS_SIGPENDING
 #define __ARCH_WANT_SYS_SIGPROCMASK
 #define __ARCH_WANT_SYS_RT_SIGACTION
-/* #define __ARCH_WANT_SYS_RT_SIGSUSPEND */
+#define __ARCH_WANT_SYS_RT_SIGSUSPEND
 
 /*
  * "Conditional" syscalls

-- 

--
To unsubscribe from this list: send the line "unsubscribe linux-api" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
