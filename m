From: Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [RFC PATCH 3/9] arm64: allocate sys_membarrier system call number
Date: Wed, 2 Sep 2015 11:10:50 +0100
Message-ID: <20150902101049.GE25720@arm.com>
References: <1440698215-8355-1-git-send-email-mathieu.desnoyers@efficios.com>
 <1440698215-8355-4-git-send-email-mathieu.desnoyers@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1440698215-8355-4-git-send-email-mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Catalin Marinas <Catalin.Marinas-5wv7dgnIgG8@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thu, Aug 27, 2015 at 06:56:49PM +0100, Mathieu Desnoyers wrote:
> arm64 sys_membarrier number is already wired for arm64 through
> asm-generic/unistd.h, but needs to be allocated separately for
> the 32-bit compability layer of arm64.
> 
> [ Untested on this architecture. To try it out: fetch linux-next/akpm,
>   apply this patch, build/run a membarrier-enabled kernel, and do make
>   kselftest. ]
> 
> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
> CC: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
> CC: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> CC: Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>
> CC: Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>
> ---
>  arch/arm64/include/asm/unistd32.h | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/unistd32.h b/arch/arm64/include/asm/unistd32.h
> index cef934a..d97be80 100644
> --- a/arch/arm64/include/asm/unistd32.h
> +++ b/arch/arm64/include/asm/unistd32.h
> @@ -797,3 +797,5 @@ __SYSCALL(__NR_memfd_create, sys_memfd_create)
>  __SYSCALL(__NR_bpf, sys_bpf)
>  #define __NR_execveat 387
>  __SYSCALL(__NR_execveat, compat_sys_execveat)
> +#define __NR_membarrier 388
> +__SYSCALL(__NR_membarrier, sys_membarrier)

I think people have made similar comments for other architectures, but
please also updated __NR_compat_syscalls when adding new compat syscalls
here.

Will
