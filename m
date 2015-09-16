From: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Subject: Re: [RFC PATCH v2 6/9] arm: allocate sys_membarrier system call
 number
Date: Wed, 16 Sep 2015 18:27:10 +0000 (UTC)
Message-ID: <2106738851.9514.1442428030540.JavaMail.zimbra@efficios.com>
References: <1441642556-30972-1-git-send-email-mathieu.desnoyers@efficios.com> <1441642556-30972-7-git-send-email-mathieu.desnoyers@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1441642556-30972-7-git-send-email-mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Russell King <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-api <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Michael Jeanson <mjeanson-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

----- On Sep 7, 2015, at 12:15 PM, Mathieu Desnoyers mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org wrote:

> [ Untested on this architecture. To try it out: fetch linux-next/akpm,
>  apply this patch, build/run a membarrier-enabled kernel, and do make
>  kselftest. ]

Hi,

We tested the system call on our ARM board (Wandboard, SoC
Freescale i.MX6 Quad) by applying this patch on top of
Linux 4.3-rc1. Both the membarrier kselftest and
Userspace RCU regression tests (the latter manually wired up
on sys_membarrier) work fine.

Tested-by: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>

sys_membarrier has been pulled into Linux 4.3-rc1. Please
feel free to wire it up on ARM.

Thanks!

Mathieu


> 
> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
> CC: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
> CC: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> CC: Russell King <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>
> ---
> arch/arm/include/asm/unistd.h      | 2 +-
> arch/arm/include/uapi/asm/unistd.h | 1 +
> arch/arm/kernel/calls.S            | 1 +
> 3 files changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm/include/asm/unistd.h b/arch/arm/include/asm/unistd.h
> index 32640c4..d93876c 100644
> --- a/arch/arm/include/asm/unistd.h
> +++ b/arch/arm/include/asm/unistd.h
> @@ -19,7 +19,7 @@
>  * This may need to be greater than __NR_last_syscall+1 in order to
>  * account for the padding in the syscall table
>  */
> -#define __NR_syscalls  (388)
> +#define __NR_syscalls  (389)
> 
> /*
>  * *NOTE*: This is a ghost syscall private to the kernel.  Only the
> diff --git a/arch/arm/include/uapi/asm/unistd.h
> b/arch/arm/include/uapi/asm/unistd.h
> index 0c3f5a0..436bb32 100644
> --- a/arch/arm/include/uapi/asm/unistd.h
> +++ b/arch/arm/include/uapi/asm/unistd.h
> @@ -414,6 +414,7 @@
> #define __NR_memfd_create		(__NR_SYSCALL_BASE+385)
> #define __NR_bpf			(__NR_SYSCALL_BASE+386)
> #define __NR_execveat			(__NR_SYSCALL_BASE+387)
> +#define __NR_membarrier			(__NR_SYSCALL_BASE+388)
> 
> /*
>  * The following SWIs are ARM private.
> diff --git a/arch/arm/kernel/calls.S b/arch/arm/kernel/calls.S
> index 05745eb..310699c 100644
> --- a/arch/arm/kernel/calls.S
> +++ b/arch/arm/kernel/calls.S
> @@ -397,6 +397,7 @@
> /* 385 */	CALL(sys_memfd_create)
> 		CALL(sys_bpf)
> 		CALL(sys_execveat)
> +		CALL(sys_membarrier)
> #ifndef syscalls_counted
> .equ syscalls_padding, ((NR_syscalls + 3) & ~3) - NR_syscalls
> #define syscalls_counted
> --
> 1.9.1

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
