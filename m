From: Lyra Zhang <zhang.lyra@gmail.com>
Subject: Re: [PATCH v3 5/5] tty/serial: Add Spreadtrum sc9836-uart driver support
Date: Thu, 27 Nov 2014 19:39:36 +0800
Message-ID: <CAAfSe-sdMVG-JV9DjQ0YYqe++r3MtgADReQHr1x54Z8xjp8pRA@mail.gmail.com>
References: <1416917818-10506-1-git-send-email-chunyan.zhang@spreadtrum.com>
	<1416917818-10506-6-git-send-email-chunyan.zhang@spreadtrum.com>
	<20141126094838.GB17980@distanz.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <20141126094838.GB17980@distanz.ch>
Sender: linux-doc-owner@vger.kernel.org
To: Tobias Klauser <tklauser@distanz.ch>
Cc: Chunyan Zhang <chunyan.zhang@spreadtrum.com>, Grant Likely <grant.likely@linaro.org>, "robh+dt@kernel.org" <robh+dt@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>, "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>, "jslaby@suse.cz" <jslaby@suse.cz>, Kumar Gala <galak@codeaurora.org>, Mark Brown <broonie@linaro.org>, Mark Rutland <mark.rutland@arm.com>, "m-karicheri2@ti.com" <m-karicheri2@ti.com>, Pawel Moll <pawel.moll@arm.com>, Ramkumar Ramachandra <artagnon@gmail.com>, "rrichter@cavium.com" <rrichter@cavium.com>, Will Deacon <will.deacon@arm.com>, Arnd Bergmann <arnd@arndb.de>, gnomes@lxorguk.ukuu.org.uk, Jonathan Corbet <corbet@lwn.net>, jason@lakedaemon.net, Mark Brown <broonie@kernel.org>, =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>, shawn.guo@freescale.com, florian.vaussard@
List-Id: linux-api@vger.kernel.org

2014-11-26 17:48 GMT+08:00 Tobias Klauser <tklauser@distanz.ch>:
> On 2014-11-25 at 13:16:58 +0100, Chunyan Zhang <chunyan.zhang@spreadtrum.com> wrote:

>> ---
[...]
>> +
>> +config SERIAL_SPRD_CONSOLE
>> +        bool "SPRD UART console support"
>> +        depends on SERIAL_SPRD=y
>> +        select SERIAL_CORE_CONSOLE
>> +     select SERIAL_EARLYCON
>> +        help
>> +       Support for early debug console using Spreadtrum's serial. This enables
>> +       the console before standard serial driver is probed. This is enabled
>> +       with "earlycon" on the kernel command line. The console is
>> +       enabled when early_param is processed.
>> +
>>  endmenu
>
> Please consistently use tabs instead of spaces for indentation. The help
> text should be indented by one tabe + 2 spaces.
>

OK, I will note it later.
[...]

>> +static inline int handle_lsr_errors(struct uart_port *port,
>> +     unsigned int *flag, unsigned int *lsr)
>
> This line should be aligned with the opening ( above.
>
OK, will change.

>> +static inline void sprd_rx(int irq, void *dev_id)
>> +{
>> +     struct uart_port *port = (struct uart_port *)dev_id;
>
> No need to cast a void pointer.
>

>> +static void sprd_console_write(struct console *co, const char *s,
>> +                                   unsigned int count)
>> +{
>> +     struct uart_port *port = (struct uart_port *)sprd_port[co->index];
>
> Better explicitly access the .port member of sprd_port[co->index] here
> instead of casting.
>

>> +     port = (struct uart_port *)sprd_port[co->index];
>
> Same here, use the .port member of struct sprd_port[co->index].
>
>> +     if (port == NULL) {
>> +             pr_info("srial port %d not yet initialized\n", co->index);
>
> Typo: should be serial instead of srial.
>

>> +     up->mapbase = mem->start;
>> +     up->membase = ioremap(mem->start, resource_size(mem));
>
> Return value of ioremap() should be checked for NULL.
>
>> +static int sprd_resume(struct platform_device *dev)
>> +{
>> +     int id = dev->id;
>> +     struct uart_port *port = (struct uart_port *)sprd_port[id];
>
> Access the .port member instead of the cast.
>
OK, will change all of the problems you pointed out in v4.
Thanks for your review.

Chunyan
