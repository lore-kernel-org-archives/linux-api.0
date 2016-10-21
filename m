From: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC][PATCH v3] cgroup: Use CAP_SYS_RESOURCE to allow a process
 to migrate other tasks between cgroups
Date: Fri, 21 Oct 2016 08:42:22 +0200
Message-ID: <937568dd-61b8-ac09-3cdf-789ff14f5423@gmail.com>
References: <1477013079-23692-1-git-send-email-john.stultz@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1477013079-23692-1-git-send-email-john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Android Kernel Team <kernel-team-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Rom Lemarchand <romlem-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Colin Cross <ccross-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Dmitry Shmidt <dimitrysh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Todd Kjos <tkjos-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Christian Poetzsch <christian.potzsch-1AXoQHu6uovQT0dZR+AlfA@public.gmane.org>, Amit Pundir <amit.pundir-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Dmitry Torokhov <dmitry.torokhov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, "Serge E . Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Hi John,

On 10/21/2016 03:24 AM, John Stultz wrote:
> This patch adds logic to allows a process to migrate other tasks
> between cgroups if they have CAP_SYS_RESOURCE.

This appears to be a patch against your previous patch, 
rather than against mainline. Was that intended?

Cheers,

Michael


> In Android (where this feature originated), the ActivityManager tracks
> various application states (TOP_APP, FOREGROUND, BACKGROUND, SYSTEM,
> etc), and then as applications change states, the SchedPolicy logic
> will migrate the application tasks between different cgroups used
> to control the different application states (for example, there is a
> background cpuset cgroup which can limit background tasks to stay
> on one low-power cpu, and the bg_non_interactive cpuctrl cgroup can
> then further limit those background tasks to a small percentage of
> that one cpu's cpu time).
> 
> However, for security reasons, Android doesn't want to make the
> system_server (the process that runs the ActivityManager and
> SchedPolicy logic), run as root. So in the Android common.git
> kernel, they have some logic to allow cgroups to loosen their
> permissions so CAP_SYS_NICE tasks can migrate other tasks between
> cgroups.
> 
> I feel the approach taken there overloads CAP_SYS_NICE a bit much,
> and is maybe more complicated then needed.
> 
> So this patch, as suggested by Michael Kerrisk, simply adds a
> check for CAP_SYS_RESOURCE.
> 
> I've tested this with AOSP master, and this seems to work well
> as Zygote and system_server already use CAP_SYS_RESOURCE. I've
> also submitted patches against the android-4.4 kernel to change
> it to use CAP_SYS_RESOURCE, and the Android developers have
> seemed ok with this change.
> 
> Thouhts and feedback would be appreciated!
> 
> Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> Cc: Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>
> Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Cc: Android Kernel Team <kernel-team-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>
> Cc: Rom Lemarchand <romlem-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>
> Cc: Colin Cross <ccross-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>
> Cc: Dmitry Shmidt <dimitrysh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> Cc: Todd Kjos <tkjos-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> Cc: Christian Poetzsch <christian.potzsch-1AXoQHu6uovQT0dZR+AlfA@public.gmane.org>
> Cc: Amit Pundir <amit.pundir-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> Cc: Dmitry Torokhov <dmitry.torokhov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Cc: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
> Cc: Serge E. Hallyn <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>
> Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Signed-off-by: John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> ---
> v2: Renamed to just CAP_CGROUP_MIGRATE as reccomended by Tejun
> v3: Switched to just using CAP_SYS_RESOURCE as suggested by Michael
> ---
>  kernel/cgroup.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/kernel/cgroup.c b/kernel/cgroup.c
> index 09f84d2..866059a 100644
> --- a/kernel/cgroup.c
> +++ b/kernel/cgroup.c
> @@ -2857,7 +2857,7 @@ static int cgroup_procs_write_permission(struct task_struct *task,
>  	if (!uid_eq(cred->euid, GLOBAL_ROOT_UID) &&
>  	    !uid_eq(cred->euid, tcred->uid) &&
>  	    !uid_eq(cred->euid, tcred->suid) &&
> -	    !ns_capable(tcred->user_ns, CAP_CGROUP_MIGRATE))
> +	    !ns_capable(tcred->user_ns, CAP_SYS_RESOURCE))
>  		ret = -EACCES;
>  
>  	if (!ret && cgroup_on_dfl(dst_cgrp)) {
> 


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
