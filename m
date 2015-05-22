From: Daniel Thompson <daniel.thompson@linaro.org>
Subject: Re: [PATCH v8 14/16] ARM: dts: Introduce STM32F429 MCU
Date: Fri, 22 May 2015 13:43:43 +0100
Message-ID: <555F247F.9060100@linaro.org>
References: <1431158038-3813-1-git-send-email-mcoquelin.stm32@gmail.com>	<2282066.NWoIT9ZyLc@wuerfel>	<CALszF6CaO_yuNiSDuDV+4d2NRe_+32j=zcSE1HPhB1UH59cW9w@mail.gmail.com>	<13641152.Yt4ZI3oT6L@wuerfel>	<CALszF6CK5ezrO6D=4zr6zEPC7VanzbQjnZJwKOZekEZ5L4D-Dg@mail.gmail.com>	<1432285588.3929.28.camel@pengutronix.de>	<20150522091822.GF8557@lukather>	<1432289231.3929.60.camel@pengutronix.de> <CALszF6CQ1_HQXJ8=vgytvVo2t4_ue5_nsE06HPyHMzSLrntqKg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-arch-owner@vger.kernel.org>
In-Reply-To: <CALszF6CQ1_HQXJ8=vgytvVo2t4_ue5_nsE06HPyHMzSLrntqKg@mail.gmail.com>
Sender: linux-arch-owner@vger.kernel.org
To: Maxime Coquelin <mcoquelin.stm32@gmail.com>, Philipp Zabel <p.zabel@pengutronix.de>
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>, Arnd Bergmann <arnd@arndb.de>, =?UTF-8?B?VXdlIEtsZWluZS1Lw7ZuaWc=?= <u.kleine-koenig@pengutronix.de>, =?UTF-8?B?QW5kcmVhcyBGw6RyYmVy?= <afaerber@suse.de>, Geert Uytterhoeven <geert@linux-m68k.org>, Rob Herring <robh+dt@kernel.org>, Linus Walleij <linus.walleij@linaro.org>, Stefan Agner <stefan@agner.ch>, Peter Meerwald <pmeerw@pmeerw.net>, Paul Bolle <pebolle@tiscali.nl>, Peter Hurley <peter@hurleysoftware.com>, Andy Shevchenko <andy.shevchenko@gmail.com>, Chanwoo Choi <cw00.choi@samsung.com>, Russell King <linux@arm.linux.org.uk>, Daniel Lezcano <daniel.lezcano@linaro.org>, Joe Perches <joe@perches.com>, Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>, Lee Jones <lee.jones@linaro.org>, Jonathan Corbet <corbet@lwn.net>, Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>, Ian Campbell <ijc+de>
List-Id: linux-api@vger.kernel.org

On 22/05/15 13:32, Maxime Coquelin wrote:
> 2015-05-22 12:07 GMT+02:00 Philipp Zabel <p.zabel@pengutronix.de>:
>> And that's how I'd expect it to be described by the device tree:
>>
>>      rcc: rcc@40023800 {
>>          compatible = "st,stm32-rcc";
>>          reg = <0x40023800 0xc0>;
>>      };
>>
>
> Doing that, since this register bank contains both reset and clock
> registers, the reset device cannot get the IO resource at probe time
> because the clock driver has already reserved it.
> Daniel, who has started to work on the clock driver is facing this issue.
> This is why I proposed this binding for "reg" property.

Temporarily I've kept things working for me by avoiding 
of_io_request_and_map() in the clock driver (I am using raw of_iomap() 
instead).

I view this as a hack rather than a solution!

Note that, with or without the hack, I do hope to be able to post the 
clock driver this weekend. I am acutely aware that at the moment we are 
discussing code I haven't posted yet.


> We could think of creating a MFD driver, but the problem is that clock
> need to be intialized before a MFD device can be probed.
>
> Maybe there is a way to have you binding working properly, but I
> haven't found one for now.

I guess a driver doesn't *have* to reserve all the register space 
described in DT. The driver could replace of_io_request_and_map() with 
lower level calls.

Thus if we wanted to keep this detail out of DT then I guess the two 
drivers could simply make an agreement not to request registers they do 
not use.
