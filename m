From: ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org (Eric W. Biederman)
Subject: Re: [PATCHv2 7/7] cgroup: mount cgroupns-root when inside non-init cgroupns
Date: Fri, 31 Oct 2014 19:59:45 -0700
Message-ID: <87a94blj6m.fsf@x220.int.ebiederm.org>
References: <1414783141-6947-1-git-send-email-adityakali@google.com>
	<1414783141-6947-8-git-send-email-adityakali@google.com>
	<CALCETrXTaZ3SJ_t-gnbc93BVZXg-912NqO78kFd0Tpi-5-dZoQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CALCETrXTaZ3SJ_t-gnbc93BVZXg-912NqO78kFd0Tpi-5-dZoQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
	(Andy Lutomirski's message of "Fri, 31 Oct 2014 17:07:51 -0700")
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Cc: Aditya Kali <adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Serge Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "linux-kernel@vger.kernel.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, Rohit Jnagal <jnagal-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org> writes:
>> @@ -1862,6 +1904,7 @@ static struct file_system_type cgroup_fs_type = {
>>         .name = "cgroup",
>>         .mount = cgroup_mount,
>>         .kill_sb = cgroup_kill_sb,
>> +       .fs_flags = FS_USERNS_MOUNT,
>
> Aargh, another one!  Eric, can you either ack or nack my patch?
> Because if my patch goes in, then this line may need to change.  Or
> not, but if a stable release with cgroupfs and without my patch
> happens, then we'll have an ABI break.

cgroupfs has no device nodes.  So as long as we are consistent in any
given release what happens here is orthogonal.

I don't remember if we have managed to get the original problem fixed
with the trivial backportable solution.  I think so.

My apologies for not getting to that I haven't even had time to shepherd
through the regression associated regression fix.  I probably just lock
track of them but I haven't found the Tested-By's for it yet.

Nor have I had time to dig through and figure out how to safely deal
with umount -l aka MOUNT_DETACH.

Along with the question about what to do with nodev, there is also
your patch about nosuid.

Starting in about 5 minutes I am going to be mostly offline until
sometime in the 3rd week in November as I haul all of my stuff accross
the country to someplace that actually has winter and my allergies don't
kill me.

I am going to have to review and merge a lot of code as soon as I am
back to being a programmer full time again.  There is a lot of
interesting stuff coming in right now.

Eric
