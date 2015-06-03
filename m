From: tip-bot for Ingo Molnar <tipbot-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Subject: [tip:core/documentation] Documentation/features/time:
  Add feature description and arch support status file for 'irq-time-acct'
Date: Wed, 3 Jun 2015 04:10:18 -0700
Message-ID: <tip-1aebadbca627c8840adcf78e68a9ab81c6490307@git.kernel.org>
Reply-To: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	  linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, corbet-T1hC0tSOHrs@public.gmane.org,
	  linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org,
	  torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org,
	  peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-tip-commits-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, corbet-T1hC0tSOHrs@public.gmane.org, linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Commit-ID:  1aebadbca627c8840adcf78e68a9ab81c6490307
Gitweb:     http://git.kernel.org/tip/1aebadbca627c8840adcf78e68a9ab81c6490307
Author:     Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
AuthorDate: Wed, 3 Jun 2015 12:37:07 +0200
Committer:  Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
CommitDate: Wed, 3 Jun 2015 12:51:35 +0200

Documentation/features/time: Add feature description and arch support status file for 'irq-time-acct'

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
 .../arch-support.txt                               | 24 +++++++++++-----------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/Documentation/features/time/virt-cpuacct/arch-support.txt b/Documentation/features/time/irq-time-acct/arch-support.txt
similarity index 63%
copy from Documentation/features/time/virt-cpuacct/arch-support.txt
copy to Documentation/features/time/irq-time-acct/arch-support.txt
index cf3c3e3..e633162 100644
--- a/Documentation/features/time/virt-cpuacct/arch-support.txt
+++ b/Documentation/features/time/irq-time-acct/arch-support.txt
@@ -1,15 +1,15 @@
 #
-# Feature name:          virt-cpuacct
-#         Kconfig:       HAVE_VIRT_CPU_ACCOUNTING
-#         description:   arch supports precise virtual CPU time accounting
+# Feature name:          irq-time-acct
+#         Kconfig:       HAVE_IRQ_TIME_ACCOUNTING
+#         description:   arch supports precise IRQ time accounting
 #
     -----------------------
     |         arch |status|
     -----------------------
-    |       alpha: |  ok  |
+    |       alpha: |  ..  |
     |         arc: | TODO |
     |         arm: |  ok  |
-    |       arm64: |  ok  |
+    |       arm64: |  ..  |
     |       avr32: | TODO |
     |    blackfin: | TODO |
     |         c6x: | TODO |
@@ -17,7 +17,7 @@
     |         frv: | TODO |
     |       h8300: | TODO |
     |     hexagon: | TODO |
-    |        ia64: |  ok  |
+    |        ia64: |  ..  |
     |        m32r: | TODO |
     |        m68k: | TODO |
     |       metag: | TODO |
@@ -26,15 +26,15 @@
     |     mn10300: | TODO |
     |       nios2: | TODO |
     |    openrisc: | TODO |
-    |      parisc: |  ok  |
-    |     powerpc: |  ok  |
-    |        s390: |  ok  |
+    |      parisc: |  ..  |
+    |     powerpc: |  ..  |
+    |        s390: |  ..  |
     |       score: | TODO |
     |          sh: | TODO |
-    |       sparc: |  ok  |
-    |        tile: |  ok  |
+    |       sparc: |  ..  |
+    |        tile: |  ..  |
     |          um: | TODO |
     |   unicore32: | TODO |
     |         x86: |  ok  |
-    |      xtensa: | TODO |
+    |      xtensa: |  ok  |
     -----------------------
