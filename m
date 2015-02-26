From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: Re: [RFC PATCH 1/3] eeprom: Add a simple EEPROM framework
Date: Thu, 26 Feb 2015 09:16:27 +0000
Message-ID: <54EEE46B.6090905@linaro.org>
References: <1424365639-26634-1-git-send-email-srinivas.kandagatla@linaro.org> <1424365708-26681-1-git-send-email-srinivas.kandagatla@linaro.org> <CAL_Jsq+SeuoojgTpv1y_aPJ_jzDr3HqZhYEBQ3_vYGBHvcccug@mail.gmail.com> <54E78A31.9020306@linaro.org> <CAL_Jsq+mvpRjYfL_8OseTDCB-6aBhwhNKLBQXXJeVQLDwWm8Nw@mail.gmail.com> <20150222143211.GX25269@lukather> <CAL_JsqLqqw5DyUqCaOTSKPwF-Ms5EU4f_OPoW9YVpMCo8A_bbw@mail.gmail.com> <54EBB3AC.30000@codeaurora.org> <20150224092155.GO25269@lukather> <20150225013049.GJ24928@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150225013049.GJ24928@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Stephen Boyd <sboyd@codeaurora.org>, Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Rob Herring <robherring2@gmail.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>, Kumar Gala <galak@codeaurora.org>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>, Mark Brown <broonie@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
List-Id: linux-api@vger.kernel.org



