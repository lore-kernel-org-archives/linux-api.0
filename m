From: Vladimir Murzin <vladimir.murzin@arm.com>
Subject: Re: [PATCH v3 09/10] ARM: dts: introduce MPS2 AN385/AN386
Date: Thu, 18 Feb 2016 11:13:06 +0000
Message-ID: <56C5A742.8010304@arm.com>
References: <1455617295-23736-1-git-send-email-vladimir.murzin@arm.com> <7272921.u1gphgWzUn@wuerfel> <56C598D9.3030001@arm.com> <7245560.jfhuhtPsB8@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <7245560.jfhuhtPsB8@wuerfel>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: mark.rutland@arm.com, devicetree@vger.kernel.org, linux@arm.linux.org.uk, pawel.moll@arm.com, ijc+devicetree@hellion.org.uk, gregkh@linuxfoundation.org, daniel.lezcano@linaro.org, linux-kernel@vger.kernel.org, robh+dt@kernel.org, andy.shevchenko@gmail.com, galak@codeaurora.org, linux-serial@vger.kernel.org, u.kleine-koenig@pengutronix.de, tglx@linutronix.de, linux-api@vger.kernel.org, jslaby@suse.cz, linux-arm-kernel@lists.infradead.org
List-Id: linux-api@vger.kernel.org

On 18/02/16 10:45, Arnd Bergmann wrote:
> On Thursday 18 February 2016 10:11:37 Vladimir Murzin wrote:
>>
>> Right, I thought in a wrong way, in opposite it makes more sense now.
>>
>> .dtsi
>>
>> /* below the soc/ */
>> smb {
>>         compatible = "simple-bus";
>>         #address-cells = <2>;
>>         #size-cells = <1>;
>>         ranges = <0 0 0x40200000 0x10000>,
>>                  <1 0 0xa0000000 0x10000>;
>> };
> 
> That looks good, yes.
> 
> Is 0x10000 the correct maximum addressable size of the external bus
> in both cases?
> 
> Intuitively, I would guess that the 0xa0000000 range might
> be much wider.

There is only Ethernet connected to this bus (apart from PSRAM), so it
might be wider, but there is no indication of this in documentation.

> 
>> .dts
>>
>> smb {
>>         ethernet@0,0 {
>>                 compatible = "smsc,lan9220", "smsc,lan9115";
>>                 reg = <0 0x0 0x10000>;
>>                 interrupts = <13>;
>>                 interrupt-parent = <&nvic>;
>>                 smsc,irq-active-high;
>> };
>>
>>
>> and looking again at .dtsi it seems to me that fpgaio should be moved
>> below the soc/ under separate bus interface which would hosts audio and
>> spi too or I keep missing things around device-tree?
>>
> 
> I don't see the audio and spi nodes, so I'm not sure where exactly
> you would put them.

I just keep things simple ;)

> 
> Ideally those things should be visible from a block diagram in the
> datasheet.

Indeed, block diagram indicates all them as a "FPGA APB subsystem" and
clearly draws a line indicating a bus those devices are connected to.
After your point about lan9220, it looks clearer to me to express that
subsystem outside of soc/ node indicating bus interface, so it would
match to those drawings closely.

Cheers
Vladimir

> 
> 	Arnd
> 
> 
> 
