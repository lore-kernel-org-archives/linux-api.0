From: Mike Galbraith <umgwanakikbuti-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [Documentation] State of CPU controller in cgroup v2
Date: Fri, 30 Sep 2016 16:53:10 +0200
Message-ID: <1475247190.3963.134.camel@gmail.com>
References: <20160829222048.GH28713@mtj.duckdns.org>
         <CALCETrUEygWrJbG25wSfG3zMG_+TNeP8+gAkcbh4_=ZNWHQCkw@mail.gmail.com>
         <20160831173251.GY12660@htj.duckdns.org>
         <CALCETrUKOJZS+=QDPyQD+vxXpwyjoj4+Crg6wU7Xk8rP4prYkA@mail.gmail.com>
         <20160831210754.GZ12660@htj.duckdns.org>
         <CALCETrXj2Z=-GMaWV_EpCvw_8C3t1vc=D53Ff2wdvo=At8ZF1Q@mail.gmail.com>
         <20160903220526.GA20784@mtj.duckdns.org>
         <CALCETrVcAjFWLQ1arjSP-g=4jRY_J7G-j9JJHrvTDgOnxApYPw@mail.gmail.com>
         <20160909225747.GA30105@mtj.duckdns.org>
         <1473502137.3857.218.camel@gmail.com>
         <20160930090603.GD29207@mtj.duckdns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160930090603.GD29207-qYNAdHglDFBN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, kernel-team-b10kYP2dOMg@public.gmane.org, "open list:CONTROL GROUP (CGROUP)" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Fri, 2016-09-30 at 11:06 +0200, Tejun Heo wrote:
> Hello, Mike.
> 
> On Sat, Sep 10, 2016 at 12:08:57PM +0200, Mike Galbraith wrote:
> > On Fri, 2016-09-09 at 18:57 -0400, Tejun Heo wrote:
> > > > > As for your example, who performs the cgroup setup and configuration,
> > > > > the application itself or an external entity?  If an external entity,
> > > > > how does it know which thread is what?
> > > > 
> > > > In my case, it would be a little script that reads a config file that
> > > > knows all kinds of internal information about the application and its
> > > > threads.
> > > 
> > > I see.  One-of-a-kind custom setup.  This is a completely valid usage;
> > > however, please also recognize that it's an extremely specific one
> > > which is niche by definition.
> > 
> > This is the same pigeon hole you placed Google into.  So Google, my
> > (also decidedly non-petite) users, and now Andy are all sharing the one
> > of a kind extremely specific niche.. it's becoming a tad crowded.
> 
> I wasn't trying to say that these use cases are small in numbers when
> added up, but that they're all isolated in their own small silos.

These use cases exist, and are perfectly valid use cases.  That is sum
and total of what is relevant.

> Facebook has a lot of these usages too but they're almost all mutually
> exculsive.  Making workloads share machines or even adding resource
> conrol for base system operations afterwards is extremely difficult.

The cases I have in mind are not difficult to deal with, as you don't
have to worry about collisions.

> There are cases these adhoc approaches make sense but insisting that
> this is all there is to resource control is short-sighted.

1. I never insisted any such thing.
2. Please stop pigeon-holing.

The usage cases in question are no more ad hoc than any other usage,
they are all "for this", none are globally applicable.  What they are
is power users utilizing the intimate knowledge that is both required
and in the possession of power users who are in fact using controllers
precisely as said controllers were designed to be used.

No, these usages do not belong in an "adhoc" (aka disposable refuse) pi
geon-hole.  I choose to ignore the one you stuffed me into.
	-Mike
