From: Aditya Kali <adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCHv1 7/8] cgroup: cgroup namespace setns support
Date: Wed, 22 Oct 2014 11:37:55 -0700
Message-ID: <CAGr1F2EBDCVrXZd7fOdffQ2C0c25T8co4wfxRc8P0Jb18yq2uQ@mail.gmail.com>
References: <1413235430-22944-1-git-send-email-adityakali@google.com>
	<1413235430-22944-8-git-send-email-adityakali@google.com>
	<20141016211236.GA4308@mail.hallyn.com>
	<CAGr1F2EH0ynfFihTh1dv=n1faxUh0zS3ggk303bwGnDnW2PUCw@mail.gmail.com>
	<20141016214710.GA4759@mail.hallyn.com>
	<87iojgmy3o.fsf@x220.int.ebiederm.org>
	<CALCETrUC=yW72d2hDzjESmZAt85x1WcGz4L-DrtY5YXAQxbpMA@mail.gmail.com>
	<44072106-c0f3-46b8-b2b5-9b1cbd1b7d88@email.android.com>
	<CALCETrXhGnBM_xx=Auz3WRQXkqhGGTWuZN=PU+A9HZ7Ek27FLA@mail.gmail.com>
	<87zjcq10ya.fsf@x220.int.ebiederm.org>
	<CALCETrVkMtsnEh57jFZrdx5vHbz97BdO7OuupT+xVNnWpJjxng@mail.gmail.com>
	<87lhoayo59.fsf@x220.int.ebiederm.org>
	<CALCETrVFKvtHpTfY3kuE5ZTrwQAzuDmk6dm-mbQffDHAZmq-KQ@mail.gmail.com>
	<CAGr1F2Ee2MCKOwALR2YV7ppDmyHxO6+EsHqSc1+WcwKFPPQB0w@mail.gmail.com>
	<CALCETrWXDMRsexfvmh2CiMW4WX0ZLJ4pJvzHU55PEBk=NmnyZg@mail.gmail.com>
	<CAGr1F2FdQ4VF1_o7mdybZ-WhLLhFxdgkNnzotHOwnhLU8W+YCw@mail.gmail.com>
	<CALCETrXEAegFmSs2LnfSJR0tQmqZudnESDER8CoqKxOCBFMwdA@mail.gmail.com>
	<CAGr1F2HYGG9=jwugywD8tUdB+dOjN4z+3BSpqL_m2aaM+3Rz1A@mail.gmail.com>
	<CALCETrUtqozUE=Lr5d2dBKd_vaLzfVvVv8g6ZALz1MWqVzj9dQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <CALCETrUtqozUE=Lr5d2dBKd_vaLzfVvVv8g6ZALz1MWqVzj9dQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/containers/>
