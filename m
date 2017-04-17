From: Kirill Tkhai <ktkhai-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Subject: [PATCH 1/2] nsfs: Add namespace-specific ioctl (NS_SPECIFIC_IOC)
Date: Mon, 17 Apr 2017 20:36:00 +0300
Message-ID: <149245048927.17600.6201635115178279430.stgit@localhost.localdomain>
References: <149245014695.17600.12640895883798122726.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <149245014695.17600.12640895883798122726.stgit-bi+AKbBUZKY6gyzm1THtWbp2dZbC/Bob@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, agruenba-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org, ktkhai-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org, gorcunov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org
List-Id: linux-api@vger.kernel.org

Some namespaces types want have their own ioctls.
For, example, pid namespace needs a ioctl, allowing
to set vector of ns_last_pid on namespaces hierarchy.

This patch introduces proc_ns_operations::ns_ioctl()
to allow namespaces determine specific ioctls.

Signed-off-by: Kirill Tkhai <ktkhai-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
---
 fs/nsfs.c                 |    4 ++++
 include/linux/proc_ns.h   |    1 +
 include/uapi/linux/nsfs.h |    2 ++
 3 files changed, 7 insertions(+)

diff --git a/fs/nsfs.c b/fs/nsfs.c
index 1656843e87d2..fed7e5c59e9c 100644
--- a/fs/nsfs.c
+++ b/fs/nsfs.c
@@ -185,6 +185,10 @@ static long ns_ioctl(struct file *filp, unsigned int ioctl,
 		argp = (uid_t __user *) arg;
 		uid = from_kuid_munged(current_user_ns(), user_ns->owner);
 		return put_user(uid, argp);
+	case NS_SPECIFIC_IOC:
+		if (!ns->ops->ns_ioctl)
+			return -ENOTTY;
+		return ns->ops->ns_ioctl(ns, arg);
 	default:
 		return -ENOTTY;
 	}
diff --git a/include/linux/proc_ns.h b/include/linux/proc_ns.h
index 12cb8bd81d2d..c645a2174933 100644
--- a/include/linux/proc_ns.h
+++ b/include/linux/proc_ns.h
@@ -20,6 +20,7 @@ struct proc_ns_operations {
 	int (*install)(struct nsproxy *nsproxy, struct ns_common *ns);
 	struct user_namespace *(*owner)(struct ns_common *ns);
 	struct ns_common *(*get_parent)(struct ns_common *ns);
+	long (*ns_ioctl)(struct ns_common *ns, unsigned long arg);
 };
 
 extern const struct proc_ns_operations netns_operations;
diff --git a/include/uapi/linux/nsfs.h b/include/uapi/linux/nsfs.h
index 1a3ca79f466b..544bbb661475 100644
--- a/include/uapi/linux/nsfs.h
+++ b/include/uapi/linux/nsfs.h
@@ -14,5 +14,7 @@
 #define NS_GET_NSTYPE		_IO(NSIO, 0x3)
 /* Get owner UID (in the caller's user namespace) for a user namespace */
 #define NS_GET_OWNER_UID	_IO(NSIO, 0x4)
+/* Execute namespace-specific ioctl */
+#define NS_SPECIFIC_IOC		_IO(NSIO, 0x5)
 
 #endif /* __LINUX_NSFS_H */
