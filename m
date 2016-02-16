From: Vladimir Murzin <vladimir.murzin@arm.com>
Subject: Re: [PATCH v3 09/10] ARM: dts: introduce MPS2 AN385/AN386
Date: Tue, 16 Feb 2016 16:10:14 +0000
Message-ID: <56C349E6.2000002@arm.com>
References: <1455617295-23736-1-git-send-email-vladimir.murzin@arm.com> <1455617295-23736-10-git-send-email-vladimir.murzin@arm.com> <7562697.iiO7rmWd7c@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <7562697.iiO7rmWd7c@wuerfel>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux@arm.linux.org.uk, gregkh@linuxfoundation.org, daniel.lezcano@linaro.org, tglx@linutronix.de, u.kleine-koenig@pengutronix.de, mark.rutland@arm.com, pawel.moll@arm.com, ijc+devicetree@hellion.org.uk, galak@codeaurora.org, jslaby@suse.cz, robh+dt@kernel.org, andy.shevchenko@gmail.com, devicetree@vger.kernel.org, linux-serial@vger.kernel.org, linux-api@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On 16/02/16 11:01, Arnd Bergmann wrote:
> On Tuesday 16 February 2016 10:08:14 Vladimir Murzin wrote:
>> +
>> +       ethernet@40200000 {
>> +               compatible = "smsc,lan9220", "smsc,lan9115";
>> +               reg = <0x40200000 0x10000>;
>> +               interrupts = <13>;
>> +               interrupt-parent = <&nvic>;
>> +               smsc,irq-active-high;
>> +       };
>> +};
>> +
>>
> 
> This node seems slightly misplaced. Is there some external bus interface
> that this is connected to? The address suggests that it should be somewhere
> below the /soc node, and you probably want to list the external bus
> interface with a "ranges" property that identifies the addresses visibile
> there, and put the external chip under there.
> 

I might messed it up since the MAC/PHY connects to the same 16-bit
interface as the 16MB PSRAM external memory and both connected via AHB.

Not sure how it should be expressed, so some help form DT camp would be
appreciated.

Cheers
Vladimir

> 	Arnd
> 
> 
> 
