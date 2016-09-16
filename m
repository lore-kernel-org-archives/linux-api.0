From: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [Documentation] State of CPU controller in cgroup v2
Date: Fri, 16 Sep 2016 09:51:37 +0200
Message-ID: <20160916075137.GK5012@twins.programming.kicks-ass.net>
References: <20160831173251.GY12660@htj.duckdns.org>
 <CALCETrUKOJZS+=QDPyQD+vxXpwyjoj4+Crg6wU7Xk8rP4prYkA@mail.gmail.com>
 <20160831210754.GZ12660@htj.duckdns.org>
 <CALCETrXj2Z=-GMaWV_EpCvw_8C3t1vc=D53Ff2wdvo=At8ZF1Q@mail.gmail.com>
 <20160903220526.GA20784@mtj.duckdns.org>
 <CALCETrVcAjFWLQ1arjSP-g=4jRY_J7G-j9JJHrvTDgOnxApYPw@mail.gmail.com>
 <20160909225747.GA30105@mtj.duckdns.org>
 <CALCETrUhpPQdyZ-6WRjdB+iLbpGBduRZMWXQtCuS+R7Cq7rygg@mail.gmail.com>
 <20160914200041.GB6832@htj.duckdns.org>
 <CALCETrUA6_noue4kq9JLqr-V_yo7hB+v1Arhg6i6fFn0tyTrpw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CALCETrUA6_noue4kq9JLqr-V_yo7hB+v1Arhg6i6fFn0tyTrpw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Mike Galbraith <umgwanakikbuti-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, kernel-team-b10kYP2dOMg@public.gmane.org, "open list:CONTROL GROUP (CGROUP)" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thu, Sep 15, 2016 at 01:08:07PM -0700, Andy Lutomirski wrote:
> BTW, Mike keeps mentioning exclusive cgroups as problematic with the
> no-internal-tasks constraints.  Do exclusive cgroups still exist in
> cgroup2?  Could we perhaps just remove that capability entirely?  I've
> never understood what problem exlusive cpusets and such solve that
> can't be more comprehensibly solved by just assigning the cpusets the
> normal inclusive way.

Without exclusive sets we cannot split the sched_domain structure.
Which leads to not being able to actually partition things. That would
break DL for one.
