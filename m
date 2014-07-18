From: Serge Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 0/5] RFC: CGroup Namespaces
Date: Fri, 18 Jul 2014 16:00:04 +0000
Message-ID: <20140718160004.GC20686@ubuntumail>
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

Hi,

So right now we basically do this in userspace using cgmanager.  Each
container/chroot/whatever that has a cgproxy is 'locked' under that
proxy's cgroup.  So if root in a container asks the cgproxy for the
cgroup of pid 2000, and cgproxy is in /lxc/u1 while pid 2000 in the
container is in /lxc/u1/service1, then the response will be '/service1'=
=2E
Same happens with creating cgroups, moving pids into cgroups, etc.

(Hoping to take a close look at this set early next week)

-serge
