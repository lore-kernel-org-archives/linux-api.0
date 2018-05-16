From: Yury Norov <ynorov@caviumnetworks.com>
Subject: [PATCH 18/24] arm64: signal: share lp64 signal structures and routines to ilp32
Date: Wed, 16 May 2018 11:19:03 +0300
Message-ID: <20180516081910.10067-19-ynorov@caviumnetworks.com>
References: <20180516081910.10067-1-ynorov@caviumnetworks.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180516081910.10067-1-ynorov@caviumnetworks.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Catalin Marinas <catalin.marinas@arm.com>, Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-arch@vger.kernel.org, linux-api@vger.kernel.org
Cc: Yury Norov <ynorov@caviumnetworks.com>, Adam Borowski <kilobyte@angband.pl>, Alexander Graf <agraf@suse.de>, Alexey Klimov <klimov.linux@gmail.com>, Andreas Schwab <schwab@suse.de>, Andrew Pinski <pinskia@gmail.com>, Bamvor Zhangjian <bamv2005@gmail.com>, Chris Metcalf <cmetcalf@mellanox.com>, Christoph Muellner <christoph.muellner@theobroma-systems.com>, Dave Martin <Dave.Martin@arm.com>, "David S . Miller" <davem@davemloft.net>, Florian Weimer <fweimer@redhat.com>, Geert Uytterhoeven <geert@linux-m68k.org>, Heiko Carstens <heiko.carstens@de.ibm.com>, James Hogan <james.hogan@imgtec.com>, James Morse <james.morse@arm.com>, Joseph Myers <joseph@codesourcery.com>, Lin Yongting <linyongting@huawei.com>, Manuel Montezelo <manuel.montezelo@gmail.>
List-Id: linux-api@vger.kernel.org

Following patches of the series introduce ILP32-specific structures and
handlers for signal subsystem. In this patch, functions and structures
that common for LP64 and ILP32 are moved to
arch/arm64/include/asm/signal_common.h to let ILP32 code reuse them. Some
functions work with struct rt_sigframe which differs for ILP32. Therefore,
to let ILP32 generate correct code, body of that functions are moved to
arch/arm64/include/asm/signal_common.h. Others just declared in new header.

Signed-off-by: Yury Norov <ynorov@caviumnetworks.com>
---
 arch/arm64/include/asm/signal_common.h | 306 ++++++++++++++++++++++
 arch/arm64/kernel/signal.c             | 336 ++++---------------------
 2 files changed, 359 insertions(+), 283 deletions(-)
 create mode 100644 arch/arm64/include/asm/signal_common.h

