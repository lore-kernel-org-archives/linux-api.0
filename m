From: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Subject: Re: [PATCH v3 01/11] stm class: Introduce an abstraction for System Trace Module devices
Date: Thu, 30 Jul 2015 10:16:19 +0300
Message-ID: <87si869ku4.fsf@ashishki-desk.ger.corp.intel.com>
References: <1436177344-16751-1-git-send-email-alexander.shishkin@linux.intel.com> <1436177344-16751-2-git-send-email-alexander.shishkin@linux.intel.com> <CAAfSe-vOgnMXCy6fb8yuQ0O_5x1L1QtCmGjNjH+OtGAg6KJHrg@mail.gmail.com> <877fpjkseh.fsf@ashishki-desk.ger.corp.intel.com> <CAAfSe-vgFSxA7OX7DSOB4XXdsan_3PWne0-16kSKZv_8HkHjgg@mail.gmail.com> <87vbd29mm6.fsf@ashishki-desk.ger.corp.intel.com> <CAAfSe-vBnqC4QNMXLK2H2b8XUAiXz5qk8BO90Y=a5azfqWe+nw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAAfSe-vBnqC4QNMXLK2H2b8XUAiXz5qk8BO90Y=a5azfqWe+nw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Chunyan Zhang <zhang.lyra@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Mathieu Poirier <mathieu.poirier@linaro.org>, peter.lachner@intel.com, norbert.schulz@intel.com, keven.boell@intel.com, yann.fouassier@intel.com, laurent.fert@intel.com, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>, Chunyan Zhang <zhang.chunyan@linaro.org>, Mark Brown <broonie@kernel.org>
List-Id: linux-api@vger.kernel.org

Chunyan Zhang <zhang.lyra@gmail.com> writes:

> The code has already been submitted like I said in the earlier emails,
> you may refer [1].
>
> Thanks,
> Chunyan
>
> [1] https://lkml.org/lkml/2015/2/4/729

This code does the following (pasting from that patch):

in stm_probe():

drvdata = devm_kzalloc(dev, sizeof(*drvdata), GFP_KERNEL);

... something irrelevant ...

ret = clk_prepare_enable(drvdata->clk);

... something irrelevant ...

clk_disable_unprepare(drvdata->clk);

... something irrelevant ...

drvdata->clk = adev->pclk;

How is this supposed to even work?

Regards,
--
Alex
