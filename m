From: Mike Galbraith <umgwanakikbuti-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [Documentation] State of CPU controller in cgroup v2
Date: Thu, 11 Aug 2016 08:25:06 +0200
Message-ID: <1470896706.4116.146.camel@gmail.com>
References: <20160805170752.GK2542@mtj.duckdns.org>
	 <1470474291.4117.243.camel@gmail.com> <20160810220944.GB3085@cmpxchg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160810220944.GB3085-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Wed, 2016-08-10 at 18:09 -0400, Johannes Weiner wrote:
> The complete lack of cohesiveness between v1 controllers prevents us
> from implementing even the most fundamental resource control that
> cloud fleets like Google's and Facebook's are facing, such as
> controlling buffered IO; attributing CPU cycles spent receiving
> packets, reclaiming memory in kswapd, encrypting the disk; attributing
> swap IO etc. That's why cgroup2 runs a tighter ship when it comes to
> the controllers: to make something much bigger work.

Where is the gun wielding thug forcing people to place tasks where v2
now explicitly forbids them?

> Agreeing on something - in this case a common controller model - is
> necessarily going to take away some flexibility from how you approach
> a problem. What matters is whether the problem can still be solved.

What annoys me about this more than the seemingly gratuitous breakage
is that the decision is passed to third parties who have nothing to
lose, and have done quite a bit of breaking lately.

> This argument that cgroup2 is not backward compatible is laughable.

Fine, you're entitled to your sense of humor.  I have one to, I find it
laughable that threaded applications can only sit there like a lump of
mud simply because they share more than applications written as a
gaggle of tasks.  "Threads are like.. so yesterday, the future belongs
to the process" tickles my funny-bone.  Whatever, to each his own.

...

> Lastly, again - and this was the whole point of this document - the
> changes in cgroup2 are not gratuitous. They are driven by fundamental
> resource control problems faced by more comprehensive applications of
> cgroup. On the other hand, the opposition here mainly seems to be the
> inconvenience of switching some specialized setups from a v1-oriented
> way of solving a problem to a v2-oriented way.
> 
> [ That, and a disturbing number of emotional outbursts against
>   systemd, which has nothing to do with any of this. ]
> 
> It's a really myopic line of argument.

And I think the myopia is on the other side of my monitor, whatever. 
 
> That being said, let's go through your points:
> 
> > Priority and affinity are not process wide attributes, never have
> > been, but you're insisting that so they must become for the sake of
> > progress.
> 
> Not really.
> 
> It's just questionable whether the cgroup interface is the best way to
> manipulate these attributes, or whether existing interfaces like
> setpriority() and sched_setaffinity() should be extended to manipulate
> groups, like the rgroup proposal does. The problems of using the
> cgroup interface for this are extensively documented, including in the
> email you were replying to.
> 
> > I mentioned a real world case of a thread pool servicing customer
> > accounts by doing something quite sane: hop into an account (cgroup),
> > do work therein, send bean count off to the $$ department, wash, rinse
> > repeat.  That's real world users making real world cash registers go ka
> > -ching so real world people can pay their real world bills.
> 
> Sure, but you're implying that this is the only way to run this real
> world cash register.

I implied no such thing.  Of course it can be done differently, all
they have to do is rip out these archaic thread thingies.

Apologies for dripping sarcasm all over your monitor, but this annoys
me far more that it should any casual user of cgroups.  Perhaps I
shouldn't care about the users (suse customers) who will step in this
eventually, but I do.

> I'm not going down the rabbit hole again of arguing against an
> incomplete case description. Scale matters. Number of workers
> matter. Amount of work each thread does matters to evaluate
> transaction overhead. Task migration is an expensive operation etc.
> 
> > I also mentioned breakage to cpusets: given exclusive set A and
> > exclusive subset B therein, there is one and only one spot where
> > affinity A exists... at the to be forbidden junction of A and B.
> 
> Again, a means to an end rather than a goal

I don't believe I described a means to an end, I believe I described
affinity bits going missing.

>  - and a particularly
> suspicious one at that: why would a cgroup need to tell its *siblings*
> which cpus/nodes in cannot use? In the hierarchical model, it's
> clearly the task of the ancestor to allocate the resources downward.
> 
> More details would be needed to properly discuss what we are trying to
> accomplish here.
> 
> > As with the thread pool, process granularity makes it impossible for
> > any threaded application affinity to be managed via cpusets, such as
> > say stuffing realtime critical threads into a shielded cpuset, mundane
> > threads into another.  There are any number of affinity usages that
> > will break.
> 
> Ditto. It's not obvious why this needs to be the cgroup interface and
> couldn't instead be solved with extending sched_setaffinity() - again
> weighing that against the power of the common controller model that
> could be preserved this way.

Wow.  Well sure, anything that becomes broken can be replaced by
something else.  Hell, people can just stop using cgroups entirely, and
the way issues become non-issues with the wave of a hand makes me
suspect that some users are going to be forced to do just that.

	-Mike
