From: Richard Guy Briggs <rgb@redhat.com>
Subject: [RFC PATCH ghak32 V2 01/13] audit: add container id
Date: Fri, 16 Mar 2018 05:00:28 -0400
Message-ID: <e284617ad667ad8f17958dd8babb87fe1b4d7205.1521179281.git.rgb@redhat.com>
References: <cover.1521179281.git.rgb@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1521179281.git.rgb@redhat.com>
In-Reply-To: <cover.1521179281.git.rgb@redhat.com>
References: <cover.1521179281.git.rgb@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: cgroups@vger.kernel.org, containers@lists.linux-foundation.org, linux-api@vger.kernel.org, Linux-Audit Mailing List <linux-audit@redhat.com>, linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org
Cc: luto@kernel.org, jlayton@redhat.com, carlos@redhat.com, viro@zeniv.linux.org.uk, dhowells@redhat.com, simo@redhat.com, eparis@parisplace.org, serge@hallyn.com, ebiederm@xmission.com, madzcar@gmail.com, Richard Guy Briggs <rgb@redhat.com>
List-Id: linux-api@vger.kernel.org

Implement the proc fs write to set the audit container ID of a process,
emitting an AUDIT_CONTAINER record to document the event.

This is a write from the container orchestrator task to a proc entry of
the form /proc/PID/containerid where PID is the process ID of the newly
created task that is to become the first task in a container, or an
additional task added to a container.

The write expects up to a u64 value (unset: 18446744073709551615).

This will produce a record such as this:
type=CONTAINER msg=audit(1519903238.968:261): op=set pid=596 uid=0 subj=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 auid=0 tty=pts0 ses=1 opid=596 old-contid=18446744073709551615 contid=123455 res=0

The "op" field indicates an initial set.  The "pid" to "ses" fields are
the orchestrator while the "opid" field is the object's PID, the process
being "contained".  Old and new container ID values are given in the
"contid" fields, while res indicates its success.

It is not permitted to self-set, unset or re-set the container ID.  A
child inherits its parent's container ID, but then can be set only once
after.

