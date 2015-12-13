From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v1 04/10] serial: mps2-uart: add MPS2 UART driver
Date: Sat, 12 Dec 2015 23:00:31 -0800
Message-ID: <20151213070031.GA12373@kroah.com>
References: <1449048790-25859-1-git-send-email-vladimir.murzin@arm.com>
 <1449048790-25859-5-git-send-email-vladimir.murzin@arm.com>
 <CAHp75Vd98TEQ7TiD==t=RgYOqSinWgnyRjg7V=oPXmEx0nedLQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAHp75Vd98TEQ7TiD==t=RgYOqSinWgnyRjg7V=oPXmEx0nedLQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Vladimir Murzin <vladimir.murzin@arm.com>, Arnd Bergmann <arnd@arndb.de>, Russell King <linux@arm.linux.org.uk>, Daniel Lezcano <daniel.lezcano@linaro.org>, Thomas Gleixner <tglx@linutronix.de>, Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <u.kleine-koenig@pengutronix.de>, Andreas =?iso-8859-1?Q?F=E4rber?= <afaerber@suse.de>, Maxime Coquelin <mcoquelin.stm32@gmail.com>, Mark Rutland <Mark.Rutland@arm.com>, Pawel Moll <Pawel.Moll@arm.com>, ijc+devicetree <ijc+devicetree@hellion.org.uk>, Kumar Gala <galak@codeaurora.org>, Jiri Slaby <jslaby@suse.cz>, Rob Herring <robh+dt@kernel.org>, devicetree <devicetree@vger.kernel.org>, "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>, linux-arm Mailing List <linux-arm-kernel@lists.infradead.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Sun, Dec 13, 2015 at 01:39:26AM +0200, Andy Shevchenko wrote:
> On Wed, Dec 2, 2015 at 11:33 AM, Vladimir Murzin
> <vladimir.murzin@arm.com> wrote:
> > This driver adds support to the UART controller found on ARM MPS2
> > platform.
> 
> Just few comments (have neither time not big desire to do full review).
> 
> >
> > Signed-off-by: Vladimir Murzin <vladimir.murzin@arm.com>
> > ---
> >  drivers/tty/serial/Kconfig       |   12 +
> >  drivers/tty/serial/Makefile      |    1 +
> >  drivers/tty/serial/mps2-uart.c   |  596 ++++++++++++++++++++++++++++++++++++++
> >  include/uapi/linux/serial_core.h |    3 +
> >  4 files changed, 612 insertions(+)
> >  create mode 100644 drivers/tty/serial/mps2-uart.c
> >
> > diff --git a/drivers/tty/serial/Kconfig b/drivers/tty/serial/Kconfig
> > index f38beb2..e98bfea 100644
> > --- a/drivers/tty/serial/Kconfig
> > +++ b/drivers/tty/serial/Kconfig
> > @@ -1473,6 +1473,18 @@ config SERIAL_EFM32_UART
> >           This driver support the USART and UART ports on
> >           Energy Micro's efm32 SoCs.
> >
> > +config SERIAL_MPS2_UART_CONSOLE
> > +       bool "MPS2 UART console support"
> > +       depends on SERIAL_MPS2_UART
> > +       select SERIAL_CORE_CONSOLE
> > +
> > +config SERIAL_MPS2_UART
> > +       bool "MPS2 UART port"
> > +       depends on ARM || COMPILE_TEST
> > +       select SERIAL_CORE
> > +       help
> > +         This driver support the UART ports on ARM MPS2.
> > +
> >  config SERIAL_EFM32_UART_CONSOLE
> >         bool "EFM32 UART/USART console support"
> >         depends on SERIAL_EFM32_UART=y
> > diff --git a/drivers/tty/serial/Makefile b/drivers/tty/serial/Makefile
> > index 5ab4111..7f589f5 100644
> > --- a/drivers/tty/serial/Makefile
> > +++ b/drivers/tty/serial/Makefile
> > @@ -93,6 +93,7 @@ obj-$(CONFIG_SERIAL_CONEXANT_DIGICOLOR)       += digicolor-usart.o
> >  obj-$(CONFIG_SERIAL_MEN_Z135)  += men_z135_uart.o
> >  obj-$(CONFIG_SERIAL_SPRD) += sprd_serial.o
> >  obj-$(CONFIG_SERIAL_STM32)     += stm32-usart.o
> > +obj-$(CONFIG_SERIAL_MPS2_UART) += mps2-uart.o
> >
> >  # GPIOLIB helpers for modem control lines
> >  obj-$(CONFIG_SERIAL_MCTRL_GPIO)        += serial_mctrl_gpio.o
> > diff --git a/drivers/tty/serial/mps2-uart.c b/drivers/tty/serial/mps2-uart.c
> > new file mode 100644
> > index 0000000..09bac16
> > --- /dev/null
> > +++ b/drivers/tty/serial/mps2-uart.c
> > @@ -0,0 +1,596 @@
> > +/*
> > + * Copyright (C) 2015 ARM Limited
> > + *
> > + * Author: Vladimir Murzin <vladimir.murzin@arm.com>
> > + *
> > + * This program is free software; you can redistribute it and/or modify
> > + * it under the terms of the GNU General Public License version 2 as
> > + * published by the Free Software Foundation.
> > + *
> > + * TODO: support for SysRq
> > + */
> > +
> > +#define pr_fmt(fmt)    KBUILD_MODNAME ": " fmt
> > +
> > +#include <linux/bitops.h>
> > +#include <linux/clk.h>
> > +#include <linux/console.h>
> > +#include <linux/io.h>
> > +#include <linux/kernel.h>
> > +#include <linux/module.h>
> > +#include <linux/of_device.h>
> > +#include <linux/of.h>
> > +#include <linux/platform_device.h>
> > +#include <linux/serial_core.h>
> > +#include <linux/tty_flip.h>
> > +#include <linux/types.h>
> > +
> > +#define SERIAL_NAME "ttyMPS"
> 
> Can it be ttyS?

It must be ttyS, please fix this.  Don't go creating new tty device
names, it never will work out and will eventually come back to cause
problems if you do not.

thanks,

greg k-h
