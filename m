From: Lyra Zhang <zhang.lyra@gmail.com>
Subject: Re: [PATCH v3 5/5] tty/serial: Add Spreadtrum sc9836-uart driver support
Date: Wed, 3 Dec 2014 20:15:48 +0800
Message-ID: <CAAfSe-smHeyRyaPYD7NsT8WNRhu+5uofc-oZ9rKX9Mkc2WV7Bg@mail.gmail.com>
References: <1416917818-10506-1-git-send-email-chunyan.zhang@spreadtrum.com>
	<54761BFC.4020705@ti.com>
	<CAAfSe-u+g0mYGi9Adrd+YwwZ=q0-s79yCg_paB1UAVqFoufXEA@mail.gmail.com>
	<3212776.kDbe7yX4eX@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <3212776.kDbe7yX4eX@wuerfel>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: Murali Karicheri <m-karicheri2@ti.com>, Chunyan Zhang <chunyan.zhang@spreadtrum.com>, Grant Likely <grant.likely@linaro.org>, "robh+dt@kernel.org" <robh+dt@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>, "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>, "jslaby@suse.cz" <jslaby@suse.cz>, Kumar Gala <galak@codeaurora.org>, Mark Rutland <mark.rutland@arm.com>, Pawel Moll <pawel.moll@arm.com>, Ramkumar Ramachandra <artagnon@gmail.com>, "rrichter@cavium.com" <rrichter@cavium.com>, Will Deacon <will.deacon@arm.com>, "gnomes@lxorguk.ukuu.org.uk" <gnomes@lxorguk.ukuu.org.uk>, Jonathan Corbet <corbet@lwn.net>, "jason@lakedaemon.net" <jason@lakedaemon.net>, Mark Brown <broonie@kernel.org>, =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>, "florian.vaussard@epfl.ch" <florian.vaussard@epfl.ch>
List-Id: linux-api@vger.kernel.org

2014-12-03 17:50 GMT+08:00 Arnd Bergmann <arnd@arndb.de>:
> On Wednesday 03 December 2014 17:17:13 Lyra Zhang wrote:
>
>> 2014-11-27 2:29 GMT+08:00 Murali Karicheri <m-karicheri2@ti.com>:
>> > How about sorting this includes? asm/irq.h go first followed linux=
/ in alphabatical order?
>>
>> There are a few compile warnings if I moved asm/irq.h to the top of
>> all included files.
>
> The order that Murali meant is
>
> - first all linux/*.h headers, sorted alphabetically
> - then all asm/*.h headers, again sorted alphabetically
>
> This is the recommended style in general.
>
>> Warning details are below:
>>
>> In file included from drivers/tty/serial/sprd_serial.c:14:0:
>> ./arch/arm64/include/asm/irq.h:6:39: warning: =E2=80=98struct pt_reg=
s=E2=80=99
>> declared inside parameter list [enabled by default]
>>  extern void (*handle_arch_irq)(struct pt_regs *);
>>                                        ^
>> ./arch/arm64/include/asm/irq.h:6:39: warning: its scope is only this
>> definition or declaration, which is probably not what you want
>> [enabled by default]
>> ./arch/arm64/include/asm/irq.h:8:54: warning: =E2=80=98struct pt_reg=
s=E2=80=99
>> declared inside parameter list [enabled by default]
>>  extern void set_handle_irq(void (*handle_irq)(struct pt_regs *));
>>
>
> I would consider this a (minor) bug in asm/irq.h. If you don't mind,
> please submit a patch to add a line with 'struct pt_regs;' to
> asm/irq.h.

OK, I would like to send another separate patch for this.

Best regards,
Chunyan

>
>         Arnd
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kerne=
l" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
