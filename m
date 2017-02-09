From: Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 1/5] selftests: Fix selftests build to just build,
 not run tests
Date: Thu,  9 Feb 2017 19:56:26 +1100
Message-ID: <1486630590-9410-1-git-send-email-mpe@ellerman.id.au>
Return-path: <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
List-Unsubscribe: <https://lists.ozlabs.org/options/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=unsubscribe>
List-Archive: <http://lists.ozlabs.org/pipermail/linuxppc-dev/>
List-Post: <mailto:linuxppc-dev@lists.ozlabs.org>
List-Help: <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=help>
List-Subscribe: <https://lists.ozlabs.org/listinfo/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=subscribe>
Errors-To: linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org
Sender: "Linuxppc-dev"
 <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
To: shuahkh@osg.samsung.com, bamvor.zhangjian@huawei.com
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

In commit 88baa78d1f31 ("selftests: remove duplicated all and clean
target"), the "all" target was removed from individual Makefiles and
added to lib.mk.

However the "all" target was added to lib.mk *after* the existing
"runtests" target. This means "runtests" becomes the first (default)
target for most of our Makefiles.

This has the effect of causing a plain "make" to build *and run* the
tests. Which is at best rude, but depending on which tests are run could
oops someone's build machine.

  $ make -C tools/testing/selftests/
  ...
  make[1]: Entering directory 'tools/testing/selftests/bpf'
  gcc -Wall -O2 -I../../../../usr/include   test_verifier.c -o tools/testing/selftests/bpf/test_verifier
  gcc -Wall -O2 -I../../../../usr/include   test_maps.c -o tools/testing/selftests/bpf/test_maps
  gcc -Wall -O2 -I../../../../usr/include   test_lru_map.c -o tools/testing/selftests/bpf/test_lru_map
  #0 add+sub+mul FAIL
  Failed to load prog 'Function not implemented'!
  #1 unreachable FAIL
  Unexpected error message!
  #2 unreachable2 FAIL
  ...

Fix it by moving the "all" target to the start of lib.mk, making it the
default target.

Fixes: 88baa78d1f31 ("selftests: remove duplicated all and clean target")
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
---
 tools/testing/selftests/lib.mk | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/lib.mk b/tools/testing/selftests/lib.mk
index 01bb7782a35e..17ed4bbe3963 100644
--- a/tools/testing/selftests/lib.mk
+++ b/tools/testing/selftests/lib.mk
@@ -2,6 +2,11 @@
 # Makefile can operate with or without the kbuild infrastructure.
 CC := $(CROSS_COMPILE)gcc
 
+TEST_GEN_PROGS := $(patsubst %,$(OUTPUT)/%,$(TEST_GEN_PROGS))
+TEST_GEN_FILES := $(patsubst %,$(OUTPUT)/%,$(TEST_GEN_FILES))
+
+all: $(TEST_GEN_PROGS) $(TEST_GEN_PROGS_EXTENDED) $(TEST_GEN_FILES)
+
 define RUN_TESTS
 	@for TEST in $(TEST_GEN_PROGS) $(TEST_PROGS); do \
 		BASENAME_TEST=`basename $$TEST`;	\
@@ -42,11 +47,6 @@ endef
 emit_tests:
 	$(EMIT_TESTS)
 
-TEST_GEN_PROGS := $(patsubst %,$(OUTPUT)/%,$(TEST_GEN_PROGS))
-TEST_GEN_FILES := $(patsubst %,$(OUTPUT)/%,$(TEST_GEN_FILES))
-
-all: $(TEST_GEN_PROGS) $(TEST_GEN_PROGS_EXTENDED) $(TEST_GEN_FILES)
-
 clean:
 	$(RM) -r $(TEST_GEN_PROGS) $(TEST_GEN_PROGS_EXTENDED) $(TEST_GEN_FILES) $(EXTRA_CLEAN)
 
-- 
2.7.4
