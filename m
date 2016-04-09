From: Mike Galbraith <umgwanakikbuti-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCHSET RFC cgroup/for-4.6] cgroup, sched: implement resource
 group and PRIO_RGRP
Date: Sat, 09 Apr 2016 08:16:43 +0200
Message-ID: <1460182603.3765.155.camel@gmail.com>
References: <1457710888-31182-1-git-send-email-tj@kernel.org>
	 <20160314113013.GM6344@twins.programming.kicks-ass.net>
	 <20160406155830.GI24661@htj.duckdns.org>
	 <20160407064549.GH3430@twins.programming.kicks-ass.net>
	 <20160407073547.GA12560@cmpxchg.org>
	 <20160407080833.GK3430@twins.programming.kicks-ass.net>
	 <20160407194555.GI7822@mtj.duckdns.org>
	 <20160407202542.GD3448@twins.programming.kicks-ass.net>
	 <20160408201135.GO24661@htj.duckdns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160408201135.GO24661-piEFEHQLUPpN0TnZuCh8vA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Fri, 2016-04-08 at 16:11 -0400, Tejun Heo wrote:

> > That's just plain broken... That is not how a proportional weight based
> > hierarchical controller works.
> 
> That's a strong statement.  When the hierarchy is composed of
> equivalent objects as in CPU, not distinguishing internal and leaf
> nodes would be a more natural way to organize; however...

You almost said it yourself, you want to make the natural organization
of cpu, cpuacct and cpuset controllers a prohibited organization. 
 There is no "however..." that can possibly justify that.  It's akin to
mandating: henceforth "horse" shall be spelled "cow", riders thereof
shall teach their "cow" the proper enunciation of "moo".  It's silly.

Like it or not, these controllers have thread encoded in their DNA,
it's an integral part of what they are, and how real users in the real
world use them.  No rationalization will change that cold hard fact.

Make an "Aunt Tilly" button for those incapable of comprehending the
complexities if you will, but please don't make cgroups so rigid and
idiot proof that only idiots (hi system thing) can use it.

	-Mike

 
