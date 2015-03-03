From: Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 4/9] kbuild: add a new kselftest_install make target to install selftests
Date: Tue,  3 Mar 2015 15:51:37 +1100
Message-ID: <1425358302-16680-4-git-send-email-mpe@ellerman.id.au>
References: <1425358302-16680-1-git-send-email-mpe@ellerman.id.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1425358302-16680-1-git-send-email-mpe@ellerman.id.au>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: shuahkh@osg.samsung.com, davej@codemonkey.org.uk, mmarek@suse.cz, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Add a new make target to install kernel selftests. This new target will
build and install selftests.

The default is just $(objtree)/selftests. This is preferable to
something based on $(INSTALL_MOD_PATH) (which defaults to /), as it
allows a normal user to install the tests. This is similar to the
default behaviour of make headers_install.

Therefore the most basic usage is:

$ make kselftests_install
$ ./selftests/all.sh

To install elsewhere use:

$ make kselftests_install INSTALL_SELFTESTS_PATH=/some/where
$ /some/where/all.sh

Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
---
 Makefile | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/Makefile b/Makefile
index 9fab639727c7..eb096850718a 100644
--- a/Makefile
+++ b/Makefile
@@ -1081,12 +1081,20 @@ headers_check: headers_install
 	$(Q)$(MAKE) $(hdr-inst)=arch/$(hdr-arch)/include/uapi/asm $(hdr-dst) HDRCHECK=1
 
 # ---------------------------------------------------------------------------
-# Kernel selftest
+# Kernel selftest targets
+
+# Default base path for kselftest install
+INSTALL_SELFTESTS_PATH = $(abspath $(objtree)/selftests)
 
 PHONY += kselftest
 kselftest:
 	$(Q)$(MAKE) -C tools/testing/selftests run_tests
 
+# Kernel selftest install
+PHONY += kselftest_install
+kselftest_install:
+	$(Q)$(MAKE) -C tools/testing/selftests INSTALL_PATH=$(INSTALL_SELFTESTS_PATH) install
+
 # ---------------------------------------------------------------------------
 # Modules
 
@@ -1295,6 +1303,9 @@ help:
 	@echo  '                    Build, install, and boot kernel before'
 	@echo  '                    running kselftest on it'
 	@echo  ''
+	@echo  '  kselftest_install - Install selftests to INSTALL_SELFTESTS_PATH'
+	@echo  '                      default: $(INSTALL_SELFTESTS_PATH)'
+	@echo  ''
 	@echo  'Kernel packaging:'
 	@$(MAKE) $(build)=$(package-dir) help
 	@echo  ''
-- 
2.1.0
