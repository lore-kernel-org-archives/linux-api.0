From: ebiederm@xmission.com (Eric W. Biederman)
Subject: Re: [PATCH] cgroup namespaces: add a 'nsroot=' mountinfo field
Date: Thu, 14 Apr 2016 11:43:05 -0500
Message-ID: <877fg05eg6.fsf@x220.int.ebiederm.org>
References: <20160321234133.GA22463@mail.hallyn.com>
	<20160413175736.GC3676@htj.duckdns.org>
	<20160414040436.GA3739@mail.hallyn.com>
	<87oa9c6ymf.fsf@x220.int.ebiederm.org>
	<20160414152747.GA12700@mail.hallyn.com>
	<877fg06uf9.fsf@x220.int.ebiederm.org>
	<20160414163839.GA14605@mail.hallyn.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160414163839.GA14605@mail.hallyn.com> (Serge E. Hallyn's
	message of "Thu, 14 Apr 2016 11:38:39 -0500")
Sender: linux-kernel-owner@vger.kernel.org
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: Tejun Heo <tj@kernel.org>, linux-api@vger.kernel.org, adityakali@google.com, Linux Containers <containers@lists.osdl.org>, cgroups@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

"Serge E. Hallyn" <serge@hallyn.com> writes:

> Quoting Eric W. Biederman (ebiederm@xmission.com):
>> "Serge E. Hallyn" <serge@hallyn.com> writes:
>> 
>> > Quoting Eric W. Biederman (ebiederm@xmission.com):
>> >> "Serge E. Hallyn" <serge@hallyn.com> writes:
>> >> 
>> >> > This is so that userspace can distinguish a mount made in a cgroup
>> >> > namespace from a bind mount from a cgroup subdirectory.
>> >> 
>> >> To do that do you need to print the path, or is an extra option that
>> >> reveals nothing except that it was a cgroup mount sufficient?
>> >> 
>> >> Is there any practical difference between a mount in a namespace and a
>> >> bind mount?
>> >> 
>> >> Given the way the conversation has been going I think it would be good
>> >> to see the answers to these questions.  Perhaps I missed it but I
>> >> haven't seen the answers to those questions.
>> >
>> > Yup, I tried to answer those in my last email, let me try again.
>> >
>> > Let's say I start a container using cgroup namespaces, /lxc/x1.  It mounts
>> > freezer at /sys/fs/cgroup so it has field three of mountinfo as /lxc/x1,
>> > and /sys/fs/cgroup/ is the path to the container's cgroup (/lxc/x1).  In
>> > that container, I start another container x1, not using cgroup namespaces.
>> > It also wants a cgroup mount, and a common way to handle that (to prevent
>> > container rewriting its limits) is to mount a tmpfs at /sys/fs/cgroup,
>> > create /sysfs/cgroup/lxc/x1, and bind mount /sys/fs/cgroup/lxc/x1 from
>> > the parent container onto /sys/fs/cgroup/lxc/x1 in the child container.
>> > Now for that bind mount, the mountinfo field 3 will show /lxc/x1/lxc/x1,
>> > with mount target /sys/fs/cgroup/lxc/x1, while /proc/self/cgroup for a task
>> > in that container will show '/lxc/x1'.  Unless it has been moved into
>> > /lxc/x1/lxc/x1 in the container (/lxc/x1/lxc/x1/lxc/x1 on the host)...
>> > Every time I've thought "maybe we can just..." I've found a case where it
>> > wouldn't work.
>> >
>> > At first in lxc we simply said if /proc/self/ns/cgroup exists assume that
>> > the cgroupfs mounts are not bind mounts.  However, old userspace (and
>> > container drivers) on new kernels is certainly possible, especially an
>> > older distro in a container on a newer distro on the host.  That completely
>> > breaks with this approach.
>> >
>> > I also personally think there *is* value in letting a task know its
>> > place on the system, so hiding the full cgroup path is imo not only not
>> > a valid goal, it's counter-productive.  Part of making for better
>> > virtualization is to give userspace all the info it needs about its
>> > current limits.  Consider that with the unified hierarchy, you cannot
>> > have tasks in a cgroup that also has child cgroups - except for the
>> > root.  Cgroup namespaces do not make an exception for this, so knowing
>> > that you are not in the absolute cgroup root actually can prevent you
>> > from trying something that cannot work.  Or, I suppose, at least
>> > understanding why you're unable to do what you're trying to do (namely
>> > your container manager messed up).  I point this out because finding
>> > a way to only show the namespaced root in field 3 of mountinfo would
>> > fix the base problem, but at the cost of hiding useful information
>> > from a container.
>> 
>> It is just the superblock show_path method.  And regardless of the rest
>> of the usefullness of your mount option implementing show_path appears
>
> Ugh.  Yeah as I've said implementing that would be the other way to go.
> I'm somewhat loath to give up the extra information, but I can work
> on that patch later this week.

It sounded like you couldn't see how to implement that which is slightly
different.

>> to be fundamentally the right thing in this context.  As that field
>> appears to have the same issue as /proc/self/cgroup.
>
> Well, /proc/self/cgroup could also have been fixed by adding a
> ':<nsroot>" field to each line, but it's used differently...

Usage may be a reasonable justification.  Mostly I am trying to pry
apart the chaos.  Not shoot down one approach or another.

My current perspective is that irrespective of what we do with
a informational mount option (and there seems to be value in that)
having mountinfo show the path relative to root, will allow more
software to just work without modification.

And old software just working when it can seem very valuable.

Eric
