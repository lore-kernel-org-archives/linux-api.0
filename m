From: Richard Guy Briggs <rgb@redhat.com>
Subject: [RFC PATCH ghak90 (was ghak32) V3 08/10] audit: NETFILTER_PKT: record each container ID associated with a netNS
Date: Wed,  6 Jun 2018 12:58:35 -0400
Message-ID: <c6b64f6540e2e531636142ced36d51f0744d0e1f.1528304204.git.rgb@redhat.com>
References: <cover.1528304203.git.rgb@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1528304203.git.rgb@redhat.com>
In-Reply-To: <cover.1528304203.git.rgb@redhat.com>
References: <cover.1528304203.git.rgb@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: cgroups@vger.kernel.org, containers@lists.linux-foundation.org, linux-api@vger.kernel.org, Linux-Audit Mailing List <linux-audit@redhat.com>, linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org
Cc: luto@kernel.org, jlayton@redhat.com, carlos@redhat.com, viro@zeniv.linux.org.uk, dhowells@redhat.com, simo@redhat.com, eparis@parisplace.org, serge@hallyn.com, ebiederm@xmission.com, Richard Guy Briggs <rgb@redhat.com>
List-Id: linux-api@vger.kernel.org

Add audit container identifier auxiliary record(s) to NETFILTER_PKT
event standalone records.  Iterate through all potential audit container
identifiers associated with a network namespace.

Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
---
 include/linux/audit.h    |  5 +++++
 kernel/audit.c           | 20 +++++++++++++++++++-
 kernel/auditsc.c         |  2 ++
 net/netfilter/xt_AUDIT.c | 12 ++++++++++--
 4 files changed, 36 insertions(+), 3 deletions(-)

diff --git a/include/linux/audit.h b/include/linux/audit.h
index 7e2e51c..4560a4e 100644
--- a/include/linux/audit.h
+++ b/include/linux/audit.h
@@ -167,6 +167,8 @@ extern int audit_log_contid(struct audit_context *context,
 extern void audit_contid_add(struct net *net, u64 contid);
 extern void audit_contid_del(struct net *net, u64 contid);
 extern void audit_switch_task_namespaces(struct nsproxy *ns, struct task_struct *p);
+extern void audit_log_contid_list(struct net *net,
+				 struct audit_context *context);
 
 extern int		    audit_update_lsm_rules(void);
 
@@ -231,6 +233,9 @@ static inline void audit_contid_del(struct net *net, u64 contid)
 { }
 static inline void audit_switch_task_namespaces(struct nsproxy *ns, struct task_struct *p)
 { }
+static inline void audit_log_contid_list(struct net *net,
+					struct audit_context *context)
+{ }
 
 #define audit_enabled 0
 #endif /* CONFIG_AUDIT */
diff --git a/kernel/audit.c b/kernel/audit.c
index ecd2de4..8cca41a 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -382,6 +382,20 @@ void audit_switch_task_namespaces(struct nsproxy *ns, struct task_struct *p)
 		audit_contid_add(new->net_ns, contid);
 }
 
+void audit_log_contid_list(struct net *net, struct audit_context *context)
+{
+	struct audit_contid *cont;
+	int i = 0;
+
+	list_for_each_entry(cont, audit_get_contid_list(net), list) {
+		char buf[14];
+
+		sprintf(buf, "net%u", i++);
+		audit_log_contid(context, buf, cont->id);
+	}
+}
+EXPORT_SYMBOL(audit_log_contid_list);
+
 void audit_panic(const char *message)
 {
 	switch (audit_failure) {
@@ -2132,17 +2146,21 @@ int audit_log_contid(struct audit_context *context,
 			      char *op, u64 contid)
 {
 	struct audit_buffer *ab;
+	gfp_t gfpflags;
 
 	if (!cid_valid(contid))
 		return 0;
+	/* We can be called in atomic context via audit_tg() */
+	gfpflags = (in_atomic() || irqs_disabled()) ? GFP_ATOMIC : GFP_KERNEL;
 	/* Generate AUDIT_CONTAINER record with container ID */
-	ab = audit_log_start(context, GFP_KERNEL, AUDIT_CONTAINER);
+	ab = audit_log_start(context, gfpflags, AUDIT_CONTAINER);
 	if (!ab)
 		return -ENOMEM;
 	audit_log_format(ab, "op=%s contid=%llu", op, contid);
 	audit_log_end(ab);
 	return 0;
 }
+EXPORT_SYMBOL(audit_log_contid);
 
 void audit_log_key(struct audit_buffer *ab, char *key)
 {
diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index 6ab5e5e..e2a16d2 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -1015,6 +1015,7 @@ struct audit_context *audit_alloc_local(void)
 	context->in_syscall = 1;
 	return context;
 }
+EXPORT_SYMBOL(audit_alloc_local);
 
 void audit_free_context(struct audit_context *context)
 {
@@ -1029,6 +1030,7 @@ void audit_free_context(struct audit_context *context)
 	audit_proctitle_free(context);
 	kfree(context);
 }
+EXPORT_SYMBOL(audit_free_context);
 
 static int audit_log_pid_context(struct audit_context *context, pid_t pid,
 				 kuid_t auid, kuid_t uid, unsigned int sessionid,
diff --git a/net/netfilter/xt_AUDIT.c b/net/netfilter/xt_AUDIT.c
index f368ee6..10d2707 100644
--- a/net/netfilter/xt_AUDIT.c
+++ b/net/netfilter/xt_AUDIT.c
@@ -71,10 +71,13 @@ static bool audit_ip6(struct audit_buffer *ab, struct sk_buff *skb)
 {
 	struct audit_buffer *ab;
 	int fam = -1;
+	struct audit_context *context;
+	struct net *net;
 
 	if (audit_enabled == 0)
-		goto errout;
-	ab = audit_log_start(NULL, GFP_ATOMIC, AUDIT_NETFILTER_PKT);
+		goto out;
+	context = audit_alloc_local();
+	ab = audit_log_start(context, GFP_ATOMIC, AUDIT_NETFILTER_PKT);
 	if (ab == NULL)
 		goto errout;
 
@@ -104,7 +107,12 @@ static bool audit_ip6(struct audit_buffer *ab, struct sk_buff *skb)
 
 	audit_log_end(ab);
 
+	net = xt_net(par);
+	audit_log_contid_list(net, context);
+
 errout:
+	audit_free_context(context);
+out:
 	return XT_CONTINUE;
 }
 
-- 
1.8.3.1
