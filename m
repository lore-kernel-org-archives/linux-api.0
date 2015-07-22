From: Vincent Batts <vbatts-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCHv1 0/8] CGroup Namespaces
Date: Wed, 22 Jul 2015 14:10:34 -0400
Message-ID: <CAN6Zp5wmMOR+UAfk7D3gXGqFk+VX93yMebd61URtrCMV-Dvfpg@mail.gmail.com>
References: <1413235430-22944-1-git-send-email-adityakali@google.com>
	<87k33wpsl3.fsf@x220.int.ebiederm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <87k33wpsl3.fsf-JOvCrm2gF+uungPnsOpG7nhyD016LWXt@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Cc: Aditya Kali <adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Has there been further movement on CLONE_NEWCGROUP outside of this?


vb

On Sun, Oct 19, 2014 at 12:54 AM, Eric W. Biederman
<ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org> wrote:
> Aditya Kali <adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> writes:
>
>> Second take at the Cgroup Namespace patch-set.
>>
>> Major changes form RFC (V0):
>> 1. setns support for cgroupns
>> 2. 'mount -t cgroup cgroup <mntpt>' from inside a cgroupns now
>>    mounts the cgroup hierarcy with cgroupns-root as the filesystem r=
oot.
>> 3. writes to cgroup files outside of cgroupns-root are not allowed
>> 4. visibility of /proc/<pid>/cgroup is further restricted by not sho=
wing
>>    anything if the <pid> is in a sibling cgroupns and its cgroup fal=
ls outside
>>    your cgroupns-root.
>>
>> More details in the writeup below.
>
> This definitely looks like the right direction to go, and something t=
hat
> in some form or another I had been asking for since cgroups were merg=
ed.
> So I am very glad to see this work moving forward.
>
> I had hoped that we might just be able to be clever with remounting
> cgroupfs but 2 things stand in the way.
> 1) /proc/<pid>/cgroups (but proc could capture that).
> 2) providing a hard guarnatee that tasks stay within a subset of the
>    cgroup hierarchy.
>
> So I think this clearly meets the requirements for a new namespace.
>
> We need to have the discussion on chmod of files on cgroupfs.  There =
is
> a notion that has floated around that only systemd or only root (with
> the appropriate capabilities) should be allowed to set resource limit=
s
> in cgroupfs.  In a practical reality that is nonsense.  If an atribut=
e
> is properly bound in it's hiearchy it should be safe to change.
>
> Not all attributes are properly bound to hierarchy and some are or at
> least were dangerous for anyone except root to set.  So I suggest tha=
t a
> CFTYPE flag perhaps CFTYPE_UNPRIV be added for attributes that are sa=
fe
> to allow anyone to set, and require CFTYPE_UNPRIV be set before we ch=
mod
> a cgroup attribute from root.
>
> That would be complimentary work, and not strictly tied the cgroup
> namespaces but unprivileged cgroup namespaces don't make much sense
> without that work.
>
> Eric
>
>> Background
>>   Cgroups and Namespaces are used together to create =E2=80=9Cvirtua=
l=E2=80=9D
>>   containers that isolates the host environment from the processes
>>   running in container. But since cgroups themselves are not
>>   =E2=80=9Cvirtualized=E2=80=9D, the task is always able to see glob=
al cgroups view
>>   through cgroupfs mount and via /proc/self/cgroup file.
>>
>>   $ cat /proc/self/cgroup
>>   0:cpuset,cpu,cpuacct,memory,devices,freezer,hugetlb:/batchjobs/c_j=
ob_id1
>>
>>   This exposure of cgroup names to the processes running inside a
>>   container results in some problems:
>>   (1) The container names are typically host-container-management-ag=
ent
>>       (systemd, docker/libcontainer, etc.) data and leaking its name=
 (or
>>       leaking the hierarchy) reveals too much information about the =
host
>>       system.
>>   (2) It makes the container migration across machines (CRIU) more
>>       difficult as the container names need to be unique across the
>>       machines in the migration domain.
>>   (3) It makes it difficult to run container management tools (like
>>       docker/libcontainer, lmctfy, etc.) within virtual containers
>>       without adding dependency on some state/agent present outside =
the
>>       container.
>>
>>   Note that the feature proposed here is completely different than t=
he
>>   =E2=80=9Cns cgroup=E2=80=9D feature which existed in the linux ker=
nel until recently.
>>   The ns cgroup also attempted to connect cgroups and namespaces by
>>   creating a new cgroup every time a new namespace was created. It d=
id
>>   not solve any of the above mentioned problems and was later droppe=
d
>>   from the kernel. Incidentally though, it used the same config opti=
on
>>   name CONFIG_CGROUP_NS as used in my prototype!
>>
>> Introducing CGroup Namespaces
>>   With unified cgroup hierarchy
>>   (Documentation/cgroups/unified-hierarchy.txt), the containers can =
now
>>   have a much more coherent cgroup view and its easy to associate a
>>   container with a single cgroup. This also allows us to virtualize =
the
>>   cgroup view for tasks inside the container.
>>
>>   The new CGroup Namespace allows a process to =E2=80=9Cunshare=E2=80=
=9D its cgroup
>>   hierarchy starting from the cgroup its currently in.
>>   For Ex:
>>   $ cat /proc/self/cgroup
>>   0:cpuset,cpu,cpuacct,memory,devices,freezer,hugetlb:/batchjobs/c_j=
ob_id1
>>   $ ls -l /proc/self/ns/cgroup
>>   lrwxrwxrwx 1 root root 0 2014-07-15 10:37 /proc/self/ns/cgroup -> =
cgroup:[4026531835]
>>   $ ~/unshare -c  # calls unshare(CLONE_NEWCGROUP) and exec=E2=80=99=
s /bin/bash
>>   [ns]$ ls -l /proc/self/ns/cgroup
>>   lrwxrwxrwx 1 root root 0 2014-07-15 10:35 /proc/self/ns/cgroup ->
>>   cgroup:[4026532183]
>>   # From within new cgroupns, process sees that its in the root cgro=
up
>>   [ns]$ cat /proc/self/cgroup
>>   0:cpuset,cpu,cpuacct,memory,devices,freezer,hugetlb:/
>>
>>   # From global cgroupns:
>>   $ cat /proc/<pid>/cgroup
>>   0:cpuset,cpu,cpuacct,memory,devices,freezer,hugetlb:/batchjobs/c_j=
ob_id1
>>
>>   # Unshare cgroupns along with userns and mountns
>>   # Following calls unshare(CLONE_NEWCGROUP|CLONE_NEWUSER|CLONE_NEWN=
S), then
>>   # sets up uid/gid map and exec=E2=80=99s /bin/bash
>>   $ ~/unshare -c -u -m
>>
>>   # Originally, we were in /batchjobs/c_job_id1 cgroup. Mount our ow=
n cgroup
>>   # hierarchy.
>>   [ns]$ mount -t cgroup cgroup /tmp/cgroup
>>   [ns]$ ls -l /tmp/cgroup
>>   total 0
>>   -r--r--r-- 1 root root 0 2014-10-13 09:32 cgroup.controllers
>>   -r--r--r-- 1 root root 0 2014-10-13 09:32 cgroup.populated
>>   -rw-r--r-- 1 root root 0 2014-10-13 09:25 cgroup.procs
>>   -rw-r--r-- 1 root root 0 2014-10-13 09:32 cgroup.subtree_control
>>
>>   The cgroupns-root (/batchjobs/c_job_id1 in above example) becomes =
the
>>   filesystem root for the namespace specific cgroupfs mount.
>>
>>   The virtualization of /proc/self/cgroup file combined with restric=
ting
>>   the view of cgroup hierarchy by namespace-private cgroupfs mount
>>   should provide a completely isolated cgroup view inside the contai=
ner.
>>
>>   In its current form, the cgroup namespaces patcheset provides foll=
owing
>>   behavior:
>>
>>   (1) The =E2=80=9Croot=E2=80=9D cgroup for a cgroup namespace is th=
e cgroup in which
>>       the process calling unshare is running.
>>       For ex. if a process in /batchjobs/c_job_id1 cgroup calls unsh=
are,
>>       cgroup /batchjobs/c_job_id1 becomes the cgroupns-root.
>>       For the init_cgroup_ns, this is the real root (=E2=80=9C/=E2=80=
=9D) cgroup
>>       (identified in code as cgrp_dfl_root.cgrp).
>>
>>   (2) The cgroupns-root cgroup does not change even if the namespace
>>       creator process later moves to a different cgroup.
>>       $ ~/unshare -c # unshare cgroupns in some cgroup
>>       [ns]$ cat /proc/self/cgroup
>>       0:cpuset,cpu,cpuacct,memory,devices,freezer,hugetlb:/
>>       [ns]$ mkdir sub_cgrp_1
>>       [ns]$ echo 0 > sub_cgrp_1/cgroup.procs
>>       [ns]$ cat /proc/self/cgroup
>>       0:cpuset,cpu,cpuacct,memory,devices,freezer,hugetlb:/sub_cgrp_=
1
>>
>>   (3) Each process gets its CGROUPNS specific view of
>>       /proc/<pid>/cgroup.
>>   (a) Processes running inside the cgroup namespace will be able to =
see
>>       cgroup paths (in /proc/self/cgroup) only inside their root cgr=
oup
>>       [ns]$ sleep 100000 &  # From within unshared cgroupns
>>       [1] 7353
>>       [ns]$ echo 7353 > sub_cgrp_1/cgroup.procs
>>       [ns]$ cat /proc/7353/cgroup
>>       0:cpuset,cpu,cpuacct,memory,devices,freezer,hugetlb:/sub_cgrp_=
1
>>
>>   (b) From global cgroupns, the real cgroup path will be visible:
>>       $ cat /proc/7353/cgroup
>>       0:cpuset,cpu,cpuacct,memory,devices,freezer,hugetlb:/batchjobs=
/c_job_id1/sub_cgrp_1
>>
>>   (c) From a sibling cgroupns (cgroupns root-ed at a sibling cgroup)=
, no cgroup
>>       path will be visible:
>>       # ns2's cgroupns-root is at '/batchjobs/c_job_id2'
>>       [ns2]$ cat /proc/7353/cgroup
>>       [ns2]$
>>       This is same as when cgroup hierarchy is not mounted at all.
>>       (In correct container setup though, it should not be possible =
to
>>        access PIDs in another container in the first place.)
>>
>>   (4) Processes inside a cgroupns are not allowed to move out of the
>>       cgroupns-root. This is true even if a privileged process in gl=
obal
>>       cgroupns tries to move the process out of its cgroupns-root.
>>
>>       # From global cgroupns
>>       $ cat /proc/7353/cgroup
>>       0:cpuset,cpu,cpuacct,memory,devices,freezer,hugetlb:/batchjobs=
/c_job_id1/sub_cgrp_1
>>       # cgroupns-root for 7353 is /batchjobs/c_job_id1
>>       $ echo 7353 > batchjobs/c_job_id2/cgroup.procs
>>       -bash: echo: write error: Operation not permitted
>>
>>   (5) Setns to another cgroup namespace is allowed only when:
>>       (a) process has CAP_SYS_ADMIN in its current userns
>>       (b) process has CAP_SYS_ADMIN in the target cgroupns' userns
>>       (c) the process's current cgroup is a descendant cgroupns-root=
 of the
