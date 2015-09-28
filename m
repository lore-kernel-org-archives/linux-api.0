From: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] kselftest: replace $(RM) with rm -f command
Date: Mon, 28 Sep 2015 03:16:53 +0000 (UTC)
Message-ID: <1201012824.5792.1443410213729.JavaMail.zimbra@efficios.com>
References: <20150925154415.GC38748@vmdeb7> <1443406217-137773-1-git-send-email-long.wanglong@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1443406217-137773-1-git-send-email-long.wanglong-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Wang Long <long.wanglong-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org, dvhart-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>, keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org, luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org, wad-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, gorcunov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, cov-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, bobby prani <bobby.prani-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, tyler baker <tyler.baker-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Tim Bird <tim.bird-/MT0OVThwyLZJqsBc5GL+g@public.gmane.org>, josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org, Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, andrej skvortzov <andrej.skvortzov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, sjayaram-JqFfY2XvxFXQT0dZR+AlfA@public.gmane.org, treding-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, naresh kamboju <naresh.kamboju-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, alexey kodanev <alexey.kodanev-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-api <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, wanglong-m92B/FuLcaEcWVvVuXF20w@public.gmane.org
List-Id: linux-api@vger.kernel.org

----- On Sep 27, 2015, at 10:10 PM, Wang Long long.wanglong-hv44wF8Li93QT0dZR+AlfA@public.gmane.org wrote:

> Some test's Makefile using "$(RM)" while the other's
> using "rm -f". It is better to use one of them in all
> tests.

I agree that this disparity appears to be unwanted. We
should settle on one or the other.

> 
> "rm -f" is better, because it is less magic, and everyone
> konws what is does.

"$(RM)" is clearly defined as a Makefile implicit variable
which defaults to "rm -f".
Ref. https://www.gnu.org/software/make/manual/html_node/Implicit-Variables.html

Leaving it as a variable is more flexible because then the
default behavior can be overridden if need be, which is
not the case of a hardcoded "rm -f".

Following your line of argumentation, we should then
invoke "gcc" directly in every Makefile because it is
less magic than "$(CC)". This makes no sense.

Thanks,

Mathieu

