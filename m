From: tip-bot for Ingo Molnar <tipbot@zytor.com>
Subject: [tip:core/documentation] Documentation/features/core:
  Add feature description and arch support status file for 'tracehook'
Date: Wed, 3 Jun 2015 04:12:13 -0700
Message-ID: <tip-f58519e9f7d65c41c17944e25d5343a07454b3a7@git.kernel.org>
Reply-To: corbet@lwn.net, torvalds@linux-foundation.org, mingo@kernel.org,
	  linux-api@vger.kernel.org, akpm@linux-foundation.org,
	  josh@joshtriplett.org, linux-kernel@vger.kernel.org,
	  peterz@infradead.org, linux-arch@vger.kernel.org, hpa@zytor.com,
	  tglx@linutronix.de
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-arch-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-arch-owner@vger.kernel.org
To: linux-tip-commits@vger.kernel.org
Cc: tglx@linutronix.de, hpa@zytor.com, linux-kernel@vger.kernel.org, peterz@infradead.org, linux-arch@vger.kernel.org, corbet@lwn.net, torvalds@linux-foundation.org, linux-api@vger.kernel.org, mingo@kernel.org, josh@joshtriplett.org, akpm@linux-foundation.org
List-Id: linux-api@vger.kernel.org

Commit-ID:  f58519e9f7d65c41c17944e25d5343a07454b3a7
Gitweb:     http://git.kernel.org/tip/f58519e9f7d65c41c17944e25d5343a07454b3a7
Author:     Ingo Molnar <mingo@kernel.org>
AuthorDate: Wed, 3 Jun 2015 12:37:15 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 3 Jun 2015 12:51:36 +0200

Documentation/features/core: Add feature description and arch support status file for 'tracehook'

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
 .../tracehook}/arch-support.txt                    | 28 +++++++++++-----------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/Documentation/features/io/dma_map_attrs/arch-support.txt b/Documentation/features/core/tracehook/arch-support.txt
similarity index 59%
copy from Documentation/features/io/dma_map_attrs/arch-support.txt
copy to Documentation/features/core/tracehook/arch-support.txt
index 51d0f1c..728061d 100644
--- a/Documentation/features/io/dma_map_attrs/arch-support.txt
+++ b/Documentation/features/core/tracehook/arch-support.txt
@@ -1,30 +1,30 @@
 #
-# Feature name:          dma_map_attrs
-#         Kconfig:       HAVE_DMA_ATTRS
-#         description:   arch provides dma_*map*_attrs() APIs
+# Feature name:          tracehook
+#         Kconfig:       HAVE_ARCH_TRACEHOOK
+#         description:   arch supports tracehook (ptrace) register handling APIs
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
     |       avr32: | TODO |
-    |    blackfin: | TODO |
-    |         c6x: | TODO |
+    |    blackfin: |  ok  |
+    |         c6x: |  ok  |
     |        cris: | TODO |
-    |         frv: | TODO |
-    |       h8300: |  ok  |
+    |         frv: |  ok  |
+    |       h8300: | TODO |
     |     hexagon: |  ok  |
     |        ia64: |  ok  |
     |        m32r: | TODO |
     |        m68k: | TODO |
-    |       metag: | TODO |
-    |  microblaze: |  ok  |
+    |       metag: |  ok  |
+    |  microblaze: | TODO |
     |        mips: |  ok  |
-    |     mn10300: | TODO |
-    |       nios2: | TODO |
+    |     mn10300: |  ok  |
+    |       nios2: |  ok  |
     |    openrisc: |  ok  |
     |      parisc: | TODO |
     |     powerpc: |  ok  |
@@ -34,7 +34,7 @@
     |       sparc: |  ok  |
     |        tile: |  ok  |
     |          um: | TODO |
-    |   unicore32: |  ok  |
+    |   unicore32: | TODO |
     |         x86: |  ok  |
     |      xtensa: | TODO |
     -----------------------
