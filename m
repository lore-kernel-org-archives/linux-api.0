From: Lyra Zhang <zhang.lyra-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v3 5/5] tty/serial: Add Spreadtrum sc9836-uart driver support
Date: Wed, 3 Dec 2014 20:08:11 +0800
Message-ID: <CAAfSe-tHbBGgi-uaGM6WEGNO1kuf9V+C1pV7P8miQSsj6Pc5dg@mail.gmail.com>
References: <1416917818-10506-1-git-send-email-chunyan.zhang@spreadtrum.com>
	<54761BFC.4020705@ti.com>
	<CAAfSe-u+g0mYGi9Adrd+YwwZ=q0-s79yCg_paB1UAVqFoufXEA@mail.gmail.com>
	<3212776.kDbe7yX4eX@wuerfel>
	<20141203101109.GB11285@n2100.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20141203101109.GB11285-l+eeeJia6m9vn6HldHNs0ANdhmdF6hFW@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Russell King - ARM Linux <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>
Cc: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, "gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org" <gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>, =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko-4mtYJXux2i+zQB+pC5nmwQ@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, "andrew-g2DYL2Zd6BY@public.gmane.org" <andrew-g2DYL2Zd6BY@public.gmane.org>, "linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "jslaby-AlSwsSmVLrQ@public.gmane.org" <jslaby-AlSwsSmVLrQ@public.gmane.org>, Ramkumar Ramachandra <artagnon-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "lanqing.liu-lxIno14LUO0EEoCn2XhGlw@public.gmane.org" <lanqing.liu-lxIno14LUO0EEoCn2XhGlw@public.gmane.org>, =?UTF-8?B?V2VpIFFpYW8gKOS5lOS8nyk=?= <wei.qiao-lxIno14LUO0EEoCn2XhGlw@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Chunyan Zhang <chunyan.zhang-lxIno14LUO0EEoCn2XhGlw@public.gmane.org>, "zhizhou.zhang" <zhizhou.zhang-lxIno14LUO0EEoCn2XhGlw@public.gmane.org>, "geng.ren-lxIno14LUO0EEoCn2XhGlw@public.gmane.org" <geng.ren-lxIno14LUO0EEoCn2XhGlw@public.gmane.org>, Murali Karicheri <m-karicheri2-l0cyMroinI0@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, linux-serial-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

2014-12-03 18:11 GMT+08:00 Russell King - ARM Linux <linux-lFZ/pmaqli4YwGPxGkYEkQ@public.gmane.org=
g.uk>:
> On Wed, Dec 03, 2014 at 10:50:17AM +0100, Arnd Bergmann wrote:
>> On Wednesday 03 December 2014 17:17:13 Lyra Zhang wrote:
>>
>> > 2014-11-27 2:29 GMT+08:00 Murali Karicheri <m-karicheri2-l0cyMroinI0@public.gmane.org>:
>> > > How about sorting this includes? asm/irq.h go first followed lin=
ux/ in alphabatical order?
>> >
>> > There are a few compile warnings if I moved asm/irq.h to the top o=
f
>> > all included files.
>>
>> The order that Murali meant is
>>
>> - first all linux/*.h headers, sorted alphabetically
>> - then all asm/*.h headers, again sorted alphabetically
>>
>> This is the recommended style in general.
>>
>> > Warning details are below:
>> >
>> > In file included from drivers/tty/serial/sprd_serial.c:14:0:
>> > ./arch/arm64/include/asm/irq.h:6:39: warning: =E2=80=98struct pt_r=
egs=E2=80=99
>> > declared inside parameter list [enabled by default]
>> >  extern void (*handle_arch_irq)(struct pt_regs *);
>> >                                        ^
>> > ./arch/arm64/include/asm/irq.h:6:39: warning: its scope is only th=
is
>> > definition or declaration, which is probably not what you want
>> > [enabled by default]
>> > ./arch/arm64/include/asm/irq.h:8:54: warning: =E2=80=98struct pt_r=
egs=E2=80=99
>> > declared inside parameter list [enabled by default]
>> >  extern void set_handle_irq(void (*handle_irq)(struct pt_regs *));
>> >
>>
>> I would consider this a (minor) bug in asm/irq.h. If you don't mind,
>> please submit a patch to add a line with 'struct pt_regs;' to
>> asm/irq.h.
>
> A better question is: why is a modern driver using asm/irq.h in the
> first place.
>
> We used to include that file when platforms defined IRQ numbers
> statically, but modern platforms don't do that, so it shouldn't be
> required anymore.
>

OK, I see. I'll remove it in v4.

I'm very sorry that I didn't check it carefully enough and troubled
many people for this problem.
This file included the asm/irq.h before I revised it for upstreaming,
I also could not find this file was no longer needed to include.
Thank you for your reminder, I'll avoid making the same mistake, and
I'll also share my experience with my colleagues to keep them from
having this mistake in the future.

Best regards,
Chunyan
