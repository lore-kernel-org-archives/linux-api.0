From: Patrick Bellasi <patrick.bellasi@arm.com>
Subject: [PATCH v8 05/16] sched/core: Allow sched_setattr() to use the current policy
Date: Tue,  2 Apr 2019 11:41:41 +0100
Message-ID: <20190402104153.25404-6-patrick.bellasi@arm.com>
References: <20190402104153.25404-1-patrick.bellasi@arm.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190402104153.25404-1-patrick.bellasi@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, linux-api@vger.kernel.org
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Tejun Heo <tj@kernel.org>, "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>, Vincent Guittot <vincent.guittot@linaro.org>, Viresh Kumar <viresh.kumar@linaro.org>, Paul Turner <pjt@google.com>, Quentin Perret <quentin.perret@arm.com>, Dietmar Eggemann <dietmar.eggemann@arm.com>, Morten Rasmussen <morten.rasmussen@arm.com>, Juri Lelli <juri.lelli@redhat.com>, Todd Kjos <tkjos@google.com>, Joel Fernandes <joelaf@google.com>, Steve Muckle <smuckle@google.com>, Suren Baghdasaryan <surenb@google.com>
List-Id: linux-api@vger.kernel.org

The sched_setattr() syscall mandates that a policy is always specified.
This requires to always know which policy a task will have when
attributes are configured and this makes it impossible to add more
generic task attributes valid across different scheduling policies.
Reading the policy before setting generic tasks attributes is racy since
we cannot be sure it is not changed concurrently.

Introduce the required support to change generic task attributes without
affecting the current task policy. This is done by adding an attribute flag
(SCHED_FLAG_KEEP_POLICY) to enforce the usage of the current policy.

Add support for the SETPARAM_POLICY policy, which is already used by the
sched_setparam() POSIX syscall, to the sched_setattr() non-POSIX
syscall.

Signed-off-by: Patrick Bellasi <patrick.bellasi@arm.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
---
 include/uapi/linux/sched.h |  6 +++++-
 kernel/sched/core.c        | 11 ++++++++++-
 2 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/sched.h b/include/uapi/linux/sched.h
index 22627f80063e..075c610adf45 100644
--- a/include/uapi/linux/sched.h
+++ b/include/uapi/linux/sched.h
@@ -40,6 +40,8 @@
 /* SCHED_ISO: reserved but not implemented yet */
 #define SCHED_IDLE		5
 #define SCHED_DEADLINE		6
+/* Must be the last entry: used to sanity check attr.policy values */
+#define SCHED_POLICY_MAX	SCHED_DEADLINE
 
 /* Can be ORed in to make sure the process is reverted back to SCHED_NORMAL on fork */
 #define SCHED_RESET_ON_FORK     0x40000000
@@ -50,9 +52,11 @@
 #define SCHED_FLAG_RESET_ON_FORK	0x01
 #define SCHED_FLAG_RECLAIM		0x02
 #define SCHED_FLAG_DL_OVERRUN		0x04
+#define SCHED_FLAG_KEEP_POLICY		0x08
 
 #define SCHED_FLAG_ALL	(SCHED_FLAG_RESET_ON_FORK	| \
 			 SCHED_FLAG_RECLAIM		| \
-			 SCHED_FLAG_DL_OVERRUN)
+			 SCHED_FLAG_DL_OVERRUN		| \
+			 SCHED_FLAG_KEEP_POLICY)
 
 #endif /* _UAPI_LINUX_SCHED_H */
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index d368ac26b8aa..20efb32e1a7e 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -4907,8 +4907,17 @@ SYSCALL_DEFINE3(sched_setattr, pid_t, pid, struct sched_attr __user *, uattr,
 	if (retval)
 		return retval;
 
-	if ((int)attr.sched_policy < 0)
+	/*
+	 * A valid policy is always required from userspace, unless
+	 * SCHED_FLAG_KEEP_POLICY is set and the current policy
+	 * is enforced for this call.
+	 */
+	if (attr.sched_policy > SCHED_POLICY_MAX &&
+	    !(attr.sched_flags & SCHED_FLAG_KEEP_POLICY)) {
 		return -EINVAL;
+	}
+	if (attr.sched_flags & SCHED_FLAG_KEEP_POLICY)
+		attr.sched_policy = SETPARAM_POLICY;
 
 	rcu_read_lock();
 	retval = -ESRCH;
-- 
2.20.1
