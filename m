From: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 1/1] ns: introduce proc_get_ns_by_fd()
Date: Fri, 25 Sep 2015 19:57:14 +0200
Message-ID: <20150925175714.GB12504@redhat.com>
References: <20150925135246.27620.97496.stgit@buzz>
	<20150925175654.GA12504@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150925175654.GA12504-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/containers/>
List-Post: <mailto:containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: Konstantin Khlebnikov <khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org>
Cc: Roman Gushchin <klamm-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, Serge Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Chen Fan <chen.fan.fnst-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Introduce proc_get_ns_by_fd() so that get_net_ns_by_fd() becomes
one-liner. It will have another CLONE_NEWPID user soon.

TODO: proc_get_ns_by_fd() can share some code with proc_ns_fget().

Signed-off-by: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/nsfs.c                |   24 ++++++++++++++++++++++++
 include/linux/proc_ns.h  |    3 +++
 kernel/pid_namespace.c   |    6 ++++++
 net/core/net_namespace.c |   23 +++++++----------------
 4 files changed, 40 insertions(+), 16 deletions(-)

diff --git a/fs/nsfs.c b/fs/nsfs.c
index 99521e7..72474ca 100644
--- a/fs/nsfs.c
+++ b/fs/nsfs.c
@@ -136,6 +136,30 @@ out_invalid:
 	return ERR_PTR(-EINVAL);
 }
 
+void *proc_get_ns_by_fd(int fd, int type)
+{
+	struct fd f;
+	struct ns_common *ns;
+	void *ret;
+
+	f = fdget(fd);
+	if (!f.file)
+		return ERR_PTR(-EBADF);
+
+	ret = ERR_PTR(-EINVAL);
+	if (f.file->f_op != &ns_file_operations)
+		goto put;
+
+	ns = get_proc_ns(file_inode(f.file));
+	if (ns->ops->type != type || !ns->ops->get_type)
+		goto put;
+
+	ret = ns->ops->get_type(ns);
+put:
+	fdput(f);
+	return ret;
+}
+
 static const struct super_operations nsfs_ops = {
 	.statfs = simple_statfs,
 	.evict_inode = nsfs_evict,
diff --git a/include/linux/proc_ns.h b/include/linux/proc_ns.h
index 42dfc61..d956f89 100644
--- a/include/linux/proc_ns.h
+++ b/include/linux/proc_ns.h
@@ -16,6 +16,7 @@ struct proc_ns_operations {
 	struct ns_common *(*get)(struct task_struct *task);
 	void (*put)(struct ns_common *ns);
 	int (*install)(struct nsproxy *nsproxy, struct ns_common *ns);
+	void *(*get_type)(struct ns_common *ns);
 };
 
 extern const struct proc_ns_operations netns_operations;
@@ -66,6 +67,8 @@ static inline int ns_alloc_inum(struct ns_common *ns)
 #define ns_free_inum(ns) proc_free_inum((ns)->inum)
 
 extern struct file *proc_ns_fget(int fd);
+extern void *proc_get_ns_by_fd(int fd, int type);
+
 #define get_proc_ns(inode) ((struct ns_common *)(inode)->i_private)
 extern void *ns_get_path(struct path *path, struct task_struct *task,
 			const struct proc_ns_operations *ns_ops);
diff --git a/kernel/pid_namespace.c b/kernel/pid_namespace.c
index a65ba13..0c87393 100644
--- a/kernel/pid_namespace.c
+++ b/kernel/pid_namespace.c
@@ -388,12 +388,18 @@ static int pidns_install(struct nsproxy *nsproxy, struct ns_common *ns)
 	return 0;
 }
 
+static void *pidns_get_type(struct ns_common *ns)
+{
+	return get_pid_ns(to_pid_ns(ns));
+}
+
 const struct proc_ns_operations pidns_operations = {
 	.name		= "pid",
 	.type		= CLONE_NEWPID,
 	.get		= pidns_get,
 	.put		= pidns_put,
 	.install	= pidns_install,
+	.get_type	= pidns_get_type,
 };
 
 static __init int pid_namespaces_init(void)
diff --git a/net/core/net_namespace.c b/net/core/net_namespace.c
index 572af00..6465dc0 100644
--- a/net/core/net_namespace.c
+++ b/net/core/net_namespace.c
@@ -420,22 +420,7 @@ EXPORT_SYMBOL_GPL(__put_net);
 
 struct net *get_net_ns_by_fd(int fd)
 {
-	struct file *file;
-	struct ns_common *ns;
-	struct net *net;
-
-	file = proc_ns_fget(fd);
-	if (IS_ERR(file))
-		return ERR_CAST(file);
-
-	ns = get_proc_ns(file_inode(file));
-	if (ns->ops == &netns_operations)
-		net = get_net(container_of(ns, struct net, ns));
-	else
-		net = ERR_PTR(-EINVAL);
-
-	fput(file);
-	return net;
+	return proc_get_ns_by_fd(fd, CLONE_NEWNET);
 }
 
 #else
@@ -955,11 +940,17 @@ static int netns_install(struct nsproxy *nsproxy, struct ns_common *ns)
 	return 0;
 }
 
+static void *netns_get_type(struct ns_common *ns)
+{
+	return get_net(to_net_ns(ns));
+}
+
 const struct proc_ns_operations netns_operations = {
 	.name		= "net",
 	.type		= CLONE_NEWNET,
 	.get		= netns_get,
 	.put		= netns_put,
 	.install	= netns_install,
+	.get_type	= netns_get_type,
 };
 #endif
-- 
1.5.5.1
