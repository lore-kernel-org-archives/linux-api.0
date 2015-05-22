From: Philipp Zabel <p.zabel@pengutronix.de>
Subject: Re: [PATCH v8 14/16] ARM: dts: Introduce STM32F429 MCU
Date: Fri, 22 May 2015 12:07:11 +0200
Message-ID: <1432289231.3929.60.camel@pengutronix.de>
References: <1431158038-3813-1-git-send-email-mcoquelin.stm32@gmail.com>
 <2282066.NWoIT9ZyLc@wuerfel>
 <CALszF6CaO_yuNiSDuDV+4d2NRe_+32j=zcSE1HPhB1UH59cW9w@mail.gmail.com>
 <13641152.Yt4ZI3oT6L@wuerfel>
 <CALszF6CK5ezrO6D=4zr6zEPC7VanzbQjnZJwKOZekEZ5L4D-Dg@mail.gmail.com>
 <1432285588.3929.28.camel@pengutronix.de> <20150522091822.GF8557@lukather>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20150522091822.GF8557@lukather>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Mark Rutland <mark.rutland@arm.com>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, Linus Walleij <linus.walleij@linaro.org>, Will Deacon <will.deacon@arm.com>, Stefan Agner <stefan@agner.ch>, Nikolay Borisov <Nikolay.Borisov@arm.com>, Peter Meerwald <pmeerw@pmeerw.net>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>, Lee Jones <lee.jones@linaro.org>, Mauro Carvalho Chehab <mchehab@osg.samsung.com>, Linux-Arch <linux-arch@vger.kernel.org>, Daniel Thompson <daniel.thompson@linaro.org>, Russell King <linux@arm.linux.org.uk>, Pawel Moll <pawel.moll@arm.com>, Jonathan Corbet <corbet@lwn.net>, Jiri Slaby <jslaby@suse.cz>, Daniel Lezcano <daniel.lezcano@linaro.org>, Chanwoo Choi <cw00.choi@samsung.com>, Andy Shevchenko <andy.shevchenko@gmail.com>, Antti Palosaari <crope@iki.fi>, Geert Uytterhoeven <geert@linux-m68k.org>"linux-serial@vger.kernel.org" <li>
List-Id: linux-api@vger.kernel.org

Am Freitag, den 22.05.2015, 11:18 +0200 schrieb Maxime Ripard:
> On Fri, May 22, 2015 at 11:06:28AM +0200, Philipp Zabel wrote:
> > > In the probe function, it would check the number of reg resources.
> > > If a single resource is passed, it would take it, else it would look
> > > the one named "reset".
> > > The driver and bindings would be the same for the two families, and
> > > the bindings would be backward compatible with sunxi ones.
> > > 
> > > Philip, Arnd, what do you think?
> > 
> > I'm not a fan of describing the register layout in the device tree as
> > detailed as the sunxi bindings do. I'd prefer the reg property to
> > describe the device's register address space with one entry per
> > contiguous block of registers.
> 
> That's exactly what we do.

Sorry, what I mean is 'as detailed as reusing the sunxi bindings for
stm32xx here would do'. I don't know enough about the Allwinner register
layouts to form an opinion.

The STM32F427xx/STM32F429xx manual, Table 13. "STM32F427xx and
STM32F429xx register boundary addresses" contains this entry:
    Bus    Boundary address       Peripheral
    AHB1   0x40023800-0x400238bf  RCC

And that's how I'd expect it to be described by the device tree:

    rcc: rcc@40023800 {
        compatible = "st,stm32-rcc";
        reg = <0x40023800 0xc0>;
    };

Instead of "reg = <0x40023810 0x20>" for the resets. Where in the
address range the reset, clock gate and clock configuration registers
reside could be derived from the compatible value.

> > Unifying the mostly identical drivers is a good idea though, and reusing
> > preexisting bindings is better than inventing new ones. I favor the
> > socfpga binding, but I still like the sunxi bindings and this proposal
> > better than encoding the register offset in the reset index.
> 
> I don't really get the difference between the socfpga and our bindings
> actually. Would you mind to explain a bit further what you don't like
> about it ?

The socfpga driver currently hardcodes the reset register offset (0x10)
and number of banks (4), the sunxi driver has no register offset (0x0)
and derives the number of banks from the resource size.
I'd store the internal register offsets and number of banks in the
driver, together with the compatible string.

regards
Philipp
