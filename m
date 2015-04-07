From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: Re: [PATCH v4 05/10] eeprom: Add bindings for simple eeprom framework
Date: Tue, 07 Apr 2015 18:35:49 +0100
Message-ID: <55241575.7040809@linaro.org>
References: <1427752492-17039-1-git-send-email-srinivas.kandagatla@linaro.org> <1427752679-17261-1-git-send-email-srinivas.kandagatla@linaro.org> <20150406133208.GH30984@beef> <CAL_Jsq++9pyJMLXssgyz2WRU4e7ikT_6FwzWMo1fKS82FJvEyg@mail.gmail.com> <20150406150442.GA26319@beef>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <20150406150442.GA26319@beef>
Sender: linux-arm-msm-owner@vger.kernel.org
To: Matt Porter <mporter@konsulko.com>, Rob Herring <robherring2@gmail.com>
Cc: "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Sascha Hauer <s.hauer@pengutronix.de>, Stephen Boyd <sboyd@codeaurora.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Rob Herring <robh+dt@kernel.org>, Mark Brown <broonie@kernel.org>, Kumar Gala <galak@codeaurora.org>, Maxime Ripard <maxime.ripard@free-electrons.com>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>, linux-arm-msm <linux-arm-msm@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

Thanks Matt and Rob for review,

On 06/04/15 16:04, Matt Porter wrote:
> On Mon, Apr 06, 2015 at 09:11:05AM -0500, Rob Herring wrote:
>> On Mon, Apr 6, 2015 at 8:32 AM, Matt Porter <mporter@konsulko.com> wrote:
>>> On Mon, Mar 30, 2015 at 10:57:59PM +0100, Srinivas Kandagatla wrote:
>>>> This patch adds bindings for simple eeprom framework which allows eeprom
>>>> consumers to talk to eeprom providers to get access to eeprom cell data.
>>>>
>>>> Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
>>>> [Maxime Ripard: intial version of eeprom framework]
>>>> Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
>>>> ---
>>>>   .../devicetree/bindings/eeprom/eeprom.txt          | 58 ++++++++++++++++++++++
>>>>   1 file changed, 58 insertions(+)
>>>>   create mode 100644 Documentation/devicetree/bindings/eeprom/eeprom.txt
>>>>
>>>> diff --git a/Documentation/devicetree/bindings/eeprom/eeprom.txt b/Documentation/devicetree/bindings/eeprom/eeprom.txt
>>>> new file mode 100644
>>>> index 0000000..fb71d46
>>>> --- /dev/null
>>>> +++ b/Documentation/devicetree/bindings/eeprom/eeprom.txt
>>>> @@ -0,0 +1,58 @@
>>>> += EEPROM Data Device Tree Bindings =
>>>> +
>>>> +This binding is intended to represent the location of hardware
>>>> +configuration data stored in EEPROMs.
>>>> +
>>>> +On a significant proportion of boards, the manufacturer has stored
>>>> +some data on an EEPROM-like device, for the OS to be able to retrieve
>>>> +these information and act upon it. Obviously, the OS has to know
>>>> +about where to retrieve these data from, and where they are stored on
>>>> +the storage device.
>>>
>>> Since this binding (and the kernel framework supporting it) describes
>>> non-volatile memory devices other than EEPROMs (e.g. EFuses) it should
>>> be named more generically like "nvmem".
>>>


nvmem sounds sensible name, I will rename framework to nvmem in next 
version.


>>>> +
>>>> +This document is here to document this.
>>>> +
>>>> += Data providers =
>>>> +Contains bindings specific to provider drivers and data cells as children
>>>> +to this node.
>>>> +
>>>> += Data cells =
>>>> +These are the child nodes of the provider which contain data cell
>>>> +information like offset and size in eeprom provider.
>>>> +
>>>> +Required properties:
>>>> +reg: specifies the offset in byte within that storage device, and the length
>>>> +     in bytes of the data we care about.
>>>> +     There could be more then one offset-length pairs in this property.
>>>> +
>>>> +Optional properties:
>>>> +As required by specific data parsers/interpreters.
>>>
>>> The generic binding could really use a "read-only" property here as this
>>> is a common hardware attribute for many nvmem devices. A serial EEPROM
>>> commonly has a write protect pin which may be hard-wired such that the
>>> hardware description should reflect that. An EFuse is typically blown with
>>> the required information at manufacturing time (for an end product case)
>>> and would be marked with the "read-only" flag.
>>>
>>> Having this optional flag in the generic binding would allow the
>>> framework to hint to consumers about the inability to write to the
>>> provided region.
>>
>> This could get fairly complex if you wanted to describe grouping of WP
>> regions which could have different layout than the fields here. This
>> may be better left as a device property listing addr & size pairs.
>> However, there is the notion of s/w "read-only" which means the OS
>> should not allow write access. The MTD partition binding supports this
>> with the "read-only" property.
>
> Yes, if the backing device has the capability to hw write protect
> regions the exported fields overlap those then it does get ugly.
> The MTD partition property was the inspiration here so perhaps it's
> best to term this as a property indicating how the data region is
> used in an implementation.
>
Correct me If am wrong.

Regarding write protection/read-only, regmap already has provisions to 
support this feature. regmap would bail out with errors if any attempt 
to write to non-writable regions. It all depends on the data providers 
how they setup the regmap and the bindings for those are specific 
individual data providers I think.

This would protect the user space side and kernel side consumers as well.

This should address your original query, I guess :-)


Thanks,
srini

> If it's left as a device property, then a binding with this property
> would need to be defined for the Efuse, etc. cases..or a simple-nvmem
> binding to handle the various OTP technologies.
>
>>> The framework sysfs attributes provide a userspace EEPROM consumer where
>>> it would be useful information to know that a data provider region is
>>> read only rather than having the exported writeable attribute simply
>>> fail a write cycle. This would allow the consumer to be aware that a
>>> failed write (if even attempted) is expected if the data provider
>>> advertised itself as read-only.
>>
>> You could distinguish with RW versus RO file attributes.
>
> Right, that would be preferred, based on the what the data provider
> advertises.

>
> -Matt
>
