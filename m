From: Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: [PATCH v5] cgroup: Add new capability to allow a process to
 migrate other tasks between cgroups
Date: Tue, 13 Dec 2016 08:39:21 -0800
Message-ID: <221e80bd-3d99-6c35-dcd3-b2547f0abb11@schaufler-ca.com>
References: <1481593143-18756-1-git-send-email-john.stultz@linaro.org>
 <CAKgNAkhGSYmtqLnCyXH8-dbmBJreo9mbVGRMyd_9hZ5D1F7q4g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAKgNAkhGSYmtqLnCyXH8-dbmBJreo9mbVGRMyd_9hZ5D1F7q4g@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: mtk.manpages@gmail.com, John Stultz <john.stultz@linaro.org>
Cc: lkml <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Jonathan Corbet <corbet@lwn.net>, "open list:CONTROL GROUP (CGROUP)" <cgroups@vger.kernel.org>, Android Kernel Team <kernel-team@android.com>, Rom Lemarchand <romlem@android.com>, Colin Cross <ccross@android.com>, Dmitry Shmidt <dimitrysh@google.com>, Todd Kjos <tkjos@google.com>, Christian Poetzsch <christian.potzsch@imgtec.com>, Amit Pundir <amit.pundir@linaro.org>, Dmitry Torokhov <dmitry.torokhov@gmail.com>, Kees Cook <keescook@chromium.org>, "Serge E . Hallyn" <serge@hallyn.com>, Andy Lutomirski <luto@amacapital.net>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On 12/13/2016 1:47 AM, Michael Kerrisk (man-pages) wrote:
> Hi John,
>
> On 13 December 2016 at 02:39, John Stultz <john.stultz@linaro.org> wrote:
>> This patch adds CAP_GROUP_MIGRATE and logic to allows a process
> s/CAP_GROUP_MIGRATE/CAP_CGROUP_MIGRATE/
>
>> to migrate other tasks between cgroups.
>>
>> In Android (where this feature originated), the ActivityManager
>> tracks various application states (TOP_APP, FOREGROUND,
>> BACKGROUND, SYSTEM, etc), and then as applications change
>> states, the SchedPolicy logic will migrate the application tasks
>> between different cgroups used to control the different
>> application states (for example, there is a background cpuset
>> cgroup which can limit background tasks to stay on one low-power
>> cpu, and the bg_non_interactive cpuctrl cgroup can then further
>> limit those background tasks to a small percentage of that one
>> cpu's cpu time).
>>
>> However, for security reasons, Android doesn't want to make the
>> system_server (the process that runs the ActivityManager and
>> SchedPolicy logic), run as root. So in the Android common.git
>> kernel, they have some logic to allow cgroups to loosen their
>> permissions so CAP_SYS_NICE tasks can migrate other tasks between
>> cgroups.
>>
>> I feel the approach taken there overloads CAP_SYS_NICE a bit much
>> for non-android environments. Efforts to re-use CAP_SYS_RESOURCE
>> for this purpose (which Android has since adopted) was also
>> stymied by concerns about risks from future cgroups that could be
>> considered "dangerous" by how they might change system semantics.
>>
>> So to avoid overlapping usage, this patch adds a brand new
>> process capability flag (CAP_CGROUP_MIGRATE), and uses it when
>> checking if a task can migrate other tasks between cgroups.
>>
>> I've tested this with AOSP master (though its a bit hacked in as
>> I still need to properly get the selinux bits aware of the new
>> capability bit) with selinux set to permissive and it seems to be
>> working well.
>>
>> Thoughts and feedback would be appreciated!
> So, back to the discussion of silos. I understand the argument for
> wanting a new silo. But, in that case can we at least try not to make
> it a single-use silo?
>
> How about CAP_CGROUP_CONTROL or some such, with the idea that this
> might be a capability that allows the holder to step outside usual
> cgroup rules? At the moment, that capability would allow only one such
> step, but maybe there would be others in the future.

I agree, but want to put it more strongly. The granularity of
capabilities can never be fine enough for some people, and this
is an example of a case where you're going a bit too far. If the
use case is Android as you say, you don't need this. As my friends
on the far side of the aisle would say, "just write SELinux policy"
to correctly control access as required.

>
> Cheers,
>
> Michael
>
>
>> Cc: Tejun Heo <tj@kernel.org>
>> Cc: Li Zefan <lizefan@huawei.com>
>> Cc: Jonathan Corbet <corbet@lwn.net>
>> Cc: cgroups@vger.kernel.org
>> Cc: Android Kernel Team <kernel-team@android.com>
>> Cc: Rom Lemarchand <romlem@android.com>
>> Cc: Colin Cross <ccross@android.com>
>> Cc: Dmitry Shmidt <dimitrysh@google.com>
>> Cc: Todd Kjos <tkjos@google.com>
>> Cc: Christian Poetzsch <christian.potzsch@imgtec.com>
>> Cc: Amit Pundir <amit.pundir@linaro.org>
>> Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
>> Cc: Kees Cook <keescook@chromium.org>
>> Cc: Serge E. Hallyn <serge@hallyn.com>
>> Cc: Andy Lutomirski <luto@amacapital.net>
>> Cc: linux-api@vger.kernel.org
>> Acked-by: Serge Hallyn <serge@hallyn.com>
>> Signed-off-by: John Stultz <john.stultz@linaro.org>
>> ---
>> v2: Renamed to just CAP_CGROUP_MIGRATE as reccomended by Tejun
>> v3: Switched to just using CAP_SYS_RESOURCE as suggested by Michael
>> v4: Send out properly folded down version of the patch. :P
>> v5: Switch back to CAP_CGROUP_MIGRATE due to concerns from Andy
>> ---
>>  include/uapi/linux/capability.h | 5 ++++-
>>  kernel/cgroup.c                 | 3 ++-
>>  2 files changed, 6 insertions(+), 2 deletions(-)
>>
>> diff --git a/include/uapi/linux/capability.h b/include/uapi/linux/capability.h
>> index 49bc062..32d3829 100644
>> --- a/include/uapi/linux/capability.h
>> +++ b/include/uapi/linux/capability.h
>> @@ -349,8 +349,11 @@ struct vfs_cap_data {
>>
>>  #define CAP_AUDIT_READ         37
>>
>> +/* Allow migration of other tasks between cgroups */
>>
>> -#define CAP_LAST_CAP         CAP_AUDIT_READ
>> +#define CAP_CGROUP_MIGRATE     38
>> +
>> +#define CAP_LAST_CAP         CAP_CGROUP_MIGRATE
>>
>>  #define cap_valid(x) ((x) >= 0 && (x) <= CAP_LAST_CAP)
>>
>> diff --git a/kernel/cgroup.c b/kernel/cgroup.c
>> index 2ee9ec3..784f115 100644
>> --- a/kernel/cgroup.c
>> +++ b/kernel/cgroup.c
>> @@ -2856,7 +2856,8 @@ static int cgroup_procs_write_permission(struct task_struct *task,
>>          */
>>         if (!uid_eq(cred->euid, GLOBAL_ROOT_UID) &&
>>             !uid_eq(cred->euid, tcred->uid) &&
>> -           !uid_eq(cred->euid, tcred->suid))
>> +           !uid_eq(cred->euid, tcred->suid) &&
>> +           !ns_capable(tcred->user_ns, CAP_CGROUP_MIGRATE))
>>                 ret = -EACCES;
>>
>>         if (!ret && cgroup_on_dfl(dst_cgrp)) {
>> --
>> 2.7.4
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-api" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
