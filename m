From: <bamvor.zhangjian-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 5/6] selftests: add EXTRA_CLEAN for clean target
Date: Tue, 29 Nov 2016 19:55:51 +0800
Message-ID: <20161129115552.8148-6-bamvor.zhangjian@huawei.com>
References: <20161129115552.8148-1-bamvor.zhangjian@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161129115552.8148-1-bamvor.zhangjian-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, khilman-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org
List-Id: linux-api@vger.kernel.org

From: Bamvor Jian Zhang <bamvor.zhangjian-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>

Some testcases need the clean extra data after running. This patch
introduce the "EXTRA_CLEAN" variable to address this requirement.

After KBUILD_OUTPUT is enabled in later patch, it will be easy to
decide to if we need do the cleanup in the KBUILD_OUTPUT path(if the
testcase ran immediately after compiled).

Signed-off-by: Bamvor Jian Zhang <bamvor.zhangjian-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 tools/testing/selftests/exec/Makefile                 | 19 +++++++++----------
 tools/testing/selftests/ftrace/Makefile               |  4 +---
 tools/testing/selftests/kcmp/Makefile                 |  4 ++--
 tools/testing/selftests/lib.mk                        |  2 +-
 .../testing/selftests/powerpc/switch_endian/Makefile  |  5 ++---
 tools/testing/selftests/pstore/Makefile               |  4 +---
 tools/testing/selftests/zram/Makefile                 |  3 +--
 7 files changed, 17 insertions(+), 24 deletions(-)

diff --git a/tools/testing/selftests/exec/Makefile b/tools/testing/selftests/exec/Makefile
index 9eb1c3e..48d1f86 100644
--- a/tools/testing/selftests/exec/Makefile
+++ b/tools/testing/selftests/exec/Makefile
@@ -1,5 +1,14 @@
 CFLAGS = -Wall
 
+TEST_GEN_PROGS := execveat
+TEST_GEN_FILES := execveat.symlink execveat.denatured script subdir
+# Makefile is a run-time dependency, since it's accessed by the execveat test
+TEST_FILES := Makefile
+
+EXTRA_CLEAN := subdir.moved execveat.moved xxxxx*
+
+include ../lib.mk
+
 subdir:
 	mkdir -p $@
 script:
@@ -11,13 +20,3 @@ execveat.symlink: execveat
 execveat.denatured: execveat
 	cp $< $@
 	chmod -x $@
-
-TEST_GEN_PROGS := execveat
-TEST_GEN_FILES := execveat.symlink execveat.denatured script subdir
-# Makefile is a run-time dependency, since it's accessed by the execveat test
-TEST_FILES := Makefile
-
-include ../lib.mk
-
-clean:
-	rm -rf $(TEST_GEN_PROGS) $(TEST_GEN_FILES) subdir.moved execveat.moved xxxxx*
diff --git a/tools/testing/selftests/ftrace/Makefile b/tools/testing/selftests/ftrace/Makefile
index a715300..6c64b42 100644
--- a/tools/testing/selftests/ftrace/Makefile
+++ b/tools/testing/selftests/ftrace/Makefile
@@ -2,8 +2,6 @@ all:
 
 TEST_PROGS := ftracetest
 TEST_FILES := test.d
+EXTRA_CLEAN := logs/*
 
 include ../lib.mk
-
-clean:
-	rm -rf logs/*
diff --git a/tools/testing/selftests/kcmp/Makefile b/tools/testing/selftests/kcmp/Makefile
index 9e8b673..74a8add 100644
--- a/tools/testing/selftests/kcmp/Makefile
+++ b/tools/testing/selftests/kcmp/Makefile
@@ -2,7 +2,7 @@ CFLAGS += -I../../../../usr/include/
 
 TEST_GEN_PROGS := kcmp_test
 
+EXTRA_CLEAN := kcmp-test-file
+
 include ../lib.mk
 
-clean:
-	$(RM) $(TEST_GEN_PROGS) kcmp-test-file
diff --git a/tools/testing/selftests/lib.mk b/tools/testing/selftests/lib.mk
index 68d7c01..0f7a371 100644
--- a/tools/testing/selftests/lib.mk
+++ b/tools/testing/selftests/lib.mk
@@ -43,7 +43,7 @@ emit_tests:
 all: $(TEST_GEN_PROGS) $(TEST_GEN_PROGS_EXTENDED) $(TEST_GEN_FILES)
 
 clean:
-	$(RM) -r $(TEST_GEN_PROGS) $(TEST_GEN_PROGS_EXTENDED) $(TEST_GEN_FILES)
+	$(RM) -r $(TEST_GEN_PROGS) $(TEST_GEN_PROGS_EXTENDED) $(TEST_GEN_FILES) $(EXTRA_CLEAN)
 
 %: %.c
 	$(CC) $(CFLAGS) $(LDFLAGS) $(LDLIBS) -o $@ $^
diff --git a/tools/testing/selftests/powerpc/switch_endian/Makefile b/tools/testing/selftests/powerpc/switch_endian/Makefile
index bd01223..dbd05ac 100644
--- a/tools/testing/selftests/powerpc/switch_endian/Makefile
+++ b/tools/testing/selftests/powerpc/switch_endian/Makefile
@@ -2,6 +2,8 @@ TEST_GEN_PROGS := switch_endian_test
 
 ASFLAGS += -O2 -Wall -g -nostdlib -m64
 
+EXTRA_CLEAN = *.o check-reversed.S
+
 include ../../lib.mk
 
 switch_endian_test: check-reversed.S
@@ -11,6 +13,3 @@ check-reversed.o: check.o
 
 check-reversed.S: check-reversed.o
 	hexdump -v -e '/1 ".byte 0x%02X\n"' $< > $@
-
-clean:
-	$(RM) $(TEST_GEN_PROGS) *.o check-reversed.S
diff --git a/tools/testing/selftests/pstore/Makefile b/tools/testing/selftests/pstore/Makefile
index bd7abe2..c5f2440 100644
--- a/tools/testing/selftests/pstore/Makefile
+++ b/tools/testing/selftests/pstore/Makefile
@@ -5,11 +5,9 @@ all:
 
 TEST_PROGS := pstore_tests pstore_post_reboot_tests
 TEST_FILES := common_tests pstore_crash_test
+EXTRA_CLEAN := logs/* *uuid
 
 include ../lib.mk
 
 run_crash:
 	@sh pstore_crash_test || { echo "pstore_crash_test: [FAIL]"; exit 1; }
-
-clean:
-	rm -rf logs/* *uuid
diff --git a/tools/testing/selftests/zram/Makefile b/tools/testing/selftests/zram/Makefile
index 29d8034..c3a87e5 100644
--- a/tools/testing/selftests/zram/Makefile
+++ b/tools/testing/selftests/zram/Makefile
@@ -2,8 +2,7 @@ all:
 
 TEST_PROGS := zram.sh
 TEST_FILES := zram01.sh zram02.sh zram_lib.sh
+EXTRA_CLEAN := err.log
 
 include ../lib.mk
 
-clean:
-	$(RM) err.log
-- 
2.10.0
