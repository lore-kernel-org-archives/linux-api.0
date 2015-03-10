From: Rob Herring <robherring2@gmail.com>
Subject: Re: [PATCH v2 05/18] reset: Add reset_controller_of_init() function
Date: Tue, 10 Mar 2015 16:30:40 -0500
Message-ID: <CAL_Jsq+_ridpAaUwpqo91xB6Ea1ctCWfYTYUrcZ=gB_0FiBD4g@mail.gmail.com>
References: <1424455277-29983-1-git-send-email-mcoquelin.stm32@gmail.com>
 <8729383.kvUZDm4dQz@wuerfel> <CALszF6BkTOLR+VNkRKfvEBG5ZyaYL+9fZ4EAPVu5b_imCvEQoQ@mail.gmail.com>
 <6773745.i9mx5zmPP4@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-gpio-owner@vger.kernel.org>
In-Reply-To: <6773745.i9mx5zmPP4@wuerfel>
Sender: linux-gpio-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: Maxime Coquelin <mcoquelin.stm32@gmail.com>, Maxime Ripard <maxime.ripard@free-electrons.com>, =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= <u.kleine-koenig@pengutronix.de>, =?UTF-8?Q?Andreas_F=C3=A4rber?= <afaerber@suse.de>, Geert Uytterhoeven <geert@linux-m68k.org>, Rob Herring <robh+dt@kernel.org>, Philipp Zabel <p.zabel@pengutronix.de>, Jonathan Corbet <corbet@lwn.net>, Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>, Ian Campbell <ijc+devicetree@hellion.org.uk>, Kumar Gala <galak@codeaurora.org>, Russell King <linux@arm.linux.org.uk>, Daniel Lezcano <daniel.lezcano@linaro.org>, Thomas Gleixner <tglx@linutronix.de>, Linus Walleij <linus.walleij@linaro.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Jiri Slaby <jslaby@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, "David S. Miller" <davem@davemloft.net>, Mauro Carvalho Chehab <mchehab>
List-Id: linux-api@vger.kernel.org

On Tue, Mar 10, 2015 at 3:19 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Tuesday 10 March 2015 16:28:44 Maxime Coquelin wrote:
>> 2015-03-10 16:00 GMT+01:00 Arnd Bergmann <arnd@arndb.de>:
>> > On Friday 20 February 2015 19:01:04 Maxime Coquelin wrote:
>> >> Some platforms need to initialize the reset controller before the timers.
>> >>
>> >> This patch introduces a reset_controller_of_init() function that can be
>> >> called before the timers intialization.
>> >>
>> >> Signed-off-by: Maxime Coquelin <mcoquelin.stm32@gmail.com>
>> >>
>> >
>> > Not sure about this. It seems like the cleanest approach if we get
>> > a lot of these, but then again it is probably very rare, and I'd
>> > like to avoid adding such infrastructure if it's just for one
>> > SoC. Could we add a hack in the machine initialization instead?
>>
>> Sun6i also need to initialize the reset controller early. Today, they
>> hack the machine initialization.
>> With two SoCs having the same need, what should we do?
>
> Good question, I'd like to hear some other opinions on this first.

2 is still far from the common case.

>> > I think ideally this would be done in the boot loader before we
>> > even start Linux, but I don't know if that's possible for you.
>>
>> From what I understand, the only constraint is to perform it after the
>> clock is enabled.
>> So this should be possible to do it in the bootloader, but it means
>> also adding timers clocks ungating in the bootloader.
>
> Ungating the timer clock input seems like a reasonable thing to
> do for the bootloader, I think a lot of platforms rely on this
> elsewhere (but enough of them don't, which is why we have the
> early clk init).

+1

If the bootloader is u-boot, then you need a timer anyway.

Rob
