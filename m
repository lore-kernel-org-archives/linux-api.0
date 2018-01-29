From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [PATCH for 4.16 v2 06/11] Introduce sync_core_before_usermode
Date: Mon, 29 Jan 2018 15:20:15 -0500
Message-ID: <20180129202020.8515-7-mathieu.desnoyers@efficios.com>
References: <20180129202020.8515-1-mathieu.desnoyers@efficios.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180129202020.8515-1-mathieu.desnoyers@efficios.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Andy Lutomirski <luto@kernel.org>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Andrew Hunter <ahh@google.com>, Maged Michael <maged.michael@gmail.com>, Avi Kivity <avi@scylladb.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Paul Mackerras <paulus@samba.org>, Michael Ellerman <mpe@ellerman.id.au>, Dave Watson <davejwatson@fb.com>, "H . Peter Anvin" <hpa@zytor.com>, Andrea Parri <parri.andrea@gmail.com>, Russell King <linux@armlinux.org.uk>, Greg Hackmann <ghackmann@google.com>, Will Deacon <will.deacon@arm.com>, David Sehr <sehr@google.com>, Linus Torvalds <torvalds@linux-foundation.org>, x86@kernel.org, Mathieu Desnoyers <mathieu.desnoy>
List-Id: linux-api@vger.kernel.org

Introduce an architecture function that ensures the current CPU
issues a core serializing instruction before returning to usermode.

This is needed for the membarrier "sync_core" command.

Architectures defining the sync_core_before_usermode() static inline
need to select ARCH_HAS_SYNC_CORE_BEFORE_USERMODE.

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
- Introduce include/linux/sync_core.h
---
 include/linux/sync_core.h | 21 +++++++++++++++++++++
 init/Kconfig              |  3 +++
 2 files changed, 24 insertions(+)
 create mode 100644 include/linux/sync_core.h

diff --git a/include/linux/sync_core.h b/include/linux/sync_core.h
new file mode 100644
index 000000000000..013da4b8b327
--- /dev/null
+++ b/include/linux/sync_core.h
@@ -0,0 +1,21 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _LINUX_SYNC_CORE_H
+#define _LINUX_SYNC_CORE_H
+
+#ifdef CONFIG_ARCH_HAS_SYNC_CORE_BEFORE_USERMODE
+#include <asm/sync_core.h>
+#else
+/*
+ * This is a dummy sync_core_before_usermode() implementation that can be used
+ * on all architectures which return to user-space through core serializing
+ * instructions.
+ * If your architecture returns to user-space through non-core-serializing
+ * instructions, you need to write your own functions.
+ */
+static inline void sync_core_before_usermode(void)
+{
+}
+#endif
+
+#endif /* _LINUX_SYNC_CORE_H */
+
diff --git a/init/Kconfig b/init/Kconfig
index 2d118b6adee2..30208da2221f 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1918,3 +1918,6 @@ config ASN1
 	  functions to call on what tags.
 
 source "kernel/Kconfig.locks"
+
+config ARCH_HAS_SYNC_CORE_BEFORE_USERMODE
+	bool
-- 
2.11.0
