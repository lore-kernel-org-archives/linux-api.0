From: Cyrill Gorcunov <gorcunov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Subject: [patch 2/3] kcmp: Add KCMP_EPOLL_TFD mode to compare epoll target files
Date: Fri, 10 Mar 2017 11:16:57 +0300
Message-ID: <20170310082146.103151106@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline; filename=kcmp-epoll-3
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, akpm-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, avagin-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org, xemul-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org, mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, kir-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, gorcunov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, Andrey Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Jason Baron <jbaron-JqFfY2XvxFXQT0dZR+AlfA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

With current epoll architecture target files are addressed
with file_struct and file descriptor number, where the last
is not unique. Moreover files can be transferred from another
process via unix socket, added into queue and closed then
so we won't find this descriptor in the task fdinfo list.

Thus to checkpoint and restore such processes CRIU needs to
find out where exactly the target file is present to add it into
epoll queue. For this sake one can use kcmp call where
some particular target file from the queue is compared with
arbitrary file passed as an argument.

Because epoll target files can have same file descriptor
number but different file_struct a caller should explicitly
specify the offset within.

To test if some particular file is matching entry inside
epoll one have to

 - fill kcmp_epoll_slot structure with epoll file descriptor,
   target file number and target file offset (in case if only
   one target is present then it should be 0)

 - call kcmp as kcmp(pid1, pid2, KCMP_EPOLL_TFD, fd, &kcmp_epoll_slot)
    - the kernel fetch file pointer matching file descriptor @fd of pid1
    - lookups for file struct in epoll queue of pid2 and returns traditional
      0,1,2 result for sorting purpose

v2:
 - Use KCMP_FILES salt for files comparision (for convenience sake,
   since the pointers are file structs so user can lookup over previously
   collected files tree)
 - Make kcmp_epoll_target as a separate helper instead of opencoding
   it with #ifdef

v3:
 - Use less if()s in kcmp_epoll_target for readability sake (by avagin@)
 - Use u32 for kcmp_epoll_slot::toff instead of u64, which makes the less
   memory pressue

Signed-off-by: Cyrill Gorcunov <gorcunov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
CC: Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
CC: Andrew Morton <akpm-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
CC: Andrey Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
CC: Pavel Emelyanov <xemul-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
CC: Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
CC: Kir Kolyshkin <kir-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
CC: Jason Baron <jbaron-JqFfY2XvxFXQT0dZR+AlfA@public.gmane.org>
CC: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
---
 fs/eventpoll.c            |   42 +++++++++++++++++++++++++++++++++++
 include/linux/eventpoll.h |    3 ++
 include/uapi/linux/kcmp.h |   10 ++++++++
 kernel/kcmp.c             |   55 ++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 110 insertions(+)

Index: linux-ml.git/fs/eventpoll.c
===================================================================
--- linux-ml.git.orig/fs/eventpoll.c
+++ linux-ml.git/fs/eventpoll.c
@@ -1000,6 +1000,48 @@ static struct epitem *ep_find(struct eve
 	return epir;
 }
 
+static struct epitem *ep_find_tfd(struct eventpoll *ep, int tfd, unsigned long toff)
+{
+	struct rb_node *rbp;
+	struct epitem *epi;
+
+	for (rbp = rb_first(&ep->rbr); rbp; rbp = rb_next(rbp)) {
+		epi = rb_entry(rbp, struct epitem, rbn);
+		if (epi->ffd.fd == tfd) {
+			if (toff == 0)
+				return epi;
+			else
+				toff--;
+		}
+		cond_resched();
+	}
+
+	return NULL;
+}
+
+struct file *get_epoll_tfile_raw_ptr(struct file *file, int tfd,
+				     unsigned long toff)
+{
+	struct file *file_raw;
+	struct eventpoll *ep;
+	struct epitem *epi;
+
+	if (!is_file_epoll(file))
+		return ERR_PTR(-EINVAL);
+
+	ep = file->private_data;
+
+	mutex_lock(&ep->mtx);
+	epi = ep_find_tfd(ep, tfd, toff);
+	if (epi)
+		file_raw = epi->ffd.file;
+	else
+		file_raw = ERR_PTR(-ENOENT);
+	mutex_unlock(&ep->mtx);
+
+	return file_raw;
+}
+
 /*
  * This is the callback that is passed to the wait queue wakeup
  * mechanism. It is called by the stored file descriptors when they
Index: linux-ml.git/include/linux/eventpoll.h
===================================================================
--- linux-ml.git.orig/include/linux/eventpoll.h
+++ linux-ml.git/include/linux/eventpoll.h
@@ -14,6 +14,7 @@
 #define _LINUX_EVENTPOLL_H
 
 #include <uapi/linux/eventpoll.h>
+#include <uapi/linux/kcmp.h>
 
 
 /* Forward declarations to avoid compiler errors */
