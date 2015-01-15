From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
Subject: Re: [PATCH RESEND v3] gpio: lib-sysfs: Add 'wakeup' attribute
Date: Thu, 15 Jan 2015 08:37:36 -0800
Message-ID: <3ac0072cbc4a4efaa7eaf071bbc321a1@BL2FFO11FD055.protection.gbl>
References: <1420481779-22841-1-git-send-email-soren.brinkmann@xilinx.com>
 <CACRpkdYJ_kZw3UfYc5vGd0cxwDJD5WR69c6Q5xTvmFnb7NOfkA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CACRpkdYJ_kZw3UfYc5vGd0cxwDJD5WR69c6Q5xTvmFnb7NOfkA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Johan Hovold <johan@kernel.org>, Alexandre Courbot <gnurou@gmail.com>, linux-api@vger.kernel.org, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Thu, 2015-01-15 at 05:34PM +0100, Linus Walleij wrote:
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
>=20
> As per discussion with Johan Hovold I have had to remove this patch
> from the development tree.
>=20
> Please rebase as indicated on the "fixes" branch, fix any resource
> leaks, include Johan Hovold on CC for review and resend.

Is that public somewhere? What are the issues?

	S=C3=B6ren
