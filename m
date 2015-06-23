From: Stefan Wahren <stefan.wahren-eS4NqCHxEME@public.gmane.org>
Subject: Re: [PATCH v6 0/9] Add simple NVMEM Framework via regmap.
Date: Tue, 23 Jun 2015 21:47:34 +0200 (CEST)
Message-ID: <235181230.251177.1435088854197.JavaMail.open-xchange@oxbsltgw00.schlund.de>
References: <1435014459-26138-1-git-send-email-srinivas.kandagatla@linaro.org>
Reply-To: Stefan Wahren <stefan.wahren-eS4NqCHxEME@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1435014459-26138-1-git-send-email-srinivas.kandagatla-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Srinivas Kandagatla <srinivas.kandagatla-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
Cc: wxt-TNX95d0MmH7DzftRWevZcw@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Kumar Gala <galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, sboyd-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, s.hauer-bIcnvbaLZ9MEGnE8C9+IrQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-msm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mporter-OWPKS81ov/FWk0Htik3J/w@public.gmane.org, Maxime Ripard <maxime.ripard-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>, pantelis.antoniou-OWPKS81ov/FWk0Htik3J/w@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mark Brown <broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hi Srinivas,

> Srinivas Kandagatla <srinivas.kandagatla-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> hat am 23. Juni 2015 um
> 01:07 geschrieben:
>
>
> [...]
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
>
> userspace interface: binary file in /sys/class/nvmem/*/nvmem
>
> ex:
> hexdump /sys/class/nvmem/qfprom0/nvmem
>
> 0000000 0000 0000 0000 0000 0000 0000 0000 0000
> *
> 00000a0 db10 2240 0000 e000 0c00 0c00 0000 0c00
> 0000000 0000 0000 0000 0000 0000 0000 0000 0000
> ...
> *
> 0001000
>

i want to port OCOTP driver for MXS, which hasn't MMIO. From my understanding
hexdump would readout the complete register range defined in provider DT node.

How can i achieve that hexdump only reads the data area within the register
range?

Stefan
