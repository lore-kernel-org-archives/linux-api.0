From: Dmitry Safonov <dima@arista.com>
Subject: [PATCHv7 20/33] x86/vdso: Provide vdso_data offset on vvar_page
Date: Fri, 11 Oct 2019 02:23:28 +0100
Message-ID: <20191011012341.846266-21-dima@arista.com>
References: <20191011012341.846266-1-dima@arista.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20191011012341.846266-1-dima@arista.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Dmitry Safonov <0x7f454c46@gmail.com>, Dmitry Safonov <dima@arista.com>, Adrian Reber <adrian@lisas.de>, Andrei Vagin <avagin@openvz.org>, Andy Lutomirski <luto@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Christian Brauner <christian.brauner@ubuntu.com>, Cyrill Gorcunov <gorcunov@openvz.org>, "Eric W. Biederman" <ebiederm@xmission.com>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Jann Horn <jannh@google.com>, Jeff Dike <jdike@addtoit.com>, Oleg Nesterov <oleg@redhat.com>, Pavel Emelyanov <xemul@virtuozzo.com>, Shuah Khan <shuah@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Vincenzo Frascino <vincenzo.frascino@arm.com>, containers@lists.linux-foundation.org, criu@openvz.org, linux-api@vger.kernel.org, x86@kernel.org
List-Id: linux-api@vger.kernel.org

VDSO support for Time namespace needs to set up a page with the same
layout as VVAR. That timens page will be placed on position of VVAR page
inside namespace. That page has vdso_data->seq set to 1 to enforce
the slow path and vdso_data->clock_mode set to VCLOCK_TIMENS to enforce
the time namespace handling path.

To prepare timens page kernel needs to know the vdso_data offset.
Provide arch_get_vdso_data() helper for locating vdso_data on VVAR page.

Co-developed-by: Andrei Vagin <avagin@openvz.org>
Signed-off-by: Andrei Vagin <avagin@openvz.org>
Signed-off-by: Dmitry Safonov <dima@arista.com>
---
 arch/x86/entry/vdso/vdso-layout.lds.S |  2 --
 arch/x86/entry/vdso/vma.c             | 11 +++++++++++
 arch/x86/include/asm/vvar.h           |  8 ++++----
 arch/x86/kernel/vmlinux.lds.S         |  4 +---
 include/linux/time_namespace.h        |  1 +
 5 files changed, 17 insertions(+), 9 deletions(-)

diff --git a/arch/x86/entry/vdso/vdso-layout.lds.S b/arch/x86/entry/vdso/vdso-layout.lds.S
index 93c6dc7812d0..2330daad67c3 100644
--- a/arch/x86/entry/vdso/vdso-layout.lds.S
+++ b/arch/x86/entry/vdso/vdso-layout.lds.S
@@ -21,9 +21,7 @@ SECTIONS
 
 	/* Place all vvars at the offsets in asm/vvar.h. */
 #define EMIT_VVAR(name, offset) vvar_ ## name = vvar_page + offset;
-#define __VVAR_KERNEL_LDS
 #include <asm/vvar.h>
-#undef __VVAR_KERNEL_LDS
 #undef EMIT_VVAR
 
 	pvclock_page = vvar_start + PAGE_SIZE;
diff --git a/arch/x86/entry/vdso/vma.c b/arch/x86/entry/vdso/vma.c
index 000db8282cc8..5dab706aca2e 100644
--- a/arch/x86/entry/vdso/vma.c
+++ b/arch/x86/entry/vdso/vma.c
@@ -24,6 +24,17 @@
 #include <asm/cpufeature.h>
 #include <clocksource/hyperv_timer.h>
 
+#undef _ASM_X86_VVAR_H
+#define EMIT_VVAR(name, offset)	\
+	const size_t name ## _offset = offset;
+#include <asm/vvar.h>
+
+struct vdso_data *arch_get_vdso_data(void *vvar_page)
+{
+	return (struct vdso_data *)(vvar_page + _vdso_data_offset);
+}
+#undef EMIT_VVAR
+
 #if defined(CONFIG_X86_64)
 unsigned int __read_mostly vdso64_enabled = 1;
 #endif
diff --git a/arch/x86/include/asm/vvar.h b/arch/x86/include/asm/vvar.h
index 32f5d9a0b90e..ff2de3025388 100644
--- a/arch/x86/include/asm/vvar.h
+++ b/arch/x86/include/asm/vvar.h
@@ -19,10 +19,10 @@
 #ifndef _ASM_X86_VVAR_H
 #define _ASM_X86_VVAR_H
 
-#if defined(__VVAR_KERNEL_LDS)
-
-/* The kernel linker script defines its own magic to put vvars in the
- * right place.
+#ifdef EMIT_VVAR
+/*
+ * EMIT_VVAR() is used by the kernel linker script to put vvars in the
+ * right place. Also, it's used by kernel code to import offsets values.
  */
 #define DECLARE_VVAR(offset, type, name) \
 	EMIT_VVAR(name, offset)
diff --git a/arch/x86/kernel/vmlinux.lds.S b/arch/x86/kernel/vmlinux.lds.S
index e2feacf921a0..ca02d0d301cd 100644
--- a/arch/x86/kernel/vmlinux.lds.S
+++ b/arch/x86/kernel/vmlinux.lds.S
@@ -195,12 +195,10 @@ SECTIONS
 		__vvar_beginning_hack = .;
 
 		/* Place all vvars at the offsets in asm/vvar.h. */
-#define EMIT_VVAR(name, offset) 			\
+#define EMIT_VVAR(name, offset)				\
 		. = __vvar_beginning_hack + offset;	\
 		*(.vvar_ ## name)
-#define __VVAR_KERNEL_LDS
 #include <asm/vvar.h>
-#undef __VVAR_KERNEL_LDS
 #undef EMIT_VVAR
 
 		/*
diff --git a/include/linux/time_namespace.h b/include/linux/time_namespace.h
index 9a77d3854830..772911945944 100644
--- a/include/linux/time_namespace.h
+++ b/include/linux/time_namespace.h
@@ -37,6 +37,7 @@ extern struct time_namespace *copy_time_ns(unsigned long flags,
 	struct user_namespace *user_ns, struct time_namespace *old_ns);
 extern void free_time_ns(struct kref *kref);
 extern int timens_on_fork(struct nsproxy *nsproxy, struct task_struct *tsk);
+extern struct vdso_data *arch_get_vdso_data(void *vvar_page);
 
 static inline void put_time_ns(struct time_namespace *ns)
 {
-- 
2.23.0
