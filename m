From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann-gjFFaj9aHVfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v4] gpio: lib-sysfs: Add 'wakeup' attribute
Date: Fri, 16 Jan 2015 08:49:17 -0800
Message-ID: <a4610e13d0094d40b7e0574992509ec6@BN1AFFO11FD044.protection.gbl>
References: <1421351389-11660-1-git-send-email-soren.brinkmann@xilinx.com>
 <20150116111108.GG30960@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150116111108.GG30960@localhost>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Johan Hovold <johan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Linus Walleij <linus.walleij-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Alexandre Courbot <gnurou-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-gpio-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Fri, 2015-01-16 at 12:11PM +0100, Johan Hovold wrote:
> On Thu, Jan 15, 2015 at 11:49:49AM -0800, Soren Brinkmann wrote:
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
> >=20
> > Signed-off-by: Soren Brinkmann <soren.brinkmann-gjFFaj9aHVfQT0dZR+AlfA@public.gmane.org>
> > Reviewed-by: Alexandre Courbot <acourbot-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
> > ---
> > Hi Linus, Johan,
> >=20
> > I rebased my patch. And things look good.
>=20
> I took at closer look at this patch now and I really don't think it
> should be merged at all.
>=20
> We have a mechanism for handling wake-up sources (documented in
> Documentation/power/devices.txt) as well as an ABI to enable/disable
> them using the power/wakeup device attribute from userspace.

Doesn't work for GPIOs AFAIK.

>=20
> Implementing proper wakeup support for unclaimed GPIOs would take som=
e
> work (if at all desired), but that is not a reason to be adding custo=
m
> implementations that violates the kernel's power policies and new ABI=
s
> that would need to be maintained forever.

These are claimed, by the sysfs interface.

>=20
> [ And we really shouldn't be adding anything to the broken gpio sysfs
> interface until it's been redesigned. ]
>=20
> Meanwhile you can (should) use gpio-keys if you need to wake your sys=
tem
> on gpio events.

We had that discussion and I don't think GPIO keys is the right solutio=
n
for every use-case.

>=20
> > But the 'is_visible' things does not behave the way I expected it t=
o.
> > It seems to be only triggered on an export but not when attributes
> > change. Hence, in my case, everything was visiible since the inital
> > state matches that, but even when changing the direction or things
> > like that, attributes don't disappear. Is that something still work=
ed
> > on? Expected
>=20
> That's expected. We generally don't want attributes to appear or
> disappear after the device has been registered (although there is a
> mechanism for cases were it makes sense). This is no different from
> how your v3 patch worked either.

Sure, but the is_visible thing is effectively broken for GPIO. I think =
a
GPIO is in a defined state when exported and the checks all work on tha=
t
state during export. But then this state can be changed through the
sysfs interface. So, if the initial state hides something it becomes
unavailable for all times and, vice versa, if the initial state makes
something visible, it will stay even when it is no longer a valid
property to change.

	S=C3=B6ren
