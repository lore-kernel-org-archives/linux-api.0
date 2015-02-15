From: Rob Herring <robherring2-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 02/14] ARM: ARMv7M: Enlarge vector table to 256 entries
Date: Sun, 15 Feb 2015 16:42:59 -0600
Message-ID: <CAL_Jsq+rHFPXmWqByvdG435tpbO_+ODByiMcdxboULYpUfDUmg@mail.gmail.com>
References: <1423763164-5606-1-git-send-email-mcoquelin.stm32@gmail.com>
 <1423763164-5606-3-git-send-email-mcoquelin.stm32@gmail.com>
 <CAMuHMdWESyPktOSBfVoZCb35stUbhNpbbpzSW4JfORdObgg5jw@mail.gmail.com> <CALszF6BDa9pUb534YN2z9DbYA+hPCnG8XYy5YbjJwSiseKz4xg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CALszF6BDa9pUb534YN2z9DbYA+hPCnG8XYy5YbjJwSiseKz4xg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Maxime Coquelin <mcoquelin.stm32-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Geert Uytterhoeven <geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Ian Campbell <ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org>, Kumar Gala <galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Philipp Zabel <p.zabel-bIcnvbaLZ9MEGnE8C9+IrQ@public.gmane.org>, Russell King <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, Daniel Lezcano <daniel.lezcano-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Linus Walleij <linus.walleij-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Jiri Slaby <jslaby-AlSwsSmVLrQ@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Mauro Carvalho Chehab <mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, Joe Perches <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>, Antti Palosaari <crope-X3B1VOXEql0@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Nikolay Borisov <Nikolay.Borisov-5wv7dgnIgG8@public.gmane.org>R
List-Id: linux-api@vger.kernel.org

On Fri, Feb 13, 2015 at 2:42 AM, Maxime Coquelin
<mcoquelin.stm32-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> Hi Geert,
>
> 2015-02-12 21:34 GMT+01:00 Geert Uytterhoeven <geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org>:
>> On Thu, Feb 12, 2015 at 6:45 PM, Maxime Coquelin
>> <mcoquelin.stm32-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>>> From Cortex-M4 and M7 reference manuals, the nvic supports up to 240
>>> interrupts. So the number of entries in vectors table is 256.
>>>
>>> This patch adds the missing entries, and change the alignement, so that
>>> vector_table remains naturally aligned.
>>
>> Shouldn't this depend on ARCH_STM32, or some other M4 or M7 specific
>> Kconfig option, to avoid wasting the space on other CPUs?
>
> Actually, the STM32F429 has 90 interrupts, so it would need 106
> entries in the vector table.
> The maximum of supported interrupts is not only for Cortex-M4 and M7,
> this is also true for Cortex-M3.
>
> I see two possibilities:
>  1 - We declare the vector table for the maximum supported number of
> IRQs, as this patch does.
>         - Pro: it will be functionnal with all Cortex-M MCUs
>         - Con: Waste of less than 1KB for memory

The waste depends on the alignment size as well and could be up to
almost 2KB worst case. It varies depending on the padding. We should
try to place it so it always aligned and the wasted space is
minimized.

Rob

>  2 - We introduce a config flag that provides the number of interrupts
>         - Pro: No more memory waste
>         - Con: Need to declare a per MCU model config flag.
>
> Then, regarding the natural alignment, is there a way to ensure it
> depending on the value of a config flag?
> Or we should keep it at the maximum value possible?
>
> Any feedback will be appreciated, especially from Uwe who maintains
> the efm32 machine.
>
> Kind regards,
> Maxime
