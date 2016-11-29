From: <bamvor.zhangjian-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 6/6] selftests: enable O and KBUILD_OUTPUT
Date: Tue, 29 Nov 2016 19:55:52 +0800
Message-ID: <20161129115552.8148-7-bamvor.zhangjian@huawei.com>
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

Enable O and KBUILD_OUTPUT for kselftest. User could compile kselftest
to another directory by passing O or KBUILD_OUTPUT. And O is high
priority than KBUILD_OUTPUT.

Signed-off-by: Bamvor Jian Zhang <bamvor.zhangjian-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 tools/testing/selftests/Makefile                   | 36 ++++++++++++++++------
 tools/testing/selftests/exec/Makefile              | 13 ++++----
 tools/testing/selftests/ftrace/Makefile            |  2 +-
 tools/testing/selftests/futex/Makefile             | 21 ++++++++++---
 tools/testing/selftests/kcmp/Makefile              |  2 +-
 tools/testing/selftests/lib.mk                     | 19 +++++++++---
 tools/testing/selftests/powerpc/Makefile           | 15 +++++----
 .../testing/selftests/powerpc/benchmarks/Makefile  |  6 ++--
 tools/testing/selftests/powerpc/copyloops/Makefile |  8 ++---
 tools/testing/selftests/powerpc/dscr/Makefile      |  2 +-
 tools/testing/selftests/powerpc/math/Makefile      | 12 ++++----
 tools/testing/selftests/powerpc/mm/Makefile        |  6 ++--
 tools/testing/selftests/powerpc/pmu/Makefile       | 16 +++++-----
 tools/testing/selftests/powerpc/pmu/ebb/Makefile   |  4 +--
 .../selftests/powerpc/switch_endian/Makefile       |  8 ++---
 tools/testing/selftests/powerpc/tm/Makefile        |  6 ++--
 tools/testing/selftests/vm/Makefile                |  4 +--
 tools/testing/selftests/x86/Makefile               | 17 +++++-----
 18 files changed, 122 insertions(+), 75 deletions(-)

diff --git a/tools/testing/selftests/Makefile b/tools/testing/selftests/Makefile
index a3144a3..848af7c 100644
--- a/tools/testing/selftests/Makefile
+++ b/tools/testing/selftests/Makefile
@@ -47,29 +47,44 @@ override LDFLAGS =
 override MAKEFLAGS =
 endif
 
+BUILD := $(O)
+ifndef BUILD
+  BUILD := $(KBUILD_OUTPUT)
+endif
+ifndef BUILD
+  BUILD := $(shell pwd)
+endif
+
+export BUILD
 all:
-	for TARGET in $(TARGETS); do \
-		make -C $$TARGET; \
+	for TARGET in $(TARGETS); do		\
+		BUILD_TARGET=$$BUILD/$$TARGET;	\
+		mkdir $$BUILD_TARGET  -p;	\
+		make OUTPUT=$$BUILD_TARGET -C $$TARGET;\
 	done;
 
 run_tests: all
 	for TARGET in $(TARGETS); do \
-		make -C $$TARGET run_tests; \
+		BUILD_TARGET=$$BUILD/$$TARGET;	\
+		make OUTPUT=$$BUILD_TARGET -C $$TARGET run_tests;\
 	done;
 
 hotplug:
 	for TARGET in $(TARGETS_HOTPLUG); do \
-		make -C $$TARGET; \
+		BUILD_TARGET=$$BUILD/$$TARGET;	\
+		make OUTPUT=$$BUILD_TARGET -C $$TARGET;\
 	done;
 
 run_hotplug: hotplug
 	for TARGET in $(TARGETS_HOTPLUG); do \
-		make -C $$TARGET run_full_test; \
+		BUILD_TARGET=$$BUILD/$$TARGET;	\
+		make OUTPUT=$$BUILD_TARGET -C $$TARGET run_full_test;\
 	done;
 
 clean_hotplug:
 	for TARGET in $(TARGETS_HOTPLUG); do \
-		make -C $$TARGET clean; \
+		BUILD_TARGET=$$BUILD/$$TARGET;	\
+		make OUTPUT=$$BUILD_TARGET -C $$TARGET clean;\
 	done;
 
 run_pstore_crash:
@@ -84,7 +99,8 @@ ifdef INSTALL_PATH
 	@# Ask all targets to install their files
 	mkdir -p $(INSTALL_PATH)
 	for TARGET in $(TARGETS); do \
