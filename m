From: Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: [PATCH v2 14/29] arch: add pkey and rseq syscall numbers
 everywhere
Date: Mon, 21 Jan 2019 12:59:05 +0100
Message-ID: <20190121115905.GC4020@osiris>
References: <20190118161835.2259170-1-arnd@arndb.de>
 <20190118161835.2259170-15-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190118161835.2259170-15-arnd@arndb.de>
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: y2038@lists.linaro.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, mattst88@gmail.com, linux@armlinux.org.uk, catalin.marinas@arm.com, will.deacon@arm.com, tony.luck@intel.com, fenghua.yu@intel.com, geert@linux-m68k.org, monstr@monstr.eu, paul.burton@mips.com, deller@gmx.de, benh@kernel.crashing.org, mpe@ellerman.id.au, schwidefsky@de.ibm.com, dalias@libc.org, davem@davemloft.net, luto@kernel.org, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org, jcmvbkbc@gmail.com, akpm@linux-foundation.org, deepa.kernel@gmail.com, ebiederm@xmission.com, firoz.khan@linaro.org, linux-alpha@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-ia64@vger.kernel.org, linux-m68k@lists.linux-m68k.org, linux-mips@vger.kernel.org, linux-p
List-Id: linux-api@vger.kernel.org

On Fri, Jan 18, 2019 at 05:18:20PM +0100, Arnd Bergmann wrote:
> Most architectures define system call numbers for the rseq and pkey system
> calls, even when they don't support the features, and perhaps never will.
> 
> Only a few architectures are missing these, so just define them anyway
> for consistency. If we decide to add them later to one of these, the
> system call numbers won't get out of sync then.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  arch/alpha/include/asm/unistd.h         | 4 ----
>  arch/alpha/kernel/syscalls/syscall.tbl  | 4 ++++
>  arch/ia64/kernel/syscalls/syscall.tbl   | 4 ++++
>  arch/m68k/kernel/syscalls/syscall.tbl   | 4 ++++
>  arch/parisc/include/asm/unistd.h        | 3 ---
>  arch/parisc/kernel/syscalls/syscall.tbl | 4 ++++
>  arch/s390/include/asm/unistd.h          | 3 ---
>  arch/s390/kernel/syscalls/syscall.tbl   | 3 +++
>  arch/sh/kernel/syscalls/syscall.tbl     | 4 ++++
>  arch/sparc/include/asm/unistd.h         | 5 -----
>  arch/sparc/kernel/syscalls/syscall.tbl  | 4 ++++
>  arch/xtensa/kernel/syscalls/syscall.tbl | 1 +
>  12 files changed, 28 insertions(+), 15 deletions(-)

For the s390 bits:
Acked-by: Heiko Carstens <heiko.carstens@de.ibm.com>
