From: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH v2 2/9] mips: allocate sys_membarrier system call number
Date: Wed, 16 Sep 2015 15:04:58 +0000 (UTC)
Message-ID: <1089832901.9282.1442415898500.JavaMail.zimbra@efficios.com>
References: <1441642556-30972-1-git-send-email-mathieu.desnoyers@efficios.com> <1441642556-30972-3-git-send-email-mathieu.desnoyers@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1441642556-30972-3-git-send-email-mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ralf Baechle <ralf-6z/3iImG2C8G8FEW9MqTrA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mips <linux-mips-6z/3iImG2C8G8FEW9MqTrA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-api <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

----- On Sep 7, 2015, at 12:15 PM, Mathieu Desnoyers mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org wrote:

> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
> Acked-by: Ralf Baechle <ralf-6z/3iImG2C8G8FEW9MqTrA@public.gmane.org>
> CC: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
> CC: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> CC: linux-mips-6z/3iImG2C8G8FEW9MqTrA@public.gmane.org

Hi,

FYI, sys_membarrier has been merged upstream in Linux 4.3-rc1. Feel free
to wire up this system call on MIPS.

Thanks!

Mathieu

> ---
> arch/mips/include/uapi/asm/unistd.h | 15 +++++++++------
> arch/mips/kernel/scall32-o32.S      |  1 +
> arch/mips/kernel/scall64-64.S       |  1 +
> arch/mips/kernel/scall64-n32.S      |  1 +
> arch/mips/kernel/scall64-o32.S      |  1 +
> 5 files changed, 13 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/mips/include/uapi/asm/unistd.h
> b/arch/mips/include/uapi/asm/unistd.h
> index d0bdfaa..b107983 100644
> --- a/arch/mips/include/uapi/asm/unistd.h
> +++ b/arch/mips/include/uapi/asm/unistd.h
> @@ -378,16 +378,17 @@
> #define __NR_bpf			(__NR_Linux + 355)
> #define __NR_execveat			(__NR_Linux + 356)
> #define __NR_mlock2			(__NR_Linux + 357)
> +#define __NR_membarrier			(__NR_Linux + 358)
> 
> /*
>  * Offset of the last Linux o32 flavoured syscall
>  */
> -#define __NR_Linux_syscalls		357
> +#define __NR_Linux_syscalls		358
> 
> #endif /* _MIPS_SIM == _MIPS_SIM_ABI32 */
> 
> #define __NR_O32_Linux			4000
> -#define __NR_O32_Linux_syscalls		357
> +#define __NR_O32_Linux_syscalls		358
> 
> #if _MIPS_SIM == _MIPS_SIM_ABI64
> 
> @@ -713,16 +714,17 @@
> #define __NR_bpf			(__NR_Linux + 315)
> #define __NR_execveat			(__NR_Linux + 316)
> #define __NR_mlock2			(__NR_Linux + 317)
> +#define __NR_membarrier			(__NR_Linux + 318)
> 
> /*
>  * Offset of the last Linux 64-bit flavoured syscall
>  */
> -#define __NR_Linux_syscalls		317
> +#define __NR_Linux_syscalls		318
> 
> #endif /* _MIPS_SIM == _MIPS_SIM_ABI64 */
> 
> #define __NR_64_Linux			5000
> -#define __NR_64_Linux_syscalls		317
> +#define __NR_64_Linux_syscalls		318
> 
> #if _MIPS_SIM == _MIPS_SIM_NABI32
> 
> @@ -1052,15 +1054,16 @@
> #define __NR_bpf			(__NR_Linux + 319)
> #define __NR_execveat			(__NR_Linux + 320)
> #define __NR_mlock2			(__NR_Linux + 321)
> +#define __NR_membarrier			(__NR_Linux + 322)
> 
> /*
>  * Offset of the last N32 flavoured syscall
>  */
> -#define __NR_Linux_syscalls		321
> +#define __NR_Linux_syscalls		322
> 
> #endif /* _MIPS_SIM == _MIPS_SIM_NABI32 */
> 
> #define __NR_N32_Linux			6000
> -#define __NR_N32_Linux_syscalls		321
> +#define __NR_N32_Linux_syscalls		322
> 
> #endif /* _UAPI_ASM_UNISTD_H */
> diff --git a/arch/mips/kernel/scall32-o32.S b/arch/mips/kernel/scall32-o32.S
> index b0b377a..9265542 100644
> --- a/arch/mips/kernel/scall32-o32.S
> +++ b/arch/mips/kernel/scall32-o32.S
> @@ -600,3 +600,4 @@ EXPORT(sys_call_table)
> 	PTR	sys_bpf				/* 4355 */
> 	PTR	sys_execveat
> 	PTR	sys_mlock2
> +	PTR	sys_membarrier
> diff --git a/arch/mips/kernel/scall64-64.S b/arch/mips/kernel/scall64-64.S
> index f12eb03..79d4fb0 100644
> --- a/arch/mips/kernel/scall64-64.S
> +++ b/arch/mips/kernel/scall64-64.S
> @@ -437,4 +437,5 @@ EXPORT(sys_call_table)
> 	PTR	sys_bpf				/* 5315 */
> 	PTR	sys_execveat
> 	PTR	sys_mlock2
> +	PTR	sys_membarrier
> 	.size	sys_call_table,.-sys_call_table
> diff --git a/arch/mips/kernel/scall64-n32.S b/arch/mips/kernel/scall64-n32.S
> index ecdd65a..235892a 100644
> --- a/arch/mips/kernel/scall64-n32.S
> +++ b/arch/mips/kernel/scall64-n32.S
> @@ -430,4 +430,5 @@ EXPORT(sysn32_call_table)
> 	PTR	sys_bpf
> 	PTR	compat_sys_execveat		/* 6320 */
> 	PTR	sys_mlock2
> +	PTR	sys_membarrier
> 	.size	sysn32_call_table,.-sysn32_call_table
> diff --git a/arch/mips/kernel/scall64-o32.S b/arch/mips/kernel/scall64-o32.S
> index 7a8b2df..c051bd3 100644
> --- a/arch/mips/kernel/scall64-o32.S
> +++ b/arch/mips/kernel/scall64-o32.S
> @@ -585,4 +585,5 @@ EXPORT(sys32_call_table)
> 	PTR	sys_bpf				/* 4355 */
> 	PTR	compat_sys_execveat
> 	PTR	sys_mlock2
> +	PTR	sys_membarrier
> 	.size	sys32_call_table,.-sys32_call_table
> --
> 1.9.1

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
