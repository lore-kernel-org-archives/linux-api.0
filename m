From: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Subject: Re: [RFC PATCH v2 8/9] ia64: allocate sys_membarrier system call
 number
Date: Wed, 16 Sep 2015 15:19:12 +0000 (UTC)
Message-ID: <1791895548.9335.1442416752623.JavaMail.zimbra@efficios.com>
References: <1441642556-30972-1-git-send-email-mathieu.desnoyers@efficios.com> <1441642556-30972-9-git-send-email-mathieu.desnoyers@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1441642556-30972-9-git-send-email-mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tony Luck <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Fenghua Yu <fenghua.yu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-ia64-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-api <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

----- On Sep 7, 2015, at 12:15 PM, Mathieu Desnoyers mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org wrote:

> [ Untested on this architecture. To try it out: fetch linux-next/akpm,
>  apply this patch, build/run a membarrier-enabled kernel, and do make
>  kselftest. ]

Hi,

sys_membarrier has been merged into Linux 4.3-rc1. It can therefore
be tested on top of Linus' master.

Thanks,

Mathieu

> 
> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
> CC: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
> CC: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> CC: Tony Luck <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> CC: Fenghua Yu <fenghua.yu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> CC: linux-ia64-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> ---
> arch/ia64/include/asm/unistd.h      | 2 +-
> arch/ia64/include/uapi/asm/unistd.h | 1 +
> arch/ia64/kernel/entry.S            | 1 +
> 3 files changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/ia64/include/asm/unistd.h b/arch/ia64/include/asm/unistd.h
> index 95c39b9..1d54e17 100644
> --- a/arch/ia64/include/asm/unistd.h
> +++ b/arch/ia64/include/asm/unistd.h
> @@ -11,7 +11,7 @@
> 
> 
> 
> -#define NR_syscalls			319 /* length of syscall table */
> +#define NR_syscalls			320 /* length of syscall table */
> 
> /*
>  * The following defines stop scripts/checksyscalls.sh from complaining about
> diff --git a/arch/ia64/include/uapi/asm/unistd.h
> b/arch/ia64/include/uapi/asm/unistd.h
> index 4610795..b7aae55 100644
> --- a/arch/ia64/include/uapi/asm/unistd.h
> +++ b/arch/ia64/include/uapi/asm/unistd.h
> @@ -332,5 +332,6 @@
> #define __NR_memfd_create		1340
> #define __NR_bpf			1341
> #define __NR_execveat			1342
> +#define __NR_membarrier			1343
> 
> #endif /* _UAPI_ASM_IA64_UNISTD_H */
> diff --git a/arch/ia64/kernel/entry.S b/arch/ia64/kernel/entry.S
> index ae0de7b..1ce01f9 100644
> --- a/arch/ia64/kernel/entry.S
> +++ b/arch/ia64/kernel/entry.S
> @@ -1768,5 +1768,6 @@ sys_call_table:
> 	data8 sys_memfd_create			// 1340
> 	data8 sys_bpf
> 	data8 sys_execveat
> +	data8 sys_membarrier
> 
> 	.org sys_call_table + 8*NR_syscalls	// guard against failures to increase
> 	NR_syscalls
> --
> 1.9.1

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
