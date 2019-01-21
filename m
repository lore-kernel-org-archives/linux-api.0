From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH v2 28/29] y2038: rename old time and utime syscalls
Date: Mon, 21 Jan 2019 09:56:06 +0100
Message-ID: <CAMuHMdVxSVpP0KcBpCSVh0iKBCh3WtGqExtZGPH86hn2TOpTXg@mail.gmail.com>
References: <20190118161835.2259170-1-arnd@arndb.de> <20190118161835.2259170-29-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190118161835.2259170-29-arnd@arndb.de>
Sender: netdev-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: y2038 Mailman List <y2038@lists.linaro.org>, Linux API <linux-api@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux-Arch <linux-arch@vger.kernel.org>, Matt Turner <mattst88@gmail.com>, Russell King <linux@armlinux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>, Michal Simek <monstr@monstr.eu>, Paul Burton <paul.burton@mips.com>, Helge Deller <deller@gmx.de>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Michael Ellerman <mpe@ellerman.id.au>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Rich Felker <dalias@libc.org>, "David S. Miller" <davem@davemloft.net>
List-Id: linux-api@vger.kernel.org

On Fri, Jan 18, 2019 at 5:21 PM Arnd Bergmann <arnd@arndb.de> wrote:
> The time, stime, utime, utimes, and futimesat system calls are only
> used on older architectures, and we do not provide y2038 safe variants
> of them, as they are replaced by clock_gettime64, clock_settime64,
> and utimensat_time64.
>
> However, for consistency it seems better to have the 32-bit architectures
> that still use them call the "time32" entry points (leaving the
> traditional handlers for the 64-bit architectures), like we do for system
> calls that now require two versions.
>
> Note: We used to always define __ARCH_WANT_SYS_TIME and
> __ARCH_WANT_SYS_UTIME and only set __ARCH_WANT_COMPAT_SYS_TIME and
> __ARCH_WANT_SYS_UTIME32 for compat mode on 64-bit kernels. Now this is
> reversed: only 64-bit architectures set __ARCH_WANT_SYS_TIME/UTIME, while
> we need __ARCH_WANT_SYS_TIME32/UTIME32 for 32-bit architectures and compat
> mode. The resulting asm/unistd.h changes look a bit counterintuitive.
>
> This is only a cleanup patch and it should not change any behavior.
>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

>  arch/m68k/include/asm/unistd.h              |  4 ++--
>  arch/m68k/kernel/syscalls/syscall.tbl       | 10 +++++-----

For m68k:
Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>

Gr{oetje,eeting}s,

                        Geert
