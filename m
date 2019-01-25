From: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v2 25/29] y2038: syscalls: rename y2038 compat syscalls
Date: Fri, 25 Jan 2019 15:47:25 +0000
Message-ID: <20190125154724.GH25901@arrakis.emea.arm.com>
References: <20190118161835.2259170-1-arnd@arndb.de>
 <20190118161835.2259170-26-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190118161835.2259170-26-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: y2038@lists.linaro.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, mattst88@gmail.com, linux@armlinux.org.uk, will.deacon@arm.com, tony.luck@intel.com, fenghua.yu@intel.com, geert@linux-m68k.org, monstr@monstr.eu, paul.burton@mips.com, deller@gmx.de, benh@kernel.crashing.org, mpe@ellerman.id.au, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, dalias@libc.org, davem@davemloft.net, luto@kernel.org, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org, jcmvbkbc@gmail.com, akpm@linux-foundation.org, deepa.kernel@gmail.com, ebiederm@xmission.com, firoz.khan@linaro.org, linux-alpha@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-ia64@vger.kernel.org, linux-m68k@lists.linux-m68k.org, linux-mips@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Fri, Jan 18, 2019 at 05:18:31PM +0100, Arnd Bergmann wrote:
> A lot of system calls that pass a time_t somewhere have an implementation
> using a COMPAT_SYSCALL_DEFINEx() on 64-bit architectures, and have
> been reworked so that this implementation can now be used on 32-bit
> architectures as well.
> 
> The missing step is to redefine them using the regular SYSCALL_DEFINEx()
> to get them out of the compat namespace and make it possible to build them
> on 32-bit architectures.
> 
> Any system call that ends in 'time' gets a '32' suffix on its name for
> that version, while the others get a '_time32' suffix, to distinguish
> them from the normal version, which takes a 64-bit time argument in the
> future.
> 
> In this step, only 64-bit architectures are changed, doing this rename
> first lets us avoid touching the 32-bit architectures twice.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

For arm64:

Acked-by: Catalin Marinas <catalin.marinas@arm.com>
