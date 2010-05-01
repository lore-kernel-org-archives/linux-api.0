From: Oren Laadan <orenl-eQaUEPhvms7ENvBUuze7eA@public.gmane.org>
Subject: [PATCH v21 010/100] eclone (10/11): Implement sys_eclone for powerpc
Date: Sat,  1 May 2010 10:14:52 -0400
Message-ID: <1272723382-19470-11-git-send-email-orenl@cs.columbia.edu>
References: <1272723382-19470-1-git-send-email-orenl@cs.columbia.edu>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1272723382-19470-1-git-send-email-orenl-eQaUEPhvms7ENvBUuze7eA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Serge Hallyn <serue-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>, Matt Helsley <matthltc-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>, Pavel Emelyanov <xemul-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Nathan Lynch <ntl-e+AXbWqSrlAAvxtiuMwx3w@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-s390-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linuxppc-dev-mnsaURCQ41sdnm+yROfE0A@public.gmane.org
List-Id: linux-api@vger.kernel.org

From: Nathan Lynch <ntl-e+AXbWqSrlAAvxtiuMwx3w@public.gmane.org>

Wired up for both ppc32 and ppc64, but tested only with the latter.

Changelog:
  - Jan 20: (ntl) fix 32-bit build
  - Nov 17: (serge) remove redundant flags_high check, and
    	    don't fold it into flags.

Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-s390-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linuxppc-dev-mnsaURCQ41sdnm+yROfE0A@public.gmane.org
Signed-off-by: Nathan Lynch <ntl-e+AXbWqSrlAAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Serge E. Hallyn <serue-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
---
 arch/powerpc/include/asm/syscalls.h |    6 ++++
 arch/powerpc/include/asm/systbl.h   |    1 +
 arch/powerpc/include/asm/unistd.h   |    3 +-
 arch/powerpc/kernel/entry_32.S      |    8 +++++
 arch/powerpc/kernel/entry_64.S      |    5 +++
 arch/powerpc/kernel/process.c       |   54 ++++++++++++++++++++++++++++++++++-
 6 files changed, 75 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/include/asm/syscalls.h b/arch/powerpc/include/asm/syscalls.h
