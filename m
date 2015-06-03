From: tip-bot for Ingo Molnar <tipbot@zytor.com>
Subject: [tip:core/documentation] Documentation/features/io:
  Add feature description and arch support status file for 'dma-contiguous'
Date: Wed, 3 Jun 2015 04:11:37 -0700
Message-ID: <tip-cd66af211609bb0cc2ab2f32412be41a7481f211@git.kernel.org>
Reply-To: linux-api@vger.kernel.org, torvalds@linux-foundation.org,
	  tglx@linutronix.de, corbet@lwn.net, hpa@zytor.com,
	  peterz@infradead.org, mingo@kernel.org,
	  akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
	  josh@joshtriplett.org, linux-arch@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-arch-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-arch-owner@vger.kernel.org
To: linux-tip-commits@vger.kernel.org
Cc: corbet@lwn.net, hpa@zytor.com, peterz@infradead.org, linux-api@vger.kernel.org, torvalds@linux-foundation.org, tglx@linutronix.de, linux-arch@vger.kernel.org, mingo@kernel.org, akpm@linux-foundation.org, linux-kernel@vger.kernel.org, josh@joshtriplett.org
List-Id: linux-api@vger.kernel.org

Commit-ID:  cd66af211609bb0cc2ab2f32412be41a7481f211
Gitweb:     http://git.kernel.org/tip/cd66af211609bb0cc2ab2f32412be41a7481f211
Author:     Ingo Molnar <mingo@kernel.org>
AuthorDate: Wed, 3 Jun 2015 12:37:13 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 3 Jun 2015 12:51:36 +0200

Documentation/features/io: Add feature description and arch support status file for 'dma-contiguous'

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
 .../dma-contiguous}/arch-support.txt                           | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/Documentation/features/vm/pmdp_splitting_flush/arch-support.txt b/Documentation/features/io/dma-contiguous/arch-support.txt
similarity index 79%
copy from Documentation/features/vm/pmdp_splitting_flush/arch-support.txt
copy to Documentation/features/io/dma-contiguous/arch-support.txt
index 26f74b4..a97e8e3 100644
--- a/Documentation/features/vm/pmdp_splitting_flush/arch-support.txt
+++ b/Documentation/features/io/dma-contiguous/arch-support.txt
@@ -1,7 +1,7 @@
 #
-# Feature name:          pmdp_splitting_flush
-#         Kconfig:       __HAVE_ARCH_PMDP_SPLITTING_FLUSH
-#         description:   arch supports the pmdp_splitting_flush() VM API
+# Feature name:          dma-contiguous
+#         Kconfig:       HAVE_DMA_CONTIGUOUS
+#         description:   arch supports the DMA CMA (continuous memory allocator)
 #
     -----------------------
     |         arch |status|
@@ -27,8 +27,8 @@
     |       nios2: | TODO |
     |    openrisc: | TODO |
     |      parisc: | TODO |
-    |     powerpc: |  ok  |
-    |        s390: |  ok  |
+    |     powerpc: | TODO |
+    |        s390: | TODO |
     |       score: | TODO |
     |          sh: | TODO |
     |       sparc: | TODO |
