From: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 0/5] RFC: CGroup Namespaces
Date: Tue, 29 Jul 2014 06:51:59 +0200
Message-ID: <20140729045159.GB31047@mail.hallyn.com>
References: <1405626731-12220-1-git-send-email-adityakali@google.com>
 <20140724163628.GN26600@ubuntumail>
 <CAGr1F2GcAema-E2q6PFj=R0Z505iD7JshrMuMdfPTJ95wMiQMA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAGr1F2GcAema-E2q6PFj=R0Z505iD7JshrMuMdfPTJ95wMiQMA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Aditya Kali <adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Serge Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Quoting Aditya Kali (adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org):
> Thank you for your review. I have tried to respond to both your email=
s here.
>=20
> On Thu, Jul 24, 2014 at 9:36 AM, Serge Hallyn <serge.hallyn-GeWIH/nMZzJhl2p70BpVqQ@public.gmane.org=
m> wrote:
> > Quoting Aditya Kali (adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org):
> >> Background
> >>   Cgroups and Namespaces are used together to create =E2=80=9Cvirt=
ual=E2=80=9D
> >>   containers that isolates the host environment from the processes
> >>   running in container. But since cgroups themselves are not
> >>   =E2=80=9Cvirtualized=E2=80=9D, the task is always able to see gl=
obal cgroups view
> >>   through cgroupfs mount and via /proc/self/cgroup file.
> >>
> > Hi,
> >
> > A few questions/comments:
> >
> > 1. Based on this description, am I to understand that after doing a
> >    cgroupns unshare, 'mount -t cgroup cgroup /mnt' by default will
> >    still mount the global root cgroup?  Any plans on "changing" tha=
t?
>=20
> This is suggested in the "Possible Extensions of CGROUPNS" section.
> More details below.
>=20
> >    Will attempts to change settings of a cgroup which is not under
> >    our current ns be rejected?  (That should be easy to do given yo=
ur
> >    patch 1/5).  Sorry if it's done in the set, I'm jumping around..=
=2E
> >
>=20
> Currently, only 'cgroup_attach_task', 'cgroup_mkdir' and
> 'cgroup_rmdir' of cgroups outside of cgroupns-root are prevented. The
> read/write of actual cgroup properties are not prevented. Usual
> permission checks continue to apply for those. I was hoping that
> should be enough, but see more comments towards the end.
>=20
> > 2. What would be the reprecussions of allowing cgroupns unshare so
> >    long as you have ns_capable(CAP_SYS_ADMIN) to the user_ns which
> >    created your current ns cgroup?  It'd be a shame if that wasn't
> >    on the roadmap.
> >
>=20
> Its certainly on the roadmap, just that some logistics were not clear
> at this time. As pointed out by Andy Lutomirski on [PATCH 5/5] of thi=
s
> series, if we allow cgroupns creation to ns_capable(CAP_SYS_ADMIN)
> processes, we may need some kind of explicit permission from the
> cgroup subsystem to allow this. One approach could be an explicit

So long as you do ns_capable(cgroup_ns->user_ns, CAP_SYS_ADMIN) I think
you're fine.

The only real problem I can think of with unsharing a cgroup_ns is that
you could lock a setuid-root application someplace it wasn't expecting.
The above check guarantees that you were privileged enough that you'd
better be trusted in this user namespace.

