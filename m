From: tip-bot for Ingo Molnar <tipbot@zytor.com>
Subject: [tip:core/documentation] Documentation/features/perf:
  Add feature description and arch support status file for 'kprobes-event'
Date: Wed, 3 Jun 2015 04:18:05 -0700
Message-ID: <tip-8994f7bbe2110dd6fec24f8474392d105d99b253@git.kernel.org>
Reply-To: corbet@lwn.net, mingo@kernel.org, linux-api@vger.kernel.org,
	  peterz@infradead.org, josh@joshtriplett.org,
	  torvalds@linux-foundation.org, akpm@linux-foundation.org,
	  linux-arch@vger.kernel.org, tglx@linutronix.de, hpa@zytor.com,
	  linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-arch-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-arch-owner@vger.kernel.org
To: linux-tip-commits@vger.kernel.org
Cc: mingo@kernel.org, linux-api@vger.kernel.org, corbet@lwn.net, josh@joshtriplett.org, peterz@infradead.org, linux-arch@vger.kernel.org, tglx@linutronix.de, torvalds@linux-foundation.org, akpm@linux-foundation.org, hpa@zytor.com, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Commit-ID:  8994f7bbe2110dd6fec24f8474392d105d99b253
Gitweb:     http://git.kernel.org/tip/8994f7bbe2110dd6fec24f8474392d105d99b253
Author:     Ingo Molnar <mingo@kernel.org>
AuthorDate: Wed, 3 Jun 2015 12:37:35 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 3 Jun 2015 12:51:41 +0200

Documentation/features/perf: Add feature description and arch support status file for 'kprobes-event'

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
 .../{debug/uprobes => perf/kprobes-event}/arch-support.txt   | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/Documentation/features/debug/uprobes/arch-support.txt b/Documentation/features/perf/kprobes-event/arch-support.txt
similarity index 78%
copy from Documentation/features/debug/uprobes/arch-support.txt
copy to Documentation/features/perf/kprobes-event/arch-support.txt
index 4efe36c..9855ad0 100644
--- a/Documentation/features/debug/uprobes/arch-support.txt
+++ b/Documentation/features/perf/kprobes-event/arch-support.txt
@@ -1,7 +1,7 @@
 #
-# Feature name:          uprobes
-#         Kconfig:       ARCH_SUPPORTS_UPROBES
-#         description:   arch supports live patched user probes
+# Feature name:          kprobes-event
+#         Kconfig:       HAVE_REGS_AND_STACK_ACCESS_API
+#         description:   arch supports kprobes with perf events
 #
     -----------------------
     |         arch |status|
@@ -16,7 +16,7 @@
     |        cris: | TODO |
     |         frv: | TODO |
     |       h8300: | TODO |
-    |     hexagon: | TODO |
+    |     hexagon: |  ok  |
     |        ia64: | TODO |
     |        m32r: | TODO |
     |        m68k: | TODO |
@@ -30,9 +30,9 @@
     |     powerpc: |  ok  |
     |        s390: |  ok  |
     |       score: | TODO |
-    |          sh: | TODO |
+    |          sh: |  ok  |
     |       sparc: | TODO |
-    |        tile: | TODO |
+    |        tile: |  ok  |
     |          um: | TODO |
     |   unicore32: | TODO |
     |         x86: |  ok  |