> 
> Signed-off-by: Wang Long <long.wanglong-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> ---
> tools/testing/selftests/capabilities/Makefile | 2 +-
> tools/testing/selftests/kcmp/Makefile         | 2 +-
> tools/testing/selftests/membarrier/Makefile   | 2 +-
> tools/testing/selftests/memfd/Makefile        | 2 +-
> tools/testing/selftests/net/Makefile          | 2 +-
> tools/testing/selftests/seccomp/Makefile      | 2 +-
> tools/testing/selftests/size/Makefile         | 2 +-
> tools/testing/selftests/vm/Makefile           | 2 +-
> tools/testing/selftests/x86/Makefile          | 2 +-
> tools/testing/selftests/zram/Makefile         | 2 +-
> 10 files changed, 10 insertions(+), 10 deletions(-)
> 
> diff --git a/tools/testing/selftests/capabilities/Makefile
> b/tools/testing/selftests/capabilities/Makefile
> index 8c8f0c1..dcc1972 100644
> --- a/tools/testing/selftests/capabilities/Makefile
> +++ b/tools/testing/selftests/capabilities/Makefile
> @@ -12,7 +12,7 @@ CFLAGS := -O2 -g -std=gnu99 -Wall -lcap-ng
> all: $(TARGETS)
> 
> clean:
> -	$(RM) $(TARGETS)
> +	rm -f $(TARGETS)
> 
> $(TARGETS): %: %.c
> 	$(CC) -o $@ $(CFLAGS) $(EXTRA_CFLAGS) $^ -lrt -ldl
> diff --git a/tools/testing/selftests/kcmp/Makefile
> b/tools/testing/selftests/kcmp/Makefile
> index 2ae7450..2deaee0 100644
> --- a/tools/testing/selftests/kcmp/Makefile
> +++ b/tools/testing/selftests/kcmp/Makefile
> @@ -7,4 +7,4 @@ TEST_PROGS := kcmp_test
> include ../lib.mk
> 
> clean:
> -	$(RM) kcmp_test kcmp-test-file
> +	rn -f kcmp_test kcmp-test-file
> diff --git a/tools/testing/selftests/membarrier/Makefile
> b/tools/testing/selftests/membarrier/Makefile
> index a1a9708..f23fc58 100644
> --- a/tools/testing/selftests/membarrier/Makefile
> +++ b/tools/testing/selftests/membarrier/Makefile
> @@ -7,4 +7,4 @@ all: $(TEST_PROGS)
> include ../lib.mk
> 
> clean:
> -	$(RM) $(TEST_PROGS)
> +	rm -f $(TEST_PROGS)
> diff --git a/tools/testing/selftests/memfd/Makefile
> b/tools/testing/selftests/memfd/Makefile
> index 3e7eb79..068fa93 100644
> --- a/tools/testing/selftests/memfd/Makefile
> +++ b/tools/testing/selftests/memfd/Makefile
> @@ -19,4 +19,4 @@ run_fuse: build_fuse
> 	@./run_fuse_test.sh || echo "fuse_test: [FAIL]"
> 
> clean:
> -	$(RM) memfd_test fuse_test
> +	rm -f memfd_test fuse_test
> diff --git a/tools/testing/selftests/net/Makefile
> b/tools/testing/selftests/net/Makefile
> index fac4782..ec7eaa4 100644
> --- a/tools/testing/selftests/net/Makefile
> +++ b/tools/testing/selftests/net/Makefile
> @@ -16,4 +16,4 @@ TEST_FILES := $(NET_PROGS)
> include ../lib.mk
> 
> clean:
> -	$(RM) $(NET_PROGS)
> +	rm -f $(NET_PROGS)
> diff --git a/tools/testing/selftests/seccomp/Makefile
> b/tools/testing/selftests/seccomp/Makefile
> index 8401e87..c16072a 100644
> --- a/tools/testing/selftests/seccomp/Makefile
> +++ b/tools/testing/selftests/seccomp/Makefile
> @@ -7,4 +7,4 @@ all: $(TEST_PROGS)
> include ../lib.mk
> 
> clean:
> -	$(RM) $(TEST_PROGS)
> +	rm -f $(TEST_PROGS)
> diff --git a/tools/testing/selftests/size/Makefile
> b/tools/testing/selftests/size/Makefile
> index bbd0b53..cefe914 100644
> --- a/tools/testing/selftests/size/Makefile
> +++ b/tools/testing/selftests/size/Makefile
> @@ -8,4 +8,4 @@ TEST_PROGS := get_size
> include ../lib.mk
> 
> clean:
> -	$(RM) get_size
> +	rm -f get_size
> diff --git a/tools/testing/selftests/vm/Makefile
> b/tools/testing/selftests/vm/Makefile
> index 3c53cac..26663c7 100644
> --- a/tools/testing/selftests/vm/Makefile
> +++ b/tools/testing/selftests/vm/Makefile
> @@ -24,4 +24,4 @@ TEST_FILES := $(BINARIES)
> include ../lib.mk
> 
> clean:
> -	$(RM) $(BINARIES)
> +	rm -f $(BINARIES)
> diff --git a/tools/testing/selftests/x86/Makefile
> b/tools/testing/selftests/x86/Makefile
> index 29089b2..48b2406 100644
> --- a/tools/testing/selftests/x86/Makefile
> +++ b/tools/testing/selftests/x86/Makefile
> @@ -32,7 +32,7 @@ all_32: $(BINARIES_32)
> all_64: $(BINARIES_64)
> 
> clean:
> -	$(RM) $(BINARIES_32) $(BINARIES_64)
> +	rm -f $(BINARIES_32) $(BINARIES_64)
> 
> $(TARGETS_C_32BIT_ALL:%=%_32): %_32: %.c
> 	$(CC) -m32 -o $@ $(CFLAGS) $(EXTRA_CFLAGS) $^ -lrt -ldl
> diff --git a/tools/testing/selftests/zram/Makefile
> b/tools/testing/selftests/zram/Makefile
> index 29d8034..e1591c8 100644
> --- a/tools/testing/selftests/zram/Makefile
> +++ b/tools/testing/selftests/zram/Makefile
> @@ -6,4 +6,4 @@ TEST_FILES := zram01.sh zram02.sh zram_lib.sh
> include ../lib.mk
> 
> clean:
> -	$(RM) err.log
> +	rm -f err.log
> --
> 1.8.3.4

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
