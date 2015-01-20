From: Fam Zheng <famz@redhat.com>
Subject: [PATCH RFC 4/6] epoll: Extract ep_ctl_do
Date: Tue, 20 Jan 2015 17:57:56 +0800
Message-ID: <1421747878-30744-5-git-send-email-famz@redhat.com>
References: <1421747878-30744-1-git-send-email-famz@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1421747878-30744-1-git-send-email-famz@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, Kees Cook <keescook@chromium.org>, Andy Lutomirski <luto@amacapital.net>, David Herrmann <dh.herrmann@gmail.com>, Alexei Starovoitov <ast@plumgrid.com>, Miklos Szeredi <mszeredi@suse.cz>, David Drysdale <drysdale@google.com>, Oleg Nesterov <oleg@redhat.com>, "David S. Miller" <davem@davemloft.net>, Vivek Goyal <vgoyal@redhat.com>, Mike Frysinger <vapier@gentoo.org>, Theodore Ts'o <tytso@mit.edu>, Heiko Carstens <heiko.carstens@de.ibm.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Rashika Kheria <rashika.kheria@gmail.com>, Hugh Dickins <hughd@google.com>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Fam Zheng <famz@redhat.com>, Peter Zijlstra <peter>
List-Id: linux-api@vger.kernel.org

This is a common part from epoll_ctl implementation which will be shared with
the coming epoll_mod_wait.

Signed-off-by: Fam Zheng <famz@redhat.com>
---
 fs/eventpoll.c | 26 ++++++++++++++++++--------
 1 file changed, 18 insertions(+), 8 deletions(-)

diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index 6da143f..e7a116d 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -1808,22 +1808,15 @@ SYSCALL_DEFINE1(epoll_create, int, size)
  * the eventpoll file that enables the insertion/removal/change of
  * file descriptors inside the interest set.
  */
-SYSCALL_DEFINE4(epoll_ctl, int, epfd, int, op, int, fd,
-		struct epoll_event __user *, event)
+int ep_ctl_do(int epfd, int op, int fd, struct epoll_event epds)
 {
 	int error;
 	int full_check = 0;
 	struct fd f, tf;
 	struct eventpoll *ep;
 	struct epitem *epi;
-	struct epoll_event epds;
 	struct eventpoll *tep = NULL;
 
-	error = -EFAULT;
-	if (ep_op_has_event(op) &&
-	    copy_from_user(&epds, event, sizeof(struct epoll_event)))
-		goto error_return;
-
 	error = -EBADF;
 	f = fdget(epfd);
 	if (!f.file)
@@ -1945,6 +1938,23 @@ error_return:
 	return error;
 }
 
+/*
+ * The following function implements the controller interface for
+ * the eventpoll file that enables the insertion/removal/change of
+ * file descriptors inside the interest set.
+ */
+SYSCALL_DEFINE4(epoll_ctl, int, epfd, int, op, int, fd,
+		struct epoll_event __user *, event)
+{
+	struct epoll_event epds;
+
+	if (ep_op_has_event(op) &&
+	    copy_from_user(&epds, event, sizeof(struct epoll_event)))
+		return -EFAULT;
+
+	return ep_ctl_do(epfd, op, fd, epds);
+}
+
 static inline int epoll_wait_do(int epfd, struct epoll_event __user *events,
 				int maxevents, int clockid, 
 				const ktime_t timeout)
-- 
1.9.3
