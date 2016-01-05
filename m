From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [RFD] cgroup: thread granularity support for cpu controller
Date: Tue, 5 Jan 2016 10:45:03 -0500
Message-ID: <20160105154503.GC5995@mtj.duckdns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Cc: cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, kernel-team <kernel-team-b10kYP2dOMg@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Hello,

This email is to restart the discussion around the thread granularity
support for cgroup cpu controller, which got lost around the following
message.

  http://thread.gmane.org/gmane.linux.kernel/2021959/focus=14454

While the previous discussion didn't reach a conclusion, it uncovered
the points of disagreements.  As the thread became too difficult to
follow, let's summarize and revisit each technical point.

cgroup v1 started out thread-granular and later grew process-granular
operations.  Thread-granular operations have some issues, which will
be partially discussed in this message, and cgroup v2 is
process-granular.  As a result, hierarchical resource distribution
among the threads of the same process isn't covered by the cgroup v2
interface proper.

For some controllers, especially cpu, in-process hierarchical resource
distribution is important.  This message discusses the in-process
support for cpu controller - where it belongs, how it should look like
and why.  cpuset can also benefit from thread granularity; however,
the situation around cpuset is murkier, so let's stay away from it for
now.  cpuset's issues are more about how to deal with CPU availability
in general than cgroup behavior.


1. Goal

The goal of thread granularity support for cpu controller can be
summarized as

  Hierarchically organize threads of a process and control CPU cycle
  distribution along the hierarchy.


2. Background and Stuff to Consider

2-1. In-process Hierarchy in v1

In the v1 interface, there is no distinction between system-wide and
in-process cgroup organizations.  Everything happens through the same
cgroupfs and in-process organization is entangled with everything
else.  Either the cgroup manager is directly involved or the
in-process sub-hierarchy is delegated to the process itself.  While
seemingly simple, the interlocking of the two different domains causes
a number of issues.

The role of each thread in a process is information private to the
process in the sense that there is no reliable way of finding out from
outside without the process itself explicitly making the information
available.  Consequently, if an external manager is involved in the
management of in-process organization, each such process has to
communicate with it.  It's one thing to make system management
software depend on userland facility, something completely different
to make normal applications depend on an external userland manager for
operations as intimate as thread management.  It will make the feature
a lot more cumbersome and less useful.

While sub-hierarchy delegation doesn't seem to create direct external
dependencies, cgroupfs doesn't provide enough facilities for such
delegations to work.  For example, there is no way for a thread to
access its own subhierarchy atomically.  It has to read a couple of
files to construct the path but may be moved to a different cgroup at
any moment making it access the wrong cgroup.  Also, it isn't clear
who is responsible for in-process organization.  System management and
normal applications still need to coordinate.

Both cases suffer from the kernel failing to provide proper separation
between system management and usual programming interfaces.  This
entangles system management and normal applications making in-process
resource control awkward and useless.


2-2. Ownership of In-process Organization

In-process hierarchies can't be implemented without active
participation from the target application for two reasons.  First, a
given thread's role is a piece of information private to the
application.  Second, as a new thread is put into the parent's
cgroups, organization is inherently tied to how threads are created.

Note the contrast against system-level management.  The only thing
necessary for cgroup support at system-level is starting each
application in the right cgroups.  No cooperation is necessary.

Lacking clear ownership of in-process organization leads to other
issues too.  For example, an application can't be sure that the
in-process organization it created remains unchanged.  Threads may
have been moved around.  Some may not even be in the process
sub-hierarchy at all.  On v1, such accidents can easily happen among
processes sharing the same credentials.

Also, the hierarchy itself could have changed.  A cgroup may have been
removed, renamed or replaced behind the process's back.  This makes
in-process organization fragile without adding any gains to the goal -
in-process hierarchical resource distribution.


2-3. Management and Application Interfaces

In cgroup, the basic operations require strict coordinations among its
users and there are oddities such as name collisions between
sub-cgroup names and interface files, a notification mechanism which
involves forking or the need for explicit cleanup.  cgroup is much
more of a system management interface than a general application
interface.

This also shows in scalability.  cgroup assumes that organization
operations are infrequent and the synchronization scheme is geared
toward minimizing hot path overheads.  This is perfectly acceptable
for a system management mechanism but a non-starter for a widely used
application interface.

For example, stemming from the architecture, migration is a fairly
heavy operation.  This doesn't matter for system management and is
even desirable because it allows for aggressive optimization of the
hot paths; however, hundreds of threads using it in parallel from
userspace could bog down the entire machine.

