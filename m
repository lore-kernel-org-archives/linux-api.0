From: tip-bot for Ingo Molnar <tipbot@zytor.com>
Subject: [tip:core/documentation] Documentation/features/debug:
  Add feature description and arch support status file for '
 user-ret-profiler'
Date: Wed, 3 Jun 2015 04:17:26 -0700
Message-ID: <tip-5d5cd30e6a897fead07639d9684e9c6910e2527c@git.kernel.org>
Reply-To: peterz@infradead.org, hpa@zytor.com,
	  torvalds@linux-foundation.org, tglx@linutronix.de,
	  mingo@kernel.org, linux-api@vger.kernel.org,
	  linux-arch@vger.kernel.org, corbet@lwn.net,
	  akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
	  josh@joshtriplett.org
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-arch-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-arch-owner@vger.kernel.org
To: linux-tip-commits@vger.kernel.org
Cc: linux-arch@vger.kernel.org, peterz@infradead.org, hpa@zytor.com, torvalds@linux-foundation.org, mingo@kernel.org, tglx@linutronix.de, linux-api@vger.kernel.org, akpm@linux-foundation.org, josh@joshtriplett.org, linux-kernel@vger.kernel.org, corbet@lwn.net
List-Id: linux-api@vger.kernel.org

Commit-ID:  5d5cd30e6a897fead07639d9684e9c6910e2527c
Gitweb:     http://git.kernel.org/tip/5d5cd30e6a897fead07639d9684e9c6910e2527c
Author:     Ingo Molnar <mingo@kernel.org>
AuthorDate: Wed, 3 Jun 2015 12:37:33 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 3 Jun 2015 12:51:41 +0200

Documentation/features/debug: Add feature description and arch support status file for 'user-ret-profiler'

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
 .../{kprobes-on-ftrace => user-ret-profiler}/arch-support.txt     | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/Documentation/features/debug/kprobes-on-ftrace/arch-support.txt b/Documentation/features/debug/user-ret-profiler/arch-support.txt
similarity index 82%
copy from Documentation/features/debug/kprobes-on-ftrace/arch-support.txt
copy to Documentation/features/debug/user-ret-profiler/arch-support.txt
index 40f44d0..44cc1ff 100644
--- a/Documentation/features/debug/kprobes-on-ftrace/arch-support.txt
+++ b/Documentation/features/debug/user-ret-profiler/arch-support.txt
@@ -1,7 +1,7 @@
 #
-# Feature name:          kprobes-on-ftrace
-#         Kconfig:       HAVE_KPROBES_ON_FTRACE
-#         description:   arch supports combined kprobes and ftrace live patching
+# Feature name:          user-ret-profiler
+#         Kconfig:       HAVE_USER_RETURN_NOTIFIER
+#         description:   arch supports user-space return from system call profiler
 #
     -----------------------
     |         arch |status|
@@ -32,7 +32,7 @@
     |       score: | TODO |
     |          sh: | TODO |
     |       sparc: | TODO |
-    |        tile: | TODO |
+    |        tile: |  ok  |
     |          um: | TODO |
     |   unicore32: | TODO |
     |         x86: |  ok  |
