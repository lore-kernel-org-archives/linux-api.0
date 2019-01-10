From: Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH 06/15] ARM: add migrate_pages() system call
Date: Thu, 10 Jan 2019 16:32:20 +0000
Message-ID: <20190110163220.GB31683@fuggles.cambridge.arm.com>
References: <20190110162435.309262-1-arnd@arndb.de>
 <20190110162435.309262-7-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190110162435.309262-7-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: y2038@lists.linaro.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, ink@jurassic.park.msu.ru, mattst88@gmail.com, linux@armlinux.org.uk, catalin.marinas@arm.com, tony.luck@intel.com, fenghua.yu@intel.com, geert@linux-m68k.org, monstr@monstr.eu, paul.burton@mips.com, deller@gmx.de, mpe@ellerman.id.au, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, dalias@libc.org, davem@davemloft.net, luto@kernel.org, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org, jcmvbkbc@gmail.com, firoz.khan@linaro.org, ebiederm@xmission.com, deepa.kernel@gmail.com, linux@dominikbrodowski.net, akpm@linux-foundation.org, dave@stgolabs.net, linux-alpha@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-ia64@vger.kernel.org, linux-m68k@lists.linux-m68k.orgli
List-Id: linux-api@vger.kernel.org

On Thu, Jan 10, 2019 at 05:24:26PM +0100, Arnd Bergmann wrote:
> The migrate_pages system call has an assigned number on all architectures
> except ARM. When it got added initially in commit d80ade7b3231 ("ARM:
> Fix warning: #warning syscall migrate_pages not implemented"), it was
> intentionally left out based on the observation that there are no 32-bit
> ARM NUMA systems.
> 
> However, there are now arm64 NUMA machines that can in theory run 32-bit
> kernels (actually enabling NUMA there would require additional work)
> as well as 32-bit user space on 64-bit kernels, so that argument is no
> longer very strong.
> 
> Assigning the number lets us use the system call on 64-bit kernels as well
> as providing a more consistent set of syscalls across architectures.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  arch/arm/include/asm/unistd.h     | 1 -
>  arch/arm/tools/syscall.tbl        | 1 +
>  arch/arm64/include/asm/unistd.h   | 2 +-
>  arch/arm64/include/asm/unistd32.h | 2 ++
>  4 files changed, 4 insertions(+), 2 deletions(-)

[...]

> diff --git a/arch/arm64/include/asm/unistd32.h b/arch/arm64/include/asm/unistd32.h
> index 04ee190b90fe..355fe2bc035b 100644
> --- a/arch/arm64/include/asm/unistd32.h
> +++ b/arch/arm64/include/asm/unistd32.h
> @@ -821,6 +821,8 @@ __SYSCALL(__NR_statx, sys_statx)
>  __SYSCALL(__NR_rseq, sys_rseq)
>  #define __NR_io_pgetevents 399
>  __SYSCALL(__NR_io_pgetevents, compat_sys_io_pgetevents)
> +#define __NR_migrate_pages 400
> +__SYSCALL(__NR_migrate_pages, sys_migrate_pages)

Should be compat_sys_migrate_pages instead?

Will
