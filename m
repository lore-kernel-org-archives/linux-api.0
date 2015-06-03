From: tip-bot for Ingo Molnar <tipbot-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Subject: [tip:core/documentation] Documentation/features/vm:
  Add feature description and arch support status file for 'THP'
Date: Wed, 3 Jun 2015 04:10:40 -0700
Message-ID: <tip-cc436a080ad45a0d98c5a37a4fd9c896ea6bcd8a@git.kernel.org>
Reply-To: josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	  akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	  hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	  torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, corbet-T1hC0tSOHrs@public.gmane.org,
	  tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-tip-commits-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, corbet-T1hC0tSOHrs@public.gmane.org, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Commit-ID:  cc436a080ad45a0d98c5a37a4fd9c896ea6bcd8a
Gitweb:     http://git.kernel.org/tip/cc436a080ad45a0d98c5a37a4fd9c896ea6bcd8a
Author:     Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
AuthorDate: Wed, 3 Jun 2015 12:37:09 +0200
Committer:  Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
CommitDate: Wed, 3 Jun 2015 12:51:35 +0200

Documentation/features/vm: Add feature description and arch support status file for 'THP'

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
 .../vm/{numa-memblock => THP}/arch-support.txt     | 26 +++++++++++-----------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/Documentation/features/vm/numa-memblock/arch-support.txt b/Documentation/features/vm/THP/arch-support.txt
similarity index 62%
copy from Documentation/features/vm/numa-memblock/arch-support.txt
copy to Documentation/features/vm/THP/arch-support.txt
index e7c252a..972d02c 100644
--- a/Documentation/features/vm/numa-memblock/arch-support.txt
+++ b/Documentation/features/vm/THP/arch-support.txt
@@ -1,15 +1,15 @@
 #
-# Feature name:          numa-memblock
-#         Kconfig:       HAVE_MEMBLOCK_NODE_MAP
-#         description:   arch supports NUMA aware memblocks
+# Feature name:          THP
+#         Kconfig:       HAVE_ARCH_TRANSPARENT_HUGEPAGE
+#         description:   arch supports transparent hugepages
 #
     -----------------------
     |         arch |status|
     -----------------------
     |       alpha: | TODO |
     |         arc: |  ..  |
-    |         arm: |  ..  |
-    |       arm64: |  ..  |
+    |         arm: |  ok  |
+    |       arm64: |  ok  |
     |       avr32: |  ..  |
     |    blackfin: |  ..  |
     |         c6x: |  ..  |
@@ -17,20 +17,20 @@
     |         frv: |  ..  |
     |       h8300: |  ..  |
     |     hexagon: |  ..  |
-    |        ia64: |  ok  |
-    |        m32r: | TODO |
+    |        ia64: | TODO |
+    |        m32r: |  ..  |
     |        m68k: |  ..  |
-    |       metag: |  ok  |
-    |  microblaze: |  ok  |
+    |       metag: |  ..  |
+    |  microblaze: |  ..  |
     |        mips: |  ok  |
-    |     mn10300: | TODO |
+    |     mn10300: |  ..  |
     |       nios2: |  ..  |
     |    openrisc: |  ..  |
-    |      parisc: |  ..  |
+    |      parisc: | TODO |
     |     powerpc: |  ok  |
     |        s390: |  ok  |
-    |       score: |  ok  |
-    |          sh: |  ok  |
+    |       score: |  ..  |
+    |          sh: |  ..  |
     |       sparc: |  ok  |
     |        tile: | TODO |
     |          um: |  ..  |
