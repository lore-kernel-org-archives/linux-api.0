From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH 2/3] ARM: convert to generated system call tables
Date: Mon, 24 Oct 2016 11:25:03 +0200
Message-ID: <CAMuHMdVy_h6Uss9bwVK5hGD42bXeEBcBsBDwCpx_eYnT9r+=Lw@mail.gmail.com>
References: <E1bwa6s-0004ZY-4k@rmk-PC.armlinux.org.uk> <4337157.Eff9E2riVH@wuerfel>
 <20161021154856.GC1041@n2100.armlinux.org.uk> <24632117.YsmPs86ri6@wuerfel> <87eg382kv9.fsf@belgarion.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-arch-owner@vger.kernel.org>
In-Reply-To: <87eg382kv9.fsf@belgarion.home>
Sender: linux-arch-owner@vger.kernel.org
To: Robert Jarzmik <robert.jarzmik@free.fr>
Cc: Arnd Bergmann <arnd@arndb.de>, Russell King - ARM Linux <linux@armlinux.org.uk>, linux-arch <linux-arch@vger.kernel.org>, linux-api <linux-api@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: linux-api@vger.kernel.org

On Sat, Oct 22, 2016 at 10:23 PM, Robert Jarzmik <robert.jarzmik@free.fr> wrote:
> Arnd Bergmann <arnd@arndb.de> writes:
>
>> On Friday, October 21, 2016 4:48:56 PM CEST Russell King - ARM Linux wrote:
>>> What's the point of the x32 mode?
>>
>> On x86, the motivation is faster code for most use cases that
>> don't need a lot of memory, as the 64-bit opcodes have 16 registers
>> rather than 8 in 32-bit mode but 32-bit pointers have lower
>> cache footprint than 64-bit pointers.
>
> For completness, the second point of x32 AFAIU is the IP-relative addressing
> which is not available in standard 32 bit mode, which improves PIC code. For
> simple not algorithmic code (think Android HAL for example) with many shared
> libraries, it's better in the Hardware Abstraction Layer Libraries, instead of
> the push-to-stack and pop register.

But that's not an advantage compared to full am64 mode, right?

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