index 4084e56..920cefd 100644
--- a/arch/powerpc/include/asm/syscalls.h
+++ b/arch/powerpc/include/asm/syscalls.h
@@ -23,6 +23,12 @@ asmlinkage int sys_execve(unsigned long a0, unsigned long a1,
 asmlinkage int sys_clone(unsigned long clone_flags, unsigned long usp,
 		int __user *parent_tidp, void __user *child_threadptr,
 		int __user *child_tidp, int p6, struct pt_regs *regs);
+asmlinkage int sys_eclone(unsigned long flags_low,
+			  struct clone_args __user *args,
+			  size_t args_size,
+			  pid_t __user *pids,
+			  unsigned long p5, unsigned long p6,
+			  struct pt_regs *regs);
 asmlinkage int sys_fork(unsigned long p1, unsigned long p2,
 		unsigned long p3, unsigned long p4, unsigned long p5,
 		unsigned long p6, struct pt_regs *regs);
diff --git a/arch/powerpc/include/asm/systbl.h b/arch/powerpc/include/asm/systbl.h
index a5ee345..f94fc43 100644
--- a/arch/powerpc/include/asm/systbl.h
+++ b/arch/powerpc/include/asm/systbl.h
@@ -326,3 +326,4 @@ SYSCALL_SPU(perf_event_open)
 COMPAT_SYS_SPU(preadv)
 COMPAT_SYS_SPU(pwritev)
 COMPAT_SYS(rt_tgsigqueueinfo)
+PPC_SYS(eclone)
diff --git a/arch/powerpc/include/asm/unistd.h b/arch/powerpc/include/asm/unistd.h
index f0a1026..4cdbd5c 100644
--- a/arch/powerpc/include/asm/unistd.h
+++ b/arch/powerpc/include/asm/unistd.h
@@ -345,10 +345,11 @@
 #define __NR_preadv		320
 #define __NR_pwritev		321
 #define __NR_rt_tgsigqueueinfo	322
+#define __NR_eclone		323
 
 #ifdef __KERNEL__
 
-#define __NR_syscalls		323
+#define __NR_syscalls		324
 
 #define __NR__exit __NR_exit
 #define NR_syscalls	__NR_syscalls
diff --git a/arch/powerpc/kernel/entry_32.S b/arch/powerpc/kernel/entry_32.S
index 1175a85..579f1da 100644
--- a/arch/powerpc/kernel/entry_32.S
+++ b/arch/powerpc/kernel/entry_32.S
@@ -586,6 +586,14 @@ ppc_clone:
 	stw	r0,_TRAP(r1)		/* register set saved */
 	b	sys_clone
 
+	.globl	ppc_eclone
+ppc_eclone:
+	SAVE_NVGPRS(r1)
+	lwz	r0,_TRAP(r1)
+	rlwinm	r0,r0,0,0,30		/* clear LSB to indicate full */
+	stw	r0,_TRAP(r1)		/* register set saved */
+	b	sys_eclone
+
 	.globl	ppc_swapcontext
 ppc_swapcontext:
 	SAVE_NVGPRS(r1)
diff --git a/arch/powerpc/kernel/entry_64.S b/arch/powerpc/kernel/entry_64.S
index 07109d8..b763340 100644
--- a/arch/powerpc/kernel/entry_64.S
+++ b/arch/powerpc/kernel/entry_64.S
@@ -344,6 +344,11 @@ _GLOBAL(ppc_clone)
 	bl	.sys_clone
 	b	syscall_exit
 
+_GLOBAL(ppc_eclone)
+	bl	.save_nvgprs
+	bl	.sys_eclone
+	b	syscall_exit
+
 _GLOBAL(ppc32_swapcontext)
 	bl	.save_nvgprs
 	bl	.compat_sys_swapcontext
diff --git a/arch/powerpc/kernel/process.c b/arch/powerpc/kernel/process.c
index e4d71ce..b183287 100644
--- a/arch/powerpc/kernel/process.c
+++ b/arch/powerpc/kernel/process.c
@@ -961,7 +961,59 @@ int sys_clone(unsigned long clone_flags, unsigned long usp,
 		child_tidp = TRUNC_PTR(child_tidp);
 	}
 #endif
- 	return do_fork(clone_flags, usp, regs, 0, parent_tidp, child_tidp);
+	return do_fork(clone_flags, usp, regs, 0, parent_tidp, child_tidp);
+}
+
+int sys_eclone(unsigned long clone_flags_low,
+	       struct clone_args __user *uclone_args,
+	       size_t size,
+	       pid_t __user *upids,
+	       unsigned long p5, unsigned long p6,
+	       struct pt_regs *regs)
+{
+	struct clone_args kclone_args;
+	unsigned long stack_base;
+	int __user *parent_tidp;
+	int __user *child_tidp;
+	unsigned long stack_sz;
+	unsigned int nr_pids;
+	unsigned long flags;
+	unsigned long usp;
+	int rc;
+
+	CHECK_FULL_REGS(regs);
+
+	rc = fetch_clone_args_from_user(uclone_args, size, &kclone_args);
+	if (rc)
+		return rc;
+
+	stack_sz = kclone_args.child_stack_size;
+	stack_base = kclone_args.child_stack;
+
+	/* powerpc doesn't do anything useful with the stack size */
+	if (stack_sz)
+		return -EINVAL;
+
+	/* Interpret stack_base as the child sp if it is set. */
+	usp = regs->gpr[1];
+	if (stack_base)
+		usp = stack_base;
+
+	flags = clone_flags_low;
+
+	nr_pids = kclone_args.nr_pids;
+
+	parent_tidp = (int __user *)(unsigned long)kclone_args.parent_tid_ptr;
+	child_tidp = (int __user *)(unsigned long)kclone_args.child_tid_ptr;
+
+#ifdef CONFIG_PPC64
+	if (test_thread_flag(TIF_32BIT)) {
+		parent_tidp = TRUNC_PTR(parent_tidp);
+		child_tidp = TRUNC_PTR(child_tidp);
+	}
+#endif
+	return do_fork_with_pids(flags, stack_base, regs, stack_sz,
+				 parent_tidp, child_tidp, nr_pids, upids);
 }
 
 int sys_fork(unsigned long p1, unsigned long p2, unsigned long p3,
-- 
1.6.3.3
