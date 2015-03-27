From: Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>
Subject: Re: [PATCH 5/5] kselftest: Add exit code defines
Date: Sat, 28 Mar 2015 09:59:38 +1100
Message-ID: <1427497178.3986.1.camel@ellerman.id.au>
References: <597c9eabcac5da9456d6cfd6de9117591d73385e.1427493640.git.dvhart@linux.intel.com>
	 <43a448183a340b61d91c711da4a75898e3ffd8f2.1427493640.git.dvhart@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <43a448183a340b61d91c711da4a75898e3ffd8f2.1427493640.git.dvhart-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Darren Hart <dvhart-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ingo Molnar <mingo-X9Un+BFzKDI@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Davidlohr Bueso <dave-h16yJtLeMjHk1uMJSBkQmQ@public.gmane.org>, KOSAKI Motohiro <kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Fri, 2015-03-27 at 15:17 -0700, Darren Hart wrote:
> Define the exit codes with KSFT_PASS and similar so tests can use these
> directly if they choose. Also enable harnesses and other tooling to use
> the defines instead of hardcoding the return codes.
 
+1

> diff --git a/tools/testing/selftests/kselftest.h b/tools/testing/selftests/kselftest.h
> index 572c888..ef1c80d 100644
> --- a/tools/testing/selftests/kselftest.h
> +++ b/tools/testing/selftests/kselftest.h
> @@ -13,6 +13,13 @@
>  #include <stdlib.h>
>  #include <unistd.h>
>  
> +/* define kselftest exit codes */
> +#define KSFT_PASS  0
> +#define KSFT_FAIL  1
> +#define KSFT_XFAIL 2
> +#define KSFT_XPASS 3
> +#define KSFT_SKIP  4
> +
>  /* counters */
>  struct ksft_count {
>  	unsigned int ksft_pass;
> @@ -40,23 +47,23 @@ static inline void ksft_print_cnts(void)
>  
>  static inline int ksft_exit_pass(void)
>  {
> -	exit(0);
> +	exit(KSFT_PASS);
>  }

Am I the only person who's bothered by the fact that these don't actually
return int?

cheers
