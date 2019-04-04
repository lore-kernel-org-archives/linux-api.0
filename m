From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [PATCH] sched/core: expand sched_getaffinity(2) to return number
 of CPUs
Date: Thu, 4 Apr 2019 21:02:30 +0300
Message-ID: <20190404180230.GA14800@avx2>
References: <20190403200809.GA13876@avx2>
 <20190404084249.GS4038@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190404084249.GS4038@hirez.programming.kicks-ass.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Peter Zijlstra <peterz@infradead.org>
Cc: mingo@redhat.com, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Thu, Apr 04, 2019 at 10:42:49AM +0200, Peter Zijlstra wrote:
> On Wed, Apr 03, 2019 at 11:08:09PM +0300, Alexey Dobriyan wrote:
> > Currently there is no easy way to get the number of CPUs on the system.
> 
> And this patch doesn't change that :-)

It does! Application or a library could do one idempotent system call
in a constructor.

> Still, it does the right thing and I like it.

Thanks.

> The point is that nr_cpu_ids is the length of the bitmap, but does not
> contain information on how many CPUs are in the system. Consider the
> case where the bitmap is sparse.

I understand that but how do you ship number of CPUs _and_ possible mask
in one go?

> > Applications are divided into 2 groups:
> > One group allocates buffer and call sched_getaffinity(2) once. It works
> > but either underallocate or overallocates and in the future such application
> > will become buggy as Linux will start working on even more SMP-ier systems.
> > 
> > Glibc in particular shipped with 1024 CPUs support maximum at some point
> > which is quite surprising as glibc maitainers should know better.
> > 
> > Another group dynamically grow buffer until cpumask fits. This is
> > inefficient as multiple system calls are done.
> > 
> > Nobody seems to parse "/sys/devices/system/cpu/possible".
> > Even if someone does, parsing sysfs is much slower than necessary.
> 
> True; but I suppose glibc already does lots of that anyway, right? It
> does contain the right information.

sched_getaffinity(3) does sched_getaffinity(2) + memset()

sysconf(_SC_NPROCESSORS_ONLN) does "/sys/devices/system/cpu/online"

sysconf(_SC_NPROCESSORS_CONF) does readdir("/sys/devices/system/cpu")
which is 5 syscalls. I'm not sure which cpumask readdir represents.

> > Patch overloads sched_getaffinity(len=0) to simply return "nr_cpu_ids".
> > This will make gettting CPU mask require at most 2 system calls
> > and will eliminate unnecessary code.
> > 
> > len=0 is chosen so that
> > * passing zeroes is the simplest thing
> > 
> > 	syscall(__NR_sched_getaffinity, 0, 0, NULL)
> > 
> >   will simply do the right thing,
> > 
> > * old kernels returned -EINVAL unconditionally.
> > 
> > Note: glibc segfaults upon exiting from system call because it tries to
> > clear the rest of the buffer if return value is positive, so
> > applications will have to use syscall(3).
> > Good news is that it proves noone uses sched_getaffinity(pid, 0, NULL).
> 
> This also needs a manpage update. And I'm missing the libc people on Cc.

[nods]
Shipping "man/2/" with kernel is long overdue. :^)

> > --- a/kernel/sched/core.c
> > +++ b/kernel/sched/core.c
> > @@ -4942,6 +4942,9 @@ SYSCALL_DEFINE3(sched_getaffinity, pid_t, pid, unsigned int, len,
> >  	int ret;
> >  	cpumask_var_t mask;
> >  
> > +	if (len == 0)
> > +		return nr_cpu_ids;
> > +
> >  	if ((len * BITS_PER_BYTE) < nr_cpu_ids)
> >  		return -EINVAL;
> >  	if (len & (sizeof(unsigned long)-1))
