From: Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH] kbuild: Don't pass -rR to selftest makefiles
Date: Wed,  4 Mar 2015 21:19:22 +1100
Message-ID: <1425464362-28876-1-git-send-email-mpe@ellerman.id.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: shuahkh@osg.samsung.com
Cc: linux-kernel@vger.kernel.org, davej@codemonkey.org.uk, mmarek@suse.cz, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

The makefiles under tools/testing/selftests are not real kbuild
makefiles, they are regular stand alone makefiles. As such they *do*
want all the standard implicit rules and variables defined.

So before calling those makefiles, filter -rR out of MAKEFLAGS.

Without this not all the selftests are built correctly when called via
the top-level Makefile.

Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
---
 Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Makefile b/Makefile
index e6a9b1b94656..da72798644fd 100644
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
