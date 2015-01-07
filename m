From: ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org (Eric W. Biederman)
Subject: Re: [PATCHv3 8/8] cgroup: Add documentation for cgroup namespaces
Date: Wed, 07 Jan 2015 17:02:17 -0600
Message-ID: <878uhe42km.fsf@x220.int.ebiederm.org>
References: <CAGr1F2HA6mzFwgp5ngX8P7=198-5CmCjLmuCJ8j3eQ08J2d9Qw@mail.gmail.com>
	<54AB15BD.8020007@nod.at> <87lhlgpyxk.fsf@x220.int.ebiederm.org>
	<CAGr1F2HSi_D07r2c5CKOsjSR1+58k9G2MrtACsd+HV6XKvJ7cA@mail.gmail.com>
	<54AB2992.6060707@nod.at>
	<CAGr1F2EGOUSEd3-G4PS0mq=9kU1nWG4CwHUOQaNUATepc11_Sw@mail.gmail.com>
	<54ACFC38.5070007@nod.at> <87fvbmir9q.fsf@x220.int.ebiederm.org>
	<20150107193059.GA1857@mail.hallyn.com>
	<87bnma6xwv.fsf@x220.int.ebiederm.org>
	<20150107224430.GA28414@htj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150107224430.GA28414-Gd/HAXX7CRxy/B6EtB590w@public.gmane.org> (Tejun Heo's message of
	"Wed, 7 Jan 2015 17:45:11 -0500")
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, Serge Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, "linux-kernel@vger.kernel.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, cgroups mailinglist <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> writes:

> On Wed, Jan 07, 2015 at 04:14:40PM -0600, Eric W. Biederman wrote:
>> I see what you mean.  If it is indeed the case than a mount of cgroupfs
>> using the unified hiearchy and can not specify which controllers are
>> present under that mount that very significant bug and presents a very
>> significant regression in user space flexibility.
>
> The parent always controls which controllers are made available at the
> children level.  Only if the parent enables a controller, its
> children, whether they're namespaces or not, can choose to further
> distribute resources using that controller.  It's a straight-forward
> top-down thing.

Ignoring namespace details for a moment. The following should be
possible with a unified hierarchy.  If it is not it is a show stopper
of a regression.

mount -t tmpfs none /sys/fs/cgroup
(cd /sys/fs/cgroup ; mkdir cpu cpuacct devices memory)
mount -t cgroupfs -o cpu /sys/fs/cgroup/cpu
mount -t cgroupfs -o cpuacct /sys/fs/cgroup/cpuacct
mount -t cgroupfs -o devices /sys/fs/cgroup/devices
mount -t cgroupfs -o memory /sys/fs/cgroup/memory

With the expectation that only the control files for the specified
controllers show up in those mounts.

That is a unified hierarchy is fine.  Requiring that there only be one
mount point and that every one use it is not ok and it actively a problem.

It is absolutely required to be able to avoid b0rked controllers, and
to my knowledge the only way to do that is to have multiple mounts where
we pick the controller on each mount.   Even if there is now a way that
doesn't require multiple mounts to keep b0rked controllers from being
enabled multiple mounts still need to work to support the existing
userspace programs.

This discussion is happening because Documentation/cgroups/unified-hierarchy.txt
implies the configuration I have just described will not work with
unified hierachies enabled.

Eric
