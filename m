From: Aditya Kali <adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 2/5] sched: new clone flag CLONE_NEWCGROUP for cgroup namespace
Date: Thu, 31 Jul 2014 12:48:43 -0700
Message-ID: <CAGr1F2FAiSFR_Y3t1=eBVoAtJvh4m=cNUi+vG146nDkgtBjisQ@mail.gmail.com>
References: <1405626731-12220-1-git-send-email-adityakali@google.com>
 <1405626731-12220-3-git-send-email-adityakali@google.com> <20140724170119.GR26600@ubuntumail>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140724170119.GR26600@ubuntumail>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Serge Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thu, Jul 24, 2014 at 10:01 AM, Serge Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org> wrote:
> Quoting Aditya Kali (adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org):
>> CLONE_NEWCGROUP will be used to create new cgroup namespace.
>>
>
> This is fine and I'm not looking to bikeshed, but am wondering - did
> you consider any other ways beside unshare (i.e. a new mount option
> to cgroupfs)?  If so, do you have a list of the downsides of those?
> (I mainly ask bc clone flags are still a scarce commodity)
>

I did consider couple of other ways:

(1) having a cgroup.ns_root (or something) cgroup file. If this value
is '1', it would mean that all processes it and its descendant cgroups
will have their cgroup paths in /proc/self/cgroup terminated at this
cgroup.
 For ex:
[A] --> [B] --> C
    | --> [D] --> E

[A], [B] and [D] has cgroup.ns_root = 1.
* all processes in cgroup C & E will see their cgroup path as /C and
/E respectively
* all processes in cgroup B & D will see their own cgroup path as /

In this model, its easy to know what to show if process is looking at
its own cgroup paths (/proc/self/cgroup). It gets tricky when you are
looking at other process's /proc/<pid>/cgroup. We may be able to come
up with some hacky way read correct value, but depending on the
cgroupfs mount, it may not make sense.
One other major drawback of this approach is that "every" process in
the cgroup will now get a restricted view. i.e., you cannot change
cgroups without affecting your view. And this is undesirable for
administrative processes.

(2) Another idea that I didn't pursue further (and is a bit hacky as
above) was having cgroup.ns_procs (like cgroup.procs, but all the pids
in cgroup.ns_procs will have their /proc/self/cgroup restricted).
Writing a pid to cgroup.ns_procs implies that you are writing it to
cgroup.procs too. But, not vise-versa. So, you could move yourself in
another cgroup by writing your pid in cgroup.procs, but not in
cgroup.ns_procs, thus preventing from getting "rooted". I This was to
solve administrative process issue in the above appraoch. But I think
this is very clunky too and I find semantics for this approach to be
non-intuitive. It almost looks like moving towards a separate "ns"
subsystem. But as we already know, its a path to failure.

I didn't think of using a mount option. I imagine the mount option
(something like -o root=/bathjobs/container_1) could be used to
restrict the visibility of cgroupfs inside the container's mount
namespace. i.e., the value you read from /proc/<pid>/cgroup now
depends on what mount namespace you are in. Its similar to cgroup
namespace, but just that the cgroupns_root is now stored in the
'struct mnt_namespace' instead of a separate 'struct
cgroup_namespace'. But, since mount namespace on creation inherits
mounts from its parent, the first cgroupfs mount in a mount namespace
is now treated specially. Also, its not possible to restrict cgroups
without mount namespace now. This is interesting and may not be too
bad. I am willing to give this a try. But I feel the cgroup namespace
approach fits well in-line with other namespaces where it does one
thing - virtualize the view of /proc/<pid>/cgroup file for processes
inside the namespace. The semantics are more intuitive as they are
similar to other namespaces.

Thanks,

>> Signed-off-by: Aditya Kali <adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
>
> Acked-by: Serge E. Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
>
>> ---
>>  include/uapi/linux/sched.h | 3 +--
>>  1 file changed, 1 insertion(+), 2 deletions(-)
>>
>> diff --git a/include/uapi/linux/sched.h b/include/uapi/linux/sched.h
>> index 34f9d73..2f90d00 100644
>> --- a/include/uapi/linux/sched.h
>> +++ b/include/uapi/linux/sched.h
>> @@ -21,8 +21,7 @@
>>  #define CLONE_DETACHED               0x00400000      /* Unused, ignored */
>>  #define CLONE_UNTRACED               0x00800000      /* set if the tracing process can't force CLONE_PTRACE on this clone */
>>  #define CLONE_CHILD_SETTID   0x01000000      /* set the TID in the child */
>> -/* 0x02000000 was previously the unused CLONE_STOPPED (Start in stopped state)
>> -   and is now available for re-use. */
>> +#define CLONE_NEWCGROUP              0x02000000      /* New cgroup namespace */
>>  #define CLONE_NEWUTS         0x04000000      /* New utsname group? */
>>  #define CLONE_NEWIPC         0x08000000      /* New ipcs */
>>  #define CLONE_NEWUSER                0x10000000      /* New user namespace */
>> --
>> 2.0.0.526.g5318336
>>
>> _______________________________________________
>> Containers mailing list
>> Containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
>> https://lists.linuxfoundation.org/mailman/listinfo/containers



-- 
Aditya
