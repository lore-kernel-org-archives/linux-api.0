From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCHSET for-4.11] cgroup: implement cgroup v2 thread mode
Date: Thu, 2 Feb 2017 16:52:29 -0500
Message-ID: <20170202215229.GA27231@htj.duckdns.org>
References: <20170202200632.13992-1-tj@kernel.org>
 <CALCETrW6Mqj9VLogd0XaLgVAzEqsZ+VnZjN5NROCqr0ssdYaKg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CALCETrW6Mqj9VLogd0XaLgVAzEqsZ+VnZjN5NROCqr0ssdYaKg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Cc: Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mike Galbraith <efault-Mmb7MZpHnFY@public.gmane.org>, "open list:CONTROL GROUP (CGROUP)" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, kernel-team-b10kYP2dOMg@public.gmane.org, lvenanci-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Hello,

On Thu, Feb 02, 2017 at 01:32:19PM -0800, Andy Lutomirski wrote:
> > * Thread mode is explicitly enabled on a cgroup by writing "enable"
> >   into "cgroup.threads" file.  The cgroup shouldn't have any child
> >   cgroups or enabled controllers.
> 
> Why do you need to manually turn it on?  That is, couldn't it be
> automatic based on what controllers are enabled?

This came up already but it's not like some controllers are inherently
thread-only.  Consider CPU, all in-context CPU cycle consumptions are
tied to the thread; however, we also want to be able to account for
CPU cycles consumed for, for example, memory reclaim or encryption
during writeback.

I played with an interface where thread mode is enabled automatically
upto the common ancestor of the threads but not only was it
complicated to implement but also the eventual behavior was very
confusing as the resource domain can change without any active actions
from the user.  I think keeping things simple is the right choice
here.

> > * Once enabled, arbitrary sub-hierarchy can be created and threads can
> >   be put anywhere in the subtree by writing TIDs into "cgroup.threads"
> >   file.  Process granularity and no-internal-process constraint don't
> >   apply in a threaded subtree.
> 
> I'm a bit worried that this conflates two different things.  There's
> thread support, i.e. allowing individual threads to be placed into
> cgroups.  There's also more flexible sub-hierarchy support, i.e.
> relaxing no-internal-process constraints.  For the "cpuacct"
> controller, for example, both of these make sense.  But what if
> someone writes a controller (directio, for example, just to make
> something up) for which thread granularity makes sense but relaxing
> no-internal-process constraints does not?

If a controller can't possibly define how internal competition should
be handled, which is unlikely - the problem is being consistent and
sensible, defining something isn't difficult - the controller can
simply error out those cases either on configuration or migration.
Again, I'm very doubtful we'll need that but if we ever need that
denying specific configurations is the best we can do anyway.

Thanks.

-- 
tejun
