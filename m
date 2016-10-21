From: Bamvor Zhang Jian <bamvor.zhangjian@linaro.org>
Subject: Re: [PATCH RFC 3/6] selftests: add default rules for c source file
Date: Fri, 21 Oct 2016 19:15:43 +0800
Message-ID: <CAFy1UST-crchw08B43_+rzaNZssfnqF10L7ZwUP65zAsCTWmLg@mail.gmail.com>
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
> There are difference rules for compiling c source file in different
> testcases. In order to enable KBUILD_OUTPUT support in later patch,
> this patch introduce the default rules in
> "tools/testing/selftest/lib.mk" and remove the existing rules in each
> testcase.
>
> Signed-off-by: Bamvor Jian Zhang <bamvor.zhangjian@linaro.org>
> ---
>  tools/testing/selftests/exec/Makefile  | 2 --
>  tools/testing/selftests/lib.mk         | 3 +++
>  tools/testing/selftests/mount/Makefile | 3 ---
>  tools/testing/selftests/net/Makefile   | 2 --
>  tools/testing/selftests/size/Makefile  | 4 +---
>  tools/testing/selftests/vm/Makefile    | 3 +--
>  6 files changed, 5 insertions(+), 12 deletions(-)
>
> diff --git a/tools/testing/selftests/exec/Makefile b/tools/testing/selftests/exec/Makefile
> index b3bf091..9eb1c3e 100644
> --- a/tools/testing/selftests/exec/Makefile
> +++ b/tools/testing/selftests/exec/Makefile
> @@ -11,8 +11,6 @@ execveat.symlink: execveat
>  execveat.denatured: execveat
>         cp $< $@
>         chmod -x $@
> -%: %.c
> -       $(CC) $(CFLAGS) -o $@ $^
>
>  TEST_GEN_PROGS := execveat
>  TEST_GEN_FILES := execveat.symlink execveat.denatured script subdir
> diff --git a/tools/testing/selftests/lib.mk b/tools/testing/selftests/lib.mk
> index 8c0440d..9ccec4b 100644
> --- a/tools/testing/selftests/lib.mk
> +++ b/tools/testing/selftests/lib.mk
> @@ -45,4 +45,7 @@ all: $(TEST_GEN_PROGS) $(TEST_GEN_PROGS_EXTENDED) $(TEST_GEN_FILES)
>  clean:
>         $(RM) -fr $(TEST_GEN_PROGS) $(TEST_GEN_PROGS_EXTENDED) $(TEST_GEN_FILES)
>
> +%: %.c
> +       $(CC) $(CFLAGS) $(LDFLAGS) $(LDLIBS) -o $@ $^
> +
>  .PHONY: run_tests all clean install emit_tests
> diff --git a/tools/testing/selftests/mount/Makefile b/tools/testing/selftests/mount/Makefile
> index e8fb15e..9093d7f 100644
> --- a/tools/testing/selftests/mount/Makefile
> +++ b/tools/testing/selftests/mount/Makefile
> @@ -2,9 +2,6 @@
>  CFLAGS = -Wall \
>           -O2
>
> -unprivileged-remount-test: unprivileged-remount-test.c
> -       $(CC) $(CFLAGS) unprivileged-remount-test.c -o unprivileged-remount-test
> -
>  TEST_GEN_PROGS := unprivileged-remount-test
>
>  include ../lib.mk
> diff --git a/tools/testing/selftests/net/Makefile b/tools/testing/selftests/net/Makefile
> index c976425..d13620a 100644
> --- a/tools/testing/selftests/net/Makefile
> +++ b/tools/testing/selftests/net/Makefile
> @@ -4,8 +4,6 @@ CFLAGS = -Wall -O2 -g
>
>  CFLAGS += -I../../../../usr/include/
>
> -%: %.c
> -       $(CC) $(CFLAGS) -o $@ $^
>  TEST_PROGS := run_netsocktests run_afpackettests test_bpf.sh
>  TEST_GEN_FILES := socket psock_fanout psock_tpacket reuseport_bpf reuseport_bpf_cpu reuseport_dualstack
>
> diff --git a/tools/testing/selftests/size/Makefile b/tools/testing/selftests/size/Makefile
> index c67f357..4685b3e 100644
> --- a/tools/testing/selftests/size/Makefile
> +++ b/tools/testing/selftests/size/Makefile
> @@ -1,6 +1,4 @@
> -
> -get_size: get_size.c
> -       $(CC) -static -ffreestanding -nostartfiles -s $< -o $@
> +CFLAGS := -static -ffreestanding -nostartfiles -s
>
>  TEST_GEN_PROGS := get_size
>
> diff --git a/tools/testing/selftests/vm/Makefile b/tools/testing/selftests/vm/Makefile
> index 323383a..eb0aaff 100644
> --- a/tools/testing/selftests/vm/Makefile
> +++ b/tools/testing/selftests/vm/Makefile
> @@ -1,6 +1,7 @@
>  # Makefile for vm selftests
>
>  CFLAGS = -Wall -I ../../../../usr/include $(EXTRA_CFLAGS)
> +LDLIBS = -lrt
>  TEST_GEN_FILES = compaction_test
>  TEST_GEN_FILES += hugepage-mmap
>  TEST_GEN_FILES += hugepage-shm
> @@ -12,8 +13,6 @@ TEST_GEN_FILES += transhuge-stress
>  TEST_GEN_FILES += userfaultfd
>  TEST_GEN_FILES += mlock-random-test
>
> -%: %.c
> -       $(CC) $(CFLAGS) -o $@ $^ -lrt
>  userfaultfd: userfaultfd.c ../../../../usr/include/linux/kernel.h
>         $(CC) $(CFLAGS) -O2 -o $@ $< -lpthread
>
> --
> 1.8.4.5
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-api" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
