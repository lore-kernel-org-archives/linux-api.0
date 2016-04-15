From: Mike Galbraith <umgwanakikbuti-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCHSET RFC cgroup/for-4.6] cgroup, sched: implement resource
 group and PRIO_RGRP
Date: Fri, 15 Apr 2016 04:42:27 +0200
Message-ID: <1460688147.3847.1.camel@gmail.com>
References: <20160407073547.GA12560@cmpxchg.org>
	 <20160407080833.GK3430@twins.programming.kicks-ass.net>
	 <20160407194555.GI7822@mtj.duckdns.org>
	 <20160407202542.GD3448@twins.programming.kicks-ass.net>
	 <20160408201135.GO24661@htj.duckdns.org>
	 <20160409133917.GV3448@twins.programming.kicks-ass.net>
	 <20160412222915.GT24661@htj.duckdns.org>
	 <1460533381.3780.191.camel@gmail.com>
	 <20160413155952.GU24661@htj.duckdns.org>
	 <1460614057.5100.150.camel@gmail.com>
	 <20160414195748.GK7822@mtj.duckdns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160414195748.GK7822-qYNAdHglDFBN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Thu, 2016-04-14 at 15:57 -0400, Tejun Heo wrote:
> Hello, Mike.
> 
> On Thu, Apr 14, 2016 at 08:07:37AM +0200, Mike Galbraith wrote:
> > Let /foo be an exclusive cpuset containing exclusive subset bar.
> > How can any task acquire set foo affinity if B really really
> > applies?  My box calls me a dummy if I try to create a "proper"
> > home
> > for tasks, one with both no snobby neighbors and proper affinity.
> 
> I'm not sure I quite understand what you're saying.  Are you referring
> to the cpuset.{cpu|mem}_exclusive knobs?

Yes.

	-Mike
