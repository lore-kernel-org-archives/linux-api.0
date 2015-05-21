From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH 2/9] y2038: asm-generic: extend sysvipc data structures
Date: Thu, 21 May 2015 10:56:34 +0200
Message-ID: <CAMuHMdUtJ2x+axBLj5qdsRwod=XdRkmeYJm1N7H5V_CXLo5J0g@mail.gmail.com>
References: <1432134445-804487-1-git-send-email-arnd@arndb.de>
	<1432134445-804487-3-git-send-email-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-arch-owner@vger.kernel.org>
In-Reply-To: <1432134445-804487-3-git-send-email-arnd@arndb.de>
Sender: linux-arch-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: y2038@lists.linaro.org, baolin.wang@linaro.org, albert.aribaud@3adev.fr, John Stultz <john.stultz@linaro.org>, bamvor.zhangjian@linaro.org, ruchandani.tina@gmail.com, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, libc-alpha@sourceware.org, Linux-Arch <linux-arch@vger.kernel.org>, Manfred Spraul <manfred@colorfullife.com>, Michael Kerrisk <mtk.manpages@gmail.com>
List-Id: linux-api@vger.kernel.org

Hi Arnd,

On Wed, May 20, 2015 at 5:07 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> --- a/include/uapi/asm-generic/sembuf.h
> +++ b/include/uapi/asm-generic/sembuf.h
> @@ -12,23 +12,29 @@
>   * everyone just ended up making identical copies without specific
>   * optimizations, so we may just as well all use the same one.
>   *
> - * 64 bit architectures typically define a 64 bit __kernel_time_t,
> + * 64 bit architectures use a 64-bit __kernel_time_t here, while
> + * 32 bit architectures have a pair of unsigned long values.
>   * so they do not need the first two padding words.
> - * On big-endian systems, the padding is in the wrong place.
>   *
> - * Pad space is left for:
> - * - 64-bit time_t to solve y2038 problem
> - * - 2 miscellaneous 32-bit values
> + * On big-endian systems, the padding is in the wrong place for
> + * historic reasons, so user space has to reconstruct a time_t
> + * value using
> + *
> + * user_semid_ds.sem_otime = kernel_semid64_ds.sem_otime +
> + *             (long long)(kernel_semid64_ds.sem_otime_high << 32)

The cast to "long long" should be inside the parentheses, to promote the
(32-bit) sem_otime_high to a first 64-bit integer first.
Else it will be shifted into oblivion (oh no, C undefined behavior).

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
