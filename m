From: <bamvor.zhangjian@huawei.com>
Subject: [PATCH RFC 1/6] selftests: remove duplicated all and clean target
Date: Fri, 21 Oct 2016 19:01:29 +0800
Message-ID: <1477047694-24122-2-git-send-email-bamvor.zhangjian@huawei.com>
References: <1477047694-24122-1-git-send-email-bamvor.zhangjian@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1477047694-24122-1-git-send-email-bamvor.zhangjian@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: shuahkh@osg.samsung.com
Cc: linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, khilman@linaro.org, broonie@kernel.org, mpe@ellerman.id.au
List-Id: linux-api@vger.kernel.org

From: Bamvor Jian Zhang <bamvor.zhangjian@linaro.org>

Currently, kselftest use TEST_PROGS, TEST_PROGS_EXTENDED, TEST_FILES to
indicate the default test program, extended test program and test files.
These lead to duplicated all and clean targets.

In order to remove them, introduce TEST_GEN_PROGS,
TEST_GEN_PROGS_EXTENDED, TEST_GEN_FILES to indicate the compiled
objected.

And add this changes to "Contributing new tests(details)" of
Documentation/kselftest.txt.

Signed-off-by: Bamvor Jian Zhang <bamvor.zhangjian@linaro.org>
---
 Documentation/kselftest.txt                        | 13 ++++++++++++
 tools/testing/selftests/breakpoints/Makefile       |  8 ++------
 tools/testing/selftests/capabilities/Makefile      | 11 ++--------
 tools/testing/selftests/efivarfs/Makefile          |  8 +-------
 tools/testing/selftests/exec/Makefile              | 10 ++++-----
 tools/testing/selftests/futex/functional/Makefile  | 12 +++--------
 tools/testing/selftests/ipc/Makefile               |  7 +------
 tools/testing/selftests/kcmp/Makefile              |  6 ++----
 tools/testing/selftests/lib.mk                     | 18 ++++++++++++----
 tools/testing/selftests/membarrier/Makefile        |  6 +-----
 tools/testing/selftests/memfd/Makefile             | 14 +++----------
 tools/testing/selftests/mount/Makefile             |  6 ++----
 tools/testing/selftests/mqueue/Makefile            |  6 +-----
 tools/testing/selftests/net/Makefile               |  8 +-------
 tools/testing/selftests/powerpc/alignment/Makefile |  9 ++------
 .../testing/selftests/powerpc/benchmarks/Makefile  | 10 ++++-----
 .../selftests/powerpc/context_switch/Makefile      |  9 ++------
 tools/testing/selftests/powerpc/copyloops/Makefile | 10 ++++-----
 tools/testing/selftests/powerpc/dscr/Makefile      | 12 +++++------
 tools/testing/selftests/powerpc/math/Makefile      | 12 +++++------
 tools/testing/selftests/powerpc/mm/Makefile        | 12 ++++-------
 tools/testing/selftests/powerpc/pmu/Makefile       | 12 +++++------
 tools/testing/selftests/powerpc/pmu/ebb/Makefile   | 11 +++-------
 .../testing/selftests/powerpc/primitives/Makefile  | 10 ++++-----
 .../testing/selftests/powerpc/stringloops/Makefile | 10 ++++-----
 .../selftests/powerpc/switch_endian/Makefile       |  8 +++-----
 tools/testing/selftests/powerpc/syscalls/Makefile  | 10 ++++-----
 tools/testing/selftests/powerpc/tm/Makefile        | 10 ++++-----
 tools/testing/selftests/powerpc/vphn/Makefile      | 10 +++------
 tools/testing/selftests/ptrace/Makefile            |  8 +-------
 tools/testing/selftests/seccomp/Makefile           |  6 +-----
 tools/testing/selftests/sigaltstack/Makefile       |  5 +----
 tools/testing/selftests/size/Makefile              |  6 +-----
 tools/testing/selftests/timers/Makefile            |  9 ++------
 tools/testing/selftests/vm/Makefile                | 24 +++++++++-------------
 35 files changed, 123 insertions(+), 223 deletions(-)

diff --git a/Documentation/kselftest.txt b/Documentation/kselftest.txt
index 54bee77..11cdd06 100644
--- a/Documentation/kselftest.txt
+++ b/Documentation/kselftest.txt
@@ -84,3 +84,16 @@ In general, the rules for selftests are
 
  * Don't cause the top-level "make run_tests" to fail if your feature is
    unconfigured.
+
+Contributing new tests(details)
+===============================
+
+ * Use TEST_GEN_XXX if such binaries or files are generated during
+   compiling.
+   TEST_PROGS, TEST_GEN_PROGS mean it is the excutable tested by
+   default.
+   TEST_PROGS_EXTENDED, TEST_GEN_PROGS_EXTENDED mean it is the
+   executable which is not tested by default.
+   TEST_FILES, TEST_GEN_FILES mean it is the file which is used by
+   test.
+
diff --git a/tools/testing/selftests/breakpoints/Makefile b/tools/testing/selftests/breakpoints/Makefile
index 74e533f..616f36a 100644
--- a/tools/testing/selftests/breakpoints/Makefile
+++ b/tools/testing/selftests/breakpoints/Makefile
@@ -3,14 +3,10 @@ uname_M := $(shell uname -m 2>/dev/null || echo not)
 ARCH ?= $(shell echo $(uname_M) | sed -e s/i.86/x86/ -e s/x86_64/x86/)
 
 ifeq ($(ARCH),x86)
