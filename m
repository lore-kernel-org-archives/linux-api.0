From: Andrey Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Subject: [PATCH] [RFC] mnt: add ability to clone mntns starting with the current root
Date: Tue,  7 Oct 2014 16:12:57 +0400
Message-ID: <1412683977-29543-1-git-send-email-avagin@openvz.org>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrey Vagin <avagin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Cyrill Gorcunov <gorcunov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Rob Landley <rob-VoJi6FS/r0vR7s880joybQ@public.gmane.org>, Andrey Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

From: Andrey Vagin <avagin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Currently when we create a new container with a separate root,
we need to clone the current mount namespace with all mounts and then
clean up it by using pivot_root(). A big part of mountpoints are cloned
only to be umounted.

Another problem is that rootfs can't be hidden from a container, because
rootfs can't be moved or umounted.

Here is an example how to get access to rootfs:
fd = open("/proc/self/ns/mnt", O_RDONLY)
umount2("/", MNT_DETACH);
setns(fd, CLONE_NEWNS)

rootfs may contain data, which should not be avaliable in CT-s.

I suggest to add ability to create a mount namespace with specified
mount points. A current task root can be used as a root for the new
mount namespace.

With this patch you can call chroot(ct->rootfs) and
unshare(UNSHARE_NEWNS2) to get a clean mount namespace.

UNSHARE_NEWNS2 can be used only with the unshare() syscall. The clone()
syscall doesn't have unused flags.

Here is an example how it looks like:
$ cat ../../unshare.c

int main(int argc, char **argv)
{
	if (unshare(UNSHARE_NEWNS2))
		return 1;

	execl("/bin/bash", "/bin/bash", NULL);
	return 1;
}
$ mount --bind test/ubuntu/ test/ubuntu/
$ cd test/ubuntu/
$ chroot .
$ ./unshare2
$ mount -t proc proc proc
$ cat /proc/self/mountinfo
55 55 252:1 /home/avagin/test/ubuntu / rw,relatime - ext4 /dev/disk/by-uuid/d672b85f-533c-4868-9609-ca80be52d3c6 rw,errors=remount-ro,data=ordered
56 55 0:3 / /proc rw,relatime - proc proc rw

Cc: Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Cc: Cyrill Gorcunov <gorcunov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Cc: Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Cc: Rob Landley <rob-VoJi6FS/r0vR7s880joybQ@public.gmane.org>
Signed-off-by: Andrey Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
---
 fs/namespace.c             | 16 ++++++++++++++--
 include/uapi/linux/sched.h |  8 ++++++++
 kernel/fork.c              | 11 ++++++++---
 kernel/nsproxy.c           |  2 +-
 4 files changed, 31 insertions(+), 6 deletions(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index 730c50e..f50a848 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -2569,12 +2569,24 @@ struct mnt_namespace *copy_mnt_ns(unsigned long flags, struct mnt_namespace *ns,
 
 	BUG_ON(!ns);
 
-	if (likely(!(flags & CLONE_NEWNS))) {
+	if (likely(!(flags & (CLONE_NEWNS | UNSHARE_NEWNS2)))) {
 		get_mnt_ns(ns);
 		return ns;
 	}
 
-	old = ns->root;
+	if (flags & CLONE_NEWNS)
+		old = ns->root;
+	else { /* UNSHARE_NEWNS2 */
+		struct path root;
+
+		get_fs_root(current->fs, &root);
+		if (root.mnt->mnt_root != root.dentry) {
+			path_put(&root);
+			return ERR_PTR(-EINVAL); /* not a mountpoint */
+		}
+		old = real_mount(root.mnt);
+		path_put(&root);
+	}
 
 	new_ns = alloc_mnt_ns(user_ns);
 	if (IS_ERR(new_ns))
diff --git a/include/uapi/linux/sched.h b/include/uapi/linux/sched.h
index 34f9d73..8092e50 100644
--- a/include/uapi/linux/sched.h
+++ b/include/uapi/linux/sched.h
@@ -31,6 +31,14 @@
 #define CLONE_IO		0x80000000	/* Clone io context */
 
 /*
+ * Following flags can be used only with unshare(), because
+ * they are intersected with CSIGNAL
+ */
+#define UNSHARE_NEWNS2		0x00000001	/* Clone mnt namespace starting with the current task root. */
+
+#define UNSHARE_FLAGS		(UNSHARE_NEWNS2)
+
+/*
  * Scheduling policies
  */
 #define SCHED_NORMAL		0
diff --git a/kernel/fork.c b/kernel/fork.c
index 0cf9cdb..52f1fc0 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1381,7 +1381,12 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 	retval = copy_mm(clone_flags, p);
 	if (retval)
 		goto bad_fork_cleanup_signal;
-	retval = copy_namespaces(clone_flags, p);
+
+	/*
+	 * CSIGNAL and UNSHARE_FLAGS are intersected, but
+	 * UNSHARE_FLAGS can't be used with clone().
+	 */
+	retval = copy_namespaces(clone_flags & ~UNSHARE_FLAGS, p);
 	if (retval)
 		goto bad_fork_cleanup_mm;
 	retval = copy_io(clone_flags, p);
@@ -1790,7 +1795,7 @@ static int check_unshare_flags(unsigned long unshare_flags)
 	if (unshare_flags & ~(CLONE_THREAD|CLONE_FS|CLONE_NEWNS|CLONE_SIGHAND|
 				CLONE_VM|CLONE_FILES|CLONE_SYSVSEM|
 				CLONE_NEWUTS|CLONE_NEWIPC|CLONE_NEWNET|
-				CLONE_NEWUSER|CLONE_NEWPID))
+				CLONE_NEWUSER|CLONE_NEWPID|UNSHARE_FLAGS))
 		return -EINVAL;
 	/*
 	 * Not implemented, but pretend it works if there is nothing to
@@ -1880,7 +1885,7 @@ SYSCALL_DEFINE1(unshare, unsigned long, unshare_flags)
 	/*
 	 * If unsharing namespace, must also unshare filesystem information.
 	 */
-	if (unshare_flags & CLONE_NEWNS)
+	if (unshare_flags & (CLONE_NEWNS | UNSHARE_NEWNS2))
 		unshare_flags |= CLONE_FS;
 
 	err = check_unshare_flags(unshare_flags);
diff --git a/kernel/nsproxy.c b/kernel/nsproxy.c
index ef42d0a..a29e836 100644
--- a/kernel/nsproxy.c
+++ b/kernel/nsproxy.c
@@ -180,7 +180,7 @@ int unshare_nsproxy_namespaces(unsigned long unshare_flags,
 	int err = 0;
 
 	if (!(unshare_flags & (CLONE_NEWNS | CLONE_NEWUTS | CLONE_NEWIPC |
-			       CLONE_NEWNET | CLONE_NEWPID)))
+			       CLONE_NEWNET | CLONE_NEWPID | UNSHARE_FLAGS)))
 		return 0;
 
 	user_ns = new_cred ? new_cred->user_ns : current_user_ns();
-- 
1.9.3
