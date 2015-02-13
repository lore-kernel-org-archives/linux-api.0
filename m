From: Maxime Coquelin <mcoquelin.stm32@gmail.com>
Subject: Re: [PATCH 02/14] ARM: ARMv7M: Enlarge vector table to 256 entries
Date: Fri, 13 Feb 2015 09:42:46 +0100
Message-ID: <CALszF6BDa9pUb534YN2z9DbYA+hPCnG8XYy5YbjJwSiseKz4xg@mail.gmail.com>
References: <1423763164-5606-1-git-send-email-mcoquelin.stm32@gmail.com>
	<1423763164-5606-3-git-send-email-mcoquelin.stm32@gmail.com>
	<CAMuHMdWESyPktOSBfVoZCb35stUbhNpbbpzSW4JfORdObgg5jw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-arch-owner@vger.kernel.org>
In-Reply-To: <CAMuHMdWESyPktOSBfVoZCb35stUbhNpbbpzSW4JfORdObgg5jw@mail.gmail.com>
Sender: linux-arch-owner@vger.kernel.org
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Jonathan Corbet <corbet@lwn.net>, Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>, Ian Campbell <ijc+devicetree@hellion.org.uk>, Kumar Gala <galak@codeaurora.org>, Philipp Zabel <p.zabel@pengutronix.de>, Russell King <linux@arm.linux.org.uk>, Daniel Lezcano <daniel.lezcano@linaro.org>, Thomas Gleixner <tglx@linutronix.de>, Linus Walleij <linus.walleij@linaro.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Jiri Slaby <jslaby@suse.cz>, Arnd Bergmann <arnd@arndb.de>, Andrew Morton <akpm@linux-foundation.org>, "David S. Miller" <davem@davemloft.net>, Mauro Carvalho Chehab <mchehab@osg.samsung.com>, Joe Perches <joe@perches.com>, Antti Palosaari <crope@iki.fi>, Tejun Heo <tj@kernel.org>, Will Deacon <will.deacon@arm.com>, Nikolay Borisov <Nikolay.Borisov@arm.com>, Rusty Russell <rusty@rustcorp.com.au>, Kees
List-Id: linux-api@vger.kernel.org

Hi Geert,

2015-02-12 21:34 GMT+01:00 Geert Uytterhoeven <geert@linux-m68k.org>:
> On Thu, Feb 12, 2015 at 6:45 PM, Maxime Coquelin
> <mcoquelin.stm32@gmail.com> wrote:
>> From Cortex-M4 and M7 reference manuals, the nvic supports up to 240
>> interrupts. So the number of entries in vectors table is 256.
>>
>> This patch adds the missing entries, and change the alignement, so that
>> vector_table remains naturally aligned.
>
> Shouldn't this depend on ARCH_STM32, or some other M4 or M7 specific
> Kconfig option, to avoid wasting the space on other CPUs?

Actually, the STM32F429 has 90 interrupts, so it would need 106
entries in the vector table.
The maximum of supported interrupts is not only for Cortex-M4 and M7,
this is also true for Cortex-M3.

I see two possibilities:
 1 - We declare the vector table for the maximum supported number of
IRQs, as this patch does.
        - Pro: it will be functionnal with all Cortex-M MCUs
        - Con: Waste of less than 1KB for memory
 2 - We introduce a config flag that provides the number of interrupts
        - Pro: No more memory waste
        - Con: Need to declare a per MCU model config flag.

Then, regarding the natural alignment, is there a way to ensure it
depending on the value of a config flag?
Or we should keep it at the maximum value possible?

Any feedback will be appreciated, especially from Uwe who maintains
the efm32 machine.

Kind regards,
Maxime