-TEST_PROGS := breakpoint_test
+TEST_GEN_PROGS := breakpoint_test
 endif
 
-TEST_PROGS += step_after_suspend_test
-
-all: $(TEST_PROGS)
+TEST_GEN_PROGS += step_after_suspend_test
 
 include ../lib.mk
 
-clean:
-	rm -fr breakpoint_test step_after_suspend_test
diff --git a/tools/testing/selftests/capabilities/Makefile b/tools/testing/selftests/capabilities/Makefile
index 008602a..29b8adf 100644
--- a/tools/testing/selftests/capabilities/Makefile
+++ b/tools/testing/selftests/capabilities/Makefile
@@ -1,15 +1,8 @@
-TEST_FILES := validate_cap
-TEST_PROGS := test_execve
-
-BINARIES := $(TEST_FILES) $(TEST_PROGS)
+TEST_GEN_FILES := validate_cap
+TEST_GEN_PROGS := test_execve
 
 CFLAGS += -O2 -g -std=gnu99 -Wall
 LDLIBS += -lcap-ng -lrt -ldl
 
-all: $(BINARIES)
-
-clean:
-	$(RM) $(BINARIES)
-
 include ../lib.mk
 
diff --git a/tools/testing/selftests/efivarfs/Makefile b/tools/testing/selftests/efivarfs/Makefile
index 736c3dd..c49dcea 100644
--- a/tools/testing/selftests/efivarfs/Makefile
+++ b/tools/testing/selftests/efivarfs/Makefile
@@ -1,13 +1,7 @@
 CFLAGS = -Wall
 
-test_objs = open-unlink create-read
-
-all: $(test_objs)
-
+TEST_GEN_FILES := open-unlink create-read
 TEST_PROGS := efivarfs.sh
-TEST_FILES := $(test_objs)
 
 include ../lib.mk
 
-clean:
-	rm -f $(test_objs)
diff --git a/tools/testing/selftests/exec/Makefile b/tools/testing/selftests/exec/Makefile
index d430060..b3bf091 100644
--- a/tools/testing/selftests/exec/Makefile
+++ b/tools/testing/selftests/exec/Makefile
@@ -1,7 +1,4 @@
 CFLAGS = -Wall
-BINARIES = execveat
-DEPS = execveat.symlink execveat.denatured script subdir
-all: $(BINARIES) $(DEPS)
 
 subdir:
 	mkdir -p $@
@@ -17,11 +14,12 @@ execveat.denatured: execveat
 %: %.c
 	$(CC) $(CFLAGS) -o $@ $^
 
-TEST_PROGS := execveat
+TEST_GEN_PROGS := execveat
+TEST_GEN_FILES := execveat.symlink execveat.denatured script subdir
 # Makefile is a run-time dependency, since it's accessed by the execveat test
-TEST_FILES := $(DEPS) Makefile
+TEST_FILES := Makefile
 
 include ../lib.mk
 
 clean:
-	rm -rf $(BINARIES) $(DEPS) subdir.moved execveat.moved xxxxx*
+	rm -rf $(TEST_GEN_PROGS) $(TEST_GEN_FILES) subdir.moved execveat.moved xxxxx*
diff --git a/tools/testing/selftests/futex/functional/Makefile b/tools/testing/selftests/futex/functional/Makefile
index 9d6b75e..ac35782 100644
--- a/tools/testing/selftests/futex/functional/Makefile
+++ b/tools/testing/selftests/futex/functional/Makefile
@@ -3,7 +3,7 @@ CFLAGS := $(CFLAGS) -g -O2 -Wall -D_GNU_SOURCE -pthread $(INCLUDES)
 LDFLAGS := $(LDFLAGS) -pthread -lrt
 
 HEADERS := ../include/futextest.h
-TARGETS := \
+TEST_GEN_FILES := \
 	futex_wait_timeout \
 	futex_wait_wouldblock \
 	futex_requeue_pi \
@@ -12,14 +12,8 @@ TARGETS := \
 	futex_wait_uninitialized_heap \
 	futex_wait_private_mapped_file
 
-TEST_PROGS := $(TARGETS) run.sh
-
-.PHONY: all clean
-all: $(TARGETS)
-
-$(TARGETS): $(HEADERS)
+TEST_PROGS := run.sh
 
 include ../../lib.mk
 
-clean:
-	rm -f $(TARGETS)
+$(TEST_GEN_FILES): $(HEADERS)
diff --git a/tools/testing/selftests/ipc/Makefile b/tools/testing/selftests/ipc/Makefile
index 25d2e70..30ef4c7 100644
--- a/tools/testing/selftests/ipc/Makefile
+++ b/tools/testing/selftests/ipc/Makefile
@@ -11,12 +11,7 @@ endif
 
 CFLAGS += -I../../../../usr/include/
 
-all:
-	$(CC) $(CFLAGS) msgque.c -o msgque_test
-
-TEST_PROGS := msgque_test
+TEST_GEN_PROGS := msgque
 
 include ../lib.mk
 
