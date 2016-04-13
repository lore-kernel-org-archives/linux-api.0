From: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC PATCH] cgroup namespaces: add a 'nsroot=' mountinfo field
Date: Wed, 13 Apr 2016 18:52:40 -0500
Message-ID: <20160413235240.GA921@mail.hallyn.com>
References: <20160321234133.GA22463@mail.hallyn.com>
 <20160413175736.GC3676@htj.duckdns.org>
 <20160413184639.GA29483@mail.hallyn.com>
 <20160413185033.GH3676@htj.duckdns.org>
 <20160413190152.GA29753@mail.hallyn.com>
 <CAGr1F2HXJ1BdMFY+vF40O_khE+4S7OnbQPv-h1Q_AmGGhL7mzw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAGr1F2HXJ1BdMFY+vF40O_khE+4S7OnbQPv-h1Q_AmGGhL7mzw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Aditya Kali <adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Containers <containers-qjLDD68F18O7TbgM5vRIOg@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, cgroups mailinglist <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Quoting Aditya Kali (adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org):
> On Wed, Apr 13, 2016 at 12:01 PM, Serge E. Hallyn <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org> wrote:
> > Quoting Tejun Heo (tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org):
> >> Hello, Serge.
> >>
> >> On Wed, Apr 13, 2016 at 01:46:39PM -0500, Serge E. Hallyn wrote:
> >> > It's not a leak of any information we're trying to hide.  I realize
> >> > something like 8 years have passed, but I still basically go by the
> >> > ksummit guidance that containers are ok but the kernel's first priority
> >> > is to facilitate containers but not trick containers into thinking
> >> > they're not containerized.  So long as the container is properly set
> >> > up, I don't think there's anything the workload could do with the
> >> > nsroot= info other than *know* that it is in a ns cgroup.
> >> >
> >> > If we did change that guidance, there's a slew of proc info that we
> >> > could better virtualize :)
> >>
> >> I see.  I'm just wondering because the information here seems a bit
> >> gratuituous.  Isn't the only thing necessary telling whether the root
> >> is bind mounted or namescoped?  Wouldn't simple "nsroot" work for that
> >> purpose?
> >
> > I don't think so - we could be in a cgroup namespace but still have
> > access only to bind-mounted cgroups.  So we need to compare the
> > superblock dentry root field to the nsroot= value.
> 
> Umm, I don't think this is such a good idea. The main purpose of
> cgroup namespace was to prevent this exposure of system cgroup
> hierarchy that used to happen because of /proc/self/cgroup. Wouldn't
> showing that information in /proc/self/mountinfo defeat the purpose?

I disagree.  The primary purpose was to simplify init's job and to keep
cgroup mounts in sync with /proc/self/cgroup.  So that userspace doesn't
have to look at /proc/self/cgroup and then try and figure out how that
relates to its actual cgroup mountpoints.  It was not to *hide* the
information.

Field 3 already gives us the path, nsroot just tells us what part of
it we are namespaced under.

> > One practical problem I've found with cgroup namespaces is that there
> > is no way to disambiguate between a cgroupfs mount which was done in
> > a cgroup namespace, and a bind mount of a cgroupfs directory.
> 
> Thats actually by design, no? Namespaced apps should not know/care if
> they are running inside namespace. If they can find it out today, its

No.  If a workload isn't allowed to mount its own cgroups, and can only
see that freezer /lxc/x1 was mounted at /dev/cgroup (poorly done, but we
don't get to pass judgement or choose mountpoints for userspace), and
it sees /lxc/x1 in its freezer entry for /proc/self/cgroup, then it
cannot tell whether it should be using /dev/cgroup/tasks or
/dev/cgroup/lxc/tasks or /dev/cgroup/lxc/x1/tasks.  That's a problem.

> just because of certain side-effects. I fear adding explicit "nsroot"
> or something in /proc/self/mountinfo now becomes an API making it hard
> to virtualize user-apps again.

It doesn't make it hard to virtualize.  The only complication would be
if you wanted to checkpoint/restart and reproduce the exact
/proc/self/mountinfo output.  That's a bogus goal anyway, since the
restart could be in a different cgroup and field 3 would be different.

In contrast, not providing this makes it impossible for software to
deal with both cgroup namespace and any bind-mounted cgroups.  Which
means any new docker (say) which can run in cgroup namespaces will
not be able to run under old (that is, anything currently released
except lxc 2.0) container managers.  We're breaking all container
managers.

Now the other thing we could do would be to tweak field 3 in the
mountinfo output.  That had been my first inclination, but the way
the mountinfo code is currently done makes that ... challenging.

-serge
