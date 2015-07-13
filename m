From: Stefan Wahren <stefan.wahren-eS4NqCHxEME@public.gmane.org>
Subject: Re: [PATCH v7 0/9] Add simple NVMEM Framework via regmap.
Date: Mon, 13 Jul 2015 20:54:25 +0200 (CEST)
Message-ID: <1984575203.163267.1436813665815.JavaMail.open-xchange@oxbsltgw06.schlund.de>
References: <1436521427-10568-1-git-send-email-srinivas.kandagatla@linaro.org>
Reply-To: Stefan Wahren <stefan.wahren-eS4NqCHxEME@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1436521427-10568-1-git-send-email-srinivas.kandagatla-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Srinivas Kandagatla <srinivas.kandagatla-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
Cc: wxt-TNX95d0MmH7DzftRWevZcw@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Kumar Gala <galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, sboyd-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, s.hauer-bIcnvbaLZ9MEGnE8C9+IrQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mporter-OWPKS81ov/FWk0Htik3J/w@public.gmane.org, linux-arm-msm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, pantelis.antoniou-OWPKS81ov/FWk0Htik3J/w@public.gmane.org, Mark Brown <broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ezequiel-30ULvvUtt6G51wMPkGsGjgyUoB5FGQPZ@public.gmane.org
List-Id: linux-api@vger.kernel.org

Hi Srinivas,

[add Ezequiel Garcia to CC]

> Srinivas Kandagatla <srinivas.kandagatla-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> hat am 10. Juli 2015 um
> 11:43 geschrieben:
>
>
> Hi Greg,
>
> This patchset adds a new simple NVMEM framework to kernel, and it is tested
> with various drivers like "QCOM thermal sensors", "QCOM cpr driver",
> "begal bone cape manager" and few more on the way.
>
> Thankyou all for providing inputs and comments on previous versions of this
> patchset. Here is the v7 of the patchset addressing all the issues raised as
> part of previous versions review.
>
> Up until now, NVMEM drivers like eeprom were stored in drivers/misc, where
> they
> all had to duplicate pretty much the same code to register a sysfs file, allow
> in-kernel users to access the content of the devices they were driving, etc.
> This was also a problem as far as other in-kernel users were involved, since
> the solutions used were pretty much different from on driver to another, there
> was a rather big abstraction leak.

i only want to mention that there are more places of NVMEM drivers like:

drivers/mfd/ab3100-otp.c
drivers/soc/tegra/fuse/*.c

>
> Introduction of this framework aims at solving this. It also introduces DT
> representation for consumer devices to go get the data they require (MAC
> Addresses, SoC/Revision ID, part numbers, and so on) from the NVMEMs.
>
> After learning few things about QCOM qfprom and other eeprom/efuses, which
> has packed fields at bit level. Which makes it important to add support to
> such memories. This version adds support to this type of non volatile
> memories by adding support to bit level nvmem-cells.
>
> Having regmap interface to this framework would give much better
> abstraction for nvmems on different buses.
>
> patch 1-4 Introduces the NVMEM framework.
> Patch 5-6 Adds Qualcomm specific qfprom driver.
> Patch 7 migrates an existing driver to nvmem framework.
> Patch 8 adds entry in MAINTAINERS.
>
> Its also possible to migrate other nvmem drivers to this framework, and I
> think
> some of them already posted patches based on this framework.
>
> Providers APIs:
> nvmem_register/unregister();

How do i get the cell info from the devicetree into the nvmem_config?

I expected a function something like of_nvmem_cell_info_get() in the Providers
API.

>
> Consumers APIs:
> Cell based apis for both DT/Non-DT:
> nvmem_cell_get()/nvmem_cell_put();
> devm_nvmem_cell_get()/devm_nvmem_cell_put();
> of_nvmem_cell_get()
> nvmem_cell_read()/nvmem_cell_write();
>
> Raw byte access apis for both DT/non-DT.
> nvmem_device_get()/nvmem_device_put()
> devm_nvmem_device_get()/nvmem_device_put()
> of_nvmem_device_get()
>
> nvmem_device_read()/nvmem_device_write();
> nvmem_device_cell_read()/nvmem_device_cell_write();
>
> Device Tree:
>
> /* Provider */
> qfprom: qfprom@00700000 {
> ...
>
> /* Data cells */
> tsens_calibration: calib@404 {
> reg = <0x404 0x10>;
> };
>
> tsens_calibration_bckp: calib_bckp@504 {
> reg = <0x504 0x11>;
> bit-offset = 6;
> nbits = 128;
> };
>
> pvs_version: pvs-version@6 {
> reg = <0x6 0x2>
> bit-offset = 7;
> nbits = 2;
> };
>
> speed_bin: speed-bin@c{
> reg = <0xc 0x1>;
> bit-offset = 2;
> nbits = 3;
>
> };
> ...
> };
> /* Consumer */
> tsens {
> ...
> nvmem-cells = <&tsens_calibration>;
> nvmem-cell-names = "calibration";
> };
>
> userspace interface: binary file in /sys/bus/nvmem/devices/*/nvmem
>
> ex:
> hexdump /sys/bus/nvmem/devices/qfprom0/nvmem
>
> 0000000 0000 0000 0000 0000 0000 0000 0000 0000
> *
> 00000a0 db10 2240 0000 e000 0c00 0c00 0000 0c00
> 0000000 0000 0000 0000 0000 0000 0000 0000 0000
> ...
> *
> 0001000

Since we're entering userspace the behavior should be clear.

How do we treat register gaps? Fill them with zero?

Best regards
Stefan
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
