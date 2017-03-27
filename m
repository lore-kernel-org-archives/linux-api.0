From: Bamvor Jian Zhang <bamvor.zhangjian@linaro.org>
Subject: [PATCH 1/2] selftests: fix the broken individual test for x86
Date: Mon, 27 Mar 2017 05:46:00 +0000
Message-ID: <20170327054601.22415-2-bamvor.zhangjian@linaro.org>
References: <20170327054601.22415-1-bamvor.zhangjian@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170327054601.22415-1-bamvor.zhangjian@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: luto@amacapital.net, shuahkh@osg.samsung.com
Cc: mpe@ellerman.id.au, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, khilman@kernel.org, broonie@kernel.org, bamvor.zhangjian@huawei.com, bamvor.zhangjian@linaro.org
List-Id: linux-api@vger.kernel.org

Andy Lutomirski report that build individual testcase in x86 is broken:

$ make -C tools/testing/selftests/x86 ldt_gdt_32
make: Entering directory '/home/luto/apps/linux/tools/testing/selftests/x86'
Makefile:44: warning: overriding recipe for target 'clean'
../lib.mk:55: warning: ignoring old recipe for target 'clean'
make: *** No rule to make target 'ldt_gdt_32'.  Stop.
make: Leaving directory '/home/luto/apps/linux/tools/testing/selftests/x86'

This patch fix this issue by adding default OUTPUT and convert
target in Makefile of x86.

And also mention this use case in Documentation/kselftests.txt

Reported-by: Andy Lutomirski <luto@amacapital.net>
Signed-off-by: Bamvor Jian Zhang <bamvor.zhangjian@linaro.org>
---
 Documentation/kselftest.txt          |  6 ++++++
 tools/testing/selftests/x86/Makefile | 23 ++++++++++++++---------
 2 files changed, 20 insertions(+), 9 deletions(-)

diff --git a/Documentation/kselftest.txt b/Documentation/kselftest.txt
index 5bd5903..3dfca71 100644
--- a/Documentation/kselftest.txt
+++ b/Documentation/kselftest.txt
@@ -43,6 +43,12 @@ See the top-level tools/testing/selftests/Makefile for the list of all
 possible targets.
 
 
+Building individual test case of a subset
+=========================================
+You could build the individual test case in subset if subset supported:
+  $  make -C tools/testing/selftests/x86 ldt_gdt_32
+
+
 Running the full range hotplug selftests
 ========================================
 
diff --git a/tools/testing/selftests/x86/Makefile b/tools/testing/selftests/x86/Makefile
index 38e0a9c..855a2a1 100644
--- a/tools/testing/selftests/x86/Makefile
+++ b/tools/testing/selftests/x86/Makefile
@@ -17,8 +17,8 @@ TARGETS_C_64BIT_ALL := $(TARGETS_C_BOTHBITS) $(TARGETS_C_64BIT_ONLY)
 BINARIES_32 := $(TARGETS_C_32BIT_ALL:%=%_32)
 BINARIES_64 := $(TARGETS_C_64BIT_ALL:%=%_64)
 
-BINARIES_32 := $(patsubst %,$(OUTPUT)/%,$(BINARIES_32))
-BINARIES_64 := $(patsubst %,$(OUTPUT)/%,$(BINARIES_64))
+BINARIES_32_FULL_PATH := $(patsubst %,$(OUTPUT)/%,$(BINARIES_32))
+BINARIES_64_FULL_PATH := $(patsubst %,$(OUTPUT)/%,$(BINARIES_64))
 
 CFLAGS := -O2 -g -std=gnu99 -pthread -Wall
 
@@ -28,25 +28,29 @@ CAN_BUILD_X86_64 := $(shell ./check_cc.sh $(CC) trivial_64bit_program.c)
 
 ifeq ($(CAN_BUILD_I386),1)
 all: all_32
-TEST_PROGS += $(BINARIES_32)
+TEST_PROGS += $(BINARIES_32_FULL_PATH)
 endif
 
 ifeq ($(CAN_BUILD_X86_64),1)
 all: all_64
-TEST_PROGS += $(BINARIES_64)
+TEST_PROGS += $(BINARIES_64_FULL_PATH)
 endif
 
-all_32: $(BINARIES_32)
+all_32: $(BINARIES_32_FULL_PATH)
 
-all_64: $(BINARIES_64)
+all_64: $(BINARIES_64_FULL_PATH)
 
 clean:
-	$(RM) $(BINARIES_32) $(BINARIES_64)
+	$(RM) $(BINARIES_32_FULL_PATH) $(BINARIES_64_FULL_PATH)
 
-$(BINARIES_32): $(OUTPUT)/%_32: %.c
+$(BINARIES_32): %_32: $(OUTPUT)/%_32
+
+$(BINARIES_64): %_64: $(OUTPUT)/%_64
+
+$(BINARIES_32_FULL_PATH): $(OUTPUT)/%_32: %.c
 	$(CC) -m32 -o $@ $(CFLAGS) $(EXTRA_CFLAGS) $^ -lrt -ldl -lm
 
-$(BINARIES_64): $(OUTPUT)/%_64: %.c
+$(BINARIES_64_FULL_PATH): $(OUTPUT)/%_64: %.c
 	$(CC) -m64 -o $@ $(CFLAGS) $(EXTRA_CFLAGS) $^ -lrt -ldl
 
 # x86_64 users should be encouraged to install 32-bit libraries
@@ -77,3 +81,4 @@ $(OUTPUT)/test_syscall_vdso_32: thunks_32.S
 # state.
 $(OUTPUT)/check_initial_reg_state_32: CFLAGS += -Wl,-ereal_start -static
 $(OUTPUT)/check_initial_reg_state_64: CFLAGS += -Wl,-ereal_start -static
+
-- 
1.9.1
