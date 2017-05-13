From: Cyrill Gorcunov <gorcunov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH linux-next] kcmp: fs/epoll -- Wrap kcmp code with
 CONFIG_CHECKPOINT_RESTORE
Date: Sat, 13 May 2017 11:34:56 +0300
Message-ID: <20170513083456.GG1881@uranus.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, akpm-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, avagin-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org, xemul-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org, mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, jbaron-JqFfY2XvxFXQT0dZR+AlfA@public.gmane.org, luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org
List-Id: linux-api@vger.kernel.org

kcmp syscall is build iif CONFIG_CHECKPOINT_RESTORE is selected,
so wrap appropriate helpers in epoll code with the config to
build it conditionally.

Signed-off-by: Cyrill Gorcunov <gorcunov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Reported-by: Andrew Morton <akpm-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
CC: Andrey Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
CC: Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
CC: Pavel Emelyanov <xemul-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
CC: Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
CC: Jason Baron <jbaron-JqFfY2XvxFXQT0dZR+AlfA@public.gmane.org>
CC: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
---
 fs/eventpoll.c            |    2 ++
 include/linux/eventpoll.h |    2 ++
 2 files changed, 4 insertions(+)

Index: linux-ml.git/fs/eventpoll.c
===================================================================
--- linux-ml.git.orig/fs/eventpoll.c
+++ linux-ml.git/fs/eventpoll.c
@@ -1077,6 +1077,7 @@ static struct epitem *ep_find(struct eve
 	return epir;
 }
 
+#ifdef CONFIG_CHECKPOINT_RESTORE
 static struct epitem *ep_find_tfd(struct eventpoll *ep, int tfd, unsigned long toff)
 {
 	struct rb_node *rbp;
@@ -1118,6 +1119,7 @@ struct file *get_epoll_tfile_raw_ptr(str
 
 	return file_raw;
 }
+#endif /* CONFIG_CHECKPOINT_RESTORE */
 
 /*
  * This is the callback that is passed to the wait queue wakeup
Index: linux-ml.git/include/linux/eventpoll.h
===================================================================
--- linux-ml.git.orig/include/linux/eventpoll.h
+++ linux-ml.git/include/linux/eventpoll.h
@@ -23,7 +23,9 @@ struct file;
 
 #ifdef CONFIG_EPOLL
 
+#ifdef CONFIG_CHECKPOINT_RESTORE
 struct file *get_epoll_tfile_raw_ptr(struct file *file, int tfd, unsigned long toff);
+#endif
 
 /* Used to initialize the epoll bits inside the "struct file" */
 static inline void eventpoll_init_file(struct file *file)
