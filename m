From: John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v5] cgroup: Add new capability to allow a process to
 migrate other tasks between cgroups
Date: Mon, 12 Dec 2016 17:40:50 -0800
Message-ID: <CALAqxLXEk2bKw71FXoE-fEPCew2SRgfZvU7-dqjpM3zYdiTVew@mail.gmail.com>
References: <1481593143-18756-1-git-send-email-john.stultz@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1481593143-18756-1-git-send-email-john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, "open list:CONTROL GROUP (CGROUP)" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Android Kernel Team <kernel-team-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Rom Lemarchand <romlem-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Colin Cross <ccross-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Dmitry Shmidt <dimitrysh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Todd Kjos <tkjos-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Christian Poetzsch <christian.potzsch-1AXoQHu6uovQT0dZR+AlfA@public.gmane.org>, Amit Pundir <amit.pundir-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Dmitry Torokhov <dmitry.torokhov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, "Serge E . Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Mon, Dec 12, 2016 at 5:39 PM, John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> wrote:
> This patch adds CAP_GROUP_MIGRATE and logic to allows a process
> to migrate other tasks between cgroups.
>
> In Android (where this feature originated), the ActivityManager
> tracks various application states (TOP_APP, FOREGROUND,
> BACKGROUND, SYSTEM, etc), and then as applications change
> states, the SchedPolicy logic will migrate the application tasks
> between different cgroups used to control the different
> application states (for example, there is a background cpuset
> cgroup which can limit background tasks to stay on one low-power
> cpu, and the bg_non_interactive cpuctrl cgroup can then further
> limit those background tasks to a small percentage of that one
> cpu's cpu time).
>
> However, for security reasons, Android doesn't want to make the
> system_server (the process that runs the ActivityManager and
> SchedPolicy logic), run as root. So in the Android common.git
> kernel, they have some logic to allow cgroups to loosen their
> permissions so CAP_SYS_NICE tasks can migrate other tasks between
> cgroups.
>
> I feel the approach taken there overloads CAP_SYS_NICE a bit much
> for non-android environments. Efforts to re-use CAP_SYS_RESOURCE
> for this purpose (which Android has since adopted) was also
> stymied by concerns about risks from future cgroups that could be
> considered "dangerous" by how they might change system semantics.
>
> So to avoid overlapping usage, this patch adds a brand new
> process capability flag (CAP_CGROUP_MIGRATE), and uses it when
> checking if a task can migrate other tasks between cgroups.
>
> I've tested this with AOSP master (though its a bit hacked in as
> I still need to properly get the selinux bits aware of the new
> capability bit) with selinux set to permissive and it seems to be
> working well.
>
> Thoughts and feedback would be appreciated!
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
> Cc: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
> Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Acked-by: Serge Hallyn <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>

After sending this I just realized that this is changed enough I
should probably remove Serge's Acked-by here. Apologies.

But otherwise feedback on this would be appreciated!

thanks
-john
