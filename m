From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?=
	<u.kleine-koenig@pengutronix.de>
Subject: Re: [PATCH v2 04/18] clocksource: Add ARM System timer driver
Date: Mon, 9 Mar 2015 23:17:52 +0100
Message-ID: <20150309221752.GE7525@pengutronix.de>
References: <1424455277-29983-1-git-send-email-mcoquelin.stm32@gmail.com>
 <1424455277-29983-5-git-send-email-mcoquelin.stm32@gmail.com>
 <20150220195437.GT19388@pengutronix.de>
 <1424468908.24292.10.camel@x220>
 <CALszF6Bm_Y4ZLednjpmP-hMix3gA23FwLm5hViEjr1QojUY+Mg@mail.gmail.com>
 <1425411786.2606.24.camel@tiscali.nl>
 <CALszF6AEThPrRe7c7nJ6q7yb2fhLMFuHJUV10sf=w0TMcqVVaw@mail.gmail.com>
 <1425935552.4244.6.camel@x220>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-doc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1425935552.4244.6.camel@x220>
Sender: linux-doc-owner@vger.kernel.org
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Maxime Coquelin <mcoquelin.stm32@gmail.com>, Andreas =?iso-8859-1?Q?F=E4rber?= <afaerber@suse.de>, Geert Uytterhoeven <geert@linux-m68k.org>, Rob Herring <robh+dt@kernel.org>, Philipp Zabel <p.zabel@pengutronix.de>, Jonathan Corbet <corbet@lwn.net>, Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>, Ian Campbell <ijc+devicetree@hellion.org.uk>, Kumar Gala <galak@codeaurora.org>, Russell King <linux@arm.linux.org.uk>, Daniel Lezcano <daniel.lezcano@linaro.org>, Thomas Gleixner <tglx@linutronix.de>, Linus Walleij <linus.walleij@linaro.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Jiri Slaby <jslaby@suse.cz>, Arnd Bergmann <arnd@arndb.de>, Andrew Morton <akpm@linux-foundation.org>, "David S. Miller" <davem@davemloft.net>, Mauro Carvalho Chehab <mchehab@osg.samsung.com>, Joe Perches <joe@perches.com>, Antti Palosaari <crope@iki.fi>, Tejun
List-Id: linux-api@vger.kernel.org

Hello,

On Mon, Mar 09, 2015 at 10:12:32PM +0100, Paul Bolle wrote:
> On Wed, 2015-03-04 at 13:08 +0100, Maxime Coquelin wrote:
> > This is because I added also support for COMPILE_TEST coverage as p=
er
> > Uwe advice,
> > and thought it was necessary to have an entry for this.
> > Maybe I'm just wrong?
>=20
> I missed that you added COMPILE_TEST.
>=20
> A quick scan of your idea doesn't show any obvious issues. (Note that=
 I
> don't really know how people actually use COMPILE_TEST. I guess thing=
s
> like "make allyesconfig" are involved.)
Maybe this can clearify the purpose of COMPILE_TEST:

diff --git a/init/Kconfig b/init/Kconfig
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -67,6 +67,26 @@ config COMPILE_TEST
 	  here. If you are a user/distributor, say N here to exclude useless
 	  drivers to be distributed.
=20
+	# If you are a driver author consider to adjust your driver's
+	# dependencies to make it buildable with minimal preconditions if
+	# COMPILE_TEST is enabled. This helps contributers and maintainers
+	# that might not have the necessary toolchain or kernel config handy =
and
+	# also increases compile test coverage. It's your advantage if others=
 can
+	# build your driver more easily! So for a device that is only found o=
n the
+	# foo cpu use:
+	#
+	# 	depends on CPU_FOO || COMPILE_TEST
+	#
+	# . You might have to use
+	#
+	# 	depends on CPU_FOO || (COMPILE_TEST && COOKIE)
+	#
+	# or
+	#
+	#	depends on COOKIE && (CPU_FOO || COMPILE_TEST)
+	#
+	# if your driver uses features that are only available if COOKIE is o=
n.
+
 config LOCALVERSION
 	string "Local version - append to kernel release"
 	help

--=20
Pengutronix e.K.                           | Uwe Kleine-K=F6nig        =
    |
Industrial Linux Solutions                 | http://www.pengutronix.de/=
  |
