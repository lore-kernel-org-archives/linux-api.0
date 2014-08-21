From: Richard Guy Briggs <rgb-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH V4 6/8] audit: log namespace serial numbers
Date: Wed, 20 Aug 2014 21:09:39 -0400
Message-ID: <74a77bba68ddf328aa073e7b463e13c70af6b2bd.1408581429.git.rgb@redhat.com>
References: <cover.1408581429.git.rgb@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <cover.1408581429.git.rgb-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
In-Reply-To: <cover.1408581429.git.rgb-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
References: <cover.1408581429.git.rgb-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/containers/>
List-Post: <mailto:containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: linux-audit-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, eparis-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sgrubb-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Log the namespace serial numbers of a task in a new record type (1329) (usually
accompanies audit_log_task_info() type=SYSCALL record) which is used by syscall
audits, among others..

Idea first presented:
	https://www.redhat.com/archives/linux-audit/2013-March/msg00020.html

Typical output format would look something like:
	type=NS_INFO msg=audit(1408577535.306:82):  netns=8 utsns=2 ipcns=1 pidns=4 userns=3 mntns=5

The serial numbers are printed in hex.

Suggested-by: Aristeu Rozanski <arozansk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Richard Guy Briggs <rgb-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Acked-by: Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
---
 include/linux/audit.h            |    7 +++++++
 include/uapi/linux/audit.h       |    1 +
 kernel/audit.c                   |   29 +++++++++++++++++++++++++++++
 kernel/auditsc.c                 |    2 ++
 security/integrity/ima/ima_api.c |    2 ++
 5 files changed, 41 insertions(+), 0 deletions(-)

diff --git a/include/linux/audit.h b/include/linux/audit.h
index 22cfddb..5ea3609 100644
--- a/include/linux/audit.h
+++ b/include/linux/audit.h
@@ -101,6 +101,13 @@ extern int __weak audit_classify_compat_syscall(int abi, unsigned syscall);
 struct filename;
 
 extern void audit_log_session_info(struct audit_buffer *ab);
+#ifdef CONFIG_NAMESPACES
+extern void audit_log_namespace_info(struct task_struct *tsk);
+#else
+void audit_log_namespace_info(struct task_struct *tsk)
+{
+}
+#endif
 
 #ifdef CONFIG_AUDIT_COMPAT_GENERIC
 #define audit_is_compat(arch)  (!((arch) & __AUDIT_ARCH_64BIT))
diff --git a/include/uapi/linux/audit.h b/include/uapi/linux/audit.h
index cf67147..84bbcdb 100644
--- a/include/uapi/linux/audit.h
+++ b/include/uapi/linux/audit.h
@@ -110,6 +110,7 @@
 #define AUDIT_SECCOMP		1326	/* Secure Computing event */
 #define AUDIT_PROCTITLE		1327	/* Proctitle emit event */
 #define AUDIT_FEATURE_CHANGE	1328	/* audit log listing feature changes */
+#define AUDIT_NS_INFO		1329	/* Record process namespace IDs */
 
 #define AUDIT_AVC		1400	/* SE Linux avc denial or grant */
 #define AUDIT_SELINUX_ERR	1401	/* Internal SE Linux Errors */
diff --git a/kernel/audit.c b/kernel/audit.c
index 3ef2e0e..a4c39a0 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -65,6 +65,7 @@
 #include <linux/freezer.h>
 #include <linux/tty.h>
 #include <linux/pid_namespace.h>
+#include <linux/proc_ns.h>
 #include <net/netns/generic.h>
 
 #include "audit.h"
@@ -743,6 +744,8 @@ static void audit_log_feature_change(int which, u32 old_feature, u32 new_feature
 			 audit_feature_names[which], !!old_feature, !!new_feature,
 			 !!old_lock, !!new_lock, res);
 	audit_log_end(ab);
+
+	audit_log_namespace_info(current);
 }
 
 static int audit_set_feature(struct sk_buff *skb)
@@ -1661,6 +1664,30 @@ void audit_log_session_info(struct audit_buffer *ab)
 	audit_log_format(ab, " auid=%u ses=%u", auid, sessionid);
 }
 
+#ifdef CONFIG_NAMESPACES
+void audit_log_namespace_info(struct task_struct *tsk)
+{
+	const struct proc_ns_operations **entry;
+	bool end = false;
+	struct audit_buffer *ab;
+
+	if (!tsk)
+		return;
+	ab = audit_log_start(tsk->audit_context, GFP_KERNEL,
+			     AUDIT_NS_INFO);
+	if (!ab)
+		return;
+	for (entry = ns_entries; !end; entry++) {
+		void *ns = (*entry)->get(tsk);
+		audit_log_format(ab, " %sns=%llx", (*entry)->name,
+				 (*entry)->snum(ns));
+		(*entry)->put(ns);
+		end = (*entry)->type == CLONE_NEWNS;
+	}
+	audit_log_end(ab);
+}
+#endif /* CONFIG_NAMESPACES */
+
 void audit_log_key(struct audit_buffer *ab, char *key)
 {
 	audit_log_format(ab, " key=");
@@ -1933,6 +1960,8 @@ void audit_log_link_denied(const char *operation, struct path *link)
 	audit_log_format(ab, " res=0");
 	audit_log_end(ab);
 
+	audit_log_namespace_info(current);
+
 	/* Generate AUDIT_PATH record with object. */
 	name->type = AUDIT_TYPE_NORMAL;
 	audit_copy_inode(name, link->dentry, link->dentry->d_inode);
diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index 21eae3c..08b9af9 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -1383,6 +1383,8 @@ static void audit_log_exit(struct audit_context *context, struct task_struct *ts
 	audit_log_key(ab, context->filterkey);
 	audit_log_end(ab);
 
+	audit_log_namespace_info(tsk);
+
 	for (aux = context->aux; aux; aux = aux->next) {
 
 		ab = audit_log_start(context, GFP_KERNEL, aux->type);
diff --git a/security/integrity/ima/ima_api.c b/security/integrity/ima/ima_api.c
index d9cd5ce..06d6897 100644
--- a/security/integrity/ima/ima_api.c
+++ b/security/integrity/ima/ima_api.c
@@ -323,6 +323,8 @@ void ima_audit_measurement(struct integrity_iint_cache *iint,
 	audit_log_task_info(ab, current);
 	audit_log_end(ab);
 
+	audit_log_namespace_info(current);
+
 	iint->flags |= IMA_AUDITED;
 }
 
-- 
1.7.1
