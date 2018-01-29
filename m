From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [PATCH for 4.16 v3 07/11] x86: Implement sync_core_before_usermode
Date: Mon, 29 Jan 2018 15:20:16 -0500
Message-ID: <20180129202020.8515-8-mathieu.desnoyers@efficios.com>
References: <20180129202020.8515-1-mathieu.desnoyers@efficios.com>
Return-path: <linux-arch-owner@vger.kernel.org>
In-Reply-To: <20180129202020.8515-1-mathieu.desnoyers@efficios.com>
Sender: linux-arch-owner@vger.kernel.org
To: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Andy Lutomirski <luto@kernel.org>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Andrew Hunter <ahh@google.com>, Maged Michael <maged.michael@gmail.com>, Avi Kivity <avi@scylladb.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Paul Mackerras <paulus@samba.org>, Michael Ellerman <mpe@ellerman.id.au>, Dave Watson <davejwatson@fb.com>, "H . Peter Anvin" <hpa@zytor.com>, Andrea Parri <parri.andrea@gmail.com>, Russell King <linux@armlinux.org.uk>, Greg Hackmann <ghackmann@google.com>, Will Deacon <will.deacon@arm.com>, David Sehr <sehr@google.com>, Linus Torvalds <torvalds@linux-foundation.org>, x86@kernel.org, Mathieu Desnoyers <mathieu.desnoy>
List-Id: linux-api@vger.kernel.org

Ensure that a core serializing instruction is issued before returning to
user-mode. x86 implements return to user-space through sysexit, sysrel,
and sysretq, which are not core serializing.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: Andy Lutomirski <luto@kernel.org>
CC: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
CC: Boqun Feng <boqun.feng@gmail.com>
CC: Andrew Hunter <ahh@google.com>
CC: Maged Michael <maged.michael@gmail.com>
CC: Avi Kivity <avi@scylladb.com>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: Paul Mackerras <paulus@samba.org>
CC: Michael Ellerman <mpe@ellerman.id.au>
CC: Dave Watson <davejwatson@fb.com>
CC: Ingo Molnar <mingo@redhat.com>
CC: "H. Peter Anvin" <hpa@zytor.com>
CC: Andrea Parri <parri.andrea@gmail.com>
CC: Russell King <linux@armlinux.org.uk>
CC: Greg Hackmann <ghackmann@google.com>
CC: Will Deacon <will.deacon@arm.com>
CC: David Sehr <sehr@google.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>
CC: Arnd Bergmann <arnd@arndb.de>
CC: x86@kernel.org
CC: linux-arch@vger.kernel.org
---
Changes since v1:
- Fix prototype of sync_core_before_usermode in generic code (missing
  return type).
- Add linux/processor.h include to sched/core.c.
- Add ARCH_HAS_SYNC_CORE_BEFORE_USERMODE to init/Kconfig.
- Fix linux/processor.h ifdef to target
  CONFIG_ARCH_HAS_SYNC_CORE_BEFORE_USERMODE rather than
  ARCH_HAS_SYNC_CORE_BEFORE_USERMODE.
- Move empty static inline in processor.h to generic patch.

Changes since v2:
- Introduce arch/x86/include/asm/sync_core.h
- Don't sync_core when KPTI is enabled, and when invoked from irq and nmi
  context.
- Note: v2 was reviewed by Thomas Gleixner, but changes were introduced
  since.
---
 arch/x86/Kconfig                 |  1 +
 arch/x86/include/asm/sync_core.h | 28 ++++++++++++++++++++++++++++
 2 files changed, 29 insertions(+)
 create mode 100644 arch/x86/include/asm/sync_core.h

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 20da391b5f32..0b44c8dd0e95 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -61,6 +61,7 @@ config X86
 	select ARCH_HAS_SG_CHAIN
 	select ARCH_HAS_STRICT_KERNEL_RWX
 	select ARCH_HAS_STRICT_MODULE_RWX
+	select ARCH_HAS_SYNC_CORE_BEFORE_USERMODE
 	select ARCH_HAS_UBSAN_SANITIZE_ALL
 	select ARCH_HAS_ZONE_DEVICE		if X86_64
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG
diff --git a/arch/x86/include/asm/sync_core.h b/arch/x86/include/asm/sync_core.h
new file mode 100644
index 000000000000..c67caafd3381
--- /dev/null
+++ b/arch/x86/include/asm/sync_core.h
@@ -0,0 +1,28 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _ASM_X86_SYNC_CORE_H
+#define _ASM_X86_SYNC_CORE_H
+
+#include <linux/preempt.h>
+#include <asm/processor.h>
+#include <asm/cpufeature.h>
+
+/*
+ * Ensure that a core serializing instruction is issued before returning
+ * to user-mode. x86 implements return to user-space through sysexit,
+ * sysrel, and sysretq, which are not core serializing.
+ */
+static inline void sync_core_before_usermode(void)
+{
+	/* With PTI, we unconditionally serialize before running user code. */
+	if (static_cpu_has(X86_FEATURE_PTI))
+		return;
+	/*
+	 * Return from interrupt and NMI is done through iret, which is core
+	 * serializing.
+	 */
+	if (in_irq() || in_nmi())
+		return;
+	sync_core();
+}
+
+#endif /* _ASM_X86_SYNC_CORE_H */
-- 
2.11.0