(Unless there is some possible interaction I'm overlooking)

> cgroup.may_unshare setting. Alternatively, the cgroup directory (whic=
h
> is going to become the cgroupns-root) ownership could also be used
> here. i.e., the process is ns_capable(CAP_SYS_ADMIN) && it owns the
> cgroup directory. There seems to be already a function that allows
> similar thing and might be sufficient:
>=20
> /**
>  * capable_wrt_inode_uidgid - Check nsown_capable and uid and gid map=
ped
>  * @inode: The inode in question
>  * @cap: The capability in question
>  *
>  * Return true if the current task has the given capability targeted =
at
>  * its own user namespace and that the given inode's uid and gid are
>  * mapped into the current user namespace.
>  */
> bool capable_wrt_inode_uidgid(const struct inode *inode, int cap)
>=20
> What do you think? We can enable this for non-init userns once this i=
s
> decided on.

I don't think it's needed... (until you show how wrong I am above :)

> > 3. The un-namespaced view of /proc/self/cgroup from a sibling cgrou=
pns
> >    makes me wonder whether it wouldn't be more appropriate to leave
> >    /proc/self/cgroup always un-filtered, and use /proc/self/nscgrou=
p
> >    (or somesuch) to provide the namespaced view.  /proc/self/nscgro=
up
> >    would simply be empty (or say (invalid) or (unreachable)) from a
> >    sibling ns.  That will give criu and admin tools like lxc/docker=
 all
> >    they need to do simple cgroup setup.
> >
>=20
> It may work for lxc/docker and new applications that use the new
> interface. But its difficult to change numerous existing user
> applications and libraries that depend on /proc/self/cgroup. Moreover=
,
> even with the new interface, /proc/self/cgroup will continue to leak
> system level cgroup information. And fixing this leak is critical to
> make the container migratable.
>=20
> Its easy to correctly handle the read of /proc/<pid>/cgroup from a
> sibling cgroupns. Instead of showing unfiltered view, we could just
> not show anything (same behavior when the cgroup hierarchy is not
> mounted). Will that be more acceptable? I can make that change in the
> next version of this series.

It'll be acceptable so long as setns(CLONE_NEWCGROUP) is supported.

> >>   $ cat /proc/self/cgroup
> >>   0:cpuset,cpu,cpuacct,memory,devices,freezer,hugetlb:/batchjobs/c=
_job_id1
> >>
> >>   This exposure of cgroup names to the processes running inside a
> >>   container results in some problems:
> >>   (1) The container names are typically host-container-management-=
agent
> >>       (systemd, docker/libcontainer, etc.) data and leaking its na=
me (or
> >>       leaking the hierarchy) reveals too much information about th=
e host
> >>       system.
> >>   (2) It makes the container migration across machines (CRIU) more
> >>       difficult as the container names need to be unique across th=
e
> >>       machines in the migration domain.
> >>   (3) It makes it difficult to run container management tools (lik=
e
> >>       docker/libcontainer, lmctfy, etc.) within virtual containers
> >>       without adding dependency on some state/agent present outsid=
e the
> >>       container.
> >>
> >>   Note that the feature proposed here is completely different than=
 the
> >>   =E2=80=9Cns cgroup=E2=80=9D feature which existed in the linux k=
ernel until recently.
> >>   The ns cgroup also attempted to connect cgroups and namespaces b=
y
> >>   creating a new cgroup every time a new namespace was created. It=
 did
> >>   not solve any of the above mentioned problems and was later drop=
ped
> >>   from the kernel.
> >>
> >> Introducing CGroup Namespaces
> >>   With unified cgroup hierarchy
> >>   (Documentation/cgroups/unified-hierarchy.txt), the containers ca=
n now
> >>   have a much more coherent cgroup view and its easy to associate =
a
> >>   container with a single cgroup. This also allows us to virtualiz=
e the
> >>   cgroup view for tasks inside the container.
> >>
> >>   The new CGroup Namespace allows a process to =E2=80=9Cunshare=E2=
=80=9D its cgroup
> >>   hierarchy starting from the cgroup its currently in.
> >>   For Ex:
> >>   $ cat /proc/self/cgroup
> >>   0:cpuset,cpu,cpuacct,memory,devices,freezer,hugetlb:/batchjobs/c=
_job_id1
> >>   $ ls -l /proc/self/ns/cgroup
> >>   lrwxrwxrwx 1 root root 0 2014-07-15 10:37 /proc/self/ns/cgroup -=
> cgroup:[4026531835]
> >>   $ ~/unshare -c  # calls unshare(CLONE_NEWCGROUP) and exec=E2=80=99=
s /bin/bash
> >>   [ns]$ ls -l /proc/self/ns/cgroup
> >>   lrwxrwxrwx 1 root root 0 2014-07-15 10:35 /proc/self/ns/cgroup -=
> cgroup:[4026532183]
> >>   # From within new cgroupns, process sees that its in the root cg=
roup
> >>   [ns]$ cat /proc/self/cgroup
> >>   0:cpuset,cpu,cpuacct,memory,devices,freezer,hugetlb:/
> >>
> >>   # From global cgroupns:
> >>   $ cat /proc/<pid>/cgroup
> >>   0:cpuset,cpu,cpuacct,memory,devices,freezer,hugetlb:/batchjobs/c=
_job_id1
> >>
> >>   The virtualization of /proc/self/cgroup file combined with restr=
icting
> >>   the view of cgroup hierarchy by bind-mounting for the
> >>   $CGROUP_MOUNT/batchjobs/c_job_id1/ directory to
> >>   $CONTAINER_CHROOT/sys/fs/cgroup/) should provide a completely is=
olated
> >>   cgroup view inside the container.
> >>
> >>   In its current simplistic form, the cgroup namespaces provide
> >>   following behavior:
> >>
> >>   (1) The =E2=80=9Croot=E2=80=9D cgroup for a cgroup namespace is =
the cgroup in which
> >>       the process calling unshare is running.
> >>       For ex. if a process in /batchjobs/c_job_id1 cgroup calls un=
share,
> >>       cgroup /batchjobs/c_job_id1 becomes the cgroupns-root.
> >>       For the init_cgroup_ns, this is the real root (=E2=80=9C/=E2=
=80=9D) cgroup
> >>       (identified in code as cgrp_dfl_root.cgrp).
> >>
> >>   (2) The cgroupns-root cgroup does not change even if the namespa=
ce
> >>       creator process later moves to a different cgroup.
> >>       $ ~/unshare -c # unshare cgroupns in some cgroup
> >>       [ns]$ cat /proc/self/cgroup
> >>       0:cpuset,cpu,cpuacct,memory,devices,freezer,hugetlb:/
> >>       [ns]$ mkdir sub_cgrp_1
> >>       [ns]$ echo 0 > sub_cgrp_1/cgroup.procs
> >>       [ns]$ cat /proc/self/cgroup
> >>       0:cpuset,cpu,cpuacct,memory,devices,freezer,hugetlb:/sub_cgr=
p_1
> >>
> >>   (3) Each process gets its CGROUPNS specific view of
> >>       /proc/<pid>/cgroup.
> >>   (a) Processes running inside the cgroup namespace will be able t=
o see
> >>       cgroup paths (in /proc/self/cgroup) only inside their root c=
group
> >>       [ns]$ sleep 100000 &  # From within unshared cgroupns
> >>       [1] 7353
> >>       [ns]$ echo 7353 > sub_cgrp_1/cgroup.procs
> >>       [ns]$ cat /proc/7353/cgroup
> >>       0:cpuset,cpu,cpuacct,memory,devices,freezer,hugetlb:/sub_cgr=
p_1
> >>
> >>   (b) From global cgroupns, the real cgroup path will be visible:
> >>       $ cat /proc/7353/cgroup
> >>       0:cpuset,cpu,cpuacct,memory,devices,freezer,hugetlb:/batchjo=
bs/c_job_id1/sub_cgrp_1
> >>
> >>   (c) From a sibling cgroupns, the real path will be visible:
> >>       [ns2]$ cat /proc/7353/cgroup
> >>       0:cpuset,cpu,cpuacct,memory,devices,freezer,hugetlb:/batchjo=
bs/c_job_id1/sub_cgrp_1
> >>       (In correct container setup though, it should not be possibl=
e to
> >>        access PIDs in another container in the first place. This c=
an be
> >>        detected changed if desired.)
> >>
> >>   (4) Processes inside a cgroupns are not allowed to move out of t=
he
> >>       cgroupns-root. This is true even if a privileged process in =
global
> >>       cgroupns tries to move the process out of its cgroupns-root.
> >>
> >>       # From global cgroupns
> >>       $ cat /proc/7353/cgroup
> >>       0:cpuset,cpu,cpuacct,memory,devices,freezer,hugetlb:/batchjo=
bs/c_job_id1/sub_cgrp_1
> >>       # cgroupns-root for 7353 is /batchjobs/c_job_id1
> >>       $ echo 7353 > batchjobs/c_job_id2/cgroup.procs
> >>       -bash: echo: write error: Operation not permitted
> >>
> >>   (5) setns() is not supported for cgroup namespace in the initial
> >>       version.
> >
> > This combined with the full-path reporting for peer ns cgroups coul=
d make
> > for fun antics when attaching to an existing container (since we'd =
have
> > to unshare into a new ns cgroup with the same roto as the container=
).
> > I understand you are implying this will be fixed soon though.
> >
>=20
> I am thinking the setns() will be only allowed if
> target_cgrpns->cgroupns_root is_descendant_of
> current_cgrpns->cgroupns_root. i.e., you will only be setns to a
> cgroup namespace which is rooted deeper in hierarchy than your own (i=
n
> addition to checking capable_wrt_inode_uidgid(target_cgrpns_inode)).

