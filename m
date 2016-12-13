From: Casey Schaufler <casey-iSGtlc1asvQWG2LlvL+J4A@public.gmane.org>
Subject: Re: [PATCH v5] cgroup: Add new capability to allow a process to
 migrate other tasks between cgroups
Date: Tue, 13 Dec 2016 09:17:43 -0800
Message-ID: <f7ccb39f-bad8-4a78-c796-90927b839494@schaufler-ca.com>
References: <1481593143-18756-1-git-send-email-john.stultz@linaro.org>
 <CAKgNAkhGSYmtqLnCyXH8-dbmBJreo9mbVGRMyd_9hZ5D1F7q4g@mail.gmail.com>
 <221e80bd-3d99-6c35-dcd3-b2547f0abb11@schaufler-ca.com>
 <CALAqxLWaJT=a1Cc2Ja8ZuazjJYi3a2WW9ATB0NFP8670Dyq6bg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CALAqxLWaJT=a1Cc2Ja8ZuazjJYi3a2WW9ATB0NFP8670Dyq6bg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, "open list:CONTROL GROUP (CGROUP)" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Android Kernel Team <kernel-team-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Rom Lemarchand <romlem-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Colin Cross <ccross-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Dmitry Shmidt <dimitrysh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Todd Kjos <tkjos-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Christian Poetzsch <christian.potzsch-1AXoQHu6uovQT0dZR+AlfA@public.gmane.org>, Amit Pundir <amit.pundir-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Dmitry Torokhov <dmitry.torokhov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, "Serge E . Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 12/13/2016 8:49 AM, John Stultz wrote:
> On Tue, Dec 13, 2016 at 8:39 AM, Casey Schaufler <casey-iSGtlc1asvQWG2LlvL+J4A@public.gmane.org> wrote:
>> On 12/13/2016 1:47 AM, Michael Kerrisk (man-pages) wrote:
>>> Hi John,
>>>
>>> On 13 December 2016 at 02:39, John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> wrote:
>>>> This patch adds CAP_GROUP_MIGRATE and logic to allows a process
>>> s/CAP_GROUP_MIGRATE/CAP_CGROUP_MIGRATE/
>>>
>>>> to migrate other tasks between cgroups.
>>>>
>>>> In Android (where this feature originated), the ActivityManager
>>>> tracks various application states (TOP_APP, FOREGROUND,
>>>> BACKGROUND, SYSTEM, etc), and then as applications change
>>>> states, the SchedPolicy logic will migrate the application tasks
>>>> between different cgroups used to control the different
>>>> application states (for example, there is a background cpuset
>>>> cgroup which can limit background tasks to stay on one low-power
>>>> cpu, and the bg_non_interactive cpuctrl cgroup can then further
>>>> limit those background tasks to a small percentage of that one
>>>> cpu's cpu time).
>>>>
>>>> However, for security reasons, Android doesn't want to make the
>>>> system_server (the process that runs the ActivityManager and
>>>> SchedPolicy logic), run as root. So in the Android common.git
>>>> kernel, they have some logic to allow cgroups to loosen their
>>>> permissions so CAP_SYS_NICE tasks can migrate other tasks between
>>>> cgroups.
>>>>
>>>> I feel the approach taken there overloads CAP_SYS_NICE a bit much
>>>> for non-android environments. Efforts to re-use CAP_SYS_RESOURCE
>>>> for this purpose (which Android has since adopted) was also
>>>> stymied by concerns about risks from future cgroups that could be
>>>> considered "dangerous" by how they might change system semantics.
>>>>
>>>> So to avoid overlapping usage, this patch adds a brand new
>>>> process capability flag (CAP_CGROUP_MIGRATE), and uses it when
>>>> checking if a task can migrate other tasks between cgroups.
>>>>
>>>> I've tested this with AOSP master (though its a bit hacked in as
>>>> I still need to properly get the selinux bits aware of the new
>>>> capability bit) with selinux set to permissive and it seems to be
>>>> working well.
>>>>
>>>> Thoughts and feedback would be appreciated!
>>> So, back to the discussion of silos. I understand the argument for
>>> wanting a new silo. But, in that case can we at least try not to make
>>> it a single-use silo?
>>>
>>> How about CAP_CGROUP_CONTROL or some such, with the idea that this
>>> might be a capability that allows the holder to step outside usual
>>> cgroup rules? At the moment, that capability would allow only one such
>>> step, but maybe there would be others in the future.
>> I agree, but want to put it more strongly. The granularity of
>> capabilities can never be fine enough for some people, and this
>> is an example of a case where you're going a bit too far. If the
>> use case is Android as you say, you don't need this. As my friends
>> on the far side of the aisle would say, "just write SELinux policy"
>> to correctly control access as required.
> So.. The trouble is that while selinux is good for restricting
> permissions, the in-kernel permission checks here are already too
> restrictive.

Why did the original authors of cgroups make it that restrictive?
If there isn't a good reason, loosen it up. If there is a good
reason, then pay heed to it.

> It seems one must first loosen things up before we can
> tighten it with selinux rules.

You're looking at splitting the granularity hair. Is your
userspace code really so delicate that it can't handle the
existing, "coarse" privilege and needs to protect at the
"fine" granularity you're proposing?

> Or are you suggesting the system_server
> run as root + further selinux limitations? I worry, the Android
> developers may still be hesitant to do that.

Unlike many of my peers, I am not afraid of running good
solid services with privilege. A proper implementation
of system_server ought to be able to run completely
unconstrained without causing anyone the least concern.
I understand all the arguments against that, and am
disinclined to get into the religious debates that ensue.
So no, I am not going to suggest running system server
as root, but I am going to suggest giving it the capability
currently required and clamping it down with SELinux policy.

>
> thanks
> -john
>
