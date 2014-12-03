From: Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: Re: [PATCH v3 5/5] tty/serial: Add Spreadtrum sc9836-uart driver
 support
Date: Wed, 3 Dec 2014 10:11:09 +0000
Message-ID: <20141203101109.GB11285@n2100.arm.linux.org.uk>
References: <1416917818-10506-1-git-send-email-chunyan.zhang@spreadtrum.com>
 <54761BFC.4020705@ti.com>
 <CAAfSe-u+g0mYGi9Adrd+YwwZ=q0-s79yCg_paB1UAVqFoufXEA@mail.gmail.com>
 <3212776.kDbe7yX4eX@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <3212776.kDbe7yX4eX@wuerfel>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: Lyra Zhang <zhang.lyra@gmail.com>, Mark Rutland <mark.rutland@arm.com>, "gnomes@lxorguk.ukuu.org.uk" <gnomes@lxorguk.ukuu.org.uk>, Heiko =?iso-8859-1?Q?St=FCbner?= <heiko@sntech.de>, Mark Brown <broonie@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, "andrew@lunn.ch" <andrew@lunn.ch>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>, "jslaby@suse.cz" <jslaby@suse.cz>, Ramkumar Ramachandra <artagnon@gmail.com>, "lanqing.liu@spreadtrum.com" <lanqing.liu@spreadtrum.com>, Wei Qiao =?utf-8?B?KOS5lOS8nyk=?= <wei.qiao@spreadtrum.com>, Jonathan Corbet <corbet@lwn.net>, Chunyan Zhang <chunyan.zhang@spreadtrum.com>, "zhizhou.zhang" <zhizhou.zhang@spreadtrum.com>, "geng.ren@spreadtrum.com" <geng.ren@spreadtrum.com>, Murali Karicheri <m-karicheri2@ti.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradea>
List-Id: linux-api@vger.kernel.org

On Wed, Dec 03, 2014 at 10:50:17AM +0100, Arnd Bergmann wrote:
> On Wednesday 03 December 2014 17:17:13 Lyra Zhang wrote:
>=20
> > 2014-11-27 2:29 GMT+08:00 Murali Karicheri <m-karicheri2@ti.com>:
> > > How about sorting this includes? asm/irq.h go first followed linu=
x/ in alphabatical order?
> >
> > There are a few compile warnings if I moved asm/irq.h to the top of
> > all included files.
>=20
> The order that Murali meant is
>=20
> - first all linux/*.h headers, sorted alphabetically
> - then all asm/*.h headers, again sorted alphabetically
>=20
> This is the recommended style in general.
>=20
> > Warning details are below:
> >=20
> > In file included from drivers/tty/serial/sprd_serial.c:14:0:
> > ./arch/arm64/include/asm/irq.h:6:39: warning: =E2=80=98struct pt_re=
gs=E2=80=99
> > declared inside parameter list [enabled by default]
> >  extern void (*handle_arch_irq)(struct pt_regs *);
> >                                        ^
> > ./arch/arm64/include/asm/irq.h:6:39: warning: its scope is only thi=
s
> > definition or declaration, which is probably not what you want
> > [enabled by default]
> > ./arch/arm64/include/asm/irq.h:8:54: warning: =E2=80=98struct pt_re=
gs=E2=80=99
> > declared inside parameter list [enabled by default]
> >  extern void set_handle_irq(void (*handle_irq)(struct pt_regs *));
> >=20
>=20
> I would consider this a (minor) bug in asm/irq.h. If you don't mind,
> please submit a patch to add a line with 'struct pt_regs;' to
> asm/irq.h.

A better question is: why is a modern driver using asm/irq.h in the
first place.

We used to include that file when platforms defined IRQ numbers
statically, but modern platforms don't do that, so it shouldn't be
required anymore.

--=20
=46TTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
