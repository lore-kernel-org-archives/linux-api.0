From: Serge Hallyn <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 7/8] cgroup: Add documentation for cgroup namespaces
Date: Mon, 28 Dec 2015 13:13:02 -0800
Message-ID: <1451337182.3374.34.camel@Nokia-N900>
References: <1450844609-9194-1-git-send-email-serge.hallyn@ubuntu.com>
	 <1450844609-9194-8-git-send-email-serge.hallyn@ubuntu.com>
	 <20151228174735.GB30165@mtj.duckdns.org>
Reply-To: Serge Hallyn <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151228174735.GB30165-qYNAdHglDFBN0TnZuCh8vA@public.gmane.org>
Content-ID: <1451337181.3374.33.camel@Nokia-N900>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lxc-devel-cunTk1MwBs9qMoObBWhMNEqPaTDuhLve2LY78lusg7I@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Mon Dec 28 2015 09:47:35 AM PST, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:

> Hello,
>=20
> I did some heavy editing of the documentation.=C2=A0=C2=A0=C2=A0=C2=A0=
  How does this look?

Thanks Tejun, just three things (which come from my version):

> Did I miss anything?
>=20
> Thanks.
> ---
>=C2=A0=C2=A0=C2=A0=C2=A0  Documentation/cgroup.txt |=C2=A0=C2=A0=C2=A0=
=C2=A0  146
> +++++++++++++++++++++++++++++++++++++++++++++++ 1 file changed, 146
> insertions(+)
>=20
> --- a/Documentation/cgroup.txt
> +++ b/Documentation/cgroup.txt
> @@ -47,6 +47,11 @@ CONTENTS
>=C2=A0 =C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0  5-3. IO
>=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0  5-3-1. IO Interf=
ace Files
>=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0  5-3-2. Writeback
> +6. Namespace
> +=C2=A0=C2=A0=C2=A0=C2=A0  6-1. Basics
> +=C2=A0=C2=A0=C2=A0=C2=A0  6-2. The Root and Views
> +=C2=A0=C2=A0=C2=A0=C2=A0  6-3. Migration and setns(2)
> +=C2=A0=C2=A0=C2=A0=C2=A0  6-4. Interaction with Other Namespaces
>=C2=A0=C2=A0=C2=A0=C2=A0  P. Information on Kernel Programming
>=C2=A0 =C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0  P-1. Filesystem Support for Wr=
iteback
>=C2=A0=C2=A0=C2=A0=C2=A0  D. Deprecated v1 Core Features
> @@ -1013,6 +1018,147 @@ writeback as follows.
>=C2=A0=C2=A0=C2=A0=C2=A0  =C2=A0=C2=A0=C2=A0 vm.dirty[_background]_rat=
io.
>=C2=A0=C2=A0=C2=A0=C2=A0 =20
>=C2=A0=C2=A0=C2=A0=C2=A0 =20
> +6. Namespace
> +
> +6-1. Basics
> +
> +cgroup namespace provides a mechanism to virtualize the view of the
> +"/proc/$PID/cgroup" file

and cgroup mounts

