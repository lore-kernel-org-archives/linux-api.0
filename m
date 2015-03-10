From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v2 05/18] reset: Add reset_controller_of_init() function
Date: Tue, 10 Mar 2015 16:00:44 +0100
Message-ID: <8729383.kvUZDm4dQz@wuerfel>
References: <1424455277-29983-1-git-send-email-mcoquelin.stm32@gmail.com> <1424455277-29983-6-git-send-email-mcoquelin.stm32@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <1424455277-29983-6-git-send-email-mcoquelin.stm32@gmail.com>
Sender: linux-doc-owner@vger.kernel.org
To: Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc: u.kleine-koenig@pengutronix.de, afaerber@suse.de, geert@linux-m68k.org, Rob Herring <robh+dt@kernel.org>, Philipp Zabel <p.zabel@pengutronix.de>, Jonathan Corbet <corbet@lwn.net>, Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>, Ian Campbell <ijc+devicetree@hellion.org.uk>, Kumar Gala <galak@codeaurora.org>, Russell King <linux@arm.linux.org.uk>, Daniel Lezcano <daniel.lezcano@linaro.org>, Thomas Gleixner <tglx@linutronix.de>, Linus Walleij <linus.walleij@linaro.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Jiri Slaby <jslaby@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, "David S. Miller" <davem@davemloft.net>, Mauro Carvalho Chehab <mchehab@osg.samsung.com>, Joe Perches <joe@perches.com>, Antti Palosaari <crope@iki.fi>, Tejun Heo <tj@kernel.org>, Will Deacon <will.deacon@arm.com>, Nikolay Borisov <Nikolay.Borisov@arm.com>Rus
List-Id: linux-api@vger.kernel.org

On Friday 20 February 2015 19:01:04 Maxime Coquelin wrote:
> Some platforms need to initialize the reset controller before the timers.
> 
> This patch introduces a reset_controller_of_init() function that can be
> called before the timers intialization.
> 
> Signed-off-by: Maxime Coquelin <mcoquelin.stm32@gmail.com>
> 

Not sure about this. It seems like the cleanest approach if we get
a lot of these, but then again it is probably very rare, and I'd
like to avoid adding such infrastructure if it's just for one
SoC. Could we add a hack in the machine initialization instead?

I think ideally this would be done in the boot loader before we
even start Linux, but I don't know if that's possible for you.

	Arnd
