From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [PATCH for 4.16] membarrier-sync-core: Document architecture support
Date: Fri,  9 Feb 2018 15:30:56 -0500
Message-ID: <1518208256-22034-1-git-send-email-mathieu.desnoyers@efficios.com>
Return-path: <linux-arch-owner@vger.kernel.org>
Sender: linux-arch-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Thomas Gleixner <tglx@linutronix.de>, "Peter Zijlstra (Intel)" <peterz@infradead.org>, Andrea Parri <parri.andrea@gmail.com>, Andrew Hunter <ahh@google.com>, Andy Lutomirski <luto@kernel.org>, Avi Kivity <avi@scylladb.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Boqun Feng <boqun.feng@gmail.com>, Dave Watson <davejwatson@fb.com>, David Sehr <sehr@google.com>, Greg Hackmann <ghackmann@google.com>, "H. Peter Anvin" <hpa@zytor.com>, Linus Torvalds <torvalds@linux-foundation.org>, Maged Michael <maged.michael@gmail.com>, Michael Ellerman <mpe@ellerman.id.au>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Paul Mackerras <paulus@samba.org>, Russell
List-Id: linux-api@vger.kernel.org

Ensure we gather architecture requirements about each architecture
supporting the "sync_core" membarrier command in a single file under
Documentation/features.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Andrea Parri <parri.andrea@gmail.com>
Cc: Andrew Hunter <ahh@google.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Avi Kivity <avi@scylladb.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Boqun Feng <boqun.feng@gmail.com>
Cc: Dave Watson <davejwatson@fb.com>
Cc: David Sehr <sehr@google.com>
Cc: Greg Hackmann <ghackmann@google.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Maged Michael <maged.michael@gmail.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Will Deacon <will.deacon@arm.com>
Cc: linux-api@vger.kernel.org
Cc: linux-arch@vger.kernel.org
---
 .../sched/membarrier-sync-core/arch-support.txt    | 62 ++++++++++++++++++++++
 1 file changed, 62 insertions(+)
 create mode 100644 Documentation/features/sched/membarrier-sync-core/arch-support.txt

diff --git a/Documentation/features/sched/membarrier-sync-core/arch-support.txt b/Documentation/features/sched/membarrier-sync-core/arch-support.txt
new file mode 100644
index 0000000..2c815a7
--- /dev/null
+++ b/Documentation/features/sched/membarrier-sync-core/arch-support.txt
@@ -0,0 +1,62 @@
+#
+# Feature name:          membarrier-sync-core
+#         Kconfig:       ARCH_HAS_MEMBARRIER_SYNC_CORE
+#         description:   arch supports core serializing membarrier
+#
+# Architecture requirements
+#
+# * arm64
+#
+# Rely on eret context synchronization when returning from IPI handler, and
+# when returning to user-space.
+#
+# * x86
+#
+# x86-32 uses IRET as return from interrupt, which takes care of the IPI.
+# However, it uses both IRET and SYSEXIT to go back to user-space. The IRET
+# instruction is core serializing, but not SYSEXIT.
+#
+# x86-64 uses IRET as return from interrupt, which takes care of the IPI.
+# However, it can return to user-space through either SYSRETL (compat code),
+# SYSRETQ, or IRET.
+#
+# Given that neither SYSRET{L,Q}, nor SYSEXIT, are core serializing, we rely
+# instead on write_cr3() performed by switch_mm() to provide core serialization
+# after changing the current mm, and deal with the special case of kthread ->
+# uthread (temporarily keeping current mm into active_mm) by issuing a
+# sync_core_before_usermode() in that specific case.
+#
+    -----------------------
+    |         arch |status|
+    -----------------------
+    |       alpha: | TODO |
+    |         arc: | TODO |
+    |         arm: | TODO |
+    |       arm64: |  ok  |
+    |    blackfin: | TODO |
+    |         c6x: | TODO |
+    |        cris: | TODO |
+    |         frv: | TODO |
+    |       h8300: | TODO |
+    |     hexagon: | TODO |
+    |        ia64: | TODO |
+    |        m32r: | TODO |
+    |        m68k: | TODO |
+    |       metag: | TODO |
+    |  microblaze: | TODO |
+    |        mips: | TODO |
+    |     mn10300: | TODO |
+    |       nios2: | TODO |
+    |    openrisc: | TODO |
+    |      parisc: | TODO |
+    |     powerpc: | TODO |
+    |        s390: | TODO |
+    |       score: | TODO |
+    |          sh: | TODO |
+    |       sparc: | TODO |
+    |        tile: | TODO |
+    |          um: | TODO |
+    |   unicore32: | TODO |
+    |         x86: |  ok  |
+    |      xtensa: | TODO |
+    -----------------------
-- 
1.9.1
