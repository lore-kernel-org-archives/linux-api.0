From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] sched/core: expand sched_getaffinity(2) to return number
 of CPUs
Date: Thu, 4 Apr 2019 10:42:49 +0200
Message-ID: <20190404084249.GS4038@hirez.programming.kicks-ass.net>
References: <20190403200809.GA13876@avx2>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190403200809.GA13876@avx2>
Sender: linux-kernel-owner@vger.kernel.org
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: mingo@redhat.com, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Wed, Apr 03, 2019 at 11:08:09PM +0300, Alexey Dobriyan wrote:
> Currently there is no easy way to get the number of CPUs on the system.

And this patch doesn't change that :-) Still, it does the right thing
and I like it.

The point is that nr_cpu_ids is the length of the bitmap, but does not
contain information on how many CPUs are in the system. Consider the
case where the bitmap is sparse.

> Applications are divided into 2 groups:
> One group allocates buffer and call sched_getaffinity(2) once. It works
> but either underallocate or overallocates and in the future such application
> will become buggy as Linux will start working on even more SMP-ier systems.
> 
> Glibc in particular shipped with 1024 CPUs support maximum at some point
> which is quite surprising as glibc maitainers should know better.
> 
> Another group dynamically grow buffer until cpumask fits. This is
> inefficient as multiple system calls are done.
> 
> Nobody seems to parse "/sys/devices/system/cpu/possible".
> Even if someone does, parsing sysfs is much slower than necessary.

True; but I suppose glibc already does lots of that anyway, right? It
does contain the right information.

> Patch overloads sched_getaffinity(len=0) to simply return "nr_cpu_ids".
> This will make gettting CPU mask require at most 2 system calls
> and will eliminate unnecessary code.
> 
> len=0 is chosen so that
> * passing zeroes is the simplest thing
> 
> 	syscall(__NR_sched_getaffinity, 0, 0, NULL)
> 
>   will simply do the right thing,
> 
> * old kernels returned -EINVAL unconditionally.
> 
> Note: glibc segfaults upon exiting from system call because it tries to
> clear the rest of the buffer if return value is positive, so
> applications will have to use syscall(3).
> Good news is that it proves noone uses sched_getaffinity(pid, 0, NULL).

This also needs a manpage update. And I'm missing the libc people on Cc.

> Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
> ---
> 
>  kernel/sched/core.c |    3 +++
>  1 file changed, 3 insertions(+)
> 
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -4942,6 +4942,9 @@ SYSCALL_DEFINE3(sched_getaffinity, pid_t, pid, unsigned int, len,
>  	int ret;
>  	cpumask_var_t mask;
>  
> +	if (len == 0)
> +		return nr_cpu_ids;
> +
>  	if ((len * BITS_PER_BYTE) < nr_cpu_ids)
>  		return -EINVAL;
>  	if (len & (sizeof(unsigned long)-1))
