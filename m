From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCHSET RFC cgroup/for-4.6] cgroup, sched: implement resource group and PRIO_RGRP
Date: Fri, 11 Mar 2016 10:41:18 -0500
Message-ID: <1457710888-31182-1-git-send-email-tj@kernel.org>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, a.p.zijlstra-/NLkJaSkS4VmR6Xm/wNWPw@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org
List-Id: linux-api@vger.kernel.org

Hello,

This patchset extends cgroup v2 to support rgroup (resource group) for
in-process hierarchical resource control and implements PRIO_RGRP for
setpriority(2) on top to allow in-process hierarchical CPU cycle
control in a seamless way.

cgroup v1 allowed putting threads of a process in different cgroups
which enabled ad-hoc in-process resource control of some resources.
Unfortunately, this approach was fraught with problems such as
membership ambiguity with per-process resources and lack of isolation
between system management and in-process properties.  For a more
detailed discussion on the subject, please refer to the following
message.

 [1] [RFD] cgroup: thread granularity support for cpu controller

This patchset implements the mechanism outlined in the above message.
The new mechanism is named rgroup (resource group).  When explicitly
designating a non-rgroup cgroup, the term sgroup (system group) is
used.  rgroup has the following properties.

* A rgroup is a cgroup which is invisible on and transparent to the
  system-level cgroupfs interface.

* A rgroup can be created by specifying CLONE_NEWRGRP flag, along with
  CLONE_THREAD, during clone(2).  A new rgroup is created under the
  parent thread's cgroup and the new thread is created in it.

* A rgroup is automatically destroyed when empty.

* A top-level rgroup of a process is a rgroup whose parent cgroup is a
  sgroup.  A process may have multiple top-level rgroups and thus
  multiple rgroup subtrees under the same parent sgroup.

* Unlike sgroups, rgroups are allowed to compete against peer threads.
  Each rgroup behaves equivalent to a sibling task.

* rgroup subtrees are local to the process.  When the process forks or
  execs, its rgroup subtrees are collapsed.

* When a process is migrated to a different cgroup, its rgroup
  subtrees are preserved.

* Subset of controllers available on the parent sgroup are available
  to rgroup subtrees.  Controller management on rgroups is automatic
  and implicit and doesn't interfere with system-level cgroup
  controller management.  If a controller is made unavailable on the
  parent sgroup, it's automatically disabled from child rgroup
  subtrees.

rgroup lays the foundation for other kernel mechanisms to make use of
resource controllers while providing proper isolation between system
management and in-process operations removing the awkward and
layer-violating requirement for coordination between individual
applications and system management.  On top of the rgroup mechanism,
PRIO_RGRP is implemented for {set|get}priority(2).

* PRIO_RGRP can only be used if the target task is already in a
  rgroup.  If setpriority(2) is used and cpu controller is available,
  cpu controller is enabled until the target rgroup is covered and the
  specified nice value is set as the weight of the rgroup.

* The specified nice value has the same meaning as for tasks.  For
  example, a rgroup and a task competing under the same parent would
  behave exactly the same as two tasks.

* For top-level rgroups, PRIO_RGRP follows the same rlimit
  restrictions as PRIO_PROCESS; however, as nested rgroups only
  distribute CPU cycles which are allocated to the process, no
  restriction is applied.

PRIO_RGRP allows in-process hierarchical control of CPU cycles in a
manner which is a straight-forward and minimal extension of existing
task and priority management.

There are still some missing pieces.

* Documentation updates.

* A mechanism that applications can use to publish certain rgroups so
  that external entities can determine which IDs to use to change
  rgroup settings.  I already have interface and implementation design
  mostly pinned down.

* Userland updates such as integrating CLONE_NEWRGRP handling to
  pthread or updating renice(1) to handle resource groups.

I'll attach a test program which demonstrates PRIO_RGRP usage in a
follow up email.

This patchset contains the following 10 patches.

 0001-cgroup-introduce-cgroup_-un-lock.patch
 0002-cgroup-un-inline-cgroup_path-and-friends.patch
 0003-cgroup-introduce-CGRP_MIGRATE_-flags.patch
 0004-signal-make-put_signal_struct-public.patch
 0005-cgroup-fork-add-new_rgrp_cset-p-and-clone_flags-to-c.patch
 0006-cgroup-fork-add-child-and-clone_flags-to-threadgroup.patch
 0007-cgroup-introduce-resource-group.patch
 0008-cgroup-implement-rgroup-control-mask-handling.patch
 0009-cgroup-implement-rgroup-subtree-migration.patch
 0010-cgroup-sched-implement-PRIO_RGRP-for-set-get-priorit.patch

0001-0006 are prepatory patches.
0007-0009 implemnet rgroup support.
0010 implements PRIO_RGRP.

This patchset is on top of

  cgroup/for-4.6 f6d635ad341d ("cgroup: implement cgroup_subsys->implicit_on_dfl")
+ [2] [PATCH 2/2] cgroup, perf_event: make perf_event controller work on cgroup2 hierarchy
+ [3] [PATCHSET REPOST] sched, cgroup: implement cgroup v2 interface for cpu controller

and available in the following git branch.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git review-cgroup2-rgroup

diffstat follows.

 fs/exec.c                     |    8 
 include/linux/cgroup-defs.h   |   72 ++-
 include/linux/cgroup.h        |   60 +--
 include/linux/sched.h         |   31 +
 include/uapi/linux/resource.h |    1 
 include/uapi/linux/sched.h    |    1 
 kernel/cgroup.c               |  828 ++++++++++++++++++++++++++++++++++++++----
 kernel/fork.c                 |   27 -
 kernel/sched/core.c           |   32 +
 kernel/signal.c               |    6 
 kernel/sys.c                  |   11 
 11 files changed, 917 insertions(+), 160 deletions(-)

Thanks.

--
tejun

[1] http://lkml.kernel.org/g/20160105154503.GC5995-qYNAdHglDFBN0TnZuCh8vA@public.gmane.org
[2] http://lkml.kernel.org/g/1456351975-1899-3-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
[3] http://lkml.kernel.org/g/20160105164758.GD5995-qYNAdHglDFBN0TnZuCh8vA@public.gmane.org
