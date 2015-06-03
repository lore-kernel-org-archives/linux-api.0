From: tip-bot for Ingo Molnar <tipbot@zytor.com>
Subject: [tip:core/documentation] Documentation/features/locking:
  Add feature description and arch support status file for 'lockdep'
Date: Wed, 3 Jun 2015 04:12:53 -0700
Message-ID: <tip-41b8ea4be1c2fbd152c413d68877318e3a1c76a0@git.kernel.org>
Reply-To: linux-api@vger.kernel.org, linux-arch@vger.kernel.org,
	  josh@joshtriplett.org, mingo@kernel.org,
	  torvalds@linux-foundation.org, tglx@linutronix.de,
	  linux-kernel@vger.kernel.org, corbet@lwn.net, hpa@zytor.com,
	  akpm@linux-foundation.org, peterz@infradead.org
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: linux-tip-commits@vger.kernel.org
Cc: corbet@lwn.net, peterz@infradead.org, hpa@zytor.com, akpm@linux-foundation.org, tglx@linutronix.de, linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, mingo@kernel.org, linux-api@vger.kernel.org, linux-arch@vger.kernel.org, josh@joshtriplett.org
List-Id: linux-api@vger.kernel.org

Commit-ID:  41b8ea4be1c2fbd152c413d68877318e3a1c76a0
Gitweb:     http://git.kernel.org/tip/41b8ea4be1c2fbd152c413d68877318e3a1c76a0
Author:     Ingo Molnar <mingo@kernel.org>
AuthorDate: Wed, 3 Jun 2015 12:37:17 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 3 Jun 2015 12:51:37 +0200

Documentation/features/locking: Add feature description and arch support status file for 'lockdep'

Cc: <linux-api@vger.kernel.org>
Cc: <linux-arch@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Josh Triplett <josh@joshtriplett.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 .../lockdep}/arch-support.txt                      | 28 +++++++++++-----------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/Documentation/features/io/dma_map_attrs/arch-support.txt b/Documentation/features/locking/lockdep/arch-support.txt
similarity index 59%
copy from Documentation/features/io/dma_map_attrs/arch-support.txt
copy to Documentation/features/locking/lockdep/arch-support.txt
index 51d0f1c..cf90635 100644
--- a/Documentation/features/io/dma_map_attrs/arch-support.txt
+++ b/Documentation/features/locking/lockdep/arch-support.txt
@@ -1,40 +1,40 @@
 #
-# Feature name:          dma_map_attrs
-#         Kconfig:       HAVE_DMA_ATTRS
-#         description:   arch provides dma_*map*_attrs() APIs
+# Feature name:          lockdep
+#         Kconfig:       LOCKDEP_SUPPORT
+#         description:   arch supports the runtime locking correctness debug facility
 #
     -----------------------
     |         arch |status|
     -----------------------
-    |       alpha: |  ok  |
-    |         arc: | TODO |
+    |       alpha: | TODO |
+    |         arc: |  ok  |
     |         arm: |  ok  |
     |       arm64: |  ok  |
-    |       avr32: | TODO |
-    |    blackfin: | TODO |
+    |       avr32: |  ok  |
+    |    blackfin: |  ok  |
     |         c6x: | TODO |
     |        cris: | TODO |
     |         frv: | TODO |
-    |       h8300: |  ok  |
+    |       h8300: | TODO |
     |     hexagon: |  ok  |
-    |        ia64: |  ok  |
+    |        ia64: | TODO |
     |        m32r: | TODO |
     |        m68k: | TODO |
-    |       metag: | TODO |
+    |       metag: |  ok  |
     |  microblaze: |  ok  |
     |        mips: |  ok  |
     |     mn10300: | TODO |
     |       nios2: | TODO |
-    |    openrisc: |  ok  |
+    |    openrisc: | TODO |
     |      parisc: | TODO |
     |     powerpc: |  ok  |
     |        s390: |  ok  |
-    |       score: | TODO |
+    |       score: |  ok  |
     |          sh: |  ok  |
     |       sparc: |  ok  |
     |        tile: |  ok  |
-    |          um: | TODO |
+    |          um: |  ok  |
     |   unicore32: |  ok  |
     |         x86: |  ok  |
-    |      xtensa: | TODO |
+    |      xtensa: |  ok  |
     -----------------------
