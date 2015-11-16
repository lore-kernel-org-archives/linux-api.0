From: Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>
Subject: Re: [PATCH RFD] selftests: create test-specific kconfig fragments
Date: Tue, 17 Nov 2015 10:06:30 +1100
Message-ID: <1447715190.23280.1.camel@ellerman.id.au>
References: <1447477033-7522-1-git-send-email-bamvor.zhangjian@linaro.org>
	 <7hpoz9a84f.fsf@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <7hpoz9a84f.fsf-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kevin Hilman <khilman-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Bamvor Jian Zhang <bamvor.zhangjian-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org, tyler.baker-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, dvhart-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Mon, 2015-11-16 at 14:32 -0800, Kevin Hilman wrote:
> Hi Bamvor,
> 
> Bamvor Jian Zhang <bamvor.zhangjian-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> writes:
> 

> > There is a discussion about improving the usability of kselftest by
> > creating test-specific kconfig in recent kernel Summit. Furthormore,
> > there are different approaches to do it:
> > 
> > 1) keep test-specific kconfig fragments inside each selftest so that
> > merge_configs.sh could build up a kernel that can test the specific
> > or all feature(s).
> > 
> > 2) In the main menu, have an additional option/flag for each feature
> > that should be enabled when ksefltests are wanted.  Similar to the
> > CONFIG_COMPILE_TEST flag.
> > 
> > This patch try to do option 1. Hope it is a good start for
> > discussion. User could use these configs with merge_config.sh script:
> 
> For broader discussion, could you please resend and include LKML?

Yeah good idea.

Before you do, do you want to try adding a top-level target that does the
merge, something like:

 $ make kselftest-mergeconfig


Or some other better name.

cheers
