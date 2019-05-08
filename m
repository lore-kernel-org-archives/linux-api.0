From: Yury Norov <yury.norov@gmail.com>
Subject: Re: [PATCH v9 00/24] ILP32 for ARM64
Date: Wed, 8 May 2019 15:59:00 -0700
Message-ID: <20190508225900.GA14091@yury-thinkpad>
References: <20180516081910.10067-1-ynorov@caviumnetworks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180516081910.10067-1-ynorov@caviumnetworks.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Yury Norov <ynorov@caviumnetworks.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-arch@vger.kernel.org, linux-api@vger.kernel.org, Adam Borowski <kilobyte@angband.pl>, Alexander Graf <agraf@suse.de>, Alexey Klimov <klimov.linux@gmail.com>, Andreas Schwab <schwab@suse.de>, Andrew Pinski <pinskia@gmail.com>, Bamvor Zhangjian <bamv2005@gmail.com>, Chris Metcalf <cmetcalf@mellanox.com>, Christoph Muellner <christoph.muellner@theobroma-systems.com>, Dave Martin <Dave.Martin@arm.com>, "David S . Miller" <davem@davemloft.net>, Florian Weimer <fweimer@redhat.com>, Geert Uytterhoeven <geert@linux-m68k.org>, Heiko Carstens <heiko.carstens@de.ibm.com>, James Hogan <jame>
List-Id: linux-api@vger.kernel.org

Hi all,

On Wed, May 16, 2018 at 11:18:45AM +0300, Yury Norov wrote:
> This series enables AARCH64 with ILP32 mode.
> 
> As supporting work, it introduces ARCH_32BIT_OFF_T configuration
> option that is enabled for existing 32-bit architectures but disabled
> for new arches (so 64-bit off_t userspace type is used by new userspace).
> Also it deprecates getrlimit and setrlimit syscalls prior to prlimit64.
> 
> Based on kernel v4.16. Tested with LTP, glibc testsuite, trinity, lmbench,
> CPUSpec.
> 
> This series on github: 
> https://github.com/norov/linux/tree/ilp32-4.16
> Linaro toolchain:
> http://snapshots.linaro.org/components/toolchain/binaries/7.3-2018.04-rc1/aarch64-linux-gnu_ilp32/
> Debian repo:
> http://people.linaro.org/~wookey/ilp32/
> OpenSUSE repo:
> https://build.opensuse.org/project/show/devel:ARM:Factory:Contrib:ILP32

This is the 5.1-based version.
Changes comparing to 5.0:
 - drop arch patches that has been taken upstream:
   80d7da1cac62 asm-generic: Drop getrlimit and setrlimit syscalls from default list
   942fa985e9f1 32-bit userspace ABI: introduce ARCH_32BIT_OFF_T config option
   0d0216c03a7a compat ABI: use non-compat openat and open_by_handle_at variants
 - in include/linux/thread_bits.h define current_thread_info() prior to
   inclusion of asm/thread_info.h, to avoid circullar dependencies (thread: move
   thread bits accessors to separated file);
 - enable old IPC interfaces for ilp32, according to mainline changes
   (arm64: ilp32: introduce syscall table for ILP32).

Thanks,
Yury
