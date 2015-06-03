From: tip-bot for Ingo Molnar <tipbot@zytor.com>
Subject: [tip:core/documentation] Documentation/features/time:
  Add feature description and arch support status file for '
 arch-tick-broadcast'
Date: Wed, 3 Jun 2015 04:15:31 -0700
Message-ID: <tip-6a6787724dc21925f6d289c9a019ed6026db5183@git.kernel.org>
Reply-To: torvalds@linux-foundation.org, mingo@kernel.org,
	  tglx@linutronix.de, corbet@lwn.net, linux-arch@vger.kernel.org,
	  peterz@infradead.org, hpa@zytor.com, akpm@linux-foundation.org,
	  josh@joshtriplett.org, linux-api@vger.kernel.org,
	  linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: linux-tip-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, hpa@zytor.com, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, josh@joshtriplett.org, mingo@kernel.org, torvalds@linux-foundation.org, peterz@infradead.org, linux-arch@vger.kernel.org, corbet@lwn.net, tglx@linutronix.de
List-Id: linux-api@vger.kernel.org

Commit-ID:  6a6787724dc21925f6d289c9a019ed6026db5183
Gitweb:     http://git.kernel.org/tip/6a6787724dc21925f6d289c9a019ed6026db5183
Author:     Ingo Molnar <mingo@kernel.org>
AuthorDate: Wed, 3 Jun 2015 12:37:26 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 3 Jun 2015 12:51:39 +0200

Documentation/features/time: Add feature description and arch support status file for 'arch-tick-broadcast'

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
 .../arch-tick-broadcast}/arch-support.txt                      | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/Documentation/features/io/dma-contiguous/arch-support.txt b/Documentation/features/time/arch-tick-broadcast/arch-support.txt
similarity index 80%
copy from Documentation/features/io/dma-contiguous/arch-support.txt
copy to Documentation/features/time/arch-tick-broadcast/arch-support.txt
index a97e8e3..8acb439 100644
--- a/Documentation/features/io/dma-contiguous/arch-support.txt
+++ b/Documentation/features/time/arch-tick-broadcast/arch-support.txt
@@ -1,7 +1,7 @@
 #
-# Feature name:          dma-contiguous
-#         Kconfig:       HAVE_DMA_CONTIGUOUS
-#         description:   arch supports the DMA CMA (continuous memory allocator)
+# Feature name:          arch-tick-broadcast
+#         Kconfig:       ARCH_HAS_TICK_BROADCAST
+#         description:   arch provides tick_broadcast()
 #
     -----------------------
     |         arch |status|
@@ -27,7 +27,7 @@
     |       nios2: | TODO |
     |    openrisc: | TODO |
     |      parisc: | TODO |
-    |     powerpc: | TODO |
+    |     powerpc: |  ok  |
     |        s390: | TODO |
     |       score: | TODO |
     |          sh: | TODO |
@@ -35,6 +35,6 @@
     |        tile: | TODO |
     |          um: | TODO |
     |   unicore32: | TODO |
-    |         x86: |  ok  |
+    |         x86: | TODO |
     |      xtensa: | TODO |
     -----------------------
