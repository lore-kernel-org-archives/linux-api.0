From: Aditya Kali <adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 0/5] RFC: CGroup Namespaces
Date: Thu, 17 Jul 2014 12:52:06 -0700
Message-ID: <1405626731-12220-1-git-send-email-adityakali@google.com>
References: <adityakali-cgroupns>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <adityakali-cgroupns>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Background
  Cgroups and Namespaces are used together to create =E2=80=9Cvirtual=E2=
=80=9D
  containers that isolates the host environment from the processes
  running in container. But since cgroups themselves are not
  =E2=80=9Cvirtualized=E2=80=9D, the task is always able to see global =
cgroups view
  through cgroupfs mount and via /proc/self/cgroup file.

  $ cat /proc/self/cgroup=20
  0:cpuset,cpu,cpuacct,memory,devices,freezer,hugetlb:/batchjobs/c_job_=
id1

  This exposure of cgroup names to the processes running inside a
  container results in some problems:
  (1) The container names are typically host-container-management-agent
      (systemd, docker/libcontainer, etc.) data and leaking its name (o=
r
      leaking the hierarchy) reveals too much information about the hos=
t
      system.
  (2) It makes the container migration across machines (CRIU) more
      difficult as the container names need to be unique across the
      machines in the migration domain.
  (3) It makes it difficult to run container management tools (like
      docker/libcontainer, lmctfy, etc.) within virtual containers
      without adding dependency on some state/agent present outside the
      container.

  Note that the feature proposed here is completely different than the
  =E2=80=9Cns cgroup=E2=80=9D feature which existed in the linux kernel=
 until recently.
  The ns cgroup also attempted to connect cgroups and namespaces by
  creating a new cgroup every time a new namespace was created. It did
  not solve any of the above mentioned problems and was later dropped
  from the kernel.

Introducing CGroup Namespaces
  With unified cgroup hierarchy
  (Documentation/cgroups/unified-hierarchy.txt), the containers can now
  have a much more coherent cgroup view and its easy to associate a
  container with a single cgroup. This also allows us to virtualize the
  cgroup view for tasks inside the container.

  The new CGroup Namespace allows a process to =E2=80=9Cunshare=E2=80=9D=
 its cgroup
  hierarchy starting from the cgroup its currently in.
  For Ex:
  $ cat /proc/self/cgroup
  0:cpuset,cpu,cpuacct,memory,devices,freezer,hugetlb:/batchjobs/c_job_=
id1
  $ ls -l /proc/self/ns/cgroup
  lrwxrwxrwx 1 root root 0 2014-07-15 10:37 /proc/self/ns/cgroup -> cgr=
oup:[4026531835]
  $ ~/unshare -c  # calls unshare(CLONE_NEWCGROUP) and exec=E2=80=99s /=
bin/bash
  [ns]$ ls -l /proc/self/ns/cgroup
  lrwxrwxrwx 1 root root 0 2014-07-15 10:35 /proc/self/ns/cgroup -> cgr=
oup:[4026532183]
  # From within new cgroupns, process sees that its in the root cgroup
  [ns]$ cat /proc/self/cgroup
  0:cpuset,cpu,cpuacct,memory,devices,freezer,hugetlb:/

  # From global cgroupns:
  $ cat /proc/<pid>/cgroup
  0:cpuset,cpu,cpuacct,memory,devices,freezer,hugetlb:/batchjobs/c_job_=
id1

  The virtualization of /proc/self/cgroup file combined with restrictin=
g
  the view of cgroup hierarchy by bind-mounting for the
  $CGROUP_MOUNT/batchjobs/c_job_id1/ directory to
  $CONTAINER_CHROOT/sys/fs/cgroup/) should provide a completely isolate=
d
  cgroup view inside the container.

  In its current simplistic form, the cgroup namespaces provide
  following behavior:

  (1) The =E2=80=9Croot=E2=80=9D cgroup for a cgroup namespace is the c=
group in which
      the process calling unshare is running.
      For ex. if a process in /batchjobs/c_job_id1 cgroup calls unshare=
