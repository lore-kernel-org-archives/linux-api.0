From: tip-bot for Ingo Molnar <tipbot@zytor.com>
Subject: [tip:core/documentation] Documentation/features/lib:
  Add feature description and arch support status file for 'strncasecmp'
Date: Wed, 3 Jun 2015 04:07:41 -0700
Message-ID: <tip-b85c92c32739bc6dacb8e1f89a760d4ccf095a0d@git.kernel.org>
Reply-To: linux-arch@vger.kernel.org, tglx@linutronix.de,
	  akpm@linux-foundation.org, josh@joshtriplett.org,
	  torvalds@linux-foundation.org, hpa@zytor.com,
	  linux-kernel@vger.kernel.org, corbet@lwn.net, mingo@kernel.org,
	  peterz@infradead.org, linux-api@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-arch-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-arch-owner@vger.kernel.org
To: linux-tip-commits@vger.kernel.org
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org, hpa@zytor.com, linux-arch@vger.kernel.org, tglx@linutronix.de, akpm@linux-foundation.org, josh@joshtriplett.org, mingo@kernel.org, peterz@infradead.org, linux-api@vger.kernel.org, corbet@lwn.net
List-Id: linux-api@vger.kernel.org

Commit-ID:  b85c92c32739bc6dacb8e1f89a760d4ccf095a0d
Gitweb:     http://git.kernel.org/tip/b85c92c32739bc6dacb8e1f89a760d4ccf095a0d
Author:     Ingo Molnar <mingo@kernel.org>
AuthorDate: Wed, 3 Jun 2015 12:36:57 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 3 Jun 2015 12:51:33 +0200

Documentation/features/lib: Add feature description and arch support status file for 'strncasecmp'

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
 .../{vm/PG_uncached => lib/strncasecmp}/arch-support.txt       | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/Documentation/features/vm/PG_uncached/arch-support.txt b/Documentation/features/lib/strncasecmp/arch-support.txt
similarity index 81%
copy from Documentation/features/vm/PG_uncached/arch-support.txt
copy to Documentation/features/lib/strncasecmp/arch-support.txt
index 9919742..12b1c93 100644
--- a/Documentation/features/vm/PG_uncached/arch-support.txt
+++ b/Documentation/features/lib/strncasecmp/arch-support.txt
@@ -1,7 +1,7 @@
 #
-# Feature name:          PG_uncached
-#         Kconfig:       ARCH_USES_PG_UNCACHED
-#         description:   arch supports the PG_uncached page flag
+# Feature name:          strncasecmp
+#         Kconfig:       __HAVE_ARCH_STRNCASECMP
+#         description:   arch provides an optimized strncasecmp() function
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
@@ -35,6 +35,6 @@
     |        tile: | TODO |
     |          um: | TODO |
     |   unicore32: | TODO |
-    |         x86: |  ok  |
+    |         x86: | TODO |
     |      xtensa: | TODO |
     -----------------------
