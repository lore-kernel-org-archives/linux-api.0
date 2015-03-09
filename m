From: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Subject: Re: [PATCH v3 7/7] selftests/mount: Use implicit rules
Date: Mon, 09 Mar 2015 17:41:38 -0600
Message-ID: <54FE2FB2.5090103@osg.samsung.com>
References: <1425465694-27095-1-git-send-email-mpe@ellerman.id.au> <1425465694-27095-7-git-send-email-mpe@ellerman.id.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1425465694-27095-7-git-send-email-mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, davej-rdkfGonbjUTCLXcRTR1eJlpr/1R2p/CL@public.gmane.org, mmarek-AlSwsSmVLrQ@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 03/04/2015 03:41 AM, Michael Ellerman wrote:
> There's no need to open-code the build rules, use the implicit ones.
> 
> This has the nice side effect of enabling cross compilation.
> 
> Signed-off-by: Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>
> ---
>  tools/testing/selftests/mount/Makefile | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/tools/testing/selftests/mount/Makefile b/tools/testing/selftests/mount/Makefile
> index a5b367f032ba..a6c62bedb0d9 100644
> --- a/tools/testing/selftests/mount/Makefile
> +++ b/tools/testing/selftests/mount/Makefile
> @@ -1,13 +1,13 @@
>  # Makefile for mount selftests.
>  
> -all: unprivileged-remount-test
> +TEST_PROGS := unprivileged-remount-test
> +
> +CFLAGS += -O2 -Wall
>  
> -unprivileged-remount-test: unprivileged-remount-test.c
> -	gcc -Wall -O2 unprivileged-remount-test.c -o unprivileged-remount-test
> +all: $(TEST_PROGS)
>  
>  include ../lib.mk
>  
> -TEST_PROGS := unprivileged-remount-test
>  override RUN_TESTS := if [ -f /proc/self/uid_map ] ; then ./unprivileged-remount-test ; fi
>  override EMIT_TESTS := echo "$(RUN_TESTS)"
>  

Nack. This change breaks make kselftest run. Test fails to
build.

thanks,
-- Shuah


-- 
Shuah Khan
Sr. Linux Kernel Developer
Open Source Innovation Group
Samsung Research America (Silicon Valley)
shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org | (970) 217-8978
