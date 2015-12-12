From: Andy Shevchenko <andy.shevchenko-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v1 04/10] serial: mps2-uart: add MPS2 UART driver
Date: Sun, 13 Dec 2015 01:39:26 +0200
Message-ID: <CAHp75Vd98TEQ7TiD==t=RgYOqSinWgnyRjg7V=oPXmEx0nedLQ@mail.gmail.com>
References: <1449048790-25859-1-git-send-email-vladimir.murzin@arm.com>
	<1449048790-25859-5-git-send-email-vladimir.murzin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1449048790-25859-5-git-send-email-vladimir.murzin-5wv7dgnIgG8@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Vladimir Murzin <vladimir.murzin-5wv7dgnIgG8@public.gmane.org>
Cc: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Russell King <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Daniel Lezcano <daniel.lezcano-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= <u.kleine-koenig-bIcnvbaLZ9MEGnE8C9+IrQ@public.gmane.org>, =?UTF-8?Q?Andreas_F=C3=A4rber?= <afaerber-l3A5Bk7waGM@public.gmane.org>, Maxime Coquelin <mcoquelin.stm32-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Mark Rutland <Mark.Rutland-5wv7dgnIgG8@public.gmane.org>, Pawel Moll <Pawel.Moll-5wv7dgnIgG8@public.gmane.org>, ijc+devicetree <ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org>, Kumar Gala <galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Jiri Slaby <jslaby-AlSwsSmVLrQ@public.gmane.org>, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, devicetree <devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-serial-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-serial-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-arm Mailing List <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Wed, Dec 2, 2015 at 11:33 AM, Vladimir Murzin
<vladimir.murzin-5wv7dgnIgG8@public.gmane.org> wrote:
> This driver adds support to the UART controller found on ARM MPS2
> platform.

Just few comments (have neither time not big desire to do full review).

>
> Signed-off-by: Vladimir Murzin <vladimir.murzin-5wv7dgnIgG8@public.gmane.org>
> ---
>  drivers/tty/serial/Kconfig       |   12 +
>  drivers/tty/serial/Makefile      |    1 +
>  drivers/tty/serial/mps2-uart.c   |  596 ++++++++++++++++++++++++++++=
++++++++++
>  include/uapi/linux/serial_core.h |    3 +
>  4 files changed, 612 insertions(+)
>  create mode 100644 drivers/tty/serial/mps2-uart.c
>
> diff --git a/drivers/tty/serial/Kconfig b/drivers/tty/serial/Kconfig
> index f38beb2..e98bfea 100644
> --- a/drivers/tty/serial/Kconfig
> +++ b/drivers/tty/serial/Kconfig
> @@ -1473,6 +1473,18 @@ config SERIAL_EFM32_UART
>           This driver support the USART and UART ports on
>           Energy Micro's efm32 SoCs.
>
> +config SERIAL_MPS2_UART_CONSOLE
> +       bool "MPS2 UART console support"
> +       depends on SERIAL_MPS2_UART
> +       select SERIAL_CORE_CONSOLE
> +
> +config SERIAL_MPS2_UART
> +       bool "MPS2 UART port"
> +       depends on ARM || COMPILE_TEST
> +       select SERIAL_CORE
> +       help
> +         This driver support the UART ports on ARM MPS2.
> +
>  config SERIAL_EFM32_UART_CONSOLE
>         bool "EFM32 UART/USART console support"
>         depends on SERIAL_EFM32_UART=3Dy
> diff --git a/drivers/tty/serial/Makefile b/drivers/tty/serial/Makefil=
e
> index 5ab4111..7f589f5 100644
> --- a/drivers/tty/serial/Makefile
> +++ b/drivers/tty/serial/Makefile
> @@ -93,6 +93,7 @@ obj-$(CONFIG_SERIAL_CONEXANT_DIGICOLOR)       +=3D =
digicolor-usart.o
>  obj-$(CONFIG_SERIAL_MEN_Z135)  +=3D men_z135_uart.o
>  obj-$(CONFIG_SERIAL_SPRD) +=3D sprd_serial.o
>  obj-$(CONFIG_SERIAL_STM32)     +=3D stm32-usart.o
> +obj-$(CONFIG_SERIAL_MPS2_UART) +=3D mps2-uart.o
>
>  # GPIOLIB helpers for modem control lines
>  obj-$(CONFIG_SERIAL_MCTRL_GPIO)        +=3D serial_mctrl_gpio.o
> diff --git a/drivers/tty/serial/mps2-uart.c b/drivers/tty/serial/mps2=
-uart.c
> new file mode 100644
> index 0000000..09bac16
> --- /dev/null
> +++ b/drivers/tty/serial/mps2-uart.c
> @@ -0,0 +1,596 @@
> +/*
> + * Copyright (C) 2015 ARM Limited
> + *
> + * Author: Vladimir Murzin <vladimir.murzin-5wv7dgnIgG8@public.gmane.org>
> + *
> + * This program is free software; you can redistribute it and/or mod=
ify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + * TODO: support for SysRq
> + */
> +
> +#define pr_fmt(fmt)    KBUILD_MODNAME ": " fmt
> +
> +#include <linux/bitops.h>
> +#include <linux/clk.h>
> +#include <linux/console.h>
> +#include <linux/io.h>
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/of_device.h>
> +#include <linux/of.h>
> +#include <linux/platform_device.h>
> +#include <linux/serial_core.h>
> +#include <linux/tty_flip.h>
> +#include <linux/types.h>
> +
> +#define SERIAL_NAME "ttyMPS"

