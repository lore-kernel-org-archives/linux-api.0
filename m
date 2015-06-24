From: Stefan Wahren <stefan.wahren-eS4NqCHxEME@public.gmane.org>
Subject: Re: [PATCH v6 0/9] Add simple NVMEM Framework via regmap.
Date: Wed, 24 Jun 2015 19:47:34 +0200 (CEST)
Message-ID: <1641569650.41238.1435168054323.JavaMail.open-xchange@oxbsltgw35.schlund.de>
References: <1435014459-26138-1-git-send-email-srinivas.kandagatla@linaro.org> <235181230.251177.1435088854197.JavaMail.open-xchange@oxbsltgw00.schlund.de> <558A7C92.2040102@linaro.org> <558AA2E2.1010606@i2se.com> <558AAA8D.8030209@linaro.org>
Reply-To: Stefan Wahren <stefan.wahren-eS4NqCHxEME@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <558AAA8D.8030209-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Srinivas Kandagatla <srinivas.kandagatla-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
Cc: wxt-TNX95d0MmH7DzftRWevZcw@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Kumar Gala <galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, sboyd-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, s.hauer-bIcnvbaLZ9MEGnE8C9+IrQ@public.gmane.org, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-msm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mporter-OWPKS81ov/FWk0Htik3J/w@public.gmane.org, Maxime Ripard <maxime.ripard-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>, pantelis.antoniou-OWPKS81ov/FWk0Htik3J/w@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mark Brown <broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hi Srinivas,

> Srinivas Kandagatla <srinivas.kandagatla-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> hat am 24. Juni 2015 um
> 15:03 geschrieben:
>
>
>
>
> On 24/06/15 13:30, Stefan Wahren wrote:
> >> >If the question is just about hexdump, then hexdump itself can read
> >> >file from given offset and size.
> > yes, this is my question at first. Let me show the difference between
> > the current implementation and my expectations as a user.
> >
> > $ hexdump /sys/class/nvmem/mxs-ocotp/nvmem
> >
> > Current implementation: dump the complete register range defined in DT
> >
> Its dumping the range which is specified in the provider regmap. If the
> requirement is to dump only particular range, this has to be made
> explicit while creating regmap, which is to specify the base address to
> start from "First data register" and max_register to be "Last data
> register "- "First data register"

i know about max_register, but i can't find the base address in regmap_config.

Do you mean struct regmap_access_table *rd_table ?

>
> > User expectation: dump only the data from OCOTP block
> >
> > Let me explain it for i.MX28 OCOTP
> >
> > 0x8002c000 // Start of OCOTP register block (defined in DT)
> >
> > 0x8002c020 // First data register
> >
> > 0x8002c290 // Last data register
> >
> > 0x8002dfff // End of OCOTP register block (defined in DT)
> >
> > My knowledge about regmap is limited, but how can i achieve that hexdump
> > give me only the data registers? From my understanding this should be
> > handled in regmap and not in the read function.
>
> Setup the base and regmap_config correctly in the provider driver before
> calling regmap_init_mmio().
>
> Let me know if you need more details.

Yes, please.

Stefan

>
> --srini
>
> >
> > Are my expectations about the raw access wrong?
> >
> >
>
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
