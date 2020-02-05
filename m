From: Yu-cheng Yu <yu-cheng.yu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [RFC PATCH v9 27/27] x86/cet/shstk: Add arch_prctl functions for Shadow Stack
Date: Wed,  5 Feb 2020 10:19:35 -0800
Message-ID: <20200205181935.3712-28-yu-cheng.yu@intel.com>
References: <20200205181935.3712-1-yu-cheng.yu@intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20200205181935.3712-1-yu-cheng.yu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Balbir Singh <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Cyrill Gorcunov <gorcunov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Dave Hansen <dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Eugene Syromiatnikov <esyr-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Florian Weimer <fweimer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H.J. Lu" <hjl.tools-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Jann Horn <jannh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Mike Kravetz <mike.kravetz-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Nadav Amit <nadav.amit-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Yu-cheng Yu <yu-cheng.yu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

arch_prctl(ARCH_X86_CET_STATUS, unsigned long *addr)
    Return CET feature status.

    The parameter 'addr' is a pointer to a user buffer.  On returning to
    the caller, the kernel fills the following information:

    *addr = SHSTK/IBT status
    *(addr + 1) = SHSTK base address
    *(addr + 2) = SHSTK size

arch_prctl(ARCH_X86_CET_DISABLE, unsigned long features)
    Disable CET features specified in 'features'.  Return -EPERM if CET is
    locked.

arch_prctl(ARCH_X86_CET_LOCK)
    Lock in CET feature.

arch_prctl(ARCH_X86_CET_ALLOC_SHSTK, unsigned long *addr)
    Allocate a new SHSTK.

    The parameter 'addr' is a pointer to a user buffer and indicates the
    desired SHSTK size to allocate.  On returning to the caller the buffer
    contains the address of the new SHSTK.

There is no CET enabling arch_prctl function.  By design, CET is enabled
automatically if the binary and the system can support it.

The parameters passed are always unsigned 64-bit.  When an IA32 application
passing pointers, it should only use the lower 32 bits.

Signed-off-by: Yu-cheng Yu <yu-cheng.yu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 arch/x86/include/asm/cet.h        |  4 ++
 arch/x86/include/uapi/asm/prctl.h |  5 ++
 arch/x86/kernel/Makefile          |  2 +-
 arch/x86/kernel/cet.c             | 29 +++++++++++
 arch/x86/kernel/cet_prctl.c       | 84 +++++++++++++++++++++++++++++++
 arch/x86/kernel/process.c         |  4 +-
 6 files changed, 125 insertions(+), 3 deletions(-)
 create mode 100644 arch/x86/kernel/cet_prctl.c

diff --git a/arch/x86/include/asm/cet.h b/arch/x86/include/asm/cet.h
index 9a3e2da9c1c4..b64f6d810ae0 100644
--- a/arch/x86/include/asm/cet.h
+++ b/arch/x86/include/asm/cet.h
@@ -14,16 +14,20 @@ struct sc_ext;
 struct cet_status {
 	unsigned long	shstk_base;
 	unsigned long	shstk_size;
+	unsigned int	locked:1;
 	unsigned int	shstk_enabled:1;
 };
 
 #ifdef CONFIG_X86_INTEL_CET
+int prctl_cet(int option, unsigned long arg2);
 int cet_setup_shstk(void);
 int cet_setup_thread_shstk(struct task_struct *p);
+int cet_alloc_shstk(unsigned long *arg);
 void cet_disable_free_shstk(struct task_struct *p);
 int cet_restore_signal(bool ia32, struct sc_ext *sc);
 int cet_setup_signal(bool ia32, unsigned long rstor, struct sc_ext *sc);
 #else
+static inline int prctl_cet(int option, unsigned long arg2) { return -EINVAL; }
 static inline int cet_setup_thread_shstk(struct task_struct *p) { return 0; }
 static inline void cet_disable_free_shstk(struct task_struct *p) {}
 static inline int cet_restore_signal(bool ia32, struct sc_ext *sc) { return -EINVAL; }
diff --git a/arch/x86/include/uapi/asm/prctl.h b/arch/x86/include/uapi/asm/prctl.h
index 5a6aac9fa41f..d962f0ec9ccf 100644
--- a/arch/x86/include/uapi/asm/prctl.h
+++ b/arch/x86/include/uapi/asm/prctl.h
@@ -14,4 +14,9 @@
 #define ARCH_MAP_VDSO_32	0x2002
 #define ARCH_MAP_VDSO_64	0x2003
 
+#define ARCH_X86_CET_STATUS		0x3001
+#define ARCH_X86_CET_DISABLE		0x3002
+#define ARCH_X86_CET_LOCK		0x3003
+#define ARCH_X86_CET_ALLOC_SHSTK	0x3004
+
 #endif /* _ASM_X86_PRCTL_H */
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index b8c1ea4ab7eb..69a19957e200 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -142,7 +142,7 @@ obj-$(CONFIG_UNWINDER_ORC)		+= unwind_orc.o
 obj-$(CONFIG_UNWINDER_FRAME_POINTER)	+= unwind_frame.o
 obj-$(CONFIG_UNWINDER_GUESS)		+= unwind_guess.o
 
