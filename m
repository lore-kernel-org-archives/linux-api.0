From: tip-bot for Ingo Molnar <tipbot@zytor.com>
Subject: [tip:core/documentation] Documentation/features/perf:
  Add feature description and arch support status file for 'perf-stackdump'
Date: Wed, 3 Jun 2015 04:19:00 -0700
Message-ID: <tip-05934cad2dd9c4b36261352d2933cc9c2b679f0c@git.kernel.org>
Reply-To: peterz@infradead.org, hpa@zytor.com, akpm@linux-foundation.org,
	  corbet@lwn.net, torvalds@linux-foundation.org,
	  tglx@linutronix.de, linux-api@vger.kernel.org,
	  linux-kernel@vger.kernel.org, mingo@kernel.org,
	  josh@joshtriplett.org, linux-arch@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-arch-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-arch-owner@vger.kernel.org
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, tglx@linutronix.de, torvalds@linux-foundation.org, corbet@lwn.net, akpm@linux-foundation.org, hpa@zytor.com, peterz@infradead.org, josh@joshtriplett.org, linux-arch@vger.kernel.org, mingo@kernel.org
List-Id: linux-api@vger.kernel.org

Commit-ID:  05934cad2dd9c4b36261352d2933cc9c2b679f0c
Gitweb:     http://git.kernel.org/tip/05934cad2dd9c4b36261352d2933cc9c2b679f0c
Author:     Ingo Molnar <mingo@kernel.org>
AuthorDate: Wed, 3 Jun 2015 12:37:38 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 3 Jun 2015 12:51:42 +0200

Documentation/features/perf: Add feature description and arch support status file for 'perf-stackdump'

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
 .../features/perf/{perf-regs => perf-stackdump}/arch-support.txt    | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/Documentation/features/perf/perf-regs/arch-support.txt b/Documentation/features/perf/perf-stackdump/arch-support.txt
similarity index 86%
copy from Documentation/features/perf/perf-regs/arch-support.txt
copy to Documentation/features/perf/perf-stackdump/arch-support.txt
index e2b4a78..3dc24b0 100644
--- a/Documentation/features/perf/perf-regs/arch-support.txt
+++ b/Documentation/features/perf/perf-stackdump/arch-support.txt
@@ -1,7 +1,7 @@
 #
-# Feature name:          perf-regs
-#         Kconfig:       HAVE_PERF_REGS
-#         description:   arch supports perf events register access
+# Feature name:          perf-stackdump
+#         Kconfig:       HAVE_PERF_USER_STACK_DUMP
+#         description:   arch supports perf events stack dumps
 #
     -----------------------
     |         arch |status|
