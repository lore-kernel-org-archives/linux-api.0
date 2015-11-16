From: Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>
Subject: Re: [PATCH RFD] selftests: create test-specific kconfig fragments
Date: Tue, 17 Nov 2015 10:42:57 +1100
Message-ID: <1447717377.23280.3.camel@ellerman.id.au>
References: <1447477033-7522-1-git-send-email-bamvor.zhangjian@linaro.org>
	 <7hpoz9a84f.fsf@linaro.org> <1447715190.23280.1.camel@ellerman.id.au>
	 <CAFy1USTNWoC_J0VgWEzA8f4WabgXgbAaBT=OPPWrz9M45gKK6A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAFy1USTNWoC_J0VgWEzA8f4WabgXgbAaBT=OPPWrz9M45gKK6A-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bamvor Zhang Jian <bamvor.zhangjian-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Kevin Hilman <khilman-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: linux-api <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org, Tyler Baker <tyler.baker-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Mark Brown <broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, dvhart-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Tue, 2015-11-17 at 07:30 +0800, Bamvor Zhang Jian wrote:
> On 11/17/2015 07:06 AM, Michael Ellerman wrote:
> > 
> > Before you do, do you want to try adding a top-level target that does the
> > merge, something like:
> > 
> >  $ make kselftest-mergeconfig
> > 
> > 
> > Or some other better name.

> Ok, Do you mean merge all the test config?

Yeah sorry that wasn't very clear. I meant that it would essentialy do your
logic to merge all the config fragments:

./scripts/kconfig/merge_config.sh .config tools/testing/selftests/*/config


You'll probably need to be more careful with $(srctree) vs $(objtree) etc. Have
a look at the merge_into_defconfig rule in arch/powerpc/Makefile for an
example.

cheers
