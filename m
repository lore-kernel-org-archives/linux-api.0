From: Richard Guy Briggs <rgb@redhat.com>
Subject: [RFC PATCH V1 06/12] audit: add support for non-syscall auxiliary records
Date: Thu,  1 Mar 2018 14:41:09 -0500
Message-ID: <e26d089d495f2ffd1d4e1f3de7730aa209340a59.1519930146.git.rgb@redhat.com>
References: <cover.1519930146.git.rgb@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1519930146.git.rgb@redhat.com>
In-Reply-To: <cover.1519930146.git.rgb@redhat.com>
References: <cover.1519930146.git.rgb@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: cgroups@vger.kernel.org, containers@lists.linux-foundation.org, linux-api@vger.kernel.org, Linux-Audit Mailing List <linux-audit@redhat.com>, linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org
Cc: mszeredi@redhat.com, luto@kernel.org, jlayton@redhat.com, carlos@redhat.com, viro@zeniv.linux.org.uk, dhowells@redhat.com, simo@redhat.com, trondmy@primarydata.com, eparis@parisplace.org, serge@hallyn.com, ebiederm@xmission.com, madzcar@gmail.com, Richard Guy Briggs <rgb@redhat.com>
List-Id: linux-api@vger.kernel.org

Standalone audit records have the timestamp and serial number generated
on the fly and as such are unique, making them standalone.  This is a
prototype of a method to generate a local audit context that will be
used only for a standalone record and its auxiliary record.  The context
is discarded immediately after the local associated records are
produced.

Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
---
 include/linux/audit.h |  8 ++++++++
 kernel/auditsc.c      | 20 +++++++++++++++++++-
 2 files changed, 27 insertions(+), 1 deletion(-)

diff --git a/include/linux/audit.h b/include/linux/audit.h
index ed16bb6..c0b83cb 100644
--- a/include/linux/audit.h
+++ b/include/linux/audit.h
@@ -227,7 +227,9 @@ static inline int audit_log_container_info(struct audit_context *context,
 /* These are defined in auditsc.c */
 				/* Public API */
 extern int  audit_alloc(struct task_struct *task);
+extern struct audit_context *audit_alloc_local(void);
 extern void __audit_free(struct task_struct *task);
+extern void audit_free_context(struct audit_context *context);
 extern void __audit_syscall_entry(int major, unsigned long a0, unsigned long a1,
 				  unsigned long a2, unsigned long a3);
 extern void __audit_syscall_exit(int ret_success, long ret_value);
@@ -472,6 +474,12 @@ static inline int audit_alloc(struct task_struct *task)
 {
 	return 0;
 }
+static inline struct audit_context *audit_alloc_local(void)
+{
+	return NULL;
+}
+static inline void audit_free_context(struct audit_context *context)
+{ }
 static inline void audit_free(struct task_struct *task)
 { }
 static inline void audit_syscall_entry(int major, unsigned long a0,
diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index 0e41884..0cbd762 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -959,8 +959,26 @@ int audit_alloc(struct task_struct *tsk)
 	return 0;
 }
 
-static inline void audit_free_context(struct audit_context *context)
+struct audit_context *audit_alloc_local(void)
 {
+	struct audit_context *context;
+
+	if (likely(!audit_ever_enabled))
+		return NULL; /* Return if not auditing. */
+
+	context = audit_alloc_context(AUDIT_RECORD_CONTEXT);
+	if (!context)
+		return NULL;
+	context->serial = audit_serial();
+	context->ctime = current_kernel_time64();
+	context->in_syscall = 1;
+	return context;
+}
+
+inline void audit_free_context(struct audit_context *context)
+{
+	if (!context)
+		return;
 	audit_free_names(context);
 	unroll_tree_refs(context, NULL, 0);
 	free_tree_refs(context);
-- 
1.8.3.1
