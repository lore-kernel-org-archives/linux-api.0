From: "Helge Deller" <deller-Mmb7MZpHnFY@public.gmane.org>
Subject: Re: [RFC PATCH 9/9] parisc: allocate sys_membarrier system call
 number
Date: Thu, 3 Sep 2015 14:26:10 +0200
Message-ID: <trinity-920d5daa-933d-4e50-bd13-713e544e93c4-1441283170751@3capp-gmx-bs04>
References: <1440698215-8355-1-git-send-email-mathieu.desnoyers@efficios.com>,
 <1440698215-8355-10-git-send-email-mathieu.desnoyers@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1440698215-8355-10-git-send-email-mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "James E.J. Bottomley" <jejb-6jwH94ZQLHl74goWV3ctuw@public.gmane.org>, linux-parisc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Hi Mathieu,

> [ Untested on this architecture. To try it out: fetch linux-next/akpm,
>   apply this patch, build/run a membarrier-enabled kernel, and do make
>   kselftest. ]
> 
> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
> CC: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
> CC: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> CC: "James E.J. Bottomley" <jejb-6jwH94ZQLHl74goWV3ctuw@public.gmane.org>
> CC: Helge Deller <deller-Mmb7MZpHnFY@public.gmane.org>
> CC: linux-parisc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> ---
>  arch/parisc/include/uapi/asm/unistd.h | 3 ++-
>  arch/parisc/kernel/syscall_table.S    | 1 +
>  2 files changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/parisc/include/uapi/asm/unistd.h b/arch/parisc/include/uapi/asm/unistd.h
> index 2e639d7..dadcada 100644
> --- a/arch/parisc/include/uapi/asm/unistd.h
> +++ b/arch/parisc/include/uapi/asm/unistd.h
> @@ -358,8 +358,9 @@
>  #define __NR_memfd_create	(__NR_Linux + 340)
>  #define __NR_bpf		(__NR_Linux + 341)
>  #define __NR_execveat		(__NR_Linux + 342)
> +#define __NR_membarrier		(__NR_Linux + 343)
>  
> -#define __NR_Linux_syscalls	(__NR_execveat + 1)
> +#define __NR_Linux_syscalls	(__NR_membarrier + 1)
>  
>  
>  #define __IGNORE_select		/* newselect */
> diff --git a/arch/parisc/kernel/syscall_table.S b/arch/parisc/kernel/syscall_table.S
> index 8eefb12..2faa43b 100644
> --- a/arch/parisc/kernel/syscall_table.S
> +++ b/arch/parisc/kernel/syscall_table.S
> @@ -438,6 +438,7 @@
>  	ENTRY_SAME(memfd_create)	/* 340 */
>  	ENTRY_SAME(bpf)
>  	ENTRY_COMP(execveat)
> +	ENTRY_COMP(membarrier)

This needs to be ENTRY_SAME(membarrier), since you don't have/need a compat_membarrier() function.

After changing to ENTRY_SAME() I did run the kselftest on parisc: 
deller@ls3xx> ./membarrier_test 
membarrier MEMBARRIER_CMD_QUERY syscall available.
membarrier: MEMBARRIER_CMD_SHARED success.
membarrier: tests done!

Helge
