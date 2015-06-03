From: tip-bot for Ingo Molnar <tipbot-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Subject: [tip:core/documentation] Documentation/features/vm:
  Add feature description and arch support status file for 'huge-vmap'
Date: Wed, 3 Jun 2015 04:08:21 -0700
Message-ID: <tip-bebcfbb0ceb5228f5931f6869a72b6e92ea10592@git.kernel.org>
Reply-To: tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org,
	  linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org,
	  corbet-T1hC0tSOHrs@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	  linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org,
	  torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-tip-commits-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, corbet-T1hC0tSOHrs@public.gmane.org, josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org
List-Id: linux-api@vger.kernel.org

Commit-ID:  bebcfbb0ceb5228f5931f6869a72b6e92ea10592
Gitweb:     http://git.kernel.org/tip/bebcfbb0ceb5228f5931f6869a72b6e92ea10592
Author:     Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
AuthorDate: Wed, 3 Jun 2015 12:37:00 +0200
Committer:  Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
CommitDate: Wed, 3 Jun 2015 12:51:33 +0200

Documentation/features/vm: Add feature description and arch support status file for 'huge-vmap'

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
 .../features/{lib/strncasecmp => vm/huge-vmap}/arch-support.txt   | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/Documentation/features/lib/strncasecmp/arch-support.txt b/Documentation/features/vm/huge-vmap/arch-support.txt
similarity index 82%
copy from Documentation/features/lib/strncasecmp/arch-support.txt
copy to Documentation/features/vm/huge-vmap/arch-support.txt
index 12b1c93..af6816b 100644
--- a/Documentation/features/lib/strncasecmp/arch-support.txt
+++ b/Documentation/features/vm/huge-vmap/arch-support.txt
@@ -1,7 +1,7 @@
 #
-# Feature name:          strncasecmp
-#         Kconfig:       __HAVE_ARCH_STRNCASECMP
-#         description:   arch provides an optimized strncasecmp() function
+# Feature name:          huge-vmap
+#         Kconfig:       HAVE_ARCH_HUGE_VMAP
+#         description:   arch supports the ioremap_pud_enabled() and ioremap_pmd_enabled() VM APIs
 #
     -----------------------
     |         arch |status|
@@ -35,6 +35,6 @@
     |        tile: | TODO |
     |          um: | TODO |
     |   unicore32: | TODO |
-    |         x86: | TODO |
+    |         x86: |  ok  |
     |      xtensa: | TODO |
     -----------------------