>.=C2=A0=C2=A0=C2=A0=C2=A0  The CLONE_NEWCGROUP clone flag can be used
> +with clone(2) and unshare(2) to create a new cgroup namespace.=C2=A0=
=C2=A0=C2=A0=C2=A0  The
> +process running inside the cgroup namespace will have its
> +"/proc/$PID/cgroup" output restricted to cgroupns root.=C2=A0=C2=A0=C2=
=A0=C2=A0  The cgroupns
> +root is the cgroup of the process at the time of creation of the
> +cgroup namespace.
> +
> +Without cgroup namespace, the "/proc/$PID/cgroup" file shows the
> +complete path of the cgroup of a process.=C2=A0=C2=A0=C2=A0=C2=A0  I=
n a container setup where
> +a set of cgroups and namespaces are intended to isolate processes th=
e
> +"/proc/$PID/cgroup" file may leak potential system level information
> +to the isolated processes.=C2=A0=C2=A0=C2=A0=C2=A0  For Example:
> +
> +=C2=A0=C2=A0=C2=A0=C2=A0  # cat /proc/self/cgroup
> +=C2=A0=C2=A0=C2=A0=C2=A0  0::/batchjobs/container_id1
> +
> +The path '/batchjobs/container_id1' can be considered as system-data
> +and undesirable to expose to the isolated processes.=C2=A0=C2=A0=C2=A0=
=C2=A0  cgroup namespace
> +can be used to restrict visibility of this path.=C2=A0=C2=A0=C2=A0=C2=
=A0  For example, before
> +creating a cgroup namespace, one would see:
> +
> +=C2=A0=C2=A0=C2=A0=C2=A0  # ls -l /proc/self/ns/cgroup
> +=C2=A0=C2=A0=C2=A0=C2=A0  lrwxrwxrwx 1 root root 0 2014-07-15 10:37 =
/proc/self/ns/cgroup ->
> cgroup:[4026531835] +=C2=A0=C2=A0=C2=A0=C2=A0  # cat /proc/self/cgrou=
p
> +=C2=A0=C2=A0=C2=A0=C2=A0  0::/batchjobs/container_id1
> +
> +After unsharing a new namespace, the view changes.
> +
> +=C2=A0=C2=A0=C2=A0=C2=A0  # ls -l /proc/self/ns/cgroup
> +=C2=A0=C2=A0=C2=A0=C2=A0  lrwxrwxrwx 1 root root 0 2014-07-15 10:35 =
/proc/self/ns/cgroup ->
> cgroup:[4026532183] +=C2=A0=C2=A0=C2=A0=C2=A0  # cat /proc/self/cgrou=
p
> +=C2=A0=C2=A0=C2=A0=C2=A0  0::/
> +
> +When some thread from a multi-threaded process unshares its cgroup
> +namespace, the new cgroupns gets applied to the entire process (all
> +the threads).=C2=A0=C2=A0=C2=A0=C2=A0  This is natural for the v2 hi=
erarchy; however, for the
> +legacy hierarchies, this may be unexpected.
> +
> +A cgroup namespace is alive as long as there are processes inside it=
=2E

Or mounts pinning it.

> +When the last process exits

or the last mount is umounted,

>, the cgroup namespace is destroyed.=C2=A0=C2=A0=C2=A0=C2=A0  The
> +cgroupns root and the actual cgroups remain.
> +
> +
> +6-2. The Root and Views
> +
> +The 'cgroupns root' for a cgroup namespace is the cgroup in which th=
e
> +process calling unshare(2) is running.=C2=A0=C2=A0=C2=A0=C2=A0  For =
example, if a process in
> +/batchjobs/container_id1 cgroup calls unshare, cgroup
> +/batchjobs/container_id1 becomes the cgroupns root.=C2=A0=C2=A0=C2=A0=
=C2=A0  For the
> +init_cgroup_ns, this is the real root ('/') cgroup.
> +
> +The cgroupns root cgroup does not change even if the namespace creat=
or
> +process later moves to a different cgroup.
> +
> +=C2=A0=C2=A0=C2=A0=C2=A0  # ~/unshare -c # unshare cgroupns in some =
cgroup
> +=C2=A0=C2=A0=C2=A0=C2=A0  # cat /proc/self/cgroup
> +=C2=A0=C2=A0=C2=A0=C2=A0  0::/
> +=C2=A0=C2=A0=C2=A0=C2=A0  # mkdir sub_cgrp_1
> +=C2=A0=C2=A0=C2=A0=C2=A0  # echo 0 > sub_cgrp_1/cgroup.procs
> +=C2=A0=C2=A0=C2=A0=C2=A0  # cat /proc/self/cgroup
> +=C2=A0=C2=A0=C2=A0=C2=A0  0::/sub_cgrp_1
> +
> +Each process gets its namespace-specific view of "/proc/$PID/cgroup"
> +
> +Processes running inside the cgroup namespace will be able to see
> +cgroup paths (in /proc/self/cgroup) only inside their root cgroup.
> +From within an unshared cgroupns:
> +
> +=C2=A0=C2=A0=C2=A0=C2=A0  # sleep 100000 &
> +=C2=A0=C2=A0=C2=A0=C2=A0  [1] 7353
> +=C2=A0=C2=A0=C2=A0=C2=A0  # echo 7353 > sub_cgrp_1/cgroup.procs
> +=C2=A0=C2=A0=C2=A0=C2=A0  # cat /proc/7353/cgroup
> +=C2=A0=C2=A0=C2=A0=C2=A0  0::/sub_cgrp_1
> +
> +From the initial cgroup namespace, the real cgroup path will be
> +visible:
> +
> +=C2=A0=C2=A0=C2=A0=C2=A0  $ cat /proc/7353/cgroup
> +=C2=A0=C2=A0=C2=A0=C2=A0  0::/batchjobs/container_id1/sub_cgrp_1
> +
> +From a sibling cgroup namespace (that is, a namespace rooted at a
> +different cgroup), the cgroup path relative to its own cgroup
> +namespace root will be shown.=C2=A0=C2=A0=C2=A0=C2=A0  For instance,=
 if PID 7353's cgroup