-clean:
-	rm -fr ./msgque_test
diff --git a/tools/testing/selftests/kcmp/Makefile b/tools/testing/selftests/kcmp/Makefile
index 2ae7450..9e8b673 100644
--- a/tools/testing/selftests/kcmp/Makefile
+++ b/tools/testing/selftests/kcmp/Makefile
@@ -1,10 +1,8 @@
 CFLAGS += -I../../../../usr/include/
 
-all: kcmp_test
-
-TEST_PROGS := kcmp_test
+TEST_GEN_PROGS := kcmp_test
 
 include ../lib.mk
 
 clean:
-	$(RM) kcmp_test kcmp-test-file
+	$(RM) $(TEST_GEN_PROGS) kcmp-test-file
diff --git a/tools/testing/selftests/lib.mk b/tools/testing/selftests/lib.mk
index 50a93f5..12edfb1f 100644
--- a/tools/testing/selftests/lib.mk
+++ b/tools/testing/selftests/lib.mk
@@ -3,7 +3,7 @@
 CC := $(CROSS_COMPILE)gcc
 
 define RUN_TESTS
-	@for TEST in $(TEST_PROGS); do \
+	@for TEST in $(TEST_GEN_PROGS) $(TEST_PROGS); do \
 		(./$$TEST && echo "selftests: $$TEST [PASS]") || echo "selftests: $$TEST [FAIL]"; \
 	done;
 endef
@@ -14,8 +14,13 @@ run_tests: all
 define INSTALL_RULE
 	@if [ "X$(TEST_PROGS)$(TEST_PROGS_EXTENDED)$(TEST_FILES)" != "X" ]; then					\
 		mkdir -p ${INSTALL_PATH};										\
-		echo "rsync -a $(TEST_DIRS) $(TEST_PROGS) $(TEST_PROGS_EXTENDED) $(TEST_FILES) $(INSTALL_PATH)/";	\
-		rsync -a $(TEST_DIRS) $(TEST_PROGS) $(TEST_PROGS_EXTENDED) $(TEST_FILES) $(INSTALL_PATH)/;		\
+		echo "rsync -a $(TEST_DIRS) $(TEST_PROGS) $(TEST_PROGS_EXTENDED) $(TEST_FILES) $(INSTALL_PATH)/";       \
+		rsync -a $(TEST_DIRS) $(TEST_PROGS) $(TEST_PROGS_EXTENDED) $(TEST_FILES) $(INSTALL_PATH)/;              \
+	fi
+	@if [ "X$(TEST_GEN_PROGS)$(TEST_GEN_PROGS_EXTENDED)$(TEST_GEN_FILES)" != "X" ]; then					\
+		mkdir -p ${INSTALL_PATH};										\
+		echo "rsync -a $(TEST_GEN_PROGS) $(TEST_GEN_PROGS_EXTENDED) $(TEST_GEN_FILES) $(INSTALL_PATH)/";	\
+		rsync -a $(TEST_GEN_PROGS) $(TEST_GEN_PROGS_EXTENDED) $(TEST_GEN_FILES) $(INSTALL_PATH)/;		\
 	fi
 endef
 
@@ -27,7 +32,7 @@ else
 endif
 
 define EMIT_TESTS
-	@for TEST in $(TEST_PROGS); do \
+	@for TEST in $(TEST_GEN_PROGS) $(TEST_PROGS); do \
 		echo "(./$$TEST && echo \"selftests: $$TEST [PASS]\") || echo \"selftests: $$TEST [FAIL]\""; \
 	done;
 endef
@@ -35,4 +40,9 @@ endef
 emit_tests:
 	$(EMIT_TESTS)
 
+all: $(TEST_GEN_PROGS) $(TEST_GEN_PROGS_EXTENDED) $(TEST_GEN_FILES)
+
+clean:
+	$(RM) -fr $(TEST_GEN_PROGS) $(TEST_GEN_PROGS_EXTENDED) $(TEST_GEN_FILES)
+
 .PHONY: run_tests all clean install emit_tests
diff --git a/tools/testing/selftests/membarrier/Makefile b/tools/testing/selftests/membarrier/Makefile
index a1a9708..0284553 100644
--- a/tools/testing/selftests/membarrier/Makefile
+++ b/tools/testing/selftests/membarrier/Makefile
@@ -1,10 +1,6 @@
 CFLAGS += -g -I../../../../usr/include/
 
-TEST_PROGS := membarrier_test
-
-all: $(TEST_PROGS)
+TEST_GEN_PROGS := membarrier_test
 
 include ../lib.mk
 
-clean:
-	$(RM) $(TEST_PROGS)
diff --git a/tools/testing/selftests/memfd/Makefile b/tools/testing/selftests/memfd/Makefile
index fd396ac..2c87f23 100644
--- a/tools/testing/selftests/memfd/Makefile
+++ b/tools/testing/selftests/memfd/Makefile
@@ -4,19 +4,11 @@ CFLAGS += -I../../../../include/uapi/
 CFLAGS += -I../../../../include/
 CFLAGS += -I../../../../usr/include/
 
-TEST_PROGS := memfd_test
-
-all: $(TEST_PROGS)
-
-include ../lib.mk
-
-build_fuse: fuse_mnt fuse_test
+TEST_PROGS := run_fuse_test.sh
+TEST_GEN_FILES := memfd_test fuse_mnt fuse_test
 
 fuse_mnt.o: CFLAGS += $(shell pkg-config fuse --cflags)
 fuse_mnt: LDFLAGS += $(shell pkg-config fuse --libs)
 
