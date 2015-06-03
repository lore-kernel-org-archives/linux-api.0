From: tip-bot for Ingo Molnar <tipbot@zytor.com>
Subject: [tip:core/documentation] Documentation/features/locking:
  Add feature description and arch support status file for 'queued-rwlocks'
Date: Wed, 3 Jun 2015 04:20:20 -0700
Message-ID: <tip-2eda9972bbd12b9feb92ec057deac8e8846e650d@git.kernel.org>
Reply-To: linux-arch@vger.kernel.org, tglx@linutronix.de, hpa@zytor.com,
	  corbet@lwn.net, linux-kernel@vger.kernel.org,
	  linux-api@vger.kernel.org, akpm@linux-foundation.org,
	  torvalds@linux-foundation.org, mingo@kernel.org,
	  josh@joshtriplett.org, peterz@infradead.org
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: linux-tip-commits@vger.kernel.org
Cc: tglx@linutronix.de, hpa@zytor.com, linux-arch@vger.kernel.org, corbet@lwn.net, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, torvalds@linux-foundation.org, akpm@linux-foundation.org, mingo@kernel.org, peterz@infradead.org, josh@joshtriplett.org
List-Id: linux-api@vger.kernel.org

Commit-ID:  2eda9972bbd12b9feb92ec057deac8e8846e650d
Gitweb:     http://git.kernel.org/tip/2eda9972bbd12b9feb92ec057deac8e8846e650d
Author:     Ingo Molnar <mingo@kernel.org>
AuthorDate: Wed, 3 Jun 2015 12:37:43 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 3 Jun 2015 12:51:43 +0200

Documentation/features/locking: Add feature description and arch support status file for 'queued-rwlocks'

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
 .../{debug/KASAN => locking/queued-rwlocks}/arch-support.txt        | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/Documentation/features/debug/KASAN/arch-support.txt b/Documentation/features/locking/queued-rwlocks/arch-support.txt
similarity index 87%
copy from Documentation/features/debug/KASAN/arch-support.txt
copy to Documentation/features/locking/queued-rwlocks/arch-support.txt
index 14531da..68c3a5d 100644
--- a/Documentation/features/debug/KASAN/arch-support.txt
+++ b/Documentation/features/locking/queued-rwlocks/arch-support.txt
@@ -1,7 +1,7 @@
 #
-# Feature name:          KASAN
-#         Kconfig:       HAVE_ARCH_KASAN
-#         description:   arch supports the KASAN runtime memory checker
+# Feature name:          queued-rwlocks
+#         Kconfig:       ARCH_USE_QUEUED_RWLOCKS
+#         description:   arch supports queued rwlocks
 #
     -----------------------
     |         arch |status|
