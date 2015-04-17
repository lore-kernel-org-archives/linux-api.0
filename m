From: Richard Guy Briggs <rgb-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH V6 09/10] audit: log on switching namespace (setns)
Date: Fri, 17 Apr 2015 03:35:56 -0400
Message-ID: <2cbbc564ee3029890f3f49a56bdf149d6db15f34.1429252659.git.rgb@redhat.com>
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
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, pmoore-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, eparis-FjpueFixGhCM4zKIHC2jIg@public.gmane.org, sgrubb-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, zohar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org
List-Id: linux-api@vger.kernel.org

Added six new audit message types, AUDIT_NS_SET_* and function
audit_log_ns_set() to log a switch of namespace.

Signed-off-by: Richard Guy Briggs <rgb-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 include/linux/audit.h      |    4 +++
 include/uapi/linux/audit.h |    6 +++++
 kernel/audit.c             |   52 ++++++++++++++++++++++++++++++++++++++++++++
 kernel/nsproxy.c           |    3 ++
 4 files changed, 65 insertions(+), 0 deletions(-)

diff --git a/include/linux/audit.h b/include/linux/audit.h
index b28dfb0..c71c819 100644
--- a/include/linux/audit.h
+++ b/include/linux/audit.h
@@ -26,6 +26,7 @@
 #include <linux/sched.h>
 #include <linux/ptrace.h>
 #include <uapi/linux/audit.h>
+#include <linux/proc_ns.h>
 
 struct audit_sig_info {
 	uid_t		uid;
@@ -487,6 +488,7 @@ static inline void	    audit_log_ns_info(struct task_struct *tsk)
 extern void		    audit_log_ns_init(int type, unsigned int old_inum,
 					      unsigned int inum);
 extern void		    audit_log_ns_del(int type, unsigned int inum);
+extern void		    audit_log_ns_set(const struct proc_ns_operations *ops, void *ns);
 
 extern int		    audit_update_lsm_rules(void);
 
@@ -550,6 +552,8 @@ static inline int audit_log_ns_init(int type, unsigned int old_inum,
 { }
 static inline int audit_log_ns_del(int type, unsigned int inum)
 { }
+static inline void audit_log_ns_set(const struct proc_ns_operations *ops, void *ns)
+{ }
 #define audit_enabled 0
 #endif /* CONFIG_AUDIT */
 static inline void audit_log_string(struct audit_buffer *ab, const char *buf)
diff --git a/include/uapi/linux/audit.h b/include/uapi/linux/audit.h
index 487cad6..567b45f 100644
--- a/include/uapi/linux/audit.h
+++ b/include/uapi/linux/audit.h
@@ -123,6 +123,12 @@
 #define AUDIT_NS_DEL_USER	1339	/* Record USER namespace instance deletion */
 #define AUDIT_NS_DEL_PID	1340	/* Record PID namespace instance deletion */
 #define AUDIT_NS_DEL_NET	1341	/* Record NET namespace instance deletion */
+#define AUDIT_NS_SET_MNT	1342	/* Record mount namespace instance deletion */
+#define AUDIT_NS_SET_UTS	1343	/* Record UTS namespace instance deletion */
+#define AUDIT_NS_SET_IPC	1344	/* Record IPC namespace instance deletion */
+#define AUDIT_NS_SET_USER	1345	/* Record USER namespace instance deletion */
+#define AUDIT_NS_SET_PID	1346	/* Record PID namespace instance deletion */
+#define AUDIT_NS_SET_NET	1347	/* Record NET namespace instance deletion */
 
 #define AUDIT_AVC		1400	/* SE Linux avc denial or grant */
 #define AUDIT_SELINUX_ERR	1401	/* Internal SE Linux Errors */
diff --git a/kernel/audit.c b/kernel/audit.c
index b7f10e9..a7b1b61 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -2054,6 +2054,58 @@ void audit_log_ns_del(int type, unsigned int inum)
 			 inum - PROC_DYNAMIC_FIRST);
 	audit_log_end(ab);
 }
+
+/**
+ * audit_log_ns_set - report a namespace set change
+ * @ops: the ops structure for the namespace to be changed
+ * @ns: the new namespace
+ */
+void audit_log_ns_set(const struct proc_ns_operations *ops, void *ns)
+{
+	struct audit_buffer *ab;
+	void *old_ns;
+	int msg_type;
+	struct vfsmount *mnt = task_active_pid_ns(current)->proc_mnt;
+	struct super_block *sb = mnt->mnt_sb;
+	char old_ns_s[16];
+
+	switch (ops->type) {
+	case CLONE_NEWNS:
+		msg_type = AUDIT_NS_SET_MNT;
+		break;
+	case CLONE_NEWUTS:
+		msg_type = AUDIT_NS_SET_UTS;
+		break;
+	case CLONE_NEWIPC:
+		msg_type = AUDIT_NS_SET_IPC;
+		break;
+	case CLONE_NEWUSER:
+		msg_type = AUDIT_NS_SET_USER;
+		break;
+	case CLONE_NEWPID:
+		msg_type = AUDIT_NS_SET_PID;
+		break;
+	case CLONE_NEWNET:
+		msg_type = AUDIT_NS_SET_NET;
+		break;
+	default:
+		return;
+	}
+	audit_log_common_recv_msg(&ab, ops->type);
+	if (!ab)
+		return;
+	old_ns = ops->get(current);
+	if (!ops->inum(old_ns))
+		sprintf(old_ns_s, "(none)");
+	else
+		sprintf(old_ns_s, "%d", ops->inum(old_ns) - PROC_DYNAMIC_FIRST);
+	audit_log_format(ab, " dev=%02x:%02x old_%sns=%s %sns=%d res=1",
+			 MAJOR(sb->s_dev), MINOR(sb->s_dev),
+			 ops->name, old_ns_s,
+			 ops->name, ops->inum(ns));
+	ops->put(old_ns);
+	audit_log_end(ab);
+}
 #endif /* CONFIG_NAMESPACES */
 
 /**
diff --git a/kernel/nsproxy.c b/kernel/nsproxy.c
index d5353c2..2ca86cf 100644
--- a/kernel/nsproxy.c
+++ b/kernel/nsproxy.c
@@ -257,6 +257,9 @@ SYSCALL_DEFINE2(setns, int, fd, int, nstype)
 		goto out;
 	}
 	switch_task_namespaces(tsk, new_nsproxy);
+
+	audit_log_ns_set(ops, ei->ns);
+
 out:
 	fput(file);
 	return err;
-- 
1.7.1
