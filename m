From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH 02/14] ARM: ARMv7M: Enlarge vector table to 256 entries
Date: Thu, 12 Feb 2015 21:34:47 +0100
Message-ID: <CAMuHMdWESyPktOSBfVoZCb35stUbhNpbbpzSW4JfORdObgg5jw@mail.gmail.com>
References: <1423763164-5606-1-git-send-email-mcoquelin.stm32@gmail.com>
	<1423763164-5606-3-git-send-email-mcoquelin.stm32@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <1423763164-5606-3-git-send-email-mcoquelin.stm32@gmail.com>
Sender: linux-doc-owner@vger.kernel.org
To: Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc: Jonathan Corbet <corbet@lwn.net>, Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>, Ian Campbell <ijc+devicetree@hellion.org.uk>, Kumar Gala <galak@codeaurora.org>, Philipp Zabel <p.zabel@pengutronix.de>, Russell King <linux@arm.linux.org.uk>, Daniel Lezcano <daniel.lezcano@linaro.org>, Thomas Gleixner <tglx@linutronix.de>, Linus Walleij <linus.walleij@linaro.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Jiri Slaby <jslaby@suse.cz>, Arnd Bergmann <arnd@arndb.de>, Andrew Morton <akpm@linux-foundation.org>, "David S. Miller" <davem@davemloft.net>, Mauro Carvalho Chehab <mchehab@osg.samsung.com>, Joe Perches <joe@perches.com>, Antti Palosaari <crope@iki.fi>, Tejun Heo <tj@kernel.org>, Will Deacon <will.deacon@arm.com>, Nikolay Borisov <Nikolay.Borisov@arm.com>, Rusty Russell <rusty@rustcorp.com.au>, Kees
List-Id: linux-api@vger.kernel.org

On Thu, Feb 12, 2015 at 6:45 PM, Maxime Coquelin
<mcoquelin.stm32@gmail.com> wrote:
> From Cortex-M4 and M7 reference manuals, the nvic supports up to 240
> interrupts. So the number of entries in vectors table is 256.
>
> This patch adds the missing entries, and change the alignement, so that
> vector_table remains naturally aligned.

Shouldn't this depend on ARCH_STM32, or some other M4 or M7 specific
Kconfig option, to avoid wasting the space on other CPUs?

>
> Signed-off-by: Maxime Coquelin <mcoquelin.stm32@gmail.com>
> ---
>  arch/arm/kernel/entry-v7m.S | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/arch/arm/kernel/entry-v7m.S b/arch/arm/kernel/entry-v7m.S
> index 8944f49..29a461b 100644
> --- a/arch/arm/kernel/entry-v7m.S
> +++ b/arch/arm/kernel/entry-v7m.S
> @@ -117,9 +117,9 @@ ENTRY(__switch_to)
>  ENDPROC(__switch_to)
>
>         .data
> -       .align  8
> +       .align  10
>  /*
> - * Vector table (64 words => 256 bytes natural alignment)
> + * Vector table (256 words => 1024 bytes alignment)
>   */
>  ENTRY(vector_table)
>         .long   0                       @ 0 - Reset stack pointer
> @@ -138,6 +138,6 @@ ENTRY(vector_table)
>         .long   __invalid_entry         @ 13 - Reserved
>         .long   __pendsv_entry          @ 14 - PendSV
>         .long   __invalid_entry         @ 15 - SysTick
> -       .rept   64 - 16
> -       .long   __irq_entry             @ 16..64 - External Interrupts
> +       .rept   256 - 16
> +       .long   __irq_entry             @ 16..256 - External Interrupts
>         .endr
> --
> 1.9.1

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
