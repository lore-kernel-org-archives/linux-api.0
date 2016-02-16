From: Andy Shevchenko <andy.shevchenko@gmail.com>
Subject: Re: [PATCH v3 05/10] serial: mps2-uart: add support for early console
Date: Tue, 16 Feb 2016 15:13:50 +0200
Message-ID: <CAHp75Vf_4MgdWunQy5hBMH5GGei+OkktFPYY-ZprY0qOEnD=wA@mail.gmail.com>
References: <1455617295-23736-1-git-send-email-vladimir.murzin@arm.com>
	<1455617295-23736-6-git-send-email-vladimir.murzin@arm.com>
	<CAHp75VdugAq0WnzLHmd9CJHCjBOdBwPqCmC3ARSaVF5XMYGoMw@mail.gmail.com>
	<56C31F9F.10000@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <56C31F9F.10000@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Vladimir Murzin <vladimir.murzin@arm.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Russell King <linux@arm.linux.org.uk>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Daniel Lezcano <daniel.lezcano@linaro.org>, Thomas Gleixner <tglx@linutronix.de>, =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= <u.kleine-koenig@pengutronix.de>, Mark Rutland <mark.rutland@arm.com>, Pawel Moll <pawel.moll@arm.com>, ijc+devicetree <ijc+devicetree@hellion.org.uk>, Kumar Gala <galak@codeaurora.org>, Jiri Slaby <jslaby@suse.cz>, Rob Herring <robh+dt@kernel.org>, devicetree <devicetree@vger.kernel.org>, "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>, linux-arm Mailing List <linux-arm-kernel@lists.infradead.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Tue, Feb 16, 2016 at 3:09 PM, Vladimir Murzin
<vladimir.murzin@arm.com> wrote:
> On 16/02/16 10:36, Andy Shevchenko wrote:
>> On Tue, Feb 16, 2016 at 12:08 PM, Vladimir Murzin
>> <vladimir.murzin@arm.com> wrote:
>>> This adds support early console for MPS2 UART which can be enabled =
via
>>> earlycon=3Dmps2,0x40004000

>>> +static void mps2_early_putchar(struct uart_port *port, int ch)
>>> +{
>>> +
>>> +       while (readb(port->membase + UARTn_STATE) & UARTn_STATE_TX_=
=46ULL)
>>> +               cpu_relax();
>>
>> Infinite busy loop?
>
> In case of broken hw, yes, but I'm quite unsure how we can help to fi=
x
> it. Do you have something in mind?

Set sane amount of loops like

int count =3D 100;
=E2=80=A6
while (=E2=80=A6 && --count)

Though I have no idea what to do if count =3D=3D 0. Perhaps it's a TX o=
verrun state.

You may try to recover by flushing TX queue in HW (fifo and / or Tx
shift register) if HW supports it.

--=20
With Best Regards,
Andy Shevchenko