@@ -22,6 +23,8 @@ struct file;
 
 #ifdef CONFIG_EPOLL
 
+struct file *get_epoll_tfile_raw_ptr(struct file *file, int tfd, unsigned long toff);
+
 /* Used to initialize the epoll bits inside the "struct file" */
 static inline void eventpoll_init_file(struct file *file)
 {
Index: linux-ml.git/include/uapi/linux/kcmp.h
===================================================================
--- linux-ml.git.orig/include/uapi/linux/kcmp.h
+++ linux-ml.git/include/uapi/linux/kcmp.h
@@ -1,6 +1,8 @@
 #ifndef _UAPI_LINUX_KCMP_H
 #define _UAPI_LINUX_KCMP_H
 
+#include <linux/types.h>
+
 /* Comparison type */
 enum kcmp_type {
 	KCMP_FILE,
@@ -10,8 +12,16 @@ enum kcmp_type {
 	KCMP_SIGHAND,
 	KCMP_IO,
 	KCMP_SYSVSEM,
+	KCMP_EPOLL_TFD,
 
 	KCMP_TYPES,
 };
 
+/* Slot for KCMP_EPOLL_TFD */
+struct kcmp_epoll_slot {
+	__u32 efd;		/* epoll file descriptor */
+	__u32 tfd;		/* target file number */
+	__u32 toff;		/* target offset within same numbered sequence */
+};
+
 #endif /* _UAPI_LINUX_KCMP_H */
Index: linux-ml.git/kernel/kcmp.c
===================================================================
--- linux-ml.git.orig/kernel/kcmp.c
+++ linux-ml.git/kernel/kcmp.c
@@ -11,6 +11,10 @@
 #include <linux/bug.h>
 #include <linux/err.h>
 #include <linux/kcmp.h>
+#include <linux/capability.h>
+#include <linux/list.h>
+#include <linux/eventpoll.h>
+#include <linux/file.h>
 
 #include <asm/unistd.h>
 
@@ -94,6 +98,54 @@ static int kcmp_lock(struct mutex *m1, s
 	return err;
 }
 
+#ifdef CONFIG_EPOLL
+static int kcmp_epoll_target(struct task_struct *task1,
+			     struct task_struct *task2,
+			     unsigned long idx1,
+			     struct kcmp_epoll_slot __user *uslot)
+{
+	struct file *filp, *filp_epoll, *filp_tgt;
+	struct kcmp_epoll_slot slot;
+	struct files_struct *files;
+
+	if (copy_from_user(&slot, uslot, sizeof(slot)))
+		return -EFAULT;
+
+	filp = get_file_raw_ptr(task1, idx1);
+	if (!filp)
+		return -EBADF;
+
+	files = get_files_struct(task2);
+	if (!files)
+		return -EBADF;
+
+	spin_lock(&files->file_lock);
+	filp_epoll = fcheck_files(files, slot.efd);
+	if (filp_epoll)
+		get_file(filp_epoll);
+	else
+		filp_tgt = ERR_PTR(-EBADF);
+	spin_unlock(&files->file_lock);
+	put_files_struct(files);
+
+	if (filp_epoll) {
+		filp_tgt = get_epoll_tfile_raw_ptr(filp_epoll, slot.tfd, slot.toff);
+		fput(filp_epoll);
+	}
+
+	return IS_ERR(filp_tgt) ? PTR_ERR(filp_tgt) :
+		kcmp_ptr(filp, filp_tgt, KCMP_FILES);
+}
+#else
+static int kcmp_epoll_target(struct task_struct *task1,
+			     struct task_struct *task2,
+			     unsigned long idx1,
+			     struct kcmp_epoll_slot __user *uslot)
+{
+	return -EOPNOTSUPP;
+}
+#endif
+
 SYSCALL_DEFINE5(kcmp, pid_t, pid1, pid_t, pid2, int, type,
 		unsigned long, idx1, unsigned long, idx2)
 {
@@ -165,6 +217,9 @@ SYSCALL_DEFINE5(kcmp, pid_t, pid1, pid_t
 		ret = -EOPNOTSUPP;
 #endif
 		break;
+	case KCMP_EPOLL_TFD:
+		ret = kcmp_epoll_target(task1, task2, idx1, (void *)idx2);
+		break;
 	default:
 		ret = -EINVAL;
 		break;
