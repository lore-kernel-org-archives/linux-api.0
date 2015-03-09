From: Maxime Coquelin <mcoquelin.stm32@gmail.com>
Subject: Re: [PATCH v2 04/18] clocksource: Add ARM System timer driver
Date: Mon, 9 Mar 2015 18:00:13 +0100
Message-ID: <CALszF6B1NV4193+az0Aep+C5R+=kn0a2HyyzU1HtfD_HnWCnRw@mail.gmail.com>
References: <1424455277-29983-1-git-send-email-mcoquelin.stm32@gmail.com>
	<1424455277-29983-5-git-send-email-mcoquelin.stm32@gmail.com>
	<CACRpkdYnj0vTBVEEDp4isznRZ+KQuC2h+VViZr=Pt8VtEOWP-A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-arch-owner@vger.kernel.org>
In-Reply-To: <CACRpkdYnj0vTBVEEDp4isznRZ+KQuC2h+VViZr=Pt8VtEOWP-A@mail.gmail.com>
Sender: linux-arch-owner@vger.kernel.org
To: Linus Walleij <linus.walleij@linaro.org>
Cc: =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= <u.kleine-koenig@pengutronix.de>, =?UTF-8?Q?Andreas_F=C3=A4rber?= <afaerber@suse.de>, Geert Uytterhoeven <geert@linux-m68k.org>, Rob Herring <robh+dt@kernel.org>, Philipp Zabel <p.zabel@pengutronix.de>, Jonathan Corbet <corbet@lwn.net>, Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>, Ian Campbell <ijc+devicetree@hellion.org.uk>, Kumar Gala <galak@codeaurora.org>, Russell King <linux@arm.linux.org.uk>, Daniel Lezcano <daniel.lezcano@linaro.org>, Thomas Gleixner <tglx@linutronix.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Jiri Slaby <jslaby@suse.cz>, Arnd Bergmann <arnd@arndb.de>, Andrew Morton <akpm@linux-foundation.org>, "David S. Miller" <davem@davemloft.net>, Mauro Carvalho Chehab <mchehab@osg.samsung.com>, Joe Perches <joe@perches.com>, Antti Palosaari <crope@iki.fi>, Tejun Heo <tj@kernel.org>
List-Id: linux-api@vger.kernel.org

2015-03-09 16:50 GMT+01:00 Linus Walleij <linus.walleij@linaro.org>:
> On Fri, Feb 20, 2015 at 7:01 PM, Maxime Coquelin
> <mcoquelin.stm32@gmail.com> wrote:
>
>> This patch adds clocksource support for ARMv7-M's System timer,
>> also known as SysTick.
>>
>> Signed-off-by: Maxime Coquelin <mcoquelin.stm32@gmail.com>
> (...)
>> +       /* If no clock found, try to get clock-frequency property */
>> +       if (!rate) {
>> +               ret = of_property_read_u32(np, "clock-frequency", &rate);
>> +               if (ret)
>> +                       goto out_unmap;
>> +       }
>
> If this driver is only used for this one system, and if on this one system
> the clk subsystem will provide the clock rate, then there is no need
> to include this hackaround property.
>
> Alternatively there is no point including reading the frequency from
> the clk subsystem for this one system.
>
> So which one is it?

In the first version, the "clock-frequency" property handling was not here.
Rob Herring advised me to add its support, as it could be used by
simple systems not selecting CCF.

So, I don't have the name of a system where it could be useful, but I
think Rob's request make sense.

Note that I tested using the clock-frequency property before sending.

Best regards,
Maxime
>
> Yours,
> Linus Walleij
