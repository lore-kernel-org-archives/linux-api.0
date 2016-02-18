From: Vladimir Murzin <vladimir.murzin@arm.com>
Subject: Re: [PATCH v3 09/10] ARM: dts: introduce MPS2 AN385/AN386
Date: Thu, 18 Feb 2016 10:11:37 +0000
Message-ID: <56C598D9.3030001@arm.com>
References: <1455617295-23736-1-git-send-email-vladimir.murzin@arm.com>
 <56C349E6.2000002@arm.com> <56C4A46C.50506@arm.com>
 <7272921.u1gphgWzUn@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <7272921.u1gphgWzUn@wuerfel>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: mark.rutland@arm.com, devicetree@vger.kernel.org, linux@arm.linux.org.uk, pawel.moll@arm.com, ijc+devicetree@hellion.org.uk, gregkh@linuxfoundation.org, daniel.lezcano@linaro.org, linux-kernel@vger.kernel.org, andy.shevchenko@gmail.com, robh+dt@kernel.org, linux-serial@vger.kernel.org, galak@codeaurora.org, u.kleine-koenig@pengutronix.de, tglx@linutronix.de, linux-api@vger.kernel.org, jslaby@suse.cz, linux-arm-kernel@lists.infradead.org
List-Id: linux-api@vger.kernel.org

On 17/02/16 16:58, Arnd Bergmann wrote:
> On Wednesday 17 February 2016 16:48:44 Vladimir Murzin wrote:
>> On 16/02/16 16:10, Vladimir Murzin wrote:
>>> On 16/02/16 11:01, Arnd Bergmann wrote:
>>>> On Tuesday 16 February 2016 10:08:14 Vladimir Murzin wrote:
>>>>> +
>>>>> +       ethernet@40200000 {
>>>>> +               compatible = "smsc,lan9220", "smsc,lan9115";
>>>>> +               reg = <0x40200000 0x10000>;
>>>>> +               interrupts = <13>;
>>>>> +               interrupt-parent = <&nvic>;
>>>>> +               smsc,irq-active-high;
>>>>> +       };
>>>>> +};
>>>>> +
>>>>>
>>>>
>>>> This node seems slightly misplaced. Is there some external bus interface
>>>> that this is connected to? The address suggests that it should be somewhere
>>>> below the /soc node, and you probably want to list the external bus
>>>> interface with a "ranges" property that identifies the addresses visibile
>>>> there, and put the external chip under there.
>>>>
>>>
>>> I might messed it up since the MAC/PHY connects to the same 16-bit
>>> interface as the 16MB PSRAM external memory and both connected via AHB.
>>>
>>> Not sure how it should be expressed, so some help form DT camp would be
>>> appreciated.
>>
>> Does following fixup address your point on where/how ethernet node
>> should be placed?
> 
> 
> 
>> diff --git a/arch/arm/boot/dts/mps2-an385.dts b/arch/arm/boot/dts/an385.dts
>> index 976f86d..50c8d24 100644
>> --- a/arch/arm/boot/dts/mps2-an385.dts
>> +++ b/arch/arm/boot/dts/mps2-an385.dts
>> @@ -63,14 +63,10 @@
>>  		device_type = "memory";
>>  		reg = <0x21000000 0x1000000>;
>>  	};
>> +};
>>
>> -	ethernet@40200000 {
>> -		compatible = "smsc,lan9220", "smsc,lan9115";
>> -		reg = <0x40200000 0x10000>;
>> -		interrupts = <13>;
>> -		interrupt-parent = <&nvic>;
>> -		smsc,irq-active-high;
>> -	};
>> +&mb {
>> +	ranges = <0 0x40200000 0x10000>;
>>  };
> 
> How is the range being set here? The way I read this is:
> 
> "There is an external bus controller whose single CPU physical
> address for MMIO is configurable. The chip always connects
> a lan9220 device to it (as that is in the dtsi file) and
> nothing else is possible, and the bootloader in this
> version of the machine has configured the window to be
> at address 0x40200000."
> 
> Is that what the hardware does?
> 
> I would have expected the opposite, with the external bus
> interface being hardwired to one or more physical addresses
> (more than one if you have multiple chip-selects), and
> then allow to connect different devices, which are in the
> .dts file, while the bus controller is defined in the
> .dtsi file.
> 

Right, I thought in a wrong way, in opposite it makes more sense now.

.dtsi

/* below the soc/ */
smb {
	compatible = "simple-bus";
	#address-cells = <2>;
	#size-cells = <1>;
	ranges = <0 0 0x40200000 0x10000>,
		 <1 0 0xa0000000 0x10000>;
};

.dts

smb {
	ethernet@0,0 {
		compatible = "smsc,lan9220", "smsc,lan9115";
		reg = <0 0x0 0x10000>;
		interrupts = <13>;
		interrupt-parent = <&nvic>;
		smsc,irq-active-high;
};


and looking again at .dtsi it seems to me that fpgaio should be moved
below the soc/ under separate bus interface which would hosts audio and
spi too or I keep missing things around device-tree?

I appreciate your help on this, thanks!

Vladimir

> 	Arnd
> 
> 
> 
