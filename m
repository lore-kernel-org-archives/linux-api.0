From: Srinivas Kandagatla <srinivas.kandagatla-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v4 04/10] eeprom: Add a simple EEPROM framework for eeprom
 consumers
Date: Tue, 05 May 2015 12:46:32 +0100
Message-ID: <5548AD98.50801@linaro.org>
References: <1427752492-17039-1-git-send-email-srinivas.kandagatla@linaro.org> <1427752670-17219-1-git-send-email-srinivas.kandagatla@linaro.org> <20150407184533.GA10278@codeaurora.org> <55243982.7020907@linaro.org> <20150409144522.GB9663@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150409144522.GB9663-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Stephen Boyd <sboyd-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Cc: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Maxime Ripard <maxime.ripard-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Kumar Gala <galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Mark Brown <broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, s.hauer-bIcnvbaLZ9MEGnE8C9+IrQ@public.gmane.org, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-msm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org
List-Id: linux-api@vger.kernel.org

Hi Stephen,

Sorry I took so long to reply.


On 09/04/15 15:45, Stephen Boyd wrote:
> On 04/07, Srinivas Kandagatla wrote:
>> On 07/04/15 19:45, Stephen Boyd wrote:
>>> On 03/30, Srinivas Kandagatla wrote:
>>>
>>> Do you have an overview of how to use these APIs? Maybe some
>>> Documentation/ is in order? I'm mostly interested in how the
>>> blocks array is supposed to work and how this hooks up to drivers
>>> that are using DT.
>>
>> Only doc ATM is function level kernel doc in c file.
>> May be I can explain you for now and I will try to add some
>> documentation with some usage examples in next version.
>
> Thanks.
>
>>
>> eeprom block array is just another way intended to get hold of
>> eeprom content for non-DT providers/consumers, but DT
>> consumers/providers can also use it. As of today SOC/mach level code
>> could use it as well.
>>
>> In eeprom_cell_get() case the lookup of provider is done based on
>> provider name, this provider name is generally supplied by all the
>> providers (both DT/non DT).
>>
>> for example in qfprom case,
>> provider is registered from DT with eeprom config containing a unique name:
>> static struct eeprom_config econfig = {
>> 	.name = "qfprom",
>> 	.id = 0,
>> };
>>
>> In the consumer case, the tsens driver could do some like in non DT way:
>>
>> 	struct eeprom_block blocks[4] ={
>> 		{
>> 		.offset = 0x404,
>> 		.count = 0x4,
>> 		},
>> 		{
>> 		.offset = 0x408,
>> 		.count = 0x4,
>> 		},
>> 		{
>> 		.offset = 0x40c,
>> 		.count = 0x4,
>> 		},
>> 		{
>> 		.offset = 0x410,
>> 		.count = 0x4,
>> 		},
>> 	};
>> 	calib_cell = eeprom_cell_get("qfprom0", blocks, 4);
>>
>>
>> Or in DT way
>> calib_cell  = of_eeprom_cell_get(np, "calib");
>>
>
> Ok. I guess I was hoping for a more device centric approach like
> we have for clks/regulators/etc. That way a driver doesn't need
> to know it's using DT or not to figure out which API to call.

That would be the best. Its easy to wrap up whats in eeprom core to
eeprom_get_cell(dev, "cell-name") for both DT and non-dt cases, if I
remove the nasty global name space thing.

Only thing which is limiting it is the existing bindings which are just 
phandle based. For eeprom to be more of device centric we need more
generic bindings/property names like

nvrom-cell = <&abc>, <&edf>
nvrom-cell-names = "cell1", "cell2";

Also we can have name associated to each eeprom cell which would help 
for non-dt cases. So they can just lookup by the cell name.


Sacha, Are you ok with such binding?  As this can provide a single 
interface for dt and non-dt. I remember you requested for changing from 
generic properties to specific property names.


> Also the global namespace is sort of worrying (qfprom0 part). How
> do we know it's qfprom0? What if it's qfprom1 sometimes?

I agree this is something which I don't like it in the first place too.
If we have something like names associated to each eeprom cell like clks
or regulators we can have some thing like eeprom_get_cell(dev, name);

>
> Also, how are we supposed to encode certain bits inside the
> stream of bytes (blocks)? In some situations (e.g. the qcom CPR
> stuff) we have quite a few fuse bits we need to read that are
> packed into different bytes and may cross byte boundaries (i.e.
> bits 6 to 10 of a 32-bit word). The current API looks to be byte
> focused when I have bit based/non-byte aligned data.
Yes, it is more of byte oriented. However we can add some new apis for
parsers like ones you are working on.

of_eeprom_get_provider_regmap(phandle) just to get handle to regmap from 
eeprom_core, which would provide most of the apis you would need.
Am guessing eeprom parsers would need need such interface to eeprom-core 
in future anyway.

>
> My current feeling is that I don't want to use any of the block
> stuff at all. I just want a simple byte-based API that allows me
> to read a number of contiguous bytes from the fuses. Then I'll
> need to shift that data down by a few bits and mask it with the
> width of the data I want to read to extract the data needed.
>
> The only thing after that where I have a problem is figuring out
> which eeprom is present in the consumer driver. I think I may
> need to open-code it and look at the phandle for the eeprom and
> do a compatible check to figure out which bits I want to read.
>
> The DT would be like this (note I left eeprom-cells/eeproms here
> because that allows us to generically find eeproms used by a
> device and find eeprom providers):

I though, having "eeprom-cells" would be make sense only if the bindings 
have possible arguments to a phandle. In this case it would be none all 
the time.

For provider lookups currently its generic/easy and fast as its done 
based on eeprom class. Am not sure what advantage would we get
Am I missing anything ?

If you are ok I will prepare a v5 with the proposed changes.


--srini
>
> 	qfprom: eeprom@58000 {
> 		compatible = "qcom,qfprom-msm8916";
> 		reg = <0x58000 0x7000>;
> 		#eeprom-cells = <0>;
> 	};
> 	
> 	cpr@b018000 {
> 		compatible = "qcom,cpr";
> 		reg = <0xb018000 0x1000>;
> 		interrupts = <0 15 1>, <0 16 1>, <0 17 1>;
> 		eeproms = <&qfprom>;
> 		...
> 	};
>
