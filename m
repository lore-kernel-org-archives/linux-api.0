From: Davidlohr Bueso <dave-h16yJtLeMjHk1uMJSBkQmQ@public.gmane.org>
Subject: Re: [PATCH 1/7] selftests: add header file for test exit code
 defines
Date: Tue, 16 Sep 2014 18:04:01 +0200
Message-ID: <1410883441.4630.9.camel@linux-t7sj.site>
References: <1410820442-8774-1-git-send-email-shuahkh@osg.samsung.com>
	 <1410820442-8774-2-git-send-email-shuahkh@osg.samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1410820442-8774-2-git-send-email-shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Cc: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, colin.king-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org, thierry-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, felipensp-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Mon, 2014-09-15 at 16:33 -0600, Shuah Khan wrote:
> Add a new header file that defines exit codes for individual
> tests to use to communicate test results. These defines are
> intended to provide a common and uniform way for selftests
> to report results. pass/fail/xfail/xpass/skip/unsupported
> are defined.
> 
> Signed-off-by: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
> ---
>  tools/testing/selftests/kselftest.h | 20 ++++++++++++++++++++
>  1 file changed, 20 insertions(+)
>  create mode 100644 tools/testing/selftests/kselftest.h
> 
> diff --git a/tools/testing/selftests/kselftest.h b/tools/testing/selftests/kselftest.h
> new file mode 100644
> index 0000000..1b1c9cb
> --- /dev/null
> +++ b/tools/testing/selftests/kselftest.h
> @@ -0,0 +1,20 @@
> +/*
> + * kselftest.h - kselftest framework return codes to include from
> + *		 selftests.
> + *
> + * Copyright (c) 2014 Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
> + * Copyright (c) 2014 Samsung Electronics Co., Ltd.
> + *
> + * This file is released under the GPLv2.
> + */
> +#ifndef __KSELFTEST_H
> +#define __KSELFTEST_H
> +
> +#define	EXIT_PASS		0
> +#define	EXIT_FAIL		1
> +#define	EXIT_XFAIL		2
> +#define	EXIT_XPASS		3
> +#define	EXIT_SKIP		4
> +#define	EXIT_UNSUPPORTED	EXIT_SKIP

Looks to me like a potential name clashes here.

What's the difference between XFAIL/XPASS and regular FAIL/PASS (I don't
see the former used in patchset either, only PASS/FAIL)? What's the
purpose of EXIT_SKIP? I think overall these should be commented.

Also, in the bigger picture, I'm guessing you have a reason for not
recycling errno and inventing your own exit codes... How do you plan on
using these? In addition I'm seeing things like:

-       exit(EXIT_FAILURE);
+       exit(EXIT_FAIL);

which isn't a very good idea in general.
