From: Konstantin Khlebnikov <khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org>
Subject: [PATCH RFC v3 1/2] nsfs: replace proc_ns_fget() with proc_ns_fdget()
Date: Fri, 25 Sep 2015 16:52:46 +0300
Message-ID: <20150925135246.27620.97496.stgit@buzz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Roman Gushchin <klamm-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org>, Serge Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Chen Fan <chen.fan.fnst-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, =?utf-8?b?U3TDqXBoYW5l?= Graber <stgraber-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

New helper function returns pointer to struct ns_common, can check
namespace type and uses struct fd for returning file reference:
this saves couple atomic operations for single-threaded applications.

Signed-off-by: Konstantin Khlebnikov <khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org>
---
 fs/nsfs.c                |   20 +++++++++++++-------
 include/linux/proc_ns.h  |    4 +++-
 kernel/nsproxy.c         |   15 +++++----------
 net/core/net_namespace.c |   18 ++++++------------
 4 files changed, 27 insertions(+), 30 deletions(-)

diff --git a/fs/nsfs.c b/fs/nsfs.c
index 8f20d6016e20..a2e803c97960 100644
--- a/fs/nsfs.c
+++ b/fs/nsfs.c
@@ -119,21 +119,27 @@ int ns_get_name(char *buf, size_t size, struct task_struct *task,
 	return res;
 }
 
-struct file *proc_ns_fget(int fd)
+struct ns_common *proc_ns_fdget(int fd, int nstype, struct fd *fd_ref)
 {
-	struct file *file;
+	struct ns_common *ns;
+	struct fd f;
 
-	file = fget(fd);
-	if (!file)
+	f = fdget(fd);
+	if (!f.file)
 		return ERR_PTR(-EBADF);
 
-	if (file->f_op != &ns_file_operations)
+	if (f.file->f_op != &ns_file_operations)
+		goto out_invalid;
+
+	ns = get_proc_ns(file_inode(f.file));
+	if (nstype && (ns->ops->type != nstype))
 		goto out_invalid;
 
-	return file;
+	*fd_ref = f;
+	return ns;
 
 out_invalid:
-	fput(file);
+	fdput(f);
 	return ERR_PTR(-EINVAL);
 }
 
diff --git a/include/linux/proc_ns.h b/include/linux/proc_ns.h
index 42dfc615dbf8..406ea4617606 100644
--- a/include/linux/proc_ns.h
+++ b/include/linux/proc_ns.h
@@ -9,6 +9,7 @@
 struct pid_namespace;
 struct nsproxy;
 struct path;
+struct fd;
 
 struct proc_ns_operations {
 	const char *name;
@@ -65,7 +66,8 @@ static inline int ns_alloc_inum(struct ns_common *ns)
 
 #define ns_free_inum(ns) proc_free_inum((ns)->inum)
 
-extern struct file *proc_ns_fget(int fd);
+extern struct ns_common *proc_ns_fdget(int fd, int nstype, struct fd *fd_ref);
+
 #define get_proc_ns(inode) ((struct ns_common *)(inode)->i_private)
 extern void *ns_get_path(struct path *path, struct task_struct *task,
 			const struct proc_ns_operations *ns_ops);
diff --git a/kernel/nsproxy.c b/kernel/nsproxy.c
index 49746c81ad8d..689b929a0fcb 100644
--- a/kernel/nsproxy.c
+++ b/kernel/nsproxy.c
@@ -222,18 +222,13 @@ SYSCALL_DEFINE2(setns, int, fd, int, nstype)
 {
 	struct task_struct *tsk = current;
 	struct nsproxy *new_nsproxy;
-	struct file *file;
+	struct fd fd_ref;
 	struct ns_common *ns;
 	int err;
 
-	file = proc_ns_fget(fd);
-	if (IS_ERR(file))
-		return PTR_ERR(file);
-
-	err = -EINVAL;
-	ns = get_proc_ns(file_inode(file));
-	if (nstype && (ns->ops->type != nstype))
-		goto out;
+	ns = proc_ns_fdget(fd, nstype, &fd_ref);
+	if (IS_ERR(ns))
+		return PTR_ERR(ns);
 
 	new_nsproxy = create_new_namespaces(0, tsk, current_user_ns(), tsk->fs);
 	if (IS_ERR(new_nsproxy)) {
@@ -248,7 +243,7 @@ SYSCALL_DEFINE2(setns, int, fd, int, nstype)
 	}
 	switch_task_namespaces(tsk, new_nsproxy);
 out:
-	fput(file);
+	fdput(fd_ref);
 	return err;
 }
 
diff --git a/net/core/net_namespace.c b/net/core/net_namespace.c
index 2c2eb1b629b1..ffc5e6df86dc 100644
--- a/net/core/net_namespace.c
+++ b/net/core/net_namespace.c
@@ -465,21 +465,15 @@ EXPORT_SYMBOL_GPL(__put_net);
 
 struct net *get_net_ns_by_fd(int fd)
 {
-	struct file *file;
 	struct ns_common *ns;
+	struct fd fd_ref;
 	struct net *net;
 
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
+	ns = proc_ns_fdget(fd, CLONE_NEWNET, &fd_ref);
+	if (IS_ERR(ns))
+		return ERR_CAST(ns);
+	net = get_net(container_of(ns, struct net, ns));
+	fdput(fd_ref);
 	return net;
 }
 
