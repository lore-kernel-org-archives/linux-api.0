From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [Documentation] State of CPU controller in cgroup v2
Date: Tue, 16 Aug 2016 17:59:29 -0400
Message-ID: <20160816215929.GF9516@htj.duckdns.org>
References: <20160805170752.GK2542@mtj.duckdns.org>
 <1470474291.4117.243.camel@gmail.com>
 <20160810220944.GB3085@cmpxchg.org>
 <20160816140738.GW6879@twins.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160816140738.GW6879-ndre7Fmf5hadTX5a5knrm8zTDFooKrT+cvkQGrU6aU0@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Mike Galbraith <umgwanakikbuti-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org
List-Id: linux-api@vger.kernel.org

Hello, Peter.

On Tue, Aug 16, 2016 at 04:07:38PM +0200, Peter Zijlstra wrote:
> On Wed, Aug 10, 2016 at 06:09:44PM -0400, Johannes Weiner wrote:
> 
> > [ That, and a disturbing number of emotional outbursts against
> >   systemd, which has nothing to do with any of this. ]
> 
> Oh, so I'm entirely dreaming this then:
> 
>   https://github.com/systemd/systemd/pull/3905
> 
> Completely unrelated.

We use centos in the fleet and are trying to control resources in base
system which of course requires writeback control and thus cgroup v2.
I'm working to solve the use cases people are facing and systemd is a
piece of the puzzle.  There is no big conspiracy.

As Johannes and Chris already pointed out, systemd is a user of cgroup
v2, a pretty important one at this point.  While I of course care
about it having a proper support for cgroup v2, systemd is just
picking up the changes in cgroup v2.  cgroup v2 design wouldn't be
different without systemd.  We'll just have something else playing its
role in resource management.

> Also, the argument there seems unfair at best, you don't need cpu-v2 for
> buffered write control, you only need memcg and block co-mounted.

( Everything I'm gonna write below has already been extensively
  documented in the posted documentation.  I'm gonna repeat the points
  for completeness but if we're gonna start an actually technical
  discussion, let's please start from the documentation instead of
  jumping off of an one liner and trying to rebuild the entire
  argument each time.

  I'm not sure what you exactly meant by the above sentence and
  assuming that you're saying that there are no new capabilities
  gained by cpu controller being on the v2 hierarchy and thus the cpu
  controller doesn't need to be on cgroup v2?  If I'm mistaken, please
  let me know. )

Just co-mounting isn't enough as it still leaves the problems with
anonymous consumption, different handling of threads belonging to
different cgroups, and whether it's acceptable to always require blkio
to use memory controller.  cgroup v2 is what we got after working
through all these issues.

While it is true that cpu controller doesn't need to be on cgroup v2
for writeback control to work, it misses the point about the larger
design issues identified during writeback control work, which can be
easily applied to the cpu controller - e.g. accounting cpu cycles
spent for packet reception, memory reclaim, IO encryption and so on.

In addition, it is an unnecessary inconvenience for users who want
writeback control to require the complication of mixed v1 and v2
hierarchies when their requirements can be easily served by v2,
especially considering that the only blocked part is trivial changes
to expose cpu controller interface on v2 and that enabling it on v2
doesn't preclude it from being used on a v1 hierarchy if necessary.

Thanks.

-- 
tejun
