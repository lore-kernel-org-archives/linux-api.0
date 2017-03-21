From: Bamvor Zhang Jian <bamvor.zhangjian@linaro.org>
Subject: Re: [PATCH v2 6/6] selftests: enable O and KBUILD_OUTPUT
Date: Tue, 21 Mar 2017 17:09:05 +0100
Message-ID: <CAFy1USRjGvF3iwWa8k54fFzcMaMcN3VCQ1qMpZ3RSqZvT17Atw@mail.gmail.com>
References: <20161129115552.8148-1-bamvor.zhangjian@huawei.com>
 <20161129115552.8148-7-bamvor.zhangjian@huawei.com> <CALCETrUCbGC5tmzKzYn0qE5w8omk6ZRDj4p9qz5-Ho92+W5McA@mail.gmail.com>
 <87fui7owls.fsf@concordia.ellerman.id.au> <CAFy1USRoKJ7G9ewLGBa1yy9V5UA+g=jo7O+eU1wV_rjKDYtJWg@mail.gmail.com>
 <5daf0b79-a000-2adb-0b1e-f528d66ff6df@osg.samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <5daf0b79-a000-2adb-0b1e-f528d66ff6df@osg.samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Shuah Khan <shuahkh@osg.samsung.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>, Andy Lutomirski <luto@amacapital.net>, "Zhangjian (Bamvor)" <bamvor.zhangjian@huawei.com>, Linux API <linux-api@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Kevin Hilman <khilman@kernel.org>, Mark Brown <broonie@kernel.org>
List-Id: linux-api@vger.kernel.org

Hi, Shuah

On 21 March 2017 at 21:54, Shuah Khan <shuahkh@osg.samsung.com> wrote:
> On 03/21/2017 03:00 AM, Bamvor Zhang Jian wrote:
>> Hi,
>>
>> On 21 March 2017 at 16:35, Michael Ellerman <mpe@ellerman.id.au> wrote:
>>> Andy Lutomirski <luto@amacapital.net> writes:
>>>
>>>> On Tue, Nov 29, 2016 at 3:55 AM,  <bamvor.zhangjian@huawei.com> wrote:
>>>>> From: Bamvor Jian Zhang <bamvor.zhangjian@linaro.org>
>>>>>
>>>>> Enable O and KBUILD_OUTPUT for kselftest. User could compile kselftest
>>>>> to another directory by passing O or KBUILD_OUTPUT. And O is high
>>>>> priority than KBUILD_OUTPUT.
>>>>
>>>> Sorry for noticing this late, but this patch
>>>> (a8ba798bc8ec663cf02e80b0dd770324de9bafd9) is really annoying for
>>>> people who *don't* use these fancy options:
>>>
>>> Yeah sorry, it wasn't quite ready to go in.
>
> Bamovar,
>
> Please give me heads up and ask me to not commit the patch,
> if you think it isn't ready.
>
>>>
>>>> $ make -C tools/testing/selftests/x86 ldt_gdt_32
>>>> make: Entering directory '/home/luto/apps/linux/tools/testing/selftests/x86'
>>>> Makefile:44: warning: overriding recipe for target 'clean'
>>>> ../lib.mk:55: warning: ignoring old recipe for target 'clean'
>>>> make: *** No rule to make target 'ldt_gdt_32'.  Stop.
>>>> make: Leaving directory '/home/luto/apps/linux/tools/testing/selftests/x86'
>>>>
>>>> Is there any way that you can make this work again?
>>>
>>> There obviously is *a* way, but I'm not sure there's a simple and
>>> obviously correct way that is an easy fix for 4.11.
>>>
>>> I see at least 18 Makefile's in tools/testing/selftests that use
>>> $(OUTPUT)/, which would all need to be updated at least to use $(OUTPUT)
>>> (no trailing slash), and then some other changes to not propagate OUTPUT
>>> when the user didn't specify it. But hopefully someone will prove me
>>> wrong.
>> I also look at this issue. Originally, I use OUTPUT without slash in my
>> patch. People argue that it is not very clear. So, I add slash in curent
>> version.
>>>
>>> As a (poor) alternative you can do:
>>>
>>>  $ cd tools/testing/selftests/x86; make $PWD/ldt_gdt_32
>>>
>>> or just:
>>>
>>>  $ make -C tools/testing/selftests/x86
>>>
>>> cheers
>> Do we really need "make -C tools/testing/selftests/x86 ldt_gdt_32"?
>> It is useful but it will skip the top level Makefile of selftests.
>
> Being able to build individual tests is an important use-case. Please
> see kselftest.txt under Documentation directory for all the use-cases
> and new patches shouldn't break these use-cases.
Understand. I am sorry I do not know this use case before. And I read
kselftest.txt again, I do not find this use case is mentioned. So,
I add a few lines in kselftest.txt to avoid break this use case in future.
Is there any other use cases I should test?
>
> Breaking these use-cases is a regression and we have to fix it
Here is a fix. I could build individual test case in x86 and build the whole
x86 test cases successful respectively. And I do a quick test for all the
subsets. Please review the patch if it is make sense to you and Michael.
At the same time, I am buildind and testing all the testcases.

