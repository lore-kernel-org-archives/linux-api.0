From: tip-bot for Ingo Molnar <tipbot@zytor.com>
Subject: [tip:core/documentation] Documentation/features/debug:
  Add feature description and arch support status file for 'kgdb'
Date: Wed, 3 Jun 2015 04:14:28 -0700
Message-ID: <tip-47af18fea1a47aa98f416bc6ba9d67ca557859ab@git.kernel.org>
Reply-To: josh@joshtriplett.org, linux-api@vger.kernel.org, hpa@zytor.com,
	  tglx@linutronix.de, torvalds@linux-foundation.org,
	  akpm@linux-foundation.org, peterz@infradead.org,
	  linux-arch@vger.kernel.org, corbet@lwn.net,
	  linux-kernel@vger.kernel.org, mingo@kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: linux-tip-commits@vger.kernel.org
Cc: tglx@linutronix.de, hpa@zytor.com, linux-api@vger.kernel.org, josh@joshtriplett.org, mingo@kernel.org, linux-kernel@vger.kernel.org, corbet@lwn.net, linux-arch@vger.kernel.org, peterz@infradead.org, akpm@linux-foundation.org, torvalds@linux-foundation.org
List-Id: linux-api@vger.kernel.org

Commit-ID:  47af18fea1a47aa98f416bc6ba9d67ca557859ab
Gitweb:     http://git.kernel.org/tip/47af18fea1a47aa98f416bc6ba9d67ca557859ab
Author:     Ingo Molnar <mingo@kernel.org>
AuthorDate: Wed, 3 Jun 2015 12:37:23 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 3 Jun 2015 12:51:38 +0200

Documentation/features/debug: Add feature description and arch support status file for 'kgdb'

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
 .../context-tracking => debug/kgdb}/arch-support.txt | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/Documentation/features/time/context-tracking/arch-support.txt b/Documentation/features/debug/kgdb/arch-support.txt
similarity index 68%
copy from Documentation/features/time/context-tracking/arch-support.txt
copy to Documentation/features/debug/kgdb/arch-support.txt
index a1e3eea..862e15d 100644
--- a/Documentation/features/time/context-tracking/arch-support.txt
+++ b/Documentation/features/debug/kgdb/arch-support.txt
@@ -1,36 +1,36 @@
 #
-# Feature name:          context-tracking
-#         Kconfig:       HAVE_CONTEXT_TRACKING
-#         description:   arch supports context tracking for NO_HZ_FULL
+# Feature name:          kgdb
+#         Kconfig:       HAVE_ARCH_KGDB
+#         description:   arch supports the kGDB kernel debugger
 #
     -----------------------
     |         arch |status|
     -----------------------
     |       alpha: | TODO |
-    |         arc: | TODO |
+    |         arc: |  ok  |
     |         arm: |  ok  |
     |       arm64: |  ok  |
     |       avr32: | TODO |
-    |    blackfin: | TODO |
+    |    blackfin: |  ok  |
     |         c6x: | TODO |
     |        cris: | TODO |
     |         frv: | TODO |
     |       h8300: | TODO |
-    |     hexagon: | TODO |
+    |     hexagon: |  ok  |
     |        ia64: | TODO |
     |        m32r: | TODO |
     |        m68k: | TODO |
     |       metag: | TODO |
-    |  microblaze: | TODO |
+    |  microblaze: |  ok  |
     |        mips: |  ok  |
-    |     mn10300: | TODO |
-    |       nios2: | TODO |
+    |     mn10300: |  ok  |
+    |       nios2: |  ok  |
     |    openrisc: | TODO |
     |      parisc: | TODO |
     |     powerpc: |  ok  |
     |        s390: | TODO |
     |       score: | TODO |
-    |          sh: | TODO |
+    |          sh: |  ok  |
     |       sparc: |  ok  |
     |        tile: |  ok  |
     |          um: | TODO |
