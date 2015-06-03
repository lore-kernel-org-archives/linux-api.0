From: tip-bot for Ingo Molnar <tipbot@zytor.com>
Subject: [tip:core/documentation] Documentation/features/vm:
  Add feature description and arch support status file for 'PG_uncached'
Date: Wed, 3 Jun 2015 04:07:22 -0700
Message-ID: <tip-c197645c597f6615f7476881789ba97774dac4f5@git.kernel.org>
Reply-To: corbet@lwn.net, hpa@zytor.com, josh@joshtriplett.org,
	  akpm@linux-foundation.org, torvalds@linux-foundation.org,
	  peterz@infradead.org, tglx@linutronix.de,
	  linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
	  mingo@kernel.org, linux-api@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: linux-tip-commits@vger.kernel.org
Cc: josh@joshtriplett.org, hpa@zytor.com, akpm@linux-foundation.org, corbet@lwn.net, tglx@linutronix.de, peterz@infradead.org, linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, linux-api@vger.kernel.org, mingo@kernel.org, torvalds@linux-foundation.org
List-Id: linux-api@vger.kernel.org

Commit-ID:  c197645c597f6615f7476881789ba97774dac4f5
Gitweb:     http://git.kernel.org/tip/c197645c597f6615f7476881789ba97774dac4f5
Author:     Ingo Molnar <mingo@kernel.org>
AuthorDate: Wed, 3 Jun 2015 12:36:56 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 3 Jun 2015 12:51:32 +0200

Documentation/features/vm: Add feature description and arch support status file for 'PG_uncached'

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
 .../features/vm/PG_uncached/arch-support.txt       | 40 ++++++++++++++++++++++
 1 file changed, 40 insertions(+)

diff --git a/Documentation/features/vm/PG_uncached/arch-support.txt b/Documentation/features/vm/PG_uncached/arch-support.txt
new file mode 100644
index 0000000..9919742
--- /dev/null
+++ b/Documentation/features/vm/PG_uncached/arch-support.txt
@@ -0,0 +1,40 @@
+#
+# Feature name:          PG_uncached
+#         Kconfig:       ARCH_USES_PG_UNCACHED
+#         description:   arch supports the PG_uncached page flag
+#
+    -----------------------
+    |         arch |status|
+    -----------------------
+    |       alpha: | TODO |
+    |         arc: | TODO |
+    |         arm: | TODO |
+    |       arm64: | TODO |
+    |       avr32: | TODO |
+    |    blackfin: | TODO |
+    |         c6x: | TODO |
+    |        cris: | TODO |
+    |         frv: | TODO |
+    |       h8300: | TODO |
+    |     hexagon: | TODO |
+    |        ia64: |  ok  |
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