List-Post: <mailto:containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Cc: Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, Serge Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Tue, Oct 21, 2014 at 5:58 PM, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org> wrote:
> On Tue, Oct 21, 2014 at 5:46 PM, Aditya Kali <adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
>> On Tue, Oct 21, 2014 at 3:42 PM, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org> wrote:
>>> On Tue, Oct 21, 2014 at 3:33 PM, Aditya Kali <adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
>>>> On Tue, Oct 21, 2014 at 12:02 PM, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org> wrote:
>>>>> On Tue, Oct 21, 2014 at 11:49 AM, Aditya Kali <adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
>>>>>> On Mon, Oct 20, 2014 at 10:49 PM, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org> wrote:
>>>>>>> On Mon, Oct 20, 2014 at 10:42 PM, Eric W. Biederman
>>>>>>> <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org> wrote:
>>>>>>>>
>>>>>>>> I do wonder if we think of this as chcgrouproot if there is a simpler
>>>>>>>> implementation.
>>>>>>>
>>>>>>> Could be.  I'll defer to Aditya for that one.
>>>>>>>
>>>>>>
>>>>>> More than chcgrouproot, its probably closer to pivot_cgroup_root. In
>>>>>> addition to restricting the process to a cgroup-root, new processes
>>>>>> entering the container should also be implicitly contained within the
>>>>>> cgroup-root of that container.
>>>>>
>>>>> Why?  Concretely, why should this be in the kernel namespace code
>>>>> instead of in userspace?
>>>>>
>>>>
>>>> Userspace can do it too. Though then there will be possibility of
>>>> having processes in the same mount namespace with different
>>>> cgroup-roots. Deriving contents of /proc/<pid>/cgroup becomes even
>>>> more complex. Thats another reason why it might not be good idea to
>>>> tie cgroups with mount namespace.
>>>>
>>>>>> Implementing pivot_cgroup_root would
>>>>>> probably involve overloading mount-namespace to now understand cgroup
>>>>>> filesystem too. I did attempt combining cgroupns-root with mntns
>>>>>> earlier (not via a new syscall though), but came to the conclusion
>>>>>> that its just simpler to have a separate cgroup namespace and get
>>>>>> clear semantics. One of the issues was that implicitly changing cgroup
>>>>>> on setns to mntns seemed like a huge undesirable side-effect.
>>>>>>
>>>>>> About pinning: I really feel that it should be OK to pin processes
>>>>>> within cgroupns-root. I think thats one of the most important feature
>>>>>> of cgroup-namespace since its most common usecase is to containerize
>>>>>> un-trusted processes - processes that, for their entire lifetime, need
>>>>>> to remain inside their container.
>>>>>
>>>>> So don't let them out.  None of the other namespaces have this kind of
>>>>> constraint:
>>>>>
>>>>>  - If you're in a mntns, you can still use fds from outside.
>>>>>  - If you're in a netns, you can still use sockets from outside the namespace.
>>>>>  - If you're in an ipcns, you can still use ipc handles from outside.
>>>>
>>>> But none of the namespaces allow you to allocate new fds/sockets/ipc
>>>> handles in the outside namespace. I think moving a process outside of
>>>> cgroupns-root is like allocating a resource outside of your namespace.
>>>
>>> In a pidns, you can see outside tasks if you have an outside procfs
>>> mounted, but, if you don't, then you can't.  Wouldn't cgroupns be just
>>> like that?  You wouldn't be able to escape your cgroup as long as you
>>> don't have an inappropriate cgroupfs mounted.
>>>
>>
>> I am not if we should only depend on restricted visibility for this
>> though. More details below.
>>
>>>
>>>>>
>>>>>> And with explicit permission from
>>>>>> cgroup subsystem (something like cgroup.may_unshare as you had
>>>>>> suggested previously), we can make sure that unprivileged processes
>>>>>> cannot pin themselves. Also, maintaining this invariant (your current
>>>>>> cgroup is always under your cgroupns-root) keeps the code and the
>>>>>> semantics simple.
>>>>>
>>>>> I actually think it makes the semantics more complex.  The less policy
>>>>> you stick in the kernel, the easier it is to understand the impact of
>>>>> that policy.
>>>>>
>>>>
>>>> My inclination is towards keeping things simpler - both in code as
>>>> well as in configuration. I agree that cgroupns might seem
>>>> "less-flexible", but in its current form, it encourages consistent
>>>> container configuration. If you have a process that needs to move
>>>> around between cgroups belonging to different containers, then that
>>>> process should probably not be inside any container's cgroup
>>>> namespace. Allowing that will just make the cgroup namespace
>>>> pretty-much meaningless.
>>>
>>> The problem with pinning is that preventing it causes problems
>>> (specifically, either something potentially complex and incompatible
>>> needs to be added or unprivileged processes will be able to pin
>>> themselves).
>>>
>>> Unless I'm missing something, a normal cgroupns user doesn't actually
>>> need kernel pinning support to effectively constrain its members'
>>> cgroups.
>>>
>>
>> So there are 2 scenarios to consider:
>>
>> We have 2 containers with cgroups: /container1 and /container2
>> Assume process P is running under cgroupns-root '/container1'
>>
>> (1) process P wants to 'write' to cgroup.procs outside its
>> cgroupns-root (say to /container2/cgroup.procs)
>
> This, at least, doesn't have the problem with unprivileged processes
> pinning themselves.
>
>> (2) An admin process running in init_cgroup_ns (or any parent cgroupns
>> with cgroupns-root above /container1) wants to write pid of process P
>> to /container2/cgroup.procs (which lies outside of P's cgroupns-root)
>>
>> For (1), I think its ok to reject such a write. This is consistent
>> with the restriction in cgroup_file_write added in 'Patch 6' of this
>> set. I believe this should be independent of visibility of the cgroup
>> hierarchy for P.
>>
>> For (2), we may allow the write to succeed if we make sure that the
>> process doing the write is an admin process (with CAP_SYS_ADMIN in its
>> userns AND over P's cgroupns->user_ns).
>
> Why is its userns relevant?
>
> Why not just check whether the target cgroup is in the process doing
> the write's cgroupns? (NB: you need to check f_cred, here, not
> current_cred(), but that's orthogonal.)  Then the policy becomes: no
> user of cgroupfs can move any process outside of the cgroupfs's user's
> cgroupns root.
>
Humm .. it doesn't have to be. I think its simpler to not enforce
artificial permission checks unless there is a security concern (and
in this case, there doesn't seem to be any). So I will leave the
capability check out from here.

> I think I'm okay with this.
>
>> If this write succeeds, then:
>> (a) process P's /proc/<pid>/cgroup does not show anything when viewed
>> by 'self' or any other process in P's cgrgroupns. I would really like
>> to avoid showing relative paths or paths outside the cgroupns-root
>
> The empty string seems just as problematic to me.

Actually, there is no right answer here. Our options are:
* show relative path
-- this will break userspace as /proc/<pid>/cgroup does not show
relative paths today. This is also very ambiguous (is it relative to
cgroupns-root or relative to /proc/<pid>cgroup file reader's cgroup?).

* show absolute path
-- this will also wrong as the process won't be able to make sense of
it unless it has exposure to the global cgroup hierarchy.
-- worse case is this that the global path also exists under the
cgroupns-root ... so now the process thinks its in completely wrong
cgroup
-- this exposes system

* show only "/"
-- this is arguably better, but if the process tires to verify that
its pid is in cgroup.procs of the cgroupns-root, its in for a
surprise!

In either case, whatever we expose, the userspace won't be able to use
this path correctly (worse yet, it associates wrong cgroup for that
path). So I think its best to not print out the line for default
hierarchy at all. This happens today when cgroupfs is not mounted. I
am open to other suggestions.

>
>> (b) if process P does 'mount -t cgroup cgroup <mnt>', it will still be
>> only able to mount and see cgroup hierarchy under its cgroupns-root
>> (d) if process P tries to write to any cgroup file outside of its
>> cgroupns-root (assuming that hierarchy is visible to it for whatever
>> reason), it will fail as in (1)
>
> I'm still unconvinced that this serves any purpose.  If you give
> DAC/MAC permission to a task to write to something, and you give it
> access to an fd or mount pointing there, and you don't want it writing
> there, then *don't do that*.  I'm not really seeing why cgroupns needs
> special treatment here.
>

There was a suggestion on the previous version of this patch-set that
we need to prevent processes inside cgroupns to not be able to modify
settings of cgroups outside of its cgroupns-root. But I agree with
your point that cgroupns should not enforce unnecessary access-control
restrictions. Its job is only to virtualize the view of
/proc/<pid>/cgroup file as much as possible (100% virtualized for a
correctly setup container). This will get rid of most of patch 6/8
"cgroup: restrict cgroup operations within task's cgroupns" of this
series. The only check we keep is in cgroup_attach_task() which
ensures that target-cgroup is descendant of current's cgroupns-root
and prevents processes from escaping their cgroupns on their own.

>>
>> i.e., in summary, you can't escape out of cgroupns-root yourself. You
>> will need help from an admin process running under some parent
>> cgroupns-root to move you out. Is that workable for your usecase? Most
>> of the things above already happen with the current patch-set, so it
>> should be easy to enable this.
>>
>> Though there are still some open issues like:
>> * what happens if you move all the processes out of /container1 and
>> then 'rmdir /container1'? As it is now, you won't be able to setns()
>> to that cgroupns anymore. But the cgroupns will still hang around
>> until the processes switch their cgroupns.
>
> Seems okay.
>
>> * should we then also allow setns() without first entering the
>> cgroupns-root? setns also checks the same conditions as in (a) plus it
>> checks that your current cgroup is descendant of target cgroupns-root.
>> Alternatively we can special-case setns() to own cgroupns so that it
>> doesn't fail.
>
> I think setns should completely ignore the caller's cgroup and should
> not change it.  Userspace can do this.
>

All above changes more or less means that tasks cannot pin themselves
by unsharing cgroupns. Do you agree that we don't need that "explicit
permission from cgroupfs" anymore (via cgroup.may_unshare file or
other mechanism)?

>> * migration for these processes will be tricky, if not impossible. But
>> the admin trying to do this probably doesn't care about it or will
>> provision for it.
>
> Migration for processes in a mntns that have a current directory
> outside their mntns is also difficult or impossible.  Same with
> pidnses with an fd pointing at /proc/self from an outside-the-pid-ns
> procfs.  Nothing new here.
>
> --Andy

Thanks for the review!

-- 
Aditya
