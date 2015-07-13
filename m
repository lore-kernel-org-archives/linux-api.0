From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: Re: [PATCH v7 2/9] nvmem: Add a simple NVMEM framework for consumers
Date: Mon, 13 Jul 2015 20:24:02 +0100
Message-ID: <55A41052.3000604@linaro.org>
References: <1436521427-10568-1-git-send-email-srinivas.kandagatla@linaro.org> <1436521495-10728-1-git-send-email-srinivas.kandagatla@linaro.org> <1510509759.163664.1436814382477.JavaMail.open-xchange@oxbsltgw06.schlund.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1510509759.163664.1436814382477.JavaMail.open-xchange@oxbsltgw06.schlund.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Stefan Wahren <stefan.wahren@i2se.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-arm-kernel@lists.infradead.org
Cc: wxt@rock-chips.com, linux-api@vger.kernel.org, Kumar Gala <galak@codeaurora.org>, Rob Herring <robh+dt@kernel.org>, sboyd@codeaurora.org, arnd@arndb.de, s.hauer@pengutronix.de, linux-kernel@vger.kernel.org, mporter@konsulko.com, linux-arm-msm@vger.kernel.org, Maxime Ripard <maxime.ripard@free-electrons.com>, pantelis.antoniou@konsulko.com, Mark Brown <broonie@kernel.org>, devicetree@vger.kernel.org
List-Id: linux-api@vger.kernel.org



On 13/07/15 20:06, Stefan Wahren wrote:
>> -#include <linux/nvmem-provider.h>
>> >#include <linux/export.h>
>> >#include <linux/fs.h>
>> >#include <linux/idr.h>
>> >#include <linux/init.h>
>> >-#include <linux/regmap.h>
> please avoid such changes in your patch series. This should be fixed in the
> first patch.
Sure, I know why this happened, the headers were re-ordered in this 
patch.. I will take care of it.

--srini
