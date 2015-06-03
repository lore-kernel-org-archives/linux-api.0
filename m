From: tip-bot for Ingo Molnar <tipbot-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Subject: [tip:core/documentation] Documentation/features/time:
  Add feature description and arch support status file for '
 modern-timekeeping'
Date: Wed, 3 Jun 2015 04:09:40 -0700
Message-ID: <tip-44121b9ed0384088a6899cfb2ca4ede1428d412f@git.kernel.org>
Reply-To: peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org,
	  linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	  corbet-T1hC0tSOHrs@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	  torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org,
	  tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-tip-commits-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, corbet-T1hC0tSOHrs@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org
List-Id: linux-api@vger.kernel.org

Commit-ID:  44121b9ed0384088a6899cfb2ca4ede1428d412f
Gitweb:     http://git.kernel.org/tip/44121b9ed0384088a6899cfb2ca4ede1428d412f
Author:     Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
AuthorDate: Wed, 3 Jun 2015 12:37:04 +0200
Committer:  Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
CommitDate: Wed, 3 Jun 2015 12:51:34 +0200

Documentation/features/time: Add feature description and arch support status file for 'modern-timekeeping'

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
 .../time/modern-timekeeping/arch-support.txt       | 40 ++++++++++++++++++++++
 1 file changed, 40 insertions(+)

diff --git a/Documentation/features/time/modern-timekeeping/arch-support.txt b/Documentation/features/time/modern-timekeeping/arch-support.txt
new file mode 100644
index 0000000..17f68a0
--- /dev/null
+++ b/Documentation/features/time/modern-timekeeping/arch-support.txt
@@ -0,0 +1,40 @@
+#
+# Feature name:          modern-timekeeping
+#         Kconfig:       !ARCH_USES_GETTIMEOFFSET
+#         description:   arch does not use arch_gettimeoffset() anymore
+#
+    -----------------------
+    |         arch |status|
+    -----------------------
+    |       alpha: |  ok  |
+    |         arc: |  ok  |
+    |         arm: | TODO |
+    |       arm64: |  ok  |
+    |       avr32: |  ok  |
+    |    blackfin: | TODO |
+    |         c6x: |  ok  |
+    |        cris: | TODO |
+    |         frv: |  ok  |
+    |       h8300: |  ok  |
+    |     hexagon: |  ok  |
+    |        ia64: |  ok  |
+    |        m32r: | TODO |
+    |        m68k: | TODO |
+    |       metag: |  ok  |
+    |  microblaze: |  ok  |
+    |        mips: |  ok  |
+    |     mn10300: |  ok  |
+    |       nios2: |  ok  |
+    |    openrisc: |  ok  |
+    |      parisc: |  ok  |
+    |     powerpc: |  ok  |
+    |        s390: |  ok  |
+    |       score: |  ok  |
+    |          sh: |  ok  |
+    |       sparc: |  ok  |
+    |        tile: |  ok  |
+    |          um: |  ok  |
+    |   unicore32: |  ok  |
+    |         x86: |  ok  |
+    |      xtensa: |  ok  |
+    -----------------------
