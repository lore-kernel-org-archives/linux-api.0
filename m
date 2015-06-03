From: tip-bot for Ingo Molnar <tipbot@zytor.com>
Subject: [tip:core/documentation] Documentation/features/locking:
  Add feature description and arch support status file for 'rwsem-optimized
 '
Date: Wed, 3 Jun 2015 04:10:57 -0700
Message-ID: <tip-a521dc564bcce456354a01d2603ff946af141d32@git.kernel.org>
Reply-To: hpa@zytor.com, linux-arch@vger.kernel.org,
	  akpm@linux-foundation.org, tglx@linutronix.de,
	  peterz@infradead.org, mingo@kernel.org,
	  linux-api@vger.kernel.org, linux-kernel@vger.kernel.org,
	  josh@joshtriplett.org, torvalds@linux-foundation.org,
	  corbet@lwn.net
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: linux-tip-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, hpa@zytor.com, linux-arch@vger.kernel.org, tglx@linutronix.de, peterz@infradead.org, linux-api@vger.kernel.org, mingo@kernel.org, linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, josh@joshtriplett.org, corbet@lwn.net
List-Id: linux-api@vger.kernel.org

Commit-ID:  a521dc564bcce456354a01d2603ff946af141d32
Gitweb:     http://git.kernel.org/tip/a521dc564bcce456354a01d2603ff946af141d32
Author:     Ingo Molnar <mingo@kernel.org>
AuthorDate: Wed, 3 Jun 2015 12:37:10 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 3 Jun 2015 12:51:35 +0200

Documentation/features/locking: Add feature description and arch support status file for 'rwsem-optimized'

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
 .../rwsem-optimized}/arch-support.txt                    | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/Documentation/features/vm/PG_uncached/arch-support.txt b/Documentation/features/locking/rwsem-optimized/arch-support.txt
similarity index 74%
copy from Documentation/features/vm/PG_uncached/arch-support.txt
copy to Documentation/features/locking/rwsem-optimized/arch-support.txt
index 9919742..ac93d7a 100644
--- a/Documentation/features/vm/PG_uncached/arch-support.txt
+++ b/Documentation/features/locking/rwsem-optimized/arch-support.txt
@@ -1,12 +1,12 @@
 #
-# Feature name:          PG_uncached
-#         Kconfig:       ARCH_USES_PG_UNCACHED
-#         description:   arch supports the PG_uncached page flag
+# Feature name:          rwsem-optimized
+#         Kconfig:       Optimized asm/rwsem.h
+#         description:   arch provides optimized rwsem APIs
 #
     -----------------------
     |         arch |status|
     -----------------------
-    |       alpha: | TODO |
+    |       alpha: |  ok  |
     |         arc: | TODO |
     |         arm: | TODO |
     |       arm64: | TODO |
@@ -28,13 +28,13 @@
     |    openrisc: | TODO |
     |      parisc: | TODO |
     |     powerpc: | TODO |
-    |        s390: | TODO |
+    |        s390: |  ok  |
     |       score: | TODO |
-    |          sh: | TODO |
-    |       sparc: | TODO |
+    |          sh: |  ok  |
+    |       sparc: |  ok  |
     |        tile: | TODO |
     |          um: | TODO |
     |   unicore32: | TODO |
     |         x86: |  ok  |
-    |      xtensa: | TODO |
+    |      xtensa: |  ok  |
     -----------------------
