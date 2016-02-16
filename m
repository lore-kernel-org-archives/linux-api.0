From: Vladimir Murzin <vladimir.murzin@arm.com>
Subject: Re: [PATCH v3 09/10] ARM: dts: introduce MPS2 AN385/AN386
Date: Tue, 16 Feb 2016 15:37:31 +0000
Message-ID: <56C3423B.5070307@arm.com>
References: <1455617295-23736-1-git-send-email-vladimir.murzin@arm.com>	<1455617295-23736-10-git-send-email-vladimir.murzin@arm.com> <CACRpkdafDhT=1uJssVNAW+g05eXbRC1xUL+O0+SxcpdczUX0vQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CACRpkdafDhT=1uJssVNAW+g05eXbRC1xUL+O0+SxcpdczUX0vQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Russell King - ARM Linux <linux@arm.linux.org.uk>, Greg KH <gregkh@linuxfoundation.org>, Daniel Lezcano <daniel.lezcano@linaro.org>, Thomas Gleixner <tglx@linutronix.de>, =?UTF-8?B?VXdlIEtsZWluZS1Lw7ZuaWc=?= <u.kleine-koenig@pengutronix.de>, Mark Rutland <mark.rutland@arm.com>, =?UTF-8?B?UGF3ZcWCIE1vbGw=?= <pawel.moll@arm.com>, "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>, Kumar Gala <galak@codeaurora.org>, Jiri Slaby <jslaby@suse.cz>, Rob Herring <robh+dt@kernel.org>, Andy Shevchenko <andy.shevchenko@gmail.com>, "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>, "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger>
List-Id: linux-api@vger.kernel.org

On 16/02/16 15:17, Linus Walleij wrote:
> On Tue, Feb 16, 2016 at 11:08 AM, Vladimir Murzin
> <vladimir.murzin@arm.com> wrote:
> 
>> Application Notes 385 and 386 shares the same memory map and features
>> except the CPU is used. AN385 is supplied with Cortex-M3 CPU and AN386
>> is supplied with Cortex-M4.
>>
>> Signed-off-by: Vladimir Murzin <vladimir.murzin@arm.com>
> (...)
>> +               fpgaio {
>> +                       compatible = "syscon", "simple-mfd";
>> +                       reg = <0x40028000 0x10>;
>> +
>> +                       led@0 {
>> +                               compatible = "register-bit-led";
>> +                               offset = <0x0>;
>> +                               mask = <0x01>;
>> +                               label = "userled:0";
>> +                               linux,default-trigger = "heartbeat";
>> +                               default-state = "on";
>> +                       };
>> +
>> +                       led@1 {
>> +                               compatible = "register-bit-led";
>> +                               offset = <0x0>;
>> +                               mask = <0x02>;
>> +                               label = "userled:1";
>> +                               linux,default-trigger = "usr";
>> +                               default-state = "off";
>> +                       };
>> +               };
> 
> Thanks for using this. I worked hard to massage this into the
> core.
> 

Thank you for pushing it, it cost me couple of minutes to make these
tiny leds alive :)

> Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
> 

Cheers!

Vladimir

> Yours,
> Linus Walleij
> 
> 
> 
