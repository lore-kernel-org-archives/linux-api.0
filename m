From: tip-bot for Ingo Molnar <tipbot@zytor.com>
Subject: [tip:core/documentation] Documentation/features/vm:
  Add feature description and arch support status file for 'ELF-ASLR'
Date: Wed, 3 Jun 2015 04:15:10 -0700
Message-ID: <tip-343163ca15954bcd926ced32616821d540612104@git.kernel.org>
Reply-To: torvalds@linux-foundation.org, linux-api@vger.kernel.org,
	  mingo@kernel.org, corbet@lwn.net, hpa@zytor.com,
	  peterz@infradead.org, linux-kernel@vger.kernel.org,
	  akpm@linux-foundation.org, linux-arch@vger.kernel.org,
	  josh@joshtriplett.org, tglx@linutronix.de
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-arch-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-arch-owner@vger.kernel.org
To: linux-tip-commits@vger.kernel.org
Cc: corbet@lwn.net, mingo@kernel.org, linux-api@vger.kernel.org, torvalds@linux-foundation.org, tglx@linutronix.de, josh@joshtriplett.org, linux-arch@vger.kernel.org, akpm@linux-foundation.org, linux-kernel@vger.kernel.org, hpa@zytor.com, peterz@infradead.org
List-Id: linux-api@vger.kernel.org

Commit-ID:  343163ca15954bcd926ced32616821d540612104
Gitweb:     http://git.kernel.org/tip/343163ca15954bcd926ced32616821d540612104
Author:     Ingo Molnar <mingo@kernel.org>
AuthorDate: Wed, 3 Jun 2015 12:37:25 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 3 Jun 2015 12:51:39 +0200

Documentation/features/vm: Add feature description and arch support status file for 'ELF-ASLR'

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
 .../features/vm/{pmdp_splitting_flush => ELF-ASLR}/arch-support.txt | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/Documentation/features/vm/pmdp_splitting_flush/arch-support.txt b/Documentation/features/vm/ELF-ASLR/arch-support.txt
similarity index 84%
copy from Documentation/features/vm/pmdp_splitting_flush/arch-support.txt
copy to Documentation/features/vm/ELF-ASLR/arch-support.txt
index 26f74b4..ec4dd28 100644
--- a/Documentation/features/vm/pmdp_splitting_flush/arch-support.txt
+++ b/Documentation/features/vm/ELF-ASLR/arch-support.txt
@@ -1,7 +1,7 @@
 #
-# Feature name:          pmdp_splitting_flush
-#         Kconfig:       __HAVE_ARCH_PMDP_SPLITTING_FLUSH
-#         description:   arch supports the pmdp_splitting_flush() VM API
+# Feature name:          ELF-ASLR
+#         Kconfig:       ARCH_HAS_ELF_RANDOMIZE
+#         description:   arch randomizes the stack, heap and binary images of ELF binaries
 #
     -----------------------
     |         arch |status|