-run_fuse: build_fuse
-	@./run_fuse_test.sh || echo "fuse_test: [FAIL]"
+include ../lib.mk
 
-clean:
-	$(RM) memfd_test fuse_test
diff --git a/tools/testing/selftests/mount/Makefile b/tools/testing/selftests/mount/Makefile
index 5e35c9c..e8fb15e 100644
--- a/tools/testing/selftests/mount/Makefile
+++ b/tools/testing/selftests/mount/Makefile
@@ -1,14 +1,14 @@
 # Makefile for mount selftests.
 CFLAGS = -Wall \
          -O2
-all: unprivileged-remount-test
 
 unprivileged-remount-test: unprivileged-remount-test.c
 	$(CC) $(CFLAGS) unprivileged-remount-test.c -o unprivileged-remount-test
 
+TEST_GEN_PROGS := unprivileged-remount-test
+
 include ../lib.mk
 
-TEST_PROGS := unprivileged-remount-test
 override RUN_TESTS := if [ -f /proc/self/uid_map ] ; \
 		      then	\
 				./unprivileged-remount-test ; \
@@ -17,5 +17,3 @@ override RUN_TESTS := if [ -f /proc/self/uid_map ] ; \
 		      fi
 override EMIT_TESTS := echo "$(RUN_TESTS)"
 
-clean:
-	rm -f unprivileged-remount-test
diff --git a/tools/testing/selftests/mqueue/Makefile b/tools/testing/selftests/mqueue/Makefile
index eebac29..79a664a 100644
--- a/tools/testing/selftests/mqueue/Makefile
+++ b/tools/testing/selftests/mqueue/Makefile
@@ -1,8 +1,6 @@
 CFLAGS += -O2
 LDLIBS = -lrt -lpthread -lpopt
-TEST_PROGS := mq_open_tests mq_perf_tests
-
-all: $(TEST_PROGS)
+TEST_GEN_PROGS := mq_open_tests mq_perf_tests
 
 include ../lib.mk
 
@@ -16,5 +14,3 @@ override define EMIT_TESTS
 	echo "./mq_perf_tests || echo \"selftests: mq_perf_tests [FAIL]\""
 endef
 
-clean:
-	rm -f mq_open_tests mq_perf_tests
diff --git a/tools/testing/selftests/net/Makefile b/tools/testing/selftests/net/Makefile
index 0e53407..c976425 100644
--- a/tools/testing/selftests/net/Makefile
+++ b/tools/testing/selftests/net/Makefile
@@ -4,16 +4,10 @@ CFLAGS = -Wall -O2 -g
 
 CFLAGS += -I../../../../usr/include/
 
-NET_PROGS = socket psock_fanout psock_tpacket reuseport_bpf reuseport_bpf_cpu reuseport_dualstack
-
-all: $(NET_PROGS)
 %: %.c
 	$(CC) $(CFLAGS) -o $@ $^
-
 TEST_PROGS := run_netsocktests run_afpackettests test_bpf.sh
-TEST_FILES := $(NET_PROGS)
+TEST_GEN_FILES := socket psock_fanout psock_tpacket reuseport_bpf reuseport_bpf_cpu reuseport_dualstack
 
 include ../lib.mk
 
-clean:
-	$(RM) $(NET_PROGS)
diff --git a/tools/testing/selftests/powerpc/alignment/Makefile b/tools/testing/selftests/powerpc/alignment/Makefile
index ad6a4e4..16b2200 100644
--- a/tools/testing/selftests/powerpc/alignment/Makefile
+++ b/tools/testing/selftests/powerpc/alignment/Makefile
@@ -1,10 +1,5 @@
-TEST_PROGS := copy_unaligned copy_first_unaligned paste_unaligned paste_last_unaligned
-
-all: $(TEST_PROGS)
-
-$(TEST_PROGS): ../harness.c ../utils.c copy_paste_unaligned_common.c
+TEST_GEN_PROGS := copy_unaligned copy_first_unaligned paste_unaligned paste_last_unaligned
 
 include ../../lib.mk
 
-clean:
-	rm -f $(TEST_PROGS)
+$(TEST_GEN_PROGS): ../harness.c ../utils.c copy_paste_unaligned_common.c
diff --git a/tools/testing/selftests/powerpc/benchmarks/Makefile b/tools/testing/selftests/powerpc/benchmarks/Makefile
index a9adfb7..985a77c 100644
--- a/tools/testing/selftests/powerpc/benchmarks/Makefile
+++ b/tools/testing/selftests/powerpc/benchmarks/Makefile
@@ -1,16 +1,14 @@
-TEST_PROGS := gettimeofday context_switch mmap_bench futex_bench
+TEST_GEN_PROGS := gettimeofday context_switch mmap_bench futex_bench
 
 CFLAGS += -O2
 
-all: $(TEST_PROGS)
+$(TEST_GEN_PROGS): ../harness.c
 
-$(TEST_PROGS): ../harness.c
+include ../../lib.mk
 
 context_switch: ../utils.c
 context_switch: CFLAGS += -maltivec -mvsx -mabi=altivec
 context_switch: LDLIBS += -lpthread
 
-include ../../lib.mk
-
 clean:
