From: =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>
Subject: [PATCH v1 3/4] um: Add full asm/syscall.h support
Date: Mon, 21 Dec 2015 01:03:28 +0100
Message-ID: <1450656209-2676-4-git-send-email-mic@digikod.net>
References: <1450656209-2676-1-git-send-email-mic@digikod.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <1450656209-2676-1-git-send-email-mic@digikod.net>
Sender: linux-doc-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>, Jonathan Corbet <corbet@lwn.net>, Jeff Dike <jdike@addtoit.com>, Richard Weinberger <richard@nod.at>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, x86@kernel.org, Kees Cook <keescook@chromium.org>, Andy Lutomirski <luto@amacapital.net>, Will Drewry <wad@chromium.org>, Shuah Khan <shuahkh@osg.samsung.com>, Chris Metcalf <cmetcalf@ezchip.com>, Michael Ellerman <mpe@ellerman.id.au>, Andrew Morton <akpm@linux-foundation.org>, James Hogan <james.hogan@imgtec.com>, Thomas Meyer <thomas@m3y3r.de>, Nicolas Iooss <nicolas.iooss_linux@m4x.org>, Anton Ivanov <aivanov@brocade.com>, linux-doc@vger.kernel.org, user-mode-linux-devel@lists.sourceforge.net, user-mode-linux-user@lists.sourceforge.net, linux-api@vger.kernel.org, Meredydd Luff <meredydd@senatehouse.o>
List-Id: linux-api@vger.kernel.org

Add subarchitecture-independent implementation of asm-generic/syscall.h
allowing access to user system call parameters and results:
* syscall_get_nr()
* syscall_rollback()
* syscall_get_error()
* syscall_get_return_value()
* syscall_set_return_value()
* syscall_get_arguments()
* syscall_set_arguments()
* syscall_get_arch() provided by arch/x86/um/asm/syscall.h

This provides the necessary syscall helpers needed by
HAVE_ARCH_SECCOMP_FILTER plus syscall_get_error().

