From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
Subject: Re: [PATCH v3] gpio: lib-sysfs: Add 'wakeup' attribute
Date: Fri, 31 Oct 2014 09:16:58 -0700
Message-ID: <f16258a84ebf4797abd4496842c379f2@BN1BFFO11FD009.protection.gbl>
References: <1414434602-14263-1-git-send-email-soren.brinkmann@xilinx.com>
 <CACRpkdaduj3MaEN=hmL54ANJiP0B5MdH9qSqWRukX4H7pFt_Hw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CACRpkdaduj3MaEN=hmL54ANJiP0B5MdH9qSqWRukX4H7pFt_Hw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-api@vger.kernel.org, Alexandre Courbot <gnurou@gmail.com>, Jonathan Corbet <corbet@lwn.net>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Fri, 2014-10-31 at 08:03AM +0100, Linus Walleij wrote:
> On Mon, Oct 27, 2014 at 7:30 PM, Soren Brinkmann
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
> (...)
>=20
> Looking better!
>=20
> > +       "wakeup" ... reads as either "enabled" or "disabled". Write=
 these
> > +               strings to set/clear the 'wakeup' flag of the IRQ a=
ssociated
> > +               with this GPIO. If the IRQ has the 'wakeup' flag se=
t, it can
> > +               wake the system from sleep states.
> > +
> > +               This file exists only if the pin can generate inter=
rupts and
> > +               the driver implements the required infrastructure.
>=20
> Should this not be 0/1 rather than the string "enabled"/"disabled"?
>=20
> I think that is the common pattern in sysfs?
>=20
> Not sure, but want an indication from the ABI people.

So, as I told Alexandre, 'wakeup' including the values 'enabled' &
'disabled' is how devices that support wake expose this functionality. =
I
think this is more in line with what already exists. As reference, have
a look at https://www.kernel.org/doc/Documentation/power/devices.txt. I=
t
has a section '/sys/devices/.../power/wakeup files'.

	Thanks,
	S=C3=B6ren