Can it be ttyS?

> +#define DRIVER_NAME "mps2-uart"
> +#define MAKE_NAME(x) (DRIVER_NAME # x)
> +
> +#define UARTn_DATA                             0x0

I think it makes sense to have same width for all offsets, i.e. 0x00
here and so on below.

> +
> +#define UARTn_STATE                            0x4
> +#define UARTn_STATE_TX_FULL                    BIT(0)
> +#define UARTn_STATE_RX_FULL                    BIT(1)
> +#define UARTn_STATE_TX_OVERRUN                 BIT(2)
> +#define UARTn_STATE_RX_OVERRUN                 BIT(3)
> +
> +#define UARTn_CTRL                             0x8
> +#define UARTn_CTRL_TX_ENABLE                   BIT(0)
> +#define UARTn_CTRL_RX_ENABLE                   BIT(1)
> +#define UARTn_CTRL_TX_INT_ENABLE               BIT(2)
> +#define UARTn_CTRL_RX_INT_ENABLE               BIT(3)
> +#define UARTn_CTRL_TX_OVERRUN_INT_ENABLE       BIT(4)
> +#define UARTn_CTRL_RX_OVERRUN_INT_ENABLE       BIT(5)
> +
> +#define UARTn_INT                              0xc
> +#define UARTn_INT_TX                           BIT(0)
> +#define UARTn_INT_RX                           BIT(1)
> +#define UARTn_INT_TX_OVERRUN                   BIT(2)
> +#define UARTn_INT_RX_OVERRUN                   BIT(3)
> +
> +#define UARTn_BAUDDIV                          0x10
> +#define UARTn_BAUDDIV_MASK                     GENMASK(20, 0)
> +
> +#define MPS2_MAX_PORTS                         3
> +
> +struct mps2_uart_port {
> +       struct uart_port port;
> +       struct clk *clk;
> +       unsigned int tx_irq;
> +       unsigned int rx_irq;
> +};
> +
> +static inline struct mps2_uart_port *to_mps2_port(struct uart_port *=
port)
> +{
> +       return container_of(port, struct mps2_uart_port, port);
> +}
> +
> +static void mps2_uart_write8(struct uart_port *port, u8 val, unsigne=
d off)
> +{
> +       struct mps2_uart_port *mps_port =3D to_mps2_port(port);
> +
> +       writeb(val, mps_port->port.membase + off);
> +}
> +
> +static u8 mps2_uart_read8(struct uart_port *port, unsigned off)
> +{
> +       struct mps2_uart_port *mps_port =3D to_mps2_port(port);
> +
> +       return readb(mps_port->port.membase + off);
> +}
> +
> +static void mps2_uart_write32(struct uart_port *port, u32 val, unsig=
ned off)
> +{
> +       struct mps2_uart_port *mps_port =3D to_mps2_port(port);
> +
> +       writel_relaxed(val, mps_port->port.membase + off);
> +}
> +
> +static unsigned int mps2_uart_tx_empty(struct uart_port *port)
> +{
> +       u8 status =3D mps2_uart_read8(port, UARTn_STATE);
> +
> +       return (status & UARTn_STATE_TX_FULL) ? 0 : TIOCSER_TEMT;
> +}
> +
> +static void mps2_uart_set_mctrl(struct uart_port *port, unsigned int=
 mctrl)
