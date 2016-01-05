From: Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>
Subject: Re: [PATCH v3 0/2] Create specific kconfig for kselftest
Date: Tue, 05 Jan 2016 11:17:48 +1100
Message-ID: <1451953068.12837.6.camel@ellerman.id.au>
References: <1450346273-31633-1-git-send-email-bamvor.zhangjian@linaro.org>
	 <1450395897.19696.0.camel@ellerman.id.au>
	 <CAFy1USTM1B_pWuPUun+yrhcHspNUOm9_2giWwJgOaJvgWDsiEA@mail.gmail.com>
	 <1451883424.14373.1.camel@ellerman.id.au> <568A4AC5.1050703@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <568A4AC5.1050703-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bamvor Jian Zhang <bamvor.zhangjian-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-api <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-kbuild-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, yann.morin.1998-GANU6spQydw@public.gmane.org, Kevin Hilman <khilman-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Tyler Baker <tyler.baker-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Mark Brown <broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, dvhart-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, mmarek-IBi9RG/b67k@public.gmane.orglinux-kbuild-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Mon, 2016-01-04 at 18:34 +0800, Bamvor Jian Zhang wrote:
> On 01/04/2016 12:57 PM, Michael Ellerman wrote:
> [...]
> >
> > No I meant Makefile, the very top level Makefile.
> >
> > There is already a kselftest target in there (line 1077), I meant we would add
> > a kselftest-mergeconfig target in there.
>
> I am trying to add it in top level Makefile, it says:

> $ make kselftest-mergeconfig
> make[1]: *** No rule to make target 'kselftest-mergeconfig'.  Stop.
> Makefile:553: recipe for target 'kselftest-mergeconfig' failed
> make: *** [kselftest-mergeconfig] Error 2
>
> It works when I get rid of the config at the end of this target. So, I guess
> that this is because the "%config" in this Makefile. How should I overwrite
> this wildcard?

Yes you're right that is the problem.

If you call it 'kselftest-merge' it works.

I'm not sure there's an easy way to fix it. For now maybe just call it
'kselftest-merge' or something, to avoid the name clash.

CC'ing Michal in case he has any ideas.

cheers
