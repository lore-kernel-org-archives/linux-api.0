From: Andy Shevchenko <andy.shevchenko-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v3 04/10] serial: mps2-uart: add MPS2 UART driver
Date: Tue, 16 Feb 2016 12:48:16 +0200
Message-ID: <CAHp75Vcx_xAY2A4XNgQ1ea_U5mUnD1+6=2FxCM3KzsRSpxgRuw@mail.gmail.com>
References: <1455617295-23736-1-git-send-email-vladimir.murzin@arm.com>
	<1455617295-23736-5-git-send-email-vladimir.murzin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1455617295-23736-5-git-send-email-vladimir.murzin-5wv7dgnIgG8@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Vladimir Murzin <vladimir.murzin-5wv7dgnIgG8@public.gmane.org>
Cc: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Russell King <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Daniel Lezcano <daniel.lezcano-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= <u.kleine-koenig-bIcnvbaLZ9MEGnE8C9+IrQ@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>, ijc+devicetree <ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org>, Kumar Gala <galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Jiri Slaby <jslaby-AlSwsSmVLrQ@public.gmane.org>, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, devicetree <devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-serial-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-serial-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-arm Mailing List <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Tue, Feb 16, 2016 at 12:08 PM, Vladimir Murzin
<vladimir.murzin-5wv7dgnIgG8@public.gmane.org> wrote:
> This driver adds support to the UART controller found on ARM MPS2
> platform.


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
> +       /*
> +        * It's never been seen in practice and it never *should* hap=
pen since
> +        * we check if there is enough room in TX buffer before sendi=
ng data.
> +        * So we keep this check in case something suspicious has hap=
pened.
> +        */
> +       if (irqflag & UARTn_INT_TX_OVERRUN) {
> +               mps2_uart_write8(port, UARTn_INT_TX_OVERRUN, UARTn_IN=
T);

> +               dev_warn(port->dev, "unexpected overrun interrupt\n")=
;

I'm not sure there is no dead lock if this happens on the same port
which is used as console.

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
> +       control &=3D ~(UARTn_CTRL_RX_GRP | UARTn_CTRL_TX_GRP);
> +
> +       mps2_uart_write8(port, control, UARTn_CTRL);
> +
> +       ret =3D request_irq(mps_port->rx_irq, mps2_uart_rxirq, 0,
> +                         MAKE_NAME(-rx), mps_port);
> +       if (ret) {
> +               dev_err(port->dev, "failed to register rxirq (%d)\n",=
 ret);
> +               goto err_no_rxirq;

It should be below, here just a plain return.

> +       }
> +
> +       ret =3D request_irq(mps_port->tx_irq, mps2_uart_txirq, 0,
> +                         MAKE_NAME(-tx), mps_port);
> +       if (ret) {
> +               dev_err(port->dev, "failed to register txirq (%d)\n",=
 ret);
> +               goto err_no_txirq;

goto err_free_rxirq;

> +       }
> +
> +       ret =3D request_irq(port->irq, mps2_uart_oerrirq, IRQF_SHARED=
,
> +                         MAKE_NAME(-overrun), mps_port);
> +
> +       if (ret) {
> +               dev_err(port->dev, "failed to register oerrirq (%d)\n=
", ret);

Why not goto pattern here as well?

goto err_free_txirq;

> +       } else {

=E2=80=A6and remove this else.

> +               control |=3D UARTn_CTRL_RX_GRP | UARTn_CTRL_TX_GRP;
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


> +static struct mps2_uart_port mps2_uart_ports[MPS2_MAX_PORTS];
> +
> +#ifdef CONFIG_SERIAL_MPS2_UART_CONSOLE
> +static void mps2_uart_console_putchar(struct uart_port *port, int ch=
)
> +{
> +       while (mps2_uart_read8(port, UARTn_STATE) & UARTn_STATE_TX_FU=
LL)
> +               cpu_relax();

Infinite?

> +
> +       mps2_uart_write8(port, ch, UARTn_DATA);
> +}

> +static int mps2_init_port(struct mps2_uart_port *mps_port,
> +                       struct platform_device *pdev)
> +{
> +       int ret;
> +       struct resource *res;

Maybe:
       struct resource *res;
       int ret;
?

--=20
With Best Regards,
Andy Shevchenko
