From: Bamvor Zhang Jian <bamvor.zhangjian@linaro.org>
Subject: Re: [PATCH RFC 5/6] selftests: add EXTRA_CLEAN for clean target
Date: Fri, 21 Oct 2016 19:17:06 +0800
Message-ID: <CAFy1USQ1H7W3O9BZOek7wcC6L36S8y81C4_nJtEa4aNOSLOYUA@mail.gmail.com>
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
> Some testcases need the clean extra data after running. This patch
> introduce the "EXTRA_CLEAN" variable to address this requirement.
>
> After KOUTPUT_BUILD is enabled in later patch, it will be easy to
> decide to if we need do the cleanup in the KOUTPUT_BUILD path, if the
> testcase ran immediately after compiled.
>
> Signed-off-by: Bamvor Jian Zhang <bamvor.zhangjian@linaro.org>
> ---
>  tools/testing/selftests/exec/Makefile                 | 19 +++++++++----------
>  tools/testing/selftests/ftrace/Makefile               |  4 +---
>  tools/testing/selftests/kcmp/Makefile                 |  4 ++--
>  tools/testing/selftests/lib.mk                        |  2 +-
>  tools/testing/selftests/powerpc/benchmarks/Makefile   |  5 ++---
>  tools/testing/selftests/powerpc/copyloops/Makefile    |  3 +--
>  tools/testing/selftests/powerpc/dscr/Makefile         |  4 ++--
>  tools/testing/selftests/powerpc/math/Makefile         |  5 ++---
>  tools/testing/selftests/powerpc/primitives/Makefile   |  5 ++---
>  tools/testing/selftests/powerpc/stringloops/Makefile  |  5 ++---
>  .../testing/selftests/powerpc/switch_endian/Makefile  |  5 ++---
>  tools/testing/selftests/powerpc/syscalls/Makefile     |  5 ++---
>  tools/testing/selftests/powerpc/tm/Makefile           |  5 ++---
>  tools/testing/selftests/pstore/Makefile               |  4 +---
>  tools/testing/selftests/zram/Makefile                 |  3 +--
>  15 files changed, 32 insertions(+), 46 deletions(-)
>
> diff --git a/tools/testing/selftests/exec/Makefile b/tools/testing/selftests/exec/Makefile
> index 9eb1c3e..48d1f86 100644
> --- a/tools/testing/selftests/exec/Makefile
> +++ b/tools/testing/selftests/exec/Makefile
> @@ -1,5 +1,14 @@
>  CFLAGS = -Wall
>
> +TEST_GEN_PROGS := execveat
> +TEST_GEN_FILES := execveat.symlink execveat.denatured script subdir
> +# Makefile is a run-time dependency, since it's accessed by the execveat test
> +TEST_FILES := Makefile
> +
> +EXTRA_CLEAN := subdir.moved execveat.moved xxxxx*
> +
> +include ../lib.mk
> +
>  subdir:
>         mkdir -p $@
>  script:
> @@ -11,13 +20,3 @@ execveat.symlink: execveat
>  execveat.denatured: execveat
>         cp $< $@
>         chmod -x $@
> -
> -TEST_GEN_PROGS := execveat
> -TEST_GEN_FILES := execveat.symlink execveat.denatured script subdir
> -# Makefile is a run-time dependency, since it's accessed by the execveat test
> -TEST_FILES := Makefile
> -
> -include ../lib.mk
> -
> -clean:
> -       rm -rf $(TEST_GEN_PROGS) $(TEST_GEN_FILES) subdir.moved execveat.moved xxxxx*
> diff --git a/tools/testing/selftests/ftrace/Makefile b/tools/testing/selftests/ftrace/Makefile
> index a715300..6c64b42 100644
> --- a/tools/testing/selftests/ftrace/Makefile
> +++ b/tools/testing/selftests/ftrace/Makefile
> @@ -2,8 +2,6 @@ all:
>
>  TEST_PROGS := ftracetest
>  TEST_FILES := test.d
> +EXTRA_CLEAN := logs/*
>
>  include ../lib.mk
> -
> -clean:
> -       rm -rf logs/*
> diff --git a/tools/testing/selftests/kcmp/Makefile b/tools/testing/selftests/kcmp/Makefile
> index 9e8b673..74a8add 100644
> --- a/tools/testing/selftests/kcmp/Makefile
> +++ b/tools/testing/selftests/kcmp/Makefile
> @@ -2,7 +2,7 @@ CFLAGS += -I../../../../usr/include/
>
>  TEST_GEN_PROGS := kcmp_test
>
> +EXTRA_CLEAN := kcmp-test-file
> +
>  include ../lib.mk
>
> -clean:
> -       $(RM) $(TEST_GEN_PROGS) kcmp-test-file
> diff --git a/tools/testing/selftests/lib.mk b/tools/testing/selftests/lib.mk
> index 9ccec4b..0f7a371 100644
> --- a/tools/testing/selftests/lib.mk
> +++ b/tools/testing/selftests/lib.mk
> @@ -43,7 +43,7 @@ emit_tests:
>  all: $(TEST_GEN_PROGS) $(TEST_GEN_PROGS_EXTENDED) $(TEST_GEN_FILES)
>
>  clean:
> -       $(RM) -fr $(TEST_GEN_PROGS) $(TEST_GEN_PROGS_EXTENDED) $(TEST_GEN_FILES)
> +       $(RM) -r $(TEST_GEN_PROGS) $(TEST_GEN_PROGS_EXTENDED) $(TEST_GEN_FILES) $(EXTRA_CLEAN)
>
>  %: %.c
>         $(CC) $(CFLAGS) $(LDFLAGS) $(LDLIBS) -o $@ $^
> diff --git a/tools/testing/selftests/powerpc/benchmarks/Makefile b/tools/testing/selftests/powerpc/benchmarks/Makefile
> index 985a77c..1f94b31 100644
> --- a/tools/testing/selftests/powerpc/benchmarks/Makefile
> +++ b/tools/testing/selftests/powerpc/benchmarks/Makefile
> @@ -4,11 +4,10 @@ CFLAGS += -O2
>
>  $(TEST_GEN_PROGS): ../harness.c
>
> +EXTRA_CLEAN = *.o
> +
>  include ../../lib.mk
>
>  context_switch: ../utils.c
>  context_switch: CFLAGS += -maltivec -mvsx -mabi=altivec
>  context_switch: LDLIBS += -lpthread
> -
> -clean:
> -       $(RM) $(TEST_GEN_PROGS) *.o
> diff --git a/tools/testing/selftests/powerpc/copyloops/Makefile b/tools/testing/selftests/powerpc/copyloops/Makefile
> index eff1034..a768179 100644
> --- a/tools/testing/selftests/powerpc/copyloops/Makefile
> +++ b/tools/testing/selftests/powerpc/copyloops/Makefile
> @@ -9,6 +9,7 @@ ASFLAGS = $(CFLAGS)
>
>  TEST_GEN_PROGS := copyuser_64 copyuser_power7 memcpy_64 memcpy_power7
>  EXTRA_SOURCES := validate.c ../harness.c
> +EXTRA_CLEAN := *.o
>
>  include ../../lib.mk
>
> @@ -19,5 +20,3 @@ memcpy_power7:   CPPFLAGS += -D COPY_LOOP=test_memcpy_power7
>
>  $(TEST_GEN_PROGS): $(EXTRA_SOURCES)
>
> -clean:
> -       $(RM) $(TEST_GEN_PROGS) *.o
> diff --git a/tools/testing/selftests/powerpc/dscr/Makefile b/tools/testing/selftests/powerpc/dscr/Makefile
> index 96e0de0..7b43ac3 100644
> --- a/tools/testing/selftests/powerpc/dscr/Makefile
> +++ b/tools/testing/selftests/powerpc/dscr/Makefile
> @@ -2,11 +2,11 @@ TEST_GEN_PROGS := dscr_default_test dscr_explicit_test dscr_user_test \
>               dscr_inherit_test dscr_inherit_exec_test dscr_sysfs_test  \
>               dscr_sysfs_thread_test
>
> +EXTRA_CLEAN := *.o
> +
>  include ../../lib.mk
>
>  dscr_default_test: LDLIBS += -lpthread
>
>  $(TEST_GEN_PROGS): ../harness.c
>
> -clean:
> -       $(RM) $(TEST_GEN_PROGS) *.o
> diff --git a/tools/testing/selftests/powerpc/math/Makefile b/tools/testing/selftests/powerpc/math/Makefile
> index 8a5dde5..9aa9b22 100644
> --- a/tools/testing/selftests/powerpc/math/Makefile
> +++ b/tools/testing/selftests/powerpc/math/Makefile
> @@ -1,5 +1,7 @@
>  TEST_GEN_PROGS := fpu_syscall fpu_preempt fpu_signal vmx_syscall vmx_preempt vmx_signal vsx_preempt
>
> +EXTRA_CLEAN = *.o
> +
>  include ../../lib.mk
>
>  $(TEST_GEN_PROGS): ../harness.c
> @@ -15,6 +17,3 @@ vmx_signal: vmx_asm.S
>
>  vsx_preempt: CFLAGS += -mvsx
>  vsx_preempt: vsx_asm.S
> -
> -clean:
> -       $(RM) $(TEST_GEN_PROGS) *.o
> diff --git a/tools/testing/selftests/powerpc/primitives/Makefile b/tools/testing/selftests/powerpc/primitives/Makefile
> index 32cd56c..681627d 100644
> --- a/tools/testing/selftests/powerpc/primitives/Makefile
> +++ b/tools/testing/selftests/powerpc/primitives/Makefile
> @@ -2,9 +2,8 @@ CFLAGS += -I$(CURDIR)
>
>  TEST_GEN_PROGS := load_unaligned_zeropad
>
> +EXTRA_CLEAN = *.o
> +
>  include ../../lib.mk
>
>  $(TEST_GEN_PROGS): ../harness.c
> -
> -clean:
> -       $(RM) $(TEST_GEN_PROGS) *.o
> diff --git a/tools/testing/selftests/powerpc/stringloops/Makefile b/tools/testing/selftests/powerpc/stringloops/Makefile
> index c0ce663..166fdb8 100644
> --- a/tools/testing/selftests/powerpc/stringloops/Makefile
> +++ b/tools/testing/selftests/powerpc/stringloops/Makefile
> @@ -5,9 +5,8 @@ CFLAGS += -I$(CURDIR)
>  TEST_GEN_PROGS := memcmp
>  EXTRA_SOURCES := memcmp_64.S ../harness.c
>
> +EXTRA_CLEAN = *.o
> +
>  include ../../lib.mk
>
>  $(TEST_GEN_PROGS): $(EXTRA_SOURCES)
> -
> -clean:
> -       $(RM) $(TEST_GEN_PROGS) *.o
> diff --git a/tools/testing/selftests/powerpc/switch_endian/Makefile b/tools/testing/selftests/powerpc/switch_endian/Makefile
> index bd01223..dbd05ac 100644
> --- a/tools/testing/selftests/powerpc/switch_endian/Makefile
> +++ b/tools/testing/selftests/powerpc/switch_endian/Makefile
> @@ -2,6 +2,8 @@ TEST_GEN_PROGS := switch_endian_test
>
>  ASFLAGS += -O2 -Wall -g -nostdlib -m64
>
> +EXTRA_CLEAN = *.o check-reversed.S
> +
>  include ../../lib.mk
>
>  switch_endian_test: check-reversed.S
> @@ -11,6 +13,3 @@ check-reversed.o: check.o
>
>  check-reversed.S: check-reversed.o
>         hexdump -v -e '/1 ".byte 0x%02X\n"' $< > $@
> -
> -clean:
> -       $(RM) $(TEST_GEN_PROGS) *.o check-reversed.S
> diff --git a/tools/testing/selftests/powerpc/syscalls/Makefile b/tools/testing/selftests/powerpc/syscalls/Makefile
> index 5bea391..1590938 100644
> --- a/tools/testing/selftests/powerpc/syscalls/Makefile
> +++ b/tools/testing/selftests/powerpc/syscalls/Makefile
> @@ -2,9 +2,8 @@ TEST_GEN_PROGS := ipc_unmuxed
>
>  CFLAGS += -I../../../../../usr/include
>
> +EXTRAN_CLEAN = *.o
> +
>  include ../../lib.mk
>
>  $(TEST_GEN_PROGS): ../harness.c
> -
> -clean:
> -       $(RM) $(TEST_GEN_PROGS) *.o
> diff --git a/tools/testing/selftests/powerpc/tm/Makefile b/tools/testing/selftests/powerpc/tm/Makefile
> index cad0821..0ad4674 100644
> --- a/tools/testing/selftests/powerpc/tm/Makefile
> +++ b/tools/testing/selftests/powerpc/tm/Makefile
> @@ -4,6 +4,8 @@ SIGNAL_CONTEXT_CHK_TESTS := tm-signal-context-chk-gpr tm-signal-context-chk-fpu
>  TEST_GEN_PROGS := tm-resched-dscr tm-syscall tm-signal-msr-resv tm-signal-stack \
>         tm-vmxcopy tm-fork tm-tar tm-tmspr $(SIGNAL_CONTEXT_CHK_TESTS)
>
> +EXTRA_CLEAN = *.o
> +
>  include ../../lib.mk
>
>  $(TEST_GEN_PROGS): ../harness.c ../utils.c
> @@ -16,6 +18,3 @@ tm-tmspr: CFLAGS += -pthread
>
>  $(SIGNAL_CONTEXT_CHK_TESTS): tm-signal.S
>  $(SIGNAL_CONTEXT_CHK_TESTS): CFLAGS += -mhtm -m64 -mvsx
> -
> -clean:
> -       $(RM) $(TEST_GEN_PROGS) *.o
> diff --git a/tools/testing/selftests/pstore/Makefile b/tools/testing/selftests/pstore/Makefile
> index bd7abe2..c5f2440 100644
> --- a/tools/testing/selftests/pstore/Makefile
> +++ b/tools/testing/selftests/pstore/Makefile
> @@ -5,11 +5,9 @@ all:
>
>  TEST_PROGS := pstore_tests pstore_post_reboot_tests
>  TEST_FILES := common_tests pstore_crash_test
> +EXTRA_CLEAN := logs/* *uuid
>
>  include ../lib.mk
>
>  run_crash:
>         @sh pstore_crash_test || { echo "pstore_crash_test: [FAIL]"; exit 1; }
> -
> -clean:
> -       rm -rf logs/* *uuid
> diff --git a/tools/testing/selftests/zram/Makefile b/tools/testing/selftests/zram/Makefile
> index 29d8034..c3a87e5 100644
> --- a/tools/testing/selftests/zram/Makefile
> +++ b/tools/testing/selftests/zram/Makefile
> @@ -2,8 +2,7 @@ all:
>
>  TEST_PROGS := zram.sh
>  TEST_FILES := zram01.sh zram02.sh zram_lib.sh
> +EXTRA_CLEAN := err.log
>
>  include ../lib.mk
>
> -clean:
> -       $(RM) err.log
> --
> 1.8.4.5
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-api" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
