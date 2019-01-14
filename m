From: Michael Ellerman <mpe@ellerman.id.au>
Subject: Re: [PATCH 14/15] arch: add split IPC system calls where needed
Date: Mon, 14 Jan 2019 14:40:14 +1100
Message-ID: <87r2df29gh.fsf@concordia.ellerman.id.au>
References: <20190110162435.309262-1-arnd@arndb.de>
 <20190110162435.309262-15-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20190110162435.309262-15-arnd@arndb.de>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: y2038@lists.linaro.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: dalias@libc.org, linux-ia64@vger.kernel.org, linux-sh@vger.kernel.org, catalin.marinas@arm.com, will.deacon@arm.com, linux@dominikbrodowski.net, jcmvbkbc@gmail.com, deepa.kernel@gmail.com, hpa@zytor.com, sparclinux@vger.kernel.org, linux-s390@vger.kernel.org, dave@stgolabs.net, deller@gmx.de, x86@kernel.org, linux@armlinux.org.uk, mingo@redhat.com, geert@linux-m68k.org, firoz.khan@linaro.org, mattst88@gmail.com, fenghua.yu@intel.com, Arnd Bergmann <arnd@arndb.de>, heiko.carstens@de.ibm.com, linux-m68k@lists.linux-m68k.org, ink@jurassic.park.msu.ru, luto@kernel.org, tglx@linutronix.de, linux-arm-kernel@lists.infradead.org, monstr@monstr.eu, tony.luck@intel.com, linux-parisc@vger.kernel.org, linux-mips@vger.kernel.org, paul.burton@mips.com, ebiederm@xmission.com, linux-alpha@vger.kernel.org, schwidefsky@de.ibm.com, akpm@linux-foundation.org, linuxppc-dev@lists.ozlabs.orgd
List-Id: linux-api@vger.kernel.org

Hi Arnd,

Arnd Bergmann <arnd@arndb.de> writes:
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
>  arch/powerpc/kernel/syscalls/syscall.tbl  | 12 ++++++++++++

I have some changes I'd like to make to our syscall table that will
clash with this.

I'll try and send them today.

> diff --git a/arch/powerpc/kernel/syscalls/syscall.tbl b/arch/powerpc/kernel/syscalls/syscall.tbl
> index db3bbb8744af..1bffab54ff35 100644
> --- a/arch/powerpc/kernel/syscalls/syscall.tbl
> +++ b/arch/powerpc/kernel/syscalls/syscall.tbl
> @@ -425,3 +425,15 @@
>  386	nospu	pkey_mprotect			sys_pkey_mprotect
>  387	nospu	rseq				sys_rseq
>  388	nospu	io_pgetevents			sys_io_pgetevents		compat_sys_io_pgetevents
> +# room for arch specific syscalls
> +392	64	semtimedop			sys_semtimedop
> +393	common	semget				sys_semget
> +394	common	semctl				sys_semctl			compat_sys_semctl
> +395	common	shmget				sys_shmget
> +396	common	shmctl				sys_shmctl			compat_sys_shmctl
> +397	common	shmat				sys_shmat			compat_sys_shmat
> +398	common	shmdt				sys_shmdt
> +399	common	msgget				sys_msgget
> +400	common	msgsnd				sys_msgsnd			compat_sys_msgsnd
> +401	common	msgrcv				sys_msgrcv			compat_sys_msgrcv
> +402	common	msgctl				sys_msgctl			compat_sys_msgctl

We already have a gap at 366-377 from when we tried to add the split IPC
calls a few years back.

I guess I don't mind leaving that gap and using the common numbers.

But would be good to add a comment pointing out that we have room there
for arch specific syscalls as well.

cheers
