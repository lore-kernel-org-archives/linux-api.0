From: <bamvor.zhangjian-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH RFC 3/6] selftests: add default rules for c source file
Date: Fri, 21 Oct 2016 19:01:31 +0800
Message-ID: <1477047694-24122-4-git-send-email-bamvor.zhangjian@huawei.com>
References: <1477047694-24122-1-git-send-email-bamvor.zhangjian@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1477047694-24122-1-git-send-email-bamvor.zhangjian-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, khilman-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org
List-Id: linux-api@vger.kernel.org

From: Bamvor Jian Zhang <bamvor.zhangjian-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>

There are difference rules for compiling c source file in different
testcases. In order to enable KBUILD_OUTPUT support in later patch,
this patch introduce the default rules in
"tools/testing/selftest/lib.mk" and remove the existing rules in each
testcase.

Signed-off-by: Bamvor Jian Zhang <bamvor.zhangjian-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 tools/testing/selftests/exec/Makefile  | 2 --
 tools/testing/selftests/lib.mk         | 3 +++
 tools/testing/selftests/mount/Makefile | 3 ---
 tools/testing/selftests/net/Makefile   | 2 --
 tools/testing/selftests/size/Makefile  | 4 +---
 tools/testing/selftests/vm/Makefile    | 3 +--
 6 files changed, 5 insertions(+), 12 deletions(-)

diff --git a/tools/testing/selftests/exec/Makefile b/tools/testing/selftests/exec/Makefile
index b3bf091..9eb1c3e 100644
--- a/tools/testing/selftests/exec/Makefile
+++ b/tools/testing/selftests/exec/Makefile
@@ -11,8 +11,6 @@ execveat.symlink: execveat
 execveat.denatured: execveat
 	cp $< $@
 	chmod -x $@
-%: %.c
-	$(CC) $(CFLAGS) -o $@ $^
 
 TEST_GEN_PROGS := execveat
 TEST_GEN_FILES := execveat.symlink execveat.denatured script subdir
diff --git a/tools/testing/selftests/lib.mk b/tools/testing/selftests/lib.mk
index 8c0440d..9ccec4b 100644
--- a/tools/testing/selftests/lib.mk
+++ b/tools/testing/selftests/lib.mk
@@ -45,4 +45,7 @@ all: $(TEST_GEN_PROGS) $(TEST_GEN_PROGS_EXTENDED) $(TEST_GEN_FILES)
 clean:
 	$(RM) -fr $(TEST_GEN_PROGS) $(TEST_GEN_PROGS_EXTENDED) $(TEST_GEN_FILES)
 
+%: %.c
+	$(CC) $(CFLAGS) $(LDFLAGS) $(LDLIBS) -o $@ $^
+
 .PHONY: run_tests all clean install emit_tests
diff --git a/tools/testing/selftests/mount/Makefile b/tools/testing/selftests/mount/Makefile
index e8fb15e..9093d7f 100644
--- a/tools/testing/selftests/mount/Makefile
+++ b/tools/testing/selftests/mount/Makefile
@@ -2,9 +2,6 @@
 CFLAGS = -Wall \
          -O2
 
-unprivileged-remount-test: unprivileged-remount-test.c
-	$(CC) $(CFLAGS) unprivileged-remount-test.c -o unprivileged-remount-test
-
 TEST_GEN_PROGS := unprivileged-remount-test
 
 include ../lib.mk
diff --git a/tools/testing/selftests/net/Makefile b/tools/testing/selftests/net/Makefile
index c976425..d13620a 100644
--- a/tools/testing/selftests/net/Makefile
+++ b/tools/testing/selftests/net/Makefile
@@ -4,8 +4,6 @@ CFLAGS = -Wall -O2 -g
 
 CFLAGS += -I../../../../usr/include/
 
-%: %.c
-	$(CC) $(CFLAGS) -o $@ $^
 TEST_PROGS := run_netsocktests run_afpackettests test_bpf.sh
 TEST_GEN_FILES := socket psock_fanout psock_tpacket reuseport_bpf reuseport_bpf_cpu reuseport_dualstack
 
diff --git a/tools/testing/selftests/size/Makefile b/tools/testing/selftests/size/Makefile
index c67f357..4685b3e 100644
--- a/tools/testing/selftests/size/Makefile
+++ b/tools/testing/selftests/size/Makefile
@@ -1,6 +1,4 @@
-
-get_size: get_size.c
-	$(CC) -static -ffreestanding -nostartfiles -s $< -o $@
+CFLAGS := -static -ffreestanding -nostartfiles -s
 
 TEST_GEN_PROGS := get_size
 
diff --git a/tools/testing/selftests/vm/Makefile b/tools/testing/selftests/vm/Makefile
index 323383a..eb0aaff 100644
--- a/tools/testing/selftests/vm/Makefile
+++ b/tools/testing/selftests/vm/Makefile
@@ -1,6 +1,7 @@
 # Makefile for vm selftests
 
 CFLAGS = -Wall -I ../../../../usr/include $(EXTRA_CFLAGS)
+LDLIBS = -lrt
 TEST_GEN_FILES = compaction_test
 TEST_GEN_FILES += hugepage-mmap
 TEST_GEN_FILES += hugepage-shm
@@ -12,8 +13,6 @@ TEST_GEN_FILES += transhuge-stress
 TEST_GEN_FILES += userfaultfd
 TEST_GEN_FILES += mlock-random-test
 
-%: %.c
-	$(CC) $(CFLAGS) -o $@ $^ -lrt
 userfaultfd: userfaultfd.c ../../../../usr/include/linux/kernel.h
 	$(CC) $(CFLAGS) -O2 -o $@ $< -lpthread
 
-- 
1.8.4.5
