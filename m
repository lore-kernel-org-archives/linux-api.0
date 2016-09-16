From: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Subject: Re: [Documentation] State of CPU controller in cgroup v2
Date: Fri, 16 Sep 2016 11:19:38 -0700
Message-ID: <CALCETrVMw4Nd-QZER9qzOzRte5s48WrUaM8ZZzkY_g3B6s+5Ow@mail.gmail.com>
References: <20160903220526.GA20784@mtj.duckdns.org> <CALCETrVcAjFWLQ1arjSP-g=4jRY_J7G-j9JJHrvTDgOnxApYPw@mail.gmail.com>
 <20160909225747.GA30105@mtj.duckdns.org> <CALCETrUhpPQdyZ-6WRjdB+iLbpGBduRZMWXQtCuS+R7Cq7rygg@mail.gmail.com>
 <20160914200041.GB6832@htj.duckdns.org> <CALCETrUA6_noue4kq9JLqr-V_yo7hB+v1Arhg6i6fFn0tyTrpw@mail.gmail.com>
 <20160916075137.GK5012@twins.programming.kicks-ass.net> <CALCETrXzrXJmZoFVfAXS1Zf9uNZjibnHizEhwgqdmRvnbJEksw@mail.gmail.com>
 <20160916161951.GH5016@twins.programming.kicks-ass.net> <CALCETrXoTfhaDxZJ9_XcFknnniDvrYLY9SATVXj+tK1UdaWw4A@mail.gmail.com>
 <20160916165045.GJ5016@twins.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160916165045.GJ5016-ndre7Fmf5hadTX5a5knrm8zTDFooKrT+cvkQGrU6aU0@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Mike Galbraith <umgwanakikbuti-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, kernel-team-b10kYP2dOMg@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "open list:CONTROL GROUP (CGROUP)" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Fri, Sep 16, 2016 at 9:50 AM, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> wrote:
> On Fri, Sep 16, 2016 at 09:29:06AM -0700, Andy Lutomirski wrote:
>
>> > SCHED_DEADLINE, its a 'Global'-EDF like scheduler that doesn't support
>> > CPU affinities (because that doesn't make sense). The only way to
>> > restrict it is to partition.
>> >
>> > 'Global' because you can partition it. If you reduce your system to
>> > single CPU partitions you'll reduce to P-EDF.
>> >
>> > (The same is true of SCHED_FIFO, that's a 'Global'-FIFO on the same
>> > partition scheme, it however does support sched_affinity, but using it
>> > gives 'interesting' schedulability results -- call it a historic
>> > accident).
>>
>> Hmm, I didn't realize that the deadline scheduler was global.  But
>> ISTM requiring the use of "exclusive" to get this working is
>> unfortunate.  What if a user wants two separate partitions, one using
>> CPUs 1 and 2 and the other using CPUs 3 and 4 (with 5 reserved for
>> non-RT stuff)?
>
> {1,2} {3,4} {5} seem exclusive, did I miss something? (other than that 5
> cpu parts are 'rare').

There's no overlap, so they're logically exclusive, but it avoids
needing the "cpu_exclusive" parameter.  It always seemed confusing to
me that a setting on a child cgroup would strictly remove a resource
from the parent.  (To be clear: I don't have any particularly strong
objection to cpu_exclusive.  It just always seemed like a bit of a
hack that mostly duplicated what you could get by just setting the
cpusets appropriately throughout the hierarchy.)

>> > Note that related, but differently, we have the isolcpus boot parameter
>> > which creates single CPU partitions for all listed CPUs and gives the
>> > rest to the root cpuset. Ideally we'd kill this option given its a boot
>> > time setting (for something which is trivially to do at runtime).
>> >
>> > But this cannot be done, because that would mean we'd have to start with
>> > a !0 cpuset layout:
>> >
>> >                 '/'
>> >                 load_balance=0
>> >             /              \
>> >         'system'        'isolated'
>> >         cpus=~isolcpus  cpus=isolcpus
>> >                         load_balance=0
>> >
>> > And start with _everything_ in the /system group (inclding default IRQ
>> > affinities).
>> >
>> > Of course, that will break everything cgroup :-(
>> >
>>
>> I would actually *much* prefer this over the status quo.  I'm tired of
>> my crappy, partially-working script that sits there and creates
>> exactly this configuration (minus the isolcpus part because I actually
>> want migration to work) on boot.  (Actually, it could have two
>> automatic cgroups: /kernel and /init -- init and UMH would go in init
>> and kernel threads and such would go in /kernel.  Userspace would be
>> able to request that a different cgroup be used for newly-created
>> kernel threads.)
>
> So there's a problem with sticking kernel threads (and esp. kthreadd)
> into !root groups. For example if you place it in a cpuset that doesn't
> have all cpus, then binding your shiny new kthread to a cpu will fail.
>
> You can fix that of course, and we used to do exactly that, but we kept
> running into 'fun' cases like that.

Blech.  But may this *should* have that effect.  I'm sick of random
kernel crap being scheduled on my RT CPUs and on the CPUs that I
intend to be kept forcibly idle.

>
> The unbound workqueue stuff is totally arbitrary borkage though, that
> can be made to work just fine, TJ didn't like it for some reason which I
> really cannot remember.
>
> Also, UMH?

User mode helper.  Fortunately most users are gone now, but it still exists.
