From: Richard Guy Briggs <rgb@redhat.com>
Subject: [RFC PATCH V1 05/12] audit: add containerid support for ptrace and signals
Date: Thu,  1 Mar 2018 14:41:08 -0500
Message-ID: <17f328b1bcda556184539b0980812d64cbca93d7.1519930146.git.rgb@redhat.com>
References: <cover.1519930146.git.rgb@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1519930146.git.rgb@redhat.com>
In-Reply-To: <cover.1519930146.git.rgb@redhat.com>
References: <cover.1519930146.git.rgb@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: cgroups@vger.kernel.org, containers@lists.linux-foundation.org, linux-api@vger.kernel.org, Linux-Audit Mailing List <linux-audit@redhat.com>, linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org
Cc: mszeredi@redhat.com, luto@kernel.org, jlayton@redhat.com, carlos@redhat.com, viro@zeniv.linux.org.uk, dhowells@redhat.com, simo@redhat.com, trondmy@primarydata.com, eparis@parisplace.org, serge@hallyn.com, ebiederm@xmission.com, madzcar@gmail.com, Richard Guy Briggs <rgb@redhat.com>
List-Id: linux-api@vger.kernel.org

Add container ID support to ptrace and signals.  In particular, the "op"
field provides a way to label the auxiliary record to which it is
associated.

Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
---
 include/linux/audit.h | 16 +++++++++++-----
 kernel/audit.c        | 12 ++++++++----
 kernel/audit.h        |  2 ++
 kernel/auditsc.c      | 19 +++++++++++++++----
 4 files changed, 36 insertions(+), 13 deletions(-)

diff --git a/include/linux/audit.h b/include/linux/audit.h
index f10ca1b..ed16bb6 100644
--- a/include/linux/audit.h
+++ b/include/linux/audit.h
@@ -35,6 +35,7 @@ struct audit_sig_info {
 	uid_t		uid;
 	pid_t		pid;
 	char		ctx[0];
+	u64		cid;
 };
 
 struct audit_buffer;
@@ -155,8 +156,8 @@ extern void		    audit_log_link_denied(const char *operation,
 extern int audit_log_task_context(struct audit_buffer *ab);
 extern void audit_log_task_info(struct audit_buffer *ab,
 				struct task_struct *tsk);
-extern int audit_log_container_info(struct task_struct *tsk,
-				     struct audit_context *context);
+extern int audit_log_container_info(struct audit_context *context,
+				     char *op, u64 containerid);
 
 extern int		    audit_update_lsm_rules(void);
 
@@ -208,8 +209,8 @@ static inline int audit_log_task_context(struct audit_buffer *ab)
 static inline void audit_log_task_info(struct audit_buffer *ab,
 				       struct task_struct *tsk)
 { }
-static inline int audit_log_container_info(struct task_struct *tsk,
-					    struct audit_context *context);
+static inline int audit_log_container_info(struct audit_context *context,
+					    char *op, u64 containerid);
 { }
 #define audit_enabled 0
 #endif /* CONFIG_AUDIT */
@@ -598,9 +599,14 @@ static inline bool audit_loginuid_set(struct task_struct *tsk)
 	return uid_valid(audit_get_loginuid(tsk));
 }
 
+static inline bool cid_valid(u64 containerid)
+{
+	return containerid != INVALID_CID;
+}
+
 static inline bool audit_containerid_set(struct task_struct *tsk)
 {
-	return audit_get_containerid(tsk) != INVALID_CID;
+	return cid_valid(audit_get_containerid(tsk));
 }
 
 static inline void audit_log_string(struct audit_buffer *ab, const char *buf)
