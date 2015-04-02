From: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Subject: Re: [PATCH] selftests/mount: output error messages when mount test
 fail
Date: Thu, 02 Apr 2015 12:03:58 -0600
Message-ID: <551D848E.4070008@osg.samsung.com>
References: <1427957214-40367-1-git-send-email-zhenzhang.zhang@huawei.com> <551CE72E.3050303@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <551CE72E.3050303-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Zhang Zhen <zhenzhang.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 04/02/2015 12:52 AM, Zhang Zhen wrote:
> Without this patch, if /proc/self/uid_map is not exist,
> the mount test case will fail and no any prompting.
> 
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
> Signed-off-by: Zhang Zhen <zhenzhang.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
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
> 

This patch introduces syntax error:

Running tests in mount
========================================
./run_kselftest.sh: line 53: syntax error near unexpected token `then'
./run_kselftest.sh: line 53: `@if [ -f /proc/self/uid_map ] ; then
./unprivileged-remount-test ; else echo ERROR: No /proc/self/uid_map
exist ; fi'

You will see it if you run kselftest_install.sh from
tools/testing/selftests and then attempt to run the tests using the
generated
run_kselftest.sh script.

Could you please fix this and re-send the patch.

thanks,
-- Shuah


-- 
Shuah Khan
Sr. Linux Kernel Developer
Open Source Innovation Group
Samsung Research America (Silicon Valley)
shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org | (970) 217-8978
