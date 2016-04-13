From: Mike Galbraith <umgwanakikbuti-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCHSET RFC cgroup/for-4.6] cgroup, sched: implement resource
 group and PRIO_RGRP
Date: Wed, 13 Apr 2016 21:15:34 +0200
Message-ID: <1460574934.3775.77.camel@gmail.com>
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
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160413155952.GU24661-piEFEHQLUPpN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Wed, 2016-04-13 at 11:59 -0400, Tejun Heo wrote:

> Are you saying that you're aware that google or another big outfit is
> making active use of internal tasks competing against sibling cgroups
> for proportional CPU distribution?  If so, can you please be more
> specific?

What I'm aware of is a big outfit that moves thread pool workers in/out
of a large number of cpu/cpuacct cgroups.  What all a worker thread may
spawn in a cgroup, or find already there upon arrival and thus compete
with I do not know. 

I'm baffled by why anyone would care which entity competes with which
other entity.  An entity is an entity is an entity.

	-Mike