diff --git a/arch/arm64/include/asm/signal_common.h b/arch/arm64/include/asm/signal_common.h
new file mode 100644
index 000000000000..84abe973e8b3
--- /dev/null
+++ b/arch/arm64/include/asm/signal_common.h
@@ -0,0 +1,306 @@
+/* SPDX-License-Identifier: GPL-2.0+ */
+
+/*
+ * Copyright (C) 1995-2009 Russell King
+ * Copyright (C) 2012 ARM Ltd.
+ * Copyright (C) 2018 Cavium Networks.
+ */
+
+#ifndef __ASM_SIGNAL_COMMON_H
+#define __ASM_SIGNAL_COMMON_H
+
+#include <linux/uaccess.h>
+#include <asm/fpsimd.h>
+
+#define EXTRA_CONTEXT_SIZE round_up(sizeof(struct extra_context), 16)
+#define TERMINATOR_SIZE round_up(sizeof(struct _aarch64_ctx), 16)
+#define SIGCONTEXT_RESERVED_SIZE sizeof(((struct sigcontext *)0)->__reserved)
+#define RT_SIGFRAME_RESERVED_OFFSET \
+		offsetof(struct rt_sigframe, uc.uc_mcontext.__reserved)
+
+/*
+ * Sanity limit on the approximate maximum size of signal frame we'll
+ * try to generate.  Stack alignment padding and the frame record are
+ * not taken into account.  This limit is not a guarantee and is
+ * NOT ABI.
+ */
+#define SIGFRAME_MAXSZ SZ_64K
+
+struct rt_sigframe_user_layout {
+	void __user *sigframe;
+	struct frame_record __user *next_frame;
+
+	unsigned long size;	/* size of allocated sigframe data */
+	unsigned long limit;	/* largest allowed size */
+
+	unsigned long fpsimd_offset;
+	unsigned long esr_offset;
+	unsigned long sve_offset;
+	unsigned long extra_offset;
+	unsigned long end_offset;
+};
+
+struct user_ctxs {
+	struct fpsimd_context __user *fpsimd;
+	struct sve_context __user *sve;
+};
+
+struct frame_record {
+	u64 fp;
+	u64 lr;
+};
+
+void __user *apply_user_offset(struct rt_sigframe_user_layout const *user,
+			       unsigned long offset);
+
+int setup_sigframe_layout(struct rt_sigframe_user_layout *user);
+int setup_extra_context(char __user *sfp, unsigned long sf_size,
+			char __user *exprap);
+int __parse_user_sigcontext(struct user_ctxs *user,
+				   struct sigcontext __user const *sc,
+				   void __user const *sigframe_base);
+#define parse_user_sigcontext(user, sf)					\
+	__parse_user_sigcontext(user, &(sf)->uc.uc_mcontext, sf)
+
+int preserve_fpsimd_context(struct fpsimd_context __user *ctx);
+int restore_fpsimd_context(struct fpsimd_context __user *ctx);
+
+#ifdef CONFIG_ARM64_SVE
+int preserve_sve_context(struct sve_context __user *ctx);
+int restore_sve_fpsimd_context(struct user_ctxs *user);
+#else /* ! CONFIG_ARM64_SVE */
+
+/* Turn any non-optimised out attempts to use these into a link error: */
+extern int preserve_sve_context(void __user *ctx);
+extern int restore_sve_fpsimd_context(struct user_ctxs *user);
+
+#endif /* ! CONFIG_ARM64_SVE */
+
+int sigframe_alloc(struct rt_sigframe_user_layout *user,
+		   unsigned long *offset, size_t size);
+int sigframe_alloc_end(struct rt_sigframe_user_layout *user);
+
+void __setup_return(struct pt_regs *regs, struct k_sigaction *ka,
+		    struct rt_sigframe_user_layout *user, int usig);
+
+static void init_user_layout(struct rt_sigframe_user_layout *user)
+{
+	memset(user, 0, sizeof(*user));
+	user->size = RT_SIGFRAME_RESERVED_OFFSET;
+
+	user->limit = user->size + SIGCONTEXT_RESERVED_SIZE;
+
+	user->limit -= TERMINATOR_SIZE;
+	user->limit -= EXTRA_CONTEXT_SIZE;
+	/* Reserve space for extension and terminator ^ */
+}
+
+static size_t sigframe_size(struct rt_sigframe_user_layout const *user)
+{
+	return round_up(max(user->size, sizeof(struct rt_sigframe)), 16);
+}
+
+static int get_sigframe(struct rt_sigframe_user_layout *user,
+			 struct ksignal *ksig, struct pt_regs *regs)
+{
+	unsigned long sp, sp_top;
+	int err;
+
+	init_user_layout(user);
+	err = setup_sigframe_layout(user);
+	if (err)
+		return err;
+
+	sp = sp_top = sigsp(regs->sp, ksig);
+
+	sp = round_down(sp - sizeof(struct frame_record), 16);
+	user->next_frame = (struct frame_record __user *)sp;
+
+	sp = round_down(sp, 16) - sigframe_size(user);
+	user->sigframe = (void __user *)sp;
+
+	/*
+	 * Check that we can actually write to the signal frame.
+	 */
+	if (!access_ok(VERIFY_WRITE, user->sigframe, sp_top - sp))
+		return -EFAULT;
+
+	return 0;
+}
+
+static int restore_sigframe(struct pt_regs *regs,
+			    struct rt_sigframe __user *sf)
+{
+	sigset_t set;
+	int i, err;
+	struct user_ctxs user;
+
+	err = get_sigset(&set, &sf->uc.uc_sigmask);
+	if (err == 0)
+		set_current_blocked(&set);
+
+	for (i = 0; i < 31; i++)
+		__get_user_error(regs->regs[i], &sf->uc.uc_mcontext.regs[i],
+				 err);
+	__get_user_error(regs->sp, &sf->uc.uc_mcontext.sp, err);
+	__get_user_error(regs->pc, &sf->uc.uc_mcontext.pc, err);
+	__get_user_error(regs->pstate, &sf->uc.uc_mcontext.pstate, err);
+
+	/*
+	 * Avoid sys_rt_sigreturn() restarting.
+	 */
+	forget_syscall(regs);
+
+	err |= !valid_user_regs(&regs->user_regs, current);
+	if (err == 0)
+		err = parse_user_sigcontext(&user, sf);
+
+	if (err == 0) {
+		if (!user.fpsimd)
+			return -EINVAL;
+
+		if (user.sve) {
+			if (!system_supports_sve())
+				return -EINVAL;
+
+			err = restore_sve_fpsimd_context(&user);
+		} else {
+			err = restore_fpsimd_context(user.fpsimd);
+		}
+	}
+
+	return err;
+}
+
+static int setup_sigframe(struct rt_sigframe_user_layout *user,
+			  struct pt_regs *regs, sigset_t *set)
+{
+	int i, err = 0;
+	struct rt_sigframe __user *sf = user->sigframe;
+
+	/* set up the stack frame for unwinding */
+	__put_user_error(regs->regs[29], &user->next_frame->fp, err);
+	__put_user_error(regs->regs[30], &user->next_frame->lr, err);
+
+	for (i = 0; i < 31; i++)
+		__put_user_error(regs->regs[i], &sf->uc.uc_mcontext.regs[i],
+				 err);
+	__put_user_error(regs->sp, &sf->uc.uc_mcontext.sp, err);
+	__put_user_error(regs->pc, &sf->uc.uc_mcontext.pc, err);
+	__put_user_error(regs->pstate, &sf->uc.uc_mcontext.pstate, err);
+
+	__put_user_error(current->thread.fault_address,
+			 &sf->uc.uc_mcontext.fault_address, err);
+
+	err |= put_sigset(set, &sf->uc.uc_sigmask);
+
+	if (err == 0) {
+		struct fpsimd_context __user *fpsimd_ctx =
+			apply_user_offset(user, user->fpsimd_offset);
+		err |= preserve_fpsimd_context(fpsimd_ctx);
+	}
+
+	/* fault information, if valid */
+	if (err == 0 && user->esr_offset) {
+		struct esr_context __user *esr_ctx =
+			apply_user_offset(user, user->esr_offset);
+
+		__put_user_error(ESR_MAGIC, &esr_ctx->head.magic, err);
+		__put_user_error(sizeof(*esr_ctx), &esr_ctx->head.size, err);
+		__put_user_error(current->thread.fault_code,
+				 &esr_ctx->esr, err);
+	}
+
+	/* Scalable Vector Extension state, if present */
+	if (system_supports_sve() && err == 0 && user->sve_offset) {
+		struct sve_context __user *sve_ctx =
+			apply_user_offset(user, user->sve_offset);
+		err |= preserve_sve_context(sve_ctx);
+	}
+
+	if (err == 0 && user->extra_offset)
+		setup_extra_context((char __user *)user->sigframe, user->size,
+				    (char __user *)apply_user_offset(user,
+						   user->extra_offset));
+
+	/* set the "end" magic */
+	if (err == 0) {
+		struct _aarch64_ctx __user *end =
+			apply_user_offset(user, user->end_offset);
+
+		__put_user_error(0, &end->magic, err);
+		__put_user_error(0, &end->size, err);
+	}
+
+	return err;
+}
+
+static long __sys_rt_sigreturn(struct pt_regs *regs)
+{
+	struct rt_sigframe __user *frame;
+
+	/* Always make any pending restarted system calls return -EINTR */
+	current->restart_block.fn = do_no_restart_syscall;
+
+	/*
+	 * Since we stacked the signal on a 128-bit boundary, then 'sp' should
+	 * be word aligned here.
+	 */
+	if (regs->sp & 15)
+		goto badframe;
+
+	frame = (struct rt_sigframe __user *)regs->sp;
+
+	if (!access_ok(VERIFY_READ, frame, sizeof(*frame)))
+		goto badframe;
+
+	if (restore_sigframe(regs, frame))
+		goto badframe;
+
+	if (restore_altstack(&frame->uc.uc_stack))
+		goto badframe;
+
+	return regs->regs[0];
+
+badframe:
+	if (show_unhandled_signals)
+		pr_info_ratelimited("%s[%d]: bad frame in %s: pc=%08llx sp=%08llx\n",
+				    current->comm, task_pid_nr(current), __func__,
+				    regs->pc, regs->sp);
+	force_sig(SIGSEGV, current);
+	return 0;
+}
+
+static int __setup_rt_frame(int usig, struct ksignal *ksig,
+				sigset_t *set, struct pt_regs *regs)
+{
+	struct rt_sigframe_user_layout user;
+	struct rt_sigframe __user *frame;
+	int err = 0;
+
+	fpsimd_signal_preserve_current_state();
+
+	if (get_sigframe(&user, ksig, regs))
+		return 1;
+
+	frame = user.sigframe;
+
+	__put_user_error(0, &frame->uc.uc_flags, err);
+	__put_user_error((typeof(frame->uc.uc_link)) 0,
+			  &frame->uc.uc_link, err);
+
+	err |= __save_altstack(&frame->uc.uc_stack, regs->sp);
+	err |= setup_sigframe(&user, regs, set);
+	if (err == 0) {
+		setup_return(regs, &ksig->ka, &user, usig);
+		if (ksig->ka.sa.sa_flags & SA_SIGINFO) {
+			err |= copy_siginfo_to_user(&frame->info, &ksig->info);
+			regs->regs[1] = (unsigned long)&frame->info;
+			regs->regs[2] = (unsigned long)&frame->uc;
+		}
+	}
+
+	return err;
+}
+
+#endif /* __ASM_SIGNAL_COMMON_H */
diff --git a/arch/arm64/kernel/signal.c b/arch/arm64/kernel/signal.c
index 0a829f6f1832..c1a2523bac02 100644
--- a/arch/arm64/kernel/signal.c
+++ b/arch/arm64/kernel/signal.c
@@ -41,6 +41,10 @@
 #include <asm/ptrace.h>
 #include <asm/signal32.h>
 #include <asm/vdso.h>
