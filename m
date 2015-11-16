From: Bamvor Zhang Jian <bamvor.zhangjian-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH RFD] selftests: create test-specific kconfig fragments
Date: Tue, 17 Nov 2015 07:40:40 +0800
Message-ID: <CAFy1USR03zPJtnJpN1+vHc24w73xU7Ggi2=LWCH8SYAPZ69dMg@mail.gmail.com>
References: <1447477033-7522-1-git-send-email-bamvor.zhangjian@linaro.org>
	<7hpoz9a84f.fsf@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <7hpoz9a84f.fsf-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kevin Hilman <khilman-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: linux-api <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org, Tyler Baker <tyler.baker-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Mark Brown <broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>, dvhart-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 17 November 2015 at 06:32, Kevin Hilman <khilman-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> wrote:
> Hi Bamvor,
>
> Bamvor Jian Zhang <bamvor.zhangjian-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> writes:
>
>> There is a discussion about improving the usability of kselftest by
>> creating test-specific kconfig in recent kernel Summit. Furthormore,
>> there are different approaches to do it:
>>
>> 1) keep test-specific kconfig fragments inside each selftest so that
>> merge_configs.sh could build up a kernel that can test the specific
>> or all feature(s).
>>
>> 2) In the main menu, have an additional option/flag for each feature
>> that should be enabled when ksefltests are wanted.  Similar to the
>> CONFIG_COMPILE_TEST flag.
>>
>> This patch try to do option 1. Hope it is a good start for
>> discussion. User could use these configs with merge_config.sh script:
>
> For broader discussion, could you please resend and include LKML?
Oh, sorry miss LKML. I will resend it.

Regards

Bamvor
>
> Thanks,
>
> Kevin