Michael: could you please do me a favor to test the powerpc part? Thanks.

>From 21b17710d23783c5148303e5628b52d281e6f62b Mon Sep 17 00:00:00 2001
From: Bamvor Jian Zhang <bamvor.zhangjian@linaro.org>
Date: Tue, 21 Mar 2017 22:38:01 +0800
Subject: [PATCH] selftests: fix the broken individual test for x86

Andy Lutomirski report that build individual testcase in x86 is broken:

$ make -C tools/testing/selftests/x86 ldt_gdt_32
make: Entering directory '/home/luto/apps/linux/tools/testing/selftests/x86'
Makefile:44: warning: overriding recipe for target 'clean'
../lib.mk:55: warning: ignoring old recipe for target 'clean'
make: *** No rule to make target 'ldt_gdt_32'.  Stop.
make: Leaving directory '/home/luto/apps/linux/tools/testing/selftests/x86'

This patch fix this issue by removing the slash after OUTPUT.
And also mention this use case in Documentation/kselftests.txt

Reported-by: Andy Lutomirski <luto@amacapital.net>
Suggested-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Bamvor Jian Zhang <bamvor.zhangjian@linaro.org>
---
 Documentation/kselftest.txt                            |  5 +++++
 tools/testing/selftests/Makefile                       | 16 ++++++++--------
 tools/testing/selftests/exec/Makefile                  | 10 +++++-----
 tools/testing/selftests/ftrace/Makefile                |  2 +-
 tools/testing/selftests/futex/Makefile                 | 12 ++++++------
 tools/testing/selftests/kcmp/Makefile                  |  2 +-
 tools/testing/selftests/lib.mk                         | 10 +++++-----
 tools/testing/selftests/powerpc/Makefile               | 18 +++++++++---------
 tools/testing/selftests/powerpc/benchmarks/Makefile    |  6 +++---
 tools/testing/selftests/powerpc/copyloops/Makefile     |  8 ++++----
 tools/testing/selftests/powerpc/dscr/Makefile          |  2 +-
 tools/testing/selftests/powerpc/math/Makefile          | 16 ++++++++--------
 tools/testing/selftests/powerpc/mm/Makefile            |  4 ++--
 tools/testing/selftests/powerpc/pmu/Makefile           | 16 ++++++++--------
 tools/testing/selftests/powerpc/pmu/ebb/Makefile       |  4 ++--
 tools/testing/selftests/powerpc/switch_endian/Makefile |  8 ++++----
 tools/testing/selftests/powerpc/tm/Makefile            |  8 ++++----
 tools/testing/selftests/vm/Makefile                    |  8 ++++----
 tools/testing/selftests/x86/Makefile                   | 18 +++++++++---------
 19 files changed, 89 insertions(+), 84 deletions(-)

diff --git a/Documentation/kselftest.txt b/Documentation/kselftest.txt
index 5bd5903..6197e94 100644
--- a/Documentation/kselftest.txt
+++ b/Documentation/kselftest.txt
@@ -42,6 +42,11 @@ You can specify multiple tests to build and run:
 See the top-level tools/testing/selftests/Makefile for the list of all
 possible targets.

+Building individual test case of a subset
+=========================================
+You could build the individual test case in subset if subset supported:
+  $  make -C tools/testing/selftests/x86 ldt_gdt_32
+

 Running the full range hotplug selftests
 ========================================
diff --git a/tools/testing/selftests/Makefile b/tools/testing/selftests/Makefile
index e8b79a7..6cc93c1 100644
--- a/tools/testing/selftests/Makefile
+++ b/tools/testing/selftests/Makefile
@@ -64,31 +64,31 @@ all:
  for TARGET in $(TARGETS); do \
  BUILD_TARGET=$$BUILD/$$TARGET; \
  mkdir $$BUILD_TARGET  -p; \
- make OUTPUT=$$BUILD_TARGET -C $$TARGET;\
+ make OUTPUT=$$BUILD_TARGET/ -C $$TARGET;\
  done;

 run_tests: all
  for TARGET in $(TARGETS); do \
  BUILD_TARGET=$$BUILD/$$TARGET; \
- make OUTPUT=$$BUILD_TARGET -C $$TARGET run_tests;\
+ make OUTPUT=$$BUILD_TARGET/ -C $$TARGET run_tests;\
  done;

 hotplug:
  for TARGET in $(TARGETS_HOTPLUG); do \
  BUILD_TARGET=$$BUILD/$$TARGET; \
- make OUTPUT=$$BUILD_TARGET -C $$TARGET;\
+ make OUTPUT=$$BUILD_TARGET/ -C $$TARGET;\
  done;

 run_hotplug: hotplug
  for TARGET in $(TARGETS_HOTPLUG); do \
  BUILD_TARGET=$$BUILD/$$TARGET; \
