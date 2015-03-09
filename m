From: Paul Bolle <pebolle@tiscali.nl>
Subject: Re: [PATCH v2 04/18] clocksource: Add ARM System timer driver
Date: Mon, 09 Mar 2015 22:12:32 +0100
Message-ID: <1425935552.4244.6.camel@x220>
References: <1424455277-29983-1-git-send-email-mcoquelin.stm32@gmail.com>
	 <1424455277-29983-5-git-send-email-mcoquelin.stm32@gmail.com>
	 <20150220195437.GT19388@pengutronix.de> <1424468908.24292.10.camel@x220>
	 <CALszF6Bm_Y4ZLednjpmP-hMix3gA23FwLm5hViEjr1QojUY+Mg@mail.gmail.com>
	 <1425411786.2606.24.camel@tiscali.nl>
	 <CALszF6AEThPrRe7c7nJ6q7yb2fhLMFuHJUV10sf=w0TMcqVVaw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <CALszF6AEThPrRe7c7nJ6q7yb2fhLMFuHJUV10sf=w0TMcqVVaw@mail.gmail.com>
Sender: linux-doc-owner@vger.kernel.org
To: Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc: Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= <u.kleine-koenig@pengutronix.de>, Andreas =?ISO-8859-1?Q?F=E4rber?= <afaerber@suse.de>, Geert Uytterhoeven <geert@linux-m68k.org>, Rob Herring <robh+dt@kernel.org>, Philipp Zabel <p.zabel@pengutronix.de>, Jonathan Corbet <corbet@lwn.net>, Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>, Ian Campbell <ijc+devicetree@hellion.org.uk>, Kumar Gala <galak@codeaurora.org>, Russell King <linux@arm.linux.org.uk>, Daniel Lezcano <daniel.lezcano@linaro.org>, Thomas Gleixner <tglx@linutronix.de>, Linus Walleij <linus.walleij@linaro.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Jiri Slaby <jslaby@suse.cz>, Arnd Bergmann <arnd@arndb.de>, Andrew Morton <akpm@linux-foundation.org>, "David S. Miller" <davem@davemloft.net>, Mauro Carvalho Chehab <mchehab@osg.samsung.com>, Joe Perches <joe@perches.com>, Antti
List-Id: linux-api@vger.kernel.org

On Wed, 2015-03-04 at 13:08 +0100, Maxime Coquelin wrote:
> This is because I added also support for COMPILE_TEST coverage as per
> Uwe advice,
> and thought it was necessary to have an entry for this.
> Maybe I'm just wrong?

I missed that you added COMPILE_TEST.

A quick scan of your idea doesn't show any obvious issues. (Note that I
don't really know how people actually use COMPILE_TEST. I guess things
like "make allyesconfig" are involved.)


Paul Bolle

