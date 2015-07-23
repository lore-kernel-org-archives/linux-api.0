From: Stefan Wahren <stefan.wahren@i2se.com>
Subject: Re: [PATCH v8 1/9] nvmem: Add a simple NVMEM framework for nvmem
 providers
Date: Thu, 23 Jul 2015 17:26:40 +0200
Message-ID: <55B107B0.5010706@i2se.com>
References: <1437403352-4091-1-git-send-email-srinivas.kandagatla@linaro.org>
 <1437403392-4136-1-git-send-email-srinivas.kandagatla@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <1437403392-4136-1-git-send-email-srinivas.kandagatla@linaro.org>
Sender: linux-arm-msm-owner@vger.kernel.org
To: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>, linux-arm-kernel@lists.infradead.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Rob Herring <robh+dt@kernel.org>, Mark Brown <broonie@kernel.org>, s.hauer@pengutronix.de, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, devicetree@vger.kernel.org, linux-arm-msm@vger.kernel.org, arnd@arndb.de, sboyd@codeaurora.org, pantelis.antoniou@konsulko.com, mporter@konsulko.com, wxt@rock-chips.com, Maxime Ripard <maxime.ripard@free-electrons.com>
List-Id: linux-api@vger.kernel.org

Hi Srinivas,

Am 20.07.2015 um 16:43 schrieb Srinivas Kandagatla:
> This patch adds just providers part of the framework just to enable easy
> review.
>
> Up until now, NVMEM drivers like eeprom were stored in drivers/misc,
> where they all had to duplicate pretty much the same code to register
> a sysfs file, allow in-kernel users to access the content of the devices
> they were driving, etc.
>
> This was also a problem as far as other in-kernel users were involved,
> since the solutions used were pretty much different from on driver to
> another, there was a rather big abstraction leak.
>
> This introduction of this framework aims at solving this. It also
> introduces DT representation for consumer devices to go get the data
> they require (MAC Addresses, SoC/Revision ID, part numbers, and so on)
> from the nvmems.
>
> Having regmap interface to this framework would give much better
> abstraction for nvmems on different buses.
>
> Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
> [Maxime Ripard: intial version of eeprom framework]
> Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
> ---
>  drivers/Kconfig                |   2 +
>  drivers/Makefile               |   1 +
>  drivers/nvmem/Kconfig          |  13 ++
>  drivers/nvmem/Makefile         |   6 +
>  drivers/nvmem/core.c           | 384 +++++++++++++++++++++++++++++++++++++++++
>  include/linux/nvmem-consumer.h |  23 +++
>  include/linux/nvmem-provider.h |  47 +++++
>  7 files changed, 476 insertions(+)
>  create mode 100644 drivers/nvmem/Kconfig
>  create mode 100644 drivers/nvmem/Makefile
>  create mode 100644 drivers/nvmem/core.c
>  create mode 100644 include/linux/nvmem-consumer.h
>  create mode 100644 include/linux/nvmem-provider.h

i've tested this patch with my mxs-ocotp driver [1].

So you can add

Tested-by: Stefan Wahren <stefan.wahren@i2se.com>

Regards
Stefan
