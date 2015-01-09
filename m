From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
Subject: Re: [PATCH RESEND v3] gpio: lib-sysfs: Add 'wakeup' attribute
Date: Fri, 9 Jan 2015 07:24:07 -0800
Message-ID: <1bc11e16c89049708a9273d00ac75d2b@BL2FFO11FD047.protection.gbl>
References: <1420481779-22841-1-git-send-email-soren.brinkmann@xilinx.com>
 <CACRpkda5mAtves=PZibd6jdVP1ztM0EYA+cnw7Gs+mSVXTkqpw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CACRpkda5mAtves=PZibd6jdVP1ztM0EYA+cnw7Gs+mSVXTkqpw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Alexandre Courbot <gnurou@gmail.com>, linux-api@vger.kernel.org, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Fri, 2015-01-09 at 10:32AM +0100, Linus Walleij wrote:
> On Mon, Jan 5, 2015 at 7:16 PM, Soren Brinkmann
> <soren.brinkmann@xilinx.com> wrote:
>=20
> > Add an attribute 'wakeup' to the GPIO sysfs interface which allows
> > marking/unmarking a GPIO as wake IRQ.
> > The file 'wakeup' is created in each exported GPIOs directory, if a=
n IRQ
> > is associated with that GPIO and the irqchip implements set_wake().
> > Writing 'enabled' to that file will enable wake for that GPIO, whil=
e
> > writing 'disabled' will disable wake.
> > Reading that file will return either 'disabled' or 'enabled' depeni=
ng on
> > the currently set flag for the GPIO's IRQ.
> >
> > Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
> > Reviewed-by: Alexandre Courbot <acourbot@nvidia.com>
> > ---
> > v3:
> >  - add documentation
> > v2:
> >  - fix error path to unlock mutex before return
>=20
> Finally applied for v3.20.
>=20
> Sorry for being a bit conservative and picky at times...

Thank you.

	S=C3=B6ren
