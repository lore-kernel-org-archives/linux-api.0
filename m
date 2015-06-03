From: tip-bot for Ingo Molnar <tipbot-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Subject: [tip:core/documentation] Documentation/features/vm:
  Add feature description and arch support status file for '
 pmdp_splitting_flush'
Date: Wed, 3 Jun 2015 04:09:03 -0700
Message-ID: <tip-61e06e71ccbba66c652ab741d43a9c9d0fd6a5a9@git.kernel.org>
Reply-To: linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org,
	  torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	  hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	  mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, corbet-T1hC0tSOHrs@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org,
	  akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-tip-commits-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, corbet-T1hC0tSOHrs@public.gmane.org, mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Commit-ID:  61e06e71ccbba66c652ab741d43a9c9d0fd6a5a9
Gitweb:     http://git.kernel.org/tip/61e06e71ccbba66c652ab741d43a9c9d0fd6a5a9
Author:     Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
AuthorDate: Wed, 3 Jun 2015 12:37:02 +0200
Committer:  Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
CommitDate: Wed, 3 Jun 2015 12:51:34 +0200

Documentation/features/vm: Add feature description and arch support status file for 'pmdp_splitting_flush'

Cc: <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: <linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: H. Peter Anvin <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>
Cc: Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>
Cc: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Signed-off-by: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 .../sg-chain => vm/pmdp_splitting_flush}/arch-support.txt    | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/Documentation/features/io/sg-chain/arch-support.txt b/Documentation/features/vm/pmdp_splitting_flush/arch-support.txt
similarity index 77%
copy from Documentation/features/io/sg-chain/arch-support.txt
copy to Documentation/features/vm/pmdp_splitting_flush/arch-support.txt
index b9b6755..26f74b4 100644
--- a/Documentation/features/io/sg-chain/arch-support.txt
+++ b/Documentation/features/vm/pmdp_splitting_flush/arch-support.txt
@@ -1,7 +1,7 @@
 #
-# Feature name:          sg-chain
-#         Kconfig:       ARCH_HAS_SG_CHAIN
-#         description:   arch supports chained scatter-gather lists
+# Feature name:          pmdp_splitting_flush
+#         Kconfig:       __HAVE_ARCH_PMDP_SPLITTING_FLUSH
+#         description:   arch supports the pmdp_splitting_flush() VM API
 #
     -----------------------
     |         arch |status|
@@ -17,12 +17,12 @@
     |         frv: | TODO |
     |       h8300: | TODO |
     |     hexagon: | TODO |
-    |        ia64: |  ok  |
+    |        ia64: | TODO |
     |        m32r: | TODO |
     |        m68k: | TODO |
     |       metag: | TODO |
     |  microblaze: | TODO |
-    |        mips: | TODO |
+    |        mips: |  ok  |
     |     mn10300: | TODO |
     |       nios2: | TODO |
     |    openrisc: | TODO |
@@ -31,7 +31,7 @@
     |        s390: |  ok  |
     |       score: | TODO |
     |          sh: | TODO |
-    |       sparc: |  ok  |
+    |       sparc: | TODO |
     |        tile: | TODO |
     |          um: | TODO |
     |   unicore32: | TODO |