-	rm -f $(TEST_PROGS) *.o
+	$(RM) $(TEST_GEN_PROGS) *.o
diff --git a/tools/testing/selftests/powerpc/context_switch/Makefile b/tools/testing/selftests/powerpc/context_switch/Makefile
index e164d14..e9351bb 100644
--- a/tools/testing/selftests/powerpc/context_switch/Makefile
+++ b/tools/testing/selftests/powerpc/context_switch/Makefile
@@ -1,10 +1,5 @@
-TEST_PROGS := cp_abort
-
-all: $(TEST_PROGS)
-
-$(TEST_PROGS): ../harness.c ../utils.c
+TEST_GEN_PROGS := cp_abort
 
 include ../../lib.mk
 
-clean:
-	rm -f $(TEST_PROGS)
+$(TEST_GEN_PROGS): ../harness.c ../utils.c
diff --git a/tools/testing/selftests/powerpc/copyloops/Makefile b/tools/testing/selftests/powerpc/copyloops/Makefile
index 384843e..eff1034 100644
--- a/tools/testing/selftests/powerpc/copyloops/Makefile
+++ b/tools/testing/selftests/powerpc/copyloops/Makefile
@@ -7,19 +7,17 @@ CFLAGS += -maltivec
 # Use our CFLAGS for the implicit .S rule
 ASFLAGS = $(CFLAGS)
 
-TEST_PROGS := copyuser_64 copyuser_power7 memcpy_64 memcpy_power7
+TEST_GEN_PROGS := copyuser_64 copyuser_power7 memcpy_64 memcpy_power7
 EXTRA_SOURCES := validate.c ../harness.c
 
-all: $(TEST_PROGS)
+include ../../lib.mk
 
 copyuser_64:     CPPFLAGS += -D COPY_LOOP=test___copy_tofrom_user_base
 copyuser_power7: CPPFLAGS += -D COPY_LOOP=test___copy_tofrom_user_power7
 memcpy_64:       CPPFLAGS += -D COPY_LOOP=test_memcpy
 memcpy_power7:   CPPFLAGS += -D COPY_LOOP=test_memcpy_power7
 
-$(TEST_PROGS): $(EXTRA_SOURCES)
-
-include ../../lib.mk
+$(TEST_GEN_PROGS): $(EXTRA_SOURCES)
 
 clean:
-	rm -f $(TEST_PROGS) *.o
+	$(RM) $(TEST_GEN_PROGS) *.o
diff --git a/tools/testing/selftests/powerpc/dscr/Makefile b/tools/testing/selftests/powerpc/dscr/Makefile
index 49327ee..96e0de0 100644
--- a/tools/testing/selftests/powerpc/dscr/Makefile
+++ b/tools/testing/selftests/powerpc/dscr/Makefile
@@ -1,14 +1,12 @@
-TEST_PROGS := dscr_default_test dscr_explicit_test dscr_user_test	\
+TEST_GEN_PROGS := dscr_default_test dscr_explicit_test dscr_user_test	\
 	      dscr_inherit_test dscr_inherit_exec_test dscr_sysfs_test	\
 	      dscr_sysfs_thread_test
 
-dscr_default_test: LDLIBS += -lpthread
-
-all: $(TEST_PROGS)
+include ../../lib.mk
 
-$(TEST_PROGS): ../harness.c
+dscr_default_test: LDLIBS += -lpthread
 
-include ../../lib.mk
+$(TEST_GEN_PROGS): ../harness.c
 
 clean:
-	rm -f $(TEST_PROGS) *.o
+	$(RM) $(TEST_GEN_PROGS) *.o
diff --git a/tools/testing/selftests/powerpc/math/Makefile b/tools/testing/selftests/powerpc/math/Makefile
index a505b66..8a5dde5 100644
--- a/tools/testing/selftests/powerpc/math/Makefile
+++ b/tools/testing/selftests/powerpc/math/Makefile
@@ -1,9 +1,9 @@
-TEST_PROGS := fpu_syscall fpu_preempt fpu_signal vmx_syscall vmx_preempt vmx_signal vsx_preempt
+TEST_GEN_PROGS := fpu_syscall fpu_preempt fpu_signal vmx_syscall vmx_preempt vmx_signal vsx_preempt
 
-all: $(TEST_PROGS)
+include ../../lib.mk
 
-$(TEST_PROGS): ../harness.c
-$(TEST_PROGS): CFLAGS += -O2 -g -pthread -m64 -maltivec
+$(TEST_GEN_PROGS): ../harness.c
+$(TEST_GEN_PROGS): CFLAGS += -O2 -g -pthread -m64 -maltivec
 
 fpu_syscall: fpu_asm.S
 fpu_preempt: fpu_asm.S
@@ -16,7 +16,5 @@ vmx_signal: vmx_asm.S
 vsx_preempt: CFLAGS += -mvsx
 vsx_preempt: vsx_asm.S
 
-include ../../lib.mk
-
 clean:
-	rm -f $(TEST_PROGS) *.o
+	$(RM) $(TEST_GEN_PROGS) *.o
diff --git a/tools/testing/selftests/powerpc/mm/Makefile b/tools/testing/selftests/powerpc/mm/Makefile
index 3bdb96e..d563378 100644
--- a/tools/testing/selftests/powerpc/mm/Makefile
+++ b/tools/testing/selftests/powerpc/mm/Makefile
@@ -1,19 +1,15 @@
 noarg:
 	$(MAKE) -C ../
 
