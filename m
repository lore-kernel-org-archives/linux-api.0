From: Mike Galbraith <umgwanakikbuti-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [Documentation] State of CPU controller in cgroup v2
Date: Mon, 22 Aug 2016 12:12:46 +0200
Message-ID: <1471860766.4110.103.camel@gmail.com>
References: <20160805170752.GK2542@mtj.duckdns.org>
         <CALCETrXvLNeds+ugZ8j3eD1Zg1RZYJSAET3Kguz5G2vqSLFCwQ@mail.gmail.com>
         <20160820155659.GA16906@mtj.duckdns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160820155659.GA16906-qYNAdHglDFBN0TnZuCh8vA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Cc: Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, kernel-team-b10kYP2dOMg@public.gmane.org, "open list:CONTROL GROUP (CGROUP)" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Sat, 2016-08-20 at 11:56 -0400, Tejun Heo wrote:

> > >   there are other reasons to enforce process granularity.  One
> > >   important one is isolating system-level management operations from
> > >   in-process application operations.  The cgroup interface, being a
> > >   virtual filesystem, is very unfit for multiple independent
> > >   operations taking place at the same time as most operations have to
> > >   be multi-step and there is no way to synchronize multiple accessors.
> > >   See also [5] Documentation/cgroup-v2.txt, "R-2. Thread Granularity"
> > 
> > I don't buy this argument at all.  System-level code is likely to
> > assign single process *trees*, which are a different beast entirely.
> > I.e. you fork, move the child into a cgroup, and that child and its
> > children stay in that cgroup.  I don't see how the thread/process
> > distinction matters.
> 
> Good point on the multi-process issue, this is something which nagged
> me a bit while working on rgroup, although I have to point out that
> the issue here is one of not going far enough rather than the approach
> being wrong.  There are limitations to scoping it to individual
> processes but that doesn't negate the underlying problem or the
> usefulness of in-process control.
> 
> For system-level and process-level operations to not step on each
> other's toes, they need to agree on the granularity boundary -
> system-level should be able to treat an application hierarchy as a
> single unit.  A possible solution is allowing rgroup hirearchies to
> span across process boundaries and implementing cgroup migration
> operations which treat such hierarchies as a single unit.  I'm not yet
> sure whether the boundary should be at program groups or rgroups.

Why is it not viable to predicate contentious lowest common denominator
restrictions upon the set of enabled controllers?  If only thread
granularity controllers are enabled, from that point onward, v2
restrictions cease to make any sense, thus could be lifted, leaving
nobody cast adrift in a leaky v1 lifeboat when v2 sets sail.  Or?

	-Mike
