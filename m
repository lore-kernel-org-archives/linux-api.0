From: tip-bot for Ingo Molnar <tipbot@zytor.com>
Subject: [tip:core/documentation] Documentation/features/locking:
  Add feature description and arch support status file for '
 queued-spinlocks'
Date: Wed, 3 Jun 2015 04:20:01 -0700
Message-ID: <tip-33006fae4bd7633ba4486a3cf64ad1cd1e8aa093@git.kernel.org>
Reply-To: linux-kernel@vger.kernel.org, peterz@infradead.org,
	  mingo@kernel.org, linux-arch@vger.kernel.org, hpa@zytor.com,
	  torvalds@linux-foundation.org, linux-api@vger.kernel.org,
	  josh@joshtriplett.org, corbet@lwn.net, tglx@linutronix.de,
	  akpm@linux-foundation.org
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-arch-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-arch-owner@vger.kernel.org
To: linux-tip-commits@vger.kernel.org
Cc: hpa@zytor.com, torvalds@linux-foundation.org, linux-arch@vger.kernel.org, akpm@linux-foundation.org, tglx@linutronix.de, corbet@lwn.net, josh@joshtriplett.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@kernel.org
List-Id: linux-api@vger.kernel.org

Commit-ID:  33006fae4bd7633ba4486a3cf64ad1cd1e8aa093
Gitweb:     http://git.kernel.org/tip/33006fae4bd7633ba4486a3cf64ad1cd1e8aa093
Author:     Ingo Molnar <mingo@kernel.org>
AuthorDate: Wed, 3 Jun 2015 12:37:42 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 3 Jun 2015 12:51:43 +0200

Documentation/features/locking: Add feature description and arch support status file for 'queued-spinlocks'

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
 .../{debug/KASAN => locking/queued-spinlocks}/arch-support.txt      | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/Documentation/features/debug/KASAN/arch-support.txt b/Documentation/features/locking/queued-spinlocks/arch-support.txt
similarity index 86%
copy from Documentation/features/debug/KASAN/arch-support.txt
copy to Documentation/features/locking/queued-spinlocks/arch-support.txt
index 14531da..e973b1a 100644
--- a/Documentation/features/debug/KASAN/arch-support.txt
+++ b/Documentation/features/locking/queued-spinlocks/arch-support.txt
@@ -1,7 +1,7 @@
 #
-# Feature name:          KASAN
-#         Kconfig:       HAVE_ARCH_KASAN
-#         description:   arch supports the KASAN runtime memory checker
+# Feature name:          queued-spinlocks
+#         Kconfig:       ARCH_USE_QUEUED_SPINLOCKS
+#         description:   arch supports queued spinlocks
 #
     -----------------------
     |         arch |status|
