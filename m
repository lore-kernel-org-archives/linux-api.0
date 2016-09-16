From: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Subject: Re: [Documentation] State of CPU controller in cgroup v2
Date: Fri, 16 Sep 2016 09:29:06 -0700
Message-ID: <CALCETrXoTfhaDxZJ9_XcFknnniDvrYLY9SATVXj+tK1UdaWw4A@mail.gmail.com>
References: <20160831210754.GZ12660@htj.duckdns.org> <CALCETrXj2Z=-GMaWV_EpCvw_8C3t1vc=D53Ff2wdvo=At8ZF1Q@mail.gmail.com>
 <20160903220526.GA20784@mtj.duckdns.org> <CALCETrVcAjFWLQ1arjSP-g=4jRY_J7G-j9JJHrvTDgOnxApYPw@mail.gmail.com>
 <20160909225747.GA30105@mtj.duckdns.org> <CALCETrUhpPQdyZ-6WRjdB+iLbpGBduRZMWXQtCuS+R7Cq7rygg@mail.gmail.com>
 <20160914200041.GB6832@htj.duckdns.org> <CALCETrUA6_noue4kq9JLqr-V_yo7hB+v1Arhg6i6fFn0tyTrpw@mail.gmail.com>
 <20160916075137.GK5012@twins.programming.kicks-ass.net> <CALCETrXzrXJmZoFVfAXS1Zf9uNZjibnHizEhwgqdmRvnbJEksw@mail.gmail.com>
 <20160916161951.GH5016@twins.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160916161951.GH5016-ndre7Fmf5hadTX5a5knrm8zTDFooKrT+cvkQGrU6aU0@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Mike Galbraith <umgwanakikbuti-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, kernel-team-b10kYP2dOMg@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "open list:CONTROL GROUP (CGROUP)" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Fri, Sep 16, 2016 at 9:19 AM, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> wrote:
> On Fri, Sep 16, 2016 at 08:12:58AM -0700, Andy Lutomirski wrote:
>> On Sep 16, 2016 12:51 AM, "Peter Zijlstra" <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> wrote:
>> >
>> > On Thu, Sep 15, 2016 at 01:08:07PM -0700, Andy Lutomirski wrote:
>> > > BTW, Mike keeps mentioning exclusive cgroups as problematic with the
>> > > no-internal-tasks constraints.  Do exclusive cgroups still exist in
>> > > cgroup2?  Could we perhaps just remove that capability entirely?  I've
>> > > never understood what problem exlusive cpusets and such solve that
>> > > can't be more comprehensibly solved by just assigning the cpusets the
>> > > normal inclusive way.
>> >
>> > Without exclusive sets we cannot split the sched_domain structure.
>> > Which leads to not being able to actually partition things. That would
>> > break DL for one.
>>
>> Can you sketch out a toy example?
>
> [ Also see Documentation/cgroup-v1/cpusets.txt section 1.7 ]
>
>
>   mkdir /cpuset
>
>   mount -t cgroup -o cpuset none /cpuset
>
>   mkdir /cpuset/A
>   mkdir /cpuset/B
>
>   cat /sys/devices/system/node/node0/cpulist > /cpuset/A/cpuset.cpus
>   echo 0 > /cpuset/A/cpuset.mems
>
>   cat /sys/devices/system/node/node1/cpulist > /cpuset/B/cpuset.cpus
>   echo 1 > /cpuset/B/cpuset.mems
>
>   # move all movable tasks into A
>   cat /cpuset/tasks | while read task; do echo $task > /cpuset/A/tasks ; done
>
>   # kill machine wide load-balancing
>   echo 0 > /cpuset/cpuset.sched_load_balance
>
>   # now place 'special' tasks in B
>
>
> This partitions the scheduler into two, one for each node.
>
> Hereafter no task will be moved from one node to another. The
> load-balancer is split in two, one balances in A one balances in B
> nothing crosses. (It is important that A.cpus and B.cpus do not
> intersect.)
>
> Ideally no task would remain in the root group, back in the day we could
> actually do this (with exception of the cpu bound kernel threads), but
> this has significantly regressed :-(
> (still hate the workqueue affinity interface)

I wonder if we could address this by creating (automatically at boot
or when the cpuset controller is enabled or whatever) a
/cpuset/random_kernel_shit cgroup and have all of the unmoveable tasks
land there?

>
> As is, tasks that are left in the root group get balanced within
> whatever domain they ended up in.
>
>> And what's DL?
>
> SCHED_DEADLINE, its a 'Global'-EDF like scheduler that doesn't support
> CPU affinities (because that doesn't make sense). The only way to
> restrict it is to partition.
>
> 'Global' because you can partition it. If you reduce your system to
> single CPU partitions you'll reduce to P-EDF.
>
> (The same is true of SCHED_FIFO, that's a 'Global'-FIFO on the same
> partition scheme, it however does support sched_affinity, but using it
> gives 'interesting' schedulability results -- call it a historic
> accident).

Hmm, I didn't realize that the deadline scheduler was global.  But
ISTM requiring the use of "exclusive" to get this working is
unfortunate.  What if a user wants two separate partitions, one using
CPUs 1 and 2 and the other using CPUs 3 and 4 (with 5 reserved for
non-RT stuff)?  Shouldn't we be able to have a cgroup for each of the
DL partitions and do something to tell the deadline scheduler "here is
your domain"?

>
>
> Note that related, but differently, we have the isolcpus boot parameter
> which creates single CPU partitions for all listed CPUs and gives the
> rest to the root cpuset. Ideally we'd kill this option given its a boot
> time setting (for something which is trivially to do at runtime).
>
> But this cannot be done, because that would mean we'd have to start with
> a !0 cpuset layout:
>
>                 '/'
>                 load_balance=0
>             /              \
>         'system'        'isolated'
>         cpus=~isolcpus  cpus=isolcpus
>                         load_balance=0
>
> And start with _everything_ in the /system group (inclding default IRQ
> affinities).
>
> Of course, that will break everything cgroup :-(
>

I would actually *much* prefer this over the status quo.  I'm tired of
my crappy, partially-working script that sits there and creates
exactly this configuration (minus the isolcpus part because I actually
want migration to work) on boot.  (Actually, it could have two
automatic cgroups: /kernel and /init -- init and UMH would go in init
and kernel threads and such would go in /kernel.  Userspace would be
able to request that a different cgroup be used for newly-created
kernel threads.)

Heck, even systemd would probably prefer this.  Then it could cleanly
expose a "slice" or whatever it's called for random kernel shit and at
least you could configure it meaningfully.
