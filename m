From: ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org (Eric W. Biederman)
Subject: Re: [PATCHv3 8/8] cgroup: Add documentation for cgroup namespaces
Date: Mon, 05 Jan 2015 17:53:11 -0600
Message-ID: <87lhlgpyxk.fsf@x220.int.ebiederm.org>
References: <1417744550-6461-1-git-send-email-adityakali@google.com>
	<1417744550-6461-9-git-send-email-adityakali@google.com>
	<548E17CE.8010704@nod.at>
	<CAGr1F2HA6mzFwgp5ngX8P7=198-5CmCjLmuCJ8j3eQ08J2d9Qw@mail.gmail.com>
	<54AB15BD.8020007@nod.at>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <54AB15BD.8020007-/L3Ra7n9ekc@public.gmane.org> (Richard Weinberger's message of "Mon,
	05 Jan 2015 23:52:45 +0100")
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>
Cc: Aditya Kali <adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Serge Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, cgroups mailinglist <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel@vger.kernel.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, Rohit Jnagal <jnagal-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org> writes:

> Am 05.01.2015 um 23:48 schrieb Aditya Kali:
>> On Sun, Dec 14, 2014 at 3:05 PM, Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org> wrote:
>>> Aditya,
>>>
>>> I gave your patch set a try but it does not work for me.
>>> Maybe you can bring some light into the issues I'm facing.
>>> Sadly I still had no time to dig into your code.
>>>
>>> Am 05.12.2014 um 02:55 schrieb Aditya Kali:
>>>> Signed-off-by: Aditya Kali <adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
>>>> ---
>>>>  Documentation/cgroups/namespace.txt | 147 ++++++++++++++++++++++++++++++++++++
>>>>  1 file changed, 147 insertions(+)
>>>>  create mode 100644 Documentation/cgroups/namespace.txt
>>>>
>>>> diff --git a/Documentation/cgroups/namespace.txt b/Documentation/cgroups/namespace.txt
>>>> new file mode 100644
>>>> index 0000000..6480379
>>>> --- /dev/null
>>>> +++ b/Documentation/cgroups/namespace.txt
>>>> @@ -0,0 +1,147 @@
>>>> +                     CGroup Namespaces
>>>> +
>>>> +CGroup Namespace provides a mechanism to virtualize the view of the
>>>> +/proc/<pid>/cgroup file. The CLONE_NEWCGROUP clone-flag can be used with
>>>> +clone() and unshare() syscalls to create a new cgroup namespace.
>>>> +The process running inside the cgroup namespace will have its /proc/<pid>/cgroup
>>>> +output restricted to cgroupns-root. cgroupns-root is the cgroup of the process
>>>> +at the time of creation of the cgroup namespace.
>>>> +
>>>> +Prior to CGroup Namespace, the /proc/<pid>/cgroup file used to show complete
>>>> +path of the cgroup of a process. In a container setup (where a set of cgroups
>>>> +and namespaces are intended to isolate processes), the /proc/<pid>/cgroup file
>>>> +may leak potential system level information to the isolated processes.
>>>> +
>>>> +For Example:
>>>> +  $ cat /proc/self/cgroup
>>>> +  0:cpuset,cpu,cpuacct,memory,devices,freezer,hugetlb:/batchjobs/container_id1
>>>> +
>>>> +The path '/batchjobs/container_id1' can generally be considered as system-data
>>>> +and its desirable to not expose it to the isolated process.
>>>> +
>>>> +CGroup Namespaces can be used to restrict visibility of this path.
>>>> +For Example:
>>>> +  # Before creating cgroup namespace
>>>> +  $ ls -l /proc/self/ns/cgroup
>>>> +  lrwxrwxrwx 1 root root 0 2014-07-15 10:37 /proc/self/ns/cgroup -> cgroup:[4026531835]
>>>> +  $ cat /proc/self/cgroup
>>>> +  0:cpuset,cpu,cpuacct,memory,devices,freezer,hugetlb:/batchjobs/container_id1
>>>> +
>>>> +  # unshare(CLONE_NEWCGROUP) and exec /bin/bash
>>>> +  $ ~/unshare -c
>>>> +  [ns]$ ls -l /proc/self/ns/cgroup
>>>> +  lrwxrwxrwx 1 root root 0 2014-07-15 10:35 /proc/self/ns/cgroup -> cgroup:[4026532183]
>>>> +  # From within new cgroupns, process sees that its in the root cgroup
>>>> +  [ns]$ cat /proc/self/cgroup
>>>> +  0:cpuset,cpu,cpuacct,memory,devices,freezer,hugetlb:/
>>>> +
>>>> +  # From global cgroupns:
>>>> +  $ cat /proc/<pid>/cgroup
>>>> +  0:cpuset,cpu,cpuacct,memory,devices,freezer,hugetlb:/batchjobs/container_id1
>>>> +
>>>> +  # Unshare cgroupns along with userns and mountns
>>>> +  # Following calls unshare(CLONE_NEWCGROUP|CLONE_NEWUSER|CLONE_NEWNS), then
>>>> +  # sets up uid/gid map and execs /bin/bash
>>>> +  $ ~/unshare -c -u -m
>>>
>>> This command does not issue CLONE_NEWUSER, -U does.
>>>
>> I was using a custom unshare binary. But I will update the command
>> line to be similar to the one in util-linux.
>> 
>>>> +  # Originally, we were in /batchjobs/container_id1 cgroup. Mount our own cgroup
>>>> +  # hierarchy.
>>>> +  [ns]$ mount -t cgroup cgroup /tmp/cgroup
>>>> +  [ns]$ ls -l /tmp/cgroup
>>>> +  total 0
>>>> +  -r--r--r-- 1 root root 0 2014-10-13 09:32 cgroup.controllers
>>>> +  -r--r--r-- 1 root root 0 2014-10-13 09:32 cgroup.populated
>>>> +  -rw-r--r-- 1 root root 0 2014-10-13 09:25 cgroup.procs
>>>> +  -rw-r--r-- 1 root root 0 2014-10-13 09:32 cgroup.subtree_control
>>>
>>> I've patched libvirt-lxc to issue CLONE_NEWCGROUP and not bind mount cgroupfs into a container.
>>> But I'm unable to mount cgroupfs within the container, mount(2) is failing with EINVAL.
>>> And /proc/self/cgroup still shows the cgroup from outside.
>>>
>>> ---cut---
>>> container:/ # ls /sys/fs/cgroup/
>>> container:/ # mount -t cgroup none /sys/fs/cgroup/
>> 
>> You need to provide "-o __DEVEL_sane_behavior" flag. Inside the
>> container, only unified hierarchy can be mounted. So, for now, that
>> flag is needed. I will fix the documentation too.
>> 
>>> mount: wrong fs type, bad option, bad superblock on none,
>>>        missing codepage or helper program, or other error
>>>
>>>        In some cases useful info is found in syslog - try
>>>        dmesg | tail or so.
>>> container:/ # cat /proc/self/cgroup
>>> 8:memory:/machine/test00.libvirt-lxc
>>> 7:devices:/machine/test00.libvirt-lxc
>>> 6:hugetlb:/
>>> 5:cpuset:/machine/test00.libvirt-lxc
>>> 4:blkio:/machine/test00.libvirt-lxc
>>> 3:cpu,cpuacct:/machine/test00.libvirt-lxc
>>> 2:freezer:/machine/test00.libvirt-lxc
>>> 1:name=systemd:/user.slice/user-0.slice/session-c2.scope
>>> container:/ # ls -la /proc/self/ns
>>> total 0
>>> dr-x--x--x 2 root root 0 Dec 14 23:02 .
>>> dr-xr-xr-x 8 root root 0 Dec 14 23:02 ..
>>> lrwxrwxrwx 1 root root 0 Dec 14 23:02 cgroup -> cgroup:[4026532240]
>>> lrwxrwxrwx 1 root root 0 Dec 14 23:02 ipc -> ipc:[4026532238]
>>> lrwxrwxrwx 1 root root 0 Dec 14 23:02 mnt -> mnt:[4026532235]
>>> lrwxrwxrwx 1 root root 0 Dec 14 23:02 net -> net:[4026532242]
>>> lrwxrwxrwx 1 root root 0 Dec 14 23:02 pid -> pid:[4026532239]
>>> lrwxrwxrwx 1 root root 0 Dec 14 23:02 user -> user:[4026532234]
>>> lrwxrwxrwx 1 root root 0 Dec 14 23:02 uts -> uts:[4026532236]
>>> container:/ #
>>>
>>> #host side
>>> lxc-os132:~ # ls -la /proc/self/ns
>>> total 0
>>> dr-x--x--x 2 root root 0 Dec 14 23:56 .
>>> dr-xr-xr-x 8 root root 0 Dec 14 23:56 ..
>>> lrwxrwxrwx 1 root root 0 Dec 14 23:56 cgroup -> cgroup:[4026531835]
>>> lrwxrwxrwx 1 root root 0 Dec 14 23:56 ipc -> ipc:[4026531839]
>>> lrwxrwxrwx 1 root root 0 Dec 14 23:56 mnt -> mnt:[4026531840]
>>> lrwxrwxrwx 1 root root 0 Dec 14 23:56 net -> net:[4026531957]
>>> lrwxrwxrwx 1 root root 0 Dec 14 23:56 pid -> pid:[4026531836]
>>> lrwxrwxrwx 1 root root 0 Dec 14 23:56 user -> user:[4026531837]
>>> lrwxrwxrwx 1 root root 0 Dec 14 23:56 uts -> uts:[4026531838]
>>> ---cut---
>>>
>>> Any ideas?
>>>
>> 
>> Please try with "-o __DEVEL_sane_behavior" flag to the mount command.
>
> Ohh, this renders the whole patch useless for me as systemd needs the "old/default" behavior of cgroups. :-(
> I really hoped that cgroup namespaces will help me running systemd in a sane way within Linux containers.

Ugh.  It sounds like there is a real mess here.  At the very least there
is misunderstanding.

I have a memory that systemd should have been able to use a unified
hierarchy.  As you could still mount the different controllers
independently (they just use the same directory structure on each
mount).

That said from a practical standpoint I am not certain that a cgroup
namespace is viable if it can not support the behavior of cgroupsfs
that everyone is using.

Eric
