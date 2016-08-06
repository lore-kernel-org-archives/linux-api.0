From: Mike Galbraith <umgwanakikbuti-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [Documentation] State of CPU controller in cgroup v2
Date: Sat, 06 Aug 2016 11:04:51 +0200
Message-ID: <1470474291.4117.243.camel@gmail.com>
References: <20160805170752.GK2542@mtj.duckdns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160805170752.GK2542-qYNAdHglDFBN0TnZuCh8vA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Fri, 2016-08-05 at 13:07 -0400, Tejun Heo wrote:

> 2-2. Impact on CPU Controller
> 
> As indicated earlier, the CPU controller's resource distribution graph
> is the simplest.  Every schedulable resource consumption can be
> attributed to a specific task.  In addition, for weight based control,
> the per-task priority set through setpriority(2) can be translated to
> and from a per-cgroup weight.  As such, the CPU controller can treat a
> task and a cgroup symmetrically, allowing support for any tree layout
> of cgroups and tasks.  Both process granularity and the no internal
> process constraint restrict how the CPU controller can be used.

Not only the cpu controller, but also cpuacct and cpuset.

>   2-2-1. Impact of Process Granularity
> 
>   Process granularity prevents tasks belonging to the same process to
>   be assigned to different cgroups.  It was pointed out [6] that this
>   excludes the valid use case of hierarchical CPU distribution within
>   processes.

Does that not obsolete the rather useful/common concept "thread pool"?

>   2-2-2. Impact of No Internal Process Constraint
> 
>   The no internal process constraint disallows tasks from competing
>   directly against cgroups.  Here is an excerpt from Peter Zijlstra
>   pointing out the issue [10] - R, L and A are cgroups; t1, t2, t3 and
>   t4 are tasks:
> 
> 
>           R
>         / | \
>        t1 t2 A
>            /   \
>           t3   t4
> 
> 
>     Is fundamentally different from:
> 
> 
>                R
>              /   \
>            L       A
>          /   \   /   \
>         t1  t2  t3   t4
> 
> 
>     Because if in the first hierarchy you add a task (t5) to R, all of
>     its A will run at 1/4th of total bandwidth where before it had
>     1/3rd, whereas with the second example, if you add our t5 to L, A
>     doesn't get any less bandwidth.
> 
> 
>   It is true that the trees are semantically different from each other
>   and the symmetric handling of tasks and cgroups is aesthetically
>   pleasing.  However, it isn't clear what the practical usefulness of
>   a layout with direct competition between tasks and cgroups would be,
>   considering that number and behavior of tasks are controlled by each
>   application, and cgroups primarily deal with system level resource
>   distribution; changes in the number of active threads would directly
>   impact resource distribution.  Real world use cases of such layouts
>   could not be established during the discussions.

You apparently intend to ignore any real world usages that don't work
with these new constraints.  Priority and affinity are not process wide
attributes, never have been, but you're insisting that so they must
become for the sake of progress.

I mentioned a real world case of a thread pool servicing customer
accounts by doing something quite sane: hop into an account (cgroup),
do work therein, send bean count off to the $$ department, wash, rinse
repeat.  That's real world users making real world cash registers go ka
-ching so real world people can pay their real world bills.

I also mentioned breakage to cpusets: given exclusive set A and
exclusive subset B therein, there is one and only one spot where
affinity A exists... at the to be forbidden junction of A and B.

As with the thread pool, process granularity makes it impossible for
any threaded application affinity to be managed via cpusets, such as
say stuffing realtime critical threads into a shielded cpuset, mundane
threads into another.  There are any number of affinity usages that
will break.

Try as I may, I can't see anything progressive about enforcing process
granularity of per thread attributes.  I do see regression potential
for users of these controllers, and no viable means to even report them
as being such.  It will likely be systemd flipping the V2 on switch,
not the kernel, not the user.  Regression reports would thus presumably
be deflected to... those who want this.  Sweet.

	-Mike