Certainly.

> In addition to this, we need to decide whether its OK for setns() to
> also change the cgroup of the task. Consider following example:
>=20
> [A] ----> [B] ----> C
>     ----> D
>=20
> [A] and [B] are cgroupns-roots. Now, if a task in Cgroup D (which is
> under cgroupns [A]) attempts to setns() to cgroupns [B], then its
> cgroup should change from /A/D to /A/B. I am concerned about the
> side-effects this might cause. Though otherwise, this is a very usefu=
l
> feature for containers. One could argue that this is similar to
> setns() to a mount-namespace which is pivot_root'd somewhere else (in
> which case, the attaching task's root "/" moves implicitly with
> setns).

This is what I'd expect.

> Alternatively, we could only allow setns() if
> target_cgrpns->cgroupns_root =3D=3D current->cgroup . I.e., taking ab=
ove
> example again, if process in Cgroup D wants to setns() to cgroupns
> [B], then it will first need to move to Cgroup B, and only then the
> setns() will succeed. This makes sure that there is no implicit cgrou=
p
> move.

I'm ok with the restriction if it makes the patchset easier for you -
i.e. you not having to man-handle me into another cgroup.  Though I
wouldn't expect the locking for that to be an obstacle...

> WDYT? I haven't prototyped this yet, but will send out a patch after
> this series is accepted.

