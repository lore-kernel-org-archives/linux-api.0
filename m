From: Andrey Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Subject: [PATCH 4/5] nsfs: add ioctl to get a parent namespace
Date: Thu, 14 Jul 2016 11:20:18 -0700
Message-ID: <1468520419-28220-5-git-send-email-avagin@openvz.org>
References: <1468520419-28220-1-git-send-email-avagin@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <1468520419-28220-1-git-send-email-avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/containers/>
List-Post: <mailto:containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: criu-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrey Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Pid and user namepaces are hierarchical. There is no way to discover
parent-child relationships.

In a future we will use this interface to dump and restore nested
namespaces.

Signed-off-by: Andrey Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
---
 fs/nsfs.c                 |  4 ++++
 include/linux/proc_ns.h   |  1 +
 include/uapi/linux/nsfs.h |  1 +
 kernel/pid_namespace.c    | 26 ++++++++++++++++++++++++++
 kernel/user_namespace.c   |  1 +
 5 files changed, 33 insertions(+)

diff --git a/fs/nsfs.c b/fs/nsfs.c
index 1e5d2d0..b607a42 100644
--- a/fs/nsfs.c
+++ b/fs/nsfs.c
@@ -169,6 +169,10 @@ static long ns_ioctl(struct file *filp, unsigned int ioctl,
 	switch (ioctl) {
 	case NS_GET_USERNS:
 		return open_related_ns(ns, ns_get_owner);
+	case NS_GET_PARENT:
+		if (!ns->ops->get_parent)
+			return -EINVAL;
+		return open_related_ns(ns, ns->ops->get_parent);
 	default:
 		return -ENOTTY;
 	}
diff --git a/include/linux/proc_ns.h b/include/linux/proc_ns.h
index de0e771..1c9f720 100644
--- a/include/linux/proc_ns.h
+++ b/include/linux/proc_ns.h
@@ -18,6 +18,7 @@ struct proc_ns_operations {
 	struct ns_common *(*get)(struct task_struct *task);
 	void (*put)(struct ns_common *ns);
 	int (*install)(struct nsproxy *nsproxy, struct ns_common *ns);
+	struct ns_common *(*get_parent)(struct ns_common *ns);
 };
 
 extern const struct proc_ns_operations netns_operations;
diff --git a/include/uapi/linux/nsfs.h b/include/uapi/linux/nsfs.h
index 7a09ede..88098ea 100644
--- a/include/uapi/linux/nsfs.h
+++ b/include/uapi/linux/nsfs.h
@@ -5,5 +5,6 @@
 
 #define NSIO	0xb7
 #define NS_GET_USERNS	_IO(NSIO, 0x1)
+#define NS_GET_PARENT	_IO(NSIO, 0x2)
 
 #endif /* __LINUX_NSFS_H */
diff --git a/kernel/pid_namespace.c b/kernel/pid_namespace.c
index 3529a03..a63adfb 100644
--- a/kernel/pid_namespace.c
+++ b/kernel/pid_namespace.c
@@ -388,12 +388,38 @@ static int pidns_install(struct nsproxy *nsproxy, struct ns_common *ns)
 	return 0;
 }
 
+static struct ns_common *pidns_get_parent(struct ns_common *ns)
+{
+	struct pid_namespace *active = task_active_pid_ns(current);
+	struct pid_namespace *pid_ns, *p;
+
+	pid_ns = to_pid_ns(ns);
+	if (pid_ns == &init_pid_ns) {
+		if (capable(CAP_SYS_ADMIN))
+			return ERR_PTR(-ENOENT);
+		return ERR_PTR(-EPERM);
+	}
+
+	pid_ns = p = pid_ns->parent;
+
+	for (;;) {
+		if (p == active)
+			break;
+		if (p == &init_pid_ns)
+			return ERR_PTR(-EPERM);
+		p = p->parent;
+	}
+
+	return &get_pid_ns(pid_ns)->ns;
+}
+
 const struct proc_ns_operations pidns_operations = {
 	.name		= "pid",
 	.type		= CLONE_NEWPID,
 	.get		= pidns_get,
 	.put		= pidns_put,
 	.install	= pidns_install,
+	.get_parent	= pidns_get_parent,
 };
 
 static __init int pid_namespaces_init(void)
diff --git a/kernel/user_namespace.c b/kernel/user_namespace.c
index 6382e5e..d6ba0b8 100644
--- a/kernel/user_namespace.c
+++ b/kernel/user_namespace.c
@@ -1024,6 +1024,7 @@ const struct proc_ns_operations userns_operations = {
 	.get		= userns_get,
 	.put		= userns_put,
 	.install	= userns_install,
+	.get_parent	= ns_get_owner,
 };
 
 static __init int user_namespaces_init(void)
-- 
2.5.5
