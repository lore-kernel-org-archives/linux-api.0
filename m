From: Rob Herring <robherring2@gmail.com>
Subject: Re: [PATCH 05/14] ARM: call reset_controller_of_init from default
 time_init handler
Date: Mon, 16 Feb 2015 09:48:58 -0600
Message-ID: <CAL_JsqL=A+O+J_X4aeJWeWMNg5StMJM9oosqv0Q0BZH5t=aPHQ@mail.gmail.com>
References: <1423763164-5606-1-git-send-email-mcoquelin.stm32@gmail.com>
 <1423763164-5606-6-git-send-email-mcoquelin.stm32@gmail.com>
 <CAL_Jsq+Sk0C-1UHCKE18fEVwBbV=quV9mrJSKTO_UPXWcaYfCw@mail.gmail.com> <20150215231251.GL8656@n2100.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150215231251.GL8656@n2100.arm.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Maxime Coquelin <mcoquelin.stm32@gmail.com>, Jonathan Corbet <corbet@lwn.net>, Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>, Ian Campbell <ijc+devicetree@hellion.org.uk>, Kumar Gala <galak@codeaurora.org>, Philipp Zabel <p.zabel@pengutronix.de>, Daniel Lezcano <daniel.lezcano@linaro.org>, Thomas Gleixner <tglx@linutronix.de>, Linus Walleij <linus.walleij@linaro.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Jiri Slaby <jslaby@suse.cz>, Arnd Bergmann <arnd@arndb.de>, Andrew Morton <akpm@linux-foundation.org>, "David S. Miller" <davem@davemloft.net>, Mauro Carvalho Chehab <mchehab@osg.samsung.com>, Joe Perches <joe@perches.com>, Antti Palosaari <crope@iki.fi>, Tejun Heo <tj@kernel.org>, Will Deacon <will.deacon@arm.com>, Nikolay Borisov <Nikolay.Borisov@arm.com>, Rusty Russell <rusty@rustcorp.com.au>
List-Id: linux-api@vger.kernel.org

On Sun, Feb 15, 2015 at 5:12 PM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Sun, Feb 15, 2015 at 04:17:31PM -0600, Rob Herring wrote:
>> On Thu, Feb 12, 2015 at 11:45 AM, Maxime Coquelin
>> <mcoquelin.stm32@gmail.com> wrote:
>> > Some DT ARM platforms need the reset controllers to be initialized before
>> > the timers.
>> > This is the case of the stm32 and sunxi platforms.
>>
>> I would say this is the exception, not the rule and therefore should
>> be handled in a machine desc function. Or it could be part of your
>> timer setup. Or is the bootloader's problem (like arch timer setup).
>>
>> We just want to limit how much this mechanism gets used.
>
> Can you clarify please - what is "this mechanism"?  Placing explicit
> calls at this location, or the whole OF_DECLARE_* stuff?

Well, it is both really, but I guess OF_DECLARE_ linker sections are
just an implementation detail of scattering various explicit init
calls. My concern is we'll end up with another initcall like mechanism
and the ordering problems associated with them. For example, what if
another platform needs clocks initialized before the reset controller?
I could see wanting to add gpio, pinctrl, syscon, etc. Another example
is the Beagleboard Cape folks want to read an I2C EEPROM early to
apply overlays before drivers probe. Where do we draw the line?

> Sebastian suggested using the OF_DECLARE_* stuff for the Dove PMU -
> so maybe you have a comment on that too?

I have the same position that it is the exception, not the rule, so
use the machine descriptor. I'm willing to be convinced otherwise, but
I think these cases need to be questioned.

Rob
