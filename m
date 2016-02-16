From: Vladimir Murzin <vladimir.murzin@arm.com>
Subject: Re: [PATCH v3 04/10] serial: mps2-uart: add MPS2 UART driver
Date: Tue, 16 Feb 2016 14:25:47 +0000
Message-ID: <56C3316B.10205@arm.com>
References: <1455617295-23736-1-git-send-email-vladimir.murzin@arm.com>	<1455617295-23736-5-git-send-email-vladimir.murzin@arm.com> <CAHp75Vcx_xAY2A4XNgQ1ea_U5mUnD1+6=2FxCM3KzsRSpxgRuw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAHp75Vcx_xAY2A4XNgQ1ea_U5mUnD1+6=2FxCM3KzsRSpxgRuw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Russell King <linux@arm.linux.org.uk>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Daniel Lezcano <daniel.lezcano@linaro.org>, Thomas Gleixner <tglx@linutronix.de>, =?UTF-8?B?VXdlIEtsZWluZS1Lw7ZuaWc=?= <u.kleine-koenig@pengutronix.de>, Mark Rutland <mark.rutland@arm.com>, Pawel Moll <pawel.moll@arm.com>, ijc+devicetree <ijc+devicetree@hellion.org.uk>, Kumar Gala <galak@codeaurora.org>, Jiri Slaby <jslaby@suse.cz>, Rob Herring <robh+dt@kernel.org>, devicetree <devicetree@vger.kernel.org>, "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>, linux-arm Mailing List <linux-arm-kernel@lists.infradead.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On 16/02/16 10:48, Andy Shevchenko wrote:
> On Tue, Feb 16, 2016 at 12:08 PM, Vladimir Murzin
> <vladimir.murzin@arm.com> wrote:
>> This driver adds support to the UART controller found on ARM MPS2
>> platform.
>=20
>=20
>> +static irqreturn_t mps2_uart_oerrirq(int irq, void *data)
>> +{
>> +       irqreturn_t handled =3D IRQ_NONE;
>> +       struct uart_port *port =3D data;
>> +       u8 irqflag =3D mps2_uart_read8(port, UARTn_INT);
>> +
>> +       spin_lock(&port->lock);
>> +
>> +       if (irqflag & UARTn_INT_RX_OVERRUN) {
>> +               struct tty_port *tport =3D &port->state->port;
>> +
>> +               mps2_uart_write8(port, UARTn_INT_RX_OVERRUN, UARTn_I=
NT);
>> +               tty_insert_flip_char(tport, 0, TTY_OVERRUN);
>> +               port->icount.overrun++;
>> +               handled =3D IRQ_HANDLED;
>> +       }
>> +
>> +       /*
>> +        * It's never been seen in practice and it never *should* ha=
ppen since
>> +        * we check if there is enough room in TX buffer before send=
ing data.
>> +        * So we keep this check in case something suspicious has ha=
ppened.
>> +        */
>> +       if (irqflag & UARTn_INT_TX_OVERRUN) {
>> +               mps2_uart_write8(port, UARTn_INT_TX_OVERRUN, UARTn_I=
NT);
>=20
>> +               dev_warn(port->dev, "unexpected overrun interrupt\n"=
);
>=20
> I'm not sure there is no dead lock if this happens on the same port
> which is used as console.

Right, doesn't look like a good idea...

>=20
>> +               handled =3D IRQ_HANDLED;
>> +       }
>> +
>> +       spin_unlock(&port->lock);
>> +
>> +       return handled;
>> +}
>> +
>> +static int mps2_uart_startup(struct uart_port *port)
>> +{
>> +       struct mps2_uart_port *mps_port =3D to_mps2_port(port);
>> +       u8 control =3D mps2_uart_read8(port, UARTn_CTRL);
>> +       int ret;
>> +
>> +       control &=3D ~(UARTn_CTRL_RX_GRP | UARTn_CTRL_TX_GRP);
>> +
>> +       mps2_uart_write8(port, control, UARTn_CTRL);
>> +
>> +       ret =3D request_irq(mps_port->rx_irq, mps2_uart_rxirq, 0,
>> +                         MAKE_NAME(-rx), mps_port);
>> +       if (ret) {
>> +               dev_err(port->dev, "failed to register rxirq (%d)\n"=
, ret);
>> +               goto err_no_rxirq;
>=20
> It should be below, here just a plain return.
>=20
>> +       }
>> +
>> +       ret =3D request_irq(mps_port->tx_irq, mps2_uart_txirq, 0,
>> +                         MAKE_NAME(-tx), mps_port);
>> +       if (ret) {
>> +               dev_err(port->dev, "failed to register txirq (%d)\n"=
, ret);
>> +               goto err_no_txirq;
>=20
> goto err_free_rxirq;
>=20
>> +       }
>> +
>> +       ret =3D request_irq(port->irq, mps2_uart_oerrirq, IRQF_SHARE=
D,
>> +                         MAKE_NAME(-overrun), mps_port);
>> +
>> +       if (ret) {
>> +               dev_err(port->dev, "failed to register oerrirq (%d)\=
n", ret);
>=20
> Why not goto pattern here as well?
>=20
> goto err_free_txirq;
>=20
>> +       } else {
>=20
> =E2=80=A6and remove this else.
>=20
>> +               control |=3D UARTn_CTRL_RX_GRP | UARTn_CTRL_TX_GRP;
>> +
>> +               mps2_uart_write8(port, control, UARTn_CTRL);
>> +
>> +               return 0;
>> +       }
>> +
>> +       free_irq(mps_port->tx_irq, mps_port);
>> +err_no_txirq:
>> +       free_irq(mps_port->rx_irq, mps_port);
>> +err_no_rxirq:
>> +       return ret;
>> +}
>=20

Ok. Will rework that.

>=20
>> +static struct mps2_uart_port mps2_uart_ports[MPS2_MAX_PORTS];
>> +
>> +#ifdef CONFIG_SERIAL_MPS2_UART_CONSOLE
>> +static void mps2_uart_console_putchar(struct uart_port *port, int c=
h)
>> +{
>> +       while (mps2_uart_read8(port, UARTn_STATE) & UARTn_STATE_TX_F=
ULL)
>> +               cpu_relax();
>=20
> Infinite?
>=20

The same as for [5/10].

>> +
>> +       mps2_uart_write8(port, ch, UARTn_DATA);
>> +}
>=20
>> +static int mps2_init_port(struct mps2_uart_port *mps_port,
>> +                       struct platform_device *pdev)
>> +{
>> +       int ret;
>> +       struct resource *res;
>=20
> Maybe:
>        struct resource *res;
>        int ret;
> ?
>=20

Matter of taste :) Will change it since I need to update the patch anyw=
ay.

Thanks
Vladimir
