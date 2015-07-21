From: Stefan Wahren <stefan.wahren@i2se.com>
Subject: Re: [PATCH v8 2/9] nvmem: Add a simple NVMEM framework for
 consumers
Date: Tue, 21 Jul 2015 18:25:42 +0200 (CEST)
Message-ID: <1590184041.70825.1437495942088.JavaMail.open-xchange@oxbsltgw08.schlund.de>
References: <1437403352-4091-1-git-send-email-srinivas.kandagatla@linaro.org> <1437403403-4180-1-git-send-email-srinivas.kandagatla@linaro.org>
Reply-To: Stefan Wahren <stefan.wahren@i2se.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1437403403-4180-1-git-send-email-srinivas.kandagatla@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-arm-kernel@lists.infradead.org
Cc: wxt@rock-chips.com, linux-api@vger.kernel.org, Rob Herring <robh+dt@kernel.org>, sboyd@codeaurora.org, arnd@arndb.de, s.hauer@pengutronix.de, linux-kernel@vger.kernel.org, mporter@konsulko.com, linux-arm-msm@vger.kernel.org, Maxime Ripard <maxime.ripard@free-electrons.com>, pantelis.antoniou@konsulko.com, Mark Brown <broonie@kernel.org>, devicetree@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Hi Srinivas,

> Srinivas Kandagatla <srinivas.kandagatla@linaro.org> hat am 20. Juli 2015 um
> 16:43 geschrieben:
>
>
> This patch adds just consumers part of the framework just to enable easy
> review.
>
> Up until now, nvmem drivers were stored in drivers/misc, where they all
> had to duplicate pretty much the same code to register a sysfs file,
> allow in-kernel users to access the content of the devices they were
> driving, etc.
>
> This was also a problem as far as other in-kernel users were involved,
> since the solutions used were pretty much different from on driver to
> another, there was a rather big abstraction leak.
>
> This introduction of this framework aims at solving this. It also
> introduces DT representation for consumer devices to go get the data they
> require (MAC Addresses, SoC/Revision ID, part numbers, and so on) from
> the nvmems.
>
> Having regmap interface to this framework would give much better
> abstraction for nvmems on different buses.
>
> Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
> [Maxime Ripard: intial version of the framework]
> Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
> ---
> drivers/nvmem/core.c | 415 +++++++++++++++++++++++++++++++++++++++++
> include/linux/nvmem-consumer.h | 61 ++++++
> 2 files changed, 476 insertions(+)
>
> diff --git a/drivers/nvmem/core.c b/drivers/nvmem/core.c
> index bde5528..de14c36 100644
> --- a/drivers/nvmem/core.c
> +++ b/drivers/nvmem/core.c
> [...]
> +struct nvmem_cell *of_nvmem_cell_get(struct device_node *np,
> + const char *name)
> +{
> + struct device_node *cell_np, *nvmem_np;
> + struct nvmem_cell *cell;
> + struct nvmem_device *nvmem;
> + const __be32 *addr;
> + int rval, len, index;
> +
> + index = of_property_match_string(np, "nvmem-cell-names", name);
> +
> + cell_np = of_parse_phandle(np, "nvmem-cells", index);
> + if (!cell_np)
> + return ERR_PTR(-EINVAL);
> +
> + nvmem_np = of_get_next_parent(cell_np);
> + if (!nvmem_np)
> + return ERR_PTR(-EINVAL);
> +
> + nvmem = __nvmem_device_get(nvmem_np, NULL, NULL);
> + if (IS_ERR(nvmem))
> + return ERR_CAST(nvmem);
> +
> + addr = of_get_property(cell_np, "reg", &len);
> + if (!addr || (len < 2 * sizeof(int))) {

I'm not sure, but shouldn't be sizeof(u32) more portable?

> [...]
> +
> + addr = of_get_property(cell_np, "bits", &len);
> + if (addr && len == (2 * sizeof(int))) {

dito

Regards
Stefan
