From: tip-bot for Ingo Molnar <tipbot@zytor.com>
Subject: [tip:core/documentation] Documentation/features/debug:
  Add feature description and arch support status file for 'stackprotector'
Date: Wed, 3 Jun 2015 04:13:13 -0700
Message-ID: <tip-6d6b54cb2187df8b09ce40012648606508be9b18@git.kernel.org>
Reply-To: mingo@kernel.org, linux-api@vger.kernel.org,
	  linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	  linux-arch@vger.kernel.org, josh@joshtriplett.org,
	  peterz@infradead.org, corbet@lwn.net, hpa@zytor.com,
	  akpm@linux-foundation.org, tglx@linutronix.de
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-arch-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-arch-owner@vger.kernel.org
To: linux-tip-commits@vger.kernel.org
Cc: josh@joshtriplett.org, peterz@infradead.org, akpm@linux-foundation.org, corbet@lwn.net, hpa@zytor.com, tglx@linutronix.de, mingo@kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, linux-arch@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Commit-ID:  6d6b54cb2187df8b09ce40012648606508be9b18
Gitweb:     http://git.kernel.org/tip/6d6b54cb2187df8b09ce40012648606508be9b18
Author:     Ingo Molnar <mingo@kernel.org>
AuthorDate: Wed, 3 Jun 2015 12:37:18 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 3 Jun 2015 12:51:37 +0200

Documentation/features/debug: Add feature description and arch support status file for 'stackprotector'

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
 .../{io/dma-contiguous => debug/stackprotector}/arch-support.txt  | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/Documentation/features/io/dma-contiguous/arch-support.txt b/Documentation/features/debug/stackprotector/arch-support.txt
similarity index 82%
copy from Documentation/features/io/dma-contiguous/arch-support.txt
copy to Documentation/features/debug/stackprotector/arch-support.txt
index a97e8e3..0fa4233 100644
--- a/Documentation/features/io/dma-contiguous/arch-support.txt
+++ b/Documentation/features/debug/stackprotector/arch-support.txt
@@ -1,7 +1,7 @@
 #
-# Feature name:          dma-contiguous
-#         Kconfig:       HAVE_DMA_CONTIGUOUS
-#         description:   arch supports the DMA CMA (continuous memory allocator)
+# Feature name:          stackprotector
+#         Kconfig:       HAVE_CC_STACKPROTECTOR
+#         description:   arch supports compiler driven stack overflow protection
 #
     -----------------------
     |         arch |status|
@@ -30,7 +30,7 @@
     |     powerpc: | TODO |
     |        s390: | TODO |
     |       score: | TODO |
-    |          sh: | TODO |
+    |          sh: |  ok  |
     |       sparc: | TODO |
     |        tile: | TODO |
     |          um: | TODO |
