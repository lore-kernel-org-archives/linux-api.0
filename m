From: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Subject: Re: [PATCH v3 5/5] tty/serial: Add Spreadtrum sc9836-uart driver support
Date: Wed, 03 Dec 2014 10:50:17 +0100
Message-ID: <3212776.kDbe7yX4eX@wuerfel>
References: <1416917818-10506-1-git-send-email-chunyan.zhang@spreadtrum.com> <54761BFC.4020705@ti.com> <CAAfSe-u+g0mYGi9Adrd+YwwZ=q0-s79yCg_paB1UAVqFoufXEA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAAfSe-u+g0mYGi9Adrd+YwwZ=q0-s79yCg_paB1UAVqFoufXEA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Lyra Zhang <zhang.lyra-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Murali Karicheri <m-karicheri2-l0cyMroinI0@public.gmane.org>, Chunyan Zhang <chunyan.zhang-lxIno14LUO0EEoCn2XhGlw@public.gmane.org>, Grant Likely <grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, "gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org" <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, "ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org" <ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org>, "jslaby-AlSwsSmVLrQ@public.gmane.org" <jslaby-AlSwsSmVLrQ@public.gmane.org>, Kumar Gala <galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Mark Brown <broonie-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>, Ramkumar Ramachandra <artagnon-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "rrichter-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org" <rrichter-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, "gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org" <gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, "jason-NLaQJdtUoK4Be96aLqz0jA@public.gmane.org" <jason-NLaQJdtUoK4Be96aLqz0jA@public.gmane.org>, Mark Brown <broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko-4mtYJXux2i+zQB+pC5nmwQ@public.gmane.org>, shawn.guo@freescal
List-Id: linux-api@vger.kernel.org

On Wednesday 03 December 2014 17:17:13 Lyra Zhang wrote:

> 2014-11-27 2:29 GMT+08:00 Murali Karicheri <m-karicheri2-l0cyMroinI0@public.gmane.org>:
> > How about sorting this includes? asm/irq.h go first followed linux/=
 in alphabatical order?
>
> There are a few compile warnings if I moved asm/irq.h to the top of
> all included files.

The order that Murali meant is

- first all linux/*.h headers, sorted alphabetically
- then all asm/*.h headers, again sorted alphabetically

This is the recommended style in general.

> Warning details are below:
>=20
> In file included from drivers/tty/serial/sprd_serial.c:14:0:
> ./arch/arm64/include/asm/irq.h:6:39: warning: =E2=80=98struct pt_regs=
=E2=80=99
> declared inside parameter list [enabled by default]
>  extern void (*handle_arch_irq)(struct pt_regs *);
>                                        ^
> ./arch/arm64/include/asm/irq.h:6:39: warning: its scope is only this
> definition or declaration, which is probably not what you want
> [enabled by default]
> ./arch/arm64/include/asm/irq.h:8:54: warning: =E2=80=98struct pt_regs=
=E2=80=99
> declared inside parameter list [enabled by default]
>  extern void set_handle_irq(void (*handle_irq)(struct pt_regs *));
>=20

I would consider this a (minor) bug in asm/irq.h. If you don't mind,
please submit a patch to add a line with 'struct pt_regs;' to
asm/irq.h.

	Arnd