-TEST_PROGS := hugetlb_vs_thp_test subpage_prot prot_sao
-TEST_FILES := tempfile
+TEST_GEN_PROGS := hugetlb_vs_thp_test subpage_prot prot_sao
+TEST_GEN_FILES := tempfile
 
-all: $(TEST_PROGS) $(TEST_FILES)
+include ../../lib.mk
 
-$(TEST_PROGS): ../harness.c
+$(TEST_GEN_PROGS): ../harness.c
 
 prot_sao: ../utils.c
 
-include ../../lib.mk
-
 tempfile:
 	dd if=/dev/zero of=tempfile bs=64k count=1
 
-clean:
-	rm -f $(TEST_PROGS) tempfile
diff --git a/tools/testing/selftests/powerpc/pmu/Makefile b/tools/testing/selftests/powerpc/pmu/Makefile
index ac41a71..ab0f902 100644
--- a/tools/testing/selftests/powerpc/pmu/Makefile
+++ b/tools/testing/selftests/powerpc/pmu/Makefile
@@ -1,12 +1,14 @@
 noarg:
 	$(MAKE) -C ../
 
-TEST_PROGS := count_instructions l3_bank_test per_event_excludes
+TEST_GEN_PROGS := count_instructions l3_bank_test per_event_excludes
 EXTRA_SOURCES := ../harness.c event.c lib.c ../utils.c
 
-all: $(TEST_PROGS) ebb
+include ../../lib.mk
+
+all: $(TEST_GEN_PROGS) ebb
 
-$(TEST_PROGS): $(EXTRA_SOURCES)
+$(TEST_GEN_PROGS): $(EXTRA_SOURCES)
 
 # loop.S can only be built 64-bit
 count_instructions: loop.S count_instructions.c $(EXTRA_SOURCES)
@@ -14,8 +16,6 @@ count_instructions: loop.S count_instructions.c $(EXTRA_SOURCES)
 
 per_event_excludes: ../utils.c
 
-include ../../lib.mk
-
 DEFAULT_RUN_TESTS := $(RUN_TESTS)
 override define RUN_TESTS
 	$(DEFAULT_RUN_TESTS)
@@ -35,7 +35,7 @@ override define INSTALL_RULE
 endef
 
 clean:
-	rm -f $(TEST_PROGS) loop.o
+	$(RM) $(TEST_PROGS) loop.o
 	$(MAKE) -C ebb clean
 
 ebb:
diff --git a/tools/testing/selftests/powerpc/pmu/ebb/Makefile b/tools/testing/selftests/powerpc/pmu/ebb/Makefile
index 6b0453e..8dcedc4 100644
--- a/tools/testing/selftests/powerpc/pmu/ebb/Makefile
+++ b/tools/testing/selftests/powerpc/pmu/ebb/Makefile
@@ -4,7 +4,7 @@ noarg:
 # The EBB handler is 64-bit code and everything links against it
 CFLAGS += -m64
 
-TEST_PROGS := reg_access_test event_attributes_test cycles_test	\
+TEST_GEN_PROGS := reg_access_test event_attributes_test cycles_test	\
 	 cycles_with_freeze_test pmc56_overflow_test		\
 	 ebb_vs_cpu_event_test cpu_event_vs_ebb_test		\
 	 cpu_event_pinned_vs_ebb_test task_event_vs_ebb_test	\
@@ -16,16 +16,11 @@ TEST_PROGS := reg_access_test event_attributes_test cycles_test	\
 	 lost_exception_test no_handler_test			\
 	 cycles_with_mmcr2_test ebb_lmr ebb_lmr_regs
 
-all: $(TEST_PROGS)
+include ../../../lib.mk
 
-$(TEST_PROGS): ../../harness.c ../../utils.c ../event.c ../lib.c \
+$(TEST_GEN_PROGS): ../../harness.c ../../utils.c ../event.c ../lib.c \
 	       ebb.c ebb_handler.S trace.c busy_loop.S
 
 instruction_count_test: ../loop.S
 
 lost_exception_test: ../lib.c
-
-include ../../../lib.mk
-
-clean:
-	rm -f $(TEST_PROGS)
diff --git a/tools/testing/selftests/powerpc/primitives/Makefile b/tools/testing/selftests/powerpc/primitives/Makefile
index b68c622..32cd56c 100644
--- a/tools/testing/selftests/powerpc/primitives/Makefile
+++ b/tools/testing/selftests/powerpc/primitives/Makefile
@@ -1,12 +1,10 @@
 CFLAGS += -I$(CURDIR)
 
-TEST_PROGS := load_unaligned_zeropad
-
-all: $(TEST_PROGS)
-
-$(TEST_PROGS): ../harness.c
+TEST_GEN_PROGS := load_unaligned_zeropad
 
 include ../../lib.mk
 
+$(TEST_GEN_PROGS): ../harness.c
+
 clean:
-	rm -f $(TEST_PROGS) *.o
+	$(RM) $(TEST_GEN_PROGS) *.o
diff --git a/tools/testing/selftests/powerpc/stringloops/Makefile b/tools/testing/selftests/powerpc/stringloops/Makefile
index 2a728f4..c0ce663 100644
--- a/tools/testing/selftests/powerpc/stringloops/Makefile
+++ b/tools/testing/selftests/powerpc/stringloops/Makefile
@@ -2,14 +2,12 @@
 CFLAGS += -m64
 CFLAGS += -I$(CURDIR)
 
