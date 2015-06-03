From: tip-bot for Ingo Molnar <tipbot@zytor.com>
Subject: [tip:core/documentation] Documentation/features/debug:
  Add feature description and arch support status file for 'kprobes'
Date: Wed, 3 Jun 2015 04:15:49 -0700
Message-ID: <tip-fd7d6cee93aae351b671621ad9024a8f09214284@git.kernel.org>
Reply-To: josh@joshtriplett.org, linux-arch@vger.kernel.org,
	  linux-kernel@vger.kernel.org, tglx@linutronix.de,
	  peterz@infradead.org, hpa@zytor.com, corbet@lwn.net,
	  akpm@linux-foundation.org, linux-api@vger.kernel.org,
	  mingo@kernel.org, torvalds@linux-foundation.org
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-arch-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-arch-owner@vger.kernel.org
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, josh@joshtriplett.org, tglx@linutronix.de, peterz@infradead.org, hpa@zytor.com, corbet@lwn.net, linux-api@vger.kernel.org, akpm@linux-foundation.org, torvalds@linux-foundation.org, mingo@kernel.org
List-Id: linux-api@vger.kernel.org

Commit-ID:  fd7d6cee93aae351b671621ad9024a8f09214284
Gitweb:     http://git.kernel.org/tip/fd7d6cee93aae351b671621ad9024a8f09214284
Author:     Ingo Molnar <mingo@kernel.org>
AuthorDate: Wed, 3 Jun 2015 12:37:27 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 3 Jun 2015 12:51:39 +0200

Documentation/features/debug: Add feature description and arch support status file for 'kprobes'

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
 .../ioremap_prot => debug/kprobes}/arch-support.txt    | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/Documentation/features/vm/ioremap_prot/arch-support.txt b/Documentation/features/debug/kprobes/arch-support.txt
similarity index 72%
copy from Documentation/features/vm/ioremap_prot/arch-support.txt
copy to Documentation/features/debug/kprobes/arch-support.txt
index 90c5374..a44bfff 100644
--- a/Documentation/features/vm/ioremap_prot/arch-support.txt
+++ b/Documentation/features/debug/kprobes/arch-support.txt
@@ -1,37 +1,37 @@
 #
-# Feature name:          ioremap_prot
-#         Kconfig:       HAVE_IOREMAP_PROT
-#         description:   arch has ioremap_prot()
+# Feature name:          kprobes
+#         Kconfig:       HAVE_KPROBES
+#         description:   arch supports live patched kernel probe
 #
     -----------------------
     |         arch |status|
     -----------------------
     |       alpha: | TODO |
     |         arc: |  ok  |
-    |         arm: | TODO |
+    |         arm: |  ok  |
     |       arm64: | TODO |
-    |       avr32: | TODO |
+    |       avr32: |  ok  |
     |    blackfin: | TODO |
     |         c6x: | TODO |
     |        cris: | TODO |
     |         frv: | TODO |
     |       h8300: | TODO |
     |     hexagon: | TODO |
-    |        ia64: | TODO |
+    |        ia64: |  ok  |
     |        m32r: | TODO |
     |        m68k: | TODO |
     |       metag: | TODO |
     |  microblaze: | TODO |
-    |        mips: | TODO |
+    |        mips: |  ok  |
     |     mn10300: | TODO |
     |       nios2: | TODO |
     |    openrisc: | TODO |
     |      parisc: | TODO |
     |     powerpc: |  ok  |
-    |        s390: | TODO |
+    |        s390: |  ok  |
     |       score: | TODO |
     |          sh: |  ok  |
-    |       sparc: | TODO |
+    |       sparc: |  ok  |
     |        tile: |  ok  |
     |          um: | TODO |
     |   unicore32: | TODO |
