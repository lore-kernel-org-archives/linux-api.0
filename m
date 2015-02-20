From: Russell King - ARM Linux <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>
Subject: Re: [RFC PATCH 1/3] eeprom: Add a simple EEPROM framework
Date: Fri, 20 Feb 2015 17:46:41 +0000
Message-ID: <20150220174641.GI8656@n2100.arm.linux.org.uk>
References: <1424365639-26634-1-git-send-email-srinivas.kandagatla@linaro.org>
 <1424365708-26681-1-git-send-email-srinivas.kandagatla@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1424365708-26681-1-git-send-email-srinivas.kandagatla-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Srinivas Kandagatla <srinivas.kandagatla-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Stephen Boyd <sboyd-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Kumar Gala <galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Maxime Ripard <maxime.ripard-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thu, Feb 19, 2015 at 05:08:28PM +0000, Srinivas Kandagatla wrote:
> +static struct class eeprom_class = {
> +	.name		= "eeprom",
> +	.dev_groups	= eeprom_dev_groups,
> +};
> +
> +int eeprom_register(struct eeprom_device *eeprom)
> +{
> +	int rval;
> +
> +	if (!eeprom->regmap || !eeprom->size) {
> +		dev_err(eeprom->dev, "Regmap not found\n");
> +		return -EINVAL;
> +	}
> +
> +	eeprom->id = ida_simple_get(&eeprom_ida, 0, 0, GFP_KERNEL);
> +	if (eeprom->id < 0)
> +		return eeprom->id;
> +
> +	eeprom->edev.class = &eeprom_class;
> +	eeprom->edev.parent = eeprom->dev;
> +	eeprom->edev.of_node = eeprom->dev ? eeprom->dev->of_node : NULL;
> +	dev_set_name(&eeprom->edev, "eeprom%d", eeprom->id);
> +
> +	device_initialize(&eeprom->edev);
> +
> +	dev_dbg(&eeprom->edev, "Registering eeprom device %s\n",
> +		dev_name(&eeprom->edev));
> +
> +	rval = device_add(&eeprom->edev);
> +	if (rval)
> +		return rval;
> +
> +	mutex_lock(&eeprom_list_mutex);
> +	list_add(&eeprom->list, &eeprom_list);
> +	mutex_unlock(&eeprom_list_mutex);
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL(eeprom_register);
> +
> +int eeprom_unregister(struct eeprom_device *eeprom)
> +{
> +	device_del(&eeprom->edev);
> +
> +	mutex_lock(&eeprom_list_mutex);
> +	list_del(&eeprom->list);
> +	mutex_unlock(&eeprom_list_mutex);
> +
> +	return 0;

There's problems with this.  "edev" is embedded into eeprom, and "edev"
is a refcounted structure - it has a lifetime, and the lifetime of
eeprom is thus determined by edev.

What this means is that calling eeprom_unregister() and then freeing
the eeprom structure is a potentially unsafe operation - the memory
backing edev must only be freed when the release method for the
struct device has been called.

> +struct eeprom_device {
> +	struct regmap		*regmap;
> +	int			stride;
> +	size_t			size;
> +	struct device		*dev;

Failing to understand and address the driver model life time issues is
a major blocker for this patch.  Sorry.

-- 
FTTC broadband for 0.8mile line: currently at 10.5Mbps down 400kbps up
according to speedtest.net.
