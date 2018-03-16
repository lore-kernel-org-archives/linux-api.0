From: Richard Guy Briggs <rgb@redhat.com>
Subject: [RFC PATCH ghak32 V2 12/13] audit: NETFILTER_PKT: record each container ID associated with a netNS
Date: Fri, 16 Mar 2018 05:00:39 -0400
Message-ID: <66adde01c1dda792aff99a457eea576a0b08ca98.1521179281.git.rgb@redhat.com>
References: <cover.1521179281.git.rgb@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1521179281.git.rgb@redhat.com>
In-Reply-To: <cover.1521179281.git.rgb@redhat.com>
References: <cover.1521179281.git.rgb@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: cgroups@vger.kernel.org, containers@lists.linux-foundation.org, linux-api@vger.kernel.org, Linux-Audit Mailing List <linux-audit@redhat.com>, linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org
Cc: luto@kernel.org, jlayton@redhat.com, carlos@redhat.com, viro@zeniv.linux.org.uk, dhowells@redhat.com, simo@redhat.com, eparis@parisplace.org, serge@hallyn.com, ebiederm@xmission.com, madzcar@gmail.com, Richard Guy Briggs <rgb@redhat.com>
List-Id: linux-api@vger.kernel.org

Add container ID auxiliary record(s) to NETFILTER_PKT event standalone
records.  Iterate through all potential container IDs associated with a
network namespace.

Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
---
 kernel/audit.c           |  1 +
 kernel/auditsc.c         |  2 ++
 net/netfilter/xt_AUDIT.c | 15 ++++++++++++++-
 3 files changed, 17 insertions(+), 1 deletion(-)

diff --git a/kernel/audit.c b/kernel/audit.c
index 08662b4..3c77e47 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -2102,6 +2102,7 @@ int audit_log_container_info(struct audit_context *context,
 	audit_log_end(ab);
 	return 0;
 }
+EXPORT_SYMBOL(audit_log_container_info);
 
 void audit_log_key(struct audit_buffer *ab, char *key)
 {
diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index 208da962..af68d01 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -975,6 +975,7 @@ struct audit_context *audit_alloc_local(void)
 	context->in_syscall = 1;
 	return context;
 }
+EXPORT_SYMBOL(audit_alloc_local);
 
 inline void audit_free_context(struct audit_context *context)
 {
@@ -989,6 +990,7 @@ inline void audit_free_context(struct audit_context *context)
 	audit_proctitle_free(context);
 	kfree(context);
 }
+EXPORT_SYMBOL(audit_free_context);
 
 static int audit_log_pid_context(struct audit_context *context, pid_t pid,
 				 kuid_t auid, kuid_t uid, unsigned int sessionid,
diff --git a/net/netfilter/xt_AUDIT.c b/net/netfilter/xt_AUDIT.c
index c502419..edaa456 100644
--- a/net/netfilter/xt_AUDIT.c
+++ b/net/netfilter/xt_AUDIT.c
@@ -71,10 +71,14 @@ static bool audit_ip6(struct audit_buffer *ab, struct sk_buff *skb)
 {
 	struct audit_buffer *ab;
 	int fam = -1;
+	struct audit_context *context = audit_alloc_local();
+	struct audit_containerid *cont;
+	int i = 0;
+	struct net *net;
 
 	if (audit_enabled == 0)
 		goto errout;
-	ab = audit_log_start(NULL, GFP_ATOMIC, AUDIT_NETFILTER_PKT);
+	ab = audit_log_start(context, GFP_ATOMIC, AUDIT_NETFILTER_PKT);
 	if (ab == NULL)
 		goto errout;
 
@@ -104,7 +108,16 @@ static bool audit_ip6(struct audit_buffer *ab, struct sk_buff *skb)
 
 	audit_log_end(ab);
 
+	net = sock_net(NETLINK_CB(skb).sk);
+	list_for_each_entry(cont, &net->audit_containerid, list) {
+		char buf[14];
+
+		sprintf(buf, "net%u", i++);
+		audit_log_container_info(context, buf, cont->id);
+	}
+
 errout:
+	audit_free_context(context);
 	return XT_CONTINUE;
 }
 
-- 
1.8.3.1
