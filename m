From: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Subject: Re: [PATCH v3 6/7] selftests/mqueue: Use implicit rules
Date: Mon, 09 Mar 2015 17:37:40 -0600
Message-ID: <54FE2EC4.2050901@osg.samsung.com>
References: <1425465694-27095-1-git-send-email-mpe@ellerman.id.au> <1425465694-27095-6-git-send-email-mpe@ellerman.id.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1425465694-27095-6-git-send-email-mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>
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
>  tools/testing/selftests/mqueue/Makefile | 15 +++++++++------
>  1 file changed, 9 insertions(+), 6 deletions(-)
> 
> diff --git a/tools/testing/selftests/mqueue/Makefile b/tools/testing/selftests/mqueue/Makefile
> index 6ca7261b55dc..ed85a1d7ee36 100644
> --- a/tools/testing/selftests/mqueue/Makefile
> +++ b/tools/testing/selftests/mqueue/Makefile
> @@ -1,6 +1,11 @@
> -all:
> -	gcc -O2 mq_open_tests.c -o mq_open_tests -lrt
> -	gcc -O2 -o mq_perf_tests mq_perf_tests.c -lrt -lpthread -lpopt

Nack. I can't take this one either. This breaks make kselftest
run. mqueue fails to build.

-- Shuah

-- 
Shuah Khan
Sr. Linux Kernel Developer
Open Source Innovation Group
Samsung Research America (Silicon Valley)
shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org | (970) 217-8978
