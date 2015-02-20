From: Srinivas Kandagatla <srinivas.kandagatla-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC PATCH 1/3] eeprom: Add a simple EEPROM framework
Date: Fri, 20 Feb 2015 19:25:37 +0000
Message-ID: <54E78A31.9020306@linaro.org>
References: <1424365639-26634-1-git-send-email-srinivas.kandagatla@linaro.org> <1424365708-26681-1-git-send-email-srinivas.kandagatla@linaro.org> <CAL_Jsq+SeuoojgTpv1y_aPJ_jzDr3HqZhYEBQ3_vYGBHvcccug@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAL_Jsq+SeuoojgTpv1y_aPJ_jzDr3HqZhYEBQ3_vYGBHvcccug-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Rob Herring <robherring2-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, Maxime Ripard <maxime.ripard-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>, Kumar Gala <galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, "linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Stephen Boyd <sboyd-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Mark Brown <broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
List-Id: linux-api@vger.kernel.org



On 20/02/15 17:21, Rob Herring wrote:
> On Thu, Feb 19, 2015 at 11:08 AM, Srinivas Kandagatla
> <srinivas.kandagatla-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> wrote:
>> From: Maxime Ripard <maxime.ripard-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>
>>
>> Up until now, EEPROM drivers were stored in drivers/misc, where they all had to
>> duplicate pretty much the same code to register a sysfs file, allow in-kernel
>> users to access the content of the devices they were driving, etc.
>>
>> This was also a problem as far as other in-kernel users were involved, since
>> the solutions used were pretty much different from on driver to another, there
>> was a rather big abstraction leak.
>>
>> This introduction of this framework aims at solving this. It also introduces DT
>> representation for consumer devices to go get the data they require (MAC
>> Addresses, SoC/Revision ID, part numbers, and so on) from the EEPROMs.
>>
>> Having regmap interface to this framework would give much better
>> abstraction for eeproms on different buses.
>>
>> Signed-off-by: Maxime Ripard <maxime.ripard-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>
>> [srinivas.kandagatla: Moved to regmap based and cleanedup apis]
>> Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
>> ---
>>   .../devicetree/bindings/eeprom/eeprom.txt          |  48 ++++
>>   drivers/Kconfig                                    |   2 +
>>   drivers/Makefile                                   |   1 +
>>   drivers/eeprom/Kconfig                             |  19 ++
>>   drivers/eeprom/Makefile                            |   9 +
>>   drivers/eeprom/core.c                              | 290 +++++++++++++++++++++
>>   include/linux/eeprom-consumer.h                    |  73 ++++++
>>   include/linux/eeprom-provider.h                    |  51 ++++
>
> Who is going to be the maintainer for this?

Am happy to be one.

>
>>   8 files changed, 493 insertions(+)
>>   create mode 100644 Documentation/devicetree/bindings/eeprom/eeprom.txt
>>   create mode 100644 drivers/eeprom/Kconfig
>>   create mode 100644 drivers/eeprom/Makefile
>>   create mode 100644 drivers/eeprom/core.c
>>   create mode 100644 include/linux/eeprom-consumer.h
>>   create mode 100644 include/linux/eeprom-provider.h
>>
>> diff --git a/Documentation/devicetree/bindings/eeprom/eeprom.txt b/Documentation/devicetree/bindings/eeprom/eeprom.txt
>> new file mode 100644
>> index 0000000..9ec1ec2
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/eeprom/eeprom.txt
>
> Please make bindings a separate patch.
Sure, Will do it in next version.

>
>> @@ -0,0 +1,48 @@
>> += EEPROM Data Device Tree Bindings =
>> +
>> +This binding is intended to represent the location of hardware
>> +configuration data stored in EEPROMs.
>> +
>> +On a significant proportion of boards, the manufacturer has stored
>> +some data on an EEPROM-like device, for the OS to be able to retrieve
>> +these information and act upon it. Obviously, the OS has to know
>> +about where to retrieve these data from, and where they are stored on
>> +the storage device.
>> +
>> +This document is here to document this.
>> +
>> += Data providers =
>> +
>> +Required properties:
>> +#eeprom-cells: Number of cells in an eeprom specifier; The common
>> +               case is 2.
>
> We already have eeproms in DTs, it would be nice to be able to support
> them with this framework as well.

Yes, I can see more than 60% of them are atmel,at24* eeproms in DT. We 
have some plans to migrate at24 and at25 eeproms to this framework once 
the the framework itself is accepted.

>
>> +
>> +For example:
>> +
>> +       at24: eeprom@42 {
>> +               #eeprom-cells = <2>;
>> +       };
>> +
>> += Data consumers =
>> +
>> +Required properties:
>> +
>> +eeproms: List of phandle and data cell specifier triplet, one triplet
>> +        for each data cell the device might be interested in. The
>> +        triplet consists of the phandle to the eeprom provider, then
>> +        the offset in byte within that storage device, and the length
>> +        in byte of the data we care about.
>
> The problem with this is it assumes you know who the consumer is and
> that it is a DT node. For example, how would you describe a serial
> number?
Correct me if I miss understood.
Is serial number any different?
Am hoping that the eeprom consumer would be aware of offset and size of 
serial number in the eeprom

Cant the consumer do:

eeprom-consumer {
	eeproms = <&at24 0 4>;
	eeprom-names = "device-serial-number";
};

--srini

>
> Rob
>
