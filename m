From: Serge Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 0/5] RFC: CGroup Namespaces
Date: Thu, 24 Jul 2014 16:36:28 +0000
Message-ID: <20140724163628.GN26600@ubuntumail>
References: <adityakali-cgroupns>
 <1405626731-12220-1-git-send-email-adityakali@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1405626731-12220-1-git-send-email-adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Aditya Kali <adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Quoting Aditya Kali (adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org):
> Background
>   Cgroups and Namespaces are used together to create =E2=80=9Cvirtual=
=E2=80=9D
>   containers that isolates the host environment from the processes
>   running in container. But since cgroups themselves are not
>   =E2=80=9Cvirtualized=E2=80=9D, the task is always able to see globa=
l cgroups view
>   through cgroupfs mount and via /proc/self/cgroup file.
>=20
>   $ cat /proc/self/cgroup=20
>   0:cpuset,cpu,cpuacct,memory,devices,freezer,hugetlb:/batchjobs/c_jo=
b_id1
>=20
>   This exposure of cgroup names to the processes running inside a
>   container results in some problems:
>   (1) The container names are typically host-container-management-age=
nt
>       (systemd, docker/libcontainer, etc.) data and leaking its name =
(or
>       leaking the hierarchy) reveals too much information about the h=
ost
>       system.
>   (2) It makes the container migration across machines (CRIU) more
>       difficult as the container names need to be unique across the
>       machines in the migration domain.
>   (3) It makes it difficult to run container management tools (like
>       docker/libcontainer, lmctfy, etc.) within virtual containers
>       without adding dependency on some state/agent present outside t=
he
>       container.
>=20
>   Note that the feature proposed here is completely different than th=
e
>   =E2=80=9Cns cgroup=E2=80=9D feature which existed in the linux kern=
el until recently.
>   The ns cgroup also attempted to connect cgroups and namespaces by
>   creating a new cgroup every time a new namespace was created. It di=
d
>   not solve any of the above mentioned problems and was later dropped
>   from the kernel.
>=20
> Introducing CGroup Namespaces
>   With unified cgroup hierarchy
>   (Documentation/cgroups/unified-hierarchy.txt), the containers can n=
ow
>   have a much more coherent cgroup view and its easy to associate a
>   container with a single cgroup. This also allows us to virtualize t=
he
>   cgroup view for tasks inside the container.
>=20
>   The new CGroup Namespace allows a process to =E2=80=9Cunshare=E2=80=
=9D its cgroup
>   hierarchy starting from the cgroup its currently in.
>   For Ex:
>   $ cat /proc/self/cgroup
>   0:cpuset,cpu,cpuacct,memory,devices,freezer,hugetlb:/batchjobs/c_jo=
b_id1
>   $ ls -l /proc/self/ns/cgroup
>   lrwxrwxrwx 1 root root 0 2014-07-15 10:37 /proc/self/ns/cgroup -> c=
group:[4026531835]
>   $ ~/unshare -c  # calls unshare(CLONE_NEWCGROUP) and exec=E2=80=99s=
 /bin/bash
>   [ns]$ ls -l /proc/self/ns/cgroup
>   lrwxrwxrwx 1 root root 0 2014-07-15 10:35 /proc/self/ns/cgroup -> c=
group:[4026532183]
>   # From within new cgroupns, process sees that its in the root cgrou=
p
>   [ns]$ cat /proc/self/cgroup
>   0:cpuset,cpu,cpuacct,memory,devices,freezer,hugetlb:/
>=20
>   # From global cgroupns:
>   $ cat /proc/<pid>/cgroup
>   0:cpuset,cpu,cpuacct,memory,devices,freezer,hugetlb:/batchjobs/c_jo=
b_id1
>=20
>   The virtualization of /proc/self/cgroup file combined with restrict=
ing
>   the view of cgroup hierarchy by bind-mounting for the
>   $CGROUP_MOUNT/batchjobs/c_job_id1/ directory to
>   $CONTAINER_CHROOT/sys/fs/cgroup/) should provide a completely isola=
ted
>   cgroup view inside the container.
>=20
>   In its current simplistic form, the cgroup namespaces provide
>   following behavior:
>=20
>   (1) The =E2=80=9Croot=E2=80=9D cgroup for a cgroup namespace is the=
 cgroup in which
