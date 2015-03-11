From: Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>
Subject: [PATCH v4 1/9] kbuild: Don't pass -rR to selftest makefiles
Date: Wed, 11 Mar 2015 15:05:57 +1100
Message-ID: <1426046765-19289-1-git-send-email-mpe@ellerman.id.au>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, davej-rdkfGonbjUTCLXcRTR1eJlpr/1R2p/CL@public.gmane.org, mmarek-AlSwsSmVLrQ@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

The makefiles under tools/testing/selftests are not real kbuild
makefiles, they are regular stand alone makefiles. As such they *do*
want all the standard implicit rules and variables defined.

So before calling those makefiles, filter -rR out of MAKEFLAGS.

Without this not all the selftests are built correctly when called via
the top-level Makefile.

Signed-off-by: Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>
---
 Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Makefile b/Makefile
index 1100ff3c77e3..0836e9d628f0 100644
--- a/Makefile
+++ b/Makefile
@@ -1085,7 +1085,7 @@ headers_check: headers_install
 
 PHONY += kselftest
 kselftest:
-	$(Q)$(MAKE) -C tools/testing/selftests run_tests
+	$(Q)$(MAKE) -C tools/testing/selftests MAKEFLAGS="$(filter-out rR,$(MAKEFLAGS))" run_tests
 
 # ---------------------------------------------------------------------------
 # Modules
-- 
2.1.0
