From: Maxime Coquelin <mcoquelin.stm32@gmail.com>
Subject: Re: [PATCH v8 14/16] ARM: dts: Introduce STM32F429 MCU
Date: Fri, 22 May 2015 14:32:02 +0200
Message-ID: <CALszF6CQ1_HQXJ8=vgytvVo2t4_ue5_nsE06HPyHMzSLrntqKg@mail.gmail.com>
References: <1431158038-3813-1-git-send-email-mcoquelin.stm32@gmail.com>
 <2282066.NWoIT9ZyLc@wuerfel>
 <CALszF6CaO_yuNiSDuDV+4d2NRe_+32j=zcSE1HPhB1UH59cW9w@mail.gmail.com>
 <13641152.Yt4ZI3oT6L@wuerfel>
 <CALszF6CK5ezrO6D=4zr6zEPC7VanzbQjnZJwKOZekEZ5L4D-Dg@mail.gmail.com>
 <1432285588.3929.28.camel@pengutronix.de>
 <20150522091822.GF8557@lukather>
 <1432289231.3929.60.camel@pengutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <1432289231.3929.60.camel@pengutronix.de>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: Mark Rutland <mark.rutland@arm.com>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, Linus Walleij <linus.walleij@linaro.org>, Will Deacon <will.deacon@arm.com>, Stefan Agner <stefan@agner.ch>, Nikolay Borisov <Nikolay.Borisov@arm.com>, Peter Meerwald <pmeerw@pmeerw.net>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>, Lee Jones <lee.jones@linaro.org>, Mauro Carvalho Chehab <mchehab@osg.samsung.com>, Linux-Arch <linux-arch@vger.kernel.org>, Daniel Thompson <daniel.thompson@linaro.org>, Russell King <linux@arm.linux.org.uk>, Pawel Moll <pawel.moll@arm.com>, Jonathan Corbet <corbet@lwn.net>, Jiri Slaby <jslaby@suse.cz>, Daniel Lezcano <daniel.lezcano@linaro.org>, Nicolae Rosia <nicolae.rosia@gmail.com>, Chanwoo Choi <cw00.choi@samsung.com>, Andy Shevchenko <andy.shevchenko@gmail.com>, Antti Palosaari <crope@iki.fi>, Geert Uytterhoeven <geert@linux-m68k.>
List-Id: linux-api@vger.kernel.org

2015-05-22 12:07 GMT+02:00 Philipp Zabel <p.zabel@pengutronix.de>:
> The STM32F427xx/STM32F429xx manual, Table 13. "STM32F427xx and
> STM32F429xx register boundary addresses" contains this entry:
>     Bus    Boundary address       Peripheral
>     AHB1   0x40023800-0x400238bf  RCC
>
> And that's how I'd expect it to be described by the device tree:
>
>     rcc: rcc@40023800 {
>         compatible = "st,stm32-rcc";
>         reg = <0x40023800 0xc0>;
>     };
>

Doing that, since this register bank contains both reset and clock
registers, the reset device cannot get the IO resource at probe time
because the clock driver has already reserved it.
Daniel, who has started to work on the clock driver is facing this issue.
This is why I proposed this binding for "reg" property.

We could think of creating a MFD driver, but the problem is that clock
need to be intialized before a MFD device can be probed.

Maybe there is a way to have you binding working properly, but I
haven't found one for now.

Regards,
Maxime
