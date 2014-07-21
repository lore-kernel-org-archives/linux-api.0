From: Aditya Kali <adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 5/5] cgroup: introduce cgroup namespaces
Date: Mon, 21 Jul 2014 15:11:25 -0700
Message-ID: <CAGr1F2Fd_4=WUm4STPd4kdd5tNLO6aQ1OOQMKnRqyOKZSGvCpg@mail.gmail.com>
References: <1405626731-12220-1-git-send-email-adityakali@google.com>
 <1405626731-12220-6-git-send-email-adityakali@google.com> <CALCETrWXMMGzptvEu6TfzTjBou4t==W39_nNB5FJwSk2Zy8uCQ@mail.gmail.com>
 <CAGr1F2Ht1q_nYGJwmQvEEyj8r3R1stgD=g3s8_5zYOTogjz-UQ@mail.gmail.com>
 <CALCETrW6YpyJBmr3sZC6KL03GP4dcGYavQF5DFZfys6Cok-vpw@mail.gmail.com>
 <CAGr1F2GwZvZLPGLWKPPOt3vREwwVNbVPrgE6YJ01bACKejbc4Q@mail.gmail.com> <CALCETrVeeL71sfVdbzRx0FpGrvQKbviEmUcMEosbUU+UJNQu9w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CALCETrVeeL71sfVdbzRx0FpGrvQKbviEmUcMEosbUU+UJNQu9w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Cc: Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Fri, Jul 18, 2014 at 11:57 AM, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org> wrote:
> On Fri, Jul 18, 2014 at 11:51 AM, Aditya Kali <adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
>> On Fri, Jul 18, 2014 at 9:51 AM, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org> wrote:
>>> On Jul 17, 2014 1:56 PM, "Aditya Kali" <adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
>>>>
>>>> On Thu, Jul 17, 2014 at 12:57 PM, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org> wrote:
>>>> > What happens if someone moves a task in a cgroup namespace outside of
>>>> > the namespace root cgroup?
>>>> >
>>>>
>>>> Attempt to move a task outside of cgroupns root will fail with EPERM.
>>>> This is true irrespective of the privileges of the process attempting
>>>> this. Once cgroupns is created, the task will be confined to the
>>>> cgroup hierarchy under its cgroupns root until it dies.
>>>
>>> Can a task in a non-init userns create a cgroupns?  If not, that's
>>> unusual.  If so, is it problematic if they can prevent themselves from
>>> being moved?
>>>
>>
>> Currently, only a task with CAP_SYS_ADMIN in the init-userns can
>> create cgroupns. It is stricter than for other namespaces, yes.
>
> I'm slightly hesitant to have unshare(CLONE_NEWUSER |
> CLONE_NEWCGROUPNS | ...) start having weird side effects that are
> visible outside the namespace, especially when those side effects
> don't happen (because the call fails entirely) if
> unshare(CLONE_NEWUSER) happens first.  I don't see a real problem with
> it, but it's weird.
>

I expect this to be only in the initial version of the patch. We can
make this consistent with other namespaces once we figure out how
cgroupns can be safely enabled for non-init-userns.

>>
>>> I hate to say it, but it might be worth requiring explicit permission
>>> from the cgroup manager for this.  For example, there could be a new
>>> cgroup attribute may_unshare, and any attempt to unshare the cgroup ns
>>> will fail with -EPERM unless the caller is in a may_share=1 cgroup.
>>> may_unshare in a parent cgroup would not give child cgroups the
>>> ability to unshare.
>>>
>>
>> What you suggest can be done. The current patch-set punts the problem
>> of permission checking by only allowing unshare from a
>> capable(CAP_SYS_ADMIN) process. This can be implemented as a follow-up
>> improvement to cgroupns feature if we want to open it to non-init
>> userns.
>>
>> Being said that, I would argue that even if we don't have this
>> explicit permission and relax the check to non-init userns, it should
>> be 'OK' to let ns_capable(current_user_ns(), CAP_SYS_ADMIN) tasks to
>> unshare cgroupns (basically, if you can "create" a cgroup hierarchy,
>> you should probably be allowed to unshare() it).
>
> But non-init-userns tasks can't create cgroup hierarchies, unless I
> misunderstand the current code.  And, if they can, I bet I can find
> three or four serious security issues in an hour or two. :)
>

