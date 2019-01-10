From: Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: [PATCH 14/15] arch: add split IPC system calls where needed
Date: Thu, 10 Jan 2019 21:32:53 +0100
Message-ID: <20190110203253.GA3676@osiris>
References: <20190110162435.309262-1-arnd@arndb.de>
 <20190110162435.309262-15-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190110162435.309262-15-arnd@arndb.de>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: y2038@lists.linaro.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, ink@jurassic.park.msu.ru, mattst88@gmail.com, linux@armlinux.org.uk, catalin.marinas@arm.com, will.deacon@arm.com, tony.luck@intel.com, fenghua.yu@intel.com, geert@linux-m68k.org, monstr@monstr.eu, paul.burton@mips.com, deller@gmx.de, mpe@ellerman.id.au, schwidefsky@de.ibm.com, dalias@libc.org, davem@davemloft.net, luto@kernel.org, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org, jcmvbkbc@gmail.com, firoz.khan@linaro.org, ebiederm@xmission.com, deepa.kernel@gmail.com, linux@dominikbrodowski.net, akpm@linux-foundation.org, dave@stgolabs.net, linux-alpha@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-ia64@vger.kernel.org, linux-m68k@lists.linux-m68k.org, linux-mips@vger.
List-Id: linux-api@vger.kernel.org

On Thu, Jan 10, 2019 at 05:24:34PM +0100, Arnd Bergmann wrote:
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

> diff --git a/arch/s390/kernel/syscalls/syscall.tbl b/arch/s390/kernel/syscalls/syscall.tbl
> index 022fc099b628..428cf512a757 100644
> --- a/arch/s390/kernel/syscalls/syscall.tbl
> +++ b/arch/s390/kernel/syscalls/syscall.tbl
> @@ -391,3 +391,15 @@
>  381  common	kexec_file_load		sys_kexec_file_load		compat_sys_kexec_file_load
>  382  common	io_pgetevents		sys_io_pgetevents		compat_sys_io_pgetevents
>  383  common	rseq			sys_rseq			compat_sys_rseq
> +# room for arch specific syscalls
> +392	64	semtimedop		sys_semtimedop			-
> +393  common	semget			sys_semget			sys_semget
...
> +395  common	shmget			sys_shmget			sys_shmget
...
> +398  common	shmdt			sys_shmdt 			sys_shmdt
> +399  common	msgget			sys_msgget			sys_msgget

These four need compat system call wrappers, unfortunately... (well,
actually only shmget and shmdt require them, but let's add them for
all four). See arch/s390/kernel/compat_wrapper.c

I'm afraid this compat special handling will be even more annoying in
the future, since s390 will be the only architecture which requires
this special handling.

_Maybe_ it would make sense to automatically generate a weak compat
system call wrapper for s390 with the SYSCALL_DEFINE macros, but that
probably won't work in all cases.
