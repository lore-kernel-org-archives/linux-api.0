From: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Subject: Re: [PATCH] selftests/vm: fix link error for transhuge-stress test
Date: Wed, 07 Jan 2015 12:21:18 -0700
Message-ID: <54AD872E.9060802@osg.samsung.com>
References: <1420655754-10076-1-git-send-email-Andrej.Skvortzov@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1420655754-10076-1-git-send-email-Andrej.Skvortzov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrey Skvortsov <andrej.skvortzov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Konstantin Khlebnikov <koct9i-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 01/07/2015 11:35 AM, Andrey Skvortsov wrote:
> add -lrt to fix undefined reference to `clock_gettime'
> 
> Signed-off-by: Andrey Skvortsov <andrej.skvortzov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
>  tools/testing/selftests/vm/Makefile |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/vm/Makefile b/tools/testing/selftests/vm/Makefile
> index 4c4b1f6..077828c 100644
> --- a/tools/testing/selftests/vm/Makefile
> +++ b/tools/testing/selftests/vm/Makefile
> @@ -7,7 +7,7 @@ BINARIES += transhuge-stress
>  
>  all: $(BINARIES)
>  %: %.c
> -	$(CC) $(CFLAGS) -o $@ $^
> +	$(CC) $(CFLAGS) -o $@ $^ -lrt
>  
>  run_tests: all
>  	@/bin/sh ./run_vmtests || (echo "vmtests: [FAIL]"; exit 1)
> 

Andrey,

I don't see any undefined references when I build. Curious if it is
specific to your env??

Please include the warning in the change log
when you fix warnings in the future.

-- Shuah

-- 
Shuah Khan
Sr. Linux Kernel Developer
Open Source Innovation Group
Samsung Research America (Silicon Valley)
shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org | (970) 217-8978
