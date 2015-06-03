From: tip-bot for Ingo Molnar <tipbot@zytor.com>
Subject: [tip:core/documentation] Documentation/features/seccomp:
  Add feature description and arch support status file for 'seccomp-filter'
Date: Wed, 3 Jun 2015 04:13:49 -0700
Message-ID: <tip-5b8473a6d7d08e9da9bd132c6e8ce12b8cfdbf5f@git.kernel.org>
Reply-To: corbet@lwn.net, linux-kernel@vger.kernel.org, mingo@kernel.org,
	  peterz@infradead.org, linux-arch@vger.kernel.org,
	  torvalds@linux-foundation.org, hpa@zytor.com,
	  linux-api@vger.kernel.org, tglx@linutronix.de,
	  akpm@linux-foundation.org, josh@joshtriplett.org
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-arch-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-arch-owner@vger.kernel.org
To: linux-tip-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, josh@joshtriplett.org, peterz@infradead.org, torvalds@linux-foundation.org, linux-arch@vger.kernel.org, linux-api@vger.kernel.org, hpa@zytor.com, tglx@linutronix.de, linux-kernel@vger.kernel.org, mingo@kernel.org, corbet@lwn.net
List-Id: linux-api@vger.kernel.org

Commit-ID:  5b8473a6d7d08e9da9bd132c6e8ce12b8cfdbf5f
Gitweb:     http://git.kernel.org/tip/5b8473a6d7d08e9da9bd132c6e8ce12b8cfdbf5f
Author:     Ingo Molnar <mingo@kernel.org>
AuthorDate: Wed, 3 Jun 2015 12:37:21 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 3 Jun 2015 12:51:38 +0200

Documentation/features/seccomp: Add feature description and arch support status file for 'seccomp-filter'

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
 .../dma-contiguous => seccomp/seccomp-filter}/arch-support.txt    | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/Documentation/features/io/dma-contiguous/arch-support.txt b/Documentation/features/seccomp/seccomp-filter/arch-support.txt
similarity index 83%
copy from Documentation/features/io/dma-contiguous/arch-support.txt
copy to Documentation/features/seccomp/seccomp-filter/arch-support.txt
index a97e8e3..bea8009 100644
--- a/Documentation/features/io/dma-contiguous/arch-support.txt
+++ b/Documentation/features/seccomp/seccomp-filter/arch-support.txt
@@ -1,7 +1,7 @@
 #
-# Feature name:          dma-contiguous
-#         Kconfig:       HAVE_DMA_CONTIGUOUS
-#         description:   arch supports the DMA CMA (continuous memory allocator)
+# Feature name:          seccomp-filter
+#         Kconfig:       HAVE_ARCH_SECCOMP_FILTER
+#         description:   arch supports seccomp filters
 #
     -----------------------
     |         arch |status|
@@ -28,7 +28,7 @@
     |    openrisc: | TODO |
     |      parisc: | TODO |
     |     powerpc: | TODO |
-    |        s390: | TODO |
+    |        s390: |  ok  |
     |       score: | TODO |
     |          sh: | TODO |
     |       sparc: | TODO |
