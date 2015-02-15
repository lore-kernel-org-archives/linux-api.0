From: Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: Re: [PATCH 05/14] ARM: call reset_controller_of_init from default
 time_init handler
Date: Sun, 15 Feb 2015 23:12:51 +0000
Message-ID: <20150215231251.GL8656@n2100.arm.linux.org.uk>
References: <1423763164-5606-1-git-send-email-mcoquelin.stm32@gmail.com>
 <1423763164-5606-6-git-send-email-mcoquelin.stm32@gmail.com>
 <CAL_Jsq+Sk0C-1UHCKE18fEVwBbV=quV9mrJSKTO_UPXWcaYfCw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-doc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAL_Jsq+Sk0C-1UHCKE18fEVwBbV=quV9mrJSKTO_UPXWcaYfCw@mail.gmail.com>
Sender: linux-doc-owner@vger.kernel.org
To: Rob Herring <robherring2@gmail.com>
Cc: Maxime Coquelin <mcoquelin.stm32@gmail.com>, Jonathan Corbet <corbet@lwn.net>, Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>, Ian Campbell <ijc+devicetree@hellion.org.uk>, Kumar Gala <galak@codeaurora.org>, Philipp Zabel <p.zabel@pengutronix.de>, Daniel Lezcano <daniel.lezcano@linaro.org>, Thomas Gleixner <tglx@linutronix.de>, Linus Walleij <linus.walleij@linaro.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Jiri Slaby <jslaby@suse.cz>, Arnd Bergmann <arnd@arndb.de>, Andrew Morton <akpm@linux-foundation.org>, "David S. Miller" <davem@davemloft.net>, Mauro Carvalho Chehab <mchehab@osg.samsung.com>, Joe Perches <joe@perches.com>, Antti Palosaari <crope@iki.fi>, Tejun Heo <tj@kernel.org>, Will Deacon <will.deacon@arm.com>, Nikolay Borisov <Nikolay.Borisov@arm.com>, Rusty Russell <rusty@rustcorp.com.au>
List-Id: linux-api@vger.kernel.org

On Sun, Feb 15, 2015 at 04:17:31PM -0600, Rob Herring wrote:
> On Thu, Feb 12, 2015 at 11:45 AM, Maxime Coquelin
> <mcoquelin.stm32@gmail.com> wrote:
> > Some DT ARM platforms need the reset controllers to be initialized before
> > the timers.
> > This is the case of the stm32 and sunxi platforms.
> 
> I would say this is the exception, not the rule and therefore should
> be handled in a machine desc function. Or it could be part of your
> timer setup. Or is the bootloader's problem (like arch timer setup).
> 
> We just want to limit how much this mechanism gets used.

Can you clarify please - what is "this mechanism"?  Placing explicit
calls at this location, or the whole OF_DECLARE_* stuff?

Sebastian suggested using the OF_DECLARE_* stuff for the Dove PMU -
so maybe you have a comment on that too?

Thanks.

-- 
FTTC broadband for 0.8mile line: currently at 10.5Mbps down 400kbps up
according to speedtest.net.
