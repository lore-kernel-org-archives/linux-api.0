From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: Re: [RFC PATCH 1/3] eeprom: Add a simple EEPROM framework
Date: Fri, 20 Feb 2015 08:14:34 +0000
Message-ID: <54E6ECEA.7020604@linaro.org>
References: <1424365639-26634-1-git-send-email-srinivas.kandagatla@linaro.org> <1424365708-26681-1-git-send-email-srinivas.kandagatla@linaro.org> <54E69DB0.60701@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <54E69DB0.60701@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Stephen Boyd <sboyd@codeaurora.org>, linux-arm-kernel@lists.infradead.org
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>, Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>, Kumar Gala <galak@codeaurora.org>, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, devicetree@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, broonie@kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
List-Id: linux-api@vger.kernel.org



On 20/02/15 02:36, Stephen Boyd wrote:
> On 02/19/15 09:08, Srinivas Kandagatla wrote:
>> diff --git a/drivers/Kconfig b/drivers/Kconfig
>> index c70d6e4..d7afc82 100644
>> --- a/drivers/Kconfig
>> +++ b/drivers/Kconfig
>> @@ -184,4 +184,6 @@ source "drivers/thunderbolt/Kconfig"
>>
>>   source "drivers/android/Kconfig"
>>
>> +source "drivers/eeprom/Kconfig"
>> +
>>   endmenu
>> diff --git a/drivers/Makefile b/drivers/Makefile
>> index 527a6da..57eb5b0 100644
>> --- a/drivers/Makefile
>> +++ b/drivers/Makefile
>> @@ -165,3 +165,4 @@ obj-$(CONFIG_RAS)		+= ras/
>>   obj-$(CONFIG_THUNDERBOLT)	+= thunderbolt/
>>   obj-$(CONFIG_CORESIGHT)		+= coresight/
>>   obj-$(CONFIG_ANDROID)		+= android/
>> +obj-$(CONFIG_EEPROM)		+= eeprom/
>> diff --git a/drivers/eeprom/Kconfig b/drivers/eeprom/Kconfig
>> new file mode 100644
>> index 0000000..2c5452a
>> --- /dev/null
>> +++ b/drivers/eeprom/Kconfig
>> @@ -0,0 +1,19 @@
>> +menuconfig EEPROM
>> +	bool "EEPROM Support"
>> +	depends on OF
>
> Doesn't this need some sort of select REGMAP somewhere?
May be depends REGMAP would be good.

>
> Also, why do we need to use regmap for the eeprom framework read/write
> ops? I liked the simple eeprom::{read,write} API that Maxime had. The
> regmap part could be a regmap-eeprom driver that implements read/write
> ops like you've done in the core.
regmap bus does the same job.

The only reason for using regmap here is to have more generic drivers 
for eeprom providers based on different buses like mmio, i2c, spi...
As of today we could just make the qfprom eeprom provider as more 
generic eeprom-mmio provider. May be sunxi_sid could reuse it too with 
some effort.

In future It may be possible to have eeprom-i2c or eeprom-spi providers.

>

>> +
>> +struct eeprom_device {
>> +	struct regmap		*regmap;
>> +	int			stride;
>> +	size_t			size;
>> +	struct device		*dev;
>> +
>> +	/* Internal to framework */
>> +	struct device		edev;
>> +	int			id;
>> +	struct list_head	list;
>
> Should there be a module owner here to handle module removal?
>

Good point, we should do some reference counting.
