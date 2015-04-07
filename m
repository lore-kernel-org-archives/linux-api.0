From: Maxime Coquelin <mcoquelin.stm32@gmail.com>
Subject: Re: [PATCH v5 09/15] dt-bindings: Document the STM32 USART bindings
Date: Tue, 7 Apr 2015 17:49:54 +0200
Message-ID: <CALszF6BnFz3D=6AT0+o2umy6wtVJg1BGX4rLWmHjrbt=4-ZknQ@mail.gmail.com>
References: <1428080481-18591-1-git-send-email-mcoquelin.stm32@gmail.com>
	<1428080481-18591-10-git-send-email-mcoquelin.stm32@gmail.com>
	<CAL_JsqKioFc65Gng0FbOOBCspwxr1-bdy1kShKRM24XyALPmOw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <CAL_JsqKioFc65Gng0FbOOBCspwxr1-bdy1kShKRM24XyALPmOw@mail.gmail.com>
Sender: linux-doc-owner@vger.kernel.org
To: Rob Herring <robherring2@gmail.com>
Cc: =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= <u.kleine-koenig@pengutronix.de>, =?UTF-8?Q?Andreas_F=C3=A4rber?= <afaerber@suse.de>, Geert Uytterhoeven <geert@linux-m68k.org>, Rob Herring <robh+dt@kernel.org>, Philipp Zabel <p.zabel@pengutronix.de>, Linus Walleij <linus.walleij@linaro.org>, Arnd Bergmann <arnd@arndb.de>, Stefan Agner <stefan@agner.ch>, Peter Meerwald <pmeerw@pmeerw.net>, Paul Bolle <pebolle@tiscali.nl>, Peter Hurley <peter@hurleysoftware.com>, Andy Shevchenko <andy.shevchenko@gmail.com>, Chanwoo Choi <cw00.choi@samsung.com>, Russell King <linux@arm.linux.org.uk>, Daniel Lezcano <daniel.lezcano@linaro.org>, Jonathan Corbet <corbet@lwn.net>, Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>, Ian Campbell <ijc+devicetree@hellion.org.uk>, Kumar Gala <galak@codeaurora.org>, Thomas Gleixner <tglx@linutronix.de>, Greg Kroah-Hartman <gregkh@linu>
List-Id: linux-api@vger.kernel.org

2015-04-03 19:14 GMT+02:00 Rob Herring <robherring2@gmail.com>:
> On Fri, Apr 3, 2015 at 12:01 PM, Maxime Coquelin
> <mcoquelin.stm32@gmail.com> wrote:
>> This adds documentation of device tree bindings for the
>> STM32 USART
>>
>> Tested-by: Chanwoo Choi <cw00.choi@samsung.com>
>> Signed-off-by: Maxime Coquelin <mcoquelin.stm32@gmail.com>
>> ---
>>  .../devicetree/bindings/serial/st,stm32-usart.txt  | 32 ++++++++++++++++++++++
>>  1 file changed, 32 insertions(+)
>>  create mode 100644 Documentation/devicetree/bindings/serial/st,stm32-usart.txt
>>
>> diff --git a/Documentation/devicetree/bindings/serial/st,stm32-usart.txt b/Documentation/devicetree/bindings/serial/st,stm32-usart.txt
>> new file mode 100644
>> index 0000000..090a3a4
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/serial/st,stm32-usart.txt
>> @@ -0,0 +1,32 @@
>> +* STMicroelectronics STM32 USART
>> +
>> +Required properties:
>> +- compatible: Can be either "st,stm32-usart" or "st,stm32-uart" depending on
>> +whether the device supports synchronous mode.
>> +- reg: The address and length of the peripheral registers space
>> +- interrupts: The interrupt line of the USART instance
>> +- clocks: The input clock of the USART instance
>> +
>> +Optional properties:
>> +- pinctrl: The reference on the pins configuration
>> +- st,hw-flow-ctrl: bool flag to enable hardware flow control.
>
> We already have "auto-flow-control" for 8250. Does that work for you?

Yes it works, just that I didn't know about it.

I will change to "auto-flow-control" in next version.

Thanks,
Maxime
