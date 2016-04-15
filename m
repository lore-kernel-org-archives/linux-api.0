From: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cgroup namespaces: add a 'nsroot=' mountinfo field
Date: Fri, 15 Apr 2016 11:02:51 -0500
Message-ID: <20160415160251.GA32508@mail.hallyn.com>
References: <20160321234133.GA22463@mail.hallyn.com>
 <20160413175736.GC3676@htj.duckdns.org>
 <20160414040436.GA3739@mail.hallyn.com>
 <87oa9c6ymf.fsf@x220.int.ebiederm.org>
 <20160414152747.GA12700@mail.hallyn.com>
 <CAGr1F2EZtts38SPDc9cuH1prc6NfUJiwUQmqyRp-RpNYM5UzxA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAGr1F2EZtts38SPDc9cuH1prc6NfUJiwUQmqyRp-RpNYM5UzxA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Aditya Kali <adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Containers <containers-qjLDD68F18O7TbgM5vRIOg@public.gmane.org>, cgroups mailinglist <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Quoting Aditya Kali (adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org):
> On Thu, Apr 14, 2016 at 8:27 AM, Serge E. Hallyn <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org> wrote:
> > Quoting Eric W. Biederman (ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org):
> >> "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org> writes:
> >>
> >> > This is so that userspace can distinguish a mount made in a cgroup
> >> > namespace from a bind mount from a cgroup subdirectory.
> >>
> >> To do that do you need to print the path, or is an extra option that
> >> reveals nothing except that it was a cgroup mount sufficient?
> >>
> >> Is there any practical difference between a mount in a namespace and a
> >> bind mount?
> >>
> >> Given the way the conversation has been going I think it would be good
> >> to see the answers to these questions.  Perhaps I missed it but I
> >> haven't seen the answers to those questions.
> >
> > Yup, I tried to answer those in my last email, let me try again.
> >
> > Let's say I start a container using cgroup namespaces, /lxc/x1.  It mounts
> > freezer at /sys/fs/cgroup so it has field three of mountinfo as /lxc/x1,
> > and /sys/fs/cgroup/ is the path to the container's cgroup (/lxc/x1).  In
> > that container, I start another container x1, not using cgroup namespaces.
> > It also wants a cgroup mount, and a common way to handle that (to prevent
> > container rewriting its limits) is to mount a tmpfs at /sys/fs/cgroup,
> > create /sysfs/cgroup/lxc/x1, and bind mount /sys/fs/cgroup/lxc/x1 from
> > the parent container onto /sys/fs/cgroup/lxc/x1 in the child container.
> > Now for that bind mount, the mountinfo field 3 will show /lxc/x1/lxc/x1,
> > with mount target /sys/fs/cgroup/lxc/x1, while /proc/self/cgroup for a task
> > in that container will show '/lxc/x1'.  Unless it has been moved into
> > /lxc/x1/lxc/x1 in the container (/lxc/x1/lxc/x1/lxc/x1 on the host)...
> > Every time I've thought "maybe we can just..." I've found a case where it
> > wouldn't work.
> >
> > At first in lxc we simply said if /proc/self/ns/cgroup exists assume that
> > the cgroupfs mounts are not bind mounts.  However, old userspace (and
> > container drivers) on new kernels is certainly possible, especially an
> > older distro in a container on a newer distro on the host.  That completely
> > breaks with this approach.
> >
> 
> My main concern regarding making this a new kernel API is that its too
> generic and exposes information about all system cgroups to every
> process on the system, not just the container or the process inside it
> that needs it. Not all containers need this information and not all
> processes running inside the container needs this. I haven't spent too
> much thought into it, but it seems you will still need to update the
> container userspace to read this extra mount option. So seems like a
> simpler approach where the host "cgroup manager" provides this
> information to specific container cgroup manager via other user-space
> channels (a config file, command-line args, environment vars, proper
> container mounts, etc.) may also work, right?

No, because existing legacy userspace would need to be taught about
these new channels.

I'm testing a new patch which simply fixes the root dentry field in
mountinfo, which should also serve to fix this problem without adding
the nsroot= option field.
