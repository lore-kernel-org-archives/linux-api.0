From: tip-bot for Ingo Molnar <tipbot-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Subject: [tip:core/documentation] Documentation/features/vm:
  Add feature description and arch support status file for 'numa-memblock'
Date: Wed, 3 Jun 2015 04:07:03 -0700
Message-ID: <tip-403e27dc1f90ce9ac4833c6d56cb08023b74e804@git.kernel.org>
Reply-To: tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	  linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org,
	  akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, corbet-T1hC0tSOHrs@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org,
	  linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-tip-commits-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, corbet-T1hC0tSOHrs@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org, linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Commit-ID:  403e27dc1f90ce9ac4833c6d56cb08023b74e804
Gitweb:     http://git.kernel.org/tip/403e27dc1f90ce9ac4833c6d56cb08023b74e804
Author:     Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
AuthorDate: Wed, 3 Jun 2015 12:36:55 +0200
Committer:  Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
CommitDate: Wed, 3 Jun 2015 12:51:32 +0200

Documentation/features/vm: Add feature description and arch support status file for 'numa-memblock'

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
 .../features/vm/numa-memblock/arch-support.txt     | 40 ++++++++++++++++++++++
 1 file changed, 40 insertions(+)

diff --git a/Documentation/features/vm/numa-memblock/arch-support.txt b/Documentation/features/vm/numa-memblock/arch-support.txt
new file mode 100644
index 0000000..e7c252a
--- /dev/null
+++ b/Documentation/features/vm/numa-memblock/arch-support.txt
@@ -0,0 +1,40 @@
+#
+# Feature name:          numa-memblock
+#         Kconfig:       HAVE_MEMBLOCK_NODE_MAP
+#         description:   arch supports NUMA aware memblocks
+#
+    -----------------------
+    |         arch |status|
+    -----------------------
+    |       alpha: | TODO |
+    |         arc: |  ..  |
+    |         arm: |  ..  |
+    |       arm64: |  ..  |
+    |       avr32: |  ..  |
+    |    blackfin: |  ..  |
+    |         c6x: |  ..  |
+    |        cris: |  ..  |
+    |         frv: |  ..  |
+    |       h8300: |  ..  |
+    |     hexagon: |  ..  |
+    |        ia64: |  ok  |
+    |        m32r: | TODO |
+    |        m68k: |  ..  |
+    |       metag: |  ok  |
+    |  microblaze: |  ok  |
+    |        mips: |  ok  |
+    |     mn10300: | TODO |
+    |       nios2: |  ..  |
+    |    openrisc: |  ..  |
+    |      parisc: |  ..  |
+    |     powerpc: |  ok  |
+    |        s390: |  ok  |
+    |       score: |  ok  |
+    |          sh: |  ok  |
+    |       sparc: |  ok  |
+    |        tile: | TODO |
+    |          um: |  ..  |
+    |   unicore32: |  ..  |
+    |         x86: |  ok  |
+    |      xtensa: |  ..  |
+    -----------------------