On 25/02/15 01:30, Stephen Boyd wrote:
> On 02/24, Maxime Ripard wrote:
>> On Mon, Feb 23, 2015 at 03:11:40PM -0800, Stephen Boyd wrote:
>>>>>> I would do something more simple that is just a list of keys and
>>>>>> their location like this:
>>>>>>
>>>>>> device-serial-number = <start size>;
>>>>>> key1 = <start size>;
>>>>>> key2 = <start size>;
>>>>> I'm sorry, but what's the difference?
>>>> It can describe the layout completely whether the fields are tied to a
>>>> h/w device or not.
>>>>
>>>> What I would like to see here is the entire layout described covering
>>>> both types of fields.
>>>>
>>>
>>> I was thinking the DT might be like this on the provider side:
>>>
>>>     qfprom@1000000 {
>>>        reg = <0x1000000 0x1000>;
>>>        ranges = <0 0x1000000 0x1000>;
>>>        compatible = "qcom,qfprom-msm8960"
>>>
>>>        pvs-data: pvs-data@40 {
>>>              compatible = "qcom,pvs-a";
>>>              reg = <0x40 0x20>,
>>> 	    #eeprom-cells = <0>;
>>>        };
>>>
>>>         tsens-data: tmdata@10 {
>>>              compatible = "qcom,tsens-data-msm8960";
>>>              reg = <0x10 4>, <0x16 4>;
>>> 	    #eeprom-cells = <0>;
>>>
>>>        };
>>>
>>>        serial-number: serial@50 {
>>>              compatible = "qcom,serial-msm8960";
>>>              reg = <0x50 4>, <0x60 4>;
>>> 	    #eeprom-cells = <0>;
>>>
>>>        };
>>>     };
>>
>> I'm not sure the compatible is really needed.
>>
>> A label of some sort, just like the MTD partitions do would do just
>> fine, and wouldn't have the implicit expectation that a driver will be
>> probed from that node.
>
> I wasn't aware that compatible meant driver probe. I thought
> compatible just meant some software entity can understand what
> I've described within this node. For example, compatible for
> reserved-memory nodes doesn't mean we're going to probe a device.
>
>>
>>> and then on the consumer side:
>>>
>>> 	device {
>>> 		eeproms = <&serial-number>;
>>> 		eeprom-names = "soc-rev-id";
>>> 	};
>>>
>>>
>>> This would solve a problem where the consumer device is some standard
>>> off-the-shelf IP block that needs to get some SoC specific calibration
>>> data from the eeprom. I may want to interpret the bits differently
>>> depending on which eeprom is connected to my SoC. Sometimes that data
>>> format may be the same across many variations of the SoC (e.g. the
>>> qcom,pvs-a node) or it may be completely different for a given SoC (e.g.
>>> qcom,serial-msm8960 node). I imagine for other SoCs out there it could
>>> be different depending on which eeprom the board manufacturer decides to
>>> wire onto their board and how they choose to program the data.
>>
>> Oh, so you'd like to infer the data format it's stored in from the
>> compatible?
>>
>> AFAICT, this format will be highly depending on the board itself,
>> rather than on the SoC, do you think it will scale enough?
>>
>>> So this is where I think the eeprom-cells and offset + length starts to
>>> fall apart. It forces us to make up a bunch of different compatible
>>> strings for our consumer device just so that we can parse the eeprom
>>> that we decided to use for some SoC/board specific data. Instead I'd
>>> like to see some framework that expresses exactly which eeprom is on my
>>> board and how to interpret the bits in a way that doesn't require me to
>>> keep refining the compatible string for my generic IP block.
>>
>> Hmmmm, apparently you don't :)
>>
>>> I worry that if we put all those details in DT we'll end up having to
>>> describe individual bits like serial-number-bit-2, serial-number-bit-3,
>>> etc. because sometimes these pieces of data are scattered all around the
>>> eeprom and aren't contiguous or aligned on a byte boundary. It may be
>>> easier to just have a way to express that this is an eeprom with this
>>> specific layout and my device has data stored in there. Then the driver
>>> can be told what layout it is (via compatible or some other string based
>>> means if we're not using DT?) and match that up with some driver data if
>>> it needs to know how to understand the bits it can read with the
>>> eeprom_read() API.
>>
>> I'm half convinced that the layout information will actually work for
>> more complex cases, like the linked list Rob described.
>>
>> If such a structure is ever to be found, it would feel wrong to have
>> that in the EEPROM driver, but it would feel just as wrong to put that
>> in the client driver, that would have to handle the parsing of raw
>> data coming flashed by one single crazy board vendor.
>>
>> Maybe we can have each cell carry a property that defines the format
>> it's stored in, and match that to some parsers plugins, starting with
>> the generic and trivial cases but still allowing for custom parsers to
>> be defined?
>>
>> Something like
>>
>> eeprom@42 {
>> 	compatible = "atmel,at24something";
>> 	reg = <0x42>;
>>
>> 	serial@0 {
>> 		label = "board serial";
>> 		reg = <0x0 0x10>;
>> 		format = "packed";
>> 	};
>>
>> 	opps@10 {
>> 		label = "board serial";
>> 		reg = <0x10 0x10>, <0x40 0x10>, <0x80 0x10>;
>> 		format = "random-vendor,opp-linked-list";
>> 	};
>> };
>>
>> That would make eeprom_read always return the same format of data to
>> the client drivers, without cripling the generic EEPROM drivers
>> either.
>>
>
> Is the goal here to make eeprom_read() figure out how to return
> the next byte of data and hide the parsing logic behind the
> eeprom APIs? I imagine "random-vendor,opp-linked-list" would be
> handled by the eeprom driver and that would return OPPs byte by
> byte across the different reg properties to the eeprom consumer?
>
> This approach concerns me because every eeprom_read() call needs
> to fit the format that the client driver is expecting. How do we
> validate that? What do we do if we have a random OPP client #1
> that expects to get the data from eeprom_read() with OPPs in
> ascending order and random OPP client #2 that expects to get the
> data from eeprom_read() with OPPs in descending order?
>
> It feels like we're making the eeprom framework too smart without
> a well defined abstraction. If we were to make it so that
> eeprom_get_opps() knew what to do and parsed/populated the OPPs,
> it might work. But if we're just exporting raw data across a
> read/write API with some implementation specific mangling it
> sounds like it's going to get messy fast. And if the API is well
> defined, it would start to become rather large with many
> different types of data that need to be parsed and sometimes data
> that's only specific to a single SoC.
>
> I wonder how much we could get away with this approach though. If
> the eeprom driver probed and populated OPPs, made a serial number
> available via the soc device, and then we made up framework(s)
> for things like our thermal sensor calibration data and display
> panel calibration data, I would guess that covers most of my
> use-cases. The client drivers would need some sort of 'wait for
> eeprom to populate things' API or we'd need to work that into the
> new calibration framework.
>
I think we are making simple eeprom framework too smart which will break 
in future.

IMHO, Anything on top of eeprom interface that interprets the data 
should not go into the eeprom framework itself, it can either live some 
parsers/SOC specific drivers/interfaces.

As Stephen pointed out earlier lets start with something like this, 
which would provide a better abstraction to the discussed use cases like 
serial-number and packed data in eeprom.

    qfprom@1000000 {
       reg = <0x1000000 0x1000>;
       ranges = <0 0x1000000 0x1000>;
       compatible = "qcom,qfprom-msm8960"

       pvs-data: pvs-data@40 {
             compatible = "qcom,pvs-a";
             reg = <0x40 0x20>,
       };

        tsens-data: tmdata@10 {
             reg = <0x10 40>;
       };

       serial-number: serial@50 {
             compatible = "qcom,serial-msm8960";
             reg = <0x50 4>, <0x60 4>;
       };

    };

and then on the consumer side:

	device {
		eeproms = <&serial-number>;
		eeprom-names = "soc-rev-id";
	};
	
driver side:

	eeprom_get_cell()
	eeprom_read();
