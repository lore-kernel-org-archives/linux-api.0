From: Richard Guy Briggs <rgb@redhat.com>
Subject: [PATCH ghak90 (was ghak32) V4 04/10] audit: add containerid support for ptrace and signals
Date: Tue, 31 Jul 2018 16:07:39 -0400
Message-ID: <71c7761b5e0289fee7d82ddcc723d39804826e53.1533065887.git.rgb@redhat.com>
References: <cover.1533065887.git.rgb@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1533065887.git.rgb@redhat.com>
In-Reply-To: <cover.1533065887.git.rgb@redhat.com>
References: <cover.1533065887.git.rgb@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: containers@lists.linux-foundation.org, linux-api@vger.kernel.org, Linux-Audit Mailing List <linux-audit@redhat.com>, linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org, netfilter-devel@vger.kernel.org
Cc: luto@kernel.org, carlos@redhat.com, viro@zeniv.linux.org.uk, dhowells@redhat.com, simo@redhat.com, eparis@parisplace.org, serge@hallyn.com, ebiederm@xmission.com, Richard Guy Briggs <rgb@redhat.com>
List-Id: linux-api@vger.kernel.org

Add audit container identifier support to ptrace and signals.  In
particular, the "op" field provides a way to label the auxiliary record
to which it is associated.

Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
Acked-by: Serge Hallyn <serge@hallyn.com>
---
 include/linux/audit.h | 11 +++++------
 kernel/audit.c        | 13 +++++++------
 kernel/audit.h        |  2 ++
 kernel/auditsc.c      | 21 ++++++++++++++++-----
 4 files changed, 30 insertions(+), 17 deletions(-)

diff --git a/include/linux/audit.h b/include/linux/audit.h
index d5a48dc..4f514ed 100644
--- a/include/linux/audit.h
+++ b/include/linux/audit.h
@@ -34,6 +34,7 @@ struct audit_sig_info {
 	uid_t		uid;
 	pid_t		pid;
 	char		ctx[0];
+	u64		cid;
 };
 
 struct audit_buffer;
