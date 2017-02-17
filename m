From: Cyrill Gorcunov <gorcunov@openvz.org>
Subject: [RFC 1/2] fs,eventpoll: Add ability to install target file by its number
Date: Fri, 17 Feb 2017 11:30:11 +0300
Message-ID: <20170217083324.627615532@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline; filename=epoll-install-fd-2
Sender: linux-kernel-owner@vger.kernel.org
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
Cc: viro@zeniv.linux.org.uk, akpm@linuxfoundation.org, avagin@virtuozzo.com, xemul@virtuozzo.com, mtk.manpages@gmail.com, kir@openvz.org, gorcunov@openvz.org, Andrey Vagin <avagin@openvz.org>
List-Id: linux-api@vger.kernel.org

When we checkpoint a process we look into /proc/<pid>/fdinfo/<fd> of eventpoll
file and parse target files list from there. In most situations this is fine
because target file is present in the /proc/<pid>/fd/ list. But in case if file
descriptor was dup'ed or transferred via unix socket and closed after,
it might not be in the list and we can't figure out which file descriptor
to pass into epoll_ctl call.

To resolve this tie lets add EPOLL_CTL_DUP operation which simply takes
target file descriptor number and installs it into a caller's file table,
thus we can use kcmp() syscall and figure out which exactly file to be
added into eventpoll on restore procedure.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
CC: Andrey Vagin <avagin@openvz.org>
CC: Pavel Emelyanov <xemul@virtuozzo.com>
CC: Al Viro <viro@zeniv.linux.org.uk>
CC: Andrew Morton <akpm@linuxfoundation.org>
CC: Michael Kerrisk <mtk.manpages@gmail.com>
CC: Kir Kolyshkin <kir@openvz.org>
---
 fs/eventpoll.c                 |   74 +++++++++++++++++++++++++++++++++++------
 include/uapi/linux/eventpoll.h |    1 
 2 files changed, 65 insertions(+), 10 deletions(-)

Index: linux-ml.git/fs/eventpoll.c
===================================================================
--- linux-ml.git.orig/fs/eventpoll.c
+++ linux-ml.git/fs/eventpoll.c
@@ -361,7 +361,7 @@ static inline struct epitem *ep_item_fro
 /* Tells if the epoll_ctl(2) operation needs an event copy from userspace */
 static inline int ep_op_has_event(int op)
 {
-	return op != EPOLL_CTL_DEL;
+	return op != EPOLL_CTL_DEL && op != EPOLL_CTL_DUP;
 }
 
 /* Initialize the poll safe wake up structure */
@@ -967,6 +967,20 @@ free_uid:
 	return error;
 }
 
+static struct epitem *ep_find_tfd(struct eventpoll *ep, int tfd)
+{
+	struct rb_node *rbp;
+	struct epitem *epi;
+
+	for (rbp = rb_first(&ep->rbr); rbp; rbp = rb_next(rbp)) {
+		epi = rb_entry(rbp, struct epitem, rbn);
+		if (epi->ffd.fd == tfd)
+			return epi;
+	}
+
+	return NULL;
+}
+
 /*
  * Search the file inside the eventpoll tree. The RB tree operations
  * are protected by the "mtx" mutex, and ep_find() must be called with
@@ -979,6 +993,9 @@ static struct epitem *ep_find(struct eve
 	struct epitem *epi, *epir = NULL;
 	struct epoll_filefd ffd;
 
+	if (unlikely(!file))
+		return ep_find_tfd(ep, fd);
+
 	ep_set_ffd(&ffd, file, fd);
 	for (rbp = ep->rbr.rb_node; rbp; ) {
 		epi = rb_entry(rbp, struct epitem, rbn);
@@ -1787,6 +1804,28 @@ static void clear_tfile_check_list(void)
 	INIT_LIST_HEAD(&tfile_check_list);
 }
 
+static int ep_install_tfd(struct eventpoll *ep, struct epitem *epi)
+{
+	struct file *file;
+	int ret = -ENOENT;
+
+	rcu_read_lock();
+	if (get_file_rcu(epi->ffd.file))
+		file = epi->ffd.file;
+	else
+		file = NULL;
+	rcu_read_unlock();
+
+	if (file) {
+		ret = get_unused_fd_flags(0);
+		if (ret >= 0)
+			fd_install(ret, file);
+		else
+			fput(file);
+	}
+	return ret;
+}
+
 /*
  * Open an eventpoll file descriptor.
  */
@@ -1867,15 +1906,24 @@ SYSCALL_DEFINE4(epoll_ctl, int, epfd, in
 	if (!f.file)
 		goto error_return;
 
-	/* Get the "struct file *" for the target file */
-	tf = fdget(fd);
-	if (!tf.file)
-		goto error_fput;
-
-	/* The target file descriptor must support poll */
-	error = -EPERM;
-	if (!tf.file->f_op->poll)
-		goto error_tgt_fput;
+	if (likely(op != EPOLL_CTL_DUP)) {
+		/* Get the "struct file *" for the target file */
+		tf = fdget(fd);
+		if (!tf.file)
+			goto error_fput;
+
+		/* The target file descriptor must support poll */
+		error = -EPERM;
+		if (!tf.file->f_op->poll)
+			goto error_tgt_fput;
+	} else {
+		/*
+		 * A special case where target file
+		 * is to be looked up and installed
+		 * into a caller.
+		 */
+		memset(&tf, 0, sizeof(tf));
+	}
 
 	/* Check if EPOLLWAKEUP is allowed */
 	if (ep_op_has_event(op))
@@ -1972,6 +2020,12 @@ SYSCALL_DEFINE4(epoll_ctl, int, epfd, in
 		else
 			error = -ENOENT;
 		break;
+	case EPOLL_CTL_DUP:
+		if (epi)
+			error = ep_install_tfd(ep, epi);
+		else
+			error = -ENOENT;
+		break;
 	case EPOLL_CTL_MOD:
 		if (epi) {
 			if (!(epi->event.events & EPOLLEXCLUSIVE)) {
Index: linux-ml.git/include/uapi/linux/eventpoll.h
===================================================================
--- linux-ml.git.orig/include/uapi/linux/eventpoll.h
+++ linux-ml.git/include/uapi/linux/eventpoll.h
@@ -25,6 +25,7 @@
 #define EPOLL_CTL_ADD 1
 #define EPOLL_CTL_DEL 2
 #define EPOLL_CTL_MOD 3
+#define EPOLL_CTL_DUP 4
 
 /* Set exclusive wakeup mode for the target file descriptor */
 #define EPOLLEXCLUSIVE (1 << 28)
