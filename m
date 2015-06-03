From: tip-bot for Ingo Molnar <tipbot@zytor.com>
Subject: [tip:core/documentation] Documentation/features/sched:
  Add feature description and arch support status file for 'numa-balancing'
Date: Wed, 3 Jun 2015 04:11:19 -0700
Message-ID: <tip-65ee8aeb3759908606486248363026cc9b734d9e@git.kernel.org>
Reply-To: josh@joshtriplett.org, peterz@infradead.org, hpa@zytor.com,
	  linux-arch@vger.kernel.org, torvalds@linux-foundation.org,
	  linux-api@vger.kernel.org, mingo@kernel.org, corbet@lwn.net,
	  akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
	  tglx@linutronix.de
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-arch-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-arch-owner@vger.kernel.org
To: linux-tip-commits@vger.kernel.org
Cc: corbet@lwn.net, akpm@linux-foundation.org, tglx@linutronix.de, linux-kernel@vger.kernel.org, josh@joshtriplett.org, peterz@infradead.org, linux-arch@vger.kernel.org, hpa@zytor.com, linux-api@vger.kernel.org, mingo@kernel.org, torvalds@linux-foundation.org
List-Id: linux-api@vger.kernel.org

Commit-ID:  65ee8aeb3759908606486248363026cc9b734d9e
Gitweb:     http://git.kernel.org/tip/65ee8aeb3759908606486248363026cc9b734d9e
Author:     Ingo Molnar <mingo@kernel.org>
AuthorDate: Wed, 3 Jun 2015 12:37:12 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 3 Jun 2015 12:51:36 +0200

Documentation/features/sched: Add feature description and arch support status file for 'numa-balancing'

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
 .../{vm/THP => sched/numa-balancing}/arch-support.txt  | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/Documentation/features/vm/THP/arch-support.txt b/Documentation/features/sched/numa-balancing/arch-support.txt
similarity index 72%
copy from Documentation/features/vm/THP/arch-support.txt
copy to Documentation/features/sched/numa-balancing/arch-support.txt
index 972d02c..ac7cd6b 100644
--- a/Documentation/features/vm/THP/arch-support.txt
+++ b/Documentation/features/sched/numa-balancing/arch-support.txt
@@ -1,15 +1,15 @@
 #
-# Feature name:          THP
-#         Kconfig:       HAVE_ARCH_TRANSPARENT_HUGEPAGE
-#         description:   arch supports transparent hugepages
+# Feature name:          numa-balancing
+#         Kconfig:       ARCH_SUPPORTS_NUMA_BALANCING
+#         description:   arch supports NUMA balancing
 #
     -----------------------
     |         arch |status|
     -----------------------
     |       alpha: | TODO |
     |         arc: |  ..  |
-    |         arm: |  ok  |
-    |       arm64: |  ok  |
+    |         arm: |  ..  |
+    |       arm64: |  ..  |
     |       avr32: |  ..  |
     |    blackfin: |  ..  |
     |         c6x: |  ..  |
@@ -22,16 +22,16 @@
     |        m68k: |  ..  |
     |       metag: |  ..  |
     |  microblaze: |  ..  |
-    |        mips: |  ok  |
+    |        mips: | TODO |
     |     mn10300: |  ..  |
     |       nios2: |  ..  |
     |    openrisc: |  ..  |
-    |      parisc: | TODO |
+    |      parisc: |  ..  |
     |     powerpc: |  ok  |
-    |        s390: |  ok  |
+    |        s390: |  ..  |
     |       score: |  ..  |
     |          sh: |  ..  |
-    |       sparc: |  ok  |
+    |       sparc: | TODO |
     |        tile: | TODO |
     |          um: |  ..  |
     |   unicore32: |  ..  |
