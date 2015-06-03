From: tip-bot for Ingo Molnar <tipbot-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Subject: [tip:core/documentation] Documentation/features/io:
  Add feature description and arch support status file for 'dma_map_attrs'
Date: Wed, 3 Jun 2015 04:11:55 -0700
Message-ID: <tip-3c1b5142691f094591b6c1d6e7a9fc5599409c28@git.kernel.org>
Reply-To: hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, corbet-T1hC0tSOHrs@public.gmane.org,
	  tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org,
	  josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	  torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org,
	  linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-tip-commits-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, corbet-T1hC0tSOHrs@public.gmane.org, linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org
List-Id: linux-api@vger.kernel.org

Commit-ID:  3c1b5142691f094591b6c1d6e7a9fc5599409c28
Gitweb:     http://git.kernel.org/tip/3c1b5142691f094591b6c1d6e7a9fc5599409c28
Author:     Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
AuthorDate: Wed, 3 Jun 2015 12:37:14 +0200
Committer:  Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
CommitDate: Wed, 3 Jun 2015 12:51:36 +0200

Documentation/features/io: Add feature description and arch support status file for 'dma_map_attrs'

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
 .../dma_map_attrs}/arch-support.txt                  | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/Documentation/features/time/virt-cpuacct/arch-support.txt b/Documentation/features/io/dma_map_attrs/arch-support.txt
similarity index 68%
copy from Documentation/features/time/virt-cpuacct/arch-support.txt
copy to Documentation/features/io/dma_map_attrs/arch-support.txt
index cf3c3e3..51d0f1c 100644
--- a/Documentation/features/time/virt-cpuacct/arch-support.txt
+++ b/Documentation/features/io/dma_map_attrs/arch-support.txt
@@ -1,7 +1,7 @@
 #
-# Feature name:          virt-cpuacct
-#         Kconfig:       HAVE_VIRT_CPU_ACCOUNTING
-#         description:   arch supports precise virtual CPU time accounting
+# Feature name:          dma_map_attrs
+#         Kconfig:       HAVE_DMA_ATTRS
+#         description:   arch provides dma_*map*_attrs() APIs
 #
     -----------------------
     |         arch |status|
@@ -15,26 +15,26 @@
     |         c6x: | TODO |
     |        cris: | TODO |
     |         frv: | TODO |
-    |       h8300: | TODO |
-    |     hexagon: | TODO |
+    |       h8300: |  ok  |
+    |     hexagon: |  ok  |
     |        ia64: |  ok  |
     |        m32r: | TODO |
     |        m68k: | TODO |
     |       metag: | TODO |
-    |  microblaze: | TODO |
+    |  microblaze: |  ok  |
     |        mips: |  ok  |
     |     mn10300: | TODO |
     |       nios2: | TODO |
-    |    openrisc: | TODO |
-    |      parisc: |  ok  |
+    |    openrisc: |  ok  |
+    |      parisc: | TODO |
     |     powerpc: |  ok  |
     |        s390: |  ok  |
     |       score: | TODO |
-    |          sh: | TODO |
+    |          sh: |  ok  |
     |       sparc: |  ok  |
     |        tile: |  ok  |
     |          um: | TODO |
-    |   unicore32: | TODO |
+    |   unicore32: |  ok  |
     |         x86: |  ok  |
     |      xtensa: | TODO |
     -----------------------
