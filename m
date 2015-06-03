From: tip-bot for Ingo Molnar <tipbot@zytor.com>
Subject: [tip:core/documentation] Documentation/features/debug:
  Add feature description and arch support status file for 'KASAN'
Date: Wed, 3 Jun 2015 04:09:23 -0700
Message-ID: <tip-2729924765bcfa9e4cf7595c49b472b561413255@git.kernel.org>
Reply-To: linux-api@vger.kernel.org, hpa@zytor.com,
	  akpm@linux-foundation.org, josh@joshtriplett.org,
	  mingo@kernel.org, peterz@infradead.org, tglx@linutronix.de,
	  torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
	  corbet@lwn.net, linux-arch@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-arch-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-arch-owner@vger.kernel.org
To: linux-tip-commits@vger.kernel.org
Cc: hpa@zytor.com, linux-api@vger.kernel.org, josh@joshtriplett.org, akpm@linux-foundation.org, mingo@kernel.org, tglx@linutronix.de, peterz@infradead.org, torvalds@linux-foundation.org, corbet@lwn.net, linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Commit-ID:  2729924765bcfa9e4cf7595c49b472b561413255
Gitweb:     http://git.kernel.org/tip/2729924765bcfa9e4cf7595c49b472b561413255
Author:     Ingo Molnar <mingo@kernel.org>
AuthorDate: Wed, 3 Jun 2015 12:37:03 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 3 Jun 2015 12:51:34 +0200

Documentation/features/debug: Add feature description and arch support status file for 'KASAN'

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
 .../features/{vm/huge-vmap => debug/KASAN}/arch-support.txt         | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/Documentation/features/vm/huge-vmap/arch-support.txt b/Documentation/features/debug/KASAN/arch-support.txt
similarity index 84%
copy from Documentation/features/vm/huge-vmap/arch-support.txt
copy to Documentation/features/debug/KASAN/arch-support.txt
index af6816b..14531da 100644
--- a/Documentation/features/vm/huge-vmap/arch-support.txt
+++ b/Documentation/features/debug/KASAN/arch-support.txt
@@ -1,7 +1,7 @@
 #
-# Feature name:          huge-vmap
-#         Kconfig:       HAVE_ARCH_HUGE_VMAP
-#         description:   arch supports the ioremap_pud_enabled() and ioremap_pmd_enabled() VM APIs
+# Feature name:          KASAN
+#         Kconfig:       HAVE_ARCH_KASAN
+#         description:   arch supports the KASAN runtime memory checker
 #
     -----------------------
     |         arch |status|
