From: Aditya Kali <adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCHv3 8/8] cgroup: Add documentation for cgroup namespaces
Date: Mon, 5 Jan 2015 14:54:13 -0800
Message-ID: <CAGr1F2Eej949PiJSUy6wzJR28igK7XbD7dD=E3K_D=JbhapAtQ@mail.gmail.com>
References: <1417744550-6461-1-git-send-email-adityakali@google.com>
	<1417744550-6461-9-git-send-email-adityakali@google.com>
	<548AAD42.5010002@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <548AAD42.5010002-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/containers/>
List-Post: <mailto:containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Richard Weinberger <richard.weinberger-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, Serge Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups mailinglist <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Thanks for the review. I have made the suggested fixes. Regarding
relative path, please see inline.

On Fri, Dec 12, 2014 at 12:54 AM, Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org> wrote:
>> +In its current form, the cgroup namespaces patcheset provides following
>> +behavior:
>> +
>> +(1) The 'cgroupns-root' for a cgroup namespace is the cgroup in which
>> +    the process calling unshare is running.
>> +    For ex. if a process in /batchjobs/container_id1 cgroup calls unshare,
>> +    cgroup /batchjobs/container_id1 becomes the cgroupns-root.
>> +    For the init_cgroup_ns, this is the real root ('/') cgroup
>> +    (identified in code as cgrp_dfl_root.cgrp).
>> +
>> +(2) The cgroupns-root cgroup does not change even if the namespace
>> +    creator process later moves to a different cgroup.
>> +    $ ~/unshare -c # unshare cgroupns in some cgroup
>> +    [ns]$ cat /proc/self/cgroup
>> +    0:cpuset,cpu,cpuacct,memory,devices,freezer,hugetlb:/
>> +    [ns]$ mkdir sub_cgrp_1
>> +    [ns]$ echo 0 > sub_cgrp_1/cgroup.procs
>> +    [ns]$ cat /proc/self/cgroup
>> +    0:cpuset,cpu,cpuacct,memory,devices,freezer,hugetlb:/sub_cgrp_1
>> +
>> +(3) Each process gets its CGROUPNS specific view of /proc/<pid>/cgroup
>> +(a) Processes running inside the cgroup namespace will be able to see
>> +    cgroup paths (in /proc/self/cgroup) only inside their root cgroup
>> +    [ns]$ sleep 100000 &  # From within unshared cgroupns
>> +    [1] 7353
>> +    [ns]$ echo 7353 > sub_cgrp_1/cgroup.procs
>> +    [ns]$ cat /proc/7353/cgroup
>> +    0:cpuset,cpu,cpuacct,memory,devices,freezer,hugetlb:/sub_cgrp_1
>> +
>> +(b) From global cgroupns, the real cgroup path will be visible:
>> +    $ cat /proc/7353/cgroup
>> +    0:cpuset,cpu,cpuacct,memory,devices,freezer,hugetlb:/batchjobs/container_id1/sub_cgrp_1
>> +
>> +(c) From a sibling cgroupns (cgroupns root-ed at a different cgroup), cgroup
>> +    path relative to its own cgroupns-root will be shown:
>> +    # ns2's cgroupns-root is at '/batchjobs/container_id2'
>> +    [ns2]$ cat /proc/7353/cgroup
>> +    0:cpuset,cpu,cpuacct,memory,devices,freezer,hugetlb:/../container_id2/sub_cgrp_1
>
> Should be ../container_id1/sub_cgrp_1 ?
>

Starting with '/' was deliberate.

>> +
>> +    Note that the relative path always starts with '/' to indicate that its
>> +    relative to the cgroupns-root of the caller.
>
> If a path doesn't start with '/', then it's a relative path, so why make it start with '/'?
>

This is so as not to surprise the apps parsing /proc/<pid>/cgroup
files and using the path in it as absolute path. The existing paths
there always start with '/' right now. Retaining the '/' means path
generated by userspace continuous to work. Does this makes sense?

>> +
>> +(4) Processes inside a cgroupns can move in-and-out of the cgroupns-root
>> +    (if they have proper access to external cgroups).
>> +    # From inside cgroupns (with cgroupns-root at /batchjobs/container_id1), and
>> +    # assuming that the global hierarchy is still accessible inside cgroupns:
>> +    $ cat /proc/7353/cgroup
>> +    0:cpuset,cpu,cpuacct,memory,devices,freezer,hugetlb:/sub_cgrp_1
>> +    $ echo 7353 > batchjobs/container_id2/cgroup.procs
>> +    $ cat /proc/7353/cgroup
>> +    0:cpuset,cpu,cpuacct,memory,devices,freezer,hugetlb:/../container_id2
>> +
>> +    Note that this kind of setup is not encouraged. A task inside cgroupns
>> +    should only be exposed to its own cgroupns hierarchy. Otherwise it makes
>> +    the virtualization of /proc/<pid>/cgroup less useful.
>> +
>> +(5) Setns to another cgroup namespace is allowed when:
>> +    (a) the process has CAP_SYS_ADMIN in its current userns
>> +    (b) the process has CAP_SYS_ADMIN in the target cgroupns' userns
>> +    No implicit cgroup changes happen with attaching to another cgroupns. It
>> +    is expected that the somone moves the attaching process under the target
>> +    cgroupns-root.
>> +
>
> s/the somone/someone
>
fixed.

>> +(6) When some thread from a multi-threaded process unshares its
>> +    cgroup-namespace, the new cgroupns gets applied to the entire
>> +    process (all the threads). This should be OK since
>> +    unified-hierarchy only allows process-level containerization. So
>> +    all the threads in the process will have the same cgroup.
>> +
>> +(7) The cgroup namespace is alive as long as there is atleast 1
>
> s/atelast/at least
>
fixed.

>> +    process inside it. When the last process exits, the cgroup
>> +    namespace is destroyed. The cgroupns-root and the actual cgroups
>> +    remain though.
>> +
>> +(8) Namespace specific cgroup hierarchy can be mounted by a process running
>> +    inside cgroupns:
>> +    $ mount -t cgroup -o __DEVEL__sane_behavior cgroup $MOUNT_POINT
>> +
>> +    This will mount the unified cgroup hierarchy with cgroupns-root as the
>> +    filesystem root. The process needs CAP_SYS_ADMIN in its userns and mntns.
>> +
>>
>
> --
> To unsubscribe from this list: send the line "unsubscribe cgroups" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Thanks!
-- 
Aditya
