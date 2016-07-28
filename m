From: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Subject: Re: [RFC 3/4] Restartable sequences: Wire up powerpc system call
Date: Thu, 28 Jul 2016 03:13:36 +0000 (UTC)
Message-ID: <1585254533.431.1469675616159.JavaMail.zimbra@efficios.com>
References: <20160727150352.GA32142@tardis.cn.ibm.com> <20160727150517.26983-1-boqun.feng@gmail.com> <20160727150517.26983-3-boqun.feng@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160727150517.26983-3-boqun.feng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Boqun Feng <boqun.feng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Russell King <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>, Dave Watson <davejwatson-b10kYP2dOMg@public.gmane.org>, Chris Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Ben Maurer <bmaurer-b10kYP2dOMg@public.gmane.org>, rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>, Benjamin Herrenschmidt <benh-XVmvHMARGAS8U2dJNN8I7kB+6BGkLq7r@public.gmane.org>, Paul Mackerras <paulus-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
List-Id: linux-api@vger.kernel.org

----- On Jul 27, 2016, at 11:05 AM, Boqun Feng boqun.feng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:

> Wire up the rseq system call on powerpc.
> 
> This provides an ABI improving the speed of a user-space getcpu
> operation on powerpc by skipping the getcpu system call on the fast
> path, as well as improving the speed of user-space operations on per-cpu
> data compared to using load-reservation/store-conditional atomics.

Picked up in my dev branch too, thanks!

Mathieu

> 
> Signed-off-by: Boqun Feng <boqun.feng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
> arch/powerpc/include/asm/systbl.h      | 1 +
> arch/powerpc/include/asm/unistd.h      | 2 +-
> arch/powerpc/include/uapi/asm/unistd.h | 1 +
> 3 files changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/powerpc/include/asm/systbl.h
> b/arch/powerpc/include/asm/systbl.h
> index 2fc5d4db503c..c68f4d0d00b2 100644
> --- a/arch/powerpc/include/asm/systbl.h
> +++ b/arch/powerpc/include/asm/systbl.h
> @@ -386,3 +386,4 @@ SYSCALL(mlock2)
> SYSCALL(copy_file_range)
> COMPAT_SYS_SPU(preadv2)
> COMPAT_SYS_SPU(pwritev2)
> +SYSCALL(rseq)
> diff --git a/arch/powerpc/include/asm/unistd.h
> b/arch/powerpc/include/asm/unistd.h
> index cf12c580f6b2..a01e97d3f305 100644
> --- a/arch/powerpc/include/asm/unistd.h
> +++ b/arch/powerpc/include/asm/unistd.h
> @@ -12,7 +12,7 @@
> #include <uapi/asm/unistd.h>
> 
> 
> -#define NR_syscalls		382
> +#define NR_syscalls		383
> 
> #define __NR__exit __NR_exit
> 
> diff --git a/arch/powerpc/include/uapi/asm/unistd.h
> b/arch/powerpc/include/uapi/asm/unistd.h
> index e9f5f41aa55a..d1849d64c8ef 100644
> --- a/arch/powerpc/include/uapi/asm/unistd.h
> +++ b/arch/powerpc/include/uapi/asm/unistd.h
> @@ -392,5 +392,6 @@
> #define __NR_copy_file_range	379
> #define __NR_preadv2		380
> #define __NR_pwritev2		381
> +#define __NR_rseq		382
> 
> #endif /* _UAPI_ASM_POWERPC_UNISTD_H_ */
> --
> 2.9.0

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
