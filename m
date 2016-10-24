From: John Stultz <john.stultz@linaro.org>
Subject: [PATCH v4] cgroup: Use CAP_SYS_RESOURCE to allow a process to migrate other tasks between cgroups
Date: Mon, 24 Oct 2016 13:37:00 -0700
Message-ID: <1477341420-21857-1-git-send-email-john.stultz@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: lkml <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Jonathan Corbet <corbet@lwn.net>, cgroups@vger.kernel.org, Android Kernel Team <kernel-team@android.com>, Rom Lemarchand <romlem@android.com>, Colin Cross <ccross@android.com>, Dmitry Shmidt <dimitrysh@google.com>, Todd Kjos <tkjos@google.com>, Christian Poetzsch <christian.potzsch@imgtec.com>, Amit Pundir <amit.pundir@linaro.org>, Dmitry Torokhov <dmitry.torokhov@gmail.com>, Kees Cook <keescook@chromium.org>, "Serge E . Hallyn" <serge@hallyn.com>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

This patch adds logic to allows a process to migrate other tasks
between cgroups if they have CAP_SYS_RESOURCE.

In Android (where this feature originated), the ActivityManager tracks
various application states (TOP_APP, FOREGROUND, BACKGROUND, SYSTEM,
etc), and then as applications change states, the SchedPolicy logic
will migrate the application tasks between different cgroups used
to control the different application states (for example, there is a
background cpuset cgroup which can limit background tasks to stay
on one low-power cpu, and the bg_non_interactive cpuctrl cgroup can
then further limit those background tasks to a small percentage of
that one cpu's cpu time).

However, for security reasons, Android doesn't want to make the
system_server (the process that runs the ActivityManager and
SchedPolicy logic), run as root. So in the Android common.git
kernel, they have some logic to allow cgroups to loosen their
permissions so CAP_SYS_NICE tasks can migrate other tasks between
cgroups.

I feel the approach taken there overloads CAP_SYS_NICE a bit much
for non-android environments.

So this patch, as suggested by Michael Kerrisk, simply adds a
check for CAP_SYS_RESOURCE.

I've tested this with AOSP master, and this seems to work well
as Zygote and system_server already use CAP_SYS_RESOURCE. I've
also submitted patches against the android-4.4 kernel to change
it to use CAP_SYS_RESOURCE, and the Android developers just merged
it.

Thouhts and feedback would be appreciated!

Cc: Tejun Heo <tj@kernel.org>
Cc: Li Zefan <lizefan@huawei.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: cgroups@vger.kernel.org
Cc: Android Kernel Team <kernel-team@android.com>
Cc: Rom Lemarchand <romlem@android.com>
Cc: Colin Cross <ccross@android.com>
Cc: Dmitry Shmidt <dimitrysh@google.com>
Cc: Todd Kjos <tkjos@google.com>
Cc: Christian Poetzsch <christian.potzsch@imgtec.com>
Cc: Amit Pundir <amit.pundir@linaro.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Serge E. Hallyn <serge@hallyn.com>
Cc: linux-api@vger.kernel.org
Acked-by: Serge Hallyn <serge@hallyn.com>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
v2: Renamed to just CAP_CGROUP_MIGRATE as reccomended by Tejun
v3: Switched to just using CAP_SYS_RESOURCE as suggested by Michael
v4: Send out properly folded down version of the patch. :P
---
 kernel/cgroup.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 85bc9be..866059a 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -2856,7 +2856,8 @@ static int cgroup_procs_write_permission(struct task_struct *task,
 	 */
 	if (!uid_eq(cred->euid, GLOBAL_ROOT_UID) &&
 	    !uid_eq(cred->euid, tcred->uid) &&
-	    !uid_eq(cred->euid, tcred->suid))
+	    !uid_eq(cred->euid, tcred->suid) &&
+	    !ns_capable(tcred->user_ns, CAP_SYS_RESOURCE))
 		ret = -EACCES;
 
 	if (!ret && cgroup_on_dfl(dst_cgrp)) {
-- 
2.7.4
