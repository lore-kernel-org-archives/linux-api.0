From: Prakash Sangappa <prakash.sangappa@oracle.com>
Subject: [RESEND RFC PATCH 1/1] Selectively allow CAP_SYS_NICE capability inside user namespaces
Date: Mon, 18 Nov 2019 09:01:18 -0800
Message-ID: <1574096478-11520-2-git-send-email-prakash.sangappa@oracle.com>
References: <1574096478-11520-1-git-send-email-prakash.sangappa@oracle.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1574096478-11520-1-git-send-email-prakash.sangappa@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
Cc: ebiederm@xmission.com, tglx@linutronix.de, peterz@infradead.org, serge@hallyn.com, prakash.sangappa@oracle.com
List-Id: linux-api@vger.kernel.org

Allow CAP_SYS_NICE to take effect for processes having effective uid of a
root user from init namespace.

Signed-off-by: Prakash Sangappa <prakash.sangappa@oracle.com>
---
 kernel/sched/core.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 7880f4f..628bd46 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -4548,6 +4548,8 @@ int can_nice(const struct task_struct *p, const int nice)
 	int nice_rlim = nice_to_rlimit(nice);
 
 	return (nice_rlim <= task_rlimit(p, RLIMIT_NICE) ||
+		(ns_capable(__task_cred(p)->user_ns, CAP_SYS_NICE) &&
+		uid_eq(current_euid(), GLOBAL_ROOT_UID)) ||
 		capable(CAP_SYS_NICE));
 }
 
@@ -4784,7 +4786,9 @@ static int __sched_setscheduler(struct task_struct *p,
 	/*
 	 * Allow unprivileged RT tasks to decrease priority:
 	 */
-	if (user && !capable(CAP_SYS_NICE)) {
+	if (user && !(ns_capable(__task_cred(p)->user_ns, CAP_SYS_NICE) &&
+		uid_eq(current_euid(), GLOBAL_ROOT_UID)) &&
+		!capable(CAP_SYS_NICE)) {
 		if (fair_policy(policy)) {
 			if (attr->sched_nice < task_nice(p) &&
 			    !can_nice(p, attr->sched_nice))
-- 
2.7.4
