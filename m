From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] sched/core: expand sched_getaffinity(2) to return number
 of CPUs
Date: Fri, 5 Apr 2019 11:26:57 +0200
Message-ID: <20190405092657.GD4038@hirez.programming.kicks-ass.net>
References: <20190403200809.GA13876@avx2>
 <20190404084249.GS4038@hirez.programming.kicks-ass.net>
 <20190404180230.GA14800@avx2>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190404180230.GA14800@avx2>
Sender: linux-kernel-owner@vger.kernel.org
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: mingo@redhat.com, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Thu, Apr 04, 2019 at 09:02:30PM +0300, Alexey Dobriyan wrote:
> On Thu, Apr 04, 2019 at 10:42:49AM +0200, Peter Zijlstra wrote:
> > On Wed, Apr 03, 2019 at 11:08:09PM +0300, Alexey Dobriyan wrote:
> > > Currently there is no easy way to get the number of CPUs on the system.
> > 
> > And this patch doesn't change that :-)
> 
> It does! Application or a library could do one idempotent system call
> in a constructor.

You said: "get the number of CPUs on the system", but what this call
actually returns is: "size of CPU bitmask", these two things are
distinctly not the same.

> > The point is that nr_cpu_ids is the length of the bitmap, but does not
> > contain information on how many CPUs are in the system. Consider the
> > case where the bitmap is sparse.
> 
> I understand that but how do you ship number of CPUs _and_ possible mask
> in one go?

You don't, possible mask is unrelated to number of CPUs and both are
unrelated to bitmap size.

In particular:

  nr_cpus <= nr_possible_cpus <= nr_cpumask_bits

In absurdum an architecture could choose to iterate its CPUs as
1024*cpuid, just for giggles. Then suppose it has two sockets, and 16
CPUs per socket and only the second socket is populated.

The we get:

  nr_cpumask_bits = 32k
  nr_possible_cpus = 32
  nr_cpus = 16

see what I mean?

Now, luckily we typically don't have crap like that, but I suspect that
with a little creative ACPI table magic we could actually get something
slightly less absurd but still non-trivial even on x86.

Also see how num_possible_cpus() is defined as
cpumask_weight(cpu_possible_mask), which is very much not nr_cpu_ids in
the generic case.

> > > Nobody seems to parse "/sys/devices/system/cpu/possible".
> > > Even if someone does, parsing sysfs is much slower than necessary.
> > 
> > True; but I suppose glibc already does lots of that anyway, right? It
> > does contain the right information.
> 
> sched_getaffinity(3) does sched_getaffinity(2) + memset()
> 
> sysconf(_SC_NPROCESSORS_ONLN) does "/sys/devices/system/cpu/online"
> 
> sysconf(_SC_NPROCESSORS_CONF) does readdir("/sys/devices/system/cpu")
> which is 5 syscalls. I'm not sure which cpumask readdir represents.

It counts the number of CPUs, which is strictly not the same as the
bitmap size.