Either one is fine with me.

> >>   (6) When some thread from a multi-threaded process unshares its
> >>       cgroup-namespace, the new cgroupns gets applied to the entir=
e
> >>       process (all the threads). This should be OK since
> >>       unified-hierarchy only allows process-level containerization=
=2E So
> >>       all the threads in the process will have the same cgroup. An=
d both
> >>       - changing cgroups and unsharing namespaces - are protected =
under
> >>       threadgroup_lock(task).
> >>
> >>   (7) The cgroup namespace is alive as long as there is atleast 1
> >>       process inside it. When the last process exits, the cgroup
> >>       namespace is destroyed. The cgroupns-root and the actual cgr=
oups
> >>       remain though.
> >>
> >> Implementation
> >>   The current patch-set is based on top of Tejun's cgroup tree (fo=
r-next
> >>   branch). Its fairly non-intrusive and provides above mentioned
> >>   features.
> >>
> >> Possible extensions of CGROUPNS:
> >>   (1) The Documentation/cgroups/unified-hierarchy.txt mentions use=
 of
> >>       capabilities to restrict cgroups to administrative users. CG=
roup
> >>       namespaces could be of help here. With cgroup namespaces, it=
 might
> >>       be possible to delegate administration of sub-cgroups under =
a
> >>       cgroupns-root to the cgroupns owner.
> >
> > That would be nice.
> >
> >>   (2) Provide a cgroupns specific cgroupfs mount. i.e., the follow=
ing
> >>       command when ran from inside a cgroupns should only mount th=
e
> >>       hierarchy from cgroupns-root cgroup:
> >>       $ mount -t cgroup cgroup <cgroup-mountpoint>
> >>       # -o __DEVEL__sane_behavior should be implicit
> >>
> >>       This is similar to how procfs can be mounted for every PIDNS=
=2E This
> >>       may have some usecases.
> >
> > Sorry - I see this answers the first part of a question in my previ=
ous email.
> > However, the question of whether changes to limits in cgroups which=
 are not
> > under our cgroup-ns-root are allowed.
> >
> > Admittedly the current case with cgmanager is the same - in that it=
 depends
> > on proper setup of the container - but cgmanager is geared to recom=
mend
> > not mounting the cgroups in the container at all (and we can reject=
 such
> > mounts in the contaienr altogether with no loss in functionality) w=
hereas
> > you are here encouraging such mounts.  Which is fine - so long as y=
ou then
> > fully address the potential issues.
>=20
> It will be nice to have this, but frankly, it may add a bit of
> complexity in the cgroup/kernfs code (I will have to prototype and
> see). Also same behavior can be obtained simply by bind-mounting
> cgroupns-root inside the container. So I am currently inclining
> towards rejecting such mounts in favor of simplicity.

Not having to track what to bind-mount where is a very nice
simplification though.  In lxc with cgmanager, we are now able to alway=
s
simply bind-mount /sys/fs/cgroup/cgmanager from the host into the
container.  Nothing more needed for the container to be able to manage
its own cgroup and start its own containers.  Likewise, if mount -t
cgroup were filtered to cgroupns, then lxc could simply not mount
anything into the container at all.  If it mount -t cgroup is not
filtered wrt cgroupns, then we'd have to go back to, at container start=
,
finding the mountpoint for every subsystem, calculating the container's
cgroup there, and bind-mounting them into the container.

> Regarding disallowing writes to cgroup files outside of your
> cgroupns-root, I think it should possible implement it easily. I will
> include it in the next revision of this series.

Great - thanks.

-serge
