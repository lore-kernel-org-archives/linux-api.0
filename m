From: Andrew Lunn <andrew-g2DYL2Zd6BY@public.gmane.org>
Subject: Re: [PATCH v9 0/9] Add simple NVMEM Framework via regmap.
Date: Sun, 9 Aug 2015 17:19:16 +0200
Message-ID: <20150809151916.GF14271@lunn.ch>
References: <1437995567-11203-1-git-send-email-srinivas.kandagatla@linaro.org>
 <1438693367.3793.29.camel@pengutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1438693367.3793.29.camel-bIcnvbaLZ9MEGnE8C9+IrQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Srinivas Kandagatla <srinivas.kandagatla-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, stefan.wahren-eS4NqCHxEME@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, khilman-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, s.hauer-bIcnvbaLZ9MEGnE8C9+IrQ@public.gmane.org, sboyd-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mporter-OWPKS81ov/FWk0Htik3J/w@public.gmane.org, pantelis.antoniou-OWPKS81ov/FWk0Htik3J/w@public.gmane.org, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Mark Brown <broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-msm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, wxt-TNX95d0MmH7DzftRWevZcw@public.gmane.org
List-Id: linux-api@vger.kernel.org

Hi Srinivas

The AT24 eeprom driver contains the comment:

        /*                                                                                               
         * Export the EEPROM bytes through sysfs, since that's convenient.                               
         * By default, only root should see the data (maybe passwords etc)                               
         */

and as you would expect from this:

# ls -l ./devices/platform/soc/soc:aips-bus@40000000/40066000.i2c/i2c-0/0-0050/eeprom
-rw------- 1 root root 512 Aug  9 10:16 ./devices/platform/soc/soc:aips-bus@40000000/40066000.i2c/i2c-0/0-0050/eeprom

The AT25 and the MAX6875 driver are the same.

However nvmem has different defaults:

# ls -l ./devices/platform/soc/soc:aips-bus@40000000/40066000.i2c/i2c-0/0-0050/0-00500/nvmem
-rw-r--r-- 1 root root 0 Aug  9 10:16 ./devices/platform/soc/soc:aips-bus@40000000/40066000.i2c/i2c-0/0-0050/0-00500/nvmem

Has this been considered and discussed?

Thanks
    Andrew
