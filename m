From: Mike Galbraith <umgwanakikbuti-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [Documentation] State of CPU controller in cgroup v2
Date: Sat, 10 Sep 2016 10:54:57 +0200
Message-ID: <1473497697.3857.161.camel@gmail.com>
References: <20160820155659.GA16906@mtj.duckdns.org>
         <CALCETrUWn1ux-ZRJoMjFCuP1aQrPOo3oTPD7k-ojsaov29NsRw@mail.gmail.com>
         <20160829222048.GH28713@mtj.duckdns.org>
         <CALCETrUEygWrJbG25wSfG3zMG_+TNeP8+gAkcbh4_=ZNWHQCkw@mail.gmail.com>
         <20160831173251.GY12660@htj.duckdns.org>
         <CALCETrUKOJZS+=QDPyQD+vxXpwyjoj4+Crg6wU7Xk8rP4prYkA@mail.gmail.com>
         <20160831210754.GZ12660@htj.duckdns.org>
         <CALCETrXj2Z=-GMaWV_EpCvw_8C3t1vc=D53Ff2wdvo=At8ZF1Q@mail.gmail.com>
         <20160903220526.GA20784@mtj.duckdns.org>
         <CALCETrVcAjFWLQ1arjSP-g=4jRY_J7G-j9JJHrvTDgOnxApYPw@mail.gmail.com>
         <20160909225747.GA30105@mtj.duckdns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160909225747.GA30105-qYNAdHglDFBN0TnZuCh8vA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Cc: Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, kernel-team-b10kYP2dOMg@public.gmane.org, "open list:CONTROL GROUP (CGROUP)" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Fri, 2016-09-09 at 18:57 -0400, Tejun Heo wrote:

> But, whatever, let's go there: Given the arguments that I laid out for
> the no-internal-tasks rule, how does the problem seem fixable through
> relaxing the constraint?

Well, for one thing, cpusets would cease to leak CPUs.  With the no
-internal-tasks constraint, no task can acquire affinity of exclusive
set A if set B is an exclusive subset thereof, as there is one and only
one spot where the affinity of set A exists: in the forbidden set A.

Relaxing no-internal-tasks would fix that, but without also relaxing
the process-only rule, cpusets would remain useless for the purpose for
which it was created.  After all, it doesn't do much good to use the
one and only dynamic partitioning tool to partition a box if you cannot
subsequently place your tasks/threads properly therein.

> What people do now with cgroup inside an application is extremely
> limited.  Because there is no proper support for it, each use case has
> to craft up a dedicated custom setup which is all but guaranteed to be
> incompatible with what someone else would come up for another
> application.  Everybody is in "this is mine, I control the entire
> system" mindset, which is fine for those specific setups but
> deterimental to making it widely available and useful.

IMO, the problem with that making it available to the huddled masses
bit is that it is a completely unrealistic fantasy.  Can hordes of
programs really autonomously carve up a single set of resources?  I do
not believe they can.  The system agent cannot autonomously do so
either.  Intimate knowledge of local requirements is not optional, it
is a prerequisite to sound decision making.  You have to have a well
defined need before it makes any sense to turn these things on, they
are not free, and impact is global.

	-Mike