- make OUTPUT=$$BUILD_TARGET -C $$TARGET run_full_test;\
+ make OUTPUT=$$BUILD_TARGET/ -C $$TARGET run_full_test;\
  done;

 clean_hotplug:
  for TARGET in $(TARGETS_HOTPLUG); do \
  BUILD_TARGET=$$BUILD/$$TARGET; \
- make OUTPUT=$$BUILD_TARGET -C $$TARGET clean;\
+ make OUTPUT=$$BUILD_TARGET/ -C $$TARGET clean;\
  done;

 run_pstore_crash:
@@ -104,7 +104,7 @@ ifdef INSTALL_PATH
  mkdir -p $(INSTALL_PATH)
  for TARGET in $(TARGETS); do \
  BUILD_TARGET=$$BUILD/$$TARGET; \
- make OUTPUT=$$BUILD_TARGET -C $$TARGET
INSTALL_PATH=$(INSTALL_PATH)/$$TARGET install; \
+ make OUTPUT=$$BUILD_TARGET/ -C $$TARGET
INSTALL_PATH=$(INSTALL_PATH)/$$TARGET install; \
  done;

  @# Ask all targets to emit their test scripts
@@ -117,7 +117,7 @@ ifdef INSTALL_PATH
  echo "echo ; echo Running tests in $$TARGET" >> $(ALL_SCRIPT); \
  echo "echo ========================================" >> $(ALL_SCRIPT); \
  echo "cd $$TARGET" >> $(ALL_SCRIPT); \
- make -s --no-print-directory OUTPUT=$$BUILD_TARGET -C $$TARGET
emit_tests >> $(ALL_SCRIPT); \
+ make -s --no-print-directory OUTPUT=$$BUILD_TARGET/ -C $$TARGET
emit_tests >> $(ALL_SCRIPT); \
  echo "cd \$$ROOT" >> $(ALL_SCRIPT); \
  done;

@@ -129,7 +129,7 @@ endif
 clean:
  for TARGET in $(TARGETS); do \
  BUILD_TARGET=$$BUILD/$$TARGET; \
- make OUTPUT=$$BUILD_TARGET -C $$TARGET clean;\
+ make OUTPUT=$$BUILD_TARGET/ -C $$TARGET clean;\
  done;

 .PHONY: install
diff --git a/tools/testing/selftests/exec/Makefile
b/tools/testing/selftests/exec/Makefile
index 2e13035..2f3b200 100644
--- a/tools/testing/selftests/exec/Makefile
+++ b/tools/testing/selftests/exec/Makefile
@@ -5,19 +5,19 @@ TEST_GEN_FILES := execveat.symlink
execveat.denatured script subdir
 # Makefile is a run-time dependency, since it's accessed by the execveat test
 TEST_FILES := Makefile

-EXTRA_CLEAN := $(OUTPUT)/subdir.moved $(OUTPUT)/execveat.moved $(OUTPUT)/xxxxx*
+EXTRA_CLEAN := $(OUTPUT)subdir.moved $(OUTPUT)execveat.moved $(OUTPUT)xxxxx*

 include ../lib.mk

-$(OUTPUT)/subdir:
+$(OUTPUT)subdir:
  mkdir -p $@
-$(OUTPUT)/script:
+$(OUTPUT)script:
  echo '#!/bin/sh' > $@
  echo 'exit $$*' >> $@
  chmod +x $@
-$(OUTPUT)/execveat.symlink: $(OUTPUT)/execveat
+$(OUTPUT)execveat.symlink: $(OUTPUT)execveat
  cd $(OUTPUT) && ln -s -f $(shell basename $<) $(shell basename $@)
-$(OUTPUT)/execveat.denatured: $(OUTPUT)/execveat
+$(OUTPUT)execveat.denatured: $(OUTPUT)execveat
  cp $< $@
  chmod -x $@

diff --git a/tools/testing/selftests/ftrace/Makefile
b/tools/testing/selftests/ftrace/Makefile
index a8a5e21..33bb29b 100644
--- a/tools/testing/selftests/ftrace/Makefile
+++ b/tools/testing/selftests/ftrace/Makefile
@@ -2,6 +2,6 @@ all:

 TEST_PROGS := ftracetest
 TEST_FILES := test.d
