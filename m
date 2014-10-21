From: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Subject: Re: [PATCHv1 7/8] cgroup: cgroup namespace setns support
Date: Tue, 21 Oct 2014 12:02:37 -0700
Message-ID: <CALCETrWXDMRsexfvmh2CiMW4WX0ZLJ4pJvzHU55PEBk=NmnyZg@mail.gmail.com>
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
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <CAGr1F2Ee2MCKOwALR2YV7ppDmyHxO6+EsHqSc1+WcwKFPPQB0w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/containers/>
List-Post: <mailto:containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: Aditya Kali <adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, Serge Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Tue, Oct 21, 2014 at 11:49 AM, Aditya Kali <adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
> On Mon, Oct 20, 2014 at 10:49 PM, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org> wrote:
>> On Mon, Oct 20, 2014 at 10:42 PM, Eric W. Biederman
>> <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org> wrote:
>>>
>>> I do wonder if we think of this as chcgrouproot if there is a simpler
>>> implementation.
>>
>> Could be.  I'll defer to Aditya for that one.
>>
>
> More than chcgrouproot, its probably closer to pivot_cgroup_root. In
> addition to restricting the process to a cgroup-root, new processes
> entering the container should also be implicitly contained within the
> cgroup-root of that container.

Why?  Concretely, why should this be in the kernel namespace code
instead of in userspace?

> Implementing pivot_cgroup_root would
> probably involve overloading mount-namespace to now understand cgroup
> filesystem too. I did attempt combining cgroupns-root with mntns
> earlier (not via a new syscall though), but came to the conclusion
> that its just simpler to have a separate cgroup namespace and get
> clear semantics. One of the issues was that implicitly changing cgroup
> on setns to mntns seemed like a huge undesirable side-effect.
>
> About pinning: I really feel that it should be OK to pin processes
> within cgroupns-root. I think thats one of the most important feature
> of cgroup-namespace since its most common usecase is to containerize
> un-trusted processes - processes that, for their entire lifetime, need
> to remain inside their container.

So don't let them out.  None of the other namespaces have this kind of
constraint:

 - If you're in a mntns, you can still use fds from outside.
 - If you're in a netns, you can still use sockets from outside the namespace.
 - If you're in an ipcns, you can still use ipc handles from outside.

etc.

> And with explicit permission from
> cgroup subsystem (something like cgroup.may_unshare as you had
> suggested previously), we can make sure that unprivileged processes
> cannot pin themselves. Also, maintaining this invariant (your current
> cgroup is always under your cgroupns-root) keeps the code and the
> semantics simple.

I actually think it makes the semantics more complex.  The less policy
you stick in the kernel, the easier it is to understand the impact of
that policy.

>
> If we ditch the pinning requirement and allow the containarized
> process to move outside of its cgroupns-root, we will have to address
> atleast the following:
> * what does its /proc/self/cgroup  (and /proc/<pid>/cgroup in general)
> look like? We might need to just not show anything in
> /proc/<pid>/cgroup in such case (for default hierarchy).

The process should see the cgroup path relative to its cgroup ns.
Whether this requires a new /proc mount or happens automatically is an
open question.  (I *hate* procfs for reasons like this.)

> * how should future setns() and unshare() by such process behave?

Open question.

> * 'mount -t cgroup cgroup <mnt>' by such a process will yield unexpected result

You could disallow that and instead require 'mount -t cgroup -o
cgrouproot=. cgroup mnt' where '.' will be resolved at mount time
relative to the caller's cgroupns.

> * container will not remain migratable

Why not?

> * added code complexity to handle above scenarios
>
> I understand that having process pinned to a cgroup hierarchy might
> seem inconvenient. But even today (without cgroup namespaces), moving
> a task from one cgroup to another can fail for reasons outside of
> control of the task attempting the move (even if its privileged). So
> the userspace should already handle this scenario. I feel its not
> worth to add complexity in the kernel for this.

--Andy