> +{
> +}
> +
> +static unsigned int mps2_uart_get_mctrl(struct uart_port *port)
> +{
> +       return TIOCM_CAR | TIOCM_CTS | TIOCM_DSR;
> +}
> +
> +static void mps2_uart_stop_tx(struct uart_port *port)
> +{
> +       u8 control =3D mps2_uart_read8(port, UARTn_CTRL);
> +
> +       control &=3D ~(UARTn_CTRL_TX_ENABLE               |
> +                    UARTn_CTRL_TX_INT_ENABLE           |
> +                    UARTn_CTRL_TX_OVERRUN_INT_ENABLE);
> +
> +       mps2_uart_write8(port, control, UARTn_CTRL);
> +}
> +
> +static void mps2_uart_tx_chars(struct uart_port *port)
> +{
> +       struct circ_buf *xmit =3D &port->state->xmit;
> +
> +       while (!(mps2_uart_read8(port, UARTn_STATE) & UARTn_STATE_TX_=
=46ULL)) {
> +               if (port->x_char) {
> +                       mps2_uart_write8(port, port->x_char, UARTn_DA=
TA);
> +                       port->x_char =3D 0;
> +                       port->icount.tx++;
> +                       continue;
> +               }
> +
> +               if (uart_circ_empty(xmit) || uart_tx_stopped(port))
> +                       break;
> +
> +               mps2_uart_write8(port, xmit->buf[xmit->tail], UARTn_D=
ATA);
> +               xmit->tail =3D (xmit->tail + 1) & (UART_XMIT_SIZE - 1=
);

More flexible here to use % UART_XMIT_SIZE. I believe compiler makes it=
 optimal.

> +               port->icount.tx++;
> +       }
> +
> +       if (uart_circ_chars_pending(xmit) < WAKEUP_CHARS)
> +               uart_write_wakeup(port);
> +
> +       if (uart_circ_empty(xmit))
> +               mps2_uart_stop_tx(port);
> +}
> +
> +static void mps2_uart_start_tx(struct uart_port *port)
> +{
> +       u8 control =3D mps2_uart_read8(port, UARTn_CTRL);
> +
> +       control |=3D (UARTn_CTRL_TX_ENABLE                |
> +                   UARTn_CTRL_TX_INT_ENABLE            |
> +                   UARTn_CTRL_TX_OVERRUN_INT_ENABLE);
> +
> +       mps2_uart_write8(port, control, UARTn_CTRL);
> +       mps2_uart_tx_chars(port);
> +}
> +
> +static void mps2_uart_stop_rx(struct uart_port *port)
> +{
> +       u8 control =3D mps2_uart_read8(port, UARTn_CTRL);
> +
> +       control &=3D ~(UARTn_CTRL_RX_ENABLE               |
> +                    UARTn_CTRL_RX_INT_ENABLE           |
> +                    UARTn_CTRL_RX_OVERRUN_INT_ENABLE);
> +
> +       mps2_uart_write8(port, control, UARTn_CTRL);
> +}
> +
> +static void mps2_uart_enable_ms(struct uart_port *port)
> +{
> +}
> +
> +static void mps2_uart_break_ctl(struct uart_port *port, int ctl)
> +{
> +}

Are those required to be present? If not, remove them until you have
alive code there.