-TEST_PROGS := memcmp
+TEST_GEN_PROGS := memcmp
 EXTRA_SOURCES := memcmp_64.S ../harness.c
 
-all: $(TEST_PROGS)
-
-$(TEST_PROGS): $(EXTRA_SOURCES)
-
 include ../../lib.mk
 
+$(TEST_GEN_PROGS): $(EXTRA_SOURCES)
+
 clean:
-	rm -f $(TEST_PROGS) *.o
+	$(RM) $(TEST_GEN_PROGS) *.o
diff --git a/tools/testing/selftests/powerpc/switch_endian/Makefile b/tools/testing/selftests/powerpc/switch_endian/Makefile
index e21d106..bd01223 100644
--- a/tools/testing/selftests/powerpc/switch_endian/Makefile
+++ b/tools/testing/selftests/powerpc/switch_endian/Makefile
@@ -1,8 +1,8 @@
-TEST_PROGS := switch_endian_test
+TEST_GEN_PROGS := switch_endian_test
 
 ASFLAGS += -O2 -Wall -g -nostdlib -m64
 
-all: $(TEST_PROGS)
+include ../../lib.mk
 
 switch_endian_test: check-reversed.S
 
@@ -12,7 +12,5 @@ check-reversed.o: check.o
 check-reversed.S: check-reversed.o
 	hexdump -v -e '/1 ".byte 0x%02X\n"' $< > $@
 
-include ../../lib.mk
-
 clean:
-	rm -f $(TEST_PROGS) *.o check-reversed.S
+	$(RM) $(TEST_GEN_PROGS) *.o check-reversed.S
diff --git a/tools/testing/selftests/powerpc/syscalls/Makefile b/tools/testing/selftests/powerpc/syscalls/Makefile
index b35c794..5bea391 100644
--- a/tools/testing/selftests/powerpc/syscalls/Makefile
+++ b/tools/testing/selftests/powerpc/syscalls/Makefile
@@ -1,12 +1,10 @@
-TEST_PROGS := ipc_unmuxed
+TEST_GEN_PROGS := ipc_unmuxed
 
 CFLAGS += -I../../../../../usr/include
 
-all: $(TEST_PROGS)
-
-$(TEST_PROGS): ../harness.c
-
 include ../../lib.mk
 
+$(TEST_GEN_PROGS): ../harness.c
+
 clean:
-	rm -f $(TEST_PROGS) *.o
+	$(RM) $(TEST_GEN_PROGS) *.o
diff --git a/tools/testing/selftests/powerpc/tm/Makefile b/tools/testing/selftests/powerpc/tm/Makefile
index c6c53c8..cad0821 100644
--- a/tools/testing/selftests/powerpc/tm/Makefile
+++ b/tools/testing/selftests/powerpc/tm/Makefile
@@ -1,12 +1,12 @@
 SIGNAL_CONTEXT_CHK_TESTS := tm-signal-context-chk-gpr tm-signal-context-chk-fpu \
 	tm-signal-context-chk-vmx tm-signal-context-chk-vsx
 
-TEST_PROGS := tm-resched-dscr tm-syscall tm-signal-msr-resv tm-signal-stack \
+TEST_GEN_PROGS := tm-resched-dscr tm-syscall tm-signal-msr-resv tm-signal-stack \
 	tm-vmxcopy tm-fork tm-tar tm-tmspr $(SIGNAL_CONTEXT_CHK_TESTS)
 
-all: $(TEST_PROGS)
+include ../../lib.mk
 
-$(TEST_PROGS): ../harness.c ../utils.c
+$(TEST_GEN_PROGS): ../harness.c ../utils.c
 
 CFLAGS += -mhtm
 
@@ -17,7 +17,5 @@ tm-tmspr: CFLAGS += -pthread
 $(SIGNAL_CONTEXT_CHK_TESTS): tm-signal.S
 $(SIGNAL_CONTEXT_CHK_TESTS): CFLAGS += -mhtm -m64 -mvsx
 
-include ../../lib.mk
-
 clean:
-	rm -f $(TEST_PROGS) *.o
+	$(RM) $(TEST_GEN_PROGS) *.o
diff --git a/tools/testing/selftests/powerpc/vphn/Makefile b/tools/testing/selftests/powerpc/vphn/Makefile
index a485f2e..f8ced26 100644
--- a/tools/testing/selftests/powerpc/vphn/Makefile
+++ b/tools/testing/selftests/powerpc/vphn/Makefile
@@ -1,12 +1,8 @@
-TEST_PROGS := test-vphn
+TEST_GEN_PROGS := test-vphn
 
 CFLAGS += -m64
 
-all: $(TEST_PROGS)
-
-$(TEST_PROGS): ../harness.c
-
 include ../../lib.mk
 
-clean:
-	rm -f $(TEST_PROGS)
+$(TEST_GEN_PROGS): ../harness.c
+
diff --git a/tools/testing/selftests/ptrace/Makefile b/tools/testing/selftests/ptrace/Makefile
index 453927f..8a2bc55 100644
--- a/tools/testing/selftests/ptrace/Makefile
+++ b/tools/testing/selftests/ptrace/Makefile
@@ -1,11 +1,5 @@
 CFLAGS += -iquote../../../../include/uapi -Wall
