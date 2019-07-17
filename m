From: Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
Subject: Re: [PATCH v2 4/4] tools: Add fchmodat4
Date: Wed, 17 Jul 2019 09:39:59 -0300
Message-ID: <20190717123959.GB24063@kernel.org>
References: <20190717012719.5524-1-palmer@sifive.com>
 <20190717012719.5524-5-palmer@sifive.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190717012719.5524-5-palmer@sifive.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Palmer Dabbelt <palmer@sifive.com>
Cc: viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, rth@twiddle.net, ink@jurassic.park.msu.ru, mattst88@gmail.com, linux@armlinux.org.uk, catalin.marinas@arm.com, will@kernel.org, tony.luck@intel.com, fenghua.yu@intel.com, geert@linux-m68k.org, monstr@monstr.eu, ralf@linux-mips.org, paul.burton@mips.com, jhogan@kernel.org, James.Bottomley@hansenpartnership.com, deller@gmx.de, benh@kernel.crashing.org, paulus@samba.org, mpe@ellerman.id.au, heiko.carstens@de.ibm.com, gor@linux.ibm.com, borntraeger@de.ibm.com, ysato@users.sourceforge.jp, dalias@libc.org, davem@davemloft.net, luto@kernel.org, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com, x86@kernel.org, peterz@infradead.org
List-Id: linux-api@vger.kernel.org

Em Tue, Jul 16, 2019 at 06:27:19PM -0700, Palmer Dabbelt escreveu:
> I'm not sure why it's necessary to add this explicitly to tools/ as well
> as arch/, but there were a few instances of fspick in here so I blindly
> added fchmodat4 in the same fashion.

The copies in tools/ for these specific files are used to generate a
syscall table used by 'perf trace', and we don't/can't access files
outside of tools/ to build tools/perf/, so we grab a copy and have
checks in place to warn perf developers when those copies get out of
sync.

Its not required that kernel developers update anything in tools, you're
welcomed to do so if you wish tho.

Thanks,

- Arnaldo
 
> Signed-off-by: Palmer Dabbelt <palmer@sifive.com>
> ---
>  tools/include/uapi/asm-generic/unistd.h           | 4 +++-
>  tools/perf/arch/x86/entry/syscalls/syscall_64.tbl | 1 +
>  2 files changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/include/uapi/asm-generic/unistd.h b/tools/include/uapi/asm-generic/unistd.h
> index a87904daf103..36232ea94956 100644
> --- a/tools/include/uapi/asm-generic/unistd.h
> +++ b/tools/include/uapi/asm-generic/unistd.h
> @@ -844,9 +844,11 @@ __SYSCALL(__NR_fsconfig, sys_fsconfig)
>  __SYSCALL(__NR_fsmount, sys_fsmount)
>  #define __NR_fspick 433
>  __SYSCALL(__NR_fspick, sys_fspick)
> +#define __NR_fchmodat4 434
> +__SYSCALL(__NR_fchmodat4, sys_fchmodat4)
>  
>  #undef __NR_syscalls
> -#define __NR_syscalls 434
> +#define __NR_syscalls 435
>  
>  /*
>   * 32 bit systems traditionally used different
> diff --git a/tools/perf/arch/x86/entry/syscalls/syscall_64.tbl b/tools/perf/arch/x86/entry/syscalls/syscall_64.tbl
> index b4e6f9e6204a..b92d5b195e66 100644
> --- a/tools/perf/arch/x86/entry/syscalls/syscall_64.tbl
> +++ b/tools/perf/arch/x86/entry/syscalls/syscall_64.tbl
> @@ -355,6 +355,7 @@
>  431	common	fsconfig		__x64_sys_fsconfig
>  432	common	fsmount			__x64_sys_fsmount
>  433	common	fspick			__x64_sys_fspick
> +434	common	fchmodat4		__x64_sys_fchmodat4
>  
>  #
>  # x32-specific system call numbers start at 512 to avoid cache impact
> -- 
> 2.21.0

-- 

- Arnaldo
