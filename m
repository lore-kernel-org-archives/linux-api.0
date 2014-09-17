From: Richard Larocque <rlarocque@google.com>
Subject: [PATCH] x86/vdso: Add prctl to set per-process VDSO load
Date: Tue, 16 Sep 2014 17:05:51 -0700
Message-ID: <1410912351-31273-1-git-send-email-rlarocque@google.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: mingo@redhat.com, tglx@linutronix.de, hpa@zytor.com, luto@amacapital.net, filbranden@google.com, md@google.com, gthelen@google.com
Cc: x86@kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, Richard Larocque <rlarocque@google.com>
List-Id: linux-api@vger.kernel.org

Adds new prctl calls to enable or disable VDSO loading for a process
and its children.

The PR_SET_DISABLE_VDSO call takes one argument, which is interpreted as
a boolean value.  If true, it disables the loading of the VDSO on exec()
for this process and any children created after this call.  A false
value unsets the flag.

The PR_GET_DISABLE_VDSO option returns a non-negative true value if VDSO
loading has been disabled for this process, zero if it has not been
disabled, and a negative value in case of error.

These prctl calls are hidden behind a new Kconfig,
CONFIG_VDSO_DISABLE_PRCTL.  This feature is available only on x86.

The command line option vdso=0 overrides the behavior of
PR_SET_DISABLE_VDSO, however, PR_GET_DISABLE_VDSO will coninue to return
whetever setting was last set with PR_SET_DISABLE_VDSO.

Signed-off-by: Richard Larocque <rlarocque@google.com>
---
This patch is part of some work to better handle times and CRIU migration.
I suspect that there are other use cases out there, so I'm offering this
patch separately.

When considering CRIU migration and times, we put some thought into how
to handle the rdtsc instruction.  If we migrate between machines or across
reboots, the migrated process will see values that could break its assumptions
about how rdtsc is supposed to work.  To deal with this, we could:
 * let the application handle it
 * ban the instruction (ie. PR_TSC_SIGSEGV), to make sure the application
   doesn't use it by accident
 * trap the instruction then mark the process as "tainted" for migration
   purposes
 * trap the instruction then apply an adjustment to keep values consistent
   across machines
 * do something really crazy involving the VMCS

There's no great option here.  Which one we choose probably depends on
what kind of process is being migrated.

Many of these options involve setting a trap for the rdtsc instruction in the
process, which creates problems for the vDSO.  The vDSO implementations of
clock_gettime() make use of that instruction from userspace.  We can use
workarounds in the kernel to turn the trap into a no-op when it comes from vDSO
code, but that somewhat defeats the purpose of having a vDSO in the first
place.  It was supposed to avoid unnecessary calls to kernel space.  Trapping
its instructions goes against that goal.

So we think it would be nice to disable the vDSO for some processes on a
machine.  This would allow us to implement some of the rdtsc handling options
without having to worry about the vDSO.

We have some additional plans for clock_gettime() and friends that may or
may not depend on disabling the vDSO, but it might be best if we defer that
part of the discussion to the next patch set.  I think this patch and its
use case can stand on their own.

 arch/x86/Kconfig           |  8 ++++++++
 arch/x86/vdso/vma.c        | 18 ++++++++++++++++++
 include/linux/sched.h      |  5 +++++
 include/uapi/linux/prctl.h |  9 +++++++++
 kernel/fork.c              |  4 ++++
 kernel/sys.c               | 16 ++++++++++++++++
 6 files changed, 60 insertions(+)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 3632743..ff54ead 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1875,6 +1875,14 @@ config COMPAT_VDSO
 	  If unsure, say N: if you are compiling your own kernel, you
 	  are unlikely to be using a buggy version of glibc.
 
+config VDSO_DISABLE_PRCTL
+	depends on X86
+	bool "prctl to disable VDSO loading"
+	---help---
+	  Enabling this option adds support for prctl calls that
+	  set and retrieve a per-process flag to disable VDSO loading on
+	  exec() for this process and all of its children.
+
 config CMDLINE_BOOL
 	bool "Built-in kernel command line"
 	---help---
diff --git a/arch/x86/vdso/vma.c b/arch/x86/vdso/vma.c
index 970463b..496c48b 100644
--- a/arch/x86/vdso/vma.c
+++ b/arch/x86/vdso/vma.c
@@ -23,6 +23,15 @@ unsigned int __read_mostly vdso64_enabled = 1;
 extern unsigned short vdso_sync_cpuid;
 #endif
 
