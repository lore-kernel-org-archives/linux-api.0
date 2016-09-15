From: Kyle Huey <me@kylehuey.com>
Subject: [PATCH v3 1/3] syscalls,x86 Expose arch_prctl on x86-32.
Date: Thu, 15 Sep 2016 16:33:22 -0700
Message-ID: <20160915233324.6060-2-khuey@kylehuey.com>
References: <20160915233324.6060-1-khuey@kylehuey.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160915233324.6060-1-khuey@kylehuey.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Robert O'Callahan <robert@ocallahan.org>
Cc: linux-kernel@vger.kernel.org, Dave Hansen <dave.hansen@linux.intel.com>, Andy Lutomirski <luto@amacapital.net>, Dmitry Safonov <0x7f454c46@gmail.com>, Borislav Petkov <bp@suse.de>, linux-api@vger.kernel.org, xen-devel@lists.xenproject.org, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, "maintainer:X86 ARCHITECTURE 32-BIT AND 64-BIT" <x86@kernel.org>, Jeff Dike <jdike@addtoit.com>, Richard Weinberger <richard@nod.at>, Al Viro <viro@zeniv.linux.org.uk>, David Howells <dhowells@redhat.com>, Anna Schumaker <Anna.Schumaker@Netapp.com>, Andy Lutomirski <luto@kernel.org>, Zach Brown <zab@redhat.com>, Eric B Munson <emunson@akamai.com>, "Dmitry V. Levin" <ldv@altlinux.org>, Peter Zijlstra <pete>
List-Id: linux-api@vger.kernel.org

arch_prctl is currently 64-bit only. Wire it up for 32-bits, as a no-op for
now. Rename the second arg to a more generic name.

Signed-off-by: Kyle Huey <khuey@kylehuey.com>
---
 arch/x86/entry/syscalls/syscall_32.tbl |  1 +
 arch/x86/include/asm/proto.h           |  5 ++++-
 arch/x86/kernel/process.c              | 10 ++++++++++
 arch/x86/kernel/process_64.c           | 33 +++++++++++++++++++++------------
 arch/x86/kernel/ptrace.c               |  8 ++++----
 arch/x86/um/Makefile                   |  2 +-
 arch/x86/um/syscalls_32.c              |  7 +++++++
 arch/x86/um/syscalls_64.c              |  4 ++--
 include/linux/compat.h                 |  2 ++
 9 files changed, 52 insertions(+), 20 deletions(-)
 create mode 100644 arch/x86/um/syscalls_32.c

diff --git a/arch/x86/entry/syscalls/syscall_32.tbl b/arch/x86/entry/syscalls/syscall_32.tbl
index f848572..666fa61 100644
--- a/arch/x86/entry/syscalls/syscall_32.tbl
+++ b/arch/x86/entry/syscalls/syscall_32.tbl
@@ -386,3 +386,4 @@
 377	i386	copy_file_range		sys_copy_file_range
 378	i386	preadv2			sys_preadv2			compat_sys_preadv2
 379	i386	pwritev2		sys_pwritev2			compat_sys_pwritev2
+380	i386	arch_prctl		compat_sys_arch_prctl		compat_sys_arch_prctl
diff --git a/arch/x86/include/asm/proto.h b/arch/x86/include/asm/proto.h
index 9b9b30b..f0e86aa 100644
--- a/arch/x86/include/asm/proto.h
+++ b/arch/x86/include/asm/proto.h
@@ -30,6 +30,9 @@ void x86_report_nx(void);
 
 extern int reboot_force;
 
-long do_arch_prctl(struct task_struct *task, int code, unsigned long addr);
+long do_arch_prctl_common(struct task_struct *task, int code, unsigned long addr);
+#ifdef CONFIG_X86_64
+long do_arch_prctl_64(struct task_struct *task, int code, unsigned long addr);
+#endif
 
 #endif /* _ASM_X86_PROTO_H */
diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index 62c0b0e..1421451 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -567,3 +567,13 @@ unsigned long get_wchan(struct task_struct *p)
 	} while (count++ < 16 && p->state != TASK_RUNNING);
 	return 0;
 }
+
+long do_arch_prctl_common(struct task_struct *task, int code, unsigned long arg2)
+{
+	return -EINVAL;
+}
+
+asmlinkage long compat_sys_arch_prctl(int code, unsigned long arg2)
+{
+	return do_arch_prctl_common(current, code, arg2);
+}
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index 63236d8..0e44608 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -35,6 +35,7 @@
 #include <linux/uaccess.h>
 #include <linux/io.h>
 #include <linux/ftrace.h>