-peeksiginfo: peeksiginfo.c
 
-all: peeksiginfo
-
-clean:
-	rm -f peeksiginfo
-
-TEST_PROGS := peeksiginfo
+TEST_GEN_PROGS := peeksiginfo
 
 include ../lib.mk
diff --git a/tools/testing/selftests/seccomp/Makefile b/tools/testing/selftests/seccomp/Makefile
index 8401e87..5fa6fd2 100644
--- a/tools/testing/selftests/seccomp/Makefile
+++ b/tools/testing/selftests/seccomp/Makefile
@@ -1,10 +1,6 @@
-TEST_PROGS := seccomp_bpf
+TEST_GEN_PROGS := seccomp_bpf
 CFLAGS += -Wl,-no-as-needed -Wall
 LDFLAGS += -lpthread
 
-all: $(TEST_PROGS)
-
 include ../lib.mk
 
-clean:
-	$(RM) $(TEST_PROGS)
diff --git a/tools/testing/selftests/sigaltstack/Makefile b/tools/testing/selftests/sigaltstack/Makefile
index 56af56e..f68fbf8 100644
--- a/tools/testing/selftests/sigaltstack/Makefile
+++ b/tools/testing/selftests/sigaltstack/Makefile
@@ -1,8 +1,5 @@
 CFLAGS = -Wall
-BINARIES = sas
-all: $(BINARIES)
+TEST_GEN_PROGS = sas
 
 include ../lib.mk
 
-clean:
-	rm -rf $(BINARIES)
diff --git a/tools/testing/selftests/size/Makefile b/tools/testing/selftests/size/Makefile
index bbd0b53..c67f357 100644
--- a/tools/testing/selftests/size/Makefile
+++ b/tools/testing/selftests/size/Makefile
@@ -1,11 +1,7 @@
-all: get_size
 
 get_size: get_size.c
 	$(CC) -static -ffreestanding -nostartfiles -s $< -o $@
 
-TEST_PROGS := get_size
+TEST_GEN_PROGS := get_size
 
 include ../lib.mk
-
-clean:
-	$(RM) get_size
diff --git a/tools/testing/selftests/timers/Makefile b/tools/testing/selftests/timers/Makefile
index 1d55568..4a3bffe 100644
--- a/tools/testing/selftests/timers/Makefile
+++ b/tools/testing/selftests/timers/Makefile
@@ -5,16 +5,13 @@ LDFLAGS += -lrt -lpthread
 
 # these are all "safe" tests that don't modify
 # system time or require escalated privledges
-TEST_PROGS = posix_timers nanosleep nsleep-lat set-timer-lat mqueue-lat \
+TEST_GEN_PROGS = posix_timers nanosleep nsleep-lat set-timer-lat mqueue-lat \
 	     inconsistency-check raw_skew threadtest rtctest
 
-TEST_PROGS_EXTENDED = alarmtimer-suspend valid-adjtimex adjtick change_skew \
+TEST_GEN_PROGS_EXTENDED = alarmtimer-suspend valid-adjtimex adjtick change_skew \
 		      skew_consistency clocksource-switch leap-a-day \
 		      leapcrash set-tai set-2038 set-tz
 
-bins = $(TEST_PROGS) $(TEST_PROGS_EXTENDED)
-
-all: ${bins}
 
 include ../lib.mk
 
@@ -34,5 +31,3 @@ run_destructive_tests: run_tests
 	./set-tai
 	./set-2038
 
-clean:
-	rm -f ${bins}
diff --git a/tools/testing/selftests/vm/Makefile b/tools/testing/selftests/vm/Makefile
index bbab7f4..323383a 100644
--- a/tools/testing/selftests/vm/Makefile
+++ b/tools/testing/selftests/vm/Makefile
@@ -1,18 +1,17 @@
 # Makefile for vm selftests
 
 CFLAGS = -Wall -I ../../../../usr/include $(EXTRA_CFLAGS)
-BINARIES = compaction_test
-BINARIES += hugepage-mmap
-BINARIES += hugepage-shm
-BINARIES += map_hugetlb
-BINARIES += mlock2-tests
-BINARIES += on-fault-limit
-BINARIES += thuge-gen
-BINARIES += transhuge-stress
-BINARIES += userfaultfd
-BINARIES += mlock-random-test
+TEST_GEN_FILES = compaction_test
+TEST_GEN_FILES += hugepage-mmap
+TEST_GEN_FILES += hugepage-shm
+TEST_GEN_FILES += map_hugetlb
+TEST_GEN_FILES += mlock2-tests
+TEST_GEN_FILES += on-fault-limit
+TEST_GEN_FILES += thuge-gen
+TEST_GEN_FILES += transhuge-stress
+TEST_GEN_FILES += userfaultfd
+TEST_GEN_FILES += mlock-random-test
 
-all: $(BINARIES)
 %: %.c
 	$(CC) $(CFLAGS) -o $@ $^ -lrt
 userfaultfd: userfaultfd.c ../../../../usr/include/linux/kernel.h
@@ -25,9 +24,6 @@ mlock-random-test: mlock-random-test.c
 	make -C ../../../.. headers_install
 
 TEST_PROGS := run_vmtests
-TEST_FILES := $(BINARIES)
 
 include ../lib.mk
 
-clean:
-	$(RM) $(BINARIES)
-- 
1.8.4.5
