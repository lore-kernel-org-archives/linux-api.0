From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v2 14/29] arch: add pkey and rseq syscall numbers everywhere
Date: Mon, 21 Jan 2019 21:28:08 +0100
Message-ID: <CAK8P3a1BxBHfHZCvTM6aoBiiN+EpnD4P9LM=Ked5Sc_QwF7hCg@mail.gmail.com>
References: <20190118161835.2259170-1-arnd@arndb.de> <20190118161835.2259170-15-arnd@arndb.de>
 <CAMuHMdWaJyNqUeq4qu3AgU0fYrQdZ_zbo0DFFiM97Y5HESYYnA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <CAMuHMdWaJyNqUeq4qu3AgU0fYrQdZ_zbo0DFFiM97Y5HESYYnA@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: y2038 Mailman List <y2038@lists.linaro.org>, Linux API <linux-api@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux-Arch <linux-arch@vger.kernel.org>, Matt Turner <mattst88@gmail.com>, Russell King <linux@armlinux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>, Michal Simek <monstr@monstr.eu>, Paul Burton <paul.burton@mips.com>, Helge Deller <deller@gmx.de>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Michael Ellerman <mpe@ellerman.id.au>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Rich Felker <dalias@libc.org>, "David S. Miller" <davem@davemloft.net>
List-Id: linux-api@vger.kernel.org

On Mon, Jan 21, 2019 at 9:56 AM Geert Uytterhoeven <geert@linux-m68k.org> wrote:
>
> Note that all architectures that already define pkey syscalls, list
> pkey_mprotect first.

It's easy enough to change, so I've reordered them for consistency now.

> Regardless, for m68k:
> Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>

Thanks,

     Arnd
