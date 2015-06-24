From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: Re: [PATCH v6 0/9] Add simple NVMEM Framework via regmap.
Date: Wed, 24 Jun 2015 10:46:58 +0100
Message-ID: <558A7C92.2040102@linaro.org>
References: <1435014459-26138-1-git-send-email-srinivas.kandagatla@linaro.org> <235181230.251177.1435088854197.JavaMail.open-xchange@oxbsltgw00.schlund.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <235181230.251177.1435088854197.JavaMail.open-xchange@oxbsltgw00.schlund.de>
Sender: linux-arm-msm-owner@vger.kernel.org
To: Stefan Wahren <stefan.wahren@i2se.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-arm-kernel@lists.infradead.org
Cc: wxt@rock-chips.com, linux-api@vger.kernel.org, Kumar Gala <galak@codeaurora.org>, Rob Herring <robh+dt@kernel.org>, sboyd@codeaurora.org, arnd@arndb.de, s.hauer@pengutronix.de, linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org, mporter@konsulko.com, Maxime Ripard <maxime.ripard@free-electrons.com>, pantelis.antoniou@konsulko.com, devicetree@vger.kernel.org, Mark Brown <broonie@kernel.org>
List-Id: linux-api@vger.kernel.org



On 23/06/15 20:47, Stefan Wahren wrote:
>> 0001000
>> >
> i want to port OCOTP driver for MXS, which hasn't MMIO. From my understanding
That's cool.

> hexdump would readout the complete register range defined in provider DT node.
>
> How can i achieve that hexdump only reads the data area within the register
> range?

If the question is just about hexdump, then hexdump itself can read file 
from given offset and size.

But I believe the real question is "How can we dump each nvmem cell 
independently"

In one of my replies I mentioned that am planning to add sysfs entries 
under /sys/class/nvmem/<provider>/cells/

ex:
for qfprom tsens calibration it would look like:

$ hexdump /sys/class/nvmem/qfprom0/cells/tsens_calibration

0000000 e000 0c00 0c00 0000 0c00
...

Is that what you guys are looking for?

--srini
>
> Stefan
