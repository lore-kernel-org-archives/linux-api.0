From: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Subject: Re: [PATCH v3 5/7] selftests/timers: Use implicit rules
Date: Mon, 09 Mar 2015 17:17:11 -0600
Message-ID: <54FE29F7.2050803@osg.samsung.com>
References: <1425465694-27095-1-git-send-email-mpe@ellerman.id.au> <1425465694-27095-5-git-send-email-mpe@ellerman.id.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1425465694-27095-5-git-send-email-mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>
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
>  tools/testing/selftests/timers/Makefile | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/tools/testing/selftests/timers/Makefile b/tools/testing/selftests/timers/Makefile
> index 149cee3b7b8a..87340405e4b3 100644
> --- a/tools/testing/selftests/timers/Makefile
> +++ b/tools/testing/selftests/timers/Makefile
> @@ -1,9 +1,9 @@
> -all:
> -	gcc posix_timers.c -o posix_timers -lrt
> -
>  TEST_PROGS := posix_timers
> +LDLIBS += -lrt
> +
> +all: $(TEST_PROGS)

I can't take this patch. This breaks make kselftest
run. With this change timers test fails to build

make[2]: Nothing to be done for 'all'.
make[2]: *** No rule to make target 'posix_timers', needed by 'all'.  Stop.


thanks,
-- Shuah


-- 
Shuah Khan
Sr. Linux Kernel Developer
Open Source Innovation Group
Samsung Research America (Silicon Valley)
shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org | (970) 217-8978
