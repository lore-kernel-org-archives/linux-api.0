From: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v4 2/2] nsfs: Add an ioctl() to return owner UID of a userns
Date: Wed, 25 Jan 2017 14:04:15 +1300
Message-ID: <628f8630-6631-8292-1841-2a45e74ae96f@gmail.com>
References: <93e5c7f9-9dc1-6c93-ad20-0ba053d8bfef@gmail.com>
 <2c27a76e-336d-e2ad-4b30-22e29249c2e9@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <2c27a76e-336d-e2ad-4b30-22e29249c2e9-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Cc: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrey Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, James Bottomley <James.Bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, "W. Trevor King" <wking-vJI2gpByivqcqzYg7KEe8g@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
List-Id: linux-api@vger.kernel.org

I'd like to write code that discovers the user namespace hierarchy on a
running system, and also shows who owns the various user namespaces.
Currently, there is no way of getting the owner UID of a user namespace.
Therefore, this patch adds a new NS_GET_CREATOR_UID ioctl() that fetches
the UID (as seen in the user namespace of the caller) of the creator of
the user namespace referred to by the specified file descriptor.

If the supplied file descriptor does not refer to a user namespace,
the operation fails with the error EINVAL. If the owner UID does
not have a mapping in the caller's user namespace, the operation
fails with the error EOVERFLOW. (Failing with EOVERFLOW, rather than
returning the overflow UID, is probably easier to deal with in
user-space applications.)

Acked-by: Andrey Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Signed-off-by: Michael Kerrisk <mtk-manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

---

V4 changes:
* Improve comment describing NS_GET_OWNER_UID (thanks to
  W. Trevor King)
* Use uid_t (rather than unsigned int) as type for ioctl() argument.
* Rather than returning the overflow UID if the owner UID does not have
  a mapping in the caller's user namespace, fail with the error
  EOVERFLOW. This makes user-space coding a little easier.
  (Thanks to the suggestion from Eric Biederman.)

V3 changes:
* Fixed data type of local variable 'uid'; thanks to Andrei Vagin.

V2 changes:
* Renamed ioctl() from NS_GET_CREATOR_UID to NS_GET_OWNER_UID, at the
  suggestion of Eric Biederman.
* Make ioctl() return UID via buffer pointed to by argp. (Returning
  the UID via the result value could lead to problems since a large
  unsigned int UID might be misinterpreted as an error.) Thanks to
  Andrei Vagin for pointing this out.
---
 fs/nsfs.c                 | 13 +++++++++++++
 include/uapi/linux/nsfs.h |  8 +++++---
 2 files changed, 18 insertions(+), 3 deletions(-)

diff --git a/fs/nsfs.c b/fs/nsfs.c
index 5d53476..4842617 100644
--- a/fs/nsfs.c
+++ b/fs/nsfs.c
@@ -7,6 +7,7 @@
 #include <linux/seq_file.h>
 #include <linux/user_namespace.h>
 #include <linux/nsfs.h>
+#include <linux/uaccess.h>
 
 static struct vfsmount *nsfs_mnt;
 
@@ -163,7 +164,10 @@ int open_related_ns(struct ns_common *ns,
 static long ns_ioctl(struct file *filp, unsigned int ioctl,
 			unsigned long arg)
 {
+	struct user_namespace *user_ns;
 	struct ns_common *ns = get_proc_ns(file_inode(filp));
+	uid_t __user *argp;
+	uid_t uid;
 
 	switch (ioctl) {
 	case NS_GET_USERNS:
@@ -174,6 +178,15 @@ static long ns_ioctl(struct file *filp, unsigned int ioctl,
 		return open_related_ns(ns, ns->ops->get_parent);
 	case NS_GET_NSTYPE:
 		return ns->ops->type;
+	case NS_GET_OWNER_UID:
+		if (ns->ops->type != CLONE_NEWUSER)
+			return -EINVAL;
+		user_ns = container_of(ns, struct user_namespace, ns);
+		argp = (uid_t __user *) arg;
+		uid = from_kuid(current_user_ns(), user_ns->owner);
+		if (uid == (uid_t)-1)
+			return -EOVERFLOW;
+		return put_user(uid, argp);
 	default:
 		return -ENOTTY;
 	}
diff --git a/include/uapi/linux/nsfs.h b/include/uapi/linux/nsfs.h
index 2b48df1..1a3ca79 100644
--- a/include/uapi/linux/nsfs.h
+++ b/include/uapi/linux/nsfs.h
@@ -6,11 +6,13 @@
 #define NSIO	0xb7
 
 /* Returns a file descriptor that refers to an owning user namespace */
-#define NS_GET_USERNS	_IO(NSIO, 0x1)
+#define NS_GET_USERNS		_IO(NSIO, 0x1)
 /* Returns a file descriptor that refers to a parent namespace */
-#define NS_GET_PARENT	_IO(NSIO, 0x2)
+#define NS_GET_PARENT		_IO(NSIO, 0x2)
 /* Returns the type of namespace (CLONE_NEW* value) referred to by
    file descriptor */
-#define NS_GET_NSTYPE	_IO(NSIO, 0x3)
+#define NS_GET_NSTYPE		_IO(NSIO, 0x3)
+/* Get owner UID (in the caller's user namespace) for a user namespace */
+#define NS_GET_OWNER_UID	_IO(NSIO, 0x4)
 
 #endif /* __LINUX_NSFS_H */
-- 
2.5.5
