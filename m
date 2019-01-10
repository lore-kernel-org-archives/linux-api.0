From: Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: [PATCH 07/11] y2038: syscalls: rename y2038 compat syscalls
Date: Thu, 10 Jan 2019 21:55:22 +0100
Message-ID: <20190110205522.GC3676@osiris>
References: <20190110172216.313063-1-arnd@arndb.de>
 <20190110172216.313063-8-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190110172216.313063-8-arnd@arndb.de>
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: y2038@lists.linaro.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, mattst88@gmail.com, linux@armlinux.org.uk, catalin.marinas@arm.com, will.deacon@arm.com, tony.luck@intel.com, fenghua.yu@intel.com, geert@linux-m68k.org, monstr@monstr.eu, paul.burton@mips.com, deller@gmx.de, benh@kernel.crashing.org, mpe@ellerman.id.au, schwidefsky@de.ibm.com, dalias@libc.org, davem@davemloft.net, luto@kernel.org, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org, jcmvbkbc@gmail.com, akpm@linux-foundation.org, deepa.kernel@gmail.com, ebiederm@xmission.com, firoz.khan@linaro.org, linux-alpha@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-ia64@vger.kernel.org, linux-m68k@lists.linux-m68k.org, linux-mips@vger.kernel.org, linux-parisc@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Thu, Jan 10, 2019 at 06:22:12PM +0100, Arnd Bergmann wrote:
> diff --git a/arch/s390/kernel/syscalls/syscall.tbl b/arch/s390/kernel/syscalls/syscall.tbl
> index f84ea364a302..b3199a744731 100644
> --- a/arch/s390/kernel/syscalls/syscall.tbl
> +++ b/arch/s390/kernel/syscalls/syscall.tbl
> @@ -20,7 +20,7 @@
>  10   common	unlink			sys_unlink			compat_sys_unlink
>  11   common	execve			sys_execve			compat_sys_execve
>  12   common	chdir			sys_chdir			compat_sys_chdir
> -13   32		time			-				compat_sys_time
> +13   32		time			-				sys_time32
>  14   common	mknod			sys_mknod			compat_sys_mknod
>  15   common	chmod			sys_chmod			compat_sys_chmod
>  16   32		lchown			-				compat_sys_s390_lchown16
> @@ -30,11 +30,11 @@
>  22   common	umount			sys_oldumount			compat_sys_oldumount
>  23   32		setuid			-				compat_sys_s390_setuid16
>  24   32		getuid			-				compat_sys_s390_getuid16
> -25   32		stime			-				compat_sys_stime
> +25   32		stime			-				sys_stime32
>  26   common	ptrace			sys_ptrace			compat_sys_ptrace
>  27   common	alarm			sys_alarm			sys_alarm
>  29   common	pause			sys_pause			sys_pause
> -30   common	utime			sys_utime			compat_sys_utime
> +30   common	utime			sys_utime			sys_utime32
...(and more)...

All of them need compat wrappers to clear the uppermost 33 bits of
user space pointers. I assume there is no new *32 system call which
takes u64/s64 arguments; so the pointers should be the only problem.
