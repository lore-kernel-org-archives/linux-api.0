From: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [Documentation] State of CPU controller in cgroup v2
Date: Sat, 17 Sep 2016 03:47:29 +0200
Message-ID: <20160917014729.GN5016@twins.programming.kicks-ass.net>
References: <20160909225747.GA30105@mtj.duckdns.org>
 <CALCETrUhpPQdyZ-6WRjdB+iLbpGBduRZMWXQtCuS+R7Cq7rygg@mail.gmail.com>
 <20160914200041.GB6832@htj.duckdns.org>
 <CALCETrUA6_noue4kq9JLqr-V_yo7hB+v1Arhg6i6fFn0tyTrpw@mail.gmail.com>
 <20160916075137.GK5012@twins.programming.kicks-ass.net>
 <CALCETrXzrXJmZoFVfAXS1Zf9uNZjibnHizEhwgqdmRvnbJEksw@mail.gmail.com>
 <20160916161951.GH5016@twins.programming.kicks-ass.net>
 <CALCETrXoTfhaDxZJ9_XcFknnniDvrYLY9SATVXj+tK1UdaWw4A@mail.gmail.com>
 <20160916165045.GJ5016@twins.programming.kicks-ass.net>
 <CALCETrVMw4Nd-QZER9qzOzRte5s48WrUaM8ZZzkY_g3B6s+5Ow@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CALCETrVMw4Nd-QZER9qzOzRte5s48WrUaM8ZZzkY_g3B6s+5Ow-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Cc: Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Mike Galbraith <umgwanakikbuti-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, kernel-team-b10kYP2dOMg@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "open list:CONTROL GROUP (CGROUP)" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Fri, Sep 16, 2016 at 11:19:38AM -0700, Andy Lutomirski wrote:
> On Fri, Sep 16, 2016 at 9:50 AM, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> wrote:

> > {1,2} {3,4} {5} seem exclusive, did I miss something? (other than that 5
> > cpu parts are 'rare').
> 
> There's no overlap, so they're logically exclusive, but it avoids
> needing the "cpu_exclusive" parameter. 

I'd need to double check, but I don't think you _need_ that. That's more
for enforcing nobody else steals your CPUs and 'accidentally' creates
overlaps. But if you configure it right, non-overlap should be enough.

That is, generate_sched_domains() only uses cpusets_overlap() which is
cpumask_intersects(). Then again, it is almost 4am, so who knows.

> > So there's a problem with sticking kernel threads (and esp. kthreadd)
> > into !root groups. For example if you place it in a cpuset that doesn't
> > have all cpus, then binding your shiny new kthread to a cpu will fail.
> >
> > You can fix that of course, and we used to do exactly that, but we kept
> > running into 'fun' cases like that.
> 
> Blech.  But may this *should* have that effect.  I'm sick of random
> kernel crap being scheduled on my RT CPUs and on the CPUs that I
> intend to be kept forcibly idle.

Hehe, so ideally those threads don't do anything unless the tasks
running on those CPUs explicitly ask for it. If you find any of the
CPU-bound kernel tasks do work that is unrelated to the tasks running on
that CPU, we should certainly look into it.

Personally I'm not much bothered by idle threads sitting about.
