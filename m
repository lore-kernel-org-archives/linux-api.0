From: Srinivas Kandagatla <srinivas.kandagatla-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 1/7] eeprom: Add a simple EEPROM framework for eeprom
 providers
Date: Tue, 24 Mar 2015 09:18:14 +0000
Message-ID: <55112BD6.2070600@linaro.org>
References: <1426240157-2383-1-git-send-email-srinivas.kandagatla@linaro.org> <1426240214-2434-1-git-send-email-srinivas.kandagatla@linaro.org> <20150323210918.GS14954@sirena.org.uk> <55108E2B.7050305@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <55108E2B.7050305-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mark Brown <broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Maxime Ripard <maxime.ripard-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>, Kumar Gala <galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Stephen Boyd <sboyd-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, linux-arm-msm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org



On 23/03/15 22:05, Srinivas Kandagatla wrote:
>
>
> On 23/03/15 21:09, Mark Brown wrote:
>> On Fri, Mar 13, 2015 at 09:50:14AM +0000, Srinivas Kandagatla wrote:
>>
>> A couple of *very* minor points below, otherwise this looks OK to me.
>>
> Thankyou for the review.
>
>>> +struct eeprom_device *eeprom_register(struct eeprom_config *config)
>>> +{
>>> +    struct eeprom_device *eeprom;
>>> +    int rval;
>>> +
>>> +    if (!config->regmap || !config->size) {
>>> +        dev_err(config->dev, "Regmap not found\n");
>>> +        return ERR_PTR(-EINVAL);
>>> +    }
>>
>> You have a struct device in the config and the regmap API has
>> dev_get_regmap() which for most devices that don't have multiple regmaps
>> will give the right regmap.  It would be nice to support this as a
>> convenience for users.
> Yes, sure that makes sense, I will give it a try.
>
I did try your suggestion, by which I could remove the regmap from 
config. One thing I did not like was eeprom-core getting size/stride 
info directly from providers and regmap from regmap apis. I was 
wondering if we could take a step further and introduce new regmap 
helpers like

regmap_get_size(regmap)
regmap_get_stride(regmap)

Which would be give eeprom-core the size and stride info, doing this way 
would cut down regmap related things from eeprom_config structure to 
minimal and also the source of information would come from just regmap apis.


--srini

>>
>>> +    eeprom = kzalloc(sizeof(*eeprom), GFP_KERNEL);
>>> +    if (!eeprom)
>>> +        return ERR_PTR(-ENOMEM);
>>
>> ...
>>
>>> +    rval = device_add(&eeprom->dev);
>>> +    if (rval)
>>> +        return ERR_PTR(rval);
>>
>> Don't you need a kfree() if device_add() fails?
> I will fix it in next version.
>
> --srini
>>
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
