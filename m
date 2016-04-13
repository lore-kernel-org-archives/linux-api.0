From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCHSET RFC cgroup/for-4.6] cgroup, sched: implement resource
 group and PRIO_RGRP
Date: Wed, 13 Apr 2016 11:59:52 -0400
Message-ID: <20160413155952.GU24661@htj.duckdns.org>
References: <20160406155830.GI24661@htj.duckdns.org>
 <20160407064549.GH3430@twins.programming.kicks-ass.net>
 <20160407073547.GA12560@cmpxchg.org>
 <20160407080833.GK3430@twins.programming.kicks-ass.net>
 <20160407194555.GI7822@mtj.duckdns.org>
 <20160407202542.GD3448@twins.programming.kicks-ass.net>
 <20160408201135.GO24661@htj.duckdns.org>
 <20160409133917.GV3448@twins.programming.kicks-ass.net>
 <20160412222915.GT24661@htj.duckdns.org>
 <1460533381.3780.191.camel@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1460533381.3780.191.camel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Galbraith <umgwanakikbuti@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Johannes Weiner <hannes@cmpxchg.org>, torvalds@linux-foundation.org, akpm@linux-foundation.org, mingo@redhat.com, lizefan@huawei.com, pjt@google.com, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-api@vger.kernel.org, kernel-team@fb.com
List-Id: linux-api@vger.kernel.org

Hello, Mike.

On Wed, Apr 13, 2016 at 09:43:01AM +0200, Mike Galbraith wrote:
> > The cost is part aesthetical and part practical.  While less elegant
> > than tree of uniform objects, it seems a stretch to call internal /
> > leaf node distinction broken especially given that the model is
> > natural to some controllers.
> 
> That justifies prohibiting proper usages of three controllers, cpu,
> cpuacct and cpuset?

Neither cpuacct or cpuset loses any capability from the constraint as
there is no difference between tasks being in an internal cgroup or a
leaf cgroup nested under it.  The only practical impact is that we
lose the ability to let internal tasks compete against sibling cgroups
for proportional control.

> > The practical cost is loss of the ability to let leaf entities compete
> > against groups.  However, we can't evaluate how important such
> > capability is without actual use-cases.  If there are important ones,
> > please bring them up, so that we can examine the actual requirements
> > and try to find a good trade-off to support them.
> 
> Hm, I though Google did that, and I know I mentioned another gigabuck
> sized outfit.  Whatever, ob trade-off..

Are you saying that you're aware that google or another big outfit is
making active use of internal tasks competing against sibling cgroups
for proportional CPU distribution?  If so, can you please be more
specific?

> Another cpuset example is something I was asked to look into recently. 

First of all, as mentioned above, cpuset isn't affected at all in
practical terms.  Besides, for a very specialized cpuset setup, the
cpuset configuration might not have anything to do with the resource
domains other controllers use and it might make sense to keep cpuset
on a separate hierarchy.

> > I understand that CPU controller getting constrained due to other
> > controllers can feel frustrating; however, the constraint is there to
> > solve practical problems which hopefully are being explained in this
> > conversation.  If there is a better trade-off, we can easily get rid
> > of it and move on, but such decision can only be made considering all
> > the relevant factors.  If you can think of a better solution, let's
> > please discuss it.
> 
> None here.  Any artificial restriction placed on controllers will
> render same broken in one way or another that will matter to someone
> somewhere.  Making something less than it was will do that.

The specifics of gains and losses are what I've been trying to clarify
in this thread.  Hopefully, what we can gain from sharing common
resource domains is clear by now.  The practical cost is loss of the
capability to let internal tasks compete against sibling cgroups for
proportional control.  However, to determine the weight of this cost,
we have to know which use-cases call for it.

Thanks.

-- 
tejun
