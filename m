From: Bamvor Zhang Jian <bamvor.zhangjian@linaro.org>
Subject: Re: [PATCH RFC 6/6] selftests: enable O and KBUILD_OUTPUT
Date: Fri, 21 Oct 2016 19:17:32 +0800
Message-ID: <CAFy1USShPwYS2PdjPh+jXk2EkZSkczGnbZmyaSDqLi-SCXqFyg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "Zhang Jian(Bamvor)" <bamvor.zhangjian@huawei.com>
Cc: Shuah Khan <shuahkh@osg.samsung.com>, linux-api <linux-api@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>, Mark Brown <broonie@kernel.org>, Michael Ellerman <mpe@ellerman.id.au>, Kevin Hilman <khilman@kernel.org>
List-Id: linux-api@vger.kernel.org

Fix the wrong email address of kevin hilman to khilman@kernel.org.
Sorry for inconvenience.

On 21 October 2016 at 19:01,  <bamvor.zhangjian@huawei.com> wrote:
> From: Bamvor Jian Zhang <bamvor.zhangjian@linaro.org>
>
> Enable O and KBUILD_OUTPUT for kselftest. User could compile kselftest
> to another directory by passing O or KBUILD_OUTPUT. And O is high
> priority than KBUILD_OUTPUT.
>
> Signed-off-by: Bamvor Jian Zhang <bamvor.zhangjian@linaro.org>
> ---
>  tools/testing/selftests/Makefile                   | 39 +++++++++++++++++-----
>  tools/testing/selftests/exec/Makefile              | 13 ++++----
>  tools/testing/selftests/ftrace/Makefile            |  2 +-
>  tools/testing/selftests/futex/Makefile             | 21 +++++++++---
>  tools/testing/selftests/kcmp/Makefile              |  2 +-
>  tools/testing/selftests/lib.mk                     | 19 ++++++++---
>  tools/testing/selftests/powerpc/Makefile           | 14 +++++---
>  .../testing/selftests/powerpc/benchmarks/Makefile  |  8 ++---
>  tools/testing/selftests/powerpc/copyloops/Makefile | 10 +++---
>  tools/testing/selftests/powerpc/dscr/Makefile      |  5 ++-
>  tools/testing/selftests/powerpc/math/Makefile      | 14 ++++----
>  tools/testing/selftests/powerpc/mm/Makefile        |  6 ++--
>  tools/testing/selftests/powerpc/pmu/Makefile       | 16 ++++-----
>  tools/testing/selftests/powerpc/pmu/ebb/Makefile   |  4 +--
>  .../testing/selftests/powerpc/primitives/Makefile  |  2 +-
>  .../testing/selftests/powerpc/stringloops/Makefile |  2 +-
>  .../selftests/powerpc/switch_endian/Makefile       |  8 ++---
>  tools/testing/selftests/powerpc/syscalls/Makefile  |  2 +-
>  tools/testing/selftests/powerpc/tm/Makefile        |  8 ++---
>  tools/testing/selftests/vm/Makefile                |  2 +-
>  tools/testing/selftests/x86/Makefile               | 17 ++++++----
>  21 files changed, 132 insertions(+), 82 deletions(-)
>
> diff --git a/tools/testing/selftests/Makefile b/tools/testing/selftests/Makefile
> index a3144a3..79c5e97 100644
> --- a/tools/testing/selftests/Makefile
> +++ b/tools/testing/selftests/Makefile
> @@ -47,29 +47,47 @@ override LDFLAGS =
>  override MAKEFLAGS =
>  endif
>
> +ifeq ($(O)$(KBUILD_OUTPUT),)
> +        BUILD :=$(shell pwd)
> +else
> +        ifneq ($(O),)
> +                BUILD := $(O)
> +        else
> +                ifneq ($(KBUILD_OUTPUT),)
> +                        BUILD := $(KBUILD_OUTPUT)
> +                endif
> +        endif
> +endif
> +export BUILD
>  all:
> -       for TARGET in $(TARGETS); do \
> -               make -C $$TARGET; \
> +       for TARGET in $(TARGETS); do            \
> +               BUILD_TARGET=$$BUILD/$$TARGET;  \
> +               mkdir $$BUILD_TARGET  -p;       \
> +               make OUTPUT=$$BUILD_TARGET/ -C $$TARGET;\
>         done;
>
>  run_tests: all
>         for TARGET in $(TARGETS); do \
> -               make -C $$TARGET run_tests; \
> +               BUILD_TARGET=$$BUILD/$$TARGET;  \
> +               make OUTPUT=$$BUILD_TARGET/ -C $$TARGET run_tests;\
>         done;
>
>  hotplug:
>         for TARGET in $(TARGETS_HOTPLUG); do \
> -               make -C $$TARGET; \
> +               BUILD_TARGET=$$BUILD/$$TARGET;  \
> +               make OUTPUT=$$BUILD_TARGET/ -C $$TARGET;\
>         done;
>
>  run_hotplug: hotplug
>         for TARGET in $(TARGETS_HOTPLUG); do \
> -               make -C $$TARGET run_full_test; \
> +               BUILD_TARGET=$$BUILD/$$TARGET;  \
> +               make OUTPUT=$$BUILD_TARGET/ -C $$TARGET run_full_test;\
>         done;
>
>  clean_hotplug:
>         for TARGET in $(TARGETS_HOTPLUG); do \
> -               make -C $$TARGET clean; \
> +               BUILD_TARGET=$$BUILD/$$TARGET;  \
> +               make OUTPUT=$$BUILD_TARGET/ -C $$TARGET clean;\
>         done;
>
>  run_pstore_crash:
> @@ -84,7 +102,8 @@ ifdef INSTALL_PATH
>         @# Ask all targets to install their files
>         mkdir -p $(INSTALL_PATH)
>         for TARGET in $(TARGETS); do \
> -               make -C $$TARGET INSTALL_PATH=$(INSTALL_PATH)/$$TARGET install; \
> +               BUILD_TARGET=$$BUILD/$$TARGET;  \
> +               make OUTPUT=$$BUILD_TARGET/ -C $$TARGET INSTALL_PATH=$(INSTALL_PATH)/$$TARGET install; \
>         done;
>
>         @# Ask all targets to emit their test scripts
> @@ -93,10 +112,11 @@ ifdef INSTALL_PATH
>         echo "ROOT=\$$PWD" >> $(ALL_SCRIPT)
>
>         for TARGET in $(TARGETS); do \
> +               BUILD_TARGET=$$BUILD/$$TARGET;  \
>                 echo "echo ; echo Running tests in $$TARGET" >> $(ALL_SCRIPT); \
>                 echo "echo ========================================" >> $(ALL_SCRIPT); \
>                 echo "cd $$TARGET" >> $(ALL_SCRIPT); \
> -               make -s --no-print-directory -C $$TARGET emit_tests >> $(ALL_SCRIPT); \
> +               make -s --no-print-directory OUTPUT=$$BUILD_TARGET/ -C $$TARGET emit_tests >> $(ALL_SCRIPT); \
>                 echo "cd \$$ROOT" >> $(ALL_SCRIPT); \
>         done;
>
> @@ -107,7 +127,8 @@ endif
>
>  clean:
>         for TARGET in $(TARGETS); do \
> -               make -C $$TARGET clean; \
> +               BUILD_TARGET=$$BUILD/$$TARGET;  \
> +               make OUTPUT=$$BUILD_TARGET/ -C $$TARGET clean;\
>         done;
>
>  .PHONY: install
> diff --git a/tools/testing/selftests/exec/Makefile b/tools/testing/selftests/exec/Makefile
> index 48d1f86..fe5cdec 100644
> --- a/tools/testing/selftests/exec/Makefile
> +++ b/tools/testing/selftests/exec/Makefile
> @@ -5,18 +5,19 @@ TEST_GEN_FILES := execveat.symlink execveat.denatured script subdir
>  # Makefile is a run-time dependency, since it's accessed by the execveat test
>  TEST_FILES := Makefile
>
> -EXTRA_CLEAN := subdir.moved execveat.moved xxxxx*
> +EXTRA_CLEAN := $(OUTPUT)subdir.moved $(OUTPUT)execveat.moved $(OUTPUT)xxxxx*
>
>  include ../lib.mk
>
> -subdir:
> +$(OUTPUT)subdir:
>         mkdir -p $@
> -script:
> +$(OUTPUT)script:
>         echo '#!/bin/sh' > $@
>         echo 'exit $$*' >> $@
>         chmod +x $@
> -execveat.symlink: execveat
> -       ln -s -f $< $@
> -execveat.denatured: execveat
> +$(OUTPUT)execveat.symlink: execveat
> +       cd $(OUTPUT) && ln -s -f $< `basename $@`
> +$(OUTPUT)execveat.denatured: execveat
>         cp $< $@
>         chmod -x $@
> +
> diff --git a/tools/testing/selftests/ftrace/Makefile b/tools/testing/selftests/ftrace/Makefile
> index 6c64b42..33bb29b 100644
> --- a/tools/testing/selftests/ftrace/Makefile
> +++ b/tools/testing/selftests/ftrace/Makefile
> @@ -2,6 +2,6 @@ all:
>
>  TEST_PROGS := ftracetest
>  TEST_FILES := test.d
> -EXTRA_CLEAN := logs/*
> +EXTRA_CLEAN := $(OUTPUT)logs/*
>
>  include ../lib.mk
> diff --git a/tools/testing/selftests/futex/Makefile b/tools/testing/selftests/futex/Makefile
> index 6a17529..12a3ae2 100644
> --- a/tools/testing/selftests/futex/Makefile
> +++ b/tools/testing/selftests/futex/Makefile
> @@ -3,13 +3,18 @@ SUBDIRS := functional
>  TEST_PROGS := run.sh
>
>  .PHONY: all clean
> -all:
> -       for DIR in $(SUBDIRS); do $(MAKE) -C $$DIR $@ ; done
>
>  include ../lib.mk
>
> +all:
> +       for DIR in $(SUBDIRS); do               \
> +               BUILD_TARGET=$$OUTPUT/$$DIR;    \
> +               mkdir $$BUILD_TARGET  -p;       \
> +               make OUTPUT=$$BUILD_TARGET/ -C $$DIR $@;\
> +       done
> +
>  override define RUN_TESTS
> -       ./run.sh
> +       @if [ `dirname $(OUTPUT)` = $(PWD) ]; then ./run.sh; fi
>  endef
>
>  override define INSTALL_RULE
> @@ -17,7 +22,9 @@ override define INSTALL_RULE
>         install -t $(INSTALL_PATH) $(TEST_PROGS) $(TEST_PROGS_EXTENDED) $(TEST_FILES)
>
>         @for SUBDIR in $(SUBDIRS); do \
> -               $(MAKE) -C $$SUBDIR INSTALL_PATH=$(INSTALL_PATH)/$$SUBDIR install; \
> +               BUILD_TARGET=$$OUTPUT/$$SUBDIR; \
> +               mkdir $$BUILD_TARGET  -p;       \
> +               $(MAKE) OUTPUT=$$BUILD_TARGET/ -C $$SUBDIR INSTALL_PATH=$(INSTALL_PATH)/$$SUBDIR install; \
>         done;
>  endef
>
> @@ -26,4 +33,8 @@ override define EMIT_TESTS
>  endef
>
>  clean:
> -       for DIR in $(SUBDIRS); do $(MAKE) -C $$DIR $@ ; done
> +       for DIR in $(SUBDIRS); do               \
> +               BUILD_TARGET=$$OUTPUT/$$DIR;    \
> +               mkdir $$BUILD_TARGET  -p;       \
> +               make OUTPUT=$$BUILD_TARGET/ -C $$DIR $@;\
> +       done
> diff --git a/tools/testing/selftests/kcmp/Makefile b/tools/testing/selftests/kcmp/Makefile
> index 74a8add..0fb599e 100644
> --- a/tools/testing/selftests/kcmp/Makefile
> +++ b/tools/testing/selftests/kcmp/Makefile
> @@ -2,7 +2,7 @@ CFLAGS += -I../../../../usr/include/
>
>  TEST_GEN_PROGS := kcmp_test
>
> -EXTRA_CLEAN := kcmp-test-file
> +EXTRA_CLEAN := $(OUTPUT)kcmp-test-file
>
>  include ../lib.mk
>
> diff --git a/tools/testing/selftests/lib.mk b/tools/testing/selftests/lib.mk
> index 0f7a371..fa87f98 100644
> --- a/tools/testing/selftests/lib.mk
> +++ b/tools/testing/selftests/lib.mk
> @@ -4,7 +4,8 @@ CC := $(CROSS_COMPILE)gcc
>
>  define RUN_TESTS
>         @for TEST in $(TEST_GEN_PROGS) $(TEST_PROGS); do \
> -               (./$$TEST && echo "selftests: $$TEST [PASS]") || echo "selftests: $$TEST [FAIL]"; \
> +               BASENAME_TEST=`basename $$TEST`;        \
> +               cd `dirname $$TEST`; (./$$BASENAME_TEST && echo "selftests: $$BASENAME_TEST [PASS]") || echo "selftests:  $$BASENAME_TEST [FAIL]"; cd -;\
>         done;
>  endef
>
> @@ -33,19 +34,29 @@ endif
>
>  define EMIT_TESTS
>         @for TEST in $(TEST_GEN_PROGS) $(TEST_PROGS); do \
> -               echo "(./$$TEST && echo \"selftests: $$TEST [PASS]\") || echo \"selftests: $$TEST [FAIL]\""; \
> +               BASENAME_TEST=`basename $$TEST`;        \
> +               echo "(./$$BASENAME_TEST && echo \"selftests: $$BASENAME_TEST [PASS]\") || echo \"selftests: $$BASENAME_TEST [FAIL]\""; \
>         done;
>  endef
>
>  emit_tests:
>         $(EMIT_TESTS)
>
> +TEST_GEN_PROGS := $(patsubst %,$(OUTPUT)%,$(TEST_GEN_PROGS))
> +TEST_GEN_FILES := $(patsubst %,$(OUTPUT)%,$(TEST_GEN_FILES))
> +
>  all: $(TEST_GEN_PROGS) $(TEST_GEN_PROGS_EXTENDED) $(TEST_GEN_FILES)
>
>  clean:
>         $(RM) -r $(TEST_GEN_PROGS) $(TEST_GEN_PROGS_EXTENDED) $(TEST_GEN_FILES) $(EXTRA_CLEAN)
>
> -%: %.c
> -       $(CC) $(CFLAGS) $(LDFLAGS) $(LDLIBS) -o $@ $^
> +$(OUTPUT)%:%.c
> +       $(CC) $(CFLAGS) $(LDFLAGS) $(LDLIBS) $< -o $@
> +
> +$(OUTPUT)%.o:%.S
> +       $(CC) $(ASFLAGS) -c $< -o $@
> +
> +$(OUTPUT)%:%.S
> +       $(CC) $(ASFLAGS) $< -o $@
>
>  .PHONY: run_tests all clean install emit_tests
> diff --git a/tools/testing/selftests/powerpc/Makefile b/tools/testing/selftests/powerpc/Makefile
> index db54a33..e99a28c 100644
> --- a/tools/testing/selftests/powerpc/Makefile
> +++ b/tools/testing/selftests/powerpc/Makefile
> @@ -33,31 +33,35 @@ endif
>  all: $(SUB_DIRS)
>
>  $(SUB_DIRS):
> -       $(MAKE) -k -C $@ all
> +       BUILD_TARGET=$$OUTPUT/$@; mkdir -p $$BUILD_TARGET; $(MAKE) OUTPUT=$$BUILD_TARGET/ -k -C $@ all
>
>  include ../lib.mk
>
>  override define RUN_TESTS
>         @for TARGET in $(SUB_DIRS); do \
> -               $(MAKE) -C $$TARGET run_tests; \
> +               BUILD_TARGET=$$OUTPUT/$$TARGET; \
> +               $(MAKE) OUTPUT=$$BUILD_TARGET/ -C $$TARGET run_tests;\
>         done;
>  endef
>
>  override define INSTALL_RULE
>         @for TARGET in $(SUB_DIRS); do \
> -               $(MAKE) -C $$TARGET install; \
> +               BUILD_TARGET=$$OUTPUT/$$TARGET; \
> +               $(MAKE) OUTPUT=$$BUILD_TARGET/ -C $$TARGET install;\
>         done;
>  endef
>
>  override define EMIT_TESTS
>         @for TARGET in $(SUB_DIRS); do \
> -               $(MAKE) -s -C $$TARGET emit_tests; \
> +               BUILD_TARGET=$$OUTPUT/$$TARGET; \
> +               $(MAKE) OUTPUT=$$BUILD_TARGET/ -s -C $$TARGET emit_tests;\
>         done;
>  endef
>
>  clean:
>         @for TARGET in $(SUB_DIRS); do \
> -               $(MAKE) -C $$TARGET clean; \
> +               BUILD_TARGET=$$OUTPUT/$$TARGET; \
> +               $(MAKE) OUTPUT=$$BUILD_TARGET/ -C $$TARGET clean;\
>         done;
>         rm -f tags
>
> diff --git a/tools/testing/selftests/powerpc/benchmarks/Makefile b/tools/testing/selftests/powerpc/benchmarks/Makefile
> index 1f94b31..3f6552c 100644
> --- a/tools/testing/selftests/powerpc/benchmarks/Makefile
> +++ b/tools/testing/selftests/powerpc/benchmarks/Makefile
> @@ -4,10 +4,10 @@ CFLAGS += -O2
>
>  $(TEST_GEN_PROGS): ../harness.c
>
> -EXTRA_CLEAN = *.o
> +EXTRA_CLEAN = $(OUTPUT)*.o
>
>  include ../../lib.mk
>
> -context_switch: ../utils.c
> -context_switch: CFLAGS += -maltivec -mvsx -mabi=altivec
> -context_switch: LDLIBS += -lpthread
> +$(OUTPUT)context_switch: ../utils.c
> +$(OUTPUT)context_switch: CFLAGS += -maltivec -mvsx -mabi=altivec
> +$(OUTPUT)context_switch: LDLIBS += -lpthread
> diff --git a/tools/testing/selftests/powerpc/copyloops/Makefile b/tools/testing/selftests/powerpc/copyloops/Makefile
> index a768179..07b0307 100644
> --- a/tools/testing/selftests/powerpc/copyloops/Makefile
> +++ b/tools/testing/selftests/powerpc/copyloops/Makefile
> @@ -9,14 +9,14 @@ ASFLAGS = $(CFLAGS)
>
>  TEST_GEN_PROGS := copyuser_64 copyuser_power7 memcpy_64 memcpy_power7
>  EXTRA_SOURCES := validate.c ../harness.c
> -EXTRA_CLEAN := *.o
> +EXTRA_CLEAN := $(OUTPUT)*.o
>
>  include ../../lib.mk
>
> -copyuser_64:     CPPFLAGS += -D COPY_LOOP=test___copy_tofrom_user_base
> -copyuser_power7: CPPFLAGS += -D COPY_LOOP=test___copy_tofrom_user_power7
> -memcpy_64:       CPPFLAGS += -D COPY_LOOP=test_memcpy
> -memcpy_power7:   CPPFLAGS += -D COPY_LOOP=test_memcpy_power7
> +$(OUTPUT)copyuser_64:     CPPFLAGS += -D COPY_LOOP=test___copy_tofrom_user_base
> +$(OUTPUT)copyuser_power7: CPPFLAGS += -D COPY_LOOP=test___copy_tofrom_user_power7
> +$(OUTPUT)memcpy_64:       CPPFLAGS += -D COPY_LOOP=test_memcpy
> +$(OUTPUT)memcpy_power7:   CPPFLAGS += -D COPY_LOOP=test_memcpy_power7
>
>  $(TEST_GEN_PROGS): $(EXTRA_SOURCES)
>
> diff --git a/tools/testing/selftests/powerpc/dscr/Makefile b/tools/testing/selftests/powerpc/dscr/Makefile
> index 7b43ac3..1df5da5 100644
> --- a/tools/testing/selftests/powerpc/dscr/Makefile
> +++ b/tools/testing/selftests/powerpc/dscr/Makefile
> @@ -2,11 +2,10 @@ TEST_GEN_PROGS := dscr_default_test dscr_explicit_test dscr_user_test \
>               dscr_inherit_test dscr_inherit_exec_test dscr_sysfs_test  \
>               dscr_sysfs_thread_test
>
> -EXTRA_CLEAN := *.o
> +EXTRA_CLEAN := $(OUTPUT)*.o
>
>  include ../../lib.mk
>
> -dscr_default_test: LDLIBS += -lpthread
> +$(OUTPUT)dscr_default_test: LDLIBS += -lpthread
>
>  $(TEST_GEN_PROGS): ../harness.c
> -
> diff --git a/tools/testing/selftests/powerpc/math/Makefile b/tools/testing/selftests/powerpc/math/Makefile
> index 9aa9b22..3587df8 100644
> --- a/tools/testing/selftests/powerpc/math/Makefile
> +++ b/tools/testing/selftests/powerpc/math/Makefile
> @@ -1,19 +1,19 @@
>  TEST_GEN_PROGS := fpu_syscall fpu_preempt fpu_signal vmx_syscall vmx_preempt vmx_signal vsx_preempt
>
> -EXTRA_CLEAN = *.o
> +EXTRA_CLEAN = $(OUTPUT)*.o
>
>  include ../../lib.mk
>
>  $(TEST_GEN_PROGS): ../harness.c
>  $(TEST_GEN_PROGS): CFLAGS += -O2 -g -pthread -m64 -maltivec
>
> -fpu_syscall: fpu_asm.S
> -fpu_preempt: fpu_asm.S
> -fpu_signal:  fpu_asm.S
> +$(OUTPUT)pu_syscall: fpu_asm.S
> +$(OUTPUT)pu_preempt: fpu_asm.S
> +$(OUTPUT)pu_signal:  fpu_asm.S
>
> -vmx_syscall: vmx_asm.S
> -vmx_preempt: vmx_asm.S
> -vmx_signal: vmx_asm.S
> +$(OUTPUT)mx_syscall: vmx_asm.S
> +$(OUTPUT)mx_preempt: vmx_asm.S
> +$(OUTPUT)mx_signal: vmx_asm.S
>
>  vsx_preempt: CFLAGS += -mvsx
>  vsx_preempt: vsx_asm.S
> diff --git a/tools/testing/selftests/powerpc/mm/Makefile b/tools/testing/selftests/powerpc/mm/Makefile
> index d563378..d4d2e68 100644
> --- a/tools/testing/selftests/powerpc/mm/Makefile
> +++ b/tools/testing/selftests/powerpc/mm/Makefile
> @@ -8,8 +8,8 @@ include ../../lib.mk
>
>  $(TEST_GEN_PROGS): ../harness.c
>
> -prot_sao: ../utils.c
> +$(OUTPUT)prot_sao: ../utils.c
>
> -tempfile:
> -       dd if=/dev/zero of=tempfile bs=64k count=1
> +$(OUTPUT)tempfile:
> +       dd if=/dev/zero of=$@ bs=64k count=1
>
> diff --git a/tools/testing/selftests/powerpc/pmu/Makefile b/tools/testing/selftests/powerpc/pmu/Makefile
> index ab0f902..1f084d0 100644
> --- a/tools/testing/selftests/powerpc/pmu/Makefile
> +++ b/tools/testing/selftests/powerpc/pmu/Makefile
> @@ -11,34 +11,34 @@ all: $(TEST_GEN_PROGS) ebb
>  $(TEST_GEN_PROGS): $(EXTRA_SOURCES)
>
>  # loop.S can only be built 64-bit
> -count_instructions: loop.S count_instructions.c $(EXTRA_SOURCES)
> +$(OUTPUT)count_instructions: loop.S count_instructions.c $(EXTRA_SOURCES)
>         $(CC) $(CFLAGS) -m64 -o $@ $^
>
> -per_event_excludes: ../utils.c
> +$(OUTPUT)per_event_excludes: ../utils.c
>
>  DEFAULT_RUN_TESTS := $(RUN_TESTS)
>  override define RUN_TESTS
>         $(DEFAULT_RUN_TESTS)
> -       $(MAKE) -C ebb run_tests
> +       TARGET=ebb; BUILD_TARGET=$$OUTPUT/$$TARGET; $(MAKE) OUTPUT=$$BUILD_TARGET/ -C $$TARGET run_tests
>  endef
>
>  DEFAULT_EMIT_TESTS := $(EMIT_TESTS)
>  override define EMIT_TESTS
>         $(DEFAULT_EMIT_TESTS)
> -       $(MAKE) -s -C ebb emit_tests
> +       TARGET=ebb; BUILD_TARGET=$$OUTPUT/$$TARGET; $(MAKE) OUTPUT=$$BUILD_TARGET/ -s -C $$TARGET emit_tests
>  endef
>
>  DEFAULT_INSTALL_RULE := $(INSTALL_RULE)
>  override define INSTALL_RULE
>         $(DEFAULT_INSTALL_RULE)
> -       $(MAKE) -C ebb install
> +       TARGET=ebb; BUILD_TARGET=$$OUTPUT/$$TARGET; $(MAKE) OUTPUT=$$BUILD_TARGET/ -C $$TARGET install
>  endef
>
>  clean:
> -       $(RM) $(TEST_PROGS) loop.o
> -       $(MAKE) -C ebb clean
> +       $(RM) $(TEST_GEN_PROGS) $(OUTPUT)loop.o
> +       TARGET=ebb; BUILD_TARGET=$$OUTPUT/$$TARGET; $(MAKE) OUTPUT=$$BUILD_TARGET/ -C $$TARGET clean
>
>  ebb:
> -       $(MAKE) -k -C $@ all
> +       TARGET=$@; BUILD_TARGET=$$OUTPUT/$$TARGET; mkdir -p $$BUILD_TARGET; $(MAKE) OUTPUT=$$BUILD_TARGET/ -k -C $$TARGET all
>
>  .PHONY: all run_tests clean ebb
> diff --git a/tools/testing/selftests/powerpc/pmu/ebb/Makefile b/tools/testing/selftests/powerpc/pmu/ebb/Makefile
> index 8dcedc4..c434a34 100644
> --- a/tools/testing/selftests/powerpc/pmu/ebb/Makefile
> +++ b/tools/testing/selftests/powerpc/pmu/ebb/Makefile
> @@ -21,6 +21,6 @@ include ../../../lib.mk
>  $(TEST_GEN_PROGS): ../../harness.c ../../utils.c ../event.c ../lib.c \
>                ebb.c ebb_handler.S trace.c busy_loop.S
>
> -instruction_count_test: ../loop.S
> +$(OUTPUT)instruction_count_test: ../loop.S
>
> -lost_exception_test: ../lib.c
> +$(OUTPUT)lost_exception_test: ../lib.c
> diff --git a/tools/testing/selftests/powerpc/primitives/Makefile b/tools/testing/selftests/powerpc/primitives/Makefile
> index 681627d..f6a0d14 100644
> --- a/tools/testing/selftests/powerpc/primitives/Makefile
> +++ b/tools/testing/selftests/powerpc/primitives/Makefile
> @@ -2,7 +2,7 @@ CFLAGS += -I$(CURDIR)
>
>  TEST_GEN_PROGS := load_unaligned_zeropad
>
> -EXTRA_CLEAN = *.o
> +EXTRA_CLEAN = $(OUTPUT)*.o
>
>  include ../../lib.mk
>
> diff --git a/tools/testing/selftests/powerpc/stringloops/Makefile b/tools/testing/selftests/powerpc/stringloops/Makefile
> index 166fdb8..49245be 100644
> --- a/tools/testing/selftests/powerpc/stringloops/Makefile
> +++ b/tools/testing/selftests/powerpc/stringloops/Makefile
> @@ -5,7 +5,7 @@ CFLAGS += -I$(CURDIR)
>  TEST_GEN_PROGS := memcmp
>  EXTRA_SOURCES := memcmp_64.S ../harness.c
>
> -EXTRA_CLEAN = *.o
> +EXTRA_CLEAN = $(OUTPUT)*.o
>
>  include ../../lib.mk
>
> diff --git a/tools/testing/selftests/powerpc/switch_endian/Makefile b/tools/testing/selftests/powerpc/switch_endian/Makefile
> index dbd05ac..4d0bbf7 100644
> --- a/tools/testing/selftests/powerpc/switch_endian/Makefile
> +++ b/tools/testing/selftests/powerpc/switch_endian/Makefile
> @@ -2,14 +2,14 @@ TEST_GEN_PROGS := switch_endian_test
>
>  ASFLAGS += -O2 -Wall -g -nostdlib -m64
>
> -EXTRA_CLEAN = *.o check-reversed.S
> +EXTRA_CLEAN = $(OUTPUT)*.o $(OUTPUT)check-reversed.S
>
>  include ../../lib.mk
>
> -switch_endian_test: check-reversed.S
> +$(OUTPUT)switch_endian_test: $(OUTPUT)check-reversed.S
>
> -check-reversed.o: check.o
> +$(OUTPUT)check-reversed.o: $(OUTPUT)check.o
>         $(CROSS_COMPILE)objcopy -j .text --reverse-bytes=4 -O binary $< $@
>
> -check-reversed.S: check-reversed.o
> +$(OUTPUT)check-reversed.S: $(OUTPUT)check-reversed.o
>         hexdump -v -e '/1 ".byte 0x%02X\n"' $< > $@
> diff --git a/tools/testing/selftests/powerpc/syscalls/Makefile b/tools/testing/selftests/powerpc/syscalls/Makefile
> index 1590938..5635076 100644
> --- a/tools/testing/selftests/powerpc/syscalls/Makefile
> +++ b/tools/testing/selftests/powerpc/syscalls/Makefile
> @@ -2,7 +2,7 @@ TEST_GEN_PROGS := ipc_unmuxed
>
>  CFLAGS += -I../../../../../usr/include
>
> -EXTRAN_CLEAN = *.o
> +EXTRAN_CLEAN = $(OUTPUT)*.o
>
>  include ../../lib.mk
>
> diff --git a/tools/testing/selftests/powerpc/tm/Makefile b/tools/testing/selftests/powerpc/tm/Makefile
> index 0ad4674..7604559 100644
> --- a/tools/testing/selftests/powerpc/tm/Makefile
> +++ b/tools/testing/selftests/powerpc/tm/Makefile
> @@ -4,7 +4,7 @@ SIGNAL_CONTEXT_CHK_TESTS := tm-signal-context-chk-gpr tm-signal-context-chk-fpu
>  TEST_GEN_PROGS := tm-resched-dscr tm-syscall tm-signal-msr-resv tm-signal-stack \
>         tm-vmxcopy tm-fork tm-tar tm-tmspr $(SIGNAL_CONTEXT_CHK_TESTS)
>
> -EXTRA_CLEAN = *.o
> +EXTRA_CLEAN = $(OUTPUT)*.o
>
>  include ../../lib.mk
>
> @@ -12,9 +12,9 @@ $(TEST_GEN_PROGS): ../harness.c ../utils.c
>
>  CFLAGS += -mhtm
>
> -tm-syscall: tm-syscall-asm.S
> -tm-syscall: CFLAGS += -I../../../../../usr/include
> -tm-tmspr: CFLAGS += -pthread
> +$(OUTPUT)tm-syscall: tm-syscall-asm.S
> +$(OUTPUT)tm-syscall: CFLAGS += -I../../../../../usr/include
> +$(OUTPUT)tm-tmspr: CFLAGS += -pthread
>
>  $(SIGNAL_CONTEXT_CHK_TESTS): tm-signal.S
>  $(SIGNAL_CONTEXT_CHK_TESTS): CFLAGS += -mhtm -m64 -mvsx
> diff --git a/tools/testing/selftests/vm/Makefile b/tools/testing/selftests/vm/Makefile
> index eb0aaff..96ff395 100644
> --- a/tools/testing/selftests/vm/Makefile
> +++ b/tools/testing/selftests/vm/Makefile
> @@ -13,7 +13,7 @@ TEST_GEN_FILES += transhuge-stress
>  TEST_GEN_FILES += userfaultfd
>  TEST_GEN_FILES += mlock-random-test
>
> -userfaultfd: userfaultfd.c ../../../../usr/include/linux/kernel.h
> +$(OUTPUT)userfaultfd: userfaultfd.c ../../../../usr/include/linux/kernel.h
>         $(CC) $(CFLAGS) -O2 -o $@ $< -lpthread
>
>  mlock-random-test: mlock-random-test.c
> diff --git a/tools/testing/selftests/x86/Makefile b/tools/testing/selftests/x86/Makefile
> index a89f80a..b11b310 100644
> --- a/tools/testing/selftests/x86/Makefile
> +++ b/tools/testing/selftests/x86/Makefile
> @@ -17,6 +17,9 @@ TARGETS_C_64BIT_ALL := $(TARGETS_C_BOTHBITS) $(TARGETS_C_64BIT_ONLY)
>  BINARIES_32 := $(TARGETS_C_32BIT_ALL:%=%_32)
>  BINARIES_64 := $(TARGETS_C_64BIT_ALL:%=%_64)
>
> +BINARIES_32 := $(patsubst %,$(OUTPUT)%,$(BINARIES_32))
> +BINARIES_64 := $(patsubst %,$(OUTPUT)%,$(BINARIES_64))
> +
>  CFLAGS := -O2 -g -std=gnu99 -pthread -Wall
>
>  UNAME_M := $(shell uname -m)
> @@ -40,10 +43,10 @@ all_64: $(BINARIES_64)
>  clean:
>         $(RM) $(BINARIES_32) $(BINARIES_64)
>
> -$(TARGETS_C_32BIT_ALL:%=%_32): %_32: %.c
> +$(BINARIES_32): $(OUTPUT)%_32: %.c
>         $(CC) -m32 -o $@ $(CFLAGS) $(EXTRA_CFLAGS) $^ -lrt -ldl -lm
>
> -$(TARGETS_C_64BIT_ALL:%=%_64): %_64: %.c
> +$(BINARIES_64): $(OUTPUT)%_64: %.c
>         $(CC) -m64 -o $@ $(CFLAGS) $(EXTRA_CFLAGS) $^ -lrt -ldl
>
>  # x86_64 users should be encouraged to install 32-bit libraries
> @@ -65,12 +68,12 @@ warn_32bit_failure:
>  endif
>
>  # Some tests have additional dependencies.
> -sysret_ss_attrs_64: thunks.S
> -ptrace_syscall_32: raw_syscall_helper_32.S
> -test_syscall_vdso_32: thunks_32.S
> +$(OUTPUT)sysret_ss_attrs_64: thunks.S
> +$(OUTPUT)ptrace_syscall_32: raw_syscall_helper_32.S
> +$(OUTPUT)test_syscall_vdso_32: thunks_32.S
>
>  # check_initial_reg_state is special: it needs a custom entry, and it
>  # needs to be static so that its interpreter doesn't destroy its initial
>  # state.
> -check_initial_reg_state_32: CFLAGS += -Wl,-ereal_start -static
> -check_initial_reg_state_64: CFLAGS += -Wl,-ereal_start -static
> +$(OUTPUT)check_initial_reg_state_32: CFLAGS += -Wl,-ereal_start -static
> +$(OUTPUT)check_initial_reg_state_64: CFLAGS += -Wl,-ereal_start -static
> --
> 1.8.4.5
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-api" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
