From: Russell King - ARM Linux <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>
Subject: Re: [RFC PATCH 2/3] eeprom: sunxi: Move the SID driver to the eeprom
 framework
Date: Fri, 20 Feb 2015 17:47:50 +0000
Message-ID: <20150220174750.GJ8656@n2100.arm.linux.org.uk>
References: <1424365639-26634-1-git-send-email-srinivas.kandagatla@linaro.org>
 <1424365720-26725-1-git-send-email-srinivas.kandagatla@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1424365720-26725-1-git-send-email-srinivas.kandagatla-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Srinivas Kandagatla <srinivas.kandagatla-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Stephen Boyd <sboyd-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Kumar Gala <galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Maxime Ripard <maxime.ripard-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thu, Feb 19, 2015 at 05:08:40PM +0000, Srinivas Kandagatla wrote:
> +static int sunxi_sid_probe(struct platform_device *pdev)
> +{
> +	const struct of_device_id *device;
> +	struct eeprom_sid *sid;
> +	struct resource *res;
> +	struct eeprom_device *eeprom;
> +	struct device *dev = &pdev->dev;
> +	int rval;
> +
> +	sid = devm_kzalloc(dev, sizeof(*sid), GFP_KERNEL);
> +	if (!sid)
> +		return -ENOMEM;
> +
> +	eeprom = &sid->eeprom;
...
> +	rval = eeprom_register(eeprom);
> +	if (rval)
> +		return rval;
...
> +static int sunxi_sid_remove(struct platform_device *pdev)
> +{
> +	struct eeprom_device *eeprom = platform_get_drvdata(pdev);
> +
> +	return eeprom_unregister(eeprom);

As pointed out in the previous patch, this is unsafe as the eeprom
structure contains a struct device.

-- 
FTTC broadband for 0.8mile line: currently at 10.5Mbps down 400kbps up
according to speedtest.net.
