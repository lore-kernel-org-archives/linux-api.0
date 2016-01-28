From: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Subject: [PATCH] tools: Add a selftests_run target
Date: Thu, 28 Jan 2016 09:20:15 +0100
Message-ID: <1453969215-26532-1-git-send-email-bp@alien8.de>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

From: Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>

With it, you can do

$ make tools/selftests_run

from the toplevel kernel repo and it'll run all selftests. Don't forget
the -j.

Signed-off-by: Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>
---
 tools/Makefile | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/Makefile b/tools/Makefile
index 6339f6ac3ccb..1e64385ff97a 100644
--- a/tools/Makefile
+++ b/tools/Makefile
@@ -73,6 +73,9 @@ perf: FORCE
 selftests: FORCE
 	$(call descend,testing/$@)
 
+selftests_run:
+	$(call descend,testing/selftests run_tests)
+
 turbostat x86_energy_perf_policy: FORCE
 	$(call descend,power/x86/$@)
 
-- 
2.3.5
