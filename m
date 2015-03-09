From: Srinivas Kandagatla <srinivas.kandagatla-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v1 1/6] eeprom: Add a simple EEPROM framework for eeprom
 providers
Date: Mon, 09 Mar 2015 07:13:17 +0000
Message-ID: <54FD480D.40604@linaro.org>
References: <1425548685-12887-1-git-send-email-srinivas.kandagatla@linaro.org> <1425548741-12930-1-git-send-email-srinivas.kandagatla@linaro.org> <20150307150035.GN28806@sirena.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150307150035.GN28806-GFdadSzt00ze9xe1eoZjHA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mark Brown <broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Maxime Ripard <maxime.ripard-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>, Kumar Gala <galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Stephen Boyd <sboyd-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, andrew-g2DYL2Zd6BY@public.gmane.org, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
List-Id: linux-api@vger.kernel.org



On 07/03/15 15:00, Mark Brown wrote:
> On Thu, Mar 05, 2015 at 09:45:41AM +0000, Srinivas Kandagatla wrote:
>
>> +
>> +	return eeprom;
>> +}
>> +EXPORT_SYMBOL(eeprom_register);
>
> This framework uses regmap but regmap is EXPORT_SYMBOL_GPL() and this is
> using EXPORT_SYMBOL().
>
Thanks for spotting this, I will fix this in next version.

>> +int eeprom_unregister(struct eeprom_device *eeprom)
>> +{
>> +	mutex_lock(&eeprom_mutex);
>> +	if (atomic_read(&eeprom->users)) {
>> +		mutex_unlock(&eeprom_mutex);
>
> Atomic reads and a mutex - isn't the mutex enough?  Atomics are
> generally a recipie for bugs due to the complexity in using them.
Yes, you are right as long as we protect users variable with mutex, 
using atomic is really redundant, will fix it in next version.
>
