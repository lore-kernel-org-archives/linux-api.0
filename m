From: Srinivas Kandagatla <srinivas.kandagatla-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v9 0/9] Add simple NVMEM Framework via regmap.
Date: Mon, 10 Aug 2015 11:37:35 +0100
Message-ID: <55C87EEF.6020609@linaro.org>
References: <1437995567-11203-1-git-send-email-srinivas.kandagatla@linaro.org> <1438693367.3793.29.camel@pengutronix.de> <20150809151916.GF14271@lunn.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150809151916.GF14271-g2DYL2Zd6BY@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrew Lunn <andrew-g2DYL2Zd6BY@public.gmane.org>
Cc: stefan.wahren-eS4NqCHxEME@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, khilman-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, s.hauer-bIcnvbaLZ9MEGnE8C9+IrQ@public.gmane.org, sboyd-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mporter-OWPKS81ov/FWk0Htik3J/w@public.gmane.org, pantelis.antoniou-OWPKS81ov/FWk0Htik3J/w@public.gmane.org, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Mark Brown <broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-msm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, wxt-TNX95d0MmH7DzftRWevZcw@public.gmane.org
List-Id: linux-api@vger.kernel.org

Hi Andrew,

On 09/08/15 16:19, Andrew Lunn wrote:
> Hi Srinivas
>
> The AT24 eeprom driver contains the comment:
>
>          /*
>           * Export the EEPROM bytes through sysfs, since that's convenient.
>           * By default, only root should see the data (maybe passwords etc)
>           */
>
> and as you would expect from this:
>
> # ls -l ./devices/platform/soc/soc:aips-bus@40000000/40066000.i2c/i2c-0/0-0050/eeprom
> -rw------- 1 root root 512 Aug  9 10:16 ./devices/platform/soc/soc:aips-bus@40000000/40066000.i2c/i2c-0/0-0050/eeprom
>
> The AT25 and the MAX6875 driver are the same.
>
> However nvmem has different defaults:
>
> # ls -l ./devices/platform/soc/soc:aips-bus@40000000/40066000.i2c/i2c-0/0-0050/0-00500/nvmem
> -rw-r--r-- 1 root root 0 Aug  9 10:16 ./devices/platform/soc/soc:aips-bus@40000000/40066000.i2c/i2c-0/0-0050/0-00500/nvmem
>
Yes, nvmem by default sets the read permission for everyone S_IRUGO. 
Which was the most common use case.

> Has this been considered and discussed?
Thanks for bringing this up, No, we did not discuss this explicitly, but 
it should not be an issue to accommodate this. Provider still have 
flexibility to configure such things.

As a first patchset we wanted to keep the framework simple and add 
features as we move on.

Thanks,
srini
>
> Thanks
>      Andrew
>
