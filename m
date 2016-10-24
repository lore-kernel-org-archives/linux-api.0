From: Geert Uytterhoeven <geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org>
Subject: Re: [PATCH 2/3] ARM: convert to generated system call tables
Date: Mon, 24 Oct 2016 11:29:28 +0200
Message-ID: <CAMuHMdWjBFRm2rvCC8LBVG0CLk7MtmMLZJ7Ca72v6Nm=b5aD9A@mail.gmail.com>
References: <E1bwa6s-0004ZY-4k@rmk-PC.armlinux.org.uk> <13702107.LdHY4HTXyY@wuerfel>
 <20161019155325.GR1041@n2100.armlinux.org.uk> <3851270.xZRcP9hae0@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <3851270.xZRcP9hae0@wuerfel>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Cc: Russell King - ARM Linux <linux-I+IVW8TIWO2tmTQ+vhA3Yw@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, linux-arch <linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hi Arnd,

On Fri, Oct 21, 2016 at 3:06 PM, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org> wrote:
> - a lot of the less common architectures just don't get updated
>   in time, out of 22 architectures that don't use asm-generic/unistd.h,
>   only 12 have pwritev2 in linux-next, and only three have pkey_mprotect

Should everybody implement pkey_mprotect?

"x86, pkeys: remove cruft from never-merged syscalls" and

arch/powerpc/include/asm/unistd.h:#define __IGNORE_pkey_mprotect

aren't that reassuring...

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
