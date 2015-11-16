From: Kevin Hilman <khilman-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH RFD] selftests: create test-specific kconfig fragments
Date: Mon, 16 Nov 2015 14:32:00 -0800
Message-ID: <7hpoz9a84f.fsf@linaro.org>
References: <1447477033-7522-1-git-send-email-bamvor.zhangjian@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1447477033-7522-1-git-send-email-bamvor.zhangjian-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
	(Bamvor Jian Zhang's message of "Sat, 14 Nov 2015 12:57:13 +0800")
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bamvor Jian Zhang <bamvor.zhangjian-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org, tyler.baker-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org, dvhart-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org
List-Id: linux-api@vger.kernel.org

Hi Bamvor,

Bamvor Jian Zhang <bamvor.zhangjian-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> writes:

> There is a discussion about improving the usability of kselftest by
> creating test-specific kconfig in recent kernel Summit. Furthormore,
> there are different approaches to do it:
>
> 1) keep test-specific kconfig fragments inside each selftest so that
> merge_configs.sh could build up a kernel that can test the specific
> or all feature(s).
>
> 2) In the main menu, have an additional option/flag for each feature
> that should be enabled when ksefltests are wanted.  Similar to the
> CONFIG_COMPILE_TEST flag.
>
> This patch try to do option 1. Hope it is a good start for
> discussion. User could use these configs with merge_config.sh script:

For broader discussion, could you please resend and include LKML?

Thanks,

Kevin
