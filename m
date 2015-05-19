From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v8 09/16] clockevents/drivers: Add STM32 Timer driver
Date: Tue, 19 May 2015 16:05:36 +0200
Message-ID: <2641240.S39i1jrT81@wuerfel>
References: <1431158038-3813-1-git-send-email-mcoquelin.stm32@gmail.com>
 <CALszF6BZKD-CPTZ6Hc85wv2Z3Y7JmUv-cMkBtbk2Ga6WeeWU=A@mail.gmail.com>
 <555B3F80.8070605@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <555B3F80.8070605@linaro.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Mark Rutland <mark.rutland@arm.com>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, Linus Walleij <linus.walleij@linaro.org>, Will Deacon <will.deacon@arm.com>, Stefan Agner <stefan@agner.ch>, Nikolay Borisov <Nikolay.Borisov@arm.com>, Peter Meerwald <pmeerw@pmeerw.net>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>, Lee Jones <lee.jones@linaro.org>, Kees Cook <keescook@chromium.org>, Linux-Arch <linux-arch@vger.kernel.org>, Daniel Thompson <daniel.thompson@linaro.org>, Russell King <linux@arm.linux.org.uk>, Jonathan Corbet <corbet@lwn.net>, Jiri Slaby <jslaby@suse.cz>, Mauro Carvalho Chehab <mchehab@osg.samsung.com>, Chanwoo Choi <cw00.choi@samsung.com>, Andy Shevchenko <andy.shevchenko@gmail.com>, Antti Palosaari <crope@iki.fi>, Geert Uytterhoeven <geert@linux-m68k.org>, "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>, Uwe
List-Id: linux-api@vger.kernel.org

On Tuesday 19 May 2015 15:49:52 Daniel Lezcano wrote:
> On 05/19/2015 03:42 PM, Maxime Coquelin wrote:
> > 2015-05-19 12:55 GMT+02:00 Arnd Bergmann <arnd@arndb.de>:
> >> Please also make it possible to select this driver on other architectures
> >> with COMPILE_TEST, so we get coverage from all the x86 test infrastructure.
> >
> > You proposal is to revert back to the original patch, except that
> > ARCH_STM32 should select CLKSRC_STM32, right?
> >
> > Daniel, what do you think?
> 
> It is not exactly as the initial patch.
> 
> I think Arnd is proposing:
> 
> config CLKSRC_STM32
>         bool "Clocksource for STM32 SoCs" if COMPILE_TEST
>         select CLKSRC_MMIO

Yes, that's fine, although we might also need a 'depends on OF'
line, not sure.

	Arnd
