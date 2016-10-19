From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Subject: Re: [PATCH] cgroup: Add new capability to allow a process to migrate
 other tasks between cgroups
Date: Wed, 19 Oct 2016 09:14:37 +0200
Message-ID: <e63d1253-8a45-343f-1930-513e6ad86aeb@gmail.com>
References: <1476743724-9104-1-git-send-email-john.stultz@linaro.org>
 <CALCETrXrZpLH8NsSmaoH5ChW5+6Zb=nLsznj=x4jeWUjpQ-ecA@mail.gmail.com>
 <CALAqxLW0_Xi0vrTkTN+Gmp3yKfOcmCYYCi5f4COgPiYY=odEJA@mail.gmail.com>
 <CAKgNAkjTYu53ji=gP2qXRYpvUEdAP=gxg0BR40JJ54z+XBha-A@mail.gmail.com>
 <CALAqxLW7XS3KyA=cCKvxJAuOYhkw_d0vUJ6=RpN0a=RL2fYm=w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CALAqxLW7XS3KyA=cCKvxJAuOYhkw_d0vUJ6=RpN0a=RL2fYm=w@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: John Stultz <john.stultz@linaro.org>
Cc: mtk.manpages@gmail.com, Andy Lutomirski <luto@amacapital.net>, lkml <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Jonathan Corbet <corbet@lwn.net>, "open list:CONTROL GROUP (CGROUP)" <cgroups@vger.kernel.org>, Android Kernel Team <kernel-team@android.com>, Rom Lemarchand <romlem@android.com>, Colin Cross <ccross@android.com>, Dmitry Shmidt <dimitrysh@google.com>, Ricky Zhou <rickyz@chromium.org>, Dmitry Torokhov <dmitry.torokhov@gmail.com>, Todd Kjos <tkjos@google.com>, Christian Poetzsch <christian.potzsch@imgtec.com>, Amit Pundir <amit.pundir@linaro.org>, "Serge E . Hallyn" <serge@hallyn.com>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

Hi John,

