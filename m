From: Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: [PATCH v2 13/29] arch: add split IPC system calls where needed
Date: Mon, 21 Jan 2019 12:57:05 +0100
Message-ID: <20190121115705.GB4020@osiris>
References: <20190118161835.2259170-1-arnd@arndb.de>
 <20190118161835.2259170-14-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190118161835.2259170-14-arnd@arndb.de>
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: y2038@lists.linaro.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, mattst88@gmail.com, linux@armlinux.org.uk, catalin.marinas@arm.com, will.deacon@arm.com, tony.luck@intel.com, fenghua.yu@intel.com, geert@linux-m68k.org, monstr@monstr.eu, paul.burton@mips.com, deller@gmx.de, benh@kernel.crashing.org, mpe@ellerman.id.au, schwidefsky@de.ibm.com, dalias@libc.org, davem@davemloft.net, luto@kernel.org, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org, jcmvbkbc@gmail.com, akpm@linux-foundation.org, deepa.kernel@gmail.com, ebiederm@xmission.com, firoz.khan@linaro.org, linux-alpha@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-ia64@vger.kernel.org, linux-m68k@lists.linux-m68k.org, linux-mips@vger.kernel.org, linux-p
List-Id: linux-api@vger.kernel.org

On Fri, Jan 18, 2019 at 05:18:19PM +0100, Arnd Bergmann wrote:
> The IPC system call handling is highly inconsistent across architectures,
> some use sys_ipc, some use separate calls, and some use both.  We also
> have some architectures that require passing IPC_64 in the flags, and
> others that set it implicitly.
> 
> For the additon of a y2083 safe semtimedop() system call, I chose to only
> support the separate entry points, but that requires first supporting
> the regular ones with their own syscall numbers.
> 
> The IPC_64 is now implied by the new semctl/shmctl/msgctl system
> calls even on the architectures that require passing it with the ipc()
> multiplexer.
> 
> I'm not adding the new semtimedop() or semop() on 32-bit architectures,
> those will get implemented using the new semtimedop_time64() version
> that gets added along with the other time64 calls.
> Three 64-bit architectures (powerpc, s390 and sparc) get semtimedop().
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
> One aspect here that might be a bit controversial is the use of
> the same system call numbers across all architectures, synchronizing
> all of them with the x86-32 numbers. With the new syscall.tbl
> files, I hope we can just keep doing that in the future, and no
> longer require the architecture maintainers to assign a number.
> 
> This is mainly useful for implementers of the C libraries: if
> we can add future system calls everywhere at the same time, using
> a particular version of the kernel headers also guarantees that
> the system call number macro is visible.
> ---
>  arch/m68k/kernel/syscalls/syscall.tbl     | 11 +++++++++++
>  arch/mips/kernel/syscalls/syscall_o32.tbl | 11 +++++++++++
>  arch/powerpc/kernel/syscalls/syscall.tbl  | 13 +++++++++++++
>  arch/s390/kernel/syscalls/syscall.tbl     | 12 ++++++++++++
>  arch/sh/kernel/syscalls/syscall.tbl       | 11 +++++++++++
>  arch/sparc/kernel/syscalls/syscall.tbl    | 12 ++++++++++++
>  arch/x86/entry/syscalls/syscall_32.tbl    | 11 +++++++++++
>  7 files changed, 81 insertions(+)

For the s390 bits:
Acked-by: Heiko Carstens <heiko.carstens@de.ibm.com>
