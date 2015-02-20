From: Rob Herring <robherring2-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC PATCH 1/3] eeprom: Add a simple EEPROM framework
Date: Fri, 20 Feb 2015 16:01:55 -0600
Message-ID: <CAL_Jsq+mvpRjYfL_8OseTDCB-6aBhwhNKLBQXXJeVQLDwWm8Nw@mail.gmail.com>
References: <1424365639-26634-1-git-send-email-srinivas.kandagatla@linaro.org>
 <1424365708-26681-1-git-send-email-srinivas.kandagatla@linaro.org>
 <CAL_Jsq+SeuoojgTpv1y_aPJ_jzDr3HqZhYEBQ3_vYGBHvcccug@mail.gmail.com> <54E78A31.9020306@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <54E78A31.9020306-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Srinivas Kandagatla <srinivas.kandagatla-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, Maxime Ripard <maxime.ripard-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>, Kumar Gala <galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, "linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Stephen Boyd <sboyd-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Mark Brown <broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Fri, Feb 20, 2015 at 1:25 PM, Srinivas Kandagatla
<srinivas.kandagatla-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> wrote:
>
>
> On 20/02/15 17:21, Rob Herring wrote:
>>
>> On Thu, Feb 19, 2015 at 11:08 AM, Srinivas Kandagatla
>> <srinivas.kandagatla-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> wrote:
>>>
>>> From: Maxime Ripard <maxime.ripard-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>
>>>
>>> Up until now, EEPROM drivers were stored in drivers/misc, where they all
>>> had to
>>> duplicate pretty much the same code to register a sysfs file, allow
>>> in-kernel
>>> users to access the content of the devices they were driving, etc.
>>>
>>> This was also a problem as far as other in-kernel users were involved,
>>> since
>>> the solutions used were pretty much different from on driver to another,
>>> there
>>> was a rather big abstraction leak.
>>>
>>> This introduction of this framework aims at solving this. It also
>>> introduces DT
>>> representation for consumer devices to go get the data they require (MAC
>>> Addresses, SoC/Revision ID, part numbers, and so on) from the EEPROMs.
>>>
>>> Having regmap interface to this framework would give much better
>>> abstraction for eeproms on different buses.
>>>
>>> Signed-off-by: Maxime Ripard <maxime.ripard-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>
>>> [srinivas.kandagatla: Moved to regmap based and cleanedup apis]
>>> Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
>>> ---
>>>   .../devicetree/bindings/eeprom/eeprom.txt          |  48 ++++
>>>   drivers/Kconfig                                    |   2 +
>>>   drivers/Makefile                                   |   1 +
>>>   drivers/eeprom/Kconfig                             |  19 ++
>>>   drivers/eeprom/Makefile                            |   9 +
>>>   drivers/eeprom/core.c                              | 290
>>> +++++++++++++++++++++
>>>   include/linux/eeprom-consumer.h                    |  73 ++++++
>>>   include/linux/eeprom-provider.h                    |  51 ++++
>>
>>
>> Who is going to be the maintainer for this?
>
>
> Am happy to be one.

So please add a MAINTAINERS entry.

[...]

>>> += Data consumers =
>>> +
>>> +Required properties:
>>> +
>>> +eeproms: List of phandle and data cell specifier triplet, one triplet
>>> +        for each data cell the device might be interested in. The
>>> +        triplet consists of the phandle to the eeprom provider, then
>>> +        the offset in byte within that storage device, and the length
>>> +        in byte of the data we care about.
>>
>>
>> The problem with this is it assumes you know who the consumer is and
>> that it is a DT node. For example, how would you describe a serial
>> number?
>
> Correct me if I miss understood.
> Is serial number any different?
> Am hoping that the eeprom consumer would be aware of offset and size of
> serial number in the eeprom
>
> Cant the consumer do:
>
> eeprom-consumer {
>         eeproms = <&at24 0 4>;
>         eeprom-names = "device-serial-number";

Yes, but who is "eeprom-consumer"? DT nodes generally describe a h/w
block, but it this case, the consumer depends on the OS, not the h/w.
I'm not saying you can't describe where things are, but I don't think
you should imply who is the consumer and doing so is unnecessarily
complicated.

Also, the layout of EEPROM is likely very much platform specific. Some
could have a more complex structure perhaps with key ids and linked
list structure.

I would do something more simple that is just a list of keys and their
location like this:

device-serial-number = <start size>;
key1 = <start size>;
key2 = <start size>;

Rob
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
