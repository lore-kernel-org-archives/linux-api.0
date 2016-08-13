From: Mike Galbraith <umgwanakikbuti-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [Documentation] State of CPU controller in cgroup v2
Date: Sat, 13 Aug 2016 07:08:33 +0200
Message-ID: <1471064913.4047.85.camel@gmail.com>
References: <20160805170752.GK2542@mtj.duckdns.org>
	 <1470474291.4117.243.camel@gmail.com> <20160810220944.GB3085@cmpxchg.org>
	 <1470896706.4116.146.camel@gmail.com> <20160812221742.GA24736@cmpxchg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160812221742.GA24736-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Fri, 2016-08-12 at 18:17 -0400, Johannes Weiner wrote:

> > > This argument that cgroup2 is not backward compatible is laughable.
> > 
> > Fine, you're entitled to your sense of humor.  I have one to, I find it
> > laughable that threaded applications can only sit there like a lump of
> > mud simply because they share more than applications written as a
> > gaggle of tasks.  "Threads are like.. so yesterday, the future belongs
> > to the process" tickles my funny-bone.  Whatever, to each his own.
> 
> Who are you quoting here? This is such a grotesque misrepresentation
> of what we have been saying and implementing, it's not even funny.

Agreed, it's not funny to me either.  Excluding threaded applications
from doing.. anything.. implies to me that either someone thinks same
do not need resource management facilities due to some magical property
of threading itself, or someone doesn't realize that an application
thread is a task, ie one and the same things which can be doing one and
the same job.  No matter how I turn it, what I see is nonsense.

> https://yourlogicalfallacyis.com/black-or-white
> https://yourlogicalfallacyis.com/strawman
> https://yourlogicalfallacyis.com/appeal-to-emotion

Nope, plain ole sarcasm, an expression of shock and awe.

> It's great that cgroup1 works for some of your customers, and they are
> free to keep using it.

If no third party can flush my customers investment down the toilet, I
can cease to care.  Please don't CC me in future, you're unlikely to
convince me that v2 is remotely sane, nor do you need to.  Lucky you. 
 
	-Mike
