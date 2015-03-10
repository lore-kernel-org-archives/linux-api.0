From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v2 05/18] reset: Add reset_controller_of_init() function
Date: Tue, 10 Mar 2015 21:19:55 +0100
Message-ID: <6773745.i9mx5zmPP4@wuerfel>
References: <1424455277-29983-1-git-send-email-mcoquelin.stm32@gmail.com>
 <8729383.kvUZDm4dQz@wuerfel>
 <CALszF6BkTOLR+VNkRKfvEBG5ZyaYL+9fZ4EAPVu5b_imCvEQoQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <CALszF6BkTOLR+VNkRKfvEBG5ZyaYL+9fZ4EAPVu5b_imCvEQoQ@mail.gmail.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc: Mark Rutland <mark.rutland@arm.com>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, Linus Walleij <linus.walleij@linaro.org>, Will Deacon <will.deacon@arm.com>, Nikolay Borisov <Nikolay.Borisov@arm.com>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>, Jiri Slaby <jslaby@suse.cz>, Mauro Carvalho Chehab <mchehab@osg.samsung.com>, Linux-Arch <linux-arch@vger.kernel.org>, Russell King <linux@arm.linux.org.uk>, Jonathan Corbet <corbet@lwn.net>, Daniel Lezcano <daniel.lezcano@linaro.org>, Antti Palosaari <crope@iki.fi>, Geert Uytterhoeven <geert@linux-m68k.org>, "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>, Uwe =?ISO-8859-1?Q?Kleine=2DK=F6nig?= <u.kleine-koenig@pengutronix.de>, "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>, Kees Cook <keescook@chromium.org>, Pawel Moll <pawel.moll@arm.com>, Ian Campbell <ijc+devicetree@hellion.or>
List-Id: linux-api@vger.kernel.org

On Tuesday 10 March 2015 16:28:44 Maxime Coquelin wrote:
> 2015-03-10 16:00 GMT+01:00 Arnd Bergmann <arnd@arndb.de>:
> > On Friday 20 February 2015 19:01:04 Maxime Coquelin wrote:
> >> Some platforms need to initialize the reset controller before the timers.
> >>
> >> This patch introduces a reset_controller_of_init() function that can be
> >> called before the timers intialization.
> >>
> >> Signed-off-by: Maxime Coquelin <mcoquelin.stm32@gmail.com>
> >>
> >
> > Not sure about this. It seems like the cleanest approach if we get
> > a lot of these, but then again it is probably very rare, and I'd
> > like to avoid adding such infrastructure if it's just for one
> > SoC. Could we add a hack in the machine initialization instead?
> 
> Sun6i also need to initialize the reset controller early. Today, they
> hack the machine initialization.
> With two SoCs having the same need, what should we do?

Good question, I'd like to hear some other opinions on this first.

> > I think ideally this would be done in the boot loader before we
> > even start Linux, but I don't know if that's possible for you.
> 
> From what I understand, the only constraint is to perform it after the
> clock is enabled.
> So this should be possible to do it in the bootloader, but it means
> also adding timers clocks ungating in the bootloader.

Ungating the timer clock input seems like a reasonable thing to
do for the bootloader, I think a lot of platforms rely on this
elsewhere (but enough of them don't, which is why we have the
early clk init).

	Arnd
