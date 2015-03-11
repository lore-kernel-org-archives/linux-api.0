From: Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH v4 4/9] selftests: Add install target
Date: Wed, 11 Mar 2015 15:06:00 +1100
Message-ID: <1426046765-19289-4-git-send-email-mpe@ellerman.id.au>
References: <1426046765-19289-1-git-send-email-mpe@ellerman.id.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1426046765-19289-1-git-send-email-mpe@ellerman.id.au>
Sender: linux-kernel-owner@vger.kernel.org
To: shuahkh@osg.samsung.com
Cc: linux-kernel@vger.kernel.org, davej@codemonkey.org.uk, mmarek@suse.cz, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

This adds make install support to selftests. The basic usage is:

$ cd tools/testing/selftests
$ make install

That installs into tools/testing/selftests/install, which can then be
copied where ever necessary.

The install destination is also configurable using eg:

$ INSTALL_PATH=/mnt/selftests make install

The implementation uses two targets in the child makefiles. The first
"install" is expected to install all files into $(INSTALL_PATH).

The second, "emit_tests", is expected to emit the test instructions (ie.
bash script) on stdout. Separating this from install means the child
makefiles need no knowledge of the location of the test script.

Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
---

v3: Rebase onto 4.0-rc2.
    Rename all.sh to run_kselftest.sh.
    Add --no-print-directory to emit_tests invocation.
v4: Rebase onto 4.0-rc3, add TEST_FILES to efivars and vm tests, remove
    newlines from echoes.

 tools/testing/selftests/Makefile                | 33 +++++++++++++++++++++++++
 tools/testing/selftests/efivarfs/Makefile       |  1 +
 tools/testing/selftests/exec/Makefile           |  3 +++
 tools/testing/selftests/lib.mk                  | 23 ++++++++++++++++-
 tools/testing/selftests/memory-hotplug/Makefile |  2 ++
 tools/testing/selftests/mount/Makefile          |  2 ++
 tools/testing/selftests/mqueue/Makefile         |  7 ++++++
 tools/testing/selftests/net/Makefile            |  1 +
 tools/testing/selftests/sysctl/Makefile         |  1 +
 tools/testing/selftests/vm/Makefile             |  1 +
 10 files changed, 73 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/Makefile b/tools/testing/selftests/Makefile
index 4e511221a0c1..9af1df28bb26 100644
--- a/tools/testing/selftests/Makefile
+++ b/tools/testing/selftests/Makefile
@@ -47,7 +47,40 @@ clean_hotplug:
 		make -C $$TARGET clean; \
 	done;
 
+INSTALL_PATH ?= install
+INSTALL_PATH := $(abspath $(INSTALL_PATH))
+ALL_SCRIPT := $(INSTALL_PATH)/run_kselftest.sh
+
+install:
+ifdef INSTALL_PATH
+	@# Ask all targets to install their files
+	mkdir -p $(INSTALL_PATH)
+	for TARGET in $(TARGETS); do \
+		mkdir -p $(INSTALL_PATH)/$$TARGET ; \
+		make -C $$TARGET INSTALL_PATH=$(INSTALL_PATH)/$$TARGET install; \
+	done;
+
+	@# Ask all targets to emit their test scripts
+	echo "#!/bin/bash" > $(ALL_SCRIPT)
+	echo "cd \$$(dirname \$$0)" >> $(ALL_SCRIPT)
+	echo "ROOT=\$$PWD" >> $(ALL_SCRIPT)
+
+	for TARGET in $(TARGETS); do \
+		echo "echo ; echo Running tests in $$TARGET" >> $(ALL_SCRIPT); \
+		echo "echo ========================================" >> $(ALL_SCRIPT); \
+		echo "cd $$TARGET" >> $(ALL_SCRIPT); \
+		make -s --no-print-directory -C $$TARGET emit_tests >> $(ALL_SCRIPT); \
+		echo "cd \$$ROOT" >> $(ALL_SCRIPT); \
+	done;
+
+	chmod u+x $(ALL_SCRIPT)
+else
+	$(error Error: set INSTALL_PATH to use install)
+endif
+
 clean:
 	for TARGET in $(TARGETS); do \
 		make -C $$TARGET clean; \
 	done;
+
+.PHONY: install
diff --git a/tools/testing/selftests/efivarfs/Makefile b/tools/testing/selftests/efivarfs/Makefile
index 3052d0bda24b..9ff04f154bd5 100644
--- a/tools/testing/selftests/efivarfs/Makefile
+++ b/tools/testing/selftests/efivarfs/Makefile
@@ -6,6 +6,7 @@ test_objs = open-unlink create-read
 all: $(test_objs)
 
 TEST_PROGS := efivarfs.sh
+TEST_FILES := $(test_objs)
 
 include ../lib.mk
 
diff --git a/tools/testing/selftests/exec/Makefile b/tools/testing/selftests/exec/Makefile
index a0098daeb73d..886cabe307b1 100644
--- a/tools/testing/selftests/exec/Makefile
+++ b/tools/testing/selftests/exec/Makefile
@@ -19,8 +19,11 @@ execveat.denatured: execveat
 	$(CC) $(CFLAGS) -o $@ $^
 
 TEST_PROGS := execveat
+TEST_FILES := $(DEPS)
 
 include ../lib.mk
 
