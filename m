From: Philipp Zabel <p.zabel@pengutronix.de>
Subject: Re: [PATCH v8 14/16] ARM: dts: Introduce STM32F429 MCU
Date: Fri, 22 May 2015 11:06:28 +0200
Message-ID: <1432285588.3929.28.camel@pengutronix.de>
References: <1431158038-3813-1-git-send-email-mcoquelin.stm32@gmail.com>
 <2282066.NWoIT9ZyLc@wuerfel>
 <CALszF6CaO_yuNiSDuDV+4d2NRe_+32j=zcSE1HPhB1UH59cW9w@mail.gmail.com>
 <13641152.Yt4ZI3oT6L@wuerfel>
 <CALszF6CK5ezrO6D=4zr6zEPC7VanzbQjnZJwKOZekEZ5L4D-Dg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <CALszF6CK5ezrO6D=4zr6zEPC7VanzbQjnZJwKOZekEZ5L4D-Dg@mail.gmail.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc: Mark Rutland <mark.rutland@arm.com>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, Linus Walleij <linus.walleij@linaro.org>, Will Deacon <will.deacon@arm.com>, Stefan Agner <stefan@agner.ch>, Nikolay Borisov <Nikolay.Borisov@arm.com>, Peter Meerwald <pmeerw@pmeerw.net>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>, Lee Jones <lee.jones@linaro.org>, Mauro Carvalho Chehab <mchehab@osg.samsung.com>, Linux-Arch <linux-arch@vger.kernel.org>, Daniel Thompson <daniel.thompson@linaro.org>, Russell King <linux@arm.linux.org.uk>, Pawel Moll <pawel.moll@arm.com>, Jonathan Corbet <corbet@lwn.net>, Jiri Slaby <jslaby@suse.cz>, Daniel Lezcano <daniel.lezcano@linaro.org>, Nicolae Rosia <nicolae.rosia@gmail.com>, Chanwoo Choi <cw00.choi@samsung.com>, Andy Shevchenko <andy.shevchenko@gmail.com>, Antti Palosaari <crope@iki.fi>, Geert Uytterhoeven <geert@linux-m68k.>
List-Id: linux-api@vger.kernel.org

Am Mittwoch, den 20.05.2015, 18:17 +0200 schrieb Maxime Coquelin:
> Hi Arnd, Philipp,
> 
> 2015-05-13 21:11 GMT+02:00 Arnd Bergmann <arnd@arndb.de>:
> > Ideally the binding should follow closely what is documented
> > in the data sheet.
> >
> 
> Daniel and myself would like your opinion about this binding:
> 
> rcc: rcc@40023800 {
>     #reset-cells = <1>;
>     #clock-cells = <2>;
>     compatible = "st,stm32-rcc";
>     reg = <0x40023800 0x10>, <0x40023810 0x20>, <0x40023830 0x20>;
>     reg-names = "clock-cfg", "reset", "clock-gates";

"reset" singular, "clock-gates" plural seems inconsistent to me.

> };
> 
> It would solve a problem Daniel is facing due to conflicting mem
> region when clock and reset drivers are enabled, as both would reserve
> the same region.
> 
> Also, it would make the reset driver very generic.
> Doing that, we could even create a generic-reset.c driver that would
> be used by STM32 and Sunxi (at least).

Adding support for providing the reset register range via of_device_id
data and the possibility to invert set/clear ops would allow to also
include the socfpga driver.

> In the probe function, it would check the number of reg resources.
> If a single resource is passed, it would take it, else it would look
> the one named "reset".
> The driver and bindings would be the same for the two families, and
> the bindings would be backward compatible with sunxi ones.
> 
> Philip, Arnd, what do you think?

I'm not a fan of describing the register layout in the device tree as
detailed as the sunxi bindings do. I'd prefer the reg property to
describe the device's register address space with one entry per
contiguous block of registers.
Unifying the mostly identical drivers is a good idea though, and reusing
preexisting bindings is better than inventing new ones. I favor the
socfpga binding, but I still like the sunxi bindings and this proposal
better than encoding the register offset in the reset index.

best regards
Philipp
