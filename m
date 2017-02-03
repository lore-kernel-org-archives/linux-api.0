From: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Subject: Re: [PATCHSET for-4.11] cgroup: implement cgroup v2 thread mode
Date: Fri, 3 Feb 2017 13:10:21 -0800
Message-ID: <CALCETrXrsejLG4Kuu4PawxWST-8S-LC_8U6_po-ORbZCy03sdw@mail.gmail.com>
References: <20170202200632.13992-1-tj@kernel.org> <CALCETrW6Mqj9VLogd0XaLgVAzEqsZ+VnZjN5NROCqr0ssdYaKg@mail.gmail.com>
 <20170202215229.GA27231@htj.duckdns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170202215229.GA27231-piEFEHQLUPpN0TnZuCh8vA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mike Galbraith <efault-Mmb7MZpHnFY@public.gmane.org>, "open list:CONTROL GROUP (CGROUP)" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, kernel-team-b10kYP2dOMg@public.gmane.org, lvenanci-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Thu, Feb 2, 2017 at 1:52 PM, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> Hello,
>
> On Thu, Feb 02, 2017 at 01:32:19PM -0800, Andy Lutomirski wrote:
>> > * Thread mode is explicitly enabled on a cgroup by writing "enable"
>> >   into "cgroup.threads" file.  The cgroup shouldn't have any child
>> >   cgroups or enabled controllers.
>>
>> Why do you need to manually turn it on?  That is, couldn't it be
>> automatic based on what controllers are enabled?
>
> This came up already but it's not like some controllers are inherently
> thread-only.  Consider CPU, all in-context CPU cycle consumptions are
> tied to the thread; however, we also want to be able to account for
> CPU cycles consumed for, for example, memory reclaim or encryption
> during writeback.
>

Is this flexible enough for the real-world usecases?  For my use case
(if I actually ported over to this), it would mean that I'd have to
enable thread mode on the root.  What about letting a given process
(actually mm, perhaps) live in a cgroup but let the threads be in
different cgroups without any particular constraints.  Then
process-wide stuff would be accounted to the cgroup that owns the
process.

>
>> > * Once enabled, arbitrary sub-hierarchy can be created and threads can
>> >   be put anywhere in the subtree by writing TIDs into "cgroup.threads"
>> >   file.  Process granularity and no-internal-process constraint don't
>> >   apply in a threaded subtree.
>>
>> I'm a bit worried that this conflates two different things.  There's
>> thread support, i.e. allowing individual threads to be placed into
>> cgroups.  There's also more flexible sub-hierarchy support, i.e.
>> relaxing no-internal-process constraints.  For the "cpuacct"
>> controller, for example, both of these make sense.  But what if
>> someone writes a controller (directio, for example, just to make
>> something up) for which thread granularity makes sense but relaxing
>> no-internal-process constraints does not?
>
> If a controller can't possibly define how internal competition should
> be handled, which is unlikely - the problem is being consistent and
> sensible, defining something isn't difficult - the controller can
> simply error out those cases either on configuration or migration.
> Again, I'm very doubtful we'll need that but if we ever need that
> denying specific configurations is the best we can do anyway.
>

I'm not sure I follow.

I'm suggesting something quite simple: let controllers that don't need
the no-internal-process constraints set a flag so that the constraints
don't apply if all enabled controllers have the flag set.

--Andy
