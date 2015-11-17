From: Bamvor Zhang Jian <bamvor.zhangjian-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH RFD] selftests: create test-specific kconfig fragments
Date: Tue, 17 Nov 2015 08:20:33 +0800
Message-ID: <CAFy1USRZYwLNFFHdnngga6kS+2Aj=c7v4ziLWTZLE8svvtrxLw@mail.gmail.com>
References: <1447477033-7522-1-git-send-email-bamvor.zhangjian@linaro.org>
	<7hpoz9a84f.fsf@linaro.org>
	<1447715190.23280.1.camel@ellerman.id.au>
	<CAFy1USTNWoC_J0VgWEzA8f4WabgXgbAaBT=OPPWrz9M45gKK6A@mail.gmail.com>
	<1447717377.23280.3.camel@ellerman.id.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1447717377.23280.3.camel-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>
Cc: Kevin Hilman <khilman-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-api <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org, Tyler Baker <tyler.baker-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Mark Brown <broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, dvhart-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org
List-Id: linux-api@vger.kernel.org

Hi, Michael

On 17 November 2015 at 07:42, Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org> wrote:
> On Tue, 2015-11-17 at 07:30 +0800, Bamvor Zhang Jian wrote:
>> On 11/17/2015 07:06 AM, Michael Ellerman wrote:
>> >
>> > Before you do, do you want to try adding a top-level target that does the
>> > merge, something like:
>> >
>> >  $ make kselftest-mergeconfig
>> >
>> >
>> > Or some other better name.
>
>> Ok, Do you mean merge all the test config?
>
> Yeah sorry that wasn't very clear. I meant that it would essentialy do your
> logic to merge all the config fragments:
>
> ./scripts/kconfig/merge_config.sh .config tools/testing/selftests/*/config
Yes, I agree with you.
>
>
> You'll probably need to be more careful with $(srctree) vs $(objtree) etc. Have
> a look at the merge_into_defconfig rule in arch/powerpc/Makefile for an
> example.
Yes, It is very useful for me.

Thanks

Bamvor
>
> cheers
>
