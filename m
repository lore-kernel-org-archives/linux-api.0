From: Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5/9] kbuild: Don't pass -rR to selftest makefiles
Date: Tue,  3 Mar 2015 15:51:38 +1100
Message-ID: <1425358302-16680-5-git-send-email-mpe@ellerman.id.au>
References: <1425358302-16680-1-git-send-email-mpe@ellerman.id.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1425358302-16680-1-git-send-email-mpe@ellerman.id.au>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: shuahkh@osg.samsung.com, davej@codemonkey.org.uk, mmarek@suse.cz, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

The makefiles under tools/testing/selftests are not real kbuild
makefiles, they are regular stand alone makefiles. As such they *do*
want all the standard implicit rules and variables defined.

So before calling those makefiles, filter -rR out of MAKEFLAGS.

Without this not all the selftests are built correctly when called via
the top-level Makefile.

Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
---
 Makefile | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Makefile b/Makefile
index eb096850718a..df058106b9ea 100644
--- a/Makefile
+++ b/Makefile
@@ -1088,12 +1088,12 @@ INSTALL_SELFTESTS_PATH = $(abspath $(objtree)/selftests)
 
 PHONY += kselftest
 kselftest:
-	$(Q)$(MAKE) -C tools/testing/selftests run_tests
+	$(Q)$(MAKE) -C tools/testing/selftests MAKEFLAGS="$(filter-out rR,$(MAKEFLAGS))" run_tests
 
 # Kernel selftest install
 PHONY += kselftest_install
 kselftest_install:
-	$(Q)$(MAKE) -C tools/testing/selftests INSTALL_PATH=$(INSTALL_SELFTESTS_PATH) install
+	$(Q)$(MAKE) -C tools/testing/selftests MAKEFLAGS="$(filter-out rR,$(MAKEFLAGS))" INSTALL_PATH=$(INSTALL_SELFTESTS_PATH) install
 
 # ---------------------------------------------------------------------------
 # Modules
-- 
2.1.0
