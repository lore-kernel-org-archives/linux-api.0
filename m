From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [PATCH for 4.16 10/11] membarrier: arm64: Provide core serializing command
Date: Wed, 17 Jan 2018 11:54:57 -0500
Message-ID: <20180117165458.13330-11-mathieu.desnoyers@efficios.com>
References: <20180117165458.13330-1-mathieu.desnoyers@efficios.com>
Return-path: <linux-arch-owner@vger.kernel.org>
In-Reply-To: <20180117165458.13330-1-mathieu.desnoyers@efficios.com>
Sender: linux-arch-owner@vger.kernel.org
To: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Andy Lutomirski <luto@kernel.org>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Andrew Hunter <ahh@google.com>, Maged Michael <maged.michael@gmail.com>, Avi Kivity <avi@scylladb.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Paul Mackerras <paulus@samba.org>, Michael Ellerman <mpe@ellerman.id.au>, Dave Watson <davejwatson@fb.com>, "H . Peter Anvin" <hpa@zytor.com>, Andrea Parri <parri.andrea@gmail.com>, Russell King <linux@armlinux.org.uk>, Greg Hackmann <ghackmann@google.com>, Will Deacon <will.deacon@arm.com>, David Sehr <sehr@google.com>, Linus Torvalds <torvalds@linux-foundation.org>, x86@kernel.org, Mathieu Desnoyers <mathieu.desnoy>
List-Id: linux-api@vger.kernel.org

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
CC: x86@kernel.org
CC: linux-arch@vger.kernel.org
---
 arch/arm64/Kconfig        | 1 +
 arch/arm64/kernel/entry.S | 4 ++++
 2 files changed, 5 insertions(+)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index c9a7e9e1414f..5b0c06d8dbbe 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -16,6 +16,7 @@ config ARM64
 	select ARCH_HAS_GCOV_PROFILE_ALL
 	select ARCH_HAS_GIGANTIC_PAGE if (MEMORY_ISOLATION && COMPACTION) || CMA
 	select ARCH_HAS_KCOV
+	select ARCH_HAS_MEMBARRIER_SYNC_CORE
 	select ARCH_HAS_SET_MEMORY
 	select ARCH_HAS_SG_CHAIN
 	select ARCH_HAS_STRICT_KERNEL_RWX
diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
index 6d14b8f29b5f..5edde1c2e93e 100644
--- a/arch/arm64/kernel/entry.S
+++ b/arch/arm64/kernel/entry.S
@@ -302,6 +302,10 @@ alternative_else_nop_endif
 	ldp	x28, x29, [sp, #16 * 14]
 	ldr	lr, [sp, #S_LR]
 	add	sp, sp, #S_FRAME_SIZE		// restore sp
+	/*
+	 * ARCH_HAS_MEMBARRIER_SYNC_CORE rely on eret context synchronization
+	 * when returning from IPI handler, and when returning to user-space.
+	 */
 	eret					// return to kernel
 	.endm
 
-- 
2.11.0
