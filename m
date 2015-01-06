From: Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>
Subject: Re: [PATCHv3 8/8] cgroup: Add documentation for cgroup namespaces
Date: Wed, 07 Jan 2015 00:39:02 +0100
Message-ID: <54AC7216.30001@nod.at>
References: <1417744550-6461-1-git-send-email-adityakali@google.com> <1417744550-6461-9-git-send-email-adityakali@google.com> <548E17CE.8010704@nod.at> <CAGr1F2HA6mzFwgp5ngX8P7=198-5CmCjLmuCJ8j3eQ08J2d9Qw@mail.gmail.com> <54AB15BD.8020007@nod.at> <87lhlgpyxk.fsf@x220.int.ebiederm.org> <CAGr1F2HSi_D07r2c5CKOsjSR1+58k9G2MrtACsd+HV6XKvJ7cA@mail.gmail.com> <54AB2992.6060707@nod.at> <CAGr1F2EGOUSEd3-G4PS0mq=9kU1nWG4CwHUOQaNUATepc11_Sw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAGr1F2EGOUSEd3-G4PS0mq=9kU1nWG4CwHUOQaNUATepc11_Sw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Aditya Kali <adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Serge Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, cgroups mailinglist <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, Rohit Jnagal <jnagal-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Am 07.01.2015 um 00:20 schrieb Aditya Kali:
> I understand your point. But it will add some complexity to the code.
> 
> Before trying to make it work for non-unified hierarchy cases, I would
> like to get a clearer idea.
> What do you expect to be mounted when you run:
>   container:/ # mount -t cgroup none /sys/fs/cgroup/
> from inside the container?

I expect cgroupfs to behave exactly as it would in the initial namespace.
Such that the container can do with it whatever it wants.
systemd mounts and manages cgroups on its own.
Like for CONFIG_DEVPTS_MULTIPLE_INSTANCES.

If a new cgroup namespace cannot provide a clean and autonomous cgroupfs
instance it is fundamentally flawed.
You cannot provide a namespace mechanism which depends on the host side
that much.
This will also horrible break container migrations between hosts.
i.e. Migrate a container from a Ubuntu host to a Fedora (systemd!) host.

> Note that cgroup-namespace wont be able to change the way cgroups are
> mounted .. i.e., if say cpu and cpuacct subsystems are mounted
> together at a single mount-point, then we cannot mount them any other
> way (inside a container or outside). This restriction exists today and
> cgroup-namespaces won't change that.

Why can't cgroup namespace change this?
I think of cgroup namespace as a new and clean cgroupfs instance which inherits
all limits from the outside.

> So, If on the host we have:
> root@adityakali-vm2:/sys/fs/cgroup# cat /proc/mounts | grep cgroup
> tmpfs /sys/fs/cgroup tmpfs rw,relatime 0 0
> cgroup /sys/fs/cgroup/cpu cgroup rw,relatime,cpuset,cpu,cpuacct 0 0
> cgroup /sys/fs/cgroup/mem cgroup rw,relatime,memory,hugetlb 0 0
> cgroup /sys/fs/cgroup/rest cgroup
> rw,relatime,devices,freezer,net_cls,blkio,perf_event,net_prio 0 0
> 
> And inside the container we want each subsystem to be on its own
> mount-point, then it will fail. Do you think even then its useful to
> support virtualizing paths for non-unified hierarchies?

As I've stated above I expect from cgroup namespaces a clean and sane
cgroupfs instance no matter how the outer mounts are.

Thanks,
//richard