,
      cgroup /batchjobs/c_job_id1 becomes the cgroupns-root.
      For the init_cgroup_ns, this is the real root (=E2=80=9C/=E2=80=9D=
) cgroup
      (identified in code as cgrp_dfl_root.cgrp).

  (2) The cgroupns-root cgroup does not change even if the namespace
      creator process later moves to a different cgroup.
      $ ~/unshare -c # unshare cgroupns in some cgroup
      [ns]$ cat /proc/self/cgroup=20
      0:cpuset,cpu,cpuacct,memory,devices,freezer,hugetlb:/=20
      [ns]$ mkdir sub_cgrp_1
      [ns]$ echo 0 > sub_cgrp_1/cgroup.procs
      [ns]$ cat /proc/self/cgroup=20
      0:cpuset,cpu,cpuacct,memory,devices,freezer,hugetlb:/sub_cgrp_1

  (3) Each process gets its CGROUPNS specific view of
      /proc/<pid>/cgroup.
  (a) Processes running inside the cgroup namespace will be able to see
      cgroup paths (in /proc/self/cgroup) only inside their root cgroup
      [ns]$ sleep 100000 &  # From within unshared cgroupns
      [1] 7353
      [ns]$ echo 7353 > sub_cgrp_1/cgroup.procs
      [ns]$ cat /proc/7353/cgroup
      0:cpuset,cpu,cpuacct,memory,devices,freezer,hugetlb:/sub_cgrp_1

  (b) From global cgroupns, the real cgroup path will be visible:
      $ cat /proc/7353/cgroup
      0:cpuset,cpu,cpuacct,memory,devices,freezer,hugetlb:/batchjobs/c_=
job_id1/sub_cgrp_1

  (c) From a sibling cgroupns, the real path will be visible:
      [ns2]$ cat /proc/7353/cgroup
      0:cpuset,cpu,cpuacct,memory,devices,freezer,hugetlb:/batchjobs/c_=
job_id1/sub_cgrp_1
      (In correct container setup though, it should not be possible to
       access PIDs in another container in the first place. This can be
       detected changed if desired.)

  (4) Processes inside a cgroupns are not allowed to move out of the
      cgroupns-root. This is true even if a privileged process in globa=
l
      cgroupns tries to move the process out of its cgroupns-root.

      # From global cgroupns
      $ cat /proc/7353/cgroup
      0:cpuset,cpu,cpuacct,memory,devices,freezer,hugetlb:/batchjobs/c_=
job_id1/sub_cgrp_1
      # cgroupns-root for 7353 is /batchjobs/c_job_id1
      $ echo 7353 > batchjobs/c_job_id2/cgroup.procs
      -bash: echo: write error: Operation not permitted

  (5) setns() is not supported for cgroup namespace in the initial
      version.

  (6) When some thread from a multi-threaded process unshares its
      cgroup-namespace, the new cgroupns gets applied to the entire
      process (all the threads). This should be OK since
      unified-hierarchy only allows process-level containerization. So
      all the threads in the process will have the same cgroup. And bot=
h
      - changing cgroups and unsharing namespaces - are protected under
      threadgroup_lock(task).

  (7) The cgroup namespace is alive as long as there is atleast 1
      process inside it. When the last process exits, the cgroup
      namespace is destroyed. The cgroupns-root and the actual cgroups
      remain though.

Implementation
  The current patch-set is based on top of Tejun's cgroup tree (for-nex=
t
  branch). Its fairly non-intrusive and provides above mentioned
  features.

Possible extensions of CGROUPNS:
  (1) The Documentation/cgroups/unified-hierarchy.txt mentions use of
      capabilities to restrict cgroups to administrative users. CGroup
      namespaces could be of help here. With cgroup namespaces, it migh=
t
      be possible to delegate administration of sub-cgroups under a
      cgroupns-root to the cgroupns owner.

  (2) Provide a cgroupns specific cgroupfs mount. i.e., the following
      command when ran from inside a cgroupns should only mount the
      hierarchy from cgroupns-root cgroup:
      $ mount -t cgroup cgroup <cgroup-mountpoint>
      # -o __DEVEL__sane_behavior should be implicit

      This is similar to how procfs can be mounted for every PIDNS. Thi=
s
      may have some usecases.

---
 fs/kernfs/dir.c                  |  51 +++++++++++++---
 fs/proc/namespaces.c             |   3 +
 include/linux/cgroup.h           |  36 ++++++++++-
 include/linux/cgroup_namespace.h |  62 +++++++++++++++++++
 include/linux/kernfs.h           |   3 +
 include/linux/nsproxy.h          |   2 +
 include/linux/proc_ns.h          |   4 ++
 include/uapi/linux/sched.h       |   3 +-
 init/Kconfig                     |   9 +++
 kernel/Makefile                  |   1 +
 kernel/cgroup.c                  |  75 +++++++++++++++++------
 kernel/cgroup_namespace.c        | 128 +++++++++++++++++++++++++++++++=
++++++++
 kernel/fork.c                    |   2 +-
 kernel/nsproxy.c                 |  19 +++++-
 14 files changed, 364 insertions(+), 34 deletions(-)
 create mode 100644 include/linux/cgroup_namespace.h
 create mode 100644 kernel/cgroup_namespace.c

[PATCH 1/5] kernfs: Add API to get generate relative kernfs path
[PATCH 2/5] sched: new clone flag CLONE_NEWCGROUP for cgroup
[PATCH 3/5] cgroup: add function to get task's cgroup on default
[PATCH 4/5] cgroup: export cgroup_get() and cgroup_put()
[PATCH 5/5] cgroup: introduce cgroup namespaces