-		make -C $$TARGET INSTALL_PATH=$(INSTALL_PATH)/$$TARGET install; \
+		BUILD_TARGET=$$BUILD/$$TARGET;	\
+		make OUTPUT=$$BUILD_TARGET -C $$TARGET INSTALL_PATH=$(INSTALL_PATH)/$$TARGET install; \
 	done;
 
 	@# Ask all targets to emit their test scripts
@@ -93,10 +109,11 @@ ifdef INSTALL_PATH
 	echo "ROOT=\$$PWD" >> $(ALL_SCRIPT)
 
 	for TARGET in $(TARGETS); do \
+		BUILD_TARGET=$$BUILD/$$TARGET;	\
 		echo "echo ; echo Running tests in $$TARGET" >> $(ALL_SCRIPT); \
 		echo "echo ========================================" >> $(ALL_SCRIPT); \
 		echo "cd $$TARGET" >> $(ALL_SCRIPT); \
-		make -s --no-print-directory -C $$TARGET emit_tests >> $(ALL_SCRIPT); \
+		make -s --no-print-directory OUTPUT=$$BUILD_TARGET -C $$TARGET emit_tests >> $(ALL_SCRIPT); \
 		echo "cd \$$ROOT" >> $(ALL_SCRIPT); \
 	done;
 
@@ -107,7 +124,8 @@ endif
 
 clean:
 	for TARGET in $(TARGETS); do \
-		make -C $$TARGET clean; \
+		BUILD_TARGET=$$BUILD/$$TARGET;	\
+		make OUTPUT=$$BUILD_TARGET -C $$TARGET clean;\
 	done;
 
 .PHONY: install
diff --git a/tools/testing/selftests/exec/Makefile b/tools/testing/selftests/exec/Makefile
index 48d1f86..2e13035 100644
--- a/tools/testing/selftests/exec/Makefile
+++ b/tools/testing/selftests/exec/Makefile
@@ -5,18 +5,19 @@ TEST_GEN_FILES := execveat.symlink execveat.denatured script subdir
 # Makefile is a run-time dependency, since it's accessed by the execveat test
 TEST_FILES := Makefile
 
-EXTRA_CLEAN := subdir.moved execveat.moved xxxxx*
+EXTRA_CLEAN := $(OUTPUT)/subdir.moved $(OUTPUT)/execveat.moved $(OUTPUT)/xxxxx*
 
 include ../lib.mk
 
-subdir:
+$(OUTPUT)/subdir:
 	mkdir -p $@
-script:
+$(OUTPUT)/script:
 	echo '#!/bin/sh' > $@
 	echo 'exit $$*' >> $@
 	chmod +x $@
-execveat.symlink: execveat
-	ln -s -f $< $@
-execveat.denatured: execveat
+$(OUTPUT)/execveat.symlink: $(OUTPUT)/execveat
+	cd $(OUTPUT) && ln -s -f $(shell basename $<) $(shell basename $@)
+$(OUTPUT)/execveat.denatured: $(OUTPUT)/execveat
 	cp $< $@
 	chmod -x $@
+
diff --git a/tools/testing/selftests/ftrace/Makefile b/tools/testing/selftests/ftrace/Makefile
index 6c64b42..a8a5e21 100644
--- a/tools/testing/selftests/ftrace/Makefile
+++ b/tools/testing/selftests/ftrace/Makefile
@@ -2,6 +2,6 @@ all:
 
 TEST_PROGS := ftracetest
 TEST_FILES := test.d
