From: tip-bot for Ingo Molnar <tipbot@zytor.com>
Subject: [tip:core/documentation] Documentation/features/core:
  Add feature description and arch support status file for 'BPF-JIT'
Date: Wed, 3 Jun 2015 04:20:38 -0700
Message-ID: <tip-b07b6ecc01fa435d1c5d3fc50ee675ed36dd89d5@git.kernel.org>
Reply-To: josh@joshtriplett.org, linux-kernel@vger.kernel.org,
	  corbet@lwn.net, torvalds@linux-foundation.org,
	  linux-api@vger.kernel.org, tglx@linutronix.de,
	  peterz@infradead.org, hpa@zytor.com, linux-arch@vger.kernel.org,
	  mingo@kernel.org, akpm@linux-foundation.org
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-arch-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-arch-owner@vger.kernel.org
To: linux-tip-commits@vger.kernel.org
Cc: tglx@linutronix.de, linux-api@vger.kernel.org, corbet@lwn.net, torvalds@linux-foundation.org, linux-kernel@vger.kernel.org, josh@joshtriplett.org, akpm@linux-foundation.org, mingo@kernel.org, linux-arch@vger.kernel.org, hpa@zytor.com, peterz@infradead.org
List-Id: linux-api@vger.kernel.org

Commit-ID:  b07b6ecc01fa435d1c5d3fc50ee675ed36dd89d5
Gitweb:     http://git.kernel.org/tip/b07b6ecc01fa435d1c5d3fc50ee675ed36dd89d5
Author:     Ingo Molnar <mingo@kernel.org>
AuthorDate: Wed, 3 Jun 2015 12:37:44 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 3 Jun 2015 12:51:43 +0200

Documentation/features/core: Add feature description and arch support status file for 'BPF-JIT'

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
 .../features/core/{jump-labels => BPF-JIT}/arch-support.txt         | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/Documentation/features/core/jump-labels/arch-support.txt b/Documentation/features/core/BPF-JIT/arch-support.txt
similarity index 85%
copy from Documentation/features/core/jump-labels/arch-support.txt
copy to Documentation/features/core/BPF-JIT/arch-support.txt
index 136868b..c1b4f91 100644
--- a/Documentation/features/core/jump-labels/arch-support.txt
+++ b/Documentation/features/core/BPF-JIT/arch-support.txt
@@ -1,7 +1,7 @@
 #
-# Feature name:          jump-labels
-#         Kconfig:       HAVE_ARCH_JUMP_LABEL
-#         description:   arch supports live patched, high efficiency branches
+# Feature name:          BPF-JIT
+#         Kconfig:       HAVE_BPF_JIT
+#         description:   arch supports BPF JIT optimizations
 #
     -----------------------
     |         arch |status|
