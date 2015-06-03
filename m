From: tip-bot for Ingo Molnar <tipbot@zytor.com>
Subject: [tip:core/documentation] Documentation/features/debug:
  Add feature description and arch support status file for 'optprobes'
Date: Wed, 3 Jun 2015 04:16:10 -0700
Message-ID: <tip-08716c0da7d6f3f7888dfc2980aec6ec226ddd2d@git.kernel.org>
Reply-To: hpa@zytor.com, linux-kernel@vger.kernel.org,
	  linux-arch@vger.kernel.org, akpm@linux-foundation.org,
	  torvalds@linux-foundation.org, mingo@kernel.org,
	  peterz@infradead.org, corbet@lwn.net, tglx@linutronix.de,
	  josh@joshtriplett.org, linux-api@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: linux-tip-commits@vger.kernel.org
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org, hpa@zytor.com, peterz@infradead.org, mingo@kernel.org, torvalds@linux-foundation.org, akpm@linux-foundation.org, tglx@linutronix.de, corbet@lwn.net, linux-api@vger.kernel.org, josh@joshtriplett.org
List-Id: linux-api@vger.kernel.org

Commit-ID:  08716c0da7d6f3f7888dfc2980aec6ec226ddd2d
Gitweb:     http://git.kernel.org/tip/08716c0da7d6f3f7888dfc2980aec6ec226ddd2d
Author:     Ingo Molnar <mingo@kernel.org>
AuthorDate: Wed, 3 Jun 2015 12:37:28 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 3 Jun 2015 12:51:40 +0200

Documentation/features/debug: Add feature description and arch support status file for 'optprobes'

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
 .../features/debug/{KASAN => optprobes}/arch-support.txt       | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/Documentation/features/debug/KASAN/arch-support.txt b/Documentation/features/debug/optprobes/arch-support.txt
similarity index 82%
copy from Documentation/features/debug/KASAN/arch-support.txt
copy to Documentation/features/debug/optprobes/arch-support.txt
index 14531da..b8999d8 100644
--- a/Documentation/features/debug/KASAN/arch-support.txt
+++ b/Documentation/features/debug/optprobes/arch-support.txt
@@ -1,14 +1,14 @@
 #
-# Feature name:          KASAN
-#         Kconfig:       HAVE_ARCH_KASAN
-#         description:   arch supports the KASAN runtime memory checker
+# Feature name:          optprobes
+#         Kconfig:       HAVE_OPTPROBES
+#         description:   arch supports live patched optprobes
 #
     -----------------------
     |         arch |status|
     -----------------------
     |       alpha: | TODO |
     |         arc: | TODO |
-    |         arm: | TODO |
+    |         arm: |  ok  |
     |       arm64: | TODO |
     |       avr32: | TODO |
     |    blackfin: | TODO |
@@ -32,7 +32,7 @@
     |       score: | TODO |
     |          sh: | TODO |
     |       sparc: | TODO |
-    |        tile: | TODO |
+    |        tile: |  ok  |
     |          um: | TODO |
     |   unicore32: | TODO |
     |         x86: |  ok  |
