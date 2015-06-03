From: tip-bot for Ingo Molnar <tipbot@zytor.com>
Subject: [tip:core/documentation] Documentation/features/perf:
  Add feature description and arch support status file for 'perf-regs'
Date: Wed, 3 Jun 2015 04:18:42 -0700
Message-ID: <tip-e30119a9dab9d407a6cd1143fb2ba6620719abe2@git.kernel.org>
Reply-To: tglx@linutronix.de, akpm@linux-foundation.org, corbet@lwn.net,
	  josh@joshtriplett.org, mingo@kernel.org,
	  linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	  peterz@infradead.org, linux-arch@vger.kernel.org,
	  linux-api@vger.kernel.org, hpa@zytor.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: linux-tip-commits@vger.kernel.org
Cc: linux-arch@vger.kernel.org, linux-api@vger.kernel.org, hpa@zytor.com, peterz@infradead.org, mingo@kernel.org, josh@joshtriplett.org, linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, tglx@linutronix.de, akpm@linux-foundation.org, corbet@lwn.net
List-Id: linux-api@vger.kernel.org

Commit-ID:  e30119a9dab9d407a6cd1143fb2ba6620719abe2
Gitweb:     http://git.kernel.org/tip/e30119a9dab9d407a6cd1143fb2ba6620719abe2
Author:     Ingo Molnar <mingo@kernel.org>
AuthorDate: Wed, 3 Jun 2015 12:37:37 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 3 Jun 2015 12:51:42 +0200

Documentation/features/perf: Add feature description and arch support status file for 'perf-regs'

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
 .../{io/dma-contiguous => perf/perf-regs}/arch-support.txt        | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/Documentation/features/io/dma-contiguous/arch-support.txt b/Documentation/features/perf/perf-regs/arch-support.txt
similarity index 83%
copy from Documentation/features/io/dma-contiguous/arch-support.txt
copy to Documentation/features/perf/perf-regs/arch-support.txt
index a97e8e3..e2b4a78 100644
--- a/Documentation/features/io/dma-contiguous/arch-support.txt
+++ b/Documentation/features/perf/perf-regs/arch-support.txt
@@ -1,7 +1,7 @@
 #
-# Feature name:          dma-contiguous
-#         Kconfig:       HAVE_DMA_CONTIGUOUS
-#         description:   arch supports the DMA CMA (continuous memory allocator)
+# Feature name:          perf-regs
+#         Kconfig:       HAVE_PERF_REGS
+#         description:   arch supports perf events register access
 #
     -----------------------
     |         arch |status|
@@ -22,7 +22,7 @@
     |        m68k: | TODO |
     |       metag: | TODO |
     |  microblaze: | TODO |
-    |        mips: |  ok  |
+    |        mips: | TODO |
     |     mn10300: | TODO |
     |       nios2: | TODO |
     |    openrisc: | TODO |
