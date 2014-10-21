From: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Subject: Re: [PATCHv1 7/8] cgroup: cgroup namespace setns support
Date: Tue, 21 Oct 2014 15:42:16 -0700
Message-ID: <CALCETrXEAegFmSs2LnfSJR0tQmqZudnESDER8CoqKxOCBFMwdA@mail.gmail.com>
References: <1413235430-22944-1-git-send-email-adityakali@google.com>
 <1413235430-22944-8-git-send-email-adityakali@google.com> <20141016211236.GA4308@mail.hallyn.com>
 <CAGr1F2EH0ynfFihTh1dv=n1faxUh0zS3ggk303bwGnDnW2PUCw@mail.gmail.com>
 <20141016214710.GA4759@mail.hallyn.com> <87iojgmy3o.fsf@x220.int.ebiederm.org>
 <CALCETrUC=yW72d2hDzjESmZAt85x1WcGz4L-DrtY5YXAQxbpMA@mail.gmail.com>
 <44072106-c0f3-46b8-b2b5-9b1cbd1b7d88@email.android.com> <CALCETrXhGnBM_xx=Auz3WRQXkqhGGTWuZN=PU+A9HZ7Ek27FLA@mail.gmail.com>
 <87zjcq10ya.fsf@x220.int.ebiederm.org> <CALCETrVkMtsnEh57jFZrdx5vHbz97BdO7OuupT+xVNnWpJjxng@mail.gmail.com>
 <87lhoayo59.fsf@x220.int.ebiederm.org> <CALCETrVFKvtHpTfY3kuE5ZTrwQAzuDmk6dm-mbQffDHAZmq-KQ@mail.gmail.com>
 <CAGr1F2Ee2MCKOwALR2YV7ppDmyHxO6+EsHqSc1+WcwKFPPQB0w@mail.gmail.com>
 <CALCETrWXDMRsexfvmh2CiMW4WX0ZLJ4pJvzHU55PEBk=NmnyZg@mail.gmail.com> <CAGr1F2FdQ4VF1_o7mdybZ-WhLLhFxdgkNnzotHOwnhLU8W+YCw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAGr1F2FdQ4VF1_o7mdybZ-WhLLhFxdgkNnzotHOwnhLU8W+YCw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Aditya Kali <adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, Serge Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Tue, Oct 21, 2014 at 3:33 PM, Aditya Kali <adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
> On Tue, Oct 21, 2014 at 12:02 PM, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org> wrote:
>> On Tue, Oct 21, 2014 at 11:49 AM, Aditya Kali <adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
>>> On Mon, Oct 20, 2014 at 10:49 PM, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org> wrote:
>>>> On Mon, Oct 20, 2014 at 10:42 PM, Eric W. Biederman
>>>> <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org> wrote:
>>>>>
>>>>> I do wonder if we think of this as chcgrouproot if there is a simpler
>>>>> implementation.
>>>>
>>>> Could be.  I'll defer to Aditya for that one.
>>>>
>>>
>>> More than chcgrouproot, its probably closer to pivot_cgroup_root. In
>>> addition to restricting the process to a cgroup-root, new processes
>>> entering the container should also be implicitly contained within the
>>> cgroup-root of that container.
>>
>> Why?  Concretely, why should this be in the kernel namespace code
>> instead of in userspace?
>>
>
> Userspace can do it too. Though then there will be possibility of
> having processes in the same mount namespace with different
> cgroup-roots. Deriving contents of /proc/<pid>/cgroup becomes even
> more complex. Thats another reason why it might not be good idea to
> tie cgroups with mount namespace.
>
>>> Implementing pivot_cgroup_root would
>>> probably involve overloading mount-namespace to now understand cgroup
>>> filesystem too. I did attempt combining cgroupns-root with mntns
>>> earlier (not via a new syscall though), but came to the conclusion
>>> that its just simpler to have a separate cgroup namespace and get
>>> clear semantics. One of the issues was that implicitly changing cgroup
>>> on setns to mntns seemed like a huge undesirable side-effect.
>>>
>>> About pinning: I really feel that it should be OK to pin processes
>>> within cgroupns-root. I think thats one of the most important feature
>>> of cgroup-namespace since its most common usecase is to containerize
>>> un-trusted processes - processes that, for their entire lifetime, need
>>> to remain inside their container.
>>
>> So don't let them out.  None of the other namespaces have this kind of
>> constraint:
>>
>>  - If you're in a mntns, you can still use fds from outside.
>>  - If you're in a netns, you can still use sockets from outside the namespace.
>>  - If you're in an ipcns, you can still use ipc handles from outside.
>
> But none of the namespaces allow you to allocate new fds/sockets/ipc
> handles in the outside namespace. I think moving a process outside of
> cgroupns-root is like allocating a resource outside of your namespace.

In a pidns, you can see outside tasks if you have an outside procfs
mounted, but, if you don't, then you can't.  Wouldn't cgroupns be just
like that?  You wouldn't be able to escape your cgroup as long as you
don't have an inappropriate cgroupfs mounted.


>>
>>> And with explicit permission from
>>> cgroup subsystem (something like cgroup.may_unshare as you had
>>> suggested previously), we can make sure that unprivileged processes
>>> cannot pin themselves. Also, maintaining this invariant (your current
>>> cgroup is always under your cgroupns-root) keeps the code and the
>>> semantics simple.
>>
>> I actually think it makes the semantics more complex.  The less policy
>> you stick in the kernel, the easier it is to understand the impact of
>> that policy.
>>
>
> My inclination is towards keeping things simpler - both in code as
> well as in configuration. I agree that cgroupns might seem
> "less-flexible", but in its current form, it encourages consistent
> container configuration. If you have a process that needs to move
> around between cgroups belonging to different containers, then that
> process should probably not be inside any container's cgroup
> namespace. Allowing that will just make the cgroup namespace
> pretty-much meaningless.

The problem with pinning is that preventing it causes problems
(specifically, either something potentially complex and incompatible
needs to be added or unprivileged processes will be able to pin
themselves).

Unless I'm missing something, a normal cgroupns user doesn't actually
need kernel pinning support to effectively constrain its members'
cgroups.

>
>>>
>>> If we ditch the pinning requirement and allow the containarized
>>> process to move outside of its cgroupns-root, we will have to address
>>> atleast the following:
>>> * what does its /proc/self/cgroup  (and /proc/<pid>/cgroup in general)
>>> look like? We might need to just not show anything in
>>> /proc/<pid>/cgroup in such case (for default hierarchy).
>>
>> The process should see the cgroup path relative to its cgroup ns.
>> Whether this requires a new /proc mount or happens automatically is an
>> open question.  (I *hate* procfs for reasons like this.)
>>
>>> * how should future setns() and unshare() by such process behave?
>>
>> Open question.
>>
>>> * 'mount -t cgroup cgroup <mnt>' by such a process will yield unexpected result
>>
>> You could disallow that and instead require 'mount -t cgroup -o
>> cgrouproot=. cgroup mnt' where '.' will be resolved at mount time
>> relative to the caller's cgroupns.
>>
>>> * container will not remain migratable
>>
>> Why not?
>>
>
> Well, the processes running outside of cgroupns root will be exposed
> to information outside of the container (i.e., its /proc/self/cgroup
> will show paths involving other containers and potentially system
> level information). So unless you even restore them, it will be
> difficult to restore these processes. The whole point of virtualizing
> the /proc/self/cgroup view was so that the processes don't see outside
> cgroups.
>

So don't do that?

--Andy
