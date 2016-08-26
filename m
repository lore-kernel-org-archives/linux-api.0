From: Andrei Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Subject: [PATCH 3/4] nsfs: add ioctl to get a parent namespace
Date: Fri, 26 Aug 2016 16:08:10 -0700
Message-ID: <1472252891-4963-4-git-send-email-avagin@openvz.org>
References: <1472252891-4963-1-git-send-email-avagin@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <1472252891-4963-1-git-send-email-avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/containers/>
List-Post: <mailto:containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Cc: Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Andrey Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
List-Id: linux-api@vger.kernel.org

From: Andrey Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>

Pid and user namepaces are hierarchical. There is no way to discover
parent-child relationships.

In a future we will use this interface to dump and restore nested
namespaces.

Signed-off-by: Andrei Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
---
 fs/nsfs.c                 |  4 ++++
 include/linux/proc_ns.h   |  1 +
 include/uapi/linux/nsfs.h |  2 ++
 kernel/pid_namespace.c    | 19 +++++++++++++++++++
 kernel/user_namespace.c   |  1 +
 5 files changed, 27 insertions(+)

diff --git a/fs/nsfs.c b/fs/nsfs.c
index be7d193..11a4b15 100644
--- a/fs/nsfs.c
+++ b/fs/nsfs.c
@@ -170,6 +170,10 @@ static long ns_ioctl(struct file *filp, unsigned int ioctl,
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
index cfc8be7..e4a904b 100644
--- a/include/linux/proc_ns.h
+++ b/include/linux/proc_ns.h
@@ -19,6 +19,7 @@ struct proc_ns_operations {
 	void (*put)(struct ns_common *ns);
 	int (*install)(struct nsproxy *nsproxy, struct ns_common *ns);
 	struct user_namespace *(*get_owner)(struct ns_common *ns);
+	struct ns_common *(*get_parent)(struct ns_common *ns);
 };
 
 extern const struct proc_ns_operations netns_operations;
diff --git a/include/uapi/linux/nsfs.h b/include/uapi/linux/nsfs.h
index 5cacd5c..3af6172 100644
--- a/include/uapi/linux/nsfs.h
+++ b/include/uapi/linux/nsfs.h
@@ -7,5 +7,7 @@
 
 /* Returns a file descriptor that refers to an owning user namespace */
 #define NS_GET_USERNS	_IO(NSIO, 0x1)
+/* Returns a file descriptor that refers to a parent namespace */
+#define NS_GET_PARENT	_IO(NSIO, 0x2)
 
 #endif /* __LINUX_NSFS_H */
diff --git a/kernel/pid_namespace.c b/kernel/pid_namespace.c
index 1860d9d..6cd473c 100644
--- a/kernel/pid_namespace.c
+++ b/kernel/pid_namespace.c
@@ -405,6 +405,24 @@ static int pidns_install(struct nsproxy *nsproxy, struct ns_common *ns)
 	return 0;
 }
 
+static struct ns_common *pidns_get_parent(struct ns_common *ns)
+{
+	struct pid_namespace *active = task_active_pid_ns(current);
+	struct pid_namespace *pid_ns, *p;
+
+	/* See if the parent is in the current namespace */
+	pid_ns = p = to_pid_ns(ns)->parent;
+	for (;;) {
+		if (!p)
+			return ERR_PTR(-EPERM);
+		if (p == active)
+			break;
+		p = p->parent;
+	}
+
+	return &get_pid_ns(pid_ns)->ns;
+}
+
 static struct user_namespace *pidns_get_owner(struct ns_common *ns)
 {
 	return to_pid_ns(ns)->user_ns;
@@ -417,6 +435,7 @@ const struct proc_ns_operations pidns_operations = {
 	.put		= pidns_put,
 	.install	= pidns_install,
 	.get_owner	= pidns_get_owner,
+	.get_parent	= pidns_get_parent,
 };
 
 static __init int pid_namespaces_init(void)
diff --git a/kernel/user_namespace.c b/kernel/user_namespace.c
index f0521e4..1516c47 100644
--- a/kernel/user_namespace.c
+++ b/kernel/user_namespace.c
@@ -1080,6 +1080,7 @@ const struct proc_ns_operations userns_operations = {
 	.put		= userns_put,
 	.install	= userns_install,
 	.get_owner	= userns_get_owner,
+	.get_parent	= ns_get_owner,
 };
 
 static __init int user_namespaces_init(void)
-- 
2.5.5
