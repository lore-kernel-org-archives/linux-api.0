From: tip-bot for Ingo Molnar <tipbot@zytor.com>
Subject: [tip:core/documentation] Documentation/features/vm:
  Add feature description and arch support status file for 'pte_special'
Date: Wed, 3 Jun 2015 04:08:42 -0700
Message-ID: <tip-f643e6a69a60d1f91bc4bc0375ae2d065081f61b@git.kernel.org>
Reply-To: torvalds@linux-foundation.org, mingo@kernel.org,
	  peterz@infradead.org, hpa@zytor.com, josh@joshtriplett.org,
	  linux-arch@vger.kernel.org, linux-api@vger.kernel.org,
	  corbet@lwn.net, akpm@linux-foundation.org,
	  linux-kernel@vger.kernel.org, tglx@linutronix.de
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-arch-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-arch-owner@vger.kernel.org
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, corbet@lwn.net, linux-api@vger.kernel.org, akpm@linux-foundation.org, josh@joshtriplett.org, linux-arch@vger.kernel.org, torvalds@linux-foundation.org, mingo@kernel.org, peterz@infradead.org, hpa@zytor.com
List-Id: linux-api@vger.kernel.org

Commit-ID:  f643e6a69a60d1f91bc4bc0375ae2d065081f61b
Gitweb:     http://git.kernel.org/tip/f643e6a69a60d1f91bc4bc0375ae2d065081f61b
Author:     Ingo Molnar <mingo@kernel.org>
AuthorDate: Wed, 3 Jun 2015 12:37:01 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 3 Jun 2015 12:51:33 +0200

Documentation/features/vm: Add feature description and arch support status file for 'pte_special'

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
 .../features/{io/sg-chain => vm/pte_special}/arch-support.txt  | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/Documentation/features/io/sg-chain/arch-support.txt b/Documentation/features/vm/pte_special/arch-support.txt
similarity index 80%
copy from Documentation/features/io/sg-chain/arch-support.txt
copy to Documentation/features/vm/pte_special/arch-support.txt
index b9b6755..aaaa21d 100644
--- a/Documentation/features/io/sg-chain/arch-support.txt
+++ b/Documentation/features/vm/pte_special/arch-support.txt
@@ -1,7 +1,7 @@
 #
-# Feature name:          sg-chain
-#         Kconfig:       ARCH_HAS_SG_CHAIN
-#         description:   arch supports chained scatter-gather lists
+# Feature name:          pte_special
+#         Kconfig:       __HAVE_ARCH_PTE_SPECIAL
+#         description:   arch supports the pte_special()/pte_mkspecial() VM APIs
 #
     -----------------------
     |         arch |status|
@@ -17,7 +17,7 @@
     |         frv: | TODO |
     |       h8300: | TODO |
     |     hexagon: | TODO |
-    |        ia64: |  ok  |
+    |        ia64: | TODO |
     |        m32r: | TODO |
     |        m68k: | TODO |
     |       metag: | TODO |
@@ -30,7 +30,7 @@
     |     powerpc: |  ok  |
     |        s390: |  ok  |
     |       score: | TODO |
-    |          sh: | TODO |
+    |          sh: |  ok  |
     |       sparc: |  ok  |
     |        tile: | TODO |
     |          um: | TODO |
