From: Cyrill Gorcunov <gorcunov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 3/3] selftests: kcmp build fails when invoked from
 kselftest target
Date: Wed, 11 Mar 2015 01:09:54 +0300
Message-ID: <20150310220954.GL30296@moon>
References: <cover.1426022048.git.shuahkh@osg.samsung.com>
 <80f321919d8d1f804c4933acac9b044d4c6626eb.1426022048.git.shuahkh@osg.samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <80f321919d8d1f804c4933acac9b044d4c6626eb.1426022048.git.shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Cc: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, tranmanphong-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Tue, Mar 10, 2015 at 04:00:59PM -0600, Shuah Khan wrote:
> kcmp Makefile doesn't have an explicit build rule. As a result,
> kcmp build fails, when it is run from top level Makefile target
> kselftest. Without the explicit rule, make works only when it is
> run in the current directory or from selftests directory. Add an
> explicit build rule to fix the problem. In addition, build fails
> as it can't find kcmp.h. Fix it by passing CFLAGS.
> 
> Signed-off-by: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
> ---
>  tools/testing/selftests/kcmp/Makefile | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/testing/selftests/kcmp/Makefile b/tools/testing/selftests/kcmp/Makefile
> index ff0eefd..83383eb 100644
> --- a/tools/testing/selftests/kcmp/Makefile
> +++ b/tools/testing/selftests/kcmp/Makefile
> @@ -1,7 +1,8 @@
>  CC := $(CROSS_COMPILE)$(CC)
> -CFLAGS += -I../../../../usr/include/
> +CFLAGS += -I../../../../include/uapi -I../../../../usr/include/
>  
> -all: kcmp_test
> +all:
> +	$(CC) $(CFLAGS) kcmp_test.c -o kcmp_test
>  
>  run_tests: all
>  	@./kcmp_test || echo "kcmp_test: [FAIL]"

Ho Shuah! Thanks for looking into it. I've a small question --
why kcmp_test prerequsite is dropped? As to me it should remain
here, except explicit build rule added.
