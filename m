From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH v2 14/29] arch: add pkey and rseq syscall numbers everywhere
Date: Mon, 21 Jan 2019 09:55:48 +0100
Message-ID: <CAMuHMdWaJyNqUeq4qu3AgU0fYrQdZ_zbo0DFFiM97Y5HESYYnA@mail.gmail.com>
References: <20190118161835.2259170-1-arnd@arndb.de> <20190118161835.2259170-15-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190118161835.2259170-15-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: y2038 Mailman List <y2038@lists.linaro.org>, Linux API <linux-api@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux-Arch <linux-arch@vger.kernel.org>, Matt Turner <mattst88@gmail.com>, Russell King <linux@armlinux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>, Michal Simek <monstr@monstr.eu>, Paul Burton <paul.burton@mips.com>, Helge Deller <deller@gmx.de>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Michael Ellerman <mpe@ellerman.id.au>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Rich Felker <dalias@libc.org>, "David S. Miller" <davem@davemloft.net>
List-Id: linux-api@vger.kernel.org

On Fri, Jan 18, 2019 at 5:20 PM Arnd Bergmann <arnd@arndb.de> wrote:
> Most architectures define system call numbers for the rseq and pkey system
> calls, even when they don't support the features, and perhaps never will.
>
> Only a few architectures are missing these, so just define them anyway
> for consistency. If we decide to add them later to one of these, the
> system call numbers won't get out of sync then.
>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

>  arch/m68k/kernel/syscalls/syscall.tbl   | 4 ++++

> --- a/arch/m68k/kernel/syscalls/syscall.tbl
> +++ b/arch/m68k/kernel/syscalls/syscall.tbl
> @@ -388,6 +388,10 @@
>  378    common  pwritev2                        sys_pwritev2
>  379    common  statx                           sys_statx
>  380    common  seccomp                         sys_seccomp
> +381    common  pkey_alloc                      sys_pkey_alloc
> +382    common  pkey_free                       sys_pkey_free
> +383    common  pkey_mprotect                   sys_pkey_mprotect
> +384    common  rseq                            sys_rseq

Note that all architectures that already define pkey syscalls, list
pkey_mprotect
first.

Regardless, for m68k:
Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>

>  # room for arch specific calls
>  393    common  semget                          sys_semget
>  394    common  semctl                          sys_semctl

Gr{oetje,eeting}s,

                        Geert


--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
