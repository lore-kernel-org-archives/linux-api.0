From: Richard Guy Briggs <rgb@redhat.com>
Subject: [RFC PATCH V1 10/12] audit: add containerid support for seccomp and anom_abend records
Date: Thu,  1 Mar 2018 14:41:13 -0500
Message-ID: <a7d7447356a7f6335d6a393ec97d1fbbc341ba33.1519930146.git.rgb@redhat.com>
References: <cover.1519930146.git.rgb@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1519930146.git.rgb@redhat.com>
In-Reply-To: <cover.1519930146.git.rgb@redhat.com>
References: <cover.1519930146.git.rgb@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: cgroups@vger.kernel.org, containers@lists.linux-foundation.org, linux-api@vger.kernel.org, Linux-Audit Mailing List <linux-audit@redhat.com>, linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org
Cc: mszeredi@redhat.com, luto@kernel.org, jlayton@redhat.com, carlos@redhat.com, viro@zeniv.linux.org.uk, dhowells@redhat.com, simo@redhat.com, trondmy@primarydata.com, eparis@parisplace.org, serge@hallyn.com, ebiederm@xmission.com, madzcar@gmail.com, Richard Guy Briggs <rgb@redhat.com>
List-Id: linux-api@vger.kernel.org

Add container ID information to secure computing and abnormal end
standalone records.

Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
---
 kernel/auditsc.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index 0cbd762..fcee34e 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -2569,6 +2569,7 @@ static void audit_log_task(struct audit_buffer *ab)
 void audit_core_dumps(long signr)
 {
 	struct audit_buffer *ab;
+	struct audit_context *context = audit_alloc_local();
 
 	if (!audit_enabled)
 		return;
@@ -2576,19 +2577,22 @@ void audit_core_dumps(long signr)
 	if (signr == SIGQUIT)	/* don't care for those */
 		return;
 
-	ab = audit_log_start(NULL, GFP_KERNEL, AUDIT_ANOM_ABEND);
+	ab = audit_log_start(context, GFP_KERNEL, AUDIT_ANOM_ABEND);
 	if (unlikely(!ab))
 		return;
 	audit_log_task(ab);
 	audit_log_format(ab, " sig=%ld res=1", signr);
 	audit_log_end(ab);
+	audit_log_container_info(context, "abend", audit_get_containerid(current));
+	audit_free_context(context);
 }
 
 void __audit_seccomp(unsigned long syscall, long signr, int code)
 {
 	struct audit_buffer *ab;
+	struct audit_context *context = audit_alloc_local();
 
-	ab = audit_log_start(NULL, GFP_KERNEL, AUDIT_SECCOMP);
+	ab = audit_log_start(context, GFP_KERNEL, AUDIT_SECCOMP);
 	if (unlikely(!ab))
 		return;
 	audit_log_task(ab);
@@ -2596,6 +2600,8 @@ void __audit_seccomp(unsigned long syscall, long signr, int code)
 			 signr, syscall_get_arch(), syscall,
 			 in_compat_syscall(), KSTK_EIP(current), code);
 	audit_log_end(ab);
+	audit_log_container_info(context, "seccomp", audit_get_containerid(current));
+	audit_free_context(context);
 }
 
 struct list_head *audit_killed_trees(void)
-- 
1.8.3.1
