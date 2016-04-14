From: Mike Galbraith <umgwanakikbuti@gmail.com>
Subject: Re: [PATCHSET RFC cgroup/for-4.6] cgroup, sched: implement resource
 group and PRIO_RGRP
Date: Thu, 14 Apr 2016 08:07:37 +0200
Message-ID: <1460614057.5100.150.camel@gmail.com>
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
	 <20160413155952.GU24661@htj.duckdns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160413155952.GU24661@htj.duckdns.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Johannes Weiner <hannes@cmpxchg.org>, torvalds@linux-foundation.org, akpm@linux-foundation.org, mingo@redhat.com, lizefan@huawei.com, pjt@google.com, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-api@vger.kernel.org, kernel-team@fb.com
List-Id: linux-api@vger.kernel.org

On Wed, 2016-04-13 at 11:59 -0400, Tejun Heo wrote:
> Hello, Mike.
> 
> On Wed, Apr 13, 2016 at 09:43:01AM +0200, Mike Galbraith wrote:
> > > The cost is part aesthetical and part practical.  While less
> > > elegant
> > > than tree of uniform objects, it seems a stretch to call internal
> > > /
> > > leaf node distinction broken especially given that the model is
> > > natural to some controllers.
> > 
> > That justifies prohibiting proper usages of three controllers, cpu,
> > cpuacct and cpuset?
> 
> Neither cpuacct or cpuset loses any capability from the constraint as
> there is no difference between tasks being in an internal cgroup or a
> leaf cgroup nested under it.  The only practical impact is that we
> lose the ability to let internal tasks compete against sibling cgroups
> for proportional control.

I'm not getting it.

A.  entity = task[s] | cgroup[s]
B.  entity = task[s] ^ cgroup[s]

A I get, B I don't, but you seem to be saying B, else we get the task
competes with sibling cgroup business.

Let /foo be an exclusive cpuset containing exclusive subset bar.  How can any task acquire set foo affinity if B really really applies?  My box calls me a dummy if I try to create a "proper" home for tasks, one with both no snobby neighbors and proper affinity.

	-Mike