-EXTRA_CLEAN := logs/*
+EXTRA_CLEAN := $(OUTPUT)/logs/*
 
 include ../lib.mk
diff --git a/tools/testing/selftests/futex/Makefile b/tools/testing/selftests/futex/Makefile
index 6a17529..653c5cd 100644
--- a/tools/testing/selftests/futex/Makefile
+++ b/tools/testing/selftests/futex/Makefile
@@ -3,13 +3,18 @@ SUBDIRS := functional
 TEST_PROGS := run.sh
 
 .PHONY: all clean
-all:
-	for DIR in $(SUBDIRS); do $(MAKE) -C $$DIR $@ ; done
 
 include ../lib.mk
 
+all:
+	for DIR in $(SUBDIRS); do		\
+		BUILD_TARGET=$$OUTPUT/$$DIR;	\
+		mkdir $$BUILD_TARGET  -p;	\
+		make OUTPUT=$$BUILD_TARGET -C $$DIR $@;\
+	done
+
 override define RUN_TESTS
-	./run.sh
+	@if [ `dirname $(OUTPUT)` = $(PWD) ]; then ./run.sh; fi
 endef
 
 override define INSTALL_RULE
@@ -17,7 +22,9 @@ override define INSTALL_RULE
 	install -t $(INSTALL_PATH) $(TEST_PROGS) $(TEST_PROGS_EXTENDED) $(TEST_FILES)
 
 	@for SUBDIR in $(SUBDIRS); do \
-		$(MAKE) -C $$SUBDIR INSTALL_PATH=$(INSTALL_PATH)/$$SUBDIR install; \
+		BUILD_TARGET=$$OUTPUT/$$SUBDIR;	\
+		mkdir $$BUILD_TARGET  -p;	\
+		$(MAKE) OUTPUT=$$BUILD_TARGET -C $$SUBDIR INSTALL_PATH=$(INSTALL_PATH)/$$SUBDIR install; \
 	done;
 endef
 
@@ -26,4 +33,8 @@ override define EMIT_TESTS
 endef
 
 clean:
-	for DIR in $(SUBDIRS); do $(MAKE) -C $$DIR $@ ; done
+	for DIR in $(SUBDIRS); do		\
+		BUILD_TARGET=$$OUTPUT/$$DIR;	\
+		mkdir $$BUILD_TARGET  -p;	\
+		make OUTPUT=$$BUILD_TARGET -C $$DIR $@;\
+	done
diff --git a/tools/testing/selftests/kcmp/Makefile b/tools/testing/selftests/kcmp/Makefile
index 74a8add..47aa988 100644
--- a/tools/testing/selftests/kcmp/Makefile
+++ b/tools/testing/selftests/kcmp/Makefile
@@ -2,7 +2,7 @@ CFLAGS += -I../../../../usr/include/
 
 TEST_GEN_PROGS := kcmp_test
 
-EXTRA_CLEAN := kcmp-test-file
+EXTRA_CLEAN := $(OUTPUT)/kcmp-test-file
 
 include ../lib.mk
 
diff --git a/tools/testing/selftests/lib.mk b/tools/testing/selftests/lib.mk
index 0f7a371..01bb778 100644
--- a/tools/testing/selftests/lib.mk
+++ b/tools/testing/selftests/lib.mk
@@ -4,7 +4,8 @@ CC := $(CROSS_COMPILE)gcc
 
 define RUN_TESTS
 	@for TEST in $(TEST_GEN_PROGS) $(TEST_PROGS); do \
-		(./$$TEST && echo "selftests: $$TEST [PASS]") || echo "selftests: $$TEST [FAIL]"; \
+		BASENAME_TEST=`basename $$TEST`;	\
+		cd `dirname $$TEST`; (./$$BASENAME_TEST && echo "selftests: $$BASENAME_TEST [PASS]") || echo "selftests:  $$BASENAME_TEST [FAIL]"; cd -;\
 	done;
 endef
 
@@ -33,19 +34,29 @@ endif
 
 define EMIT_TESTS
 	@for TEST in $(TEST_GEN_PROGS) $(TEST_PROGS); do \
-		echo "(./$$TEST && echo \"selftests: $$TEST [PASS]\") || echo \"selftests: $$TEST [FAIL]\""; \
+		BASENAME_TEST=`basename $$TEST`;	\
+		echo "(./$$BASENAME_TEST && echo \"selftests: $$BASENAME_TEST [PASS]\") || echo \"selftests: $$BASENAME_TEST [FAIL]\""; \
 	done;
 endef
 
 emit_tests:
 	$(EMIT_TESTS)
 
+TEST_GEN_PROGS := $(patsubst %,$(OUTPUT)/%,$(TEST_GEN_PROGS))
+TEST_GEN_FILES := $(patsubst %,$(OUTPUT)/%,$(TEST_GEN_FILES))
+
 all: $(TEST_GEN_PROGS) $(TEST_GEN_PROGS_EXTENDED) $(TEST_GEN_FILES)
 
 clean:
 	$(RM) -r $(TEST_GEN_PROGS) $(TEST_GEN_PROGS_EXTENDED) $(TEST_GEN_FILES) $(EXTRA_CLEAN)
 
-%: %.c
-	$(CC) $(CFLAGS) $(LDFLAGS) $(LDLIBS) -o $@ $^
+$(OUTPUT)/%:%.c
+	$(CC) $(CFLAGS) $(LDFLAGS) $(LDLIBS) $< -o $@
+
+$(OUTPUT)/%.o:%.S
+	$(CC) $(ASFLAGS) -c $< -o $@
+
+$(OUTPUT)/%:%.S
+	$(CC) $(ASFLAGS) $< -o $@
 
 .PHONY: run_tests all clean install emit_tests
diff --git a/tools/testing/selftests/powerpc/Makefile b/tools/testing/selftests/powerpc/Makefile
index c2c4211..1d48c0c 100644
--- a/tools/testing/selftests/powerpc/Makefile
+++ b/tools/testing/selftests/powerpc/Makefile
@@ -34,32 +34,35 @@ endif
 all: $(SUB_DIRS)
 
 $(SUB_DIRS):
-	$(MAKE) -k -C $@ all
+	BUILD_TARGET=$$OUTPUT/$@; mkdir -p $$BUILD_TARGET; $(MAKE) OUTPUT=$$BUILD_TARGET -k -C $@ all
 
 include ../lib.mk
 
 override define RUN_TESTS
 	@for TARGET in $(SUB_DIRS); do \
-		$(MAKE) -C $$TARGET run_tests; \
+		BUILD_TARGET=$$OUTPUT/$$TARGET;	\
+		$(MAKE) OUTPUT=$$BUILD_TARGET -C $$TARGET run_tests;\
 	done;
 endef
 
 override define INSTALL_RULE
 	@for TARGET in $(SUB_DIRS); do \
-		$(MAKE) -C $$TARGET install; \
+		BUILD_TARGET=$$OUTPUT/$$TARGET;	\
+		$(MAKE) OUTPUT=$$BUILD_TARGET -C $$TARGET install;\
 	done;
 endef
 
 override define EMIT_TESTS
 	@for TARGET in $(SUB_DIRS); do \
-		$(MAKE) -s -C $$TARGET emit_tests; \
+		BUILD_TARGET=$$OUTPUT/$$TARGET;	\
+		$(MAKE) OUTPUT=$$BUILD_TARGET -s -C $$TARGET emit_tests;\
 	done;
 endef
 
 clean:
 	@for TARGET in $(SUB_DIRS); do \
-		$(MAKE) -C $$TARGET clean; \
-	done;
+		BUILD_TARGET=$$OUTPUT/$$TARGET;	\
+		$(MAKE) OUTPUT=$$BUILD_TARGET -C $$TARGET clean;\ done;
 	rm -f tags
 
 tags:
diff --git a/tools/testing/selftests/powerpc/benchmarks/Makefile b/tools/testing/selftests/powerpc/benchmarks/Makefile
index 08a55bd..286c6ed 100644
--- a/tools/testing/selftests/powerpc/benchmarks/Makefile
+++ b/tools/testing/selftests/powerpc/benchmarks/Makefile
@@ -6,6 +6,6 @@ $(TEST_GEN_PROGS): ../harness.c
 
 include ../../lib.mk
 
-context_switch: ../utils.c
-context_switch: CFLAGS += -maltivec -mvsx -mabi=altivec
-context_switch: LDLIBS += -lpthread
+$(OUTPUT)/context_switch: ../utils.c
+$(OUTPUT)/context_switch: CFLAGS += -maltivec -mvsx -mabi=altivec
+$(OUTPUT)/context_switch: LDLIBS += -lpthread
diff --git a/tools/testing/selftests/powerpc/copyloops/Makefile b/tools/testing/selftests/powerpc/copyloops/Makefile
index 9ad1558..681ab19 100644
--- a/tools/testing/selftests/powerpc/copyloops/Makefile
+++ b/tools/testing/selftests/powerpc/copyloops/Makefile
@@ -12,9 +12,9 @@ EXTRA_SOURCES := validate.c ../harness.c
 
 include ../../lib.mk
 
-copyuser_64:     CPPFLAGS += -D COPY_LOOP=test___copy_tofrom_user_base
-copyuser_power7: CPPFLAGS += -D COPY_LOOP=test___copy_tofrom_user_power7
-memcpy_64:       CPPFLAGS += -D COPY_LOOP=test_memcpy
-memcpy_power7:   CPPFLAGS += -D COPY_LOOP=test_memcpy_power7
+$(OUTPUT)/copyuser_64:     CPPFLAGS += -D COPY_LOOP=test___copy_tofrom_user_base
+$(OUTPUT)/copyuser_power7: CPPFLAGS += -D COPY_LOOP=test___copy_tofrom_user_power7
+$(OUTPUT)/memcpy_64:       CPPFLAGS += -D COPY_LOOP=test_memcpy
+$(OUTPUT)/memcpy_power7:   CPPFLAGS += -D COPY_LOOP=test_memcpy_power7
 
 $(TEST_GEN_PROGS): $(EXTRA_SOURCES)
diff --git a/tools/testing/selftests/powerpc/dscr/Makefile b/tools/testing/selftests/powerpc/dscr/Makefile
index 4262de4..c5639de 100644
--- a/tools/testing/selftests/powerpc/dscr/Makefile
+++ b/tools/testing/selftests/powerpc/dscr/Makefile
@@ -4,6 +4,6 @@ TEST_GEN_PROGS := dscr_default_test dscr_explicit_test dscr_user_test	\
 
 include ../../lib.mk
 
-dscr_default_test: LDLIBS += -lpthread
+$(OUTPUT)/dscr_default_test: LDLIBS += -lpthread
 
 $(TEST_GEN_PROGS): ../harness.c
diff --git a/tools/testing/selftests/powerpc/math/Makefile b/tools/testing/selftests/powerpc/math/Makefile
index 814c385..da9f42f 100644
--- a/tools/testing/selftests/powerpc/math/Makefile
+++ b/tools/testing/selftests/powerpc/math/Makefile
@@ -5,13 +5,13 @@ include ../../lib.mk
 $(TEST_GEN_PROGS): ../harness.c
 $(TEST_GEN_PROGS): CFLAGS += -O2 -g -pthread -m64 -maltivec
 
-fpu_syscall: fpu_asm.S
-fpu_preempt: fpu_asm.S
-fpu_signal:  fpu_asm.S
+$(OUTPUT)/pu_syscall: fpu_asm.S
+$(OUTPUT)/pu_preempt: fpu_asm.S
+$(OUTPUT)/pu_signal:  fpu_asm.S
 
-vmx_syscall: vmx_asm.S
-vmx_preempt: vmx_asm.S
-vmx_signal: vmx_asm.S
+$(OUTPUT)/mx_syscall: vmx_asm.S
+$(OUTPUT)/mx_preempt: vmx_asm.S
+$(OUTPUT)/mx_signal: vmx_asm.S
 
 vsx_preempt: CFLAGS += -mvsx
 vsx_preempt: vsx_asm.S
diff --git a/tools/testing/selftests/powerpc/mm/Makefile b/tools/testing/selftests/powerpc/mm/Makefile
index d563378..1cffe54 100644
--- a/tools/testing/selftests/powerpc/mm/Makefile
+++ b/tools/testing/selftests/powerpc/mm/Makefile
@@ -8,8 +8,8 @@ include ../../lib.mk
 
 $(TEST_GEN_PROGS): ../harness.c
 
-prot_sao: ../utils.c
+$(OUTPUT)/prot_sao: ../utils.c
 
-tempfile:
-	dd if=/dev/zero of=tempfile bs=64k count=1
+$(OUTPUT)/tempfile:
+	dd if=/dev/zero of=$@ bs=64k count=1
 
diff --git a/tools/testing/selftests/powerpc/pmu/Makefile b/tools/testing/selftests/powerpc/pmu/Makefile
index ab0f902..097b08a 100644
--- a/tools/testing/selftests/powerpc/pmu/Makefile
+++ b/tools/testing/selftests/powerpc/pmu/Makefile
@@ -11,34 +11,34 @@ all: $(TEST_GEN_PROGS) ebb
 $(TEST_GEN_PROGS): $(EXTRA_SOURCES)
 
 # loop.S can only be built 64-bit
-count_instructions: loop.S count_instructions.c $(EXTRA_SOURCES)
+$(OUTPUT)/count_instructions: loop.S count_instructions.c $(EXTRA_SOURCES)
 	$(CC) $(CFLAGS) -m64 -o $@ $^
 
-per_event_excludes: ../utils.c
+$(OUTPUT)/per_event_excludes: ../utils.c
 
 DEFAULT_RUN_TESTS := $(RUN_TESTS)
 override define RUN_TESTS
 	$(DEFAULT_RUN_TESTS)
-	$(MAKE) -C ebb run_tests
+	TARGET=ebb; BUILD_TARGET=$$OUTPUT/$$TARGET; $(MAKE) OUTPUT=$$BUILD_TARGET -C $$TARGET run_tests
 endef
 
 DEFAULT_EMIT_TESTS := $(EMIT_TESTS)
 override define EMIT_TESTS
 	$(DEFAULT_EMIT_TESTS)
-	$(MAKE) -s -C ebb emit_tests
+	TARGET=ebb; BUILD_TARGET=$$OUTPUT/$$TARGET; $(MAKE) OUTPUT=$$BUILD_TARGET -s -C $$TARGET emit_tests
 endef
 
 DEFAULT_INSTALL_RULE := $(INSTALL_RULE)
 override define INSTALL_RULE
 	$(DEFAULT_INSTALL_RULE)
-	$(MAKE) -C ebb install
+	TARGET=ebb; BUILD_TARGET=$$OUTPUT/$$TARGET; $(MAKE) OUTPUT=$$BUILD_TARGET: -C $$TARGET install
 endef
 
 clean:
-	$(RM) $(TEST_PROGS) loop.o
-	$(MAKE) -C ebb clean
+	$(RM) $(TEST_GEN_PROGS) $(OUTPUT)/loop.o
+	TARGET=ebb; BUILD_TARGET=$$OUTPUT/$$TARGET; $(MAKE) OUTPUT=$$BUILD_TARGET: -C $$TARGET clean
 
 ebb:
-	$(MAKE) -k -C $@ all
+	TARGET=$@; BUILD_TARGET=$$OUTPUT/$$TARGET; mkdir -p $$BUILD_TARGET; $(MAKE) OUTPUT=$$BUILD_TARGET -k -C $$TARGET all
 
 .PHONY: all run_tests clean ebb
diff --git a/tools/testing/selftests/powerpc/pmu/ebb/Makefile b/tools/testing/selftests/powerpc/pmu/ebb/Makefile
index 0bc2bd6..6001fb0 100644
--- a/tools/testing/selftests/powerpc/pmu/ebb/Makefile
+++ b/tools/testing/selftests/powerpc/pmu/ebb/Makefile
@@ -21,6 +21,6 @@ include ../../../lib.mk
 $(TEST_GEN_PROGS): ../../harness.c ../../utils.c ../event.c ../lib.c \
 	       ebb.c ebb_handler.S trace.c busy_loop.S
 
-instruction_count_test: ../loop.S
+$(OUTPUT)/instruction_count_test: ../loop.S
 
-lost_exception_test: ../lib.c
+$(OUTPUT)/lost_exception_test: ../lib.c
diff --git a/tools/testing/selftests/powerpc/switch_endian/Makefile b/tools/testing/selftests/powerpc/switch_endian/Makefile
index dbd05ac..b92c2a1 100644
--- a/tools/testing/selftests/powerpc/switch_endian/Makefile
+++ b/tools/testing/selftests/powerpc/switch_endian/Makefile
@@ -2,14 +2,14 @@ TEST_GEN_PROGS := switch_endian_test
 
 ASFLAGS += -O2 -Wall -g -nostdlib -m64
 
-EXTRA_CLEAN = *.o check-reversed.S
+EXTRA_CLEAN = $(OUTPUT)/*.o $(OUTPUT)/check-reversed.S
 
 include ../../lib.mk
 
-switch_endian_test: check-reversed.S
+$(OUTPUT)/switch_endian_test: $(OUTPUT)/check-reversed.S
 
-check-reversed.o: check.o
+$(OUTPUT)/check-reversed.o: $(OUTPUT)/check.o
 	$(CROSS_COMPILE)objcopy -j .text --reverse-bytes=4 -O binary $< $@
 
-check-reversed.S: check-reversed.o
+$(OUTPUT)/check-reversed.S: $(OUTPUT)/check-reversed.o
 	hexdump -v -e '/1 ".byte 0x%02X\n"' $< > $@
diff --git a/tools/testing/selftests/powerpc/tm/Makefile b/tools/testing/selftests/powerpc/tm/Makefile
index 117c624..07da217 100644
--- a/tools/testing/selftests/powerpc/tm/Makefile
+++ b/tools/testing/selftests/powerpc/tm/Makefile
@@ -10,9 +10,9 @@ $(TEST_GEN_PROGS): ../harness.c ../utils.c
 
 CFLAGS += -mhtm
 
-tm-syscall: tm-syscall-asm.S
-tm-syscall: CFLAGS += -I../../../../../usr/include
-tm-tmspr: CFLAGS += -pthread
+$(OUTPUT)/tm-syscall: tm-syscall-asm.S
+$(OUTPUT)/tm-syscall: CFLAGS += -I../../../../../usr/include
+$(OUTPUT)/tm-tmspr: CFLAGS += -pthread
 
 $(SIGNAL_CONTEXT_CHK_TESTS): tm-signal.S
 $(SIGNAL_CONTEXT_CHK_TESTS): CFLAGS += -mhtm -m64 -mvsx
diff --git a/tools/testing/selftests/vm/Makefile b/tools/testing/selftests/vm/Makefile
index 8141d51..983140e 100644
--- a/tools/testing/selftests/vm/Makefile
+++ b/tools/testing/selftests/vm/Makefile
@@ -17,8 +17,8 @@ TEST_PROGS := run_vmtests
 
 include ../lib.mk
 
-userfaultfd: LDLIBS += -lpthread ../../../../usr/include/linux/kernel.h
-mlock-random-test: LDLIBS += -lcap
+$(OUTPUT)/userfaultfd: LDLIBS += -lpthread ../../../../usr/include/linux/kernel.h
+$(OUTPUT)/mlock-random-test: LDLIBS += -lcap
 
 ../../../../usr/include/linux/kernel.h:
 	make -C ../../../.. headers_install
diff --git a/tools/testing/selftests/x86/Makefile b/tools/testing/selftests/x86/Makefile
index 8c1cb42..f251cf9 100644
--- a/tools/testing/selftests/x86/Makefile
+++ b/tools/testing/selftests/x86/Makefile
@@ -17,6 +17,9 @@ TARGETS_C_64BIT_ALL := $(TARGETS_C_BOTHBITS) $(TARGETS_C_64BIT_ONLY)
 BINARIES_32 := $(TARGETS_C_32BIT_ALL:%=%_32)
 BINARIES_64 := $(TARGETS_C_64BIT_ALL:%=%_64)
 
+BINARIES_32 := $(patsubst %,$(OUTPUT)/%,$(BINARIES_32))
+BINARIES_64 := $(patsubst %,$(OUTPUT)/%,$(BINARIES_64))
+
 CFLAGS := -O2 -g -std=gnu99 -pthread -Wall
 
 UNAME_M := $(shell uname -m)
@@ -40,10 +43,10 @@ all_64: $(BINARIES_64)
 clean:
 	$(RM) $(BINARIES_32) $(BINARIES_64)
 
-$(TARGETS_C_32BIT_ALL:%=%_32): %_32: %.c
+$(BINARIES_32): $(OUTPUT)/%_32: %.c
 	$(CC) -m32 -o $@ $(CFLAGS) $(EXTRA_CFLAGS) $^ -lrt -ldl -lm
 
-$(TARGETS_C_64BIT_ALL:%=%_64): %_64: %.c
+$(BINARIES_64): $(OUTPUT)/%_64: %.c
 	$(CC) -m64 -o $@ $(CFLAGS) $(EXTRA_CFLAGS) $^ -lrt -ldl
 
 # x86_64 users should be encouraged to install 32-bit libraries
@@ -65,12 +68,12 @@ warn_32bit_failure:
 endif
 
 # Some tests have additional dependencies.
-sysret_ss_attrs_64: thunks.S
-ptrace_syscall_32: raw_syscall_helper_32.S
-test_syscall_vdso_32: thunks_32.S
+$(OUTPUT)/sysret_ss_attrs_64: thunks.S
+$(OUTPUT)/ptrace_syscall_32: raw_syscall_helper_32.S
+$(OUTPUT)/test_syscall_vdso_32: thunks_32.S
 
 # check_initial_reg_state is special: it needs a custom entry, and it
 # needs to be static so that its interpreter doesn't destroy its initial
 # state.
-check_initial_reg_state_32: CFLAGS += -Wl,-ereal_start -static
-check_initial_reg_state_64: CFLAGS += -Wl,-ereal_start -static
+$(OUTPUT)/check_initial_reg_state_32: CFLAGS += -Wl,-ereal_start -static
+$(OUTPUT)/check_initial_reg_state_64: CFLAGS += -Wl,-ereal_start -static
-- 
2.10.0
