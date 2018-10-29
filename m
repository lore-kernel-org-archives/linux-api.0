From: Patrick Bellasi <patrick.bellasi@arm.com>
Subject: [PATCH v5 02/15] sched/core: make sched_setattr able to tune the current policy
Date: Mon, 29 Oct 2018 18:32:56 +0000
Message-ID: <20181029183311.29175-3-patrick.bellasi@arm.com>
References: <20181029183311.29175-1-patrick.bellasi@arm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181029183311.29175-1-patrick.bellasi@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Tejun Heo <tj@kernel.org>, "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>, Vincent Guittot <vincent.guittot@linaro.org>, Viresh Kumar <viresh.kumar@linaro.org>, Paul Turner <pjt@google.com>, Quentin Perret <quentin.perret@arm.com>, Dietmar Eggemann <dietmar.eggemann@arm.com>, Morten Rasmussen <morten.rasmussen@arm.com>, Juri Lelli <juri.lelli@redhat.com>, Todd Kjos <tkjos@google.com>, Joel Fernandes <joelaf@google.com>, Steve Muckle <smuckle@google.com>, Suren Baghdasaryan <surenb@google.com>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Currently, sched_setattr mandates that a policy is always specified.
Since utilization clamp attributes could apply across different
scheduling policies (i.e. all but SCHED_DEADLINE), this requires also
to always know which policy a task has before changing its clamp values.

This is not just cumbersome but it's also racy, indeed we cannot be
sure that a task policy has been changed in between its policy read and
the actual clamp value change. Sometimes however, this could be the
actual use-case, we wanna change the clamps without affecting the
policy.

Let's fix this adding an additional attribute flag
(SCHED_FLAG_TUNE_POLICY) which, when specified, will ensure to always
force the usage of the current policy. This is done by re-using the
SETPARAM_POLICY thing we already have for the sched_setparam syscall,
thus extending its usage to the non-POSIX sched_setattr while not
exposing that internal concept to user-space.

Signed-off-by: Patrick Bellasi <patrick.bellasi@arm.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Todd Kjos <tkjos@google.com>
Cc: Joel Fernandes <joelaf@google.com>
Cc: Steve Muckle <smuckle@google.com>
Cc: Juri Lelli <juri.lelli@redhat.com>
Cc: linux-kernel@vger.kernel.org
Cc: linux-pm@vger.kernel.org
Cc: linux-api@vger.kernel.org

---
Changes in v5:
 Message-ID: <20180905110108.GC20267@localhost.localdomain>
 - allow to change clamp values without affecting current policy
---
 include/uapi/linux/sched.h |  6 +++++-
 kernel/sched/core.c        | 11 ++++++++++-
 2 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/sched.h b/include/uapi/linux/sched.h
index c27d6e81517b..62498d749bec 100644
--- a/include/uapi/linux/sched.h
+++ b/include/uapi/linux/sched.h
@@ -40,6 +40,8 @@
 /* SCHED_ISO: reserved but not implemented yet */
 #define SCHED_IDLE		5
 #define SCHED_DEADLINE		6
+/* Must be the last entry: used check attr.policy values */
+#define SCHED_POLICY_MAX	7
 
 /* Can be ORed in to make sure the process is reverted back to SCHED_NORMAL on fork */
 #define SCHED_RESET_ON_FORK     0x40000000
@@ -50,11 +52,13 @@
 #define SCHED_FLAG_RESET_ON_FORK	0x01
 #define SCHED_FLAG_RECLAIM		0x02
 #define SCHED_FLAG_DL_OVERRUN		0x04
-#define SCHED_FLAG_UTIL_CLAMP		0x08
+#define SCHED_FLAG_TUNE_POLICY		0x08
+#define SCHED_FLAG_UTIL_CLAMP		0x10
 
 #define SCHED_FLAG_ALL	(SCHED_FLAG_RESET_ON_FORK	| \
 			 SCHED_FLAG_RECLAIM		| \
 			 SCHED_FLAG_DL_OVERRUN		| \
+			 SCHED_FLAG_TUNE_POLICY		| \
 			 SCHED_FLAG_UTIL_CLAMP)
 
 #endif /* _UAPI_LINUX_SCHED_H */
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 3701bb1e6698..9a2e12eaa377 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -4595,8 +4595,17 @@ SYSCALL_DEFINE3(sched_setattr, pid_t, pid, struct sched_attr __user *, uattr,
 	if (retval)
 		return retval;
 
-	if ((int)attr.sched_policy < 0)
+	/*
+	 * A valid policy has always to be required from userspace.  Unless
+	 * the SCHED_FLAG_TUNE_POLICY is set, in which case, the current
+	 * policy will be enforced for this call.
+	 */
+	if (attr.sched_policy >= SCHED_POLICY_MAX &&
+	    !(attr.sched_flags & SCHED_FLAG_TUNE_POLICY)) {
 		return -EINVAL;
+	}
+	if (attr.sched_flags & SCHED_FLAG_TUNE_POLICY)
+		attr.sched_policy = SETPARAM_POLICY;
 
 	rcu_read_lock();
 	retval = -ESRCH;
-- 
2.18.0
