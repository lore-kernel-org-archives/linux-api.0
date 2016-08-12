From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [Documentation] State of CPU controller in cgroup v2
Date: Fri, 12 Aug 2016 18:17:42 -0400
Message-ID: <20160812221742.GA24736@cmpxchg.org>
References: <20160805170752.GK2542@mtj.duckdns.org>
 <1470474291.4117.243.camel@gmail.com>
 <20160810220944.GB3085@cmpxchg.org>
 <1470896706.4116.146.camel@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1470896706.4116.146.camel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mike Galbraith <umgwanakikbuti-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Thu, Aug 11, 2016 at 08:25:06AM +0200, Mike Galbraith wrote:
> On Wed, 2016-08-10 at 18:09 -0400, Johannes Weiner wrote:
> > The complete lack of cohesiveness between v1 controllers prevents us
> > from implementing even the most fundamental resource control that
> > cloud fleets like Google's and Facebook's are facing, such as
> > controlling buffered IO; attributing CPU cycles spent receiving
> > packets, reclaiming memory in kswapd, encrypting the disk; attributing
> > swap IO etc. That's why cgroup2 runs a tighter ship when it comes to
> > the controllers: to make something much bigger work.
> 
> Where is the gun wielding thug forcing people to place tasks where v2
> now explicitly forbids them?

The problems with supporting this are well-documented. Please see R-2
in Documentation/cgroup-v2.txt.

> > Agreeing on something - in this case a common controller model - is
> > necessarily going to take away some flexibility from how you approach
> > a problem. What matters is whether the problem can still be solved.
> 
> What annoys me about this more than the seemingly gratuitous breakage
> is that the decision is passed to third parties who have nothing to
> lose, and have done quite a bit of breaking lately.

Mike, there is no connection between what you are quoting and what you
are replying to here. We cannot have a technical discussion when you
enter it with your mind fully made up, repeat the same inflammatory
talking points over and over - some of them trivially false, some a
gross misrepresentation of what we have been trying to do - and are
completely unwilling to even entertain the idea that there might be
problems outside of the one-controller-scope you are looking at.

But to address your point: there is no 'breakage' here. Or in your
words: there is no gun wielding thug forcing people to upgrade to
v2. If v1 does everything your specific setup needs, nobody forces you
to upgrade. We are fairly confident that the majority of users *will*
upgrade, simply because v2 solves so many basic resource control
problems that v1 is inherently incapable of solving. There is a
positive incentive, but we are trying not to create negative ones.

And even if you run a systemd distribution, and systemd switches to
v2, it's trivially easy to pry the CPU controller from its hands and
maintain your setup exactly as-is using the current CPU controller.

This is really not a technical argument.

> > This argument that cgroup2 is not backward compatible is laughable.
> 
> Fine, you're entitled to your sense of humor.  I have one to, I find it
> laughable that threaded applications can only sit there like a lump of
> mud simply because they share more than applications written as a
> gaggle of tasks.  "Threads are like.. so yesterday, the future belongs
> to the process" tickles my funny-bone.  Whatever, to each his own.

Who are you quoting here? This is such a grotesque misrepresentation
of what we have been saying and implementing, it's not even funny.

In reality, the rgroup extension for setpriority() was directly based
on your and PeterZ's feedback regarding thread control. Except that,
unlike cgroup1's approach to threads, which might work in some setups
but suffers immensely from the global nature of the vfs interface once
you have to cooperate with other applications and system management*,
rgroup was proposed as a much more generic and robust interface to do
hierarchical resource control from inside the application.

* This doesn't have to be systemd, btw. We have used cgroups to
  isolate system services, maintenance jobs, cron jobs etc. from our
  applications way before systemd, and it's been a pita to coordinate
  the system managing applications and the applications managing its
  workers using the same globally scoped vfs interface.

> > > I mentioned a real world case of a thread pool servicing customer
> > > accounts by doing something quite sane: hop into an account (cgroup),
> > > do work therein, send bean count off to the $$ department, wash, rinse
> > > repeat.  That's real world users making real world cash registers go ka
> > > -ching so real world people can pay their real world bills.
> > 
> > Sure, but you're implying that this is the only way to run this real
> > world cash register.
> 
> I implied no such thing.  Of course it can be done differently, all
> they have to do is rip out these archaic thread thingies.
>
> Apologies for dripping sarcasm all over your monitor, but this annoys
> me far more that it should any casual user of cgroups.  Perhaps I
> shouldn't care about the users (suse customers) who will step in this
> eventually, but I do.

https://yourlogicalfallacyis.com/black-or-white
https://yourlogicalfallacyis.com/strawman
https://yourlogicalfallacyis.com/appeal-to-emotion

Can you please try to stay objective?

> > > As with the thread pool, process granularity makes it impossible for
> > > any threaded application affinity to be managed via cpusets, such as
> > > say stuffing realtime critical threads into a shielded cpuset, mundane
> > > threads into another.  There are any number of affinity usages that
> > > will break.
> > 
> > Ditto. It's not obvious why this needs to be the cgroup interface and
> > couldn't instead be solved with extending sched_setaffinity() - again
> > weighing that against the power of the common controller model that
> > could be preserved this way.
> 
> Wow.  Well sure, anything that becomes broken can be replaced by
> something else.  Hell, people can just stop using cgroups entirely, and
> the way issues become non-issues with the wave of a hand makes me
> suspect that some users are going to be forced to do just that.

We are not the ones doing the handwaving. We have reacted with code
and with repeated attempts to restart a grounded technical discussion
on this issue, and were met time and again with polemics, categorical
dismissal of the problems we are facing in the cloud, and a flatout
refusal to even consider a different approach to resource control.

It's great that cgroup1 works for some of your customers, and they are
free to keep using it, but there is only so much you can build with a
handful of loose shoestrings, and we are badly hitting the design
limitations of that model. We have tried to work in your direction and
proposed interfaces/processes to support the different things people
are (ab)using cgroup1 for right now, but at some point you have to
acknowledge that cgroup2 is the result of problems we have run into
with cgroup1 and that, consequently, not everything from cgroup1 can
be retained as-is. Only when that happens can we properly discuss
cgroup2's current design choices and whether it could be done better.

Ignoring the real problems that cgroup2 is solving will not remove the
demand for it. It only squanders your chance to help shape it in the
interest of the particular group of users you feel most obligated to.
