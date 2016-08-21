From: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Subject: Re: [Documentation] State of CPU controller in cgroup v2
Date: Sat, 20 Aug 2016 22:34:14 -0700
Message-ID: <1471757654.2354.97.camel@HansenPartnership.com>
References: <20160805170752.GK2542@mtj.duckdns.org>
         <CALCETrXvLNeds+ugZ8j3eD1Zg1RZYJSAET3Kguz5G2vqSLFCwQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CALCETrXvLNeds+ugZ8j3eD1Zg1RZYJSAET3Kguz5G2vqSLFCwQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Mike Galbraith <umgwanakikbuti-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, kernel-team-b10kYP2dOMg@public.gmane.org, "open list:CONTROL GROUP (CGROUP)" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Wed, 2016-08-17 at 13:18 -0700, Andy Lutomirski wrote:
> On Aug 5, 2016 7:07 PM, "Tejun Heo" <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
[...]
> > 2. Disagreements and Arguments
> > 
> > There have been several lengthy discussion threads [3][4] on LKML
> > around the structural constraints of cgroup v2.  The two that 
> > affect the CPU controller are process granularity and no internal 
> > process constraint.  Both arise primarily from the need for common 
> > resource domain definition across different resources.
> > 
> > The common resource domain is a powerful concept in cgroup v2 that
> > allows controllers to make basic assumptions about the structural
> > organization of processes and controllers inside the cgroup 
> > hierarchy, and thus solve problems spanning multiple types of 
> > resources.  The prime example for this is page cache writeback: 
> > dirty page cache is regulated through throttling buffered writers 
> > based on memory availability, and initiating batched write outs to 
> > the disk based on IO capacity.  Tracking and controlling writeback 
> > inside a cgroup thus requires the direct cooperation of the memory 
> > and the IO controller.
> > 
> > This easily extends to other areas, such as CPU cycles consumed 
> > while performing memory reclaim or IO encryption.
> > 
> > 
> > 2-1. Contentious Restrictions
> > 
> > For controllers of different resources to work together, they must
> > agree on a common organization.  This uniform model across 
> > controllers imposes two contentious restrictions on the CPU 
> > controller: process granularity and the no-internal-process
> > constraint.
> > 
> > 
> >   2-1-1. Process Granularity
> > 
> >   For memory, because an address space is shared between all
> > threads
> >   of a process, the terminal consumer is a process, not a thread.
> >   Separating the threads of a single process into different memory
> >   control domains doesn't make semantical sense.  cgroup v2 ensures
> >   that all controller can agree on the same organization by
> > requiring
> >   that threads of the same process belong to the same cgroup.
> 
> I haven't followed all of the history here, but it seems to me that
> this argument is less accurate than it appears.  Linux, for better or
> for worse, has somewhat orthogonal concepts of thread groups
> (processes), mms, and file tables.  An mm has VMAs in it, and VMAs 
> can reference things (files, etc) that hold resources.  (Two mms can
> share resources by mapping the same thing or using fork().)  File 
> tables hold files, and files can use resources.  Both of these are, 
> at best, moderately good approximations of what actually holds 
> resources. Meanwhile, threads (tasks) do syscalls, take page faults, 
> *allocate* resources, etc.
> 
> So I think it's not really true to say that the "terminal consumer" 
> of anything is a process, not a thread.
> 
> While it's certainly easier to think about assigning processes to
> cgroups, and I certainly agree that, in the common case, it's the
> right thing to do, I don't see why requiring it is a good idea.  Can
> we turn this around: what actually goes wrong if cgroup v2 were to
> allow assigning individual threads if a user specifically requests
> it?

A similar point from a different consumer: from the unprivileged
containers point of view, I'm interested in a thread based interface as
well.  The principle utility of unprivileged containers is to allow
applications that wish to to use container properties (effectively to
become self-containerising).  Some that use the producer/consumer model
do use process pools (apache springs to mind instantly) but some use
thread pools.  It is useful to the latter to preserve the concept of a
thread as being the entity inhabiting the cgroup (but only where the
granularity of the cgroup permits threads to participate) so we can
easily modify them to be self containerising without forcing them to
switch back from a thread pool model to a process pool model.

I can see that process based is conceptually easier in v2 because you
begin with a process tree, but it would really be a pity to lose the
thread based controls we have now and permanently lose the ability to
create more as we find uses for them.  I can't really see how improving
"common resource domain" is a good tradeoff for this.

James
