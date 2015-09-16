From: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Subject: Re: [RFC PATCH v2 5/9] alpha: allocate sys_membarrier system call
 number
Date: Wed, 16 Sep 2015 15:17:32 +0000 (UTC)
Message-ID: <51956530.9332.1442416652786.JavaMail.zimbra@efficios.com>
References: <1441642556-30972-1-git-send-email-mathieu.desnoyers@efficios.com> <1441642556-30972-6-git-send-email-mathieu.desnoyers@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1441642556-30972-6-git-send-email-mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Richard Henderson <rth-hL46jP5Bxq7R7s880joybQ@public.gmane.org>, Ivan Kokshaysky <ink-biIs/Y0ymYJMZLIVYojuPNP0rXTJTi09@public.gmane.org>, Matt Turner <mattst88-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-alpha-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-api <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

----- On Sep 7, 2015, at 12:15 PM, Mathieu Desnoyers mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org wrote:

> [ Untested on this architecture. To try it out: fetch linux-next/akpm,
>  apply this patch, build/run a membarrier-enabled kernel, and do make
>  kselftest. ]

Hi,

sys_membarrier has been merged into Linux 4.3-rc1. sys_membarrier can therefore
be tested on top of Linus' master.

Thanks,

Mathieu

> 
> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
> CC: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
> CC: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> CC: Richard Henderson <rth-hL46jP5Bxq7R7s880joybQ@public.gmane.org>
> CC: Ivan Kokshaysky <ink-biIs/Y0ymYJMZLIVYojuPNP0rXTJTi09@public.gmane.org>
> CC: Matt Turner <mattst88-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> CC: linux-alpha-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> ---
> arch/alpha/include/asm/unistd.h      | 2 +-
> arch/alpha/include/uapi/asm/unistd.h | 1 +
> arch/alpha/kernel/systbls.S          | 1 +
> 3 files changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/alpha/include/asm/unistd.h b/arch/alpha/include/asm/unistd.h
> index a56e608..07aa4ca 100644
> --- a/arch/alpha/include/asm/unistd.h
> +++ b/arch/alpha/include/asm/unistd.h
> @@ -3,7 +3,7 @@
> 
> #include <uapi/asm/unistd.h>
> 
> -#define NR_SYSCALLS			514
> +#define NR_SYSCALLS			515
> 
> #define __ARCH_WANT_OLD_READDIR
> #define __ARCH_WANT_STAT64
> diff --git a/arch/alpha/include/uapi/asm/unistd.h
> b/arch/alpha/include/uapi/asm/unistd.h
> index aa33bf5..7725619 100644
> --- a/arch/alpha/include/uapi/asm/unistd.h
> +++ b/arch/alpha/include/uapi/asm/unistd.h
> @@ -475,5 +475,6 @@
> #define __NR_getrandom			511
> #define __NR_memfd_create		512
> #define __NR_execveat			513
> +#define __NR_membarrier			514
> 
> #endif /* _UAPI_ALPHA_UNISTD_H */
> diff --git a/arch/alpha/kernel/systbls.S b/arch/alpha/kernel/systbls.S
> index 9b62e3f..1ea64f4 100644
> --- a/arch/alpha/kernel/systbls.S
> +++ b/arch/alpha/kernel/systbls.S
> @@ -532,6 +532,7 @@ sys_call_table:
> 	.quad sys_getrandom
> 	.quad sys_memfd_create
> 	.quad sys_execveat
> +	.quad sys_membarrier
> 
> 	.size sys_call_table, . - sys_call_table
> 	.type sys_call_table, @object
> --
> 1.9.1

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
