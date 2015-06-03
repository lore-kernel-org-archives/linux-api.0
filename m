From: tip-bot for Ingo Molnar <tipbot@zytor.com>
Subject: [tip:core/documentation] Documentation/features/debug:
  Add feature description and arch support status file for '
 kprobes-on-ftrace'
Date: Wed, 3 Jun 2015 04:16:29 -0700
Message-ID: <tip-9cf5bcc3ddc4f291f54e680b75ad3957e2d468f9@git.kernel.org>
Reply-To: mingo@kernel.org, tglx@linutronix.de, peterz@infradead.org,
	  akpm@linux-foundation.org, josh@joshtriplett.org,
	  linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
	  linux-arch@vger.kernel.org, torvalds@linux-foundation.org,
	  corbet@lwn.net, hpa@zytor.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: linux-tip-commits@vger.kernel.org
Cc: tglx@linutronix.de, mingo@kernel.org, akpm@linux-foundation.org, josh@joshtriplett.org, peterz@infradead.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, hpa@zytor.com, corbet@lwn.net, torvalds@linux-foundation.org, linux-arch@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Commit-ID:  9cf5bcc3ddc4f291f54e680b75ad3957e2d468f9
Gitweb:     http://git.kernel.org/tip/9cf5bcc3ddc4f291f54e680b75ad3957e2d468f9
Author:     Ingo Molnar <mingo@kernel.org>
AuthorDate: Wed, 3 Jun 2015 12:37:29 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 3 Jun 2015 12:51:40 +0200

Documentation/features/debug: Add feature description and arch support status file for 'kprobes-on-ftrace'

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
 .../features/debug/{KASAN => kprobes-on-ftrace}/arch-support.txt    | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/Documentation/features/debug/KASAN/arch-support.txt b/Documentation/features/debug/kprobes-on-ftrace/arch-support.txt
similarity index 85%
copy from Documentation/features/debug/KASAN/arch-support.txt
copy to Documentation/features/debug/kprobes-on-ftrace/arch-support.txt
index 14531da..40f44d0 100644
--- a/Documentation/features/debug/KASAN/arch-support.txt
+++ b/Documentation/features/debug/kprobes-on-ftrace/arch-support.txt
@@ -1,7 +1,7 @@
 #
-# Feature name:          KASAN
-#         Kconfig:       HAVE_ARCH_KASAN
-#         description:   arch supports the KASAN runtime memory checker
+# Feature name:          kprobes-on-ftrace
+#         Kconfig:       HAVE_KPROBES_ON_FTRACE
+#         description:   arch supports combined kprobes and ftrace live patching
 #
     -----------------------
     |         arch |status|