diff --git a/kernel/audit.c b/kernel/audit.c
index 8dc745f..f5cd0bc 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -142,6 +142,7 @@ struct audit_net {
 kuid_t		audit_sig_uid = INVALID_UID;
 pid_t		audit_sig_pid = -1;
 u32		audit_sig_sid = 0;
+u64		audit_sig_cid = INVALID_CID;
 
 /* Records can be lost in several ways:
    0) [suppressed in audit_alloc]
@@ -1394,6 +1395,7 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
 			memcpy(sig_data->ctx, ctx, len);
 			security_release_secctx(ctx, len);
 		}
+		sig_data->cid = audit_sig_cid;
 		audit_send_reply(skb, seq, AUDIT_SIGNAL_INFO, 0, 0,
 				 sig_data, sizeof(*sig_data) + len);
 		kfree(sig_data);
@@ -1998,20 +2000,22 @@ void audit_log_session_info(struct audit_buffer *ab)
 
 /*
  * audit_log_container_info - report container info
- * @tsk: task to be recorded
  * @context: task or local context for record
+ * @op: containerid string description
+ * @containerid: container ID to report
  */
-int audit_log_container_info(struct task_struct *tsk, struct audit_context *context)
+int audit_log_container_info(struct audit_context *context,
+			      char *op, u64 containerid)
 {
 	struct audit_buffer *ab;
 
-	if (!audit_containerid_set(tsk))
+	if (!cid_valid(containerid))
 		return 0;
 	/* Generate AUDIT_CONTAINER_INFO with container ID */
 	ab = audit_log_start(context, GFP_KERNEL, AUDIT_CONTAINER_INFO);
 	if (!ab)
 		return -ENOMEM;
-	audit_log_format(ab, "contid=%llu", audit_get_containerid(tsk));
+	audit_log_format(ab, "op=%s contid=%llu", op, containerid);
 	audit_log_end(ab);
 	return 0;
 }
diff --git a/kernel/audit.h b/kernel/audit.h
index 683316a..abbabba 100644
--- a/kernel/audit.h
+++ b/kernel/audit.h
@@ -147,6 +147,7 @@ struct audit_context {
 	kuid_t		    target_uid;
 	unsigned int	    target_sessionid;
 	u32		    target_sid;
+	u64		    target_cid;
 	char		    target_comm[TASK_COMM_LEN];
 
 	struct audit_tree_refs *trees, *first_trees;
@@ -330,6 +331,7 @@ extern void audit_log_d_path_exe(struct audit_buffer *ab,
 extern pid_t audit_sig_pid;
 extern kuid_t audit_sig_uid;
 extern u32 audit_sig_sid;
+extern u64 audit_sig_cid;
 
 extern int audit_filter(int msgtype, unsigned int listtype);
 
diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index 34396cb..0e41884 100644
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
@@ -1422,21 +1423,27 @@ static void audit_log_exit(struct audit_context *context, struct task_struct *ts
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
+			    && audit_log_container_info(context, axsn, axs->target_cid[i]))
 				call_panic = 1;
+		}
 	}
 
 	if (context->target_pid &&
 	    audit_log_pid_context(context, context->target_pid,
 				  context->target_auid, context->target_uid,
 				  context->target_sessionid,
-				  context->target_sid, context->target_comm))
+				  context->target_sid, context->target_comm)
+	    && audit_log_container_info(context, "target", context->target_cid))
 			call_panic = 1;
 
 	if (context->pwd.dentry && context->pwd.mnt) {
@@ -1456,7 +1463,7 @@ static void audit_log_exit(struct audit_context *context, struct task_struct *ts
 
 	audit_log_proctitle(tsk, context);
 
-	audit_log_container_info(tsk, context);
+	audit_log_container_info(context, "task", audit_get_containerid(tsk));
 
 	/* Send end of event record to help user space know we are finished */
 	ab = audit_log_start(context, GFP_KERNEL, AUDIT_EOE);
@@ -2354,6 +2361,7 @@ void __audit_ptrace(struct task_struct *t)
 	context->target_uid = task_uid(t);
 	context->target_sessionid = audit_get_sessionid(t);
 	security_task_getsecid(t, &context->target_sid);
+	context->target_cid = audit_get_containerid(t);
 	memcpy(context->target_comm, t->comm, TASK_COMM_LEN);
 }
 
@@ -2381,6 +2389,7 @@ int audit_signal_info(int sig, struct task_struct *t)
 		else
 			audit_sig_uid = uid;
 		security_task_getsecid(tsk, &audit_sig_sid);
+		audit_sig_cid = audit_get_containerid(tsk);
 	}
 
 	if (!audit_signals || audit_dummy_context())
@@ -2394,6 +2403,7 @@ int audit_signal_info(int sig, struct task_struct *t)
 		ctx->target_uid = t_uid;
 		ctx->target_sessionid = audit_get_sessionid(t);
 		security_task_getsecid(t, &ctx->target_sid);
+		ctx->target_cid = audit_get_containerid(t);
 		memcpy(ctx->target_comm, t->comm, TASK_COMM_LEN);
 		return 0;
 	}
@@ -2415,6 +2425,7 @@ int audit_signal_info(int sig, struct task_struct *t)
 	axp->target_uid[axp->pid_count] = t_uid;
 	axp->target_sessionid[axp->pid_count] = audit_get_sessionid(t);
 	security_task_getsecid(t, &axp->target_sid[axp->pid_count]);
+	axp->target_cid[axp->pid_count] = audit_get_containerid(t);
 	memcpy(axp->target_comm[axp->pid_count], t->comm, TASK_COMM_LEN);
 	axp->pid_count++;
 
-- 
1.8.3.1
