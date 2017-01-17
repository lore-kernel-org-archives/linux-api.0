From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Subject: [PATCH v3 2/2] nsfs: Add an ioctl() to return owner UID of a userns
Date: Tue, 17 Jan 2017 14:03:29 +1300
Message-ID: <daac6f7d-bc1e-bd61-355b-e47cf93e2535@gmail.com>
References: <69550fe9-5347-309c-b421-79c16a6300f6@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <69550fe9-5347-309c-b421-79c16a6300f6@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: mtk.manpages@gmail.com, "Serge E. Hallyn" <serge@hallyn.com>, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, Andrey Vagin <avagin@openvz.org>, James Bottomley <James.Bottomley@hansenpartnership.com>, "W. Trevor King" <wking@tremily.us>, Alexander Viro <viro@zeniv.linux.org.uk>
List-Id: linux-api@vger.kernel.org

I'd like to write code that discovers the user namespace hierarchy on
a running system, and also shows who owns the various user namespaces.
Currently, there is no way of getting the owner UID of a user
namespace. Therefore, this patch adds an NS_GET_CREATOR_UID ioctl()
that fetches the (munged) UID of the creator of the user namespace
referred to by the specified file descriptor.

If the supplied file descriptor does not refer to a user namespace,
the operation fails with the error EINVAL.

Acked-by: Andrey Vagin <avagin@openvz.org>
Signed-off-by: Michael Kerrisk <mtk-manpages@gmail.com>

---
Open questions:

Should the type for the ioctl() argument be changed? I mean,
make the following changes to the patch below:

-       unsigned int __user *argp;
+       uid_t __user *argp;

And further below, change:

-             argp = (unsigned int __user *) arg;
+             argp = (uid_t __user *) arg;

?

V3 changes:
* Fixed data type of local variable 'uid'; thanks to Andrei Vagin

V2 changes:
* Renamed ioctl() from NS_CREATOR_UID to NS_OWNER_UID, at the
  suggestion of Eric Biederman.
* Make ioctl() return UID via buffer pointed to by argp. (Returning
  the UID via the result value could lead to problems since a large
  unsigned int UID might be misinterpreted as an error.) Thanks to
  Andrei Vagin for pointing this out.
---
 fs/nsfs.c                 | 11 +++++++++++
 include/uapi/linux/nsfs.h |  8 +++++---
 2 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/fs/nsfs.c b/fs/nsfs.c
index 5d53476..63a4ad4 100644
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
+	unsigned int __user *argp;
+	uid_t uid;
 
 	switch (ioctl) {
 	case NS_GET_USERNS:
@@ -174,6 +178,13 @@ static long ns_ioctl(struct file *filp, unsigned int ioctl,
 		return open_related_ns(ns, ns->ops->get_parent);
 	case NS_GET_NSTYPE:
 		return ns->ops->type;
+	case NS_GET_OWNER_UID:
+		if (ns->ops->type != CLONE_NEWUSER)
+			return -EINVAL;
+		user_ns = container_of(ns, struct user_namespace, ns);
+		argp = (unsigned int __user *) arg;
+		uid = from_kuid_munged(current_user_ns(), user_ns->owner);
+		return put_user(uid, argp);
 	default:
 		return -ENOTTY;
 	}
diff --git a/include/uapi/linux/nsfs.h b/include/uapi/linux/nsfs.h
index 2b48df1..c4a925e 100644
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
+/* Get owner UID for a user namespace */
+#define NS_GET_OWNER_UID	_IO(NSIO, 0x4)
 
 #endif /* __LINUX_NSFS_H */
-- 
2.5.5
