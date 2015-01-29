From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
Subject: Re: [PATCH v4] gpio: lib-sysfs: Add 'wakeup' attribute
Date: Thu, 29 Jan 2015 09:23:14 -0800
Message-ID: <bb967ff02726449ab6525d33bccde7e4@BL2FFO11FD014.protection.gbl>
References: <1421351389-11660-1-git-send-email-soren.brinkmann@xilinx.com>
 <20150116111108.GG30960@localhost>
 <a4610e13d0094d40b7e0574992509ec6@BN1AFFO11FD044.protection.gbl>
 <CAAVeFu+K0W96mi0=QR8JGSe9BpH2nC5WV_9qbSvm6LJGA8gc7Q@mail.gmail.com>
 <CACRpkdZ4CekD2xeJYM+UUtuGuwS2uB++XprSueWnshEVk=79Fw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-gpio-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CACRpkdZ4CekD2xeJYM+UUtuGuwS2uB++XprSueWnshEVk=79Fw@mail.gmail.com>
Sender: linux-gpio-owner@vger.kernel.org
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Alexandre Courbot <gnurou@gmail.com>, Johan Hovold <johan@kernel.org>, linux-api@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

Hi Linus,

On Mon, 2015-01-19 at 09:54AM +0100, Linus Walleij wrote:
> On Mon, Jan 19, 2015 at 5:20 AM, Alexandre Courbot <gnurou@gmail.com>=
 wrote:
> > On Sat, Jan 17, 2015 at 1:49 AM, S=C3=B6ren Brinkmann <soren.brinkm=
ann@xilinx.com> wrote:
> >> On Fri, 2015-01-16 at 12:11PM +0100, Johan Hovold wrote:
>=20
> >>> Implementing proper wakeup support for unclaimed GPIOs would take=
 some
> >>> work (if at all desired), but that is not a reason to be adding c=
ustom
> >>> implementations that violates the kernel's power policies and new=
 ABIs
> >>> that would need to be maintained forever.
> (...)
> >>> Meanwhile you can (should) use gpio-keys if you need to wake your=
 system
> >>> on gpio events.
> >>
> >> We had that discussion and I don't think GPIO keys is the right so=
lution
> >> for every use-case.
> >
> > Sorry, it has been a while - can you remind us of why?
>=20
> There are such cases. Of course keys should be handled by GPIO-keys
> and these will trigger the right wakeup events in such cases.
>=20
> This is for more esoteric cases: we cannot have a kernel module for
> everything people want to do with GPIOs, and the use case I accept
> is GPIOs used in automatic control etc, think factory lines or doors.
> We can't have a "door" driver or "punch arm" or "fire alarm" driver
> in the kernel. Those are userspace things.
>=20
> Still such embedded systems need to be able to go to idle and
> sleep to conerve power, and then they need to put wakeups on
> these GPIOs.
>=20
> So it is a feature userspace needs, though as with much of the
> sysfs ABI it is very often abused for things like keys and LEDs which
> is an abomination but we can't do much about it :(

Thanks for clearing that up.
What does that mean for this patch? Are we going ahead, accepting the
extension of this API or do all these use-cases have to wait for the
rewrite of a proper GPIO userspace interface?

	Thanks,
	S=C3=B6ren
--
To unsubscribe from this list: send the line "unsubscribe linux-gpio" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
