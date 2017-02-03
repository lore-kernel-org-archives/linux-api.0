From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCHSET for-4.11] cgroup: implement cgroup v2 thread mode
Date: Fri, 3 Feb 2017 16:56:00 -0500
Message-ID: <20170203215600.GA13992@mtj.duckdns.org>
References: <20170202200632.13992-1-tj@kernel.org>
 <CALCETrW6Mqj9VLogd0XaLgVAzEqsZ+VnZjN5NROCqr0ssdYaKg@mail.gmail.com>
 <20170202215229.GA27231@htj.duckdns.org>
 <CALCETrXrsejLG4Kuu4PawxWST-8S-LC_8U6_po-ORbZCy03sdw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CALCETrXrsejLG4Kuu4PawxWST-8S-LC_8U6_po-ORbZCy03sdw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@amacapital.net>
Cc: Linux API <linux-api@vger.kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, Paul Turner <pjt@google.com>, Mike Galbraith <efault@gmx.de>, "open list:CONTROL GROUP (CGROUP)" <cgroups@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, kernel-team@fb.com, lvenanci@redhat.com
List-Id: linux-api@vger.kernel.org

Hello,

On Fri, Feb 03, 2017 at 01:10:21PM -0800, Andy Lutomirski wrote:
> Is this flexible enough for the real-world usecases?  For my use case

I can't think of a reason why it won't be.  Capability-wise, nothing
is being lost by the interface.

> (if I actually ported over to this), it would mean that I'd have to
> enable thread mode on the root.  What about letting a given process
> (actually mm, perhaps) live in a cgroup but let the threads be in
> different cgroups without any particular constraints.  Then
> process-wide stuff would be accounted to the cgroup that owns the
> process.

I don't know.  So, then, we basiclly have completely separate trees
for resource domains and threads.  That exactly is what mounting cpu
controller separately does.  It doesn't make sense to put them on the
same hierarchy.  Why?

> > If a controller can't possibly define how internal competition should
> > be handled, which is unlikely - the problem is being consistent and
> > sensible, defining something isn't difficult - the controller can
> > simply error out those cases either on configuration or migration.
> > Again, I'm very doubtful we'll need that but if we ever need that
> > denying specific configurations is the best we can do anyway.
> 
> I'm not sure I follow.
> 
> I'm suggesting something quite simple: let controllers that don't need
> the no-internal-process constraints set a flag so that the constraints
> don't apply if all enabled controllers have the flag set.

Firstly, I think it's better to have the rules as simple and
consistent as possible as long as we don't sacrifice critical
capabilities.

Secondly, all the major resource controllers including cpu would
eventually need resource domain, so there is no real practical upside
to doing so.

Thirdly, if we commit to something like "controller X is not subject
to no-internal-process constraint", that commitment would prevent from
ever adding domain level operations to that controller without
breaking userland visible interface.  All controllers do and have to
support process level operations.  Some controllers can do thread
level operations.  Keeping the latter opt-in doesn't block us from
adding thread mode later on.  Doing it the other way around blocks us
from adding domain level operations later on.

Thanks.

-- 
tejun