> +namespace root is at '/batchjobs/container_id2', then it will see
> +
> +=C2=A0=C2=A0=C2=A0=C2=A0  # cat /proc/7353/cgroup
> +=C2=A0=C2=A0=C2=A0=C2=A0  0::/../container_id2/sub_cgrp_1
> +
> +Note that the relative path always starts with '/' to indicate that
> +its relative to the cgroup namespace root of the caller.
> +
> +
> +6-3. Migration and setns(2)
> +
> +Processes inside a cgroup namespace can move into and out of the
> +namespace root if they have proper access to external cgroups

this really means two things - write DAC access to the cgroupfs files, =
and access to the directories through a cgroupfs mount.=C2=A0=C2=A0  No=
t sure if that should be spelled out.

>.=C2=A0=C2=A0=C2=A0=C2=A0  For
> +example, from inside a namespace with cgroupns root at
> +/batchjobs/container_id1, and assuming that the global hierarchy is
> +still accessible inside cgroupns:
> +
> +=C2=A0=C2=A0=C2=A0=C2=A0  # cat /proc/7353/cgroup
> +=C2=A0=C2=A0=C2=A0=C2=A0  0::/sub_cgrp_1
> +=C2=A0=C2=A0=C2=A0=C2=A0  # echo 7353 > batchjobs/container_id2/cgro=
up.procs
> +=C2=A0=C2=A0=C2=A0=C2=A0  # cat /proc/7353/cgroup
> +=C2=A0=C2=A0=C2=A0=C2=A0  0::/../container_id2
> +
> +Note that this kind of setup is not encouraged.=C2=A0=C2=A0=C2=A0=C2=
=A0  A task inside cgroup
> +namespace should only be exposed to its own cgroupns hierarchy.
> +
> +setns(2) to another cgroup namespace is allowed when:
> +
> +(a) the process has CAP_SYS_ADMIN against its current user namespace
> +(b) the process has CAP_SYS_ADMIN against the target cgroup
> +=C2=A0 =C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0  namespace's userns
> +
> +No implicit cgroup changes happen with attaching to another cgroup
> +namespace.=C2=A0=C2=A0=C2=A0=C2=A0  It is expected that the someone =
moves the attaching
> +process under the target cgroup namespace root.
> +
> +
> +6-4. Interaction with Other Namespaces
> +
> +Namespace specific cgroup hierarchy can be mounted by a process
> +running inside a non-init cgroup namespace.
> +
> +=C2=A0=C2=A0=C2=A0=C2=A0  # mount -t cgroup2 none $MOUNT_POINT
> +
> +This will mount the unified cgroup hierarchy with cgroupns root as t=
he
> +filesystem root.=C2=A0=C2=A0=C2=A0=C2=A0  The process needs CAP_SYS_=
ADMIN against its user and
> +mount namespaces.
> +
> +The virtualization of /proc/self/cgroup file combined with restricti=
ng
> +the view of cgroup hierarchy by namespace-private cgroupfs mount
> +provides a properly isolated cgroup view inside the container.
> +
> +
>=C2=A0=C2=A0=C2=A0=C2=A0  P. Information on Kernel Programming
>=C2=A0=C2=A0=C2=A0=C2=A0 =20
>=C2=A0=C2=A0=C2=A0=C2=A0  This section contains kernel programming inf=
ormation in the areas
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kerne=
l"
> in the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at=C2=A0=C2=A0=C2=A0=C2=A0  http://vger.kernel.or=
g/majordomo-info.html
> Please read the FAQ at=C2=A0=C2=A0=C2=A0=C2=A0  http://www.tux.org/lk=
ml/
