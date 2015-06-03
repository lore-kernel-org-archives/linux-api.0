From: tip-bot for Ingo Molnar <tipbot@zytor.com>
Subject: [tip:core/documentation] Documentation/features/vm:
  Add feature description and arch support status file for 'ioremap_prot'
Date: Wed, 3 Jun 2015 04:12:33 -0700
Message-ID: <tip-c0512abd5a3fef006975e8e9bb15b1eb99d12d79@git.kernel.org>
Reply-To: linux-kernel@vger.kernel.org, mingo@kernel.org,
	  akpm@linux-foundation.org, linux-api@vger.kernel.org,
	  tglx@linutronix.de, peterz@infradead.org,
	  torvalds@linux-foundation.org, linux-arch@vger.kernel.org,
	  hpa@zytor.com, corbet@lwn.net, josh@joshtriplett.org
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: linux-tip-commits@vger.kernel.org
Cc: josh@joshtriplett.org, linux-arch@vger.kernel.org, corbet@lwn.net, hpa@zytor.com, mingo@kernel.org, akpm@linux-foundation.org, linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, tglx@linutronix.de, peterz@infradead.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Commit-ID:  c0512abd5a3fef006975e8e9bb15b1eb99d12d79
Gitweb:     http://git.kernel.org/tip/c0512abd5a3fef006975e8e9bb15b1eb99d12d79
Author:     Ingo Molnar <mingo@kernel.org>
AuthorDate: Wed, 3 Jun 2015 12:37:16 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 3 Jun 2015 12:51:37 +0200

Documentation/features/vm: Add feature description and arch support status file for 'ioremap_prot'

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
 .../{debug/KASAN => vm/ioremap_prot}/arch-support.txt      | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/Documentation/features/debug/KASAN/arch-support.txt b/Documentation/features/vm/ioremap_prot/arch-support.txt
similarity index 77%
copy from Documentation/features/debug/KASAN/arch-support.txt
copy to Documentation/features/vm/ioremap_prot/arch-support.txt
index 14531da..90c5374 100644
--- a/Documentation/features/debug/KASAN/arch-support.txt
+++ b/Documentation/features/vm/ioremap_prot/arch-support.txt
@@ -1,13 +1,13 @@
 #
-# Feature name:          KASAN
-#         Kconfig:       HAVE_ARCH_KASAN
-#         description:   arch supports the KASAN runtime memory checker
+# Feature name:          ioremap_prot
+#         Kconfig:       HAVE_IOREMAP_PROT
+#         description:   arch has ioremap_prot()
 #
     -----------------------
     |         arch |status|
     -----------------------
     |       alpha: | TODO |
-    |         arc: | TODO |
+    |         arc: |  ok  |
     |         arm: | TODO |
     |       arm64: | TODO |
     |       avr32: | TODO |
@@ -27,12 +27,12 @@
     |       nios2: | TODO |
     |    openrisc: | TODO |
     |      parisc: | TODO |
-    |     powerpc: | TODO |
+    |     powerpc: |  ok  |
     |        s390: | TODO |
     |       score: | TODO |
-    |          sh: | TODO |
+    |          sh: |  ok  |
     |       sparc: | TODO |
-    |        tile: | TODO |
+    |        tile: |  ok  |
     |          um: | TODO |
     |   unicore32: | TODO |
     |         x86: |  ok  |
