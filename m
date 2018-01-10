From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [PATCH v2 for 4.16 08/11] x86: Introduce sync_core_before_usermode
Date: Wed, 10 Jan 2018 10:46:22 -0500
Message-ID: <20180110154625.4319-9-mathieu.desnoyers@efficios.com>
References: <20180110154625.4319-1-mathieu.desnoyers@efficios.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180110154625.4319-1-mathieu.desnoyers@efficios.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Andy Lutomirski <luto@kernel.org>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Andrew Hunter <ahh@google.com>, Maged Michael <maged.michael@gmail.com>, Avi Kivity <avi@scylladb.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Paul Mackerras <paulus@samba.org>, Michael Ellerman <mpe@ellerman.id.au>, Dave Watson <davejwatson@fb.com>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>, Andrea Parri <parri.andrea@gmail.com>, Russell King <linux@armlinux.org.uk>, Greg Hackmann <ghackmann@google.com>, Will Deacon <will.deacon@arm.com>, David Sehr <sehr@google.com>, Linus Torvalds <torvalds@linux-foundation.org>, x86@kernel.
List-Id: linux-api@vger.kernel.org

Introduce an architecture function that ensures the current CPU
issues a core serializing instruction before returning to usermode.

This is needed for the membarrier "sync_core" command.

Architectures defining the sync_core_before_usermode() static inline
need to select ARCH_HAS_SYNC_CORE_BEFORE_USERMODE.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
CC: Peter Zijlstra <peterz@infradead.org>
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
CC: Thomas Gleixner <tglx@linutronix.de>
CC: Ingo Molnar <mingo@redhat.com>
CC: "H. Peter Anvin" <hpa@zytor.com>
CC: Andrea Parri <parri.andrea@gmail.com>
CC: Russell King <linux@armlinux.org.uk>
CC: Greg Hackmann <ghackmann@google.com>
CC: Will Deacon <will.deacon@arm.com>
CC: David Sehr <sehr@google.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>
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
---
 arch/x86/Kconfig                 |  1 +
 arch/x86/include/asm/processor.h | 10 ++++++++++
 include/linux/processor.h        |  6 ++++++
 init/Kconfig                     |  3 +++
 4 files changed, 20 insertions(+)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index d4fc98c50378..74248f712411 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -62,6 +62,7 @@ config X86
 	select ARCH_HAS_SG_CHAIN
 	select ARCH_HAS_STRICT_KERNEL_RWX
 	select ARCH_HAS_STRICT_MODULE_RWX
+	select ARCH_HAS_SYNC_CORE_BEFORE_USERMODE
 	select ARCH_HAS_UBSAN_SANITIZE_ALL
 	select ARCH_HAS_ZONE_DEVICE		if X86_64
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG
diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index d3a67fba200a..3257d34dbb40 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -722,6 +722,16 @@ static inline void sync_core(void)
 #endif
 }
 
+/*
+ * Ensure that a core serializing instruction is issued before returning
+ * to user-mode. x86 implements return to user-space through sysexit,
+ * sysrel, and sysretq, which are not core serializing.
+ */
+static inline void sync_core_before_usermode(void)
+{
+	sync_core();
+}
+
 extern void select_idle_routine(const struct cpuinfo_x86 *c);
 extern void amd_e400_c1e_apic_setup(void);
 
diff --git a/include/linux/processor.h b/include/linux/processor.h
index dbc952eec869..866de5326d34 100644
--- a/include/linux/processor.h
+++ b/include/linux/processor.h
@@ -68,4 +68,10 @@ do {								\
 
 #endif
 
+#ifndef CONFIG_ARCH_HAS_SYNC_CORE_BEFORE_USERMODE
+static inline void sync_core_before_usermode(void)
+{
+}
+#endif
+
 #endif /* _LINUX_PROCESSOR_H */
diff --git a/init/Kconfig b/init/Kconfig
index a6918da8d1ad..1474c3ee398f 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1913,3 +1913,6 @@ config ASN1
 	  functions to call on what tags.
 
 source "kernel/Kconfig.locks"
+
+config ARCH_HAS_SYNC_CORE_BEFORE_USERMODE
+	bool
-- 
2.11.0