Task running in non-init userns can create cgroup hierarchies if you
chown/chgrp their cgroup root to the task user:

# while running as 'root' (uid=0)
$ cd  $CGROUP_MOUNT
$ mkdir -p batchjobs/c_job_id1/

# transfer ownership to the user (in this case 'nobody' (uid=99)).
$ chown nobody batchjobs/c_job_id1/
$ chgrp nobody batchjobs/c_job_id1/
$ ls -ld batchjobs/c_job_id1/
drwxr-xr-x 2 nobody nobody 0 2014-07-21 12:47 batchjobs/c_job_id1/

# enter container cgroup
$ echo 0 > batchjobs/c_job_id1/cgroup.procs

# unshare both userns and cgroupns
$ unshare -u -c
# setup uid_map and gid_map and export user '99' in the userns
#    $ cat /proc/<pid>/uid_map
#         0          0          1
#        99         99          1
#    $ cat /proc/<pid>/gid_map
#         0          0          1
#        99         99          1
# switch to user 'nobody'
$ su nobody
$ id
uid=99(nobody) gid=99(nobody) groups=99(nobody)

# Now user nobody running under non-init userns can create sub-cgroups
# under "batchjobs/c_job_id1/".
# PWD=$CGROUP_MOUNT/batchjobs/c_job_id1
$ mkdir sub_cgroup1
$ ls -ld sub_cgroup1/
drwxr-xr-x 2 nobody nobody 0 2014-07-21 13:11 sub_cgroup1/
$ echo 0 > sub_cgroup1/cgroup.procs
$ cat /proc/self/cgroup
0:cpuset,cpu,cpuacct,memory,devices,freezer,hugetlb:/sub_cgroup1
$ ls -l sub_cgroup1/
total 0
-r--r--r-- 1 nobody nobody 0 2014-07-21 13:11 cgroup.controllers
-r--r--r-- 1 nobody nobody 0 2014-07-21 13:11 cgroup.populated
-rw-r--r-- 1 nobody nobody 0 2014-07-21 13:12 cgroup.procs
-rw-r--r-- 1 nobody nobody 0 2014-07-21 13:11 cgroup.subtree_control


This is a powerful feature as it allows non-root tasks to run
container-management tools and provision their resources properly. But
this makes implementing your suggestion of having 'cgroup.may_unshare'
file tricky as the cgroup owner (task) will be able to set it and
still unshare cgroupns. Instead, may be we could just check if the
task has appropriate (write?) permissions on the cgroup directory
before allowing nested cgroupns creation.

>> By unsharing
>> cgroupns, the tasks can only confine themselves further under its
>> cgroupns-root. As long as it cannot escape that hierarchy, it should
>> be fine.
>
> But they can also *lock* their hierarchy.
>

But locking the tasks inside the hierarchy is really what cgroupns
feature is trying to provide. I understand that this is a change in
expectation, but with unified hierarchy, there are already
restrictions on where tasks can be moved (only to leaf cgroups). With
cgroup namespaces, this becomes: "only to leaf cgroups within task's
cgroupns".

>> In my experience, there is seldom a need to move tasks out of their
>> cgroup. At most, we create a sub-cgroup and move the task there (which
>> is allowed in their cgroupns). Even for a cgroup manager, I can't
>> think of a case where it will be useful to move a task from one cgroup
>> hierarchy to another. Such move seems overly complicated (even without
>> cgroup namespaces). The cgroup manager can just modify the settings of
>> the task's cgroup as needed or simply kill & restart the task in a new
>> container.
>>
>
> I do this all the time.  Maybe my new systemd overlords will make me
> stop doing it, at which point my current production setup will blow
> up.
>

[shudder]
I am surprised that this even works correctly.

Either way, may be checking cgroup directory permissions will work for
you? i.e., if you "chown" a cgroup directory to the user, it should be
OK if the user's task unshares cgroupns under that cgroup and you
don't care about moving tasks from under that cgroup. Without
ownership of the cgroup directory, creation of cgroupns will be
disallowed. What do you think?


> --Andy



-- 
Aditya