While some have been using in-process hierarchies, it works only
because the use cases are self-contained and limited.  If the kernel
wants to expose general hierarchical in-process resource distribution
to normal applications, we must evaluate the requirements necessary to
achieve the target functionality and make active trade-off to build a
robust interface with the right balance.  It also makes sense to take
a conservative approach by default as we can always loosen up but not
tighten down.


2-4. Cost of Membership Dynamism

There is an intrinsic trade-off between how dynamic something is and
how expensive or difficult synchronizing around it is - dynamism
doesn't come free.  This applies well to cgroup as the cost and
complexity of tracking a resource or a task's cgroup membership
depends strongly on how dynamic that relationship is.

At the system level, cgroup membership is dynamic in a way which
aggressively trades migration overhead for lower hot path overhead.
This isn't an issue because when a sysadmin or system management
software modifies cgroup membership too frequently, it's easy to tell
them to not do that; however, if cgroup membership migration is
exposed as a general programming interface, such an approach is no
longer viable.

If supporting that level of dynamism is something which brings
essential benefits, we can make that choice and pay in terms of added
complexity and overhead in hot paths; however, this definitely isn't
something we want to be committed to by simply being dragged into it
for historical reasons.


3. Design Choices

There are several important abstract design choices which are
independent from implementation details.  As it is easy to miss them
in a deluge of details, let's discuss the larger design points and
then work our way to a specific implementation.


3-1. Exclusive Ownership of In-process Organization

As discussed, the target process must be an active participant in
thread organization and depends on the organization not changing
behind its back.  Given those, it is logical to make in-process
organization owned exclusively by each process.  It gets rid of all
ambiguities and the accompanying failure modes without losing core
functionalities.


3-2. Static Grouping

Changing cgroup membership of a thread is all but guaranteed to be
more expensive than scheduling an existing thread which is already in
the target cgroup.  This implies that there always is a better way to
implement execution of a chunk of work in a remote cgroup than moving
a thread into the cgroup.  In addition, establishing in-process
hierarchical resource distribution is a significant step and it makes
sense to start as restricted as possible while achieving the core
functionalities.

It is logical to start with a model where in-process cgroup membership
is determined on thread creation and remains immutable.  This avoids
exposing membership dynamism to normal applications, which will be
expensive in terms of both complexity and hot path overhead.  It also
clearly signals that assignment of cgroup membership is an operation
at least as expensive as thread creation and naturally excludes usages
where cgroup membership is changed very frequently.


3-3. Extending the Thread Control Interfaces

cgroup has a pseudo filesystem interface at system level, which is
great for interface flexibility; however, as an interface exposed to
normal applications, it is unusual and awkward.  Any operation is a
multi-step process and it isn't difficult to create a sub-cgroup whose
name collides with one of the interface files.

In-process hierarchical resource distribution shouldn't stand out like
a sore thumb.  If it can be implemented as a natural extension of the
existing patterns and mechanisms, that is the right direction to take.
As in-process structure follows clone(2) history, it has natural
similarities to how processes are organized - e.g. the traditional
process hierarchy or namespace.  On the resource control side, the
existing rlimit facility has inherent similarities.

One possible upside of exposing cgroupfs to normal applications is
reuse of existing cgroup libraries; however, the part which can be
reused is mostly encapsulation of multistep filesystem operations into
a more programmable interface.  It doesn't make any sense to cling
onto the partial compatibility when the main benefit can be replaced
by the kernel providing a more programmable interface.

There's no reason to deviate from existing programmable interfaces for
in-process hierarchical resource distribution.  It can be implemented
as a natural extension of existing facilities and it should be.


4. Interface Proposal

4-1. In-process Organization

In-process hierarchy is separate from the system-level cgroup
hierarchy.  It is invisible from cgroupfs interface and transparent
for all operations - e.g. when a process is migrated to a different
cgroup, the whole in-process hierarchy is atomically moved as-is.

By default, a new thread is put into the same in-process group as the
parent.  If explicitly indicated, e.g. CLONE_NEWRESGROUP, a new group
which is a child of the parent's group is created and the thread is
put into it.  The group is identified by the TID of the thread and
stays around while there are sub-groups or threads in it.

For in-process use, TID based identification is enough; however, it
can be useful to allow modifying resource settings from outside.  To
allow identifying each group from outside, a new prctl(2) operation
can be introduced, e.g. PR_SET_RESGROUP_NAME, which can be called from
any thread and sets the name of the group that the calling thread
belongs to.  The mapping between group IDs and names can be published
in the process's /proc.


5-2. Resource Control Settings

Resource control settings can be implemented as a natural extension of
the rlimit facility.  get/setrlimit(2) and prlimit(2) provide all
that's necessary to read and modify resource settings by the process
itself and from outside.  The only interface change needed is adding
the matching RLMIT_ resource tags.

Thanks.

-- 
tejun
