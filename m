From: Maxime Coquelin <mcoquelin.stm32@gmail.com>
Subject: Re: [PATCH v9 4/5] serial: stm32-usart: Add STM32 USART Driver
Date: Wed, 10 Jun 2015 21:22:59 +0200
Message-ID: <CALszF6BhyKqKUkWpEr_Fcc_jVrhEy7cZTY3oHKyo3sZK1exUtw@mail.gmail.com>
References: <1432328616-16964-1-git-send-email-mcoquelin.stm32@gmail.com>
 <1432328616-16964-5-git-send-email-mcoquelin.stm32@gmail.com>
 <20150531215246.GA24174@kroah.com>
 <CALszF6B7_xOMvO9pRJJPNeR4JnOgAQAohSARDivzt2d1DQWP_Q@mail.gmail.com>
 <20150610154240.GC22214@kroah.com>
 <CALszF6AaS-i2MBF64mJKtY2h5Sb710Z50Mf8wHotUBysukfZbw@mail.gmail.com>
 <20150610174955.GA6527@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20150610174955.GA6527@kroah.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Mark Rutland <mark.rutland@arm.com>, "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>, Daniel Thompson <daniel.thompson@linaro.org>, Russell King <linux@arm.linux.org.uk>, Pawel Moll <pawel.moll@arm.com>, Arnd Bergmann <arnd@arndb.de>, khilman@kernel.org, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>, Daniel Lezcano <daniel.lezcano@linaro.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Kamil Lulko <rev13@wp.pl>, Rob Herring <robh+dt@kernel.org>, Geert Uytterhoeven <geert@linux-m68k.org>, "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>, =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= <u.kleine-koenig@pengutronix.de>, Kumar Gala <galak@codeaurora.org>, Thomas Gleixner <tglx@linutronix.de>, Ian Campbell <ijc+devicetree@hellion.org.uk>, Jiri Slaby <jslaby@suse.cz>, =?UTF-8?Q?Andreas_F=C3=A4rber?= <afaerber@suse.de>, linux-arm-kern
List-Id: linux-api@vger.kernel.org

2015-06-10 19:49 GMT+02:00 Greg Kroah-Hartman <gregkh@linuxfoundation.org>:
> On Wed, Jun 10, 2015 at 06:18:37PM +0200, Maxime Coquelin wrote:
>> 2015-06-10 17:42 GMT+02:00 Greg Kroah-Hartman <gregkh@linuxfoundation.org>:
>> > On Wed, Jun 10, 2015 at 01:33:22PM +0200, Maxime Coquelin wrote:
>> >> 2015-05-31 23:52 GMT+02:00 Greg Kroah-Hartman <gregkh@linuxfoundation.org>:
>> >> > On Fri, May 22, 2015 at 11:03:35PM +0200, Maxime Coquelin wrote:
>> >> >> This drivers adds support to the STM32 USART controller, which is a
>> >> >> standard serial driver.
>> >> >>
>> >> >> Tested-by: Chanwoo Choi <cw00.choi@samsung.com>
>> >> >> Reviewed-by: Peter Hurley <peter@hurleysoftware.com>
>> >> >> Reviewed-by: Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>
>> >> >> Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
>> >> >> Signed-off-by: Maxime Coquelin <mcoquelin.stm32@gmail.com>
>> >> >
>> >> > Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> >>
>> >> Thanks Greg.
>> >>
>> >> Will you apply it to your tty tree for v4.2? Or it should go in
>> >> someone else tree?
>> >
>> > It's not in my queue, I'm guessing it goes in through some other tree as
>> > there are build dependancies here preventing me from taking it.
>>
>> There should not be any build dependencies.
>> I just tested it on my x86 machine with COMPILE_TEST on both v4.1-rc1
>> and tty-next branch.
>> In both case it compiles without warnings.
>
> Ok, then feel free to resend it as a stand-alone patch please and I will
> queue it up.

Patch resent as a standalone patch.

Thanks!
Maxime
