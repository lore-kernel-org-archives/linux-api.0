From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?=
	<u.kleine-koenig@pengutronix.de>
Subject: Re: [PATCH v2 02/18] ARM: ARMv7M: Enlarge vector table to 256 entries
Date: Thu, 26 Feb 2015 11:43:04 +0100
Message-ID: <20150226104304.GK7789@pengutronix.de>
References: <1424455277-29983-1-git-send-email-mcoquelin.stm32@gmail.com>
 <1424455277-29983-3-git-send-email-mcoquelin.stm32@gmail.com>
 <20150220194756.GS19388@pengutronix.de>
 <CALszF6CB9YU7ashQ-y_zx58Mkf=sbrBfa2dAOdQm7FkmcuE7PA@mail.gmail.com>
 <CALszF6B6A=de_TK0e-iJHuW4MfD9xbd-yHZHaD-JmZXwZ9CW2A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-doc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CALszF6B6A=de_TK0e-iJHuW4MfD9xbd-yHZHaD-JmZXwZ9CW2A@mail.gmail.com>
Sender: linux-doc-owner@vger.kernel.org
To: Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc: Andreas =?iso-8859-1?Q?F=E4rber?= <afaerber@suse.de>, Geert Uytterhoeven <geert@linux-m68k.org>, Rob Herring <robh+dt@kernel.org>, Philipp Zabel <p.zabel@pengutronix.de>, Jonathan Corbet <corbet@lwn.net>, Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>, Ian Campbell <ijc+devicetree@hellion.org.uk>, Kumar Gala <galak@codeaurora.org>, Russell King <linux@arm.linux.org.uk>, Daniel Lezcano <daniel.lezcano@linaro.org>, Thomas Gleixner <tglx@linutronix.de>, Linus Walleij <linus.walleij@linaro.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Jiri Slaby <jslaby@suse.cz>, Arnd Bergmann <arnd@arndb.de>, Andrew Morton <akpm@linux-foundation.org>, "David S. Miller" <davem@davemloft.net>, Mauro Carvalho Chehab <mchehab@osg.samsung.com>, Joe Perches <joe@perches.com>, Antti Palosaari <crope@iki.fi>, Tejun Heo <tj@kernel.org>, Will Deacon <will.deacon@a>
List-Id: linux-api@vger.kernel.org

On Thu, Feb 26, 2015 at 11:29:52AM +0100, Maxime Coquelin wrote:
> 2015-02-23 11:33 GMT+01:00 Maxime Coquelin <mcoquelin.stm32@gmail.com=
>:
> > 2015-02-20 20:47 GMT+01:00 Uwe Kleine-K=F6nig <u.kleine-koenig@peng=
utronix.de>:
> >> Who do you target to apply this series?
> >
> > I guess it should go through Russell's Patch Tracking System?
>=20
> Sorry, I answered your question too quickly.
> I meant this patch should go through Russell's Patch Tracking System.
>=20
> For the other patches, I think it should be picked by their respectiv=
e
> maintainers.
> Or I can create an immutable tag (on github or kernel.org?) that will
> be merged by the different sub-systems?
> What would you advise?
Depends on the interdependencies of your patches. If each maintainer ca=
n
just pick up the patches affecting his area on top of (say) 4.0-rc1 tha=
t
would be good.

Best regards
Uwe

--=20
Pengutronix e.K.                           | Uwe Kleine-K=F6nig        =
    |
Industrial Linux Solutions                 | http://www.pengutronix.de/=
  |
