From: tip-bot for Ingo Molnar <tipbot@zytor.com>
Subject: [tip:core/documentation] Documentation/features/core:
  Add feature description and arch support status file for 'jump-labels'
Date: Wed, 3 Jun 2015 04:13:31 -0700
Message-ID: <tip-d8affc78130a87ea6a4027d6a8ede91486bfef27@git.kernel.org>
Reply-To: peterz@infradead.org, hpa@zytor.com, linux-api@vger.kernel.org,
	  torvalds@linux-foundation.org, tglx@linutronix.de,
	  linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
	  josh@joshtriplett.org, corbet@lwn.net, mingo@kernel.org,
	  akpm@linux-foundation.org
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-arch-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-arch-owner@vger.kernel.org
To: linux-tip-commits@vger.kernel.org
Cc: josh@joshtriplett.org, akpm@linux-foundation.org, mingo@kernel.org, corbet@lwn.net, peterz@infradead.org, hpa@zytor.com, linux-api@vger.kernel.org, torvalds@linux-foundation.org, linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, tglx@linutronix.de
List-Id: linux-api@vger.kernel.org

Commit-ID:  d8affc78130a87ea6a4027d6a8ede91486bfef27
Gitweb:     http://git.kernel.org/tip/d8affc78130a87ea6a4027d6a8ede91486bfef27
Author:     Ingo Molnar <mingo@kernel.org>
AuthorDate: Wed, 3 Jun 2015 12:37:19 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 3 Jun 2015 12:51:37 +0200

Documentation/features/core: Add feature description and arch support status file for 'jump-labels'

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
 .../pmdp_splitting_flush => core/jump-labels}/arch-support.txt    | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/Documentation/features/vm/pmdp_splitting_flush/arch-support.txt b/Documentation/features/core/jump-labels/arch-support.txt
similarity index 82%
copy from Documentation/features/vm/pmdp_splitting_flush/arch-support.txt
copy to Documentation/features/core/jump-labels/arch-support.txt
index 26f74b4..136868b 100644
--- a/Documentation/features/vm/pmdp_splitting_flush/arch-support.txt
+++ b/Documentation/features/core/jump-labels/arch-support.txt
@@ -1,7 +1,7 @@
 #
-# Feature name:          pmdp_splitting_flush
-#         Kconfig:       __HAVE_ARCH_PMDP_SPLITTING_FLUSH
-#         description:   arch supports the pmdp_splitting_flush() VM API
+# Feature name:          jump-labels
+#         Kconfig:       HAVE_ARCH_JUMP_LABEL
+#         description:   arch supports live patched, high efficiency branches
 #
     -----------------------
     |         arch |status|
@@ -31,7 +31,7 @@
     |        s390: |  ok  |
     |       score: | TODO |
     |          sh: | TODO |
-    |       sparc: | TODO |
+    |       sparc: |  ok  |
     |        tile: | TODO |
     |          um: | TODO |
     |   unicore32: | TODO |
