From: Kyle Huey <me@kylehuey.com>
Subject: [PATCH v6 4/6] x86/syscalls/32: Wire up arch_prctl on x86-32
Date: Mon, 26 Sep 2016 14:53:16 -0700
Message-ID: <20160926215318.9587-5-khuey@kylehuey.com>
References: <20160926215318.9587-1-khuey@kylehuey.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160926215318.9587-1-khuey@kylehuey.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Robert O'Callahan <robert@ocallahan.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, x86@kernel.org, Jeff Dike <jdike@addtoit.com>, Richard Weinberger <richard@nod.at>, Andy Lutomirski <luto@kernel.org>, Borislav Petkov <bp@suse.de>, Dmitry Safonov <dsafonov@virtuozzo.com>, Dave Hansen <dave.hansen@linux.intel.com>, Peter Zijlstra <peterz@infradead.org>, Boris Ostrovsky <boris.ostrovsky@oracle.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Shuah Khan <shuah@kernel.org>, Len Brown <len.brown@intel.com>, "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>, Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, user-mode-linux-devel@lists.sourceforge.net, user-mode-linux-user@lists.sourceforge.net, linux-kselftest@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Hook up arch_prctl to call do_arch_prctl on x86-32, and in 32 bit compat
mode on x86-64. This allows us to have arch_prctls that are not specific to
64 bits.

On UML, simply stub out this syscall.

Signed-off-by: Kyle Huey <khuey@kylehuey.com>
---
 arch/x86/entry/syscalls/syscall_32.tbl | 1 +
 arch/x86/kernel/process_32.c           | 7 +++++++
 arch/x86/kernel/process_64.c           | 7 +++++++
 arch/x86/um/Makefile                   | 2 +-
 arch/x86/um/syscalls_32.c              | 7 +++++++
 include/linux/compat.h                 | 2 ++
 6 files changed, 25 insertions(+), 1 deletion(-)
 create mode 100644 arch/x86/um/syscalls_32.c

diff --git a/arch/x86/entry/syscalls/syscall_32.tbl b/arch/x86/entry/syscalls/syscall_32.tbl
index f848572..300fdf8 100644
--- a/arch/x86/entry/syscalls/syscall_32.tbl
+++ b/arch/x86/entry/syscalls/syscall_32.tbl
@@ -386,3 +386,4 @@
 377	i386	copy_file_range		sys_copy_file_range
 378	i386	preadv2			sys_preadv2			compat_sys_preadv2
 379	i386	pwritev2		sys_pwritev2			compat_sys_pwritev2
+380	i386	arch_prctl		sys_arch_prctl			compat_sys_arch_prctl
diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
index d86be29..d3b9dd6 100644
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -35,6 +35,7 @@
 #include <linux/uaccess.h>
 #include <linux/io.h>
 #include <linux/kdebug.h>
+#include <linux/syscalls.h>
 
 #include <asm/pgtable.h>
 #include <asm/ldt.h>
@@ -54,6 +55,7 @@
 #include <asm/debugreg.h>
 #include <asm/switch_to.h>
 #include <asm/vm86.h>
+#include <asm/proto.h>
 
 asmlinkage void ret_from_fork(void) __asm__("ret_from_fork");
 asmlinkage void ret_from_kernel_thread(void) __asm__("ret_from_kernel_thread");
@@ -316,3 +318,8 @@ __switch_to(struct task_struct *prev_p, struct task_struct *next_p)
 
 	return prev_p;
 }
+
+SYSCALL_DEFINE2(arch_prctl, int, code, unsigned long, arg2)
+{
+	return do_arch_prctl_common(current, code, arg2);
+}
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index 0e44608..83b3da4 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -599,6 +599,13 @@ SYSCALL_DEFINE2(arch_prctl, int, code, unsigned long, arg2)
 	return ret;
 }
 
+#ifdef CONFIG_IA32_EMULATION
+COMPAT_SYSCALL_DEFINE2(arch_prctl, int, code, unsigned long, arg2)
+{
+	return do_arch_prctl_common(current, code, arg2);
+}
+#endif
+
 unsigned long KSTK_ESP(struct task_struct *task)
 {
 	return task_pt_regs(task)->sp;
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
index 0000000..ccf0598
--- /dev/null
+++ b/arch/x86/um/syscalls_32.c
@@ -0,0 +1,7 @@
+#include <linux/syscalls.h>
+#include <os.h>
+
+SYSCALL_DEFINE2(arch_prctl, int, code, unsigned long, arg2)
+{
+	return -EINVAL;
+}
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