>       the process calling unshare is running.
>       For ex. if a process in /batchjobs/c_job_id1 cgroup calls unsha=
re,
>       cgroup /batchjobs/c_job_id1 becomes the cgroupns-root.
>       For the init_cgroup_ns, this is the real root (=E2=80=9C/=E2=80=
=9D) cgroup
>       (identified in code as cgrp_dfl_root.cgrp).
>=20
>   (2) The cgroupns-root cgroup does not change even if the namespace
>       creator process later moves to a different cgroup.
>       $ ~/unshare -c # unshare cgroupns in some cgroup
>       [ns]$ cat /proc/self/cgroup=20
>       0:cpuset,cpu,cpuacct,memory,devices,freezer,hugetlb:/=20
>       [ns]$ mkdir sub_cgrp_1
>       [ns]$ echo 0 > sub_cgrp_1/cgroup.procs
>       [ns]$ cat /proc/self/cgroup=20
>       0:cpuset,cpu,cpuacct,memory,devices,freezer,hugetlb:/sub_cgrp_1
>=20
>   (3) Each process gets its CGROUPNS specific view of
>       /proc/<pid>/cgroup.
>   (a) Processes running inside the cgroup namespace will be able to s=
ee
>       cgroup paths (in /proc/self/cgroup) only inside their root cgro=
up
>       [ns]$ sleep 100000 &  # From within unshared cgroupns
>       [1] 7353
>       [ns]$ echo 7353 > sub_cgrp_1/cgroup.procs
>       [ns]$ cat /proc/7353/cgroup
>       0:cpuset,cpu,cpuacct,memory,devices,freezer,hugetlb:/sub_cgrp_1
>=20
>   (b) From global cgroupns, the real cgroup path will be visible:
>       $ cat /proc/7353/cgroup
>       0:cpuset,cpu,cpuacct,memory,devices,freezer,hugetlb:/batchjobs/=
c_job_id1/sub_cgrp_1
>=20
>   (c) From a sibling cgroupns, the real path will be visible:
>       [ns2]$ cat /proc/7353/cgroup
>       0:cpuset,cpu,cpuacct,memory,devices,freezer,hugetlb:/batchjobs/=
c_job_id1/sub_cgrp_1
>       (In correct container setup though, it should not be possible t=
o
>        access PIDs in another container in the first place. This can =
be
>        detected changed if desired.)
>=20
>   (4) Processes inside a cgroupns are not allowed to move out of the
>       cgroupns-root. This is true even if a privileged process in glo=
bal
>       cgroupns tries to move the process out of its cgroupns-root.
>=20
>       # From global cgroupns
>       $ cat /proc/7353/cgroup
>       0:cpuset,cpu,cpuacct,memory,devices,freezer,hugetlb:/batchjobs/=
c_job_id1/sub_cgrp_1
>       # cgroupns-root for 7353 is /batchjobs/c_job_id1
>       $ echo 7353 > batchjobs/c_job_id2/cgroup.procs
>       -bash: echo: write error: Operation not permitted
>=20
>   (5) setns() is not supported for cgroup namespace in the initial
>       version.

This combined with the full-path reporting for peer ns cgroups could ma=
ke
for fun antics when attaching to an existing container (since we'd have
to unshare into a new ns cgroup with the same roto as the container).
I understand you are implying this will be fixed soon though.

>   (6) When some thread from a multi-threaded process unshares its
>       cgroup-namespace, the new cgroupns gets applied to the entire
>       process (all the threads). This should be OK since
>       unified-hierarchy only allows process-level containerization. S=
o
>       all the threads in the process will have the same cgroup. And b=
oth
>       - changing cgroups and unsharing namespaces - are protected und=
er
>       threadgroup_lock(task).
>=20
>   (7) The cgroup namespace is alive as long as there is atleast 1
>       process inside it. When the last process exits, the cgroup
>       namespace is destroyed. The cgroupns-root and the actual cgroup=
s
>       remain though.
>=20
> Implementation
>   The current patch-set is based on top of Tejun's cgroup tree (for-n=
ext
>   branch). Its fairly non-intrusive and provides above mentioned
>   features.
>=20
> Possible extensions of CGROUPNS:
>   (1) The Documentation/cgroups/unified-hierarchy.txt mentions use of
>       capabilities to restrict cgroups to administrative users. CGrou=
p
>       namespaces could be of help here. With cgroup namespaces, it mi=
ght
>       be possible to delegate administration of sub-cgroups under a
>       cgroupns-root to the cgroupns owner.

That would be nice.

>   (2) Provide a cgroupns specific cgroupfs mount. i.e., the following
>       command when ran from inside a cgroupns should only mount the
>       hierarchy from cgroupns-root cgroup:
>       $ mount -t cgroup cgroup <cgroup-mountpoint>
>       # -o __DEVEL__sane_behavior should be implicit
>=20
>       This is similar to how procfs can be mounted for every PIDNS. T=
his
>       may have some usecases.

Sorry - I see this answers the first part of a question in my previous =
email.
However, the question of whether changes to limits in cgroups which are=
 not
under our cgroup-ns-root are allowed.

Admittedly the current case with cgmanager is the same - in that it dep=
ends
on proper setup of the container - but cgmanager is geared to recommend
not mounting the cgroups in the container at all (and we can reject suc=
h
mounts in the contaienr altogether with no loss in functionality) where=
as
you are here encouraging such mounts.  Which is fine - so long as you t=
hen
fully address the potential issues.
