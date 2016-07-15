From: Andrey Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Subject: [PATCH 3/5] nsfs: add ioctl to get an owning user namespace for ns
	file descriptor
Date: Thu, 14 Jul 2016 19:12:20 -0700
Message-ID: <1468548742-32136-3-git-send-email-avagin@openvz.org>
References: <CANaxB-xw_xBUq=0uT14ANv-jfg2NsGaPy=jyDO9=yF03_7toSw@mail.gmail.com>
	<1468548742-32136-1-git-send-email-avagin@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <1468548742-32136-1-git-send-email-avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
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
Cc: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, Andrey Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, criu-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Each namespace has an owning user namespace and now there is not way
to discover these relationships.

Understending namespaces relationships allows to answer the question:
what capability does process X have to perform operations on a resource
governed by namespace Y?

After a long discussion, Eric W. Biederman proposed to use ioctl-s for
this purpose.

The NS_GET_USERNS ioctl returns a file descriptor to an owning user
namespace.
It returns EPERM if a target namespace is outside of a current user
namespace.

Link: https://lkml.org/lkml/2016/7/6/158
Signed-off-by: Andrey Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
---
 fs/nsfs.c                 | 94 ++++++++++++++++++++++++++++++++++++++++-------
 include/uapi/linux/nsfs.h |  9 +++++
 2 files changed, 90 insertions(+), 13 deletions(-)
 create mode 100644 include/uapi/linux/nsfs.h

diff --git a/fs/nsfs.c b/fs/nsfs.c
index 8f20d60..1e5d2d0 100644
--- a/fs/nsfs.c
+++ b/fs/nsfs.c
@@ -5,11 +5,16 @@
 #include <linux/magic.h>
 #include <linux/ktime.h>
 #include <linux/seq_file.h>
+#include <linux/user_namespace.h>
+#include <linux/nsfs.h>
 
 static struct vfsmount *nsfs_mnt;
 
+static long ns_ioctl(struct file *filp, unsigned int ioctl,
+			unsigned long arg);
 static const struct file_operations ns_file_operations = {
 	.llseek		= no_llseek,
+	.unlocked_ioctl = ns_ioctl,
 };
 
 static char *ns_dname(struct dentry *dentry, char *buffer, int buflen)
@@ -44,22 +49,14 @@ static void nsfs_evict(struct inode *inode)
 	ns->ops->put(ns);
 }
 
-void *ns_get_path(struct path *path, struct task_struct *task,
-			const struct proc_ns_operations *ns_ops)
+static void *__ns_get_path(struct path *path, struct ns_common *ns)
 {
 	struct vfsmount *mnt = mntget(nsfs_mnt);
 	struct qstr qname = { .name = "", };
 	struct dentry *dentry;
 	struct inode *inode;
-	struct ns_common *ns;
 	unsigned long d;
 
-again:
-	ns = ns_ops->get(task);
-	if (!ns) {
-		mntput(mnt);
-		return ERR_PTR(-ENOENT);
-	}
 	rcu_read_lock();
 	d = atomic_long_read(&ns->stashed);
 	if (!d)
@@ -68,7 +65,7 @@ again:
 	if (!lockref_get_not_dead(&dentry->d_lockref))
 		goto slow;
 	rcu_read_unlock();
-	ns_ops->put(ns);
+	ns->ops->put(ns);
 got_it:
 	path->mnt = mnt;
 	path->dentry = dentry;
@@ -77,7 +74,7 @@ slow:
 	rcu_read_unlock();
 	inode = new_inode_pseudo(mnt->mnt_sb);
 	if (!inode) {
-		ns_ops->put(ns);
+		ns->ops->put(ns);
 		mntput(mnt);
 		return ERR_PTR(-ENOMEM);
 	}
@@ -95,17 +92,88 @@ slow:
 		return ERR_PTR(-ENOMEM);
 	}
 	d_instantiate(dentry, inode);
-	dentry->d_fsdata = (void *)ns_ops;
+	dentry->d_fsdata = (void *)ns->ops;
 	d = atomic_long_cmpxchg(&ns->stashed, 0, (unsigned long)dentry);
 	if (d) {
 		d_delete(dentry);	/* make sure ->d_prune() does nothing */
 		dput(dentry);
 		cpu_relax();
-		goto again;
+		return ERR_PTR(-EAGAIN);
 	}
 	goto got_it;
 }
 
+void *ns_get_path(struct path *path, struct task_struct *task,
+			const struct proc_ns_operations *ns_ops)
+{
+	struct ns_common *ns;
+	void *ret;
+
+again:
+	ns = ns_ops->get(task);
+	if (!ns)
+		return ERR_PTR(-ENOENT);
+
+	ret = __ns_get_path(path, ns);
+	if (IS_ERR(ret) && PTR_ERR(ret) == -EAGAIN)
+		goto again;
+	return ret;
+}
+
+int open_related_ns(struct ns_common *ns,
+		   struct ns_common *(*get_ns)(struct ns_common *ns))
+{
+	struct path path = {};
+	struct file *f;
+	void *err;
+	int fd;
+
+	fd = get_unused_fd_flags(O_CLOEXEC);
+	if (fd < 0)
+		return fd;
+
+	while (1) {
+		struct ns_common *parent;
+
+		parent = get_ns(ns);
+		if (IS_ERR(parent)) {
+			put_unused_fd(fd);
+			return PTR_ERR(parent);
+		}
+
+		err = __ns_get_path(&path, parent);
+		if (IS_ERR(err) && PTR_ERR(err) == -EAGAIN)
+			continue;
+		break;
+	}
+	if (IS_ERR(err)) {
+		put_unused_fd(fd);
+		return PTR_ERR(err);
+	}
+
+	f = dentry_open(&path, O_RDONLY, current_cred());
+	path_put(&path);
+	if (IS_ERR(f)) {
+		put_unused_fd(fd);
+		fd = PTR_ERR(f);
+	} else
+		fd_install(fd, f);
+	return fd;
+}
+
+static long ns_ioctl(struct file *filp, unsigned int ioctl,
+			unsigned long arg)
+{
+	struct ns_common *ns = get_proc_ns(file_inode(filp));
+
+	switch (ioctl) {
+	case NS_GET_USERNS:
+		return open_related_ns(ns, ns_get_owner);
+	default:
+		return -ENOTTY;
+	}
+}
+
 int ns_get_name(char *buf, size_t size, struct task_struct *task,
 			const struct proc_ns_operations *ns_ops)
 {
diff --git a/include/uapi/linux/nsfs.h b/include/uapi/linux/nsfs.h
new file mode 100644
index 0000000..7a09ede
--- /dev/null
+++ b/include/uapi/linux/nsfs.h
@@ -0,0 +1,9 @@
+#ifndef __LINUX_NSFS_H
+#define __LINUX_NSFS_H
+
+#include <linux/ioctl.h>
+
+#define NSIO	0xb7
+#define NS_GET_USERNS	_IO(NSIO, 0x1)
+
+#endif /* __LINUX_NSFS_H */
-- 
2.5.5
