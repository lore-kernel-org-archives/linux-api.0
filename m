From: "Andrew F. Davis" <afd@ti.com>
Subject: Re: [PATCH 1/2] Documentation: afe4404: Add DT bindings for the
 AFE4404 heart monitor
Date: Mon, 2 Nov 2015 10:08:30 -0600
Message-ID: <56378A7E.20900@ti.com>
References: <1446309089-21094-1-git-send-email-afd@ti.com>
 <1446309089-21094-2-git-send-email-afd@ti.com>
 <CAL_JsqJJjtAXzi-3Aeb6pwwSUUv0i9g0g43Fq60CeSmNEiYoaQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAL_JsqJJjtAXzi-3Aeb6pwwSUUv0i9g0g43Fq60CeSmNEiYoaQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Rob Herring <robh+dt@kernel.org>
Cc: Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>, Ian Campbell <ijc+devicetree@hellion.org.uk>, Kumar Gala <galak@codeaurora.org>, Jonathan Cameron <jic23@kernel.org>, Hartmut Knaack <knaack.h@gmx.de>, Lars-Peter Clausen <lars@metafoo.de>, Peter Meerwald <pmeerw@pmeerw.net>, "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>, "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On 10/31/2015 01:44 PM, Rob Herring wrote:
> gmail thinks this is spam BTW.
>

Strange, the mailing lists do too.

> On Sat, Oct 31, 2015 at 11:31 AM, Andrew F. Davis <afd@ti.com> wrote:
>> Add the TI afe4404 heart monitor DT bindings documentation.
>> Create health directory created under iio.
>>
>> Signed-off-by: Andrew F. Davis <afd@ti.com>
>> ---
>>   .../devicetree/bindings/iio/health/afe4404.txt     | 27 ++++++++++++++++++++++
>>   1 file changed, 27 insertions(+)
>>   create mode 100644 Documentation/devicetree/bindings/iio/health/afe4404.txt
>>
>> diff --git a/Documentation/devicetree/bindings/iio/health/afe4404.txt b/Documentation/devicetree/bindings/iio/health/afe4404.txt
>> new file mode 100644
>> index 0000000..d377033
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/iio/health/afe4404.txt
>> @@ -0,0 +1,27 @@
>> +* Texas Instruments AFE4404 Heart rate and Pulse Oximeter
>> +
>> +Required properties:
>> + - compatible          : Should be "ti,afe4404".
>> + - reg                 : I2C address of the device.
>> + - led-supply          : Regulator supply to the device.
>
> Is led correct name or copy-n-paste? The datasheet has tx_sup and
> rx_sup for supplies.
>

Looking back at the data sheet it looks like it also has an io_sup.
rx_sup seems to be the supply that must be on to keep the device on.
io_sup and tx_sup can be disabled without losing register values and
reseting the device.

I'm not sure if it makes sense to list the needed supplies, so I may
just rename led-supply to tx_sup-supply and have the be the only one.

>> + - interrupt-parent    : Phandle to he parent interrupt controller.
>> + - interrupts          : The interrupt line the device ADC_RDY pin is connected to.
>> +
>> +Optional properties:
>> + - reset-gpios         : GPIO used to reset the device.
>> +
>> +Example:
>> +
>> +&i2c2 {
>> +       heart_mon@58 {
>> +               compatible = "ti,afe4404";
>> +               reg = <0x58>;
>> +
>> +               led-supply = <&vbat>;
>> +
>> +               interrupt-parent = <&gpio1>;
>> +               interrupts = <28 IRQ_TYPE_EDGE_RISING>;
>> +
>> +               reset-gpios = <&gpio1 16 GPIO_ACTIVE_LOW>;
>> +       };
>> +};
>> --
>> 1.9.1
>>
