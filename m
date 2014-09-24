From: Davidlohr Bueso <dave@stgolabs.net>
Subject: Re: [PATCH v2 1/7] selftests: add kselftest framework for uniform
 test reporting
Date: Wed, 24 Sep 2014 10:09:04 +0200
Message-ID: <1411546144.30630.10.camel@linux-t7sj.site>
References: <cover.1411506121.git.shuahkh@osg.samsung.com>
	 <0b1961bd4d2104beafd2e8c1a17690f6efe14a61.1411506121.git.shuahkh@osg.samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <0b1961bd4d2104beafd2e8c1a17690f6efe14a61.1411506121.git.shuahkh@osg.samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Shuah Khan <shuahkh@osg.samsung.com>
Cc: akpm@linux-foundation.org, gregkh@linuxfoundation.org, colin.king@canonical.com, ebiederm@xmission.com, serge.hallyn@ubuntu.com, thierry@linux.vnet.ibm.com, luto@amacapital.net, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Tue, 2014-09-23 at 15:32 -0600, Shuah Khan wrote:
> Add kselftest framework for tests to use. This is a light
> weight framework provides a set of interfaces to report test
> results. Tests can use these interfaces to report pass, and
> fail cases as well as when failure is due to configuration
> problems such as missing modules, or when a test that is should
> fail, fails as expected, and a test that should fail, passes.
> The framework uses POSIX standard return codes for reporting
> results to address the needs of users that want to run the kernel
> selftests from their user-space test suites and want to know why a
> test failed. In addition, the framework includes interfaces to use
> to report test statistics on number of tests passed and failed.
> 
> Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
> ---
>  tools/testing/selftests/kselftest.h | 41 +++++++++++++++++++++++++++++++++++++
>  1 file changed, 41 insertions(+)
>  create mode 100644 tools/testing/selftests/kselftest.h
> 
> diff --git a/tools/testing/selftests/kselftest.h b/tools/testing/selftests/kselftest.h
> new file mode 100644
> index 0000000..c73fc2c
> --- /dev/null
> +++ b/tools/testing/selftests/kselftest.h
> @@ -0,0 +1,41 @@
> +/*
> + * kselftest.h: kselftest framework return codes to include from
> + *		 selftests.
> + *
> + * Copyright (c) 2014 Shuah Khan <shuahkh@osg.samsung.com>
> + * Copyright (c) 2014 Samsung Electronics Co., Ltd.
> + *
> + * This file is released under the GPLv2.
> + */
> +#ifndef __KSELFTEST_H
> +#define __KSELFTEST_H
> +
> +#include <stdlib.h>
> +#include <unistd.h>
> +
> +/* counters */
> +static int ksft_pass;
> +static int ksft_fail;
> +static int ksft_xfail;
> +static int ksft_xpass;
> +static int ksft_xskip;

unsigned int?

> +static inline void ksft_inc_pass_cnt(void) { ksft_pass++; }
> +static inline void ksft_inc_fail_cnt(void) { ksft_fail++; }
> +static inline void ksft_inc_xfail_cnt(void) { ksft_xfail++; }
> +static inline void ksft_inc_xpass_cnt(void) { ksft_xpass++; }
> +static inline void ksft_inc_xskip_cnt(void) { ksft_xskip++; }

It would probably make sense to have the counters in a structures,
something like: struct ksft_counter { ... } ksft_cnt;

Then just pass it around the proposed functions as arguments. That also
minimizes a bit the global variables and would allow you to easily
change it in the future.

> +static inline void ksft_print_cnts(void)
> +{
> +	printf("Pass: %d Fail: %d Xfail: %d Xpass: %d, Xskip: %d\n",
> +		ksft_pass, ksft_fail, ksft_xfail, ksft_xpass, ksft_xskip);
> +}

Same here, just do:

static inline void ksft_print_cnts(struct ksft_counter counters)
{ 
	... 
}

Otherwise looks good.

> +static inline int ksft_exit_pass(void) { exit(0); }
> +static inline int ksft_exit_fail(void) { exit(1); }
> +static inline int ksft_exit_xfail(void) { exit(2); }
> +static inline int ksft_exit_xpass(void) { exit(3); }
> +static inline int ksft_exit_skip(void) { exit(4); }
> +
> +#endif /* __KSELFTEST_H */
