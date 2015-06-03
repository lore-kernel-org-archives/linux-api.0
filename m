From: tip-bot for Ingo Molnar <tipbot@zytor.com>
Subject: [tip:core/documentation] Documentation/features/debug:
  Add feature description and arch support status file for '
 gcov-profile-all'
Date: Wed, 3 Jun 2015 04:19:41 -0700
Message-ID: <tip-5fac5f55f3fd4d9e639778c0d6e412d8ff0b5528@git.kernel.org>
Reply-To: torvalds@linux-foundation.org, tglx@linutronix.de, hpa@zytor.com,
	  peterz@infradead.org, mingo@kernel.org,
	  akpm@linux-foundation.org, corbet@lwn.net,
	  linux-arch@vger.kernel.org, linux-api@vger.kernel.org,
	  linux-kernel@vger.kernel.org, josh@joshtriplett.org
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: linux-tip-commits@vger.kernel.org
Cc: tglx@linutronix.de, torvalds@linux-foundation.org, hpa@zytor.com, peterz@infradead.org, linux-arch@vger.kernel.org, corbet@lwn.net, linux-api@vger.kernel.org, mingo@kernel.org, akpm@linux-foundation.org, josh@joshtriplett.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Commit-ID:  5fac5f55f3fd4d9e639778c0d6e412d8ff0b5528
Gitweb:     http://git.kernel.org/tip/5fac5f55f3fd4d9e639778c0d6e412d8ff0b5528
Author:     Ingo Molnar <mingo@kernel.org>
AuthorDate: Wed, 3 Jun 2015 12:37:40 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 3 Jun 2015 12:51:43 +0200

Documentation/features/debug: Add feature description and arch support status file for 'gcov-profile-all'

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
 .../pte_special => debug/gcov-profile-all}/arch-support.txt    | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/Documentation/features/vm/pte_special/arch-support.txt b/Documentation/features/debug/gcov-profile-all/arch-support.txt
similarity index 80%
copy from Documentation/features/vm/pte_special/arch-support.txt
copy to Documentation/features/debug/gcov-profile-all/arch-support.txt
index aaaa21d..38dea8e 100644
--- a/Documentation/features/vm/pte_special/arch-support.txt
+++ b/Documentation/features/debug/gcov-profile-all/arch-support.txt
@@ -1,7 +1,7 @@
 #
-# Feature name:          pte_special
-#         Kconfig:       __HAVE_ARCH_PTE_SPECIAL
-#         description:   arch supports the pte_special()/pte_mkspecial() VM APIs
+# Feature name:          gcov-profile-all
+#         Kconfig:       ARCH_HAS_GCOV_PROFILE_ALL
+#         description:   arch supports whole-kernel GCOV code coverage profiling
 #
     -----------------------
     |         arch |status|
@@ -21,7 +21,7 @@
     |        m32r: | TODO |
     |        m68k: | TODO |
     |       metag: | TODO |
-    |  microblaze: | TODO |
+    |  microblaze: |  ok  |
     |        mips: | TODO |
     |     mn10300: | TODO |
     |       nios2: | TODO |
@@ -31,7 +31,7 @@
     |        s390: |  ok  |
     |       score: | TODO |
     |          sh: |  ok  |
-    |       sparc: |  ok  |
+    |       sparc: | TODO |
     |        tile: | TODO |
     |          um: | TODO |
     |   unicore32: | TODO |
