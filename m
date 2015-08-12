From: ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org (Eric W. Biederman)
Subject: Re: [CFT][PATCH 09/10] sysfs: Create mountpoints with sysfs_create_empty_dir
Date: Tue, 11 Aug 2015 19:37:32 -0500
Message-ID: <87fv3pe3zn.fsf@x220.int.ebiederm.org>
References: <87pp63jcca.fsf@x220.int.ebiederm.org>
	<878ucrhxi9.fsf@x220.int.ebiederm.org>
	<20150811184426.GH23408@mtj.duckdns.org>
	<877fp1hcuj.fsf@x220.int.ebiederm.org>
	<CAOS58YOHU8SFv4UXeBRr4t88UU=DXQCPg2HU_dMBmgM7WBB1zQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAOS58YOHU8SFv4UXeBRr4t88UU=DXQCPg2HU_dMBmgM7WBB1zQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
	(Tejun Heo's message of "Tue, 11 Aug 2015 16:11:55 -0400")
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, LINUXFS-ML <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, Kenton Varda <kenton-AuYgBwuPrUQTaNkGU808tA@public.gmane.org>, Michael Kerrisk-manpages <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, =?utf-8?Q?St=C3=A9phane?= Graber <stgraber-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, Eric Windisch <ewindisch-FCduhRhOUaTQT0dZR+AlfA@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> writes:

> Hey,
>
> On Tue, Aug 11, 2015 at 2:57 PM, Eric W. Biederman
> <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org> wrote:
>>> So, this somehow ends up confusing upstart on centos6 based systems
>>> making it fail to mount tmpfs on /sys/fs/cgroup.  It also skips sunrpc
>>> and other mounts are different too.  No idea why at this point.  Can
>>> we please revert this from -stable until we know what's going on?
>>
>> *Boggle*
>>
>> The only time this should prevent anything is when in a container when
>> you are not global root.  And then only mounting sysfs should be
>> affected.
>
> This is just plain boot. No namespace involved.
>
>> The only difference in executed code really should be setting an extra
>> flag on the kernfs, inode.  The kernfs changes will also refuse to add
>> entries to these directories (but these directories are empty).
>
> Why do we have this in -stable then? Is this part of a larger fix?

It is. This patch is part of the prep work to prevent unprivileged users
not mounting sysfs (using user namespace permissions) when they should
not be allowed to.

>> If this is causing problems I don't have a problem with a revert but
>> reverts take a minute, and this seems to be the first report of this
>> kind.  Can we take a minute and attempt to get a coherent explanation.
>>
>> It should be a matter of moments to debug this
>> issue (once a test environment is setup), and see what is wrong and then
>> we can act intelligently.  Tracing a single system call is not difficult.
>
> I'm already out today so it'll have to wait till tomorrow.
>
>> If there really is some weird issue I want to know what it is.
>
> Sure, but you wanna do that in -stable?

Before fixing anything I want a bug report that is clear enough
to be reproducible.

I just went and attempted to reproduce this, and on RHEL6 workstation
(aka my work laptop), using the todays 4.2.0-rc6+ aka
edf15b4d4b01b565cb5f4fd2e2d08940b9f92e2f and all of the mounts in
/proc/self/mounts are the same between 4.2.0-rc6 and the RHEL6 stock
2.6.32-504.30.3.el6.x86_64, including the cgroups mounted on /cgroup.

Which means that I don't have any reason to believe that normal CentOS 6
is broken.

Which -stable kernel are you having problems with?  Perhaps it was
a broken backport?

Is it possible this is a local CentOS 6 hack that is breaking?
Perhaps a patch you apply on top of your -stable kernel?

Certainly with cgroups expected to be mounted at /sys/fs/cgroup there
has clearly been at least one change from the stock configuration.

I think it is a little less serious if stock CentOS 6 doesn't have
problems.  Unless it is a conflict of kernel patches I definitely think
whatever it is needs to be fixed.

Eric
