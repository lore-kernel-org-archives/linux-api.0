From: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Subject: Re: [PATCH v06 14/36] arm uapi asm/signal.h: include <stddef.h> for
 size_t in userspace
Date: Wed, 9 Aug 2017 14:41:59 +0200
Message-ID: <CAK8P3a30Vd2JquMvZ88tTO4jFAUMJGtUpvLuDmDPp2UFBYXDLQ@mail.gmail.com>
References: <20170806164428.2273-1-mikko.rapeli@iki.fi> <20170806164428.2273-15-mikko.rapeli@iki.fi>
 <20170808225739.GF10552@altlinux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170808225739.GF10552-u2l5PoMzF/Vg9hUCZPvPmw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Dmitry V. Levin" <ldv-u2l5PoMzF/Vg9hUCZPvPmw@public.gmane.org>
Cc: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Russell King <linux-I+IVW8TIWO2tmTQ+vhA3Yw@public.gmane.org>, Linux ARM <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Wed, Aug 9, 2017 at 12:57 AM, Dmitry V. Levin <ldv-u2l5PoMzF/Vg9hUCZPvPmw@public.gmane.org> wrote:
> On Sun, Aug 06, 2017 at 06:44:05PM +0200, Mikko Rapeli wrote:
>> Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org> doubts that __kernel_size_t could be used here
>> so trying to fall back to gcc's <stddef.h>.
>
> The only architecture where you cannot do this safely is x86 family
> because of x32 exception.  If there is no chance that the change will
> affect x32, feel free to replace size_t with __kernel_size_t like I did
> some time ago, see
> http://lkml.kernel.org/r/20170302002022.GB27097-u2l5PoMzF/Vg9hUCZPvPmw@public.gmane.org

There is another problem: on some 32-bit architectures, size_t is
defined as 'unsigned int', while '__kernel_size_t' is defined as 'unsigned
long'. These obviously have the same size, but the man page
explicitly defines it as 'size_t ss_size'.

If a user space program accesses the field in a way requires an
exact type match, it gets a warning or error, e.g.

1. printf("signal with %zd bytes\n", stack->ss_size);
2. size_t *pointer_to_size_t = &stack->ss_size;
3. assert(__builtin_types_compatible_p(size_t, typeof(stack->ss_size)))

Not sure how important those are, but I think there is at least a risk
of any of those showing up in user space.

         Arnd
