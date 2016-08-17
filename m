From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [Documentation] State of CPU controller in cgroup v2
Date: Wed, 17 Aug 2016 13:18:24 -0700
Message-ID: <CALCETrXvLNeds+ugZ8j3eD1Zg1RZYJSAET3Kguz5G2vqSLFCwQ@mail.gmail.com>
References: <20160805170752.GK2542@mtj.duckdns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160805170752.GK2542@mtj.duckdns.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>, Mike Galbraith <umgwanakikbuti@gmail.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, kernel-team@fb.com, "open list:CONTROL GROUP (CGROUP)" <cgroups@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Paul Turner <pjt@google.com>, Li Zefan <lizefan@huawei.com>, Linux API <linux-api@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>, Johannes Weiner <hannes@cmpxchg.org>, Linus Torvalds <torvalds@linux-foundation.org>
List-Id: linux-api@vger.kernel.org

On Aug 5, 2016 7:07 PM, "Tejun Heo" <tj@kernel.org> wrote:
>
> Hello,
>
> There have been several discussions around CPU controller support.
> Unfortunately, no consensus was reached and cgroup v2 is sorely
> lacking CPU controller support.  This document includes summary of the
> situation and arguments along with an interim solution for parties who
> want to use the out-of-tree patches for CPU controller cgroup v2
> support.  I'll post the two patches as replies for reference.
>
> Thanks.
>
>
> CPU Controller on Control Group v2
>
> August, 2016            Tejun Heo <tj@kernel.org>
>
>
> While most controllers have support for cgroup v2 now, the CPU
> controller support is not upstream yet due to objections from the
> scheduler maintainers on the basic designs of cgroup v2.  This
> document explains the current situation as well as an interim
> solution, and details the disagreements and arguments.  The latest
> version of this document can be found at the following URL.
>
>  https://git.kernel.org/cgit/linux/kernel/git/tj/cgroup.git/tree/Documentation/cgroup-v2-cpu.txt?h=cgroup-v2-cpu
>
>
> CONTENTS
>
> 1. Current Situation and Interim Solution
> 2. Disagreements and Arguments
>   2-1. Contentious Restrictions
>     2-1-1. Process Granularity
>     2-1-2. No Internal Process Constraint
>   2-2. Impact on CPU Controller
>     2-2-1. Impact of Process Granularity
>     2-2-2. Impact of No Internal Process Constraint
>   2-3. Arguments for cgroup v2
> 3. Way Forward
> 4. References
>
>
> 1. Current Situation and Interim Solution
>
> All objections from the scheduler maintainers apply to cgroup v2 core
> design, and there are no known objections to the specifics of the CPU
> controller cgroup v2 interface.  The only blocked part is changes to
> expose the CPU controller interface on cgroup v2, which comprises the
> following two patches:
>
>  [1] sched: Misc preps for cgroup unified hierarchy interface
>  [2] sched: Implement interface for cgroup unified hierarchy
>
> The necessary changes are superficial and implement the interface
> files on cgroup v2.  The combined diffstat is as follows.
>
>  kernel/sched/core.c    |  149 +++++++++++++++++++++++++++++++++++++++++++++++--
>  kernel/sched/cpuacct.c |   57 ++++++++++++------
>  kernel/sched/cpuacct.h |    5 +
>  3 files changed, 189 insertions(+), 22 deletions(-)
>
> The patches are easy to apply and forward-port.  The following git
> branch will always carry the two patches on top of the latest release
> of the upstream kernel.
>
>  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git/cgroup-v2-cpu
>
> There also are versioned branches going back to v4.4.
>
>  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git/cgroup-v2-cpu-$KERNEL_VER
>
> While it's difficult to tell whether the CPU controller support will
> be merged, there are crucial resource control features in cgroup v2
> that are only possible due to the design choices that are being
> objected to, and every effort will be made to ease enabling the CPU
> controller cgroup v2 support out-of-tree for parties which choose to.
>
>
> 2. Disagreements and Arguments
>
> There have been several lengthy discussion threads [3][4] on LKML
> around the structural constraints of cgroup v2.  The two that affect
> the CPU controller are process granularity and no internal process
> constraint.  Both arise primarily from the need for common resource
> domain definition across different resources.
>
> The common resource domain is a powerful concept in cgroup v2 that
> allows controllers to make basic assumptions about the structural
> organization of processes and controllers inside the cgroup hierarchy,
> and thus solve problems spanning multiple types of resources.  The
> prime example for this is page cache writeback: dirty page cache is
> regulated through throttling buffered writers based on memory
> availability, and initiating batched write outs to the disk based on
> IO capacity.  Tracking and controlling writeback inside a cgroup thus
> requires the direct cooperation of the memory and the IO controller.
>
> This easily extends to other areas, such as CPU cycles consumed while
> performing memory reclaim or IO encryption.
>
>
> 2-1. Contentious Restrictions
>
> For controllers of different resources to work together, they must
> agree on a common organization.  This uniform model across controllers
> imposes two contentious restrictions on the CPU controller: process
> granularity and the no-internal-process constraint.
>
>
>   2-1-1. Process Granularity
>
>   For memory, because an address space is shared between all threads
>   of a process, the terminal consumer is a process, not a thread.
>   Separating the threads of a single process into different memory
>   control domains doesn't make semantical sense.  cgroup v2 ensures
>   that all controller can agree on the same organization by requiring
>   that threads of the same process belong to the same cgroup.

I haven't followed all of the history here, but it seems to me that
this argument is less accurate than it appears.  Linux, for better or
for worse, has somewhat orthogonal concepts of thread groups
(processes), mms, and file tables.  An mm has VMAs in it, and VMAs can
reference things (files, etc) that hold resources.  (Two mms can share
resources by mapping the same thing or using fork().)  File tables
hold files, and files can use resources.  Both of these are, at best,
moderately good approximations of what actually holds resources.
Meanwhile, threads (tasks) do syscalls, take page faults, *allocate*
resources, etc.

So I think it's not really true to say that the "terminal consumer" of
anything is a process, not a thread.

While it's certainly easier to think about assigning processes to
cgroups, and I certainly agree that, in the common case, it's the
right thing to do, I don't see why requiring it is a good idea.  Can
we turn this around: what actually goes wrong if cgroup v2 were to
allow assigning individual threads if a user specifically requests it?

>
>   There are other reasons to enforce process granularity.  One
>   important one is isolating system-level management operations from
>   in-process application operations.  The cgroup interface, being a
>   virtual filesystem, is very unfit for multiple independent
>   operations taking place at the same time as most operations have to
>   be multi-step and there is no way to synchronize multiple accessors.
>   See also [5] Documentation/cgroup-v2.txt, "R-2. Thread Granularity"

I don't buy this argument at all.  System-level code is likely to
assign single process *trees*, which are a different beast entirely.
I.e. you fork, move the child into a cgroup, and that child and its
children stay in that cgroup.  I don't see how the thread/process
distinction matters.

On the contrary: with cgroup namespaces, one could easily create a
cgroup namespace, shove a process in it, and let that process delegate
its threads to child cgroups however it likes.  (Well, children of the
namespace root.)

>
>
>   2-1-2. No Internal Process Constraint
>
>   cgroup v2 does not allow processes to belong to any cgroup which has
>   child cgroups when resource controllers are enabled on it (the
>   notable exception being the root cgroup itself).

Can you elaborate on this exception?  How do you get any of the
supposed benefits of not having processes and cgroups exist as
siblings when you make an exception for the root?  Similarly, if you
make an exception for the root, what do you do about cgroup namespaces
where the apparent root isn't the global root?

--Andy
