From: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCHSET RFC cgroup/for-4.6] cgroup, sched: implement resource
 group and PRIO_RGRP
Date: Sat, 9 Apr 2016 18:02:28 +0200
Message-ID: <20160409160228.GW3448@twins.programming.kicks-ass.net>
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
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160408201135.GO24661-piEFEHQLUPpN0TnZuCh8vA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Fri, Apr 08, 2016 at 04:11:35PM -0400, Tejun Heo wrote:
> > Yes, I'm familiar with the problem; but simply mandating leaf only nodes
> > is not a solution, for the very simple fact that there are tasks in the
> > root cgroup that cannot ever be moved out, so we _must_ be able to deal
> > with !leaf nodes containing tasks.
> 
> As Johannes already pointed out, the root cgroup has always been
> special.

The root of the tree isn't special except for 2 properties.

 - it _is_ a root; iow, it doesn't have any incoming edges.
   This also means it doesn't have a parent; nor can have a weight,
   since that is an edge propery, not a node property.

 - it always exists; for without a root there is no tree.

Making it _more_ special is silly.

> > Maybe, but so far I've only heard people complain this v2 thing didn't
> > work for them, and as far as I can see the whole v2 model is internally
> > inconsistent and impossible to implement.
> 
> I suppose we live in different bubbles.  Can you please elaborate
> which parts of cgroup v2 model are internally inconsistent and
> impossible to implement?  I'd be happy to rectify the situation.

The fact that we have to deal with tasks in the root cgroup while not
allowing tasks in any other node is internally inconsistent.

If I can deal with tasks in one node (root) I can equally deal with
tasks in any other node in exactly the same manner.

Making it different is actually _more_ code.
