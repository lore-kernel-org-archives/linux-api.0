From: ebiederm@xmission.com (Eric W. Biederman)
Subject: Re: [PATCH] selftests/mount: output error messages when mount test fail
Date: Thu, 02 Apr 2015 13:56:23 -0500
Message-ID: <87r3s2qrzc.fsf@x220.int.ebiederm.org>
References: <1427957214-40367-1-git-send-email-zhenzhang.zhang@huawei.com>
	<551CE72E.3050303@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <551CE72E.3050303@huawei.com> (Zhang Zhen's message of "Thu, 2
	Apr 2015 14:52:30 +0800")
Sender: linux-kernel-owner@vger.kernel.org
To: Zhang Zhen <zhenzhang.zhang@huawei.com>
Cc: linux-api@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, shuahkh@osg.samsung.com, mpe@ellerman.id.au
List-Id: linux-api@vger.kernel.org

Zhang Zhen <zhenzhang.zhang@huawei.com> writes:

> Without this patch, if /proc/self/uid_map is not exist,
> the mount test case will fail and no any prompting.

The intent was not to fail if /proc/self/uid_map is missing but to skip
the test because it is not applicable.

Making this an error seems wrong.  Even if I did mess up the shell
script error propagation and made it an error by accident.

> After applied this patch, the case will prompt why it fail.
> Just as follows:
> root@kernel-host:/opt/kernel> make -C tools/testing/selftests TARGETS=mount run_tests
> make: Entering directory `/opt/kernel/tools/testing/selftests'
> for TARGET in mount; do \
>                 make -C $TARGET; \
>         done;
> make[1]: Entering directory `/opt/kernel/tools/testing/selftests/mount'
> make[1]: Nothing to be done for `all'.
> make[1]: Leaving directory `/opt/kernel/tools/testing/selftests/mount'
> for TARGET in mount; do \
>                 make -C $TARGET run_tests; \
>         done;
> make[1]: Entering directory `/opt/kernel/tools/testing/selftests/mount'
> ERROR: No /proc/self/uid_map exist
> make[1]: Leaving directory `/opt/kernel/tools/testing/selftests/mount'
> make: Leaving directory `/opt/kernel/tools/testing/selftests'
>
> Signed-off-by: Zhang Zhen <zhenzhang.zhang@huawei.com>
> ---
>  tools/testing/selftests/mount/Makefile | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
>
> diff --git a/tools/testing/selftests/mount/Makefile b/tools/testing/selftests/mount/Makefile
> index a5b367f..b3266db 100644
> --- a/tools/testing/selftests/mount/Makefile
> +++ b/tools/testing/selftests/mount/Makefile
> @@ -8,7 +8,12 @@ unprivileged-remount-test: unprivileged-remount-test.c
>  include ../lib.mk
>
>  TEST_PROGS := unprivileged-remount-test
> -override RUN_TESTS := if [ -f /proc/self/uid_map ] ; then ./unprivileged-remount-test ; fi
> +override RUN_TESTS :=  @if [ -f /proc/self/uid_map ] ; \
> +			then	\
> +				./unprivileged-remount-test ; \
> +			else	\
> +				echo "ERROR: No /proc/self/uid_map exist" ; \
> +			fi
>  override EMIT_TESTS := echo "$(RUN_TESTS)"
>
>  clean:
