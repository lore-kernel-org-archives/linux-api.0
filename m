From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [PATCH] sched/core: expand sched_getaffinity(2) to return number
 of CPUs
Date: Sat, 6 Apr 2019 22:48:25 +0300
Message-ID: <20190406194825.GA5106@avx2>
References: <20190403200809.GA13876@avx2>
 <20190404084249.GS4038@hirez.programming.kicks-ass.net>
 <87wok83gfs.fsf@oldenburg2.str.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87wok83gfs.fsf@oldenburg2.str.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Florian Weimer <fweimer@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>, mingo@redhat.com, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Fri, Apr 05, 2019 at 12:16:39PM +0200, Florian Weimer wrote:
> * Peter Zijlstra:
> 
> > On Wed, Apr 03, 2019 at 11:08:09PM +0300, Alexey Dobriyan wrote:
> >> Currently there is no easy way to get the number of CPUs on the system.
> 
> The size of the affinity mask is only related to the number of CPUs in
> the system in such a way that the number of CPUs cannot be larger than
> the number of bits in the affinity mask.
> 
> >> Glibc in particular shipped with 1024 CPUs support maximum at some point
> >> which is quite surprising as glibc maitainers should know better.
> 
> This dates back to a time when the kernel was never going to support
> more than 1024 CPUs.
> 
> A lot of distribution kernels still enforce a hard limit, which papers
> over firmware bugs which tell the kernel that the system can be
> hot-plugged to a ridiculous number of sockets/CPUs.
> 
> >> Another group dynamically grow buffer until cpumask fits. This is
> >> inefficient as multiple system calls are done.
> >> 
> >> Nobody seems to parse "/sys/devices/system/cpu/possible".
> >> Even if someone does, parsing sysfs is much slower than necessary.
> >
> > True; but I suppose glibc already does lots of that anyway, right? It
> > does contain the right information.
> 
> If I recall correctly my last investigation,
> /sys/devices/system/cpu/possible does not reflect the size of the
> affinity mask, either.
> 
> >> Patch overloads sched_getaffinity(len=0) to simply return "nr_cpu_ids".
> >> This will make gettting CPU mask require at most 2 system calls
> >> and will eliminate unnecessary code.
> >> 
> >> len=0 is chosen so that
> >> * passing zeroes is the simplest thing
> >> 
> >> 	syscall(__NR_sched_getaffinity, 0, 0, NULL)
> >> 
> >>   will simply do the right thing,
> >> 
> >> * old kernels returned -EINVAL unconditionally.
> >> 
> >> Note: glibc segfaults upon exiting from system call because it tries to
> >> clear the rest of the buffer if return value is positive, so
> >> applications will have to use syscall(3).
> >> Good news is that it proves noone uses sched_getaffinity(pid, 0, NULL).
> 
> Given that old kernels fail with EINVAL, that evidence is fairly
> restricted.
> 
> I'm not sure if it's a good idea to overload this interface.  I expect
> that users will want to call sched_getaffinity (the system call wrapper)
> with cpusetsize == 0 to query the value, so there will be pressure on
> glibc to remove the memset.  At that point we have an API that obscurely
> fails with old glibc versions, but suceeds with newer ones, which isn't
> great.

I can do "if (len == 536870912)" so that bit count overflows on old
kernels into EINVAL and is unlikely to be used ever.