+#include <asm/signal_ilp32.h>
+
+#define get_sigset(s, m) __copy_from_user(s, m, sizeof(*s))
+#define put_sigset(s, m) __copy_to_user(m, s, sizeof(*s))
 
 /*
  * Do a signal return; undo the signal stack. These are aligned to 128-bit.
@@ -49,57 +53,12 @@ struct rt_sigframe {
 	struct siginfo info;
 	struct ucontext uc;
 };
+struct rt_sigframe_user_layout;
 
-struct frame_record {
-	u64 fp;
-	u64 lr;
-};
-
-struct rt_sigframe_user_layout {
-	struct rt_sigframe __user *sigframe;
-	struct frame_record __user *next_frame;
-
-	unsigned long size;	/* size of allocated sigframe data */
-	unsigned long limit;	/* largest allowed size */
-
-	unsigned long fpsimd_offset;
-	unsigned long esr_offset;
-	unsigned long sve_offset;
-	unsigned long extra_offset;
-	unsigned long end_offset;
-};
-
-#define BASE_SIGFRAME_SIZE round_up(sizeof(struct rt_sigframe), 16)
-#define TERMINATOR_SIZE round_up(sizeof(struct _aarch64_ctx), 16)
-#define EXTRA_CONTEXT_SIZE round_up(sizeof(struct extra_context), 16)
-
-static void init_user_layout(struct rt_sigframe_user_layout *user)
-{
-	const size_t reserved_size =
-		sizeof(user->sigframe->uc.uc_mcontext.__reserved);
-
-	memset(user, 0, sizeof(*user));
-	user->size = offsetof(struct rt_sigframe, uc.uc_mcontext.__reserved);
-
-	user->limit = user->size + reserved_size;
-
-	user->limit -= TERMINATOR_SIZE;
-	user->limit -= EXTRA_CONTEXT_SIZE;
-	/* Reserve space for extension and terminator ^ */
-}
-
-static size_t sigframe_size(struct rt_sigframe_user_layout const *user)
-{
-	return round_up(max(user->size, sizeof(struct rt_sigframe)), 16);
-}
+static void setup_return(struct pt_regs *regs, struct k_sigaction *ka,
+			 struct rt_sigframe_user_layout *user, int usig);
 
