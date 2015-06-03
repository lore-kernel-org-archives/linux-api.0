From: tip-bot for Ingo Molnar <tipbot@zytor.com>
Subject: [tip:core/documentation] Documentation/features/io:
  Add feature description and arch support status file for 'sg-chain'
Date: Wed, 3 Jun 2015 04:08:03 -0700
Message-ID: <tip-6c7cca4dc10950ee299ef2cb1db81733679380df@git.kernel.org>
Reply-To: mingo@kernel.org, torvalds@linux-foundation.org, corbet@lwn.net,
	  peterz@infradead.org, akpm@linux-foundation.org,
	  linux-arch@vger.kernel.org, josh@joshtriplett.org, hpa@zytor.com,
	  linux-api@vger.kernel.org, linux-kernel@vger.kernel.org,
	  tglx@linutronix.de
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: linux-tip-commits@vger.kernel.org
Cc: mingo@kernel.org, torvalds@linux-foundation.org, corbet@lwn.net, peterz@infradead.org, hpa@zytor.com, josh@joshtriplett.org, linux-arch@vger.kernel.org, akpm@linux-foundation.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, tglx@linutronix.de
List-Id: linux-api@vger.kernel.org

Commit-ID:  6c7cca4dc10950ee299ef2cb1db81733679380df
Gitweb:     http://git.kernel.org/tip/6c7cca4dc10950ee299ef2cb1db81733679380df
Author:     Ingo Molnar <mingo@kernel.org>
AuthorDate: Wed, 3 Jun 2015 12:36:59 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 3 Jun 2015 12:51:33 +0200

Documentation/features/io: Add feature description and arch support status file for 'sg-chain'

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
 .../{vm/PG_uncached => io/sg-chain}/arch-support.txt     | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/Documentation/features/vm/PG_uncached/arch-support.txt b/Documentation/features/io/sg-chain/arch-support.txt
similarity index 74%
copy from Documentation/features/vm/PG_uncached/arch-support.txt
copy to Documentation/features/io/sg-chain/arch-support.txt
index 9919742..b9b6755 100644
--- a/Documentation/features/vm/PG_uncached/arch-support.txt
+++ b/Documentation/features/io/sg-chain/arch-support.txt
@@ -1,15 +1,15 @@
 #
-# Feature name:          PG_uncached
-#         Kconfig:       ARCH_USES_PG_UNCACHED
-#         description:   arch supports the PG_uncached page flag
+# Feature name:          sg-chain
+#         Kconfig:       ARCH_HAS_SG_CHAIN
+#         description:   arch supports chained scatter-gather lists
 #
     -----------------------
     |         arch |status|
     -----------------------
     |       alpha: | TODO |
     |         arc: | TODO |
-    |         arm: | TODO |
-    |       arm64: | TODO |
+    |         arm: |  ok  |
+    |       arm64: |  ok  |
     |       avr32: | TODO |
     |    blackfin: | TODO |
     |         c6x: | TODO |
@@ -27,11 +27,11 @@
     |       nios2: | TODO |
     |    openrisc: | TODO |
     |      parisc: | TODO |
-    |     powerpc: | TODO |
-    |        s390: | TODO |
+    |     powerpc: |  ok  |
+    |        s390: |  ok  |
     |       score: | TODO |
     |          sh: | TODO |
-    |       sparc: | TODO |
+    |       sparc: |  ok  |
     |        tile: | TODO |
     |          um: | TODO |
     |   unicore32: | TODO |
