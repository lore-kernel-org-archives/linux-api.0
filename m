From: Bamvor Jian Zhang <bamvor.zhangjian@linaro.org>
Subject: Re: [PATCH v3 0/2] Create specific kconfig for kselftest
Date: Mon, 4 Jan 2016 18:34:45 +0800
Message-ID: <568A4AC5.1050703@linaro.org>
References: <1450346273-31633-1-git-send-email-bamvor.zhangjian@linaro.org>
 <1450395897.19696.0.camel@ellerman.id.au>
 <CAFy1USTM1B_pWuPUun+yrhcHspNUOm9_2giWwJgOaJvgWDsiEA@mail.gmail.com>
 <1451883424.14373.1.camel@ellerman.id.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1451883424.14373.1.camel@ellerman.id.au>
Sender: linux-kernel-owner@vger.kernel.org
To: Michael Ellerman <mpe@ellerman.id.au>, linux-api <linux-api@vger.kernel.org>
Cc: lkml <linux-kernel@vger.kernel.org>, linux-kbuild@vger.kernel.org, Shuah Khan <shuahkh@osg.samsung.com>, yann.morin.1998@free.fr, Kevin Hilman <khilman@linaro.org>, Tyler Baker <tyler.baker@linaro.org>, Mark Brown <broonie@kernel.org>, dvhart@infradead.org, Bamvor Zhang Jian <bamvor.zhangjian@linaro.org>
List-Id: linux-api@vger.kernel.org

Hi, Michael

On 01/04/2016 12:57 PM, Michael Ellerman wrote:
[...]
>> Do you mean "tools/testing/selftest/Makefile"? I try to do it but I could not
>> get the objtree and srctree if it is called directly(objtree and srctree is
>> defined in toplevel Makefile)
> 
> No I meant Makefile, the very top level Makefile.
> 
> There is already a kselftest target in there (line 1077), I meant we would add
> a kselftest-mergeconfig target in there.
I am trying to add it in top level Makefile, it says:
> make kselftest-mergeconfig
make[1]: *** No rule to make target 'kselftest-mergeconfig'.  Stop.
Makefile:553: recipe for target 'kselftest-mergeconfig' failed
make: *** [kselftest-mergeconfig] Error 2

01234567890123456789012345678901234567890123456789012345678901234567890123456789
It works when I get rid of the config at the end of this target. So, I guess
that this is because the "%config" in this Makefile. How should I overwrite
this wildcard?

Thanks

Bamvor

> 
> cheers
> 

-- 
-----------------------------------------
   arm64, kernel. opensuse
   blog: http://bjzhang.github.io
-----------------------------------------
