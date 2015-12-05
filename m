From: Jonathan Cameron <jic23-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 1/2] Documentation: afe4404: Add DT bindings for the
 AFE4404 heart monitor
Date: Sat, 5 Dec 2015 18:21:18 +0000
Message-ID: <56632B1E.1040907@kernel.org>
References: <1449086240-13375-1-git-send-email-afd@ti.com>
 <1449086240-13375-2-git-send-email-afd@ti.com> <56632122.8040702@kernel.org>
 <56632499.9080708@ti.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <56632499.9080708-l0cyMroinI0@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Andrew F. Davis" <afd-l0cyMroinI0@public.gmane.org>, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Ian Campbell <ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org>, Kumar Gala <galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Hartmut Knaack <knaack.h-Mmb7MZpHnFY@public.gmane.org>, Lars-Peter Clausen <lars-Qo5EllUWu/uELgA04lAiVw@public.gmane.org>, Peter Meerwald <pmeerw-jW+XmwGofnusTnJN9+BGXg@public.gmane.org>
Cc: devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-iio-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 05/12/15 17:53, Andrew F. Davis wrote:
> On 12/05/2015 11:38 AM, Jonathan Cameron wrote:
>> On 02/12/15 19:57, Andrew F. Davis wrote:
>>> Add the TI afe4404 heart monitor DT bindings documentation.
>>> Create health directory created under iio.
>>>
>>> Signed-off-by: Andrew F. Davis <afd-l0cyMroinI0@public.gmane.org>
>> One little point inline - otherwise this is straightforward and
>> looks good to me.
>>
>> Could add cross references to the interrupt and gpio docs.
>>
> 
> Will add.
> 
>> Jonathan
>>> ---
>>>   .../devicetree/bindings/iio/health/afe4404.txt     | 27 ++++++++++++++++++++++
>>>   1 file changed, 27 insertions(+)
>>>   create mode 100644 Documentation/devicetree/bindings/iio/health/afe4404.txt
>>>
>>> diff --git a/Documentation/devicetree/bindings/iio/health/afe4404.txt b/Documentation/devicetree/bindings/iio/health/afe4404.txt
>>> new file mode 100644
>>> index 0000000..25b77a4
>>> --- /dev/null
>>> +++ b/Documentation/devicetree/bindings/iio/health/afe4404.txt
>>> @@ -0,0 +1,27 @@
>>> +* Texas Instruments AFE4404 Heart rate and Pulse Oximeter
>>> +
>>> +Required properties:
>>> + - compatible        : Should be "ti,afe4404".
>>> + - reg            : I2C address of the device.
>>> + - tx_sup-supply    : Regulator supply to LEDs.
>> If the sup bit is for supply I'd drop it and just have
>> tx-supply.
> 
> It is, the name of the pin in the datasheet is "tx_sup", so
> I went with that.
Drop it - I suspect the device tree guys would prefer it without
and it's not hard to make the connection with the datasheet name!
> 
>>> + - interrupt-parent    : Phandle to he parent interrupt controller.
>>> + - interrupts        : The interrupt line the device ADC_RDY pin is connected to.
>>> +
>>> +Optional properties:
>>> + - reset-gpios        : GPIO used to reset the device.
>>> +
>>> +Example:
>>> +
>>> +&i2c2 {
>>> +    heart_mon@58 {
>>> +        compatible = "ti,afe4404";
>>> +        reg = <0x58>;
>>> +
>>> +        tx_sup-supply = <&vbat>;
>>> +
>>> +        interrupt-parent = <&gpio1>;
>>> +        interrupts = <28 IRQ_TYPE_EDGE_RISING>;
>>> +
>>> +        reset-gpios = <&gpio1 16 GPIO_ACTIVE_LOW>;
>>> +    };
>>> +};
>>>
>>