> +
> +static void mps2_uart_rx_chars(struct uart_port *port)
> +{
> +       struct tty_port *tport =3D &port->state->port;
> +
> +       while (mps2_uart_read8(port, UARTn_STATE) & UARTn_STATE_RX_FU=
LL) {
> +               u8 rxdata =3D mps2_uart_read8(port, UARTn_DATA);
> +
> +               port->icount.rx++;
> +               tty_insert_flip_char(&port->state->port, rxdata, TTY_=
NORMAL);
> +       }
> +
> +       spin_unlock(&port->lock);
> +       tty_flip_buffer_push(tport);
> +       spin_lock(&port->lock);
> +}
> +
> +static irqreturn_t mps2_uart_rxirq(int irq, void *data)
> +{
> +
> +       struct uart_port *port =3D data;
> +       u8 irqflag =3D mps2_uart_read8(port, UARTn_INT);
> +
> +       if (unlikely(!(irqflag & UARTn_INT_RX)))
> +               return IRQ_NONE;
> +
> +       spin_lock(&port->lock);
> +
> +       mps2_uart_write8(port, UARTn_INT_RX, UARTn_INT);
> +       mps2_uart_rx_chars(port);
> +
> +       spin_unlock(&port->lock);
> +
> +       return IRQ_HANDLED;
> +}
> +
> +static irqreturn_t mps2_uart_txirq(int irq, void *data)
> +{
> +       struct uart_port *port =3D data;
> +       u8 irqflag =3D mps2_uart_read8(port, UARTn_INT);
> +
> +       if (unlikely(!(irqflag & UARTn_INT_TX)))
> +               return IRQ_NONE;
> +
> +       mps2_uart_write8(port, UARTn_INT_TX, UARTn_INT);
> +       mps2_uart_tx_chars(port);
> +
> +       return IRQ_HANDLED;
> +}
> +
> +static irqreturn_t mps2_uart_oerrirq(int irq, void *data)
> +{
> +       irqreturn_t handled =3D IRQ_NONE;
> +       struct uart_port *port =3D data;
> +       u8 irqflag =3D mps2_uart_read8(port, UARTn_INT);
> +
> +       spin_lock(&port->lock);
> +
> +       if (irqflag & UARTn_INT_RX_OVERRUN) {
> +               struct tty_port *tport =3D &port->state->port;
> +
> +               mps2_uart_write8(port, UARTn_INT_RX_OVERRUN, UARTn_IN=
T);
> +               tty_insert_flip_char(tport, 0, TTY_OVERRUN);
> +               port->icount.overrun++;
> +               handled =3D IRQ_HANDLED;
> +       }
> +
> +       /* XXX: this shouldn't happen? */

If shouldn't why it's there? Otherwise better to explain which
conditions may lead to this.

> +       if (irqflag & UARTn_INT_TX_OVERRUN) {
> +               mps2_uart_write8(port, UARTn_INT_TX_OVERRUN, UARTn_IN=
T);
> +               handled =3D IRQ_HANDLED;
> +       }
> +
> +       spin_unlock(&port->lock);
> +
> +       return handled;
> +}
> +
> +static int mps2_uart_startup(struct uart_port *port)
> +{
> +       struct mps2_uart_port *mps_port =3D to_mps2_port(port);
> +       u8 control =3D mps2_uart_read8(port, UARTn_CTRL);
> +       int ret;
> +
> +       control &=3D ~(UARTn_CTRL_RX_ENABLE               |
> +                    UARTn_CTRL_TX_ENABLE               |
> +                    UARTn_CTRL_RX_INT_ENABLE           |
> +                    UARTn_CTRL_TX_INT_ENABLE           |
> +                    UARTn_CTRL_RX_OVERRUN_INT_ENABLE   |
> +                    UARTn_CTRL_TX_OVERRUN_INT_ENABLE);


If you unifyf both RX and TX groups you may use them here, and above.

control &=3D ~(UART=E2=80=A6RX | UART=E2=80=A6TX);

Above case just RX. Maybe something alike below.

> +
> +       mps2_uart_write8(port, control, UARTn_CTRL);
> +
> +       ret =3D request_irq(mps_port->rx_irq, mps2_uart_rxirq, 0,
> +                         MAKE_NAME(-rx), mps_port);
> +       if (ret) {
> +               pr_info("failed to register rxirq (%d)\n", ret);

And why not _err() and even dev_err()? Same for stuff below.

> +               goto err_no_rxirq;
> +       }
> +
> +       ret =3D request_irq(mps_port->tx_irq, mps2_uart_txirq, 0,
> +                         MAKE_NAME(-tx), mps_port);
> +       if (ret) {
> +               pr_info("failed to register txirq (%d)\n", ret);
> +               goto err_no_txirq;
> +       }
> +
> +       ret =3D request_irq(port->irq, mps2_uart_oerrirq, IRQF_SHARED=
,
> +                         MAKE_NAME(-overrun), mps_port);
> +
> +       if (ret)
> +               pr_info("failed to register oerrirq (%d)\n", ret);
> +       else {

Keep style according to requirement.
} else {

> +               control |=3D UARTn_CTRL_RX_ENABLE                 |
> +                          UARTn_CTRL_TX_ENABLE                 |
> +                          UARTn_CTRL_RX_INT_ENABLE             |
> +                          UARTn_CTRL_TX_INT_ENABLE             |
> +                          UARTn_CTRL_RX_OVERRUN_INT_ENABLE     |
> +                          UARTn_CTRL_TX_OVERRUN_INT_ENABLE;
> +
> +               mps2_uart_write8(port, control, UARTn_CTRL);
> +
> +               return 0;
> +       }
> +
> +       free_irq(mps_port->tx_irq, mps_port);
> +err_no_txirq:
> +       free_irq(mps_port->rx_irq, mps_port);
> +err_no_rxirq:
> +       return ret;
> +}
> +
> +static void mps2_uart_shutdown(struct uart_port *port)
> +{
> +       struct mps2_uart_port *mps_port =3D to_mps2_port(port);
> +       u8 control =3D mps2_uart_read8(port, UARTn_CTRL);
> +
> +       control &=3D ~(UARTn_CTRL_RX_ENABLE               |
> +                    UARTn_CTRL_TX_ENABLE               |
> +                    UARTn_CTRL_RX_INT_ENABLE           |
> +                    UARTn_CTRL_TX_INT_ENABLE           |
> +                    UARTn_CTRL_RX_OVERRUN_INT_ENABLE   |
> +                    UARTn_CTRL_TX_OVERRUN_INT_ENABLE);

TX group + RX group, see above.

> +
> +       mps2_uart_write8(port, control, UARTn_CTRL);
> +
> +       free_irq(mps_port->rx_irq, mps_port);
> +       free_irq(mps_port->tx_irq, mps_port);
> +       free_irq(port->irq, mps_port);
> +}
> +
> +static void mps2_uart_set_termios(struct uart_port *port,
> +       struct ktermios *new, struct ktermios *old)
> +{
> +       unsigned long flags;
> +       unsigned int baud, bauddiv;
> +
> +       new->c_cflag &=3D ~(CRTSCTS | CMSPAR);
> +       new->c_cflag &=3D ~CSIZE;
> +       new->c_cflag |=3D CS8;
> +       new->c_cflag &=3D ~PARENB;
> +       new->c_cflag &=3D ~CSTOPB;
> +
> +       baud =3D uart_get_baud_rate(port, new, old,
> +                       DIV_ROUND_CLOSEST(port->uartclk, UARTn_BAUDDI=
V_MASK),
> +                       DIV_ROUND_CLOSEST(port->uartclk, 16));
> +
> +       bauddiv =3D DIV_ROUND_CLOSEST(port->uartclk, baud);
> +
> +       spin_lock_irqsave(&port->lock, flags);
> +
> +       uart_update_timeout(port, new->c_cflag, baud);
> +       mps2_uart_write32(port, bauddiv, UARTn_BAUDDIV);
> +
> +       spin_unlock_irqrestore(&port->lock, flags);
> +}
> +
> +static const char *mps2_uart_type(struct uart_port *port)
> +{
> +       return (port->type =3D=3D PORT_MPS2UART) ? DRIVER_NAME : NULL=
;
> +}
> +
> +static void mps2_uart_release_port(struct uart_port *port)
> +{
> +}
> +
> +static int mps2_uart_request_port(struct uart_port *port)
> +{
> +       return 0;
> +}
> +

