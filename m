From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
Subject: Re: [PATCH v4] gpio: lib-sysfs: Add 'wakeup' attribute
Date: Wed, 4 Feb 2015 10:27:15 -0800
Message-ID: <ce91ced9e1f0481f8af03a168eda48b9@BN1AFFO11FD048.protection.gbl>
References: <1421351389-11660-1-git-send-email-soren.brinkmann@xilinx.com>
 <20150116111108.GG30960@localhost>
 <a4610e13d0094d40b7e0574992509ec6@BN1AFFO11FD044.protection.gbl>
 <CAAVeFu+K0W96mi0=QR8JGSe9BpH2nC5WV_9qbSvm6LJGA8gc7Q@mail.gmail.com>
 <CACRpkdZ4CekD2xeJYM+UUtuGuwS2uB++XprSueWnshEVk=79Fw@mail.gmail.com>
 <bb967ff02726449ab6525d33bccde7e4@BL2FFO11FD014.protection.gbl>
 <CACRpkdYuHdbQ7aaeCQTwZO63LjWpKyZnPQRNCBmRybntXYJxFQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-doc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CACRpkdYuHdbQ7aaeCQTwZO63LjWpKyZnPQRNCBmRybntXYJxFQ@mail.gmail.com>
Sender: linux-doc-owner@vger.kernel.org
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Alexandre Courbot <gnurou@gmail.com>, Johan Hovold <johan@kernel.org>, linux-api@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Wed, 2015-02-04 at 10:19AM +0100, Linus Walleij wrote:
> On Thu, Jan 29, 2015 at 6:23 PM, S=C3=B6ren Brinkmann
> <soren.brinkmann@xilinx.com> wrote:
> > On Mon, 2015-01-19 at 09:54AM +0100, Linus Walleij wrote:
> >> On Mon, Jan 19, 2015 at 5:20 AM, Alexandre Courbot <gnurou@gmail.c=
om> wrote:
> >> > On Sat, Jan 17, 2015 at 1:49 AM, S=C3=B6ren Brinkmann <soren.bri=
nkmann@xilinx.com> wrote:
> >> >> On Fri, 2015-01-16 at 12:11PM +0100, Johan Hovold wrote:
> >>
> >> >>> Implementing proper wakeup support for unclaimed GPIOs would t=
ake some
> >> >>> work (if at all desired), but that is not a reason to be addin=
g custom
> >> >>> implementations that violates the kernel's power policies and =
new ABIs
> >> >>> that would need to be maintained forever.
> >> (...)
> >> >>> Meanwhile you can (should) use gpio-keys if you need to wake y=
our system
> >> >>> on gpio events.
> >> >>
> >> >> We had that discussion and I don't think GPIO keys is the right=
 solution
> >> >> for every use-case.
> >> >
> >> > Sorry, it has been a while - can you remind us of why?
> >>
> >> There are such cases. Of course keys should be handled by GPIO-key=
s
> >> and these will trigger the right wakeup events in such cases.
> >>
> >> This is for more esoteric cases: we cannot have a kernel module fo=
r
> >> everything people want to do with GPIOs, and the use case I accept
> >> is GPIOs used in automatic control etc, think factory lines or doo=
rs.
> >> We can't have a "door" driver or "punch arm" or "fire alarm" drive=
r
> >> in the kernel. Those are userspace things.
> >>
> >> Still such embedded systems need to be able to go to idle and
> >> sleep to conerve power, and then they need to put wakeups on
> >> these GPIOs.
> >>
> >> So it is a feature userspace needs, though as with much of the
> >> sysfs ABI it is very often abused for things like keys and LEDs wh=
ich
> >> is an abomination but we can't do much about it :(
> >
> > Thanks for clearing that up.
> > What does that mean for this patch? Are we going ahead, accepting t=
he
> > extension of this API or do all these use-cases have to wait for th=
e
> > rewrite of a proper GPIO userspace interface?
>=20
> What needs to happen (IMHO) is to make gpio_chips properly obeying
> the device model, and then add the attributes for fiddling around wit=
h
> GPIOs to either the *real* device or create a new char device interfa=
ce.
> Whatever works best. These mock devices are fragile and never
> worked properly especially in the removal path as Johans recent
> fixes has shown.

Sure, that would be a nice long-term solution. But until then this patc=
h
would probably be welcomed by some people, without making the brokennes=
s
of this interface much worse.

	S=C3=B6ren