@@ -155,9 +156,8 @@ extern void		    audit_log_key(struct audit_buffer *ab,
 extern int audit_log_task_context(struct audit_buffer *ab);
 extern void audit_log_task_info(struct audit_buffer *ab,
 				struct task_struct *tsk);
-extern int audit_log_contid(struct task_struct *tsk,
-				    struct audit_context *context,
-				    char *op);
+extern int audit_log_contid(struct audit_context *context,
+				     char *op, u64 contid);
 
 extern int		    audit_update_lsm_rules(void);
 
@@ -208,9 +208,8 @@ static inline int audit_log_task_context(struct audit_buffer *ab)
 static inline void audit_log_task_info(struct audit_buffer *ab,
 				       struct task_struct *tsk)
 { }
-static inline int audit_log_contid(struct task_struct *tsk,
-					   struct audit_context *context,
-					   char *op)
+static inline int audit_log_contid(struct audit_context *context,
+					    char *op, u64 contid)
 { }
 #define audit_enabled AUDIT_OFF
 #endif /* CONFIG_AUDIT */
diff --git a/kernel/audit.c b/kernel/audit.c
index 15f54c7..fc9f026f 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -139,6 +139,7 @@ struct audit_net {
 kuid_t		audit_sig_uid = INVALID_UID;
 pid_t		audit_sig_pid = -1;
 u32		audit_sig_sid = 0;
+u64		audit_sig_cid = AUDIT_CID_UNSET;
 
 /* Records can be lost in several ways:
    0) [suppressed in audit_alloc]
@@ -1434,6 +1435,7 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
 			memcpy(sig_data->ctx, ctx, len);
 			security_release_secctx(ctx, len);
 		}
+		sig_data->cid = audit_sig_cid;
 		audit_send_reply(skb, seq, AUDIT_SIGNAL_INFO, 0, 0,
 				 sig_data, sizeof(*sig_data) + len);
 		kfree(sig_data);
@@ -2047,23 +2049,22 @@ void audit_log_session_info(struct audit_buffer *ab)
 
 /*
  * audit_log_contid - report container info
- * @tsk: task to be recorded
  * @context: task or local context for record
  * @op: contid string description
+ * @contid: container ID to report
  */
-int audit_log_contid(struct task_struct *tsk,
-			     struct audit_context *context, char *op)
+int audit_log_contid(struct audit_context *context,
+			      char *op, u64 contid)
 {
 	struct audit_buffer *ab;
 
-	if (!audit_contid_set(tsk))
+	if (!audit_contid_valid(contid))
 		return 0;
 	/* Generate AUDIT_CONTAINER record with container ID */
 	ab = audit_log_start(context, GFP_KERNEL, AUDIT_CONTAINER);
 	if (!ab)
 		return -ENOMEM;
-	audit_log_format(ab, "op=%s contid=%llu",
-			 op, audit_get_contid(tsk));
+	audit_log_format(ab, "op=%s contid=%llu", op, contid);
 	audit_log_end(ab);
 	return 0;
 }
diff --git a/kernel/audit.h b/kernel/audit.h
index 214e149..1cf1c35 100644
--- a/kernel/audit.h
+++ b/kernel/audit.h
@@ -147,6 +147,7 @@ struct audit_context {
 	kuid_t		    target_uid;
 	unsigned int	    target_sessionid;
 	u32		    target_sid;
+	u64		    target_cid;
 	char		    target_comm[TASK_COMM_LEN];
 
 	struct audit_tree_refs *trees, *first_trees;
@@ -329,6 +330,7 @@ extern void audit_log_d_path_exe(struct audit_buffer *ab,
 extern pid_t audit_sig_pid;
 extern kuid_t audit_sig_uid;
 extern u32 audit_sig_sid;
+extern u64 audit_sig_cid;
 
 extern int audit_filter(int msgtype, unsigned int listtype);
 
diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index 39e5633..cdb24cf 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -113,6 +113,7 @@ struct audit_aux_data_pids {
 	kuid_t			target_uid[AUDIT_AUX_PIDS];
 	unsigned int		target_sessionid[AUDIT_AUX_PIDS];
 	u32			target_sid[AUDIT_AUX_PIDS];
+	u64			target_cid[AUDIT_AUX_PIDS];
 	char 			target_comm[AUDIT_AUX_PIDS][TASK_COMM_LEN];
 	int			pid_count;
 };
@@ -1454,21 +1455,27 @@ static void audit_log_exit(struct audit_context *context, struct task_struct *ts
 	for (aux = context->aux_pids; aux; aux = aux->next) {
 		struct audit_aux_data_pids *axs = (void *)aux;
 
-		for (i = 0; i < axs->pid_count; i++)
+		for (i = 0; i < axs->pid_count; i++) {
+			char axsn[sizeof("aux0xN ")];
+
+			sprintf(axsn, "aux0x%x", i);
 			if (audit_log_pid_context(context, axs->target_pid[i],
 						  axs->target_auid[i],
 						  axs->target_uid[i],
 						  axs->target_sessionid[i],
 						  axs->target_sid[i],
-						  axs->target_comm[i]))
+						  axs->target_comm[i])
+			    || audit_log_contid(context, axsn, axs->target_cid[i]))
 				call_panic = 1;
+		}
 	}
 
 	if (context->target_pid &&
-	    audit_log_pid_context(context, context->target_pid,
+	    (audit_log_pid_context(context, context->target_pid,
 				  context->target_auid, context->target_uid,
 				  context->target_sessionid,
-				  context->target_sid, context->target_comm))
+				  context->target_sid, context->target_comm)
+	    || audit_log_contid(context, "target", context->target_cid)))
 			call_panic = 1;
 
 	if (context->pwd.dentry && context->pwd.mnt) {
@@ -1488,7 +1495,7 @@ static void audit_log_exit(struct audit_context *context, struct task_struct *ts
 
 	audit_log_proctitle(tsk, context);
 
-	audit_log_contid(tsk, context, "task");
+	audit_log_contid(context, "task", audit_get_contid(tsk));
 
 	/* Send end of event record to help user space know we are finished */
 	ab = audit_log_start(context, GFP_KERNEL, AUDIT_EOE);
@@ -2372,6 +2379,7 @@ void __audit_ptrace(struct task_struct *t)
 	context->target_uid = task_uid(t);
 	context->target_sessionid = audit_get_sessionid(t);
 	security_task_getsecid(t, &context->target_sid);
+	context->target_cid = audit_get_contid(t);
 	memcpy(context->target_comm, t->comm, TASK_COMM_LEN);
 }
 
@@ -2399,6 +2407,7 @@ int audit_signal_info(int sig, struct task_struct *t)
 		else
 			audit_sig_uid = uid;
 		security_task_getsecid(current, &audit_sig_sid);
+		audit_sig_cid = audit_get_contid(current);
 	}
 
 	if (!audit_signals || audit_dummy_context())
@@ -2412,6 +2421,7 @@ int audit_signal_info(int sig, struct task_struct *t)
 		ctx->target_uid = t_uid;
 		ctx->target_sessionid = audit_get_sessionid(t);
 		security_task_getsecid(t, &ctx->target_sid);
+		ctx->target_cid = audit_get_contid(t);
 		memcpy(ctx->target_comm, t->comm, TASK_COMM_LEN);
 		return 0;
 	}
@@ -2433,6 +2443,7 @@ int audit_signal_info(int sig, struct task_struct *t)
 	axp->target_uid[axp->pid_count] = t_uid;
 	axp->target_sessionid[axp->pid_count] = audit_get_sessionid(t);
 	security_task_getsecid(t, &axp->target_sid[axp->pid_count]);
+	axp->target_cid[axp->pid_count] = audit_get_contid(t);
 	memcpy(axp->target_comm[axp->pid_count], t->comm, TASK_COMM_LEN);
 	axp->pid_count++;
 
-- 
1.8.3.1