See: https://github.com/linux-audit/audit-kernel/issues/32

Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
---
 fs/proc/base.c             | 37 ++++++++++++++++++++
 include/linux/audit.h      | 16 +++++++++
 include/linux/init_task.h  |  4 ++-
 include/linux/sched.h      |  1 +
 include/uapi/linux/audit.h |  2 ++
 kernel/auditsc.c           | 84 ++++++++++++++++++++++++++++++++++++++++++++++
 6 files changed, 143 insertions(+), 1 deletion(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index 60316b5..6ce4fbe 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -1299,6 +1299,41 @@ static ssize_t proc_sessionid_read(struct file * file, char __user * buf,
 	.read		= proc_sessionid_read,
 	.llseek		= generic_file_llseek,
 };
+
+static ssize_t proc_containerid_write(struct file *file, const char __user *buf,
+				   size_t count, loff_t *ppos)
+{
+	struct inode *inode = file_inode(file);
+	u64 containerid;
+	int rv;
+	struct task_struct *task = get_proc_task(inode);
+
+	if (!task)
+		return -ESRCH;
+	if (*ppos != 0) {
+		/* No partial writes. */
+		put_task_struct(task);
+		return -EINVAL;
+	}
+
+	rv = kstrtou64_from_user(buf, count, 10, &containerid);
+	if (rv < 0) {
+		put_task_struct(task);
+		return rv;
+	}
+
+	rv = audit_set_containerid(task, containerid);
+	put_task_struct(task);
+	if (rv < 0)
+		return rv;
+	return count;
+}
+
+static const struct file_operations proc_containerid_operations = {
+	.write		= proc_containerid_write,
+	.llseek		= generic_file_llseek,
+};
+
 #endif
 
 #ifdef CONFIG_FAULT_INJECTION
@@ -2961,6 +2996,7 @@ static int proc_pid_patch_state(struct seq_file *m, struct pid_namespace *ns,
 #ifdef CONFIG_AUDITSYSCALL
 	REG("loginuid",   S_IWUSR|S_IRUGO, proc_loginuid_operations),
 	REG("sessionid",  S_IRUGO, proc_sessionid_operations),
+	REG("containerid", S_IWUSR, proc_containerid_operations),
 #endif
 #ifdef CONFIG_FAULT_INJECTION
 	REG("make-it-fail", S_IRUGO|S_IWUSR, proc_fault_inject_operations),
@@ -3355,6 +3391,7 @@ static int proc_tid_comm_permission(struct inode *inode, int mask)
 #ifdef CONFIG_AUDITSYSCALL
 	REG("loginuid",  S_IWUSR|S_IRUGO, proc_loginuid_operations),
 	REG("sessionid",  S_IRUGO, proc_sessionid_operations),
+	REG("containerid", S_IWUSR, proc_containerid_operations),
 #endif
 #ifdef CONFIG_FAULT_INJECTION
 	REG("make-it-fail", S_IRUGO|S_IWUSR, proc_fault_inject_operations),
diff --git a/include/linux/audit.h b/include/linux/audit.h
index af410d9..fe4ba3f 100644
--- a/include/linux/audit.h
+++ b/include/linux/audit.h
@@ -29,6 +29,7 @@
 
 #define AUDIT_INO_UNSET ((unsigned long)-1)
 #define AUDIT_DEV_UNSET ((dev_t)-1)
+#define INVALID_CID AUDIT_CID_UNSET
 
 struct audit_sig_info {
 	uid_t		uid;
@@ -321,6 +322,7 @@ static inline void audit_ptrace(struct task_struct *t)
 extern int auditsc_get_stamp(struct audit_context *ctx,
 			      struct timespec64 *t, unsigned int *serial);
 extern int audit_set_loginuid(kuid_t loginuid);
+extern int audit_set_containerid(struct task_struct *tsk, u64 containerid);
 
 static inline kuid_t audit_get_loginuid(struct task_struct *tsk)
 {
@@ -332,6 +334,11 @@ static inline unsigned int audit_get_sessionid(struct task_struct *tsk)
 	return tsk->sessionid;
 }
 
+static inline u64 audit_get_containerid(struct task_struct *tsk)
+{
+	return tsk->containerid;
+}
+
 extern void __audit_ipc_obj(struct kern_ipc_perm *ipcp);
 extern void __audit_ipc_set_perm(unsigned long qbytes, uid_t uid, gid_t gid, umode_t mode);
 extern void __audit_bprm(struct linux_binprm *bprm);
@@ -517,6 +524,10 @@ static inline unsigned int audit_get_sessionid(struct task_struct *tsk)
 {
 	return -1;
 }
+static inline kuid_t audit_get_containerid(struct task_struct *tsk)
+{
+	return INVALID_CID;
+}
 static inline void audit_ipc_obj(struct kern_ipc_perm *ipcp)
 { }
 static inline void audit_ipc_set_perm(unsigned long qbytes, uid_t uid,
@@ -581,6 +592,11 @@ static inline bool audit_loginuid_set(struct task_struct *tsk)
 	return uid_valid(audit_get_loginuid(tsk));
 }
 
+static inline bool audit_containerid_set(struct task_struct *tsk)
+{
+	return audit_get_containerid(tsk) != INVALID_CID;
+}
+
 static inline void audit_log_string(struct audit_buffer *ab, const char *buf)
 {
 	audit_log_n_string(ab, buf, strlen(buf));
diff --git a/include/linux/init_task.h b/include/linux/init_task.h
index 6a53262..046bd0a 100644
--- a/include/linux/init_task.h
+++ b/include/linux/init_task.h
@@ -18,6 +18,7 @@
 #include <linux/sched/rt.h>
 #include <linux/livepatch.h>
 #include <linux/mm_types.h>
+#include <linux/audit.h>
 
 #include <asm/thread_info.h>
 
@@ -120,7 +121,8 @@
 #ifdef CONFIG_AUDITSYSCALL
 #define INIT_IDS \
 	.loginuid = INVALID_UID, \
-	.sessionid = (unsigned int)-1,
+	.sessionid = (unsigned int)-1, \
+	.containerid = INVALID_CID,
 #else
 #define INIT_IDS
 #endif
diff --git a/include/linux/sched.h b/include/linux/sched.h
index d258826..1b82191 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -796,6 +796,7 @@ struct task_struct {
 #ifdef CONFIG_AUDITSYSCALL
 	kuid_t				loginuid;
 	unsigned int			sessionid;
+	u64				containerid;
 #endif
 	struct seccomp			seccomp;
 
diff --git a/include/uapi/linux/audit.h b/include/uapi/linux/audit.h
index 4e61a9e..921a71f 100644
--- a/include/uapi/linux/audit.h
+++ b/include/uapi/linux/audit.h
@@ -71,6 +71,7 @@
 #define AUDIT_TTY_SET		1017	/* Set TTY auditing status */
 #define AUDIT_SET_FEATURE	1018	/* Turn an audit feature on or off */
 #define AUDIT_GET_FEATURE	1019	/* Get which features are enabled */
+#define AUDIT_CONTAINER		1020	/* Define the container id and information */
 
 #define AUDIT_FIRST_USER_MSG	1100	/* Userspace messages mostly uninteresting to kernel */
 #define AUDIT_USER_AVC		1107	/* We filter this differently */
@@ -465,6 +466,7 @@ struct audit_tty_status {
 };
 
 #define AUDIT_UID_UNSET (unsigned int)-1
+#define AUDIT_CID_UNSET ((u64)-1)
 
 /* audit_rule_data supports filter rules with both integer and string
  * fields.  It corresponds with AUDIT_ADD_RULE, AUDIT_DEL_RULE and
diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index 4e0a4ac..29c8482 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -2073,6 +2073,90 @@ int audit_set_loginuid(kuid_t loginuid)
 	return rc;
 }
 
+static int audit_set_containerid_perm(struct task_struct *task, u64 containerid)
+{
+	struct task_struct *parent;
+	u64 pcontainerid, ccontainerid;
+
+	/* Don't allow to set our own containerid */
+	if (current == task)
+		return -EPERM;
+	/* Don't allow the containerid to be unset */
+	if (!cid_valid(containerid))
+		return -EINVAL;
+	/* if we don't have caps, reject */
+	if (!capable(CAP_AUDIT_CONTROL))
+		return -EPERM;
+	/* if containerid is unset, allow */
+	if (!audit_containerid_set(task))
+		return 0;
+	/* it is already set, and not inherited from the parent, reject */
+	ccontainerid = audit_get_containerid(task);
+	rcu_read_lock();
+	parent = rcu_dereference(task->real_parent);
+	rcu_read_unlock();
+	task_lock(parent);
+	pcontainerid = audit_get_containerid(parent);
+	task_unlock(parent);
+	if (ccontainerid != pcontainerid)
+		return -EPERM;
+	return 0;
+}
+
+static void audit_log_set_containerid(struct task_struct *task, u64 oldcontainerid,
+				      u64 containerid, int rc)
+{
+	struct audit_buffer *ab;
+	uid_t uid;
+	struct tty_struct *tty;
+
+	if (!audit_enabled)
+		return;
+
+	ab = audit_log_start(NULL, GFP_KERNEL, AUDIT_CONTAINER);
+	if (!ab)
+		return;
+
+	uid = from_kuid(&init_user_ns, task_uid(current));
+	tty = audit_get_tty(current);
+
+	audit_log_format(ab, "op=set pid=%d uid=%u", task_tgid_nr(current), uid);
+	audit_log_task_context(ab);
+	audit_log_format(ab, " auid=%u tty=%s ses=%u opid=%d old-contid=%llu contid=%llu res=%d",
+			 from_kuid(&init_user_ns, audit_get_loginuid(current)),
+			 tty ? tty_name(tty) : "(none)", audit_get_sessionid(current),
+			 task_tgid_nr(task), oldcontainerid, containerid, !rc);
+
+	audit_put_tty(tty);
+	audit_log_end(ab);
+}
+
+/**
+ * audit_set_containerid - set current task's audit_context containerid
+ * @containerid: containerid value
+ *
+ * Returns 0 on success, -EPERM on permission failure.
+ *
+ * Called (set) from fs/proc/base.c::proc_containerid_write().
+ */
+int audit_set_containerid(struct task_struct *task, u64 containerid)
+{
+	u64 oldcontainerid;
+	int rc;
+
+	oldcontainerid = audit_get_containerid(task);
+
+	rc = audit_set_containerid_perm(task, containerid);
+	if (!rc) {
+		task_lock(task);
+		task->containerid = containerid;
+		task_unlock(task);
+	}
+
+	audit_log_set_containerid(task, oldcontainerid, containerid, rc);
+	return rc;
+}
+
 /**
  * __audit_mq_open - record audit data for a POSIX MQ open
  * @oflag: open flag
-- 
1.8.3.1
