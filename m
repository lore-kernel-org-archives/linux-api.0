From: Srinivas Kandagatla <srinivas.kandagatla-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v8 2/9] nvmem: Add a simple NVMEM framework for consumers
Date: Wed, 22 Jul 2015 08:26:36 +0100
Message-ID: <55AF45AC.9040003@linaro.org>
References: <1437403352-4091-1-git-send-email-srinivas.kandagatla@linaro.org> <1437403403-4180-1-git-send-email-srinivas.kandagatla@linaro.org> <1590184041.70825.1437495942088.JavaMail.open-xchange@oxbsltgw08.schlund.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1590184041.70825.1437495942088.JavaMail.open-xchange-0SF9iQWekqLc2Cnrm9MUdsgmgJlYmuWJ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Stefan Wahren <stefan.wahren-eS4NqCHxEME@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
Cc: wxt-TNX95d0MmH7DzftRWevZcw@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, sboyd-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, s.hauer-bIcnvbaLZ9MEGnE8C9+IrQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mporter-OWPKS81ov/FWk0Htik3J/w@public.gmane.org, linux-arm-msm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Maxime Ripard <maxime.ripard-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>, pantelis.antoniou-OWPKS81ov/FWk0Htik3J/w@public.gmane.org, Mark Brown <broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Thanks Stefan,

On 21/07/15 17:25, Stefan Wahren wrote:
>> +
>> >+ addr = of_get_property(cell_np, "reg", &len);
>> >+ if (!addr || (len < 2 * sizeof(int))) {
> I'm not sure, but shouldn't be sizeof(u32) more portable?
>
yes it makes sense, I will change it.
>> >[...]
>> >+
>> >+ addr = of_get_property(cell_np, "bits", &len);
>> >+ if (addr && len == (2 * sizeof(int))) {
> dito
yep.

--srini
