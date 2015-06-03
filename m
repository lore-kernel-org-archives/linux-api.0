From: tip-bot for Ingo Molnar <tipbot@zytor.com>
Subject: [tip:core/documentation] Documentation/features/io:
  Add feature description and arch support status file for 'dma-api-debug'
Date: Wed, 3 Jun 2015 04:18:25 -0700
Message-ID: <tip-318d10dd83d0c61422f544f9be2634663e094a2c@git.kernel.org>
Reply-To: linux-api@vger.kernel.org, josh@joshtriplett.org,
	  mingo@kernel.org, peterz@infradead.org,
	  linux-arch@vger.kernel.org, corbet@lwn.net,
	  linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	  akpm@linux-foundation.org, hpa@zytor.com, tglx@linutronix.de
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-arch-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-arch-owner@vger.kernel.org
To: linux-tip-commits@vger.kernel.org
Cc: mingo@kernel.org, peterz@infradead.org, linux-api@vger.kernel.org, josh@joshtriplett.org, linux-arch@vger.kernel.org, corbet@lwn.net, linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, tglx@linutronix.de, hpa@zytor.com, akpm@linux-foundation.org
List-Id: linux-api@vger.kernel.org

Commit-ID:  318d10dd83d0c61422f544f9be2634663e094a2c
Gitweb:     http://git.kernel.org/tip/318d10dd83d0c61422f544f9be2634663e094a2c
Author:     Ingo Molnar <mingo@kernel.org>
AuthorDate: Wed, 3 Jun 2015 12:37:36 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 3 Jun 2015 12:51:41 +0200

Documentation/features/io: Add feature description and arch support status file for 'dma-api-debug'

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
 .../kretprobes => io/dma-api-debug}/arch-support.txt       | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/Documentation/features/debug/kretprobes/arch-support.txt b/Documentation/features/io/dma-api-debug/arch-support.txt
similarity index 77%
copy from Documentation/features/debug/kretprobes/arch-support.txt
copy to Documentation/features/io/dma-api-debug/arch-support.txt
index d87c1ce..4f4a344 100644
--- a/Documentation/features/debug/kretprobes/arch-support.txt
+++ b/Documentation/features/io/dma-api-debug/arch-support.txt
@@ -1,18 +1,18 @@
 #
-# Feature name:          kretprobes
-#         Kconfig:       HAVE_KRETPROBES
-#         description:   arch supports kernel function-return probes
+# Feature name:          dma-api-debug
+#         Kconfig:       HAVE_DMA_API_DEBUG
+#         description:   arch supports DMA debug facilities
 #
     -----------------------
     |         arch |status|
     -----------------------
     |       alpha: | TODO |
-    |         arc: |  ok  |
+    |         arc: | TODO |
     |         arm: |  ok  |
-    |       arm64: | TODO |
+    |       arm64: |  ok  |
     |       avr32: | TODO |
     |    blackfin: | TODO |
-    |         c6x: | TODO |
+    |         c6x: |  ok  |
     |        cris: | TODO |
     |         frv: | TODO |
     |       h8300: | TODO |
@@ -21,7 +21,7 @@
     |        m32r: | TODO |
     |        m68k: | TODO |
     |       metag: | TODO |
-    |  microblaze: | TODO |
+    |  microblaze: |  ok  |
     |        mips: |  ok  |
     |     mn10300: | TODO |
     |       nios2: | TODO |
