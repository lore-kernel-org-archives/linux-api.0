From: Maxime Coquelin <mcoquelin.stm32@gmail.com>
Subject: Re: [PATCH v3 10/15] serial: stm32-usart: Add STM32 USART Driver
Date: Thu, 26 Mar 2015 23:05:52 +0100
Message-ID: <CALszF6CPRqB-wOfyM6QuN3v7GNRbsaHtPv82okiLcNekoBQ2tQ@mail.gmail.com>
References: <1426197361-19290-1-git-send-email-maxime.coquelin@st.com>
	<1426197361-19290-11-git-send-email-maxime.coquelin@st.com>
	<5511ABAA.2010303@hurleysoftware.com>
	<20150326154618.GO8656@n2100.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-arch-owner@vger.kernel.org>
In-Reply-To: <20150326154618.GO8656@n2100.arm.linux.org.uk>
Sender: linux-arch-owner@vger.kernel.org
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Peter Hurley <peter@hurleysoftware.com>, =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= <u.kleine-koenig@pengutronix.de>, =?UTF-8?Q?Andreas_F=C3=A4rber?= <afaerber@suse.de>, Geert Uytterhoeven <geert@linux-m68k.org>, Rob Herring <robh+dt@kernel.org>, Philipp Zabel <p.zabel@pengutronix.de>, Linus Walleij <linus.walleij@linaro.org>, Arnd Bergmann <arnd@arndb.de>, Stefan Agner <stefan@agner.ch>, Peter Meerwald <pmeerw@pmeerw.net>, Paul Bolle <pebolle@tiscali.nl>, Jonathan Corbet <corbet@lwn.net>, Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>, Ian Campbell <ijc+devicetree@hellion.org.uk>, Kumar Gala <galak@codeaurora.org>, Daniel Lezcano <daniel.lezcano@linaro.org>, Thomas Gleixner <tglx@linutronix.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Jiri Slaby <jslaby@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, "David S. Miller" <davem@davemlo>
List-Id: linux-api@vger.kernel.org

2015-03-26 16:46 GMT+01:00 Russell King - ARM Linux <linux@arm.linux.org.uk>:
> On Tue, Mar 24, 2015 at 02:23:38PM -0400, Peter Hurley wrote:
>> Hi Maxime,
>>
>> On 03/12/2015 05:55 PM, Maxime Coquelin wrote:
>> > +static unsigned int stm32_get_mctrl(struct uart_port *port)
>> > +{
>> > +   /*
>> > +    * This routine is used for geting signals of: DTR, DCD, DSR, RI,
>> > +    * and CTS/RTS
>
> It's also worth noting that this comment is wrong.  This is used to get
> the state of DCD, DSR, RI and CTS.  DTR and RTS are *not* included
> because the core tracks their state.

OK, thanks for pointing this.
I will fix the comment in the v4.

>
> ...
>
>> > +   stm32port->clk = devm_clk_get(&pdev->dev, NULL);
>> > +
>> > +   if (WARN_ON(IS_ERR(stm32port->clk)))
>>
>> Do you really need a stack trace here? Could this be dev_err() instead?
>>
>> > +           return -EINVAL;
>
> Also, propagate the error code.
Ok.

>
>> > +
>> > +   /* ensure that clk rate is correct by enabling the clk */
>> > +   clk_prepare_enable(stm32port->clk);
>
> And remember to check the return value of clk_prepare_enable().
I will.

Thanks for the review,
Maxime

>
> --
> FTTC broadband for 0.8mile line: currently at 10.5Mbps down 400kbps up
> according to speedtest.net.