-/*
- * Sanity limit on the approximate maximum size of signal frame we'll
- * try to generate.  Stack alignment padding and the frame record are
- * not taken into account.  This limit is not a guarantee and is
- * NOT ABI.
- */
-#define SIGFRAME_MAXSZ SZ_64K
+#include <asm/signal_common.h>
 
 static int __sigframe_alloc(struct rt_sigframe_user_layout *user,
 			    unsigned long *offset, size_t size, bool extend)
@@ -144,14 +103,14 @@ static int __sigframe_alloc(struct rt_sigframe_user_layout *user,
  * signal frame.  The offset from the signal frame base address to the
  * allocated block is assigned to *offset.
  */
-static int sigframe_alloc(struct rt_sigframe_user_layout *user,
+int sigframe_alloc(struct rt_sigframe_user_layout *user,
 			  unsigned long *offset, size_t size)
 {
 	return __sigframe_alloc(user, offset, size, true);
 }
 
 /* Allocate the null terminator record and prevent further allocations */
-static int sigframe_alloc_end(struct rt_sigframe_user_layout *user)
+int sigframe_alloc_end(struct rt_sigframe_user_layout *user)
 {
 	int ret;
 
@@ -168,7 +127,7 @@ static int sigframe_alloc_end(struct rt_sigframe_user_layout *user)
 	return 0;
 }
 
-static void __user *apply_user_offset(
+void __user *apply_user_offset(
 	struct rt_sigframe_user_layout const *user, unsigned long offset)
 {
 	char __user *base = (char __user *)user->sigframe;
@@ -176,7 +135,7 @@ static void __user *apply_user_offset(
 	return base + offset;
 }
 
-static int preserve_fpsimd_context(struct fpsimd_context __user *ctx)
+int preserve_fpsimd_context(struct fpsimd_context __user *ctx)
 {
 	struct user_fpsimd_state const *fpsimd =
 		&current->thread.fpsimd_state.user_fpsimd;
@@ -194,7 +153,7 @@ static int preserve_fpsimd_context(struct fpsimd_context __user *ctx)
 	return err ? -EFAULT : 0;
 }
 
-static int restore_fpsimd_context(struct fpsimd_context __user *ctx)
+int restore_fpsimd_context(struct fpsimd_context __user *ctx)
 {
 	struct user_fpsimd_state fpsimd;
 	__u32 magic, size;
@@ -223,15 +182,9 @@ static int restore_fpsimd_context(struct fpsimd_context __user *ctx)
 	return err ? -EFAULT : 0;
 }
 
-
-struct user_ctxs {
-	struct fpsimd_context __user *fpsimd;
-	struct sve_context __user *sve;
-};
-
 #ifdef CONFIG_ARM64_SVE
 
-static int preserve_sve_context(struct sve_context __user *ctx)
+int preserve_sve_context(struct sve_context __user *ctx)
 {
 	int err = 0;
 	u16 reserved[ARRAY_SIZE(ctx->__reserved)];
@@ -263,7 +216,7 @@ static int preserve_sve_context(struct sve_context __user *ctx)
 	return err ? -EFAULT : 0;
 }
 
-static int restore_sve_fpsimd_context(struct user_ctxs *user)
+int restore_sve_fpsimd_context(struct user_ctxs *user)
 {
 	int err;
 	unsigned int vq;
@@ -326,15 +279,9 @@ static int restore_sve_fpsimd_context(struct user_ctxs *user)
 	return err ? -EFAULT : 0;
 }
 
-#else /* ! CONFIG_ARM64_SVE */
-
-/* Turn any non-optimised out attempts to use these into a link error: */
-extern int preserve_sve_context(void __user *ctx);
-extern int restore_sve_fpsimd_context(struct user_ctxs *user);
-
 #endif /* ! CONFIG_ARM64_SVE */
 
-static int __parse_user_sigcontext(struct user_ctxs *user,
+int __parse_user_sigcontext(struct user_ctxs *user,
 				   struct sigcontext __user const *sc,
 				   void __user const *sigframe_base)
 {
@@ -492,91 +439,13 @@ static int __parse_user_sigcontext(struct user_ctxs *user,
 	return -EINVAL;
 }
 
-#define parse_user_sigcontext(user, sf)					\
-	__parse_user_sigcontext(user, &(sf)->uc.uc_mcontext, sf)
-
-static int restore_sigframe(struct pt_regs *regs,
-			    struct rt_sigframe __user *sf)
-{
-	sigset_t set;
-	int i, err;
-	struct user_ctxs user;
-
-	err = __copy_from_user(&set, &sf->uc.uc_sigmask, sizeof(set));
-	if (err == 0)
-		set_current_blocked(&set);
-
-	for (i = 0; i < 31; i++)
-		__get_user_error(regs->regs[i], &sf->uc.uc_mcontext.regs[i],
-				 err);
-	__get_user_error(regs->sp, &sf->uc.uc_mcontext.sp, err);
-	__get_user_error(regs->pc, &sf->uc.uc_mcontext.pc, err);
-	__get_user_error(regs->pstate, &sf->uc.uc_mcontext.pstate, err);
-
-	/*
-	 * Avoid sys_rt_sigreturn() restarting.
-	 */
-	forget_syscall(regs);
-
-	err |= !valid_user_regs(&regs->user_regs, current);
-	if (err == 0)
-		err = parse_user_sigcontext(&user, sf);
-
-	if (err == 0) {
-		if (!user.fpsimd)
-			return -EINVAL;
-
-		if (user.sve) {
-			if (!system_supports_sve())
-				return -EINVAL;
-
-			err = restore_sve_fpsimd_context(&user);
-		} else {
-			err = restore_fpsimd_context(user.fpsimd);
-		}
-	}
-
-	return err;
-}
-
 asmlinkage long sys_rt_sigreturn(struct pt_regs *regs)
 {
-	struct rt_sigframe __user *frame;
-
-	/* Always make any pending restarted system calls return -EINTR */
-	current->restart_block.fn = do_no_restart_syscall;
-
-	/*
-	 * Since we stacked the signal on a 128-bit boundary, then 'sp' should
-	 * be word aligned here.
-	 */
-	if (regs->sp & 15)
-		goto badframe;
-
-	frame = (struct rt_sigframe __user *)regs->sp;
-
-	if (!access_ok(VERIFY_READ, frame, sizeof (*frame)))
-		goto badframe;
-
-	if (restore_sigframe(regs, frame))
-		goto badframe;
-
-	if (restore_altstack(&frame->uc.uc_stack))
-		goto badframe;
-
-	return regs->regs[0];
-
-badframe:
-	if (show_unhandled_signals)
-		pr_info_ratelimited("%s[%d]: bad frame in %s: pc=%08llx sp=%08llx\n",
-				    current->comm, task_pid_nr(current), __func__,
-				    regs->pc, regs->sp);
-	force_sig(SIGSEGV, current);
-	return 0;
+	return __sys_rt_sigreturn(regs);
 }
 
 /* Determine the layout of optional records in the signal frame */
-static int setup_sigframe_layout(struct rt_sigframe_user_layout *user)
+int setup_sigframe_layout(struct rt_sigframe_user_layout *user)
 {
 	int err;
 
@@ -608,123 +477,50 @@ static int setup_sigframe_layout(struct rt_sigframe_user_layout *user)
 	return sigframe_alloc_end(user);
 }
 
-
-static int setup_sigframe(struct rt_sigframe_user_layout *user,
-			  struct pt_regs *regs, sigset_t *set)
+int setup_extra_context(char __user *sfp, unsigned long sf_size,
+			char __user *extrap)
 {
-	int i, err = 0;
-	struct rt_sigframe __user *sf = user->sigframe;
-
-	/* set up the stack frame for unwinding */
-	__put_user_error(regs->regs[29], &user->next_frame->fp, err);
-	__put_user_error(regs->regs[30], &user->next_frame->lr, err);
-
-	for (i = 0; i < 31; i++)
-		__put_user_error(regs->regs[i], &sf->uc.uc_mcontext.regs[i],
-				 err);
-	__put_user_error(regs->sp, &sf->uc.uc_mcontext.sp, err);
-	__put_user_error(regs->pc, &sf->uc.uc_mcontext.pc, err);
-	__put_user_error(regs->pstate, &sf->uc.uc_mcontext.pstate, err);
-
-	__put_user_error(current->thread.fault_address, &sf->uc.uc_mcontext.fault_address, err);
-
-	err |= __copy_to_user(&sf->uc.uc_sigmask, set, sizeof(*set));
-
-	if (err == 0) {
-		struct fpsimd_context __user *fpsimd_ctx =
-			apply_user_offset(user, user->fpsimd_offset);
-		err |= preserve_fpsimd_context(fpsimd_ctx);
-	}
-
-	/* fault information, if valid */
-	if (err == 0 && user->esr_offset) {
-		struct esr_context __user *esr_ctx =
-			apply_user_offset(user, user->esr_offset);
-
-		__put_user_error(ESR_MAGIC, &esr_ctx->head.magic, err);
-		__put_user_error(sizeof(*esr_ctx), &esr_ctx->head.size, err);
-		__put_user_error(current->thread.fault_code, &esr_ctx->esr, err);
-	}
-
-	/* Scalable Vector Extension state, if present */
-	if (system_supports_sve() && err == 0 && user->sve_offset) {
-		struct sve_context __user *sve_ctx =
-			apply_user_offset(user, user->sve_offset);
-		err |= preserve_sve_context(sve_ctx);
-	}
-
-	if (err == 0 && user->extra_offset) {
-		char __user *sfp = (char __user *)user->sigframe;
-		char __user *userp =
-			apply_user_offset(user, user->extra_offset);
-
-		struct extra_context __user *extra;
-		struct _aarch64_ctx __user *end;
-		u64 extra_datap;
-		u32 extra_size;
-
-		extra = (struct extra_context __user *)userp;
-		userp += EXTRA_CONTEXT_SIZE;
-
-		end = (struct _aarch64_ctx __user *)userp;
-		userp += TERMINATOR_SIZE;
+	int err = 0;
+	struct extra_context __user *extra;
+	struct _aarch64_ctx __user *end;
+	u64 extra_datap;
+	u32 extra_size;
 
-		/*
-		 * extra_datap is just written to the signal frame.
-		 * The value gets cast back to a void __user *
-		 * during sigreturn.
-		 */
-		extra_datap = (__force u64)userp;
-		extra_size = sfp + round_up(user->size, 16) - userp;
+	extra = (struct extra_context __user *)extrap;
+	extrap += EXTRA_CONTEXT_SIZE;
 
-		__put_user_error(EXTRA_MAGIC, &extra->head.magic, err);
-		__put_user_error(EXTRA_CONTEXT_SIZE, &extra->head.size, err);
-		__put_user_error(extra_datap, &extra->datap, err);
-		__put_user_error(extra_size, &extra->size, err);
+	end = (struct _aarch64_ctx __user *)extrap;
+	extrap += TERMINATOR_SIZE;
 
-		/* Add the terminator */
-		__put_user_error(0, &end->magic, err);
-		__put_user_error(0, &end->size, err);
-	}
+	/*
+	 * extra_datap is just written to the signal frame.
+	 * The value gets cast back to a void __user *
+	 * during sigreturn.
+	 */
+	extra_datap = (__force u64)extrap;
+	extra_size = sfp + round_up(sf_size, 16) - extrap;
 
-	/* set the "end" magic */
-	if (err == 0) {
-		struct _aarch64_ctx __user *end =
-			apply_user_offset(user, user->end_offset);
+	__put_user_error(EXTRA_MAGIC, &extra->head.magic, err);
+	__put_user_error(EXTRA_CONTEXT_SIZE, &extra->head.size, err);
+	__put_user_error(extra_datap, &extra->datap, err);
+	__put_user_error(extra_size, &extra->size, err);
 
-		__put_user_error(0, &end->magic, err);
-		__put_user_error(0, &end->size, err);
-	}
+	/* Add the terminator */
+	__put_user_error(0, &end->magic, err);
+	__put_user_error(0, &end->size, err);
 
 	return err;
 }
 
-static int get_sigframe(struct rt_sigframe_user_layout *user,
-			 struct ksignal *ksig, struct pt_regs *regs)
+void __setup_return(struct pt_regs *regs, struct k_sigaction *ka,
+		struct rt_sigframe_user_layout *user, int usig)
 {
-	unsigned long sp, sp_top;
-	int err;
-
-	init_user_layout(user);
-	err = setup_sigframe_layout(user);
-	if (err)
-		return err;
-
-	sp = sp_top = sigsp(regs->sp, ksig);
-
-	sp = round_down(sp - sizeof(struct frame_record), 16);
-	user->next_frame = (struct frame_record __user *)sp;
 
-	sp = round_down(sp, 16) - sigframe_size(user);
-	user->sigframe = (struct rt_sigframe __user *)sp;
-
-	/*
-	 * Check that we can actually write to the signal frame.
-	 */
-	if (!access_ok(VERIFY_WRITE, user->sigframe, sp_top - sp))
-		return -EFAULT;
+	regs->regs[0] = usig;
+	regs->sp = (unsigned long)user->sigframe;
+	regs->regs[29] = (unsigned long)&user->next_frame->fp;
+	regs->pc = (unsigned long)ka->sa.sa_handler;
 
-	return 0;
 }
 
 static void setup_return(struct pt_regs *regs, struct k_sigaction *ka,
@@ -732,10 +528,7 @@ static void setup_return(struct pt_regs *regs, struct k_sigaction *ka,
 {
 	__sigrestore_t sigtramp;
 
-	regs->regs[0] = usig;
-	regs->sp = (unsigned long)user->sigframe;
-	regs->regs[29] = (unsigned long)&user->next_frame->fp;
-	regs->pc = (unsigned long)ka->sa.sa_handler;
+	__setup_return(regs, ka, user, usig);
 
 	if (ka->sa.sa_flags & SA_RESTORER)
 		sigtramp = ka->sa.sa_restorer;
@@ -748,32 +541,7 @@ static void setup_return(struct pt_regs *regs, struct k_sigaction *ka,
 static int setup_rt_frame(int usig, struct ksignal *ksig, sigset_t *set,
 			  struct pt_regs *regs)
 {
-	struct rt_sigframe_user_layout user;
-	struct rt_sigframe __user *frame;
-	int err = 0;
-
-	fpsimd_signal_preserve_current_state();
-
-	if (get_sigframe(&user, ksig, regs))
-		return 1;
-
-	frame = user.sigframe;
-
-	__put_user_error(0, &frame->uc.uc_flags, err);
-	__put_user_error(NULL, &frame->uc.uc_link, err);
-
-	err |= __save_altstack(&frame->uc.uc_stack, regs->sp);
-	err |= setup_sigframe(&user, regs, set);
-	if (err == 0) {
-		setup_return(regs, &ksig->ka, &user, usig);
-		if (ksig->ka.sa.sa_flags & SA_SIGINFO) {
-			err |= copy_siginfo_to_user(&frame->info, &ksig->info);
-			regs->regs[1] = (unsigned long)&frame->info;
-			regs->regs[2] = (unsigned long)&frame->uc;
-		}
-	}
-
-	return err;
+	return __setup_rt_frame(usig, ksig, set, regs);
 }
 
 static void setup_restart_syscall(struct pt_regs *regs)
@@ -802,6 +570,8 @@ static void handle_signal(struct ksignal *ksig, struct pt_regs *regs)
 			ret = a32_setup_rt_frame(usig, ksig, oldset, regs);
 		else
 			ret = a32_setup_frame(usig, ksig, oldset, regs);
+	} else if (is_ilp32_compat_task()) {
+		ret = ilp32_setup_rt_frame(usig, ksig, oldset, regs);
 	} else {
 		ret = setup_rt_frame(usig, ksig, oldset, regs);
 	}
-- 
2.17.0
