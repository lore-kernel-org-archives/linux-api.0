From: Lyra Zhang <zhang.lyra@gmail.com>
Subject: Re: [PATCH v3 5/5] tty/serial: Add Spreadtrum sc9836-uart driver support
Date: Thu, 27 Nov 2014 23:23:17 +0800
Message-ID: <CAAfSe-uWvn4MX-+GKuvvd=G2MTfLDCFeLRoUGWp7vvc81wfu0w@mail.gmail.com>
References: <1416917818-10506-1-git-send-email-chunyan.zhang@spreadtrum.com>
	<54761BFC.4020705@ti.com>
	<CAAfSe-uMqy7zwiEK+nDoMPw_oni8L_vq7oW2Me5AY8z8KGpjwQ@mail.gmail.com>
	<3400511.2SONqVcoEr@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-serial-owner@vger.kernel.org>
In-Reply-To: <3400511.2SONqVcoEr@wuerfel>
Sender: linux-serial-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: Murali Karicheri <m-karicheri2@ti.com>, Chunyan Zhang <chunyan.zhang@spreadtrum.com>, Grant Likely <grant.likely@linaro.org>, "robh+dt@kernel.org" <robh+dt@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>, "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>, "jslaby@suse.cz" <jslaby@suse.cz>, Kumar Gala <galak@codeaurora.org>, Mark Rutland <mark.rutland@arm.com>, Pawel Moll <pawel.moll@arm.com>, Ramkumar Ramachandra <artagnon@gmail.com>, "rrichter@cavium.com" <rrichter@cavium.com>, Will Deacon <will.deacon@arm.com>, "gnomes@lxorguk.ukuu.org.uk" <gnomes@lxorguk.ukuu.org.uk>, Jonathan Corbet <corbet@lwn.net>, "jason@lakedaemon.net" <jason@lakedaemon.net>, Mark Brown <broonie@kernel.org>, =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>, "florian.vaussard@epfl.ch" <florian.vaussard@epfl.ch>
List-Id: linux-api@vger.kernel.org

2014-11-27 20:57 GMT+08:00 Arnd Bergmann <arnd@arndb.de>:
> On Thursday 27 November 2014 19:59:46 Lyra Zhang wrote:
>> 2014-11-27 2:29 GMT+08:00 Murali Karicheri <m-karicheri2@ti.com>:
>> > On 11/25/2014 07:16 AM, Chunyan Zhang wrote:
>> >>
>> >> Add a full sc9836-uart driver for SC9836 SoC which is based on the
>>
>> >> +#include<linux/clk.h>
>> >
>> > How about sorting this includes? asm/irq.h go first followed linux/ in
>> > alphabatical order?
>>
>> >> +static irqreturn_t sprd_handle_irq(int irq, void *dev_id)
>> >> +{
>> >> +       struct uart_port *port = (struct uart_port *)dev_id;
>> >> +       u32 ims;
>> >> +
>> >> +       ims = serial_in(port, SPRD_IMSR);
>> >> +
>> >> +       serial_out(port, SPRD_ICLR, ~0);
>> >> +
>> >> +       if (ims&  (SPRD_IMSR_RX_FIFO_FULL |
>> >> +               SPRD_IMSR_BREAK_DETECT | SPRD_IMSR_TIMEOUT)) {
>> >> +               sprd_rx(irq, port);
>> >> +       }
>> >> +       if (ims&  SPRD_IMSR_TX_FIFO_EMPTY)
>> >> +               sprd_tx(irq, port);
>> >> +
>> >> +       return IRQ_HANDLED;
>> >
>> > You are always returning IRQ_HANDLED and this is registered as a SHARED irq.
>> > Is there a chance this handler is called and the irq event doesn't
>> > belong to this device?
>> >
>> > Murali
>>
>> You are right, this is not a SHARED irq. I'll pass 0 for irqflags when
>> called 'devm_request_irq' in the next version patch.
>
> I think you could also add
>
>         if (!ims)
>                 return IRQ_NONE;
>
> which would make it work on shared interrupt lines.
>
>         Arnd

Yes, I saw this way in other serial drivers.
But, if then, there are two questions for me:
1. Why did some serial drivers need an UN_SHARED irq?
2. How can we choose a right way?

Thank you!

Best regards,
Chunyan
