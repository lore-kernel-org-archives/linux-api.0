From: David Drysdale <drysdale-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 10/11] capsicum: prctl(2) to force use of O_BENEATH
Date: Fri, 25 Jul 2014 14:47:06 +0100
Message-ID: <1406296033-32693-11-git-send-email-drysdale@google.com>
References: <1406296033-32693-1-git-send-email-drysdale@google.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1406296033-32693-1-git-send-email-drysdale-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Cc: Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Meredydd Luff <meredydd-zPN50pYk8eUaUu29zAJCuw@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, James Morris <james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Paolo Bonzini <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Paul Moore <paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, David Drysdale <drysdale-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Add a per-task flag that indicates all openat(2) operations
should implicitly have the O_BENEATH flag set.

Add a prctl(2) command to set this flag (irrevocably). Include
an option to force the flag set to be synchronized across all
tasks in the thread group.

Signed-off-by: David Drysdale <drysdale-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---
 fs/namei.c                 |  3 +++
 include/linux/sched.h      |  3 +++
 include/uapi/linux/prctl.h | 14 ++++++++++++++
 kernel/sys.c               | 28 ++++++++++++++++++++++++++++
 4 files changed, 48 insertions(+)

diff --git a/fs/namei.c b/fs/namei.c
index fe03a7dd7537..5d3b440869df 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -1849,6 +1849,9 @@ static int path_init(int dfd, const char *name, unsigned int *flags,
 	nd->flags = (*flags) | LOOKUP_PARENT | LOOKUP_JUMPED;
 	nd->depth = 0;
 
+	if (current->openat_beneath)
+		*flags |= LOOKUP_BENEATH;
+
 	if ((*flags) & LOOKUP_ROOT) {
 		struct dentry *root = nd->root.dentry;
 		struct inode *inode = root->d_inode;
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 306f4f0c987a..8d2943879b7b 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1303,6 +1303,9 @@ struct task_struct {
 	/* Used for emulating ABI behavior of previous Linux versions */
 	unsigned int personality;
 
+	/* Indicate that openat(2) operations implictly have O_BENEATH */
+	unsigned openat_beneath:1;
+
 	unsigned in_execve:1;	/* Tell the LSMs that the process is doing an
 				 * execve */
 	unsigned in_iowait:1;
diff --git a/include/uapi/linux/prctl.h b/include/uapi/linux/prctl.h
index 58afc04c107e..b34fb2bbdaf8 100644
--- a/include/uapi/linux/prctl.h
+++ b/include/uapi/linux/prctl.h
@@ -152,4 +152,18 @@
 #define PR_SET_THP_DISABLE	41
 #define PR_GET_THP_DISABLE	42
 
+/*
+ * If openat_beneath is set for a task, then all openat(2) operations will
+ * implicitly have the O_BENEATH flag set for them.  Once set, this flag cannot
+ * be cleared.
+ */
+#define PR_SET_OPENAT_BENEATH	44
+#define PR_GET_OPENAT_BENEATH	45
+
+/*
+  Indicate that the openat_beneath flag should be synchronized across all
+ * threads in the process.
+ */
+#define PR_SET_OPENAT_BENEATH_TSYNC	0x01
+
 #endif /* _LINUX_PRCTL_H */
diff --git a/kernel/sys.c b/kernel/sys.c
index 8d8ccf6cfb38..cf2530c41982 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -1821,6 +1821,23 @@ out:
 	return error;
 }
 
+static int prctl_set_openat_beneath(struct task_struct *me, unsigned long flags)
+{
+	me->openat_beneath = 1;
+	if (flags & PR_SET_OPENAT_BENEATH_TSYNC) {
+		struct task_struct *thread, *caller;
+		unsigned long tflags;
+
+		write_lock_irqsave(&tasklist_lock, tflags);
+		thread = caller = me;
+		while_each_thread(caller, thread) {
+			thread->openat_beneath = 1;
+		}
+		write_unlock_irqrestore(&tasklist_lock, tflags);
+	}
+	return 0;
+}
+
 #ifdef CONFIG_CHECKPOINT_RESTORE
 static int prctl_get_tid_address(struct task_struct *me, int __user **tid_addr)
 {
@@ -1996,6 +2013,17 @@ SYSCALL_DEFINE5(prctl, int, option, unsigned long, arg2, unsigned long, arg3,
 		if (arg2 || arg3 || arg4 || arg5)
 			return -EINVAL;
 		return current->no_new_privs ? 1 : 0;
+	case PR_SET_OPENAT_BENEATH:
+		if (arg2 != 1 || arg4 || arg5)
+			return -EINVAL;
+		if ((arg3 & ~(PR_SET_OPENAT_BENEATH_TSYNC)) != 0)
+			return -EINVAL;
+		error = prctl_set_openat_beneath(me, arg3);
+		break;
+	case PR_GET_OPENAT_BENEATH:
+		if (arg2 || arg3 || arg4 || arg5)
+			return -EINVAL;
+		return me->openat_beneath;
 	case PR_GET_THP_DISABLE:
 		if (arg2 || arg3 || arg4 || arg5)
 			return -EINVAL;
-- 
2.0.0.526.g5318336
