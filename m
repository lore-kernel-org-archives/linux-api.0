From: Richard Guy Briggs <rgb-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH V6 03/10] audit: log namespace ID numbers
Date: Fri, 17 Apr 2015 03:35:50 -0400
Message-ID: <8a9afed0517958092fb42a8fe4c8b1d1829327f2.1429252659.git.rgb@redhat.com>
References: <cover.1429252659.git.rgb@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <cover.1429252659.git.rgb-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
In-Reply-To: <cover.1429252659.git.rgb-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
References: <cover.1429252659.git.rgb-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/containers/>
List-Post: <mailto:containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-audit-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, pmoore-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ima-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, eparis-FjpueFixGhCM4zKIHC2jIg@public.gmane.org, sgrubb-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, zohar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org
List-Id: linux-api@vger.kernel.org

Log the namespace identifiers (device ID and proc inode minus base offset) of a
task in a new record type (1329) (usually accompanies audit_log_task_info()
type=SYSCALL record) which is used by syscall audits, among others..

Idea first presented:
	https://www.redhat.com/archives/linux-audit/2013-March/msg00020.html

Typical output format would look something like:
	type=NS_INFO msg=audit(1408577535.306:82): pid=374 dev=00:03 netns=116 utsns=-2 ipcns=-1 pidns=-4 userns=-3 mntns=0

The namespace identifier values are printed relative to PROC_DYNAMIC_FIRST
(0xF000000) (so the first 4 are negative).

Suggested-by: Aristeu Rozanski <arozansk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Richard Guy Briggs <rgb-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Acked-by: Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
---
 include/linux/audit.h            |    8 ++++++++
 include/uapi/linux/audit.h       |    1 +
 kernel/audit.c                   |   35 +++++++++++++++++++++++++++++++++++
 kernel/auditsc.c                 |    2 ++
 security/integrity/ima/ima_api.c |    2 ++
 5 files changed, 48 insertions(+), 0 deletions(-)

diff --git a/include/linux/audit.h b/include/linux/audit.h
index b481779..71698ec 100644
--- a/include/linux/audit.h
+++ b/include/linux/audit.h
@@ -478,6 +478,12 @@ static inline void	    audit_log_secctx(struct audit_buffer *ab, u32 secid)
 extern int audit_log_task_context(struct audit_buffer *ab);
 extern void audit_log_task_info(struct audit_buffer *ab,
 				struct task_struct *tsk);
+#ifdef CONFIG_NAMESPACES
+extern void		    audit_log_ns_info(struct task_struct *tsk);
+#else
+static inline void	    audit_log_ns_info(struct task_struct *tsk)
+{ }
+#endif
 
 extern int		    audit_update_lsm_rules(void);
 
@@ -534,6 +540,8 @@ static inline int audit_log_task_context(struct audit_buffer *ab)
 static inline void audit_log_task_info(struct audit_buffer *ab,
 				       struct task_struct *tsk)
 { }
+static inline void audit_log_ns_info(struct task_struct *tsk)
+{ }
 #define audit_enabled 0
 #endif /* CONFIG_AUDIT */
 static inline void audit_log_string(struct audit_buffer *ab, const char *buf)
diff --git a/include/uapi/linux/audit.h b/include/uapi/linux/audit.h
index 2ccf19e..1ffb151 100644
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
index d5a1220..68200ce 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -66,7 +66,9 @@
 #include <linux/freezer.h>
 #include <linux/tty.h>
 #include <linux/pid_namespace.h>
+#include <linux/proc_ns.h>
 #include <net/netns/generic.h>
+#include <linux/mount.h> /* struct vfsmount */
 
 #include "audit.h"
 
@@ -745,6 +747,8 @@ static void audit_log_feature_change(int which, u32 old_feature, u32 new_feature
 			 audit_feature_names[which], !!old_feature, !!new_feature,
 			 !!old_lock, !!new_lock, res);
 	audit_log_end(ab);
+
+	audit_log_ns_info(current);
 }
 
 static int audit_set_feature(struct sk_buff *skb)
@@ -1653,6 +1657,35 @@ void audit_log_session_info(struct audit_buffer *ab)
 	audit_log_format(ab, " auid=%u ses=%u", auid, sessionid);
 }
 
+#ifdef CONFIG_NAMESPACES
+void audit_log_ns_info(struct task_struct *tsk)
+{
+	const struct proc_ns_operations **entry;
+	bool end = false;
+	struct audit_buffer *ab;
+	struct vfsmount *mnt = task_active_pid_ns(tsk)->proc_mnt;
+	struct super_block *sb = mnt->mnt_sb;
+
+	if (!tsk)
+		return;
+	ab = audit_log_start(tsk->audit_context, GFP_KERNEL,
+			     AUDIT_NS_INFO);
+	if (!ab)
+		return;
+	audit_log_format(ab, "pid=%d", task_pid_nr(tsk));
+	audit_log_format(ab, " dev=%02x:%02x", MAJOR(sb->s_dev), MINOR(sb->s_dev));
+	for (entry = ns_entries; !end; entry++) {
+		void *ns = (*entry)->get(tsk);
+
+		audit_log_format(ab, " %sns=%d", (*entry)->name,
+				 (*entry)->inum(ns) - PROC_DYNAMIC_FIRST);
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
@@ -1935,6 +1968,8 @@ void audit_log_link_denied(const char *operation, struct path *link)
 	audit_log_format(ab, " res=0");
 	audit_log_end(ab);
 
+	audit_log_ns_info(current);
+
 	/* Generate AUDIT_PATH record with object. */
 	name->type = AUDIT_TYPE_NORMAL;
 	audit_copy_inode(name, link->dentry, link->dentry->d_inode);
diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index 4b89f7f..3ca3416 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -1378,6 +1378,8 @@ static void audit_log_exit(struct audit_context *context, struct task_struct *ts
 	audit_log_key(ab, context->filterkey);
 	audit_log_end(ab);
 
+	audit_log_ns_info(tsk);
+
 	for (aux = context->aux; aux; aux = aux->next) {
 
 		ab = audit_log_start(context, GFP_KERNEL, aux->type);
diff --git a/security/integrity/ima/ima_api.c b/security/integrity/ima/ima_api.c
index d9cd5ce..58ac695 100644
--- a/security/integrity/ima/ima_api.c
+++ b/security/integrity/ima/ima_api.c
@@ -323,6 +323,8 @@ void ima_audit_measurement(struct integrity_iint_cache *iint,
 	audit_log_task_info(ab, current);
 	audit_log_end(ab);
 
+	audit_log_ns_info(current);
+
 	iint->flags |= IMA_AUDITED;
 }
 
-- 
1.7.1
