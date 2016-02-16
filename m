From: Vladimir Murzin <vladimir.murzin-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [PATCH v3 05/10] serial: mps2-uart: add support for early console
Date: Tue, 16 Feb 2016 13:38:09 +0000
Message-ID: <56C32641.4020201@arm.com>
References: <1455617295-23736-1-git-send-email-vladimir.murzin@arm.com>	<1455617295-23736-6-git-send-email-vladimir.murzin@arm.com>	<CAHp75VdugAq0WnzLHmd9CJHCjBOdBwPqCmC3ARSaVF5XMYGoMw@mail.gmail.com>	<56C31F9F.10000@arm.com> <CAHp75Vf_4MgdWunQy5hBMH5GGei+OkktFPYY-ZprY0qOEnD=wA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAHp75Vf_4MgdWunQy5hBMH5GGei+OkktFPYY-ZprY0qOEnD=wA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Shevchenko <andy.shevchenko-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Russell King <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Daniel Lezcano <daniel.lezcano-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, =?UTF-8?B?VXdlIEtsZWluZS1Lw7ZuaWc=?= <u.kleine-koenig-bIcnvbaLZ9MEGnE8C9+IrQ@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>, ijc+devicetree <ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org>, Kumar Gala <galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Jiri Slaby <jslaby-AlSwsSmVLrQ@public.gmane.org>, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, devicetree <devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-serial-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-serial-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-arm Mailing List <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 16/02/16 13:13, Andy Shevchenko wrote:
> On Tue, Feb 16, 2016 at 3:09 PM, Vladimir Murzin
> <vladimir.murzin-5wv7dgnIgG8@public.gmane.org> wrote:
>> On 16/02/16 10:36, Andy Shevchenko wrote:
>>> On Tue, Feb 16, 2016 at 12:08 PM, Vladimir Murzin
>>> <vladimir.murzin-5wv7dgnIgG8@public.gmane.org> wrote:
>>>> This adds support early console for MPS2 UART which can be enabled=
 via
>>>> earlycon=3Dmps2,0x40004000
>=20
>>>> +static void mps2_early_putchar(struct uart_port *port, int ch)
>>>> +{
>>>> +
>>>> +       while (readb(port->membase + UARTn_STATE) & UARTn_STATE_TX=
_FULL)
>>>> +               cpu_relax();
>>>
>>> Infinite busy loop?
>>
>> In case of broken hw, yes, but I'm quite unsure how we can help to f=
ix
>> it. Do you have something in mind?
>=20
> Set sane amount of loops like
>=20
> int count =3D 100;
> =E2=80=A6
> while (=E2=80=A6 && --count)
>=20
> Though I have no idea what to do if count =3D=3D 0. Perhaps it's a TX=
 overrun state.

I thought about counter too, like some of drivers do, but had no idea
what to do next after counter reaches zero. In case of TX overrun we
could get it either because of broken hw or because we entered Linux
with that state already set. In both cases, it looks handy to me to
attach a debugger and see that we are spinning in this putchar loop.

If you do insist to have a counter I'll add one, but if you are not
strong about it I'd prefer to leave it as is.

>=20
> You may try to recover by flushing TX queue in HW (fifo and / or Tx
> shift register) if HW supports it.
>=20

I'm afraid this is not supported.

Thanks
Vladimir
