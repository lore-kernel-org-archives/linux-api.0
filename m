From: Bamvor Jian Zhang <bamvor.zhangjian@linaro.org>
Subject: [RFD] How to support KBUILD_OUTPUT for kselftest?
Date: Thu, 31 Dec 2015 11:13:15 +0800
Message-ID: <56849D4B.6010008@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: lkml <linux-kernel@vger.kernel.org>, linux-api@vger.kernel.org
Cc: Michael Ellerman <mpe@ellerman.id.au>, Mark Brown <broonie@kernel.org>, Kevin Hilman <khilman@kernel.org>, Shuah Khan <shuahkh@osg.samsung.com>, Tyler Baker <tyler.baker@linaro.org>, dvhart@infradead.org, Bamvor Zhang Jian <bamvor.zhangjian@linaro.org>
List-Id: linux-api@vger.kernel.org

Hi,

I am trying to improve cross compiling support for kselftest recently. Right
now I am stuck when I want to enable KBUILD_OUTPUT(O=xxx). It exist in wiki of
kselftest[1]. Hope it is not a duplicated work.

It seems that only perf tools(tools/perf) support it. And I could know that the
following Makefile are called when building perf:
tools/Makefile
tools/perf/Makefile
tools/perf/Makefile.perf
tools/build/Makefile.build

But I could not get the idea that how to do it for kselftest. Is there any
existed infrastructure I could use?

I am appreciated if there is any suggestions or ideas. Thanks in advance.

Regards

Bamvor

[1] https://kselftest.wiki.kernel.org/support_cross-compilation