-obj-$(CONFIG_X86_INTEL_CET)		+= cet.o
+obj-$(CONFIG_X86_INTEL_CET)		+= cet.o cet_prctl.o
 
 ###
 # 64 bit specific files
diff --git a/arch/x86/kernel/cet.c b/arch/x86/kernel/cet.c
index 5b45abda80a1..01aa24c40a5d 100644
--- a/arch/x86/kernel/cet.c
+++ b/arch/x86/kernel/cet.c
@@ -145,6 +145,35 @@ static int create_rstor_token(bool ia32, unsigned long ssp,
 	return 0;
 }
 
+int cet_alloc_shstk(unsigned long *arg)
+{
+	unsigned long len = *arg;
+	unsigned long addr;
+	unsigned long token;
+	unsigned long ssp;
+
+	addr = alloc_shstk(len);
+
+	if (IS_ERR((void *)addr))
+		return PTR_ERR((void *)addr);
+
+	/* Restore token is 8 bytes and aligned to 8 bytes */
+	ssp = addr + len;
+	token = ssp;
+
+	if (!in_ia32_syscall())
+		token |= TOKEN_MODE_64;
+	ssp -= 8;
+
+	if (write_user_shstk_64(ssp, token)) {
+		vm_munmap(addr, len);
+		return -EINVAL;
+	}
+
+	*arg = addr;
+	return 0;
+}
+
 int cet_setup_shstk(void)
 {
 	unsigned long addr, size;
diff --git a/arch/x86/kernel/cet_prctl.c b/arch/x86/kernel/cet_prctl.c
new file mode 100644
index 000000000000..6cf8f87e3d98
--- /dev/null
+++ b/arch/x86/kernel/cet_prctl.c
@@ -0,0 +1,84 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+#include <linux/errno.h>
+#include <linux/uaccess.h>
+#include <linux/prctl.h>
+#include <linux/compat.h>
+#include <linux/mman.h>
+#include <linux/elfcore.h>
+#include <asm/processor.h>
+#include <asm/prctl.h>
+#include <asm/cet.h>
+
+/* See Documentation/x86/intel_cet.rst. */
+
+static int handle_get_status(unsigned long arg2)
+{
+	struct cet_status *cet = &current->thread.cet;
+	unsigned int features = 0;
+	unsigned long buf[3];
+
+	if (cet->shstk_enabled)
+		features |= GNU_PROPERTY_X86_FEATURE_1_SHSTK;
+
+	buf[0] = (unsigned long)features;
+	buf[1] = cet->shstk_base;
+	buf[2] = cet->shstk_size;
+	return copy_to_user((unsigned long __user *)arg2, buf,
+			    sizeof(buf));
+}
+
+static int handle_alloc_shstk(unsigned long arg2)
+{
+	int err = 0;
+	unsigned long arg;
+	unsigned long addr = 0;
+	unsigned long size = 0;
+
+	if (get_user(arg, (unsigned long __user *)arg2))
+		return -EFAULT;
+
+	size = arg;
+	err = cet_alloc_shstk(&arg);
+	if (err)
+		return err;
+
+	addr = arg;
+	if (put_user(addr, (unsigned long __user *)arg2)) {
+		vm_munmap(addr, size);
+		return -EFAULT;
+	}
+
+	return 0;
+}
+
+int prctl_cet(int option, unsigned long arg2)
+{
+	struct cet_status *cet = &current->thread.cet;
+
+	if (!cpu_x86_cet_enabled())
+		return -EINVAL;
+
+	switch (option) {
+	case ARCH_X86_CET_STATUS:
+		return handle_get_status(arg2);
+
+	case ARCH_X86_CET_DISABLE:
+		if (cet->locked)
+			return -EPERM;
+		if (arg2 & GNU_PROPERTY_X86_FEATURE_1_SHSTK)
+			cet_disable_free_shstk(current);
+
+		return 0;
+
+	case ARCH_X86_CET_LOCK:
+		cet->locked = 1;
+		return 0;
+
+	case ARCH_X86_CET_ALLOC_SHSTK:
+		return handle_alloc_shstk(arg2);
+
+	default:
+		return -EINVAL;
+	}
+}
diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index 7098618142f2..63dc88070923 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -998,7 +998,7 @@ long do_arch_prctl_common(struct task_struct *task, int option,
 		return get_cpuid_mode();
 	case ARCH_SET_CPUID:
 		return set_cpuid_mode(task, cpuid_enabled);
+	default:
+		return prctl_cet(option, cpuid_enabled);
 	}
-
-	return -EINVAL;
 }
-- 
2.21.0