Same question about empty stubs.

> +static void mps2_uart_config_port(struct uart_port *port, int type)
> +{
> +       if (type & UART_CONFIG_TYPE && !mps2_uart_request_port(port))
> +               port->type =3D PORT_MPS2UART;
> +}
> +
> +static int mps2_uart_verify_port(struct uart_port *port, struct seri=
al_struct *serinfo)
> +{
> +       return -EINVAL;
> +}
> +
> +static const struct uart_ops mps2_uart_pops =3D {
> +       .tx_empty =3D mps2_uart_tx_empty,
> +       .set_mctrl =3D mps2_uart_set_mctrl,
> +       .get_mctrl =3D mps2_uart_get_mctrl,
> +       .stop_tx =3D mps2_uart_stop_tx,
> +       .start_tx =3D mps2_uart_start_tx,
> +       .stop_rx =3D mps2_uart_stop_rx,
> +       .enable_ms =3D mps2_uart_enable_ms,
> +       .break_ctl =3D mps2_uart_break_ctl,
> +       .startup =3D mps2_uart_startup,
> +       .shutdown =3D mps2_uart_shutdown,
> +       .set_termios =3D mps2_uart_set_termios,
> +       .type =3D mps2_uart_type,
> +       .release_port =3D mps2_uart_release_port,
> +       .request_port =3D mps2_uart_request_port,
> +       .config_port =3D mps2_uart_config_port,
> +       .verify_port =3D mps2_uart_verify_port,
> +};
> +
> +static struct mps2_uart_port mps2_uart_ports[MPS2_MAX_PORTS];
> +
> +#ifdef CONFIG_SERIAL_MPS2_UART_CONSOLE
> +static void mps2_uart_console_putchar(struct uart_port *port, int ch=
)
> +{
> +       while (mps2_uart_read8(port, UARTn_STATE) & UARTn_STATE_TX_FU=
LL)
> +               cpu_relax();
> +
> +       mps2_uart_write8(port, ch, UARTn_DATA);
> +}
> +
> +static void mps2_uart_console_write(struct console *co, const char *=
s, unsigned int cnt)
> +{
> +       struct uart_port *port =3D &mps2_uart_ports[co->index].port;
> +
> +       uart_console_write(port, s, cnt, mps2_uart_console_putchar);
> +}
> +
> +static int mps2_uart_console_setup(struct console *co, char *options=
)
> +{
> +       struct mps2_uart_port *mps_port;
> +       int baud =3D 9600;
> +       int bits =3D 8;
> +       int parity =3D 'n';
> +       int flow =3D 'n';
> +
> +       if (co->index < 0 || co->index >=3D MPS2_MAX_PORTS)
> +               return -ENODEV;
> +
> +       mps_port =3D &mps2_uart_ports[co->index];
> +
> +       if (options)
> +               uart_parse_options(options, &baud, &parity, &bits, &f=
low);
> +
> +       return uart_set_options(&mps_port->port, co, baud, parity, bi=
ts, flow);
> +}
> +
> +static struct uart_driver mps2_uart_driver;
> +
> +static struct console mps2_uart_console =3D {
> +       .name =3D SERIAL_NAME,
> +       .device =3D uart_console_device,
> +       .write =3D mps2_uart_console_write,
> +       .setup =3D mps2_uart_console_setup,
> +       .flags =3D CON_PRINTBUFFER,
> +       .index =3D -1,
> +       .data =3D &mps2_uart_driver,
> +};
> +
> +#define MPS2_SERIAL_CONSOLE (&mps2_uart_console)
> +
> +#else
> +#define MPS2_SERIAL_CONSOLE NULL
> +#endif
> +
> +static struct uart_driver mps2_uart_driver =3D {
> +       .driver_name =3D DRIVER_NAME,
> +       .dev_name =3D SERIAL_NAME,
> +       .nr =3D MPS2_MAX_PORTS,
> +       .cons =3D MPS2_SERIAL_CONSOLE,
> +};
> +
> +static struct mps2_uart_port *mps2_of_get_port(struct platform_devic=
e *pdev)
> +{
> +       struct device_node *np =3D pdev->dev.of_node;
> +       int id;
> +
> +       if (!np)
> +               return NULL;
> +
> +       id =3D of_alias_get_id(np, "serial");
> +       if (id < 0)
> +               id =3D 0;
> +
> +       if (WARN_ON(id >=3D MPS2_MAX_PORTS))
> +               return NULL;
> +
> +       mps2_uart_ports[id].port.line =3D id;
> +       return &mps2_uart_ports[id];
> +}
> +
> +static int mps2_init_port(struct mps2_uart_port *mps_port,
> +                       struct platform_device *pdev)
> +{
> +       int ret =3D 0;

Redundant assignment.

> +       struct resource *res;
> +
> +       res =3D platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +       mps_port->port.membase =3D devm_ioremap_resource(&pdev->dev, =
res);
> +       if (IS_ERR(mps_port->port.membase))
> +               return PTR_ERR(mps_port->port.membase);
> +
> +       mps_port->port.mapbase =3D res->start;
> +       mps_port->port.mapsize =3D resource_size(res);
> +
> +       mps_port->rx_irq =3D platform_get_irq(pdev, 0);
> +       mps_port->tx_irq =3D platform_get_irq(pdev, 1);
> +       mps_port->port.irq =3D platform_get_irq(pdev, 2);
> +
> +       mps_port->port.iotype =3D UPIO_MEM;
> +       mps_port->port.flags =3D UPF_BOOT_AUTOCONF;
> +       mps_port->port.fifosize =3D 1;
> +       mps_port->port.ops =3D &mps2_uart_pops;
> +       mps_port->port.dev =3D &pdev->dev;
> +
> +       mps_port->clk =3D devm_clk_get(&pdev->dev, NULL);
> +       if (IS_ERR(mps_port->clk))
> +               return PTR_ERR(mps_port->clk);
> +
> +       ret =3D clk_prepare_enable(mps_port->clk);
> +       if (ret)
> +               return ret;
> +
> +       mps_port->port.uartclk =3D clk_get_rate(mps_port->clk);
> +       if (!mps_port->port.uartclk)
> +               ret =3D -EINVAL;

So, 1 is OK, 0 is not. I think 1 is too low to be provided by hardware.

> +
> +       clk_disable_unprepare(mps_port->clk);
> +
> +       return ret;
> +}
> +
> +static int mps2_serial_probe(struct platform_device *pdev)
> +{
> +       struct mps2_uart_port *mps_port;
> +       int ret;
> +
> +       mps_port =3D mps2_of_get_port(pdev);
> +       if (!mps_port)
> +               return -ENODEV;
> +
> +       ret =3D mps2_init_port(mps_port, pdev);
> +       if (ret)
> +               return ret;
> +
> +       ret =3D uart_add_one_port(&mps2_uart_driver, &mps_port->port)=
;
> +       if (ret)
> +               return ret;
> +
> +       platform_set_drvdata(pdev, mps_port);
> +
> +       return 0;
> +}
> +
> +static int mps2_serial_remove(struct platform_device *pdev)
> +{
> +       struct mps2_uart_port *mps_port =3D platform_get_drvdata(pdev=
);
> +
> +       uart_remove_one_port(&mps2_uart_driver, &mps_port->port);
> +
> +       return 0;
> +}
> +
> +#ifdef CONFIG_OF
> +static const struct of_device_id mps2_match[] =3D {
> +       { .compatible =3D "arm,mps2-uart", },
> +       {},
> +};
> +MODULE_DEVICE_TABLE(of, mps2_match);
> +#endif
> +
> +static struct platform_driver mps2_serial_driver =3D {
> +       .probe =3D mps2_serial_probe,
> +       .remove =3D mps2_serial_remove,
> +
> +       .driver =3D {
> +               .name =3D DRIVER_NAME,
> +               .of_match_table =3D of_match_ptr(mps2_match),
> +       },
> +};
> +
> +static int __init mps2_uart_init(void)
> +{
> +       int ret;
> +
> +       ret =3D uart_register_driver(&mps2_uart_driver);
> +       if (ret)
> +               return ret;
> +
> +       ret =3D platform_driver_register(&mps2_serial_driver);
> +       if (ret)
> +               uart_unregister_driver(&mps2_uart_driver);
> +
> +       pr_info("MPS2 UART driver initialized\n");
> +
> +       return ret;
> +}
> +module_init(mps2_uart_init);
> +
> +static void __exit mps2_uart_exit(void)
> +{
> +       platform_driver_unregister(&mps2_serial_driver);
> +       uart_unregister_driver(&mps2_uart_driver);
> +}
> +module_exit(mps2_uart_exit);

module_platform_driver();
And move uart_*register calls to probe/remove.

> +
> +MODULE_AUTHOR("Vladimir Murzin <vladimir.murzin-5wv7dgnIgG8@public.gmane.org>");
> +MODULE_DESCRIPTION("MPS2 UART driver");
> +MODULE_LICENSE("GPL v2");
> +MODULE_ALIAS("platform:" DRIVER_NAME);
> diff --git a/include/uapi/linux/serial_core.h b/include/uapi/linux/se=
rial_core.h
> index 93ba148..f097fe9 100644
> --- a/include/uapi/linux/serial_core.h
> +++ b/include/uapi/linux/serial_core.h
> @@ -261,4 +261,7 @@
>  /* STM32 USART */
>  #define PORT_STM32     113
>
> +/* MPS2 UART */
> +#define PORT_MPS2UART  114
> +
>  #endif /* _UAPILINUX_SERIAL_CORE_H */
> --
> 1.7.9.5
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kerne=
l" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/



--=20
With Best Regards,
Andy Shevchenko
