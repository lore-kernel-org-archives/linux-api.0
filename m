From: tip-bot for Ingo Molnar <tipbot-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Subject: [tip:core/documentation] Documentation/features/time:
  Add feature description and arch support status file for 'clockevents'
Date: Wed, 3 Jun 2015 04:14:48 -0700
Message-ID: <tip-28dfffd6d14f9cb2277e9bead011e8d510e2c4fa@git.kernel.org>
Reply-To: josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	  akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org,
	  corbet-T1hC0tSOHrs@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org,
	  tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	  linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-tip-commits-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, corbet-T1hC0tSOHrs@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Commit-ID:  28dfffd6d14f9cb2277e9bead011e8d510e2c4fa
Gitweb:     http://git.kernel.org/tip/28dfffd6d14f9cb2277e9bead011e8d510e2c4fa
Author:     Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
AuthorDate: Wed, 3 Jun 2015 12:37:24 +0200
Committer:  Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
CommitDate: Wed, 3 Jun 2015 12:51:39 +0200

Documentation/features/time: Add feature description and arch support status file for 'clockevents'

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
 .../arch-support.txt                                 | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/Documentation/features/time/modern-timekeeping/arch-support.txt b/Documentation/features/time/clockevents/arch-support.txt
similarity index 68%
copy from Documentation/features/time/modern-timekeeping/arch-support.txt
copy to Documentation/features/time/clockevents/arch-support.txt
index 17f68a0..ff670b2 100644
--- a/Documentation/features/time/modern-timekeeping/arch-support.txt
+++ b/Documentation/features/time/clockevents/arch-support.txt
@@ -1,32 +1,32 @@
 #
-# Feature name:          modern-timekeeping
-#         Kconfig:       !ARCH_USES_GETTIMEOFFSET
-#         description:   arch does not use arch_gettimeoffset() anymore
+# Feature name:          clockevents
+#         Kconfig:       GENERIC_CLOCKEVENTS
+#         description:   arch support generic clock events
 #
     -----------------------
     |         arch |status|
     -----------------------
     |       alpha: |  ok  |
     |         arc: |  ok  |
-    |         arm: | TODO |
+    |         arm: |  ok  |
     |       arm64: |  ok  |
     |       avr32: |  ok  |
-    |    blackfin: | TODO |
+    |    blackfin: |  ok  |
     |         c6x: |  ok  |
-    |        cris: | TODO |
-    |         frv: |  ok  |
+    |        cris: |  ok  |
+    |         frv: | TODO |
     |       h8300: |  ok  |
     |     hexagon: |  ok  |
-    |        ia64: |  ok  |
+    |        ia64: | TODO |
     |        m32r: | TODO |
-    |        m68k: | TODO |
+    |        m68k: |  ok  |
     |       metag: |  ok  |
     |  microblaze: |  ok  |
     |        mips: |  ok  |
     |     mn10300: |  ok  |
     |       nios2: |  ok  |
     |    openrisc: |  ok  |
-    |      parisc: |  ok  |
+    |      parisc: | TODO |
     |     powerpc: |  ok  |
     |        s390: |  ok  |
     |       score: |  ok  |