+#include <linux/syscalls.h>
 
 #include <asm/pgtable.h>
 #include <asm/processor.h>
@@ -196,7 +197,7 @@ int copy_thread_tls(unsigned long clone_flags, unsigned long sp,
 				(struct user_desc __user *)tls, 0);
 		else
 #endif
-			err = do_arch_prctl(p, ARCH_SET_FS, tls);
+			err = do_arch_prctl_64(p, ARCH_SET_FS, tls);
 		if (err)
 			goto out;
 	}
@@ -524,7 +525,7 @@ void set_personality_ia32(bool x32)
 }
 EXPORT_SYMBOL_GPL(set_personality_ia32);
 
-long do_arch_prctl(struct task_struct *task, int code, unsigned long addr)
+long do_arch_prctl_64(struct task_struct *task, int code, unsigned long arg2)
 {
 	int ret = 0;
 	int doit = task == current;
@@ -532,48 +533,50 @@ long do_arch_prctl(struct task_struct *task, int code, unsigned long addr)
 
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
 
@@ -585,9 +588,15 @@ long do_arch_prctl(struct task_struct *task, int code, unsigned long addr)
 	return ret;
 }
 
-long sys_arch_prctl(int code, unsigned long addr)
+SYSCALL_DEFINE2(arch_prctl, int, code, unsigned long, arg2)
 {
-	return do_arch_prctl(current, code, addr);
+	long ret;
+
+	ret = do_arch_prctl_64(current, code, arg2);
+	if (ret == -EINVAL)
+		ret = do_arch_prctl_common(current, code, arg2);
+
+	return ret;
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
 
diff --git a/arch/x86/um/Makefile b/arch/x86/um/Makefile
index 3ee2bb6..5e039d6 100644
--- a/arch/x86/um/Makefile
+++ b/arch/x86/um/Makefile
@@ -16,7 +16,7 @@ obj-y = bug.o bugs_$(BITS).o delay.o fault.o ksyms.o ldt.o \
 
 ifeq ($(CONFIG_X86_32),y)
 
-obj-y += checksum_32.o
+obj-y += checksum_32.o syscalls_32.o
 obj-$(CONFIG_ELF_CORE) += elfcore.o
 
 subarch-y = ../lib/string_32.o ../lib/atomic64_32.o ../lib/atomic64_cx8_32.o
diff --git a/arch/x86/um/syscalls_32.c b/arch/x86/um/syscalls_32.c
new file mode 100644
index 0000000..c6812c1
--- /dev/null
+++ b/arch/x86/um/syscalls_32.c
@@ -0,0 +1,7 @@
+#include <linux/syscalls.h>
+#include <os.h>
+
+long compat_sys_arch_prctl(int code, unsigned long arg2)
+{
+	return -EINVAL;
+}
diff --git a/arch/x86/um/syscalls_64.c b/arch/x86/um/syscalls_64.c
index e655227..d0a7160 100644
--- a/arch/x86/um/syscalls_64.c
+++ b/arch/x86/um/syscalls_64.c
@@ -72,9 +72,9 @@ long arch_prctl(struct task_struct *task, int code, unsigned long __user *addr)
 	return ret;
 }
 
-long sys_arch_prctl(int code, unsigned long addr)
+long sys_arch_prctl(int code, unsigned long arg2)
 {
-	return arch_prctl(current, code, (unsigned long __user *) addr);
+	return arch_prctl(current, code, (unsigned long __user *) arg2);
 }
 
 void arch_switch_to(struct task_struct *to)
diff --git a/include/linux/compat.h b/include/linux/compat.h
index f964ef7..0039d53 100644
--- a/include/linux/compat.h
+++ b/include/linux/compat.h
@@ -722,6 +722,8 @@ asmlinkage long compat_sys_sched_rr_get_interval(compat_pid_t pid,
 asmlinkage long compat_sys_fanotify_mark(int, unsigned int, __u32, __u32,
 					    int, const char __user *);
 
+asmlinkage long compat_sys_arch_prctl(int, unsigned long);
+
 /*
  * For most but not all architectures, "am I in a compat syscall?" and
  * "am I a compat task?" are the same question.  For architectures on which
-- 
2.9.3

base-commit: 4cea8776571b18db7485930cb422faa739580c8c