>>           target namespace.
>>       (d) the target cgroupns-root is descendant of current cgroupns=
-root..
>>       The last check (d) prevents processes from escaping their cgro=
upns-root by
>>       attaching to parent cgroupns. Thus, setns is allowed only when=
 the process
>>       is trying to restrict itself to a deeper cgroup hierarchy.
>>
>>   (6) When some thread from a multi-threaded process unshares its
>>       cgroup-namespace, the new cgroupns gets applied to the entire
>>       process (all the threads). This should be OK since
>>       unified-hierarchy only allows process-level containerization. =
So
>>       all the threads in the process will have the same cgroup. And =
both
>>       - changing cgroups and unsharing namespaces - are protected un=
der
>>       threadgroup_lock(task).
>>
>>   (7) The cgroup namespace is alive as long as there is atleast 1
>>       process inside it. When the last process exits, the cgroup
>>       namespace is destroyed. The cgroupns-root and the actual cgrou=
ps
>>       remain though.
>>
>>   (8) 'mount -t cgroup cgroup <mntpt>' when called from within cgrou=
pns mounts
>>       the unified cgroup hierarchy with cgroupns-root as the filesys=
tem root.
>>       The process needs CAP_SYS_ADMIN in its userns and mntns. This =
allows the
>>       container management tools to be run inside the containers tra=
nsparently.
>>
>> Implementation
>>   The current patch-set is based on top of Tejun Heo's cgroup tree (=
for-next
>>   branch). Its fairly non-intrusive and provides above mentioned
>>   features.
>>
>> Possible extensions of CGROUPNS:
>>   (1) The Documentation/cgroups/unified-hierarchy.txt mentions use o=
f
>>       capabilities to restrict cgroups to administrative users. CGro=
up
>>       namespaces could be of help here. With cgroup namespaces, it m=
ight
>>       be possible to delegate administration of sub-cgroups under a
>>       cgroupns-root to the cgroupns owner.
>
>
>
>
>> ---
>>  fs/kernfs/dir.c                  |  53 +++++++++---
>>  fs/kernfs/mount.c                |  48 +++++++++++
>>  fs/proc/namespaces.c             |   3 +
>>  include/linux/cgroup.h           |  41 +++++++++-
>>  include/linux/cgroup_namespace.h |  62 +++++++++++++++
>>  include/linux/kernfs.h           |   5 ++
>>  include/linux/nsproxy.h          |   2 +
>>  include/linux/proc_ns.h          |   4 +
>>  include/uapi/linux/sched.h       |   3 +-
>>  init/Kconfig                     |   9 +++
>>  kernel/Makefile                  |   1 +
>>  kernel/cgroup.c                  | 139 ++++++++++++++++++++++++++--=
----
>>  kernel/cgroup_namespace.c        | 168 ++++++++++++++++++++++++++++=
+++++++++++
>>  kernel/fork.c                    |   2 +-
>>  kernel/nsproxy.c                 |  19 ++++-
>>  15 files changed, 518 insertions(+), 41 deletions(-)
>>  create mode 100644 include/linux/cgroup_namespace.h
>>  create mode 100644 kernel/cgroup_namespace.c
>>
>> [PATCHv1 1/8] kernfs: Add API to generate relative kernfs path
>> [PATCHv1 2/8] sched: new clone flag CLONE_NEWCGROUP for cgroup
>> [PATCHv1 3/8] cgroup: add function to get task's cgroup on default
>> [PATCHv1 4/8] cgroup: export cgroup_get() and cgroup_put()
>> [PATCHv1 5/8] cgroup: introduce cgroup namespaces
>> [PATCHv1 6/8] cgroup: restrict cgroup operations within task's cgrou=
pns
>> [PATCHv1 7/8] cgroup: cgroup namespace setns support
>> [PATCHv1 8/8] cgroup: mount cgroupns-root when inside non-init cgrou=
pns
>> _______________________________________________
>> Containers mailing list
>> Containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
>> https://lists.linuxfoundation.org/mailman/listinfo/containers
> _______________________________________________
> Containers mailing list
> Containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
> https://lists.linuxfoundation.org/mailman/listinfo/containers
