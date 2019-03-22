From: Carlos O'Donell <codonell@redhat.com>
Subject: Re: [PATCH 2/4] glibc: sched_getcpu(): use rseq cpu_id TLS on Linux
Date: Fri, 22 Mar 2019 16:13:52 -0400
Message-ID: <fc431a95-789a-6c02-13d0-d0d01916ee99@redhat.com>
References: <20190212194253.1951-1-mathieu.desnoyers@efficios.com>
 <20190212194253.1951-3-mathieu.desnoyers@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190212194253.1951-3-mathieu.desnoyers@efficios.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Carlos O'Donell <carlos@redhat.com>
Cc: Florian Weimer <fweimer@redhat.com>, Joseph Myers <joseph@codesourcery.com>, Szabolcs Nagy <szabolcs.nagy@arm.com>, libc-alpha@sourceware.org, Thomas Gleixner <tglx@linutronix.de>, Ben Maurer <bmaurer@fb.com>, Peter Zijlstra <peterz@infradead.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Will Deacon <will.deacon@arm.com>, Dave Watson <davejwatson@fb.com>, Paul Turner <pjt@google.com>, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On 2/12/19 2:42 PM, Mathieu Desnoyers wrote:
> When available, use the cpu_id field from __rseq_abi on Linux to
> implement sched_getcpu(). Fall-back on the vgetcpu vDSO if unavailable.
> 
> Benchmarks:
> 
> x86-64: Intel E5-2630 v3@2.40GHz, 16-core, hyperthreading

This patch looks good to me for master, but is blocked on patch 1/4
being reworked.

Reviewed-by: Carlos O'Donell <carlos@redhat.com>

> glibc sched_getcpu():                     13.7 ns (baseline)
> glibc sched_getcpu() using rseq:           2.5 ns (speedup:  5.5x)
> inline load cpuid from __rseq_abi TLS:     0.8 ns (speedup: 17.1x)
> 
> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> CC: Carlos O'Donell <carlos@redhat.com>
> CC: Florian Weimer <fweimer@redhat.com>
> CC: Joseph Myers <joseph@codesourcery.com>
> CC: Szabolcs Nagy <szabolcs.nagy@arm.com>
> CC: Thomas Gleixner <tglx@linutronix.de>
> CC: Ben Maurer <bmaurer@fb.com>
> CC: Peter Zijlstra <peterz@infradead.org>
> CC: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> CC: Boqun Feng <boqun.feng@gmail.com>
> CC: Will Deacon <will.deacon@arm.com>
> CC: Dave Watson <davejwatson@fb.com>
> CC: Paul Turner <pjt@google.com>
> CC: libc-alpha@sourceware.org
> CC: linux-kernel@vger.kernel.org
> CC: linux-api@vger.kernel.org
> ---
>   sysdeps/unix/sysv/linux/sched_getcpu.c | 25 +++++++++++++++++++++++--
>   1 file changed, 23 insertions(+), 2 deletions(-)
> 
> diff --git a/sysdeps/unix/sysv/linux/sched_getcpu.c b/sysdeps/unix/sysv/linux/sched_getcpu.c
> index fb0d317f83..8bfb03778b 100644
> --- a/sysdeps/unix/sysv/linux/sched_getcpu.c
> +++ b/sysdeps/unix/sysv/linux/sched_getcpu.c
> @@ -24,8 +24,8 @@
>   #endif
>   #include <sysdep-vdso.h>
>   
> -int
> -sched_getcpu (void)
> +static int
> +vsyscall_sched_getcpu (void)

OK.

>   {
>   #ifdef __NR_getcpu
>     unsigned int cpu;
> @@ -37,3 +37,24 @@ sched_getcpu (void)
>     return -1;
>   #endif
>   }
> +
> +#ifdef __NR_rseq
> +#include <linux/rseq.h>
> +
> +extern __attribute__ ((tls_model ("initial-exec")))
> +__thread volatile struct rseq __rseq_abi;

OK.

> +
> +int
> +sched_getcpu (void)
> +{
> +  int cpu_id = __rseq_abi.cpu_id;
> +
> +  return cpu_id >= 0 ? cpu_id : vsyscall_sched_getcpu ();

OK. Impressive :-)

> +}
> +#else
> +int
> +sched_getcpu (void)
> +{
> +  return vsyscall_sched_getcpu ();

OK.

> +}
> +#endif
> 


-- 
Cheers,
Carlos.
