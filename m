From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: Re: [PATCH v7 0/9] Add simple NVMEM Framework via regmap.
Date: Mon, 13 Jul 2015 20:35:56 +0100
Message-ID: <55A4131C.7040700@linaro.org>
References: <1436521427-10568-1-git-send-email-srinivas.kandagatla@linaro.org>
 <1984575203.163267.1436813665815.JavaMail.open-xchange@oxbsltgw06.schlund.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <1984575203.163267.1436813665815.JavaMail.open-xchange@oxbsltgw06.schlund.de>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Stefan Wahren <stefan.wahren@i2se.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-arm-kernel@lists.infradead.org
Cc: devicetree@vger.kernel.org, arnd@arndb.de, ezequiel@vanguardiasur.com.ar, linux-api@vger.kernel.org, s.hauer@pengutronix.de, sboyd@codeaurora.org, linux-kernel@vger.kernel.org, pantelis.antoniou@konsulko.com, Rob Herring <robh+dt@kernel.org>, Mark Brown <broonie@kernel.org>, Kumar Gala <galak@codeaurora.org>, mporter@konsulko.com, linux-arm-msm@vger.kernel.org, wxt@rock-chips.com
List-Id: linux-api@vger.kernel.org



On 13/07/15 19:54, Stefan Wahren wrote:
> Hi Srinivas,
>
> [add Ezequiel Garcia to CC]
>
>> Srinivas Kandagatla <srinivas.kandagatla@linaro.org> hat am 10. Juli 2015 um
>> 11:43 geschrieben:
>>
>>
>> Hi Greg,
>>
>> This patchset adds a new simple NVMEM framework to kernel, and it is tested
>> with various drivers like "QCOM thermal sensors", "QCOM cpr driver",
>> "begal bone cape manager" and few more on the way.
>>
>> Thankyou all for providing inputs and comments on previous versions of this
>> patchset. Here is the v7 of the patchset addressing all the issues raised as
>> part of previous versions review.
>>
>> Up until now, NVMEM drivers like eeprom were stored in drivers/misc, where
>> they
>> all had to duplicate pretty much the same code to register a sysfs file, allow
>> in-kernel users to access the content of the devices they were driving, etc.
>> This was also a problem as far as other in-kernel users were involved, since
>> the solutions used were pretty much different from on driver to another, there
>> was a rather big abstraction leak.
>
> i only want to mention that there are more places of NVMEM drivers like:
>
> drivers/mfd/ab3100-otp.c
> drivers/soc/tegra/fuse/*.c

Thanks for mentioning.

>
>>
>> Introduction of this framework aims at solving this. It also introduces DT
>> representation for consumer devices to go get the data they require (MAC
>> Addresses, SoC/Revision ID, part numbers, and so on) from the NVMEMs.
>>
>> After learning few things about QCOM qfprom and other eeprom/efuses, which
>> has packed fields at bit level. Which makes it important to add support to
>> such memories. This version adds support to this type of non volatile
>> memories by adding support to bit level nvmem-cells.
>>
>> Having regmap interface to this framework would give much better
>> abstraction for nvmems on different buses.
>>
>> patch 1-4 Introduces the NVMEM framework.
>> Patch 5-6 Adds Qualcomm specific qfprom driver.
>> Patch 7 migrates an existing driver to nvmem framework.
>> Patch 8 adds entry in MAINTAINERS.
>>
>> Its also possible to migrate other nvmem drivers to this framework, and I
>> think
>> some of them already posted patches based on this framework.
>>
>> Providers APIs:
>> nvmem_register/unregister();
>
> How do i get the cell info from the devicetree into the nvmem_config?
>
Not sure what is the real use-case here, But this is how it is supposed 
to work.

cellinfo in nvmem_config is used to pass cell information in non-dt 
style to the core. The core would parse it and convert into nvmem-cells. 
Am not sure why would you want to do other way round. Could you explain 
the real use case here?


> I expected a function something like of_nvmem_cell_info_get() in the Providers
> API.


>
...

>> userspace interface: binary file in /sys/bus/nvmem/devices/*/nvmem
>>
>> ex:
>> hexdump /sys/bus/nvmem/devices/qfprom0/nvmem
>>
>> 0000000 0000 0000 0000 0000 0000 0000 0000 0000
>> *
>> 00000a0 db10 2240 0000 e000 0c00 0c00 0000 0c00
>> 0000000 0000 0000 0000 0000 0000 0000 0000 0000
>> ...
>> *
>> 0001000
>
> Since we're entering userspace the behavior should be clear.
>
> How do we treat register gaps? Fill them with zero?
nvmem file would read full nvmem size which is passed to it as regmap. 
So It would dump whatever the provider returns.


--srini
>
> Best regards
> Stefan
>
