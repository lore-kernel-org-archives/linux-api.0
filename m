From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCHSET RFC cgroup/for-4.6] cgroup, sched: implement resource
 group and PRIO_RGRP
Date: Thu, 7 Apr 2016 15:45:55 -0400
Message-ID: <20160407194555.GI7822@mtj.duckdns.org>
References: <1457710888-31182-1-git-send-email-tj@kernel.org>
 <20160314113013.GM6344@twins.programming.kicks-ass.net>
 <20160406155830.GI24661@htj.duckdns.org>
 <20160407064549.GH3430@twins.programming.kicks-ass.net>
 <20160407073547.GA12560@cmpxchg.org>
 <20160407080833.GK3430@twins.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160407080833.GK3430-ndre7Fmf5hadTX5a5knrm8zTDFooKrT+cvkQGrU6aU0@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org
List-Id: linux-api@vger.kernel.org

Hello, Peter.

On Thu, Apr 07, 2016 at 10:08:33AM +0200, Peter Zijlstra wrote:
> On Thu, Apr 07, 2016 at 03:35:47AM -0400, Johannes Weiner wrote:
> > So it was a nice cleanup for the memory controller and I believe the
> > IO controller as well. I'd be curious how it'd be a problem for CPU?
> 
> The full hierarchy took years to make work and is fully ingrained with
> how the thing words, changing it isn't going to be nice or easy.
> 
> So sure, go with a lowest common denominator, instead of fixing shit,
> yay for progress :/

It's easy to get fixated on what each subsystem can do and develop
towards different directions siloed in each subsystem.  That's what
we've had for quite a while in cgroup.  Expectedly, this sends off
controllers towards different directions.  Direct competion between
tasks and child cgroups was one of the main sources of balkanization.

The balkanization was no coincidence either.  Tasks and cgroups are
different types of entities and don't have the same control knobs or
follow the same lifetime rules.  For absolute limits, it isn't clear
how much of the parent's resources should be distributed to internal
children as opposed to child cgroups.  People end up depending on
specific implementation details and proposing one-off hacks and
interface additions.

Proportional weights aren't much better either.  CPU has internal
mapping between nice values and shares and treat them equally, which
can get confusing as the configured weights behave differently
depending on how many threads are in the parent cgroup which often is
opaque and can't be controlled from outside.  Widely diverging from
CPU's behavior, IO grouped all internal tasks into an internal leaf
node and used to assign a fixed weight to it.

Now, you might think that none of it matters and each subsystem
treating cgroup hierarchy as arbitrary and orthogonal collections of
bean counters is fine; however, that makes it impossible to account
for and control operations which span different types of resources.
This prevented us from implementing resource control over frigging
buffered writes, making the whole IO control thing a joke.  While CPU
currently doesn't directly tie into it, that is only because CPU
cycles spent during writeback isn't yet properly accounted.

The structural constraints and resulting consistency don't just
subtract from the abilities of each controller.  It establishes a
common base, the shared resource domains and consistent behaviors on
top of them, that further capabilities can be built upon, capabilities
as fundamental as comprehensive resource control over buffered
writeback.

It can be convenient to have subsystem-specific raw bean counters.  If
that's what the use case calls for, individual controllers can easily
be moved to a separate hierarchy although it would naturally lose the
capabilities coming from cooperating over shared resource domains.
However, please understand that there are a lot of use cases where
comprehensive and consistent resource accounting and control over all
major resources is useful and necessary.

Thanks.

-- 
tejun
