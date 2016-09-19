From: Kyle Huey <me-OhBmq/TcCDJWk0Htik3J/w@public.gmane.org>
Subject: [PATCH v4 2/6] x86/arch_prctl/64 Rename do_arch_prctl to do_arch_prctl_64
Date: Sun, 18 Sep 2016 21:17:14 -0700
Message-ID: <20160919041718.4608-3-khuey@kylehuey.com>
References: <20160919041718.4608-1-khuey@kylehuey.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160919041718.4608-1-khuey-OhBmq/TcCDJWk0Htik3J/w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Robert O'Callahan <robert-7ok7fSEJICeEi8DpZVb4nw@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Jeff Dike <jdike-OPE4K8JWMJJBDgjK7y7TUQ@public.gmane.org>, Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>, Dmitry Safonov <dsafonov-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, Dave Hansen <dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Boris Ostrovsky <boris.ostrovsky-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Len Brown <len.brown-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Rafael J . Wysocki" <rafael.j.wysocki-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Srinivas Pandruvada <srinivas.pandruvada-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, user-mode-linux-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, user-mode-linux-user-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

In order to introduce new arch_prctls that are not 64 bit only, rename the
existing 64 bit implementation to do_arch_prctl_64. Also rename the second
argument to arch_prctl, which will no longer always be an address.

Signed-off-by: Kyle Huey <khuey-OhBmq/TcCDJWk0Htik3J/w@public.gmane.org>
---
 arch/x86/include/asm/proto.h |  4 +++-
 arch/x86/kernel/process_64.c | 26 ++++++++++++++------------
 arch/x86/kernel/ptrace.c     |  8 ++++----
 arch/x86/um/syscalls_64.c    |  4 ++--
 4 files changed, 23 insertions(+), 19 deletions(-)

diff --git a/arch/x86/include/asm/proto.h b/arch/x86/include/asm/proto.h
index 9b9b30b..95c3e51 100644
--- a/arch/x86/include/asm/proto.h
+++ b/arch/x86/include/asm/proto.h
@@ -30,6 +30,8 @@ void x86_report_nx(void);
 
 extern int reboot_force;
 
-long do_arch_prctl(struct task_struct *task, int code, unsigned long addr);
+#ifdef CONFIG_X86_64
+long do_arch_prctl_64(struct task_struct *task, int code, unsigned long arg2);
+#endif
 
 #endif /* _ASM_X86_PROTO_H */
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index 4d6363c..292ce48 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -197,7 +197,7 @@ int copy_thread_tls(unsigned long clone_flags, unsigned long sp,
 				(struct user_desc __user *)tls, 0);
 		else
 #endif
-			err = do_arch_prctl(p, ARCH_SET_FS, tls);
+			err = do_arch_prctl_64(p, ARCH_SET_FS, tls);
 		if (err)
 			goto out;
 	}
@@ -525,7 +525,7 @@ void set_personality_ia32(bool x32)
 }
 EXPORT_SYMBOL_GPL(set_personality_ia32);
 