+override EMIT_TESTS := echo "mkdir -p subdir; (./execveat && echo \"selftests: execveat [PASS]\") || echo \"selftests: execveat [FAIL]\""
+
 clean:
 	rm -rf $(BINARIES) $(DEPS) subdir.moved execveat.moved xxxxx*
diff --git a/tools/testing/selftests/lib.mk b/tools/testing/selftests/lib.mk
index b30c5a49cb61..7bd3dabe2846 100644
--- a/tools/testing/selftests/lib.mk
+++ b/tools/testing/selftests/lib.mk
@@ -7,4 +7,25 @@ endef
 run_tests: all
 	$(RUN_TESTS)
 
-.PHONY: run_tests all clean
+define INSTALL_RULE
+	mkdir -p $(INSTALL_PATH)
+	install -t $(INSTALL_PATH) $(TEST_PROGS) $(TEST_FILES)
+endef
+
+install: all
+ifdef INSTALL_PATH
+	$(INSTALL_RULE)
+else
+	$(error Error: set INSTALL_PATH to use install)
+endif
+
+define EMIT_TESTS
+	@for TEST in $(TEST_PROGS); do \
+		echo "(./$$TEST && echo \"selftests: $$TEST [PASS]\") || echo \"selftests: $$TEST [FAIL]\""; \
+	done;
+endef
+
+emit_tests:
+	$(EMIT_TESTS)
+
+.PHONY: run_tests all clean install emit_tests
diff --git a/tools/testing/selftests/memory-hotplug/Makefile b/tools/testing/selftests/memory-hotplug/Makefile
index 8f7dea66ecac..598a1f68f534 100644
--- a/tools/testing/selftests/memory-hotplug/Makefile
+++ b/tools/testing/selftests/memory-hotplug/Makefile
@@ -2,7 +2,9 @@ all:
 
 include ../lib.mk
 
+TEST_PROGS := on-off-test.sh
 override RUN_TESTS := ./on-off-test.sh -r 2 || echo "selftests: memory-hotplug [FAIL]"
+override EMIT_TESTS := echo "$(RUN_TESTS)"
 
 run_full_test:
 	@/bin/bash ./on-off-test.sh || echo "memory-hotplug selftests: [FAIL]"
diff --git a/tools/testing/selftests/mount/Makefile b/tools/testing/selftests/mount/Makefile
index 06931dfd3ef0..a5b367f032ba 100644
--- a/tools/testing/selftests/mount/Makefile
+++ b/tools/testing/selftests/mount/Makefile
@@ -7,7 +7,9 @@ unprivileged-remount-test: unprivileged-remount-test.c
 
 include ../lib.mk
 
+TEST_PROGS := unprivileged-remount-test
 override RUN_TESTS := if [ -f /proc/self/uid_map ] ; then ./unprivileged-remount-test ; fi
+override EMIT_TESTS := echo "$(RUN_TESTS)"
 
 clean:
 	rm -f unprivileged-remount-test
diff --git a/tools/testing/selftests/mqueue/Makefile b/tools/testing/selftests/mqueue/Makefile
index cbc300ef11bf..6ca7261b55dc 100644
--- a/tools/testing/selftests/mqueue/Makefile
+++ b/tools/testing/selftests/mqueue/Makefile
@@ -9,5 +9,12 @@ override define RUN_TESTS
 	@./mq_perf_tests || echo "selftests: mq_perf_tests [FAIL]"
 endef
 
+TEST_PROGS := mq_open_tests mq_perf_tests
+
+override define EMIT_TESTS
+	echo "./mq_open_tests /test1 || echo \"selftests: mq_open_tests [FAIL]\""
+	echo "./mq_perf_tests || echo \"selftests: mq_perf_tests [FAIL]\""
+endef
+
 clean:
 	rm -f mq_open_tests mq_perf_tests
diff --git a/tools/testing/selftests/net/Makefile b/tools/testing/selftests/net/Makefile
index fa8187ff15e6..6ba2ac7bbb0d 100644
--- a/tools/testing/selftests/net/Makefile
+++ b/tools/testing/selftests/net/Makefile
@@ -12,6 +12,7 @@ all: $(NET_PROGS)
 	$(CC) $(CFLAGS) -o $@ $^
 
 TEST_PROGS := run_netsocktests run_afpackettests test_bpf.sh
+TEST_FILES := $(NET_PROGS)
 
 include ../lib.mk
 
diff --git a/tools/testing/selftests/sysctl/Makefile b/tools/testing/selftests/sysctl/Makefile
index c9660f5ef9f9..b3c33e071f10 100644
--- a/tools/testing/selftests/sysctl/Makefile
+++ b/tools/testing/selftests/sysctl/Makefile
@@ -5,6 +5,7 @@
 all:
 
 TEST_PROGS := run_numerictests run_stringtests
+TEST_FILES := common_tests
 
 include ../lib.mk
 
diff --git a/tools/testing/selftests/vm/Makefile b/tools/testing/selftests/vm/Makefile
index 90e56090b0ed..1a49761df6ed 100644
--- a/tools/testing/selftests/vm/Makefile
+++ b/tools/testing/selftests/vm/Makefile
@@ -10,6 +10,7 @@ all: $(BINARIES)
 	$(CC) $(CFLAGS) -o $@ $^ -lrt
 
 TEST_PROGS := run_vmtests
+TEST_FILES := $(BINARIES)
 
 include ../lib.mk
 
-- 
2.1.0
