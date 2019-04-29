From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 1/2] y2038: make CONFIG_64BIT_TIME unconditional
Date: Mon, 29 Apr 2019 15:22:02 +0200
Message-ID: <CAK8P3a2UVqg--Xs29o55QbsRKu-ynN8ZXR96Phiq2cuCoABvGw@mail.gmail.com>
References: <20190426142531.1378357-1-arnd@arndb.de> <alpine.DEB.2.21.1904290933130.1626@nanos.tec.linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.21.1904290933130.1626@nanos.tec.linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Joseph Myers <joseph@codesourcery.com>, GNU C Library <libc-alpha@sourceware.org>, Linux API <linux-api@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Deepa Dinamani <deepa.kernel@gmail.com>, Lukasz Majewski <lukma@denx.de>, Stepan Golosunov <stepan@golosunov.pp.ru>
List-Id: linux-api@vger.kernel.org

On Mon, Apr 29, 2019 at 9:34 AM Thomas Gleixner <tglx@linutronix.de> wrote:
>
> On Fri, 26 Apr 2019, Arnd Bergmann wrote:
>
> > As Stepan Golosunov points out, we made a small mistake in the
> > get_timespec64() function in the kernel. It was originally added under
> > the assumption that CONFIG_64BIT_TIME would get enabled on all 32-bit
> > and 64-bit architectures, but when I did the conversion, I only turned
> > it on for 32-bit ones.
> >
> > The effect is that the get_timespec64() function never clears the upper
> > half of the tv_nsec field for 32-bit tasks in compat mode. Clearing this
> > is required for POSIX compliant behavior of functions that pass a
> > 'timespec' structure with a 64-bit tv_sec and a 32-bit tv_nsec, plus
> > uninitialized padding.
> >
> > The easiest fix for linux-5.1 is to just make the Kconfig symbol
> > unconditional, as it was originally intended. As a follow-up,
> > we should remove any #ifdef CONFIG_64BIT_TIME completely.
> >
> > Link: https://lore.kernel.org/lkml/20190422090710.bmxdhhankurhafxq@sghpc.golosunov.pp.ru/
> > Cc: Lukasz Majewski <lukma@denx.de>
> > Cc: Stepan Golosunov <stepan@golosunov.pp.ru>
> > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> > ---
> > Please apply this one as a bugfix for 5.1
>
> Can you provide a 'Fixes: ....' tag please?

Ok, resent both patches now. I also took the chance to add a clarification
for the point that Lukasz missed on the first submission.

       Arnd
