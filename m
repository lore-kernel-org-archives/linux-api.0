From: Johan Hovold <johan@kernel.org>
Subject: Re: [PATCH v4] gpio: lib-sysfs: Add 'wakeup' attribute
Date: Mon, 19 Jan 2015 11:10:06 +0100
Message-ID: <20150119101006.GM30960@localhost>
References: <1421351389-11660-1-git-send-email-soren.brinkmann@xilinx.com>
 <20150116111108.GG30960@localhost>
 <a4610e13d0094d40b7e0574992509ec6@BN1AFFO11FD044.protection.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-doc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <a4610e13d0094d40b7e0574992509ec6@BN1AFFO11FD044.protection.gbl>
Sender: linux-doc-owner@vger.kernel.org
To: =?iso-8859-1?Q?S=F6ren?= Brinkmann <soren.brinkmann@xilinx.com>
Cc: Johan Hovold <johan@kernel.org>, Linus Walleij <linus.walleij@linaro.org>, Alexandre Courbot <gnurou@gmail.com>, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, linux-gpio@vger.kernel.org, linux-doc@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Fri, Jan 16, 2015 at 08:49:17AM -0800, S=F6ren Brinkmann wrote:
> On Fri, 2015-01-16 at 12:11PM +0100, Johan Hovold wrote:
> > On Thu, Jan 15, 2015 at 11:49:49AM -0800, Soren Brinkmann wrote:
> > > Add an attribute 'wakeup' to the GPIO sysfs interface which allow=
s
> > > marking/unmarking a GPIO as wake IRQ.
> > > The file 'wakeup' is created in each exported GPIOs directory, if=
 an IRQ
> > > is associated with that GPIO and the irqchip implements set_wake(=
).
> > > Writing 'enabled' to that file will enable wake for that GPIO, wh=
ile
> > > writing 'disabled' will disable wake.
> > > Reading that file will return either 'disabled' or 'enabled' depe=
ning on
> > > the currently set flag for the GPIO's IRQ.
> > >=20
> > > Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
> > > Reviewed-by: Alexandre Courbot <acourbot@nvidia.com>
> > > ---
> > > Hi Linus, Johan,
> > >=20
> > > I rebased my patch. And things look good.
> >=20
> > I took at closer look at this patch now and I really don't think it
> > should be merged at all.
> >=20
> > We have a mechanism for handling wake-up sources (documented in
> > Documentation/power/devices.txt) as well as an ABI to enable/disabl=
e
> > them using the power/wakeup device attribute from userspace.
>=20
> Doesn't work for GPIOs AFAIK.

Not today no, that's why I said it would take some work.

> > Implementing proper wakeup support for unclaimed GPIOs would take s=
ome
> > work (if at all desired), but that is not a reason to be adding cus=
tom
> > implementations that violates the kernel's power policies and new A=
BIs
> > that would need to be maintained forever.
>=20
> These are claimed, by the sysfs interface.

Unclaimed by a proper device and driver in the driver model.

> > [ And we really shouldn't be adding anything to the broken gpio sys=
fs
> > interface until it's been redesigned. ]
> >=20
> > Meanwhile you can (should) use gpio-keys if you need to wake your s=
ystem
> > on gpio events.
>=20
> We had that discussion and I don't think GPIO keys is the right solut=
ion
> for every use-case.

I can see that, but this still needs to be implemented properly and not
just as a quick hack on top of the already fragile gpio sysfs-interface=
=2E

Since pretty much everyone agrees that the current interface needs to b=
e
replaced, we really shouldn't be adding more stuff to the broken
interface before that happens.

> > > But the 'is_visible' things does not behave the way I expected it=
 to.
> > > It seems to be only triggered on an export but not when attribute=
s
> > > change. Hence, in my case, everything was visiible since the init=
al
> > > state matches that, but even when changing the direction or thing=
s
> > > like that, attributes don't disappear. Is that something still wo=
rked
> > > on? Expected
> >=20
> > That's expected. We generally don't want attributes to appear or
> > disappear after the device has been registered (although there is a
> > mechanism for cases were it makes sense). This is no different from
> > how your v3 patch worked either.
>=20
> Sure, but the is_visible thing is effectively broken for GPIO. I thin=
k a
> GPIO is in a defined state when exported and the checks all work on t=
hat
> state during export. But then this state can be changed through the
> sysfs interface. So, if the initial state hides something it becomes
> unavailable for all times and, vice versa, if the initial state makes
> something visible, it will stay even when it is no longer a valid
> property to change.

Again, this is exactly how the interface has always worked, and that's
exactly how your v3, which added the attributes manually, also worked.

The group-visibility mechanism is not broken. What's broken is interfac=
e
designs based on attributes magically disappearing and reappearing afte=
r
the device has been created.

Johan
