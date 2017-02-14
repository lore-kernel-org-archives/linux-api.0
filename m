From: Bamvor Zhang Jian <bamvor.zhangjian-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 1/5] selftests: Fix selftests build to just build, not run tests
Date: Tue, 14 Feb 2017 11:06:36 +0800
Message-ID: <CAFy1USTVyg5Mq65r-yskvEuaNrxxYHpckrFa1o0OUtn=_ZT38Q@mail.gmail.com>
References: <1486630590-9410-1-git-send-email-mpe@ellerman.id.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1486630590-9410-1-git-send-email-mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>
Cc: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, "Zhang Jian(Bamvor)" <bamvor.zhangjian-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linuxppc-dev-mnsaURCQ41sdnm+yROfE0A@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Tested by: Bamvor Jian Zhang <bamvor.zhangjian-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>

On 9 February 2017 at 16:56, Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org> wrote:
> In commit 88baa78d1f31 ("selftests: remove duplicated all and clean
> target"), the "all" target was removed from individual Makefiles and
> added to lib.mk.
>
> However the "all" target was added to lib.mk *after* the existing
> "runtests" target. This means "runtests" becomes the first (default)
> target for most of our Makefiles.
>
> This has the effect of causing a plain "make" to build *and run* the
> tests. Which is at best rude, but depending on which tests are run could
> oops someone's build machine.
>
>   $ make -C tools/testing/selftests/
>   ...
>   make[1]: Entering directory 'tools/testing/selftests/bpf'
>   gcc -Wall -O2 -I../../../../usr/include   test_verifier.c -o tools/testing/selftests/bpf/test_verifier
>   gcc -Wall -O2 -I../../../../usr/include   test_maps.c -o tools/testing/selftests/bpf/test_maps
>   gcc -Wall -O2 -I../../../../usr/include   test_lru_map.c -o tools/testing/selftests/bpf/test_lru_map
>   #0 add+sub+mul FAIL
>   Failed to load prog 'Function not implemented'!
>   #1 unreachable FAIL
>   Unexpected error message!
>   #2 unreachable2 FAIL
>   ...
>
> Fix it by moving the "all" target to the start of lib.mk, making it the
> default target.
>
> Fixes: 88baa78d1f31 ("selftests: remove duplicated all and clean target")
> Signed-off-by: Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>
> ---
>  tools/testing/selftests/lib.mk | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
>
> diff --git a/tools/testing/selftests/lib.mk b/tools/testing/selftests/lib.mk
> index 01bb7782a35e..17ed4bbe3963 100644
> --- a/tools/testing/selftests/lib.mk
> +++ b/tools/testing/selftests/lib.mk
> @@ -2,6 +2,11 @@
>  # Makefile can operate with or without the kbuild infrastructure.
>  CC := $(CROSS_COMPILE)gcc
>
> +TEST_GEN_PROGS := $(patsubst %,$(OUTPUT)/%,$(TEST_GEN_PROGS))
> +TEST_GEN_FILES := $(patsubst %,$(OUTPUT)/%,$(TEST_GEN_FILES))
> +
> +all: $(TEST_GEN_PROGS) $(TEST_GEN_PROGS_EXTENDED) $(TEST_GEN_FILES)
> +
>  define RUN_TESTS
>         @for TEST in $(TEST_GEN_PROGS) $(TEST_PROGS); do \
>                 BASENAME_TEST=`basename $$TEST`;        \
> @@ -42,11 +47,6 @@ endef
>  emit_tests:
>         $(EMIT_TESTS)
>
> -TEST_GEN_PROGS := $(patsubst %,$(OUTPUT)/%,$(TEST_GEN_PROGS))
> -TEST_GEN_FILES := $(patsubst %,$(OUTPUT)/%,$(TEST_GEN_FILES))
> -
> -all: $(TEST_GEN_PROGS) $(TEST_GEN_PROGS_EXTENDED) $(TEST_GEN_FILES)
> -
>  clean:
>         $(RM) -r $(TEST_GEN_PROGS) $(TEST_GEN_PROGS_EXTENDED) $(TEST_GEN_FILES) $(EXTRA_CLEAN)
>
> --
> 2.7.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-api" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
