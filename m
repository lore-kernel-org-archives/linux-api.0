From: tip-bot for Ingo Molnar <tipbot-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Subject: [tip:core/documentation] Documentation/features/core:
  Add feature description and arch support status file for '
 generic-idle-thread'
Date: Wed, 3 Jun 2015 04:17:45 -0700
Message-ID: <tip-8fa369c0485c843f93045974e2a93cdc09828db1@git.kernel.org>
Reply-To: torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org,
	  corbet-T1hC0tSOHrs@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org,
	  tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	  linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org,
	  akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-tip-commits-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, corbet-T1hC0tSOHrs@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Commit-ID:  8fa369c0485c843f93045974e2a93cdc09828db1
Gitweb:     http://git.kernel.org/tip/8fa369c0485c843f93045974e2a93cdc09828db1
Author:     Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
AuthorDate: Wed, 3 Jun 2015 12:37:34 +0200
Committer:  Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
CommitDate: Wed, 3 Jun 2015 12:51:41 +0200

Documentation/features/core: Add feature description and arch support status file for 'generic-idle-thread'

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
 .../generic-idle-thread}/arch-support.txt            | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/Documentation/features/time/virt-cpuacct/arch-support.txt b/Documentation/features/core/generic-idle-thread/arch-support.txt
similarity index 68%
copy from Documentation/features/time/virt-cpuacct/arch-support.txt
copy to Documentation/features/core/generic-idle-thread/arch-support.txt
index cf3c3e3..6d930fc 100644
--- a/Documentation/features/time/virt-cpuacct/arch-support.txt
+++ b/Documentation/features/core/generic-idle-thread/arch-support.txt
@@ -1,26 +1,26 @@
 #
-# Feature name:          virt-cpuacct
-#         Kconfig:       HAVE_VIRT_CPU_ACCOUNTING
-#         description:   arch supports precise virtual CPU time accounting
+# Feature name:          generic-idle-thread
+#         Kconfig:       GENERIC_SMP_IDLE_THREAD
+#         description:   arch makes use of the generic SMP idle thread facility
 #
     -----------------------
     |         arch |status|
     -----------------------
     |       alpha: |  ok  |
-    |         arc: | TODO |
+    |         arc: |  ok  |
     |         arm: |  ok  |
     |       arm64: |  ok  |
     |       avr32: | TODO |
-    |    blackfin: | TODO |
+    |    blackfin: |  ok  |
     |         c6x: | TODO |
     |        cris: | TODO |
     |         frv: | TODO |
     |       h8300: | TODO |
-    |     hexagon: | TODO |
+    |     hexagon: |  ok  |
     |        ia64: |  ok  |
     |        m32r: | TODO |
     |        m68k: | TODO |
-    |       metag: | TODO |
+    |       metag: |  ok  |
     |  microblaze: | TODO |
     |        mips: |  ok  |
     |     mn10300: | TODO |
@@ -30,11 +30,11 @@
     |     powerpc: |  ok  |
     |        s390: |  ok  |
     |       score: | TODO |
-    |          sh: | TODO |
+    |          sh: |  ok  |
     |       sparc: |  ok  |
-    |        tile: |  ok  |
+    |        tile: | TODO |
     |          um: | TODO |
     |   unicore32: | TODO |
     |         x86: |  ok  |
-    |      xtensa: | TODO |
+    |      xtensa: |  ok  |
     -----------------------
