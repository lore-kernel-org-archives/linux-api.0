From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 1/2] y2038: make CONFIG_64BIT_TIME unconditional
Date: Sat, 27 Apr 2019 22:47:17 +0200
Message-ID: <CAK8P3a0rdByED8ZsCSm4biuvOhkKs3o9_wFnGnSHk0hOhu-vsA@mail.gmail.com>
References: <20190426142531.1378357-1-arnd@arndb.de> <20190427004653.3cecd1cb@jawa>
 <20190427095418.344yoomf5nwznatd@sghpc.golosunov.pp.ru> <20190427170613.38bdfbbd@jawa>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190427170613.38bdfbbd@jawa>
Sender: linux-kernel-owner@vger.kernel.org
To: Lukasz Majewski <lukma@denx.de>
Cc: Stepan Golosunov <stepan@golosunov.pp.ru>, Thomas Gleixner <tglx@linutronix.de>, Joseph Myers <joseph@codesourcery.com>, GNU C Library <libc-alpha@sourceware.org>, Linux API <linux-api@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Deepa Dinamani <deepa.kernel@gmail.com>
List-Id: linux-api@vger.kernel.org

On Sat, Apr 27, 2019 at 5:06 PM Lukasz Majewski <lukma@denx.de> wrote:
> > 27.04.2019 в 00:46:53 +0200 Lukasz Majewski написал:
> > (I am wondering whether such trucation is undefined behaviour in C
>
> According to [1] - Chapter 6.3.1.3 - Point 3 it is
> implementation-defined.

The kernel relies on the sane behavior for integer overflow in many
places already, and it is built with -fno-strict-overflow to also make
sure gcc doesn't optimize cases that would be undefined otherwise.

> > and
> > whether there should be sign-extension instead of zeroing-out for the
> > in_compat_syscall() case though.)
>
> What I've found is that "typically" the high order bits are discarded.
>
> However, it is still "implementation dependent".

I think the question was whether we should use

          kts.tv_nsec = (int)kts.tv_nsec;

instead of

          kts.tv_nsec &= 0xfffffffful;

Both have a clearly defined meaning in the C dialect we use in the
kernel, but differ in the upper 32 bits for negative input values.

I would say that using sign-extension indeed makes more sense
here, but we don't need to change it for linux-5.1, since none of the
callers of get_timespec64() care -- any negative 32-bit tv_nsec
value results in -EINVAL, including the utimensat() syscall that
has two special cases outside of the 0...999999999 range.

      Arnd
