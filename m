From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCHSET RFC cgroup/for-4.6] cgroup, sched: implement resource
 group and PRIO_RGRP
Date: Wed, 6 Apr 2016 11:58:30 -0400
Message-ID: <20160406155830.GI24661@htj.duckdns.org>
References: <1457710888-31182-1-git-send-email-tj@kernel.org>
 <20160314113013.GM6344@twins.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160314113013.GM6344-ndre7Fmf5hadTX5a5knrm8zTDFooKrT+cvkQGrU6aU0@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org
List-Id: linux-api@vger.kernel.org

Hello, Peter.

Sorry about the delay.

On Mon, Mar 14, 2016 at 12:30:13PM +0100, Peter Zijlstra wrote:
> On Fri, Mar 11, 2016 at 10:41:18AM -0500, Tejun Heo wrote:
> > * A rgroup is a cgroup which is invisible on and transparent to the
> >   system-level cgroupfs interface.
> > 
> > * A rgroup can be created by specifying CLONE_NEWRGRP flag, along with
> >   CLONE_THREAD, during clone(2).  A new rgroup is created under the
> >   parent thread's cgroup and the new thread is created in it.
> 
> This seems overly restrictive. As you well know there's people moving
> threads about after creation.

Will get to this later.

> Also, with this interface the whole thing cannot be used until your
> libc's pthread_create() has been patched to allow use of this new flag.

This isn't difficult to change but is this a problem in the long term?
Once added, this is gonna be a permanent part of API and I think we
better get it right than quick.  If this is a concern, we can go for a
setsid(2) style syscall so that users can have an easier access to it.

> > * A rgroup is automatically destroyed when empty.
> 
> Except for Zombies it appears..

Zombies do hold onto its rgroup but at that point the rgroup is
draining refs and can't be populated again.  The same state as rmdir'd
cgroup with zombies.

> > * A top-level rgroup of a process is a rgroup whose parent cgroup is a
> >   sgroup.  A process may have multiple top-level rgroups and thus
> >   multiple rgroup subtrees under the same parent sgroup.
> > 
> > * Unlike sgroups, rgroups are allowed to compete against peer threads.
> >   Each rgroup behaves equivalent to a sibling task.
> > 
> > * rgroup subtrees are local to the process.  When the process forks or
> >   execs, its rgroup subtrees are collapsed.
> > 
> > * When a process is migrated to a different cgroup, its rgroup
> >   subtrees are preserved.
> 
> This all makes it impossible to say put a single thread outside of the
> hierarchy forced upon it by the process. Like putting a RT thread in an
> isolated group on the side.
> 
> Which is a rather common thing to do.

I don't think the mentioned RT case is problematic.  Depending on the
desired outcome,

1. If the admin doesn't want the program to be able to meddle with the
   cpu resource control at all, it can just disable the cpu controller
   in subtree_control (this is tied to the parent control now but will
   be moved to the associated cgroup itself).  The application will
   create rgroup hierarchy but won't be able to use CPU resource
   control and the admin would be able to treat all threads as if they
   don't have rgroups at all.

2. If the admin still wants to allow the application to retain CPU
   resource control, unless the said program is actively getting in
   the way, the admin can set the limits the way it wants along the
   hierarchy down to the specific thread.

Note that #1 can be done after-the-fact.  The admin can revoke CPU
controller access anytime.  For example, assuming the following
hierarchy (cX is a cgroup, rX is a rgroup, NNN are threads).

   cA - 234
      + r235 - 235
             + 236

If the process 234 configured CPU resource control in a specific way
and the admin wants to override, the admin can simply do "echo -cpu >
cA.subtree_control".  Afterwards, as far as CPU resource control is
concerned, all threads will behave as if there are no rgroups at all
and the admin can tweak the settings of individual threads using the
usual scheduler systemcalls.

> > rgroup lays the foundation for other kernel mechanisms to make use of
> > resource controllers while providing proper isolation between system
> > management and in-process operations removing the awkward and
> > layer-violating requirement for coordination between individual
> > applications and system management.  On top of the rgroup mechanism,
> > PRIO_RGRP is implemented for {set|get}priority(2).
> > 
> > * PRIO_RGRP can only be used if the target task is already in a
> >   rgroup.  If setpriority(2) is used and cpu controller is available,
> >   cpu controller is enabled until the target rgroup is covered and the
> >   specified nice value is set as the weight of the rgroup.
> > 
> > * The specified nice value has the same meaning as for tasks.  For
> >   example, a rgroup and a task competing under the same parent would
> >   behave exactly the same as two tasks.
> > 
> > * For top-level rgroups, PRIO_RGRP follows the same rlimit
> >   restrictions as PRIO_PROCESS; however, as nested rgroups only
> >   distribute CPU cycles which are allocated to the process, no
> >   restriction is applied.
> 
> While this appears neat, I doubt it will remain so in the face of this:
> 
> > * A mechanism that applications can use to publish certain rgroups so
> >   that external entities can determine which IDs to use to change
> >   rgroup settings.  I already have interface and implementation design
> >   mostly pinned down.
> 
> So you need some new fangled way to set/query all the other possible
> cgroup parameters supported, and then suddenly you have one that has two
> possible interface. That's way ugly.

So, the above response is a bit confusing because publishing rgroups
doesn't require setting or querying all other possible cgroup
parameters.

Regarding the need to add separeate interface for each control knob
for rgroups,

1. There aren't many knobs which make sense for in-process control to
   begin with.

2. As shown in this patchset's modifiction to setpriority(2), for
   stuff which makes sense, we're likely to already have constructs
   which already deal with the issue (it is a needed capability with
   or without cgroup).  The right way forward is seamlessly extending
   existing interfaces.

3. If there is no exactly matching interface, we want to add them for
   both groups and threads in a way which is consistent with other
   syscalls which deal with related issues, especially for the
   scheduler.

Just in case, here's a more concerete explanation about publishing
rgroups.  The only addition needed for external access is a way to
determine which ID maps to which rgroup - a proc file listing (rgroup
name, ID) pairs.

Let's say the program creates the following internal hierarchy.

 cgroup - service0 - highpri_workers
                   + lowpri_workers
        + service1 - highpri_workers
                   + lowpri_workers

The rgroups are published by a member thread performing, for example,
prctl(PR_SET_RGROUP_NAME, "service0.highpri_workers").  The only thing
it does is pinning the pid so that it stays associated with the rgroup
and publishes it in proc as follows.

 # cat /proc/234/rgroups
 service0.highpri_workers 240
 service0.lowpri_workers 241
 service1.highpri_workers 248
 service1.lowpri_workers 249

>From tooling side, renice(2) can be extended to understand rgroups so
that something like the following works.

 # renice -n -10 -r 234:service1.highpri_workers

Thanks.

-- 
tejun