This is inspired from Meredydd Luff's patch
(https://gerrit.chromium.org/gerrit/21425).

Signed-off-by: Micka=C3=ABl Sala=C3=BCn <mic@digikod.net>
Cc: Jeff Dike <jdike@addtoit.com>
Cc: Richard Weinberger <richard@nod.at>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: x86@kernel.org
Cc: Kees Cook <keescook@chromium.org>
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Will Drewry <wad@chromium.org>
Cc: linux-kernel@vger.kernel.org
Cc: user-mode-linux-devel@lists.sourceforge.net
Cc: user-mode-linux-user@lists.sourceforge.net
Cc: Meredydd Luff <meredydd@senatehouse.org>
Cc: David Drysdale <drysdale@google.com>
---
 arch/um/include/asm/syscall-generic.h | 138 ++++++++++++++++++++++++++=
++++++++
 arch/x86/um/asm/syscall.h             |   1 +
 2 files changed, 139 insertions(+)
 create mode 100644 arch/um/include/asm/syscall-generic.h

diff --git a/arch/um/include/asm/syscall-generic.h b/arch/um/include/as=
m/syscall-generic.h
new file mode 100644
index 0000000..9fb9cf8
--- /dev/null
+++ b/arch/um/include/asm/syscall-generic.h
@@ -0,0 +1,138 @@
+/*
+ * Access to user system call parameters and results
+ *
+ * See asm-generic/syscall.h for function descriptions.
+ *
+ * Copyright (C) 2015 Micka=C3=ABl Sala=C3=BCn <mic@digikod.net>
+ *
+ * This program is free software; you can redistribute it and/or modif=
y
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef __UM_SYSCALL_GENERIC_H
+#define __UM_SYSCALL_GENERIC_H
+
+#include <asm/ptrace.h>
+#include <linux/err.h>
+#include <linux/sched.h>
+#include <sysdep/ptrace.h>
+
+static inline int syscall_get_nr(struct task_struct *task, struct pt_r=
egs *regs)
+{
+
+	return PT_REGS_SYSCALL_NR(regs);
+}
+
+static inline void syscall_rollback(struct task_struct *task,
+				    struct pt_regs *regs)
+{
+	/* do nothing */
+}
+
+static inline long syscall_get_error(struct task_struct *task,
+				     struct pt_regs *regs)
+{
+	const long error =3D regs_return_value(regs);
+
+	return IS_ERR_VALUE(error) ? error : 0;
+}
+
+static inline long syscall_get_return_value(struct task_struct *task,
+					    struct pt_regs *regs)
+{
+	return regs_return_value(regs);
+}
+
+static inline void syscall_set_return_value(struct task_struct *task,
+					    struct pt_regs *regs,
+					    int error, long val)
+{
+	PT_REGS_SET_SYSCALL_RETURN(regs, (long) error ?: val);
+}
+
+static inline void syscall_get_arguments(struct task_struct *task,
+					 struct pt_regs *regs,
+					 unsigned int i, unsigned int n,
+					 unsigned long *args)
+{
+	const struct uml_pt_regs *r =3D &regs->regs;
+
+	switch (i) {
+	case 0:
+		if (!n--)
+			break;
+		*args++ =3D UPT_SYSCALL_ARG1(r);
+	case 1:
+		if (!n--)
+			break;
+		*args++ =3D UPT_SYSCALL_ARG2(r);
+	case 2:
+		if (!n--)
+			break;
+		*args++ =3D UPT_SYSCALL_ARG3(r);
+	case 3:
+		if (!n--)
+			break;
+		*args++ =3D UPT_SYSCALL_ARG4(r);
+	case 4:
+		if (!n--)
+			break;
+		*args++ =3D UPT_SYSCALL_ARG5(r);
+	case 5:
+		if (!n--)
+			break;
+		*args++ =3D UPT_SYSCALL_ARG6(r);
+	case 6:
+		if (!n--)
+			break;
+	default:
+		BUG();
+		break;
+	}
+}
+
+static inline void syscall_set_arguments(struct task_struct *task,
+					 struct pt_regs *regs,
+					 unsigned int i, unsigned int n,
+					 const unsigned long *args)
+{
+	struct uml_pt_regs *r =3D &regs->regs;
+
+	switch (i) {
+	case 0:
+		if (!n--)
+			break;
+		UPT_SYSCALL_ARG1(r) =3D *args++;
+	case 1:
+		if (!n--)
+			break;
+		UPT_SYSCALL_ARG2(r) =3D *args++;
+	case 2:
+		if (!n--)
+			break;
+		UPT_SYSCALL_ARG3(r) =3D *args++;
+	case 3:
+		if (!n--)
+			break;
+		UPT_SYSCALL_ARG4(r) =3D *args++;
+	case 4:
+		if (!n--)
+			break;
+		UPT_SYSCALL_ARG5(r) =3D *args++;
+	case 5:
+		if (!n--)
+			break;
+		UPT_SYSCALL_ARG6(r) =3D *args++;
+	case 6:
+		if (!n--)
+			break;
+	default:
+		BUG();
+		break;
+	}
+}
+
+/* See arch/x86/um/asm/syscall.h for syscall_get_arch() definition. */
+
+#endif	/* __UM_SYSCALL_GENERIC_H */
diff --git a/arch/x86/um/asm/syscall.h b/arch/x86/um/asm/syscall.h
index 81d6562..11ab90d 100644
--- a/arch/x86/um/asm/syscall.h
+++ b/arch/x86/um/asm/syscall.h
@@ -1,6 +1,7 @@
 #ifndef __UM_ASM_SYSCALL_H
 #define __UM_ASM_SYSCALL_H
=20
+#include <asm/syscall-generic.h>
 #include <uapi/linux/audit.h>
=20
 typedef asmlinkage long (*sys_call_ptr_t)(unsigned long, unsigned long=
,
--=20
2.6.4