+static int vdso_enabled_for_current_process(void)
+{
+#if defined(CONFIG_VDSO_DISABLE_PRCTL)
+	return !current->signal->disable_vdso;
+#else
+	return 1;
+#endif
+}
+
 void __init init_vdso_image(const struct vdso_image *image)
 {
 	int i;
@@ -185,6 +194,9 @@ static int load_vdso32(void)
 	if (vdso32_enabled != 1)  /* Other values all mean "disabled" */
 		return 0;
 
+	if (!vdso_enabled_for_current_process())
+		return 0;
+
 	ret = map_vdso(selected_vdso32, false);
 	if (ret)
 		return ret;
@@ -204,6 +216,9 @@ int arch_setup_additional_pages(struct linux_binprm *bprm, int uses_interp)
 	if (!vdso64_enabled)
 		return 0;
 
+	if (!vdso_enabled_for_current_process())
+		return 0;
+
 	return map_vdso(&vdso_image_64, true);
 }
 
@@ -216,6 +231,9 @@ int compat_arch_setup_additional_pages(struct linux_binprm *bprm,
 		if (!vdso64_enabled)
 			return 0;
 
+		if (!vdso_enabled_for_current_process())
+			return 0;
+
 		return map_vdso(&vdso_image_x32, true);
 	}
 #endif
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 5c2c885..37f6a7a 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -708,6 +708,11 @@ struct signal_struct {
 	struct mutex cred_guard_mutex;	/* guard against foreign influences on
 					 * credential calculations
 					 * (notably. ptrace) */
+
+#ifdef CONFIG_VDSO_DISABLE_PRCTL
+	unsigned int disable_vdso;     /* If true, prevents loading of VDSO on
+					  next exec() */
+#endif
 };
 
 /*
diff --git a/include/uapi/linux/prctl.h b/include/uapi/linux/prctl.h
index 58afc04..3dbbeda 100644
--- a/include/uapi/linux/prctl.h
+++ b/include/uapi/linux/prctl.h
@@ -152,4 +152,13 @@
 #define PR_SET_THP_DISABLE	41
 #define PR_GET_THP_DISABLE	42
 
+/*
+ * These can be used to flag a process so that neither it nor its children will
+ * receive VDSO mappings on their next exec() call.
+ */
+#define PR_SET_VDSO		43
+#define PR_GET_VDSO		44
+# define PR_VDSO_DISABLE	0	/* prevent loading of VDSO on exec() */
+# define PR_VDSO_ENABLE		1	/* allow loading of VDSO on exec() */
+
 #endif /* _LINUX_PRCTL_H */
diff --git a/kernel/fork.c b/kernel/fork.c
index 0cf9cdb..11ede19 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1091,6 +1091,10 @@ static int copy_signal(unsigned long clone_flags, struct task_struct *tsk)
 	sig->has_child_subreaper = current->signal->has_child_subreaper ||
 				   current->signal->is_child_subreaper;
 
+#ifdef CONFIG_VDSO_DISABLE_PRCTL
+	sig->disable_vdso = current->signal->disable_vdso;
+#endif
+
 	mutex_init(&sig->cred_guard_mutex);
 
 	return 0;
diff --git a/kernel/sys.c b/kernel/sys.c
index ce81291..eb94a96 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -2011,6 +2011,22 @@ SYSCALL_DEFINE5(prctl, int, option, unsigned long, arg2, unsigned long, arg3,
 			me->mm->def_flags &= ~VM_NOHUGEPAGE;
 		up_write(&me->mm->mmap_sem);
 		break;
+#ifdef CONFIG_VDSO_DISABLE_PRCTL
+	case PR_SET_VDSO:
+		if (arg2 == PR_VDSO_ENABLE)
+			me->signal->disable_vdso = 0;
+		else if (arg2 == PR_VDSO_DISABLE)
+			me->signal->disable_vdso = 1;
+		else
+			return -EINVAL;
+		break;
+	case PR_GET_VDSO:
+		if (!me->signal->disable_vdso)
+			error = put_user(PR_VDSO_ENABLE, (int __user *)arg2);
+		else
+			error = put_user(PR_VDSO_DISABLE, (int __user *)arg2);
+		break;
+#endif
 	default:
 		error = -EINVAL;
 		break;
-- 
2.1.0.rc2.206.gedb03e5