-EXTRA_CLEAN := $(OUTPUT)/logs/*
+EXTRA_CLEAN := $(OUTPUT)logs/*

 include ../lib.mk
diff --git a/tools/testing/selftests/futex/Makefile
b/tools/testing/selftests/futex/Makefile
index 653c5cd..11c6c49 100644
--- a/tools/testing/selftests/futex/Makefile
+++ b/tools/testing/selftests/futex/Makefile
@@ -8,9 +8,9 @@ include ../lib.mk

 all:
  for DIR in $(SUBDIRS); do \
- BUILD_TARGET=$$OUTPUT/$$DIR; \
+ BUILD_TARGET=$$OUTPUT$$DIR; \
  mkdir $$BUILD_TARGET  -p; \
- make OUTPUT=$$BUILD_TARGET -C $$DIR $@;\
+ make OUTPUT=$$BUILD_TARGET/ -C $$DIR $@;\
  done

 override define RUN_TESTS
@@ -22,9 +22,9 @@ override define INSTALL_RULE
  install -t $(INSTALL_PATH) $(TEST_PROGS) $(TEST_PROGS_EXTENDED) $(TEST_FILES)

  @for SUBDIR in $(SUBDIRS); do \
- BUILD_TARGET=$$OUTPUT/$$SUBDIR; \
+ BUILD_TARGET=$$OUTPUT$$SUBDIR; \
  mkdir $$BUILD_TARGET  -p; \
- $(MAKE) OUTPUT=$$BUILD_TARGET -C $$SUBDIR
INSTALL_PATH=$(INSTALL_PATH)/$$SUBDIR install; \
+ $(MAKE) OUTPUT=$$BUILD_TARGET/ -C $$SUBDIR
INSTALL_PATH=$(INSTALL_PATH)/$$SUBDIR install; \
  done;
 endef

@@ -34,7 +34,7 @@ endef

 clean:
  for DIR in $(SUBDIRS); do \
- BUILD_TARGET=$$OUTPUT/$$DIR; \
+ BUILD_TARGET=$$OUTPUT$$DIR; \
  mkdir $$BUILD_TARGET  -p; \
- make OUTPUT=$$BUILD_TARGET -C $$DIR $@;\
+ make OUTPUT=$$BUILD_TARGET/ -C $$DIR $@;\
  done
diff --git a/tools/testing/selftests/kcmp/Makefile
b/tools/testing/selftests/kcmp/Makefile
index 47aa988..0fb599e 100644
--- a/tools/testing/selftests/kcmp/Makefile
+++ b/tools/testing/selftests/kcmp/Makefile
@@ -2,7 +2,7 @@ CFLAGS += -I../../../../usr/include/

 TEST_GEN_PROGS := kcmp_test

-EXTRA_CLEAN := $(OUTPUT)/kcmp-test-file
+EXTRA_CLEAN := $(OUTPUT)kcmp-test-file

 include ../lib.mk

diff --git a/tools/testing/selftests/lib.mk b/tools/testing/selftests/lib.mk
index ce96d80..716e920 100644
--- a/tools/testing/selftests/lib.mk
+++ b/tools/testing/selftests/lib.mk
@@ -2,8 +2,8 @@
 # Makefile can operate with or without the kbuild infrastructure.
 CC := $(CROSS_COMPILE)gcc

-TEST_GEN_PROGS := $(patsubst %,$(OUTPUT)/%,$(TEST_GEN_PROGS))
-TEST_GEN_FILES := $(patsubst %,$(OUTPUT)/%,$(TEST_GEN_FILES))
+TEST_GEN_PROGS := $(patsubst %,$(OUTPUT)%,$(TEST_GEN_PROGS))
+TEST_GEN_FILES := $(patsubst %,$(OUTPUT)%,$(TEST_GEN_FILES))

 all: $(TEST_GEN_PROGS) $(TEST_GEN_PROGS_EXTENDED) $(TEST_GEN_FILES)

@@ -50,13 +50,13 @@ emit_tests:
 clean:
  $(RM) -r $(TEST_GEN_PROGS) $(TEST_GEN_PROGS_EXTENDED)
$(TEST_GEN_FILES) $(EXTRA_CLEAN)

-$(OUTPUT)/%:%.c
+$(OUTPUT)%:%.c
  $(LINK.c) $^ $(LDLIBS) -o $@

-$(OUTPUT)/%.o:%.S
+$(OUTPUT)%.o:%.S
  $(COMPILE.S) $^ -o $@

-$(OUTPUT)/%:%.S
+$(OUTPUT)%:%.S
  $(LINK.S) $^ $(LDLIBS) -o $@

 .PHONY: run_tests all clean install emit_tests
diff --git a/tools/testing/selftests/powerpc/Makefile
b/tools/testing/selftests/powerpc/Makefile
index 1c5d057..1a1a33c 100644
--- a/tools/testing/selftests/powerpc/Makefile
+++ b/tools/testing/selftests/powerpc/Makefile
@@ -34,35 +34,35 @@ endif
 all: $(SUB_DIRS)

 $(SUB_DIRS):
- BUILD_TARGET=$$OUTPUT/$@; mkdir -p $$BUILD_TARGET; $(MAKE)
OUTPUT=$$BUILD_TARGET -k -C $@ all
+ BUILD_TARGET=$$OUTPUT$@; mkdir -p $$BUILD_TARGET; $(MAKE)
OUTPUT=$$BUILD_TARGET/ -k -C $@ all

 include ../lib.mk

 override define RUN_TESTS
  @for TARGET in $(SUB_DIRS); do \
- BUILD_TARGET=$$OUTPUT/$$TARGET; \
- $(MAKE) OUTPUT=$$BUILD_TARGET -C $$TARGET run_tests;\
+ BUILD_TARGET=$$OUTPUT$$TARGET; \
+ $(MAKE) OUTPUT=$$BUILD_TARGET/ -C $$TARGET run_tests;\
  done;
 endef

 override define INSTALL_RULE
  @for TARGET in $(SUB_DIRS); do \
- BUILD_TARGET=$$OUTPUT/$$TARGET; \
- $(MAKE) OUTPUT=$$BUILD_TARGET -C $$TARGET install;\
+ BUILD_TARGET=$$OUTPUT$$TARGET; \
+ $(MAKE) OUTPUT=$$BUILD_TARGET/ -C $$TARGET install;\
  done;
 endef

 override define EMIT_TESTS
  @for TARGET in $(SUB_DIRS); do \
- BUILD_TARGET=$$OUTPUT/$$TARGET; \
- $(MAKE) OUTPUT=$$BUILD_TARGET -s -C $$TARGET emit_tests;\
+ BUILD_TARGET=$$OUTPUT$$TARGET; \
+ $(MAKE) OUTPUT=$$BUILD_TARGET/ -s -C $$TARGET emit_tests;\
  done;
 endef

 clean:
  @for TARGET in $(SUB_DIRS); do \
- BUILD_TARGET=$$OUTPUT/$$TARGET; \
- $(MAKE) OUTPUT=$$BUILD_TARGET -C $$TARGET clean; \
+ BUILD_TARGET=$$OUTPUT$$TARGET; \
+ $(MAKE) OUTPUT=$$BUILD_TARGET/ -C $$TARGET clean; \
  done;
  rm -f tags

diff --git a/tools/testing/selftests/powerpc/benchmarks/Makefile
b/tools/testing/selftests/powerpc/benchmarks/Makefile
index fb96a89..c720780 100644
--- a/tools/testing/selftests/powerpc/benchmarks/Makefile
+++ b/tools/testing/selftests/powerpc/benchmarks/Makefile
@@ -6,6 +6,6 @@ include ../../lib.mk

 $(TEST_GEN_PROGS): ../harness.c

-$(OUTPUT)/context_switch: ../utils.c
-$(OUTPUT)/context_switch: CFLAGS += -maltivec -mvsx -mabi=altivec
-$(OUTPUT)/context_switch: LDLIBS += -lpthread
+$(OUTPUT)context_switch: ../utils.c
+$(OUTPUT)context_switch: CFLAGS += -maltivec -mvsx -mabi=altivec
+$(OUTPUT)context_switch: LDLIBS += -lpthread
diff --git a/tools/testing/selftests/powerpc/copyloops/Makefile
b/tools/testing/selftests/powerpc/copyloops/Makefile
index 681ab19..60e195a 100644
--- a/tools/testing/selftests/powerpc/copyloops/Makefile
+++ b/tools/testing/selftests/powerpc/copyloops/Makefile
@@ -12,9 +12,9 @@ EXTRA_SOURCES := validate.c ../harness.c

 include ../../lib.mk

-$(OUTPUT)/copyuser_64:     CPPFLAGS += -D
COPY_LOOP=test___copy_tofrom_user_base
-$(OUTPUT)/copyuser_power7: CPPFLAGS += -D
COPY_LOOP=test___copy_tofrom_user_power7
-$(OUTPUT)/memcpy_64:       CPPFLAGS += -D COPY_LOOP=test_memcpy
-$(OUTPUT)/memcpy_power7:   CPPFLAGS += -D COPY_LOOP=test_memcpy_power7
+$(OUTPUT)copyuser_64:     CPPFLAGS += -D COPY_LOOP=test___copy_tofrom_user_base
+$(OUTPUT)copyuser_power7: CPPFLAGS += -D
COPY_LOOP=test___copy_tofrom_user_power7
+$(OUTPUT)memcpy_64:       CPPFLAGS += -D COPY_LOOP=test_memcpy
+$(OUTPUT)memcpy_power7:   CPPFLAGS += -D COPY_LOOP=test_memcpy_power7

 $(TEST_GEN_PROGS): $(EXTRA_SOURCES)
diff --git a/tools/testing/selftests/powerpc/dscr/Makefile
b/tools/testing/selftests/powerpc/dscr/Makefile
index c5639de..378f825 100644
--- a/tools/testing/selftests/powerpc/dscr/Makefile
+++ b/tools/testing/selftests/powerpc/dscr/Makefile
@@ -4,6 +4,6 @@ TEST_GEN_PROGS := dscr_default_test dscr_explicit_test
dscr_user_test \

 include ../../lib.mk

-$(OUTPUT)/dscr_default_test: LDLIBS += -lpthread
+$(OUTPUT)dscr_default_test: LDLIBS += -lpthread

 $(TEST_GEN_PROGS): ../harness.c
diff --git a/tools/testing/selftests/powerpc/math/Makefile
b/tools/testing/selftests/powerpc/math/Makefile
index fa8bae9..73d6f52 100644
--- a/tools/testing/selftests/powerpc/math/Makefile
+++ b/tools/testing/selftests/powerpc/math/Makefile
@@ -5,13 +5,13 @@ include ../../lib.mk
 $(TEST_GEN_PROGS): ../harness.c
 $(TEST_GEN_PROGS): CFLAGS += -O2 -g -pthread -m64 -maltivec

-$(OUTPUT)/fpu_syscall: fpu_asm.S
-$(OUTPUT)/fpu_preempt: fpu_asm.S
-$(OUTPUT)/fpu_signal:  fpu_asm.S
+$(OUTPUT)fpu_syscall: fpu_asm.S
+$(OUTPUT)fpu_preempt: fpu_asm.S
+$(OUTPUT)fpu_signal:  fpu_asm.S

-$(OUTPUT)/vmx_syscall: vmx_asm.S
-$(OUTPUT)/vmx_preempt: vmx_asm.S
-$(OUTPUT)/vmx_signal: vmx_asm.S
+$(OUTPUT)vmx_syscall: vmx_asm.S
+$(OUTPUT)vmx_preempt: vmx_asm.S
+$(OUTPUT)vmx_signal: vmx_asm.S

-$(OUTPUT)/vsx_preempt: CFLAGS += -mvsx
-$(OUTPUT)/vsx_preempt: vsx_asm.S
+$(OUTPUT)vsx_preempt: CFLAGS += -mvsx
+$(OUTPUT)vsx_preempt: vsx_asm.S
diff --git a/tools/testing/selftests/powerpc/mm/Makefile
b/tools/testing/selftests/powerpc/mm/Makefile
index 1cffe54..d4d2e68 100644
--- a/tools/testing/selftests/powerpc/mm/Makefile
+++ b/tools/testing/selftests/powerpc/mm/Makefile
@@ -8,8 +8,8 @@ include ../../lib.mk

 $(TEST_GEN_PROGS): ../harness.c

-$(OUTPUT)/prot_sao: ../utils.c
+$(OUTPUT)prot_sao: ../utils.c

-$(OUTPUT)/tempfile:
+$(OUTPUT)tempfile:
  dd if=/dev/zero of=$@ bs=64k count=1

diff --git a/tools/testing/selftests/powerpc/pmu/Makefile
b/tools/testing/selftests/powerpc/pmu/Makefile
index e4e55d1..17a9be7 100644
--- a/tools/testing/selftests/powerpc/pmu/Makefile
+++ b/tools/testing/selftests/powerpc/pmu/Makefile
@@ -11,34 +11,34 @@ all: $(TEST_GEN_PROGS) ebb
 $(TEST_GEN_PROGS): $(EXTRA_SOURCES)

 # loop.S can only be built 64-bit
-$(OUTPUT)/count_instructions: loop.S count_instructions.c $(EXTRA_SOURCES)
+$(OUTPUT)count_instructions: loop.S count_instructions.c $(EXTRA_SOURCES)
  $(CC) $(CFLAGS) -m64 -o $@ $^

-$(OUTPUT)/per_event_excludes: ../utils.c
+$(OUTPUT)per_event_excludes: ../utils.c

 DEFAULT_RUN_TESTS := $(RUN_TESTS)
 override define RUN_TESTS
  $(DEFAULT_RUN_TESTS)
- TARGET=ebb; BUILD_TARGET=$$OUTPUT/$$TARGET; $(MAKE)
OUTPUT=$$BUILD_TARGET -C $$TARGET run_tests
+ TARGET=ebb; BUILD_TARGET=$$OUTPUT$$TARGET; $(MAKE)
OUTPUT=$$BUILD_TARGET/ -C $$TARGET run_tests
 endef

 DEFAULT_EMIT_TESTS := $(EMIT_TESTS)
 override define EMIT_TESTS
  $(DEFAULT_EMIT_TESTS)
- TARGET=ebb; BUILD_TARGET=$$OUTPUT/$$TARGET; $(MAKE)
OUTPUT=$$BUILD_TARGET -s -C $$TARGET emit_tests
+ TARGET=ebb; BUILD_TARGET=$$OUTPUT$$TARGET; $(MAKE)
OUTPUT=$$BUILD_TARGET/ -s -C $$TARGET emit_tests
 endef

 DEFAULT_INSTALL_RULE := $(INSTALL_RULE)
 override define INSTALL_RULE
  $(DEFAULT_INSTALL_RULE)
- TARGET=ebb; BUILD_TARGET=$$OUTPUT/$$TARGET; $(MAKE)
OUTPUT=$$BUILD_TARGET -C $$TARGET install
+ TARGET=ebb; BUILD_TARGET=$$OUTPUT$$TARGET; $(MAKE)
OUTPUT=$$BUILD_TARGET/ -C $$TARGET install
 endef

 clean:
- $(RM) $(TEST_GEN_PROGS) $(OUTPUT)/loop.o
- TARGET=ebb; BUILD_TARGET=$$OUTPUT/$$TARGET; $(MAKE)
OUTPUT=$$BUILD_TARGET -C $$TARGET clean
+ $(RM) $(TEST_GEN_PROGS) $(OUTPUT)loop.o
+ TARGET=ebb; BUILD_TARGET=$$OUTPUT$$TARGET; $(MAKE)
OUTPUT=$$BUILD_TARGET/ -C $$TARGET clean

 ebb:
- TARGET=$@; BUILD_TARGET=$$OUTPUT/$$TARGET; mkdir -p $$BUILD_TARGET;
$(MAKE) OUTPUT=$$BUILD_TARGET -k -C $$TARGET all
+ TARGET=$@; BUILD_TARGET=$$OUTPUT$$TARGET; mkdir -p $$BUILD_TARGET;
$(MAKE) OUTPUT=$$BUILD_TARGET/ -k -C $$TARGET all

 .PHONY: all run_tests clean ebb
diff --git a/tools/testing/selftests/powerpc/pmu/ebb/Makefile
b/tools/testing/selftests/powerpc/pmu/ebb/Makefile
index 6001fb0..1512260 100644
--- a/tools/testing/selftests/powerpc/pmu/ebb/Makefile
+++ b/tools/testing/selftests/powerpc/pmu/ebb/Makefile
@@ -21,6 +21,6 @@ include ../../../lib.mk
 $(TEST_GEN_PROGS): ../../harness.c ../../utils.c ../event.c ../lib.c \
        ebb.c ebb_handler.S trace.c busy_loop.S

-$(OUTPUT)/instruction_count_test: ../loop.S
+$(OUTPUT)instruction_count_test: ../loop.S

-$(OUTPUT)/lost_exception_test: ../lib.c
+$(OUTPUT)lost_exception_test: ../lib.c
diff --git a/tools/testing/selftests/powerpc/switch_endian/Makefile
b/tools/testing/selftests/powerpc/switch_endian/Makefile
index b92c2a1..4d0bbf7 100644
--- a/tools/testing/selftests/powerpc/switch_endian/Makefile
+++ b/tools/testing/selftests/powerpc/switch_endian/Makefile
@@ -2,14 +2,14 @@ TEST_GEN_PROGS := switch_endian_test

 ASFLAGS += -O2 -Wall -g -nostdlib -m64

-EXTRA_CLEAN = $(OUTPUT)/*.o $(OUTPUT)/check-reversed.S
+EXTRA_CLEAN = $(OUTPUT)*.o $(OUTPUT)check-reversed.S

 include ../../lib.mk

-$(OUTPUT)/switch_endian_test: $(OUTPUT)/check-reversed.S
+$(OUTPUT)switch_endian_test: $(OUTPUT)check-reversed.S

-$(OUTPUT)/check-reversed.o: $(OUTPUT)/check.o
+$(OUTPUT)check-reversed.o: $(OUTPUT)check.o
  $(CROSS_COMPILE)objcopy -j .text --reverse-bytes=4 -O binary $< $@

-$(OUTPUT)/check-reversed.S: $(OUTPUT)/check-reversed.o
+$(OUTPUT)check-reversed.S: $(OUTPUT)check-reversed.o
  hexdump -v -e '/1 ".byte 0x%02X\n"' $< > $@
diff --git a/tools/testing/selftests/powerpc/tm/Makefile
b/tools/testing/selftests/powerpc/tm/Makefile
index 5576ee6..9c76e25 100644
--- a/tools/testing/selftests/powerpc/tm/Makefile
+++ b/tools/testing/selftests/powerpc/tm/Makefile
@@ -10,10 +10,10 @@ $(TEST_GEN_PROGS): ../harness.c ../utils.c

 CFLAGS += -mhtm

-$(OUTPUT)/tm-syscall: tm-syscall-asm.S
-$(OUTPUT)/tm-syscall: CFLAGS += -I../../../../../usr/include
-$(OUTPUT)/tm-tmspr: CFLAGS += -pthread
+$(OUTPUT)tm-syscall: tm-syscall-asm.S
+$(OUTPUT)tm-syscall: CFLAGS += -I../../../../../usr/include
+$(OUTPUT)tm-tmspr: CFLAGS += -pthread

-SIGNAL_CONTEXT_CHK_TESTS := $(patsubst
%,$(OUTPUT)/%,$(SIGNAL_CONTEXT_CHK_TESTS))
+SIGNAL_CONTEXT_CHK_TESTS := $(patsubst
%,$(OUTPUT)%,$(SIGNAL_CONTEXT_CHK_TESTS))
 $(SIGNAL_CONTEXT_CHK_TESTS): tm-signal.S
 $(SIGNAL_CONTEXT_CHK_TESTS): CFLAGS += -mhtm -m64 -mvsx
diff --git a/tools/testing/selftests/vm/Makefile
b/tools/testing/selftests/vm/Makefile
index 222ee45..1e7c02c 100644
--- a/tools/testing/selftests/vm/Makefile
+++ b/tools/testing/selftests/vm/Makefile
@@ -19,10 +19,10 @@ TEST_PROGS := run_vmtests

 include ../lib.mk

-$(OUTPUT)/userfaultfd: LDLIBS += -lpthread
../../../../usr/include/linux/kernel.h
-$(OUTPUT)/userfaultfd_hugetlb: LDLIBS += -lpthread
../../../../usr/include/linux/kernel.h
-$(OUTPUT)/userfaultfd_shmem: LDLIBS += -lpthread
../../../../usr/include/linux/kernel.h
-$(OUTPUT)/mlock-random-test: LDLIBS += -lcap
+$(OUTPUT)userfaultfd: LDLIBS += -lpthread
../../../../usr/include/linux/kernel.h
+$(OUTPUT)userfaultfd_hugetlb: LDLIBS += -lpthread
../../../../usr/include/linux/kernel.h
+$(OUTPUT)userfaultfd_shmem: LDLIBS += -lpthread
../../../../usr/include/linux/kernel.h
+$(OUTPUT)mlock-random-test: LDLIBS += -lcap

 ../../../../usr/include/linux/kernel.h:
  make -C ../../../.. headers_install
diff --git a/tools/testing/selftests/x86/Makefile
b/tools/testing/selftests/x86/Makefile
index 3a5ebae..42db9f4 100644
--- a/tools/testing/selftests/x86/Makefile
+++ b/tools/testing/selftests/x86/Makefile
@@ -17,8 +17,8 @@ TARGETS_C_64BIT_ALL := $(TARGETS_C_BOTHBITS)
$(TARGETS_C_64BIT_ONLY)
 BINARIES_32 := $(TARGETS_C_32BIT_ALL:%=%_32)
 BINARIES_64 := $(TARGETS_C_64BIT_ALL:%=%_64)

-BINARIES_32 := $(patsubst %,$(OUTPUT)/%,$(BINARIES_32))
-BINARIES_64 := $(patsubst %,$(OUTPUT)/%,$(BINARIES_64))
+BINARIES_32 := $(patsubst %,$(OUTPUT)%,$(BINARIES_32))
+BINARIES_64 := $(patsubst %,$(OUTPUT)%,$(BINARIES_64))

 CFLAGS := -O2 -g -std=gnu99 -pthread -Wall

@@ -43,10 +43,10 @@ all_64: $(BINARIES_64)
 clean:
  $(RM) $(BINARIES_32) $(BINARIES_64)

-$(BINARIES_32): $(OUTPUT)/%_32: %.c
+$(BINARIES_32): $(OUTPUT)%_32: %.c
  $(CC) -m32 -o $@ $(CFLAGS) $(EXTRA_CFLAGS) $^ -lrt -ldl -lm

-$(BINARIES_64): $(OUTPUT)/%_64: %.c
+$(BINARIES_64): $(OUTPUT)%_64: %.c
  $(CC) -m64 -o $@ $(CFLAGS) $(EXTRA_CFLAGS) $^ -lrt -ldl

 # x86_64 users should be encouraged to install 32-bit libraries
@@ -68,12 +68,12 @@ warn_32bit_failure:
 endif

 # Some tests have additional dependencies.
-$(OUTPUT)/sysret_ss_attrs_64: thunks.S
-$(OUTPUT)/ptrace_syscall_32: raw_syscall_helper_32.S
-$(OUTPUT)/test_syscall_vdso_32: thunks_32.S
+$(OUTPUT)sysret_ss_attrs_64: thunks.S
+$(OUTPUT)ptrace_syscall_32: raw_syscall_helper_32.S
+$(OUTPUT)test_syscall_vdso_32: thunks_32.S

 # check_initial_reg_state is special: it needs a custom entry, and it
 # needs to be static so that its interpreter doesn't destroy its initial
 # state.
-$(OUTPUT)/check_initial_reg_state_32: CFLAGS += -Wl,-ereal_start -static
-$(OUTPUT)/check_initial_reg_state_64: CFLAGS += -Wl,-ereal_start -static
+$(OUTPUT)check_initial_reg_state_32: CFLAGS += -Wl,-ereal_start -static
+$(OUTPUT)check_initial_reg_state_64: CFLAGS += -Wl,-ereal_start -static
-- 
1.9.1

Regards

Bamvor

>
> thanks,
> -- Shuah
>
>>
>> Regards
>>
>> Bamvor
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-api" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
