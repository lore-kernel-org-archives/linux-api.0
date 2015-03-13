From: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Subject: [PATCH 1/2] selftests: add ability to run and emit script for tests args to lib.mk
Date: Fri, 13 Mar 2015 16:57:50 -0600
Message-ID: <7558cf9797060b4c67633c529113a70e0ac09aca.1426286799.git.shuahkh@osg.samsung.com>
References: <cover.1426286799.git.shuahkh@osg.samsung.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1426286799.git.shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
In-Reply-To: <cover.1426286799.git.shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
References: <cover.1426286799.git.shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org
Cc: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Add ability to run, emit, install tests take arguments to the
shared logic in lib.mk. lib.mk provides a way to override the
default RUN_TESTS and EMIT_TESTS, however in the cases where a
test has several executables that don't require any special args
and/or handling and some that do, overrding will be cumbersome.
Add variables RUN_TESTS_WITH_ARGS, and EMIT_TESTS_WITH_ARGS to
enable a test to run and exmit script for such special executables.

Signed-off-by: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
---
 tools/testing/selftests/lib.mk | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/tools/testing/selftests/lib.mk b/tools/testing/selftests/lib.mk
index 7bd3dab..78cdf91 100644
--- a/tools/testing/selftests/lib.mk
+++ b/tools/testing/selftests/lib.mk
@@ -6,6 +6,9 @@ endef
 
 run_tests: all
 	$(RUN_TESTS)
+ifdef RUN_TESTS_WITH_ARGS
+	$(RUN_TESTS_WITH_ARGS)
+endif
 
 define INSTALL_RULE
 	mkdir -p $(INSTALL_PATH)
@@ -27,5 +30,8 @@ endef
 
 emit_tests:
 	$(EMIT_TESTS)
+ifdef EMIT_TESTS_WITH_ARGS
+	$(EMIT_TESTS_WITH_ARGS)
+endif
 
 .PHONY: run_tests all clean install emit_tests
-- 
2.1.0
