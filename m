From: Srinivas Kandagatla <srinivas.kandagatla-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v8 8/9] nvmem: sunxi: Move the SID driver to the nvmem
 framework
Date: Thu, 23 Jul 2015 16:48:42 +0100
Message-ID: <55B10CDA.2050801@linaro.org>
References: <1437403352-4091-1-git-send-email-srinivas.kandagatla@linaro.org> <1437403462-4432-1-git-send-email-srinivas.kandagatla@linaro.org> <2114639619.71276.1437496724946.JavaMail.open-xchange@oxbsltgw08.schlund.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <2114639619.71276.1437496724946.JavaMail.open-xchange-0SF9iQWekqLc2Cnrm9MUdsgmgJlYmuWJ@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Stefan Wahren <stefan.wahren-eS4NqCHxEME@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
Cc: wxt-TNX95d0MmH7DzftRWevZcw@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, sboyd-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, s.hauer-bIcnvbaLZ9MEGnE8C9+IrQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mporter-OWPKS81ov/FWk0Htik3J/w@public.gmane.org, linux-arm-msm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Maxime Ripard <maxime.ripard-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>, pantelis.antoniou-OWPKS81ov/FWk0Htik3J/w@public.gmane.org, Mark Brown <broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org



On 21/07/15 17:38, Stefan Wahren wrote:
> Hi Srinivas,
>
>> Srinivas Kandagatla <srinivas.kandagatla-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> hat am 20. Juli 2015 um
>> 16:44 geschrieben:
>>
>>
>> From: Maxime Ripard <maxime.ripard-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>
>>
>> Now that we have the nvmem framework, we can consolidate the common
>> driver code. Move the driver to the framework, and hopefully, it will
>> fix the sysfs file creation race.
>>
>> Signed-off-by: Maxime Ripard <maxime.ripard-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>
>> [srinivas.kandagatla: Moved to regmap based EEPROM framework]
>> Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
>> ---
>> Documentation/ABI/testing/sysfs-driver-sunxi-sid | 22 ---
>> .../bindings/misc/allwinner,sunxi-sid.txt | 17 ---
>> .../bindings/nvmem/allwinner,sunxi-sid.txt | 21 +++
>> drivers/misc/eeprom/Kconfig | 13 --
>> drivers/misc/eeprom/Makefile | 1 -
>> drivers/misc/eeprom/sunxi_sid.c | 156 --------------------
>> drivers/nvmem/Kconfig | 11 ++
>> drivers/nvmem/Makefile | 2 +
>> drivers/nvmem/sunxi_sid.c | 159 +++++++++++++++++++++
>> 9 files changed, 193 insertions(+), 209 deletions(-)
>> delete mode 100644 Documentation/ABI/testing/sysfs-driver-sunxi-sid
>> delete mode 100644
>> Documentation/devicetree/bindings/misc/allwinner,sunxi-sid.txt
>> create mode 100644
>> Documentation/devicetree/bindings/nvmem/allwinner,sunxi-sid.txt
>> delete mode 100644 drivers/misc/eeprom/sunxi_sid.c
>> create mode 100644 drivers/nvmem/sunxi_sid.c
>>
>> [...]
>> -static int sunxi_sid_probe(struct platform_device *pdev)
>> -{
>> - struct sunxi_sid_data *sid_data;
>> - struct resource *res;
>> - const struct of_device_id *of_dev_id;
>> - u8 *entropy;
>> - unsigned int i;
>> -
>> - sid_data = devm_kzalloc(&pdev->dev, sizeof(struct sunxi_sid_data),
>> - GFP_KERNEL);
>> - if (!sid_data)
>> - return -ENOMEM;
>> -
>> - res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>> - sid_data->reg_base = devm_ioremap_resource(&pdev->dev, res);
>> - if (IS_ERR(sid_data->reg_base))
>> - return PTR_ERR(sid_data->reg_base);
>> -
>> - of_dev_id = of_match_device(sunxi_sid_of_match, &pdev->dev);
>> - if (!of_dev_id)
>> - return -ENODEV;
>> - sid_data->keysize = (int)of_dev_id->data;
>> -
>> - platform_set_drvdata(pdev, sid_data);
>> -
>> - sid_bin_attr.size = sid_data->keysize;
>> - if (device_create_bin_file(&pdev->dev, &sid_bin_attr))
>> - return -ENODEV;
>> -
>> - entropy = kzalloc(sizeof(u8) * sid_data->keysize, GFP_KERNEL);
>> - for (i = 0; i < sid_data->keysize; i++)
>> - entropy[i] = sunxi_sid_read_byte(sid_data, i);
>> - add_device_randomness(entropy, sid_data->keysize);
>> - kfree(entropy);
>> -
>
> in case of porting a driver to a new framework, i would expect the same
> features.
> The ported driver do not add the Security ID to the device randomness.
>
> What's the reason for this difference?
Not sure why it was discarded in the first place, but I can put it back 
which will atleast add some data to random pool.

--srini
>
> Regards
> Stefan
>
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