On 10/18/2016 06:54 PM, John Stultz wrote:
> On Tue, Oct 18, 2016 at 1:17 AM, Michael Kerrisk (man-pages)
> <mtk.manpages@gmail.com> wrote:
>> Hi John,
>>
>> On 18 October 2016 at 01:35, John Stultz <john.stultz@linaro.org> wrote:
>>> On Mon, Oct 17, 2016 at 3:40 PM, Andy Lutomirski <luto@amacapital.net> wrote:
>>>> On Mon, Oct 17, 2016 at 3:35 PM, John Stultz <john.stultz@linaro.org> wrote:
>>>>> This patch adds CAP_GROUP_MIGRATE and logic to allows a process
>>>>> to migrate other tasks between cgroups.
>>>>>
>>>>> In Android (where this feature originated), the ActivityManager tracks
>>>>> various application states (TOP_APP, FOREGROUND, BACKGROUND, SYSTEM,
>>>>> etc), and then as applications change states, the SchedPolicy logic
>>>>> will migrate the application tasks between different cgroups used
>>>>> to control the different application states (for example, there is a
>>>>> background cpuset cgroup which can limit background tasks to stay
>>>>> on one low-power cpu, and the bg_non_interactive cpuctrl cgroup can
>>>>> then further limit those background tasks to a small percentage of
>>>>> that one cpu's cpu time).
>>>>>
>>>>> However, for security reasons, Android doesn't want to make the
>>>>> system_server (the process that runs the ActivityManager and
>>>>> SchedPolicy logic), run as root. So in the Android common.git
>>>>> kernel, they have some logic to allow cgroups to loosen their
>>>>> permissions so CAP_SYS_NICE tasks can migrate other tasks between
>>>>> cgroups.
>>>>>
>>>>> The approach taken there overloads CAP_SYS_NICE a bit much, and
>>>>> is maybe more complicated then needed.
>>>>>
>>>>> So this patch, as suggested by Tejun,  simply adds a new process
>>>>> capability flag (CAP_CGROUP_MIGRATE), and uses it when checking
>>>>> if a task can migrate other tasks between cgroups.
>>>>>
>>>>> I've tested this with AOSP master (though its a bit hacked in as I
>>>>> still need to properly get the selinux bits aware of the new
>>>>> capability bit) with selinux set to permissive and it seems to be
>>>>> working well.
>>>>>
>>>>> Thoughts and feedback would be appreciated!
>>>>>
>>>>> Cc: Tejun Heo <tj@kernel.org>
>>>>> Cc: Li Zefan <lizefan@huawei.com>
>>>>> Cc: Jonathan Corbet <corbet@lwn.net>
>>>>> Cc: cgroups@vger.kernel.org
>>>>> Cc: Android Kernel Team <kernel-team@android.com>
>>>>> Cc: Rom Lemarchand <romlem@android.com>
>>>>> Cc: Colin Cross <ccross@android.com>
>>>>> Cc: Dmitry Shmidt <dimitrysh@google.com>
>>>>> Cc: Ricky Zhou <rickyz@chromium.org>
>>>>> Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
>>>>> Cc: Todd Kjos <tkjos@google.com>
>>>>> Cc: Christian Poetzsch <christian.potzsch@imgtec.com>
>>>>> Cc: Amit Pundir <amit.pundir@linaro.org>
>>>>> Cc: Serge E. Hallyn <serge@hallyn.com>
>>>>> Cc: linux-api@vger.kernel.org
>>>>> Signed-off-by: John Stultz <john.stultz@linaro.org>
>>>>> ---
>>>>> v2: Renamed to just CAP_CGROUP_MIGRATE as reccomended by Tejun
>>>>> ---
>>>>>  include/uapi/linux/capability.h | 5 ++++-
>>>>>  kernel/cgroup.c                 | 3 ++-
>>>>>  2 files changed, 6 insertions(+), 2 deletions(-)
>>>>>
>>>>> diff --git a/include/uapi/linux/capability.h b/include/uapi/linux/capability.h
>>>>> index 49bc062..44d7ff4 100644
>>>>> --- a/include/uapi/linux/capability.h
>>>>> +++ b/include/uapi/linux/capability.h
>>>>> @@ -349,8 +349,11 @@ struct vfs_cap_data {
>>>>>
>>>>>  #define CAP_AUDIT_READ         37
>>>>>
>>>>> +/* Allow migrating tasks between cgroups */
>>>>>
>>>>> -#define CAP_LAST_CAP         CAP_AUDIT_READ
>>>>> +#define CAP_CGROUP_MIGRATE     38
>>>>> +
>>>>> +#define CAP_LAST_CAP         CAP_CGROUP_MIGRATE
>>>>>
>>>>>  #define cap_valid(x) ((x) >= 0 && (x) <= CAP_LAST_CAP)
>>>>>
>>>>> diff --git a/kernel/cgroup.c b/kernel/cgroup.c
>>>>> index 85bc9be..09f84d2 100644
>>>>> --- a/kernel/cgroup.c
>>>>> +++ b/kernel/cgroup.c
>>>>> @@ -2856,7 +2856,8 @@ static int cgroup_procs_write_permission(struct task_struct *task,
>>>>>          */
>>>>>         if (!uid_eq(cred->euid, GLOBAL_ROOT_UID) &&
>>>>>             !uid_eq(cred->euid, tcred->uid) &&
>>>>> -           !uid_eq(cred->euid, tcred->suid))
>>>>> +           !uid_eq(cred->euid, tcred->suid) &&
>>>>> +           !ns_capable(tcred->user_ns, CAP_CGROUP_MIGRATE))
>>>>>                 ret = -EACCES;
>>>>
>>>> This logic seems rather confused to me.  Without this patch, a user
>>>> can write to procs if it's root *or* it matches the target uid *or* it
>>>> matches the target suid.  How does this make sense?  How about
>>>> ptrace_may_access(...) || ns_capable(tcred->user_ns,
>>>> CAP_CGROUP_MIGRATE)?
>>>
>>> Though ptrace_may_access would open it also to apps with
>>> CAP_SYS_PTRACE as well, no?
>>>
>>> Would pulling out from __ptrace_may_access the:
>>>  if (uid_eq(caller_uid, tcred->euid) &&
>>>             uid_eq(caller_uid, tcred->suid) &&
>>>             uid_eq(caller_uid, tcred->uid)  &&
>>>             gid_eq(caller_gid, tcred->egid) &&
>>>             gid_eq(caller_gid, tcred->sgid) &&
>>>             gid_eq(caller_gid, tcred->gid))
>>>                 goto ok;
>>>
>>> check and creating a new helper that could be shared between them be
>>> the right approach?
>>
>> So, is creating a new capability here necessarily the right approach?
>> Is this operation so unique, or is there an existing silo (not
>> CAP_SYS_ADMIN) that we can re-use? I ask, because we currently use 38
>> silos out of a possible 64 capabilities, and when everyone chooses
>> single-use capabilities, we will quickly exhaust the silos.
> 
> Agreed this is a concern, and CGROUP_MIGRATE is maybe too narrow of a
> specification for something so limited.
> 
>> I'm not saying that creating a new capability here is wrong, but it is
>> worth further considering the existing silos to see if there is one
>> that is a suitable match.
>>
>> Looking at http://man7.org/linux/man-pages/man7/capabilities.7.html
>> throws up the following possibilities:
>>
>> CAP_SYS_NICE
> 
> Again, for Android uses, CAP_SYS_NICE would be fine (ideal really),
> but I worry that it might be too commonly given in other systems to
> allow a task to migrate potential cgroup restrictions in container
> focused environments.
> 
>> CAP_SYS_PTRACE
> 
> For Android, PTRACE requires too much privilege given to the
> controlling task, as that would allow the system_server to also be
> able to inspect memory of all other tasks, which raises security
> concerns.  (We already went through this with the
> proc/<tid>/timerslack_ns interface, and had to move back to
> CAP_SYS_NICE there).
> 
> 
>> CAP_SYS_RESOURCE
>>
>> I'm aware that you said above that use CAP_SYS_NICE overloads that
>> capability a bit too much. Maybe it's true, but on the other hand, by
>> my count from dome rough grepping of the kernel source, there are a
>> total of 14 capable() checks for CAP_SYS_NICE, out of a total of
>> around 1256 capable() checks altogether. So, I think this does need to
>> be balanced against the limited number of silos.
>>
>> Also, CAP_SYS_RESOURCE deserves consideration (34 uses in capable()
>> checks). I'd say, since cgroups are about resources, so there's
>> something of a match there., so it's also worth considering.
> 
> I'll try to look into CAP_SYS_RESOURCE.
> 
> Colin/Todd: Any objection from the Android side on CAP_SYS_RESOURCE?

Just to reiterate my perspective: I'm suggesting that one
of the existing silos be considered only. It may be that because
of the smearing issues you allude to (where the fact that a process
may have the capability for another purpose that inadvertently
allows it also to cgroup migration), that a new capability
is in order. I just want to make sure that the issue is considered
(and--importantly--that the rationale for the eventual decision is
documented in the commit message!).

Cheers,

Michael


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