-long do_arch_prctl(struct task_struct *task, int code, unsigned long addr)
+long do_arch_prctl_64(struct task_struct *task, int code, unsigned long arg2)
 {
 	int ret = 0;
 	int doit = task == current;
@@ -533,48 +533,50 @@ long do_arch_prctl(struct task_struct *task, int code, unsigned long addr)
 
 	switch (code) {
 	case ARCH_SET_GS:
-		if (addr >= TASK_SIZE_MAX)
+		if (arg2 >= TASK_SIZE_MAX)
 			return -EPERM;
 		cpu = get_cpu();
 		task->thread.gsindex = 0;
-		task->thread.gsbase = addr;
+		task->thread.gsbase = arg2;
 		if (doit) {
 			load_gs_index(0);
-			ret = wrmsrl_safe(MSR_KERNEL_GS_BASE, addr);
+			ret = wrmsrl_safe(MSR_KERNEL_GS_BASE, arg2);
 		}
 		put_cpu();
 		break;
 	case ARCH_SET_FS:
 		/* Not strictly needed for fs, but do it for symmetry
 		   with gs */
-		if (addr >= TASK_SIZE_MAX)
+		if (arg2 >= TASK_SIZE_MAX)
 			return -EPERM;
 		cpu = get_cpu();
 		task->thread.fsindex = 0;
-		task->thread.fsbase = addr;
+		task->thread.fsbase = arg2;
 		if (doit) {
 			/* set the selector to 0 to not confuse __switch_to */
 			loadsegment(fs, 0);
-			ret = wrmsrl_safe(MSR_FS_BASE, addr);
+			ret = wrmsrl_safe(MSR_FS_BASE, arg2);
 		}
 		put_cpu();
 		break;
 	case ARCH_GET_FS: {
 		unsigned long base;
+
 		if (doit)
 			rdmsrl(MSR_FS_BASE, base);
 		else
 			base = task->thread.fsbase;
-		ret = put_user(base, (unsigned long __user *)addr);
+		ret = put_user(base, (unsigned long __user *)arg2);
 		break;
 	}
 	case ARCH_GET_GS: {
 		unsigned long base;
+
 		if (doit)
 			rdmsrl(MSR_KERNEL_GS_BASE, base);
 		else
 			base = task->thread.gsbase;
-		ret = put_user(base, (unsigned long __user *)addr);
+		ret = put_user(base, (unsigned long __user *)arg2);
 		break;
 	}
 
@@ -586,9 +588,9 @@ long do_arch_prctl(struct task_struct *task, int code, unsigned long addr)
 	return ret;
 }
 
-SYSCALL_DEFINE2(arch_prctl, int, code, unsigned long, addr)
+SYSCALL_DEFINE2(arch_prctl, int, code, unsigned long, arg2)
 {
-	return do_arch_prctl(current, code, addr);
+	return do_arch_prctl_64(current, code, arg2);
 }
 
 unsigned long KSTK_ESP(struct task_struct *task)
diff --git a/arch/x86/kernel/ptrace.c b/arch/x86/kernel/ptrace.c
index f79576a..030cbc5 100644
--- a/arch/x86/kernel/ptrace.c
+++ b/arch/x86/kernel/ptrace.c
@@ -395,12 +395,12 @@ static int putreg(struct task_struct *child,
 		if (value >= TASK_SIZE_MAX)
 			return -EIO;
 		/*
-		 * When changing the segment base, use do_arch_prctl
+		 * When changing the segment base, use do_arch_prctl_64
 		 * to set either thread.fs or thread.fsindex and the
 		 * corresponding GDT slot.
 		 */
 		if (child->thread.fsbase != value)
-			return do_arch_prctl(child, ARCH_SET_FS, value);
+			return do_arch_prctl_64(child, ARCH_SET_FS, value);
 		return 0;
 	case offsetof(struct user_regs_struct,gs_base):
 		/*
@@ -409,7 +409,7 @@ static int putreg(struct task_struct *child,
 		if (value >= TASK_SIZE_MAX)
 			return -EIO;
 		if (child->thread.gsbase != value)
-			return do_arch_prctl(child, ARCH_SET_GS, value);
+			return do_arch_prctl_64(child, ARCH_SET_GS, value);
 		return 0;
 #endif
 	}
@@ -868,7 +868,7 @@ long arch_ptrace(struct task_struct *child, long request,
 		   Works just like arch_prctl, except that the arguments
 		   are reversed. */
 	case PTRACE_ARCH_PRCTL:
-		ret = do_arch_prctl(child, data, addr);
+		ret = do_arch_prctl_64(child, data, addr);
 		break;
 #endif
 
diff --git a/arch/x86/um/syscalls_64.c b/arch/x86/um/syscalls_64.c
index 3282066..acd0922 100644
--- a/arch/x86/um/syscalls_64.c
+++ b/arch/x86/um/syscalls_64.c
@@ -72,9 +72,9 @@ long arch_prctl(struct task_struct *task, int code, unsigned long __user *addr)
 	return ret;
 }
 
-SYSCALL_DEFINE2(arch_prctl, int, code, unsigned long, addr)
+SYSCALL_DEFINE2(arch_prctl, int, code, unsigned long, arg2)
 {
-	return arch_prctl(current, code, (unsigned long __user *) addr);
+	return arch_prctl(current, code, (unsigned long __user *) arg2);
 }
 
 void arch_switch_to(struct task_struct *to)
-- 
2.9.3
