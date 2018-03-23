From: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Subject: [REVIEW][PATCH 06/11] msg: Move struct msg_queue into ipc/msg.c
Date: Fri, 23 Mar 2018 14:16:09 -0500
Message-ID: <20180323191614.32489-6-ebiederm@xmission.com>
References: <87vadmobdw.fsf_-_@xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <87vadmobdw.fsf_-_-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/containers/>
List-Post: <mailto:containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
Cc: esyr-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jannh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, prakash.sangappa-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, Nagarathnam Muthusamy <nagarathnam.muthusamy-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Pavel Emelyanov <xemul-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

All of the users are now in ipc/msg.c so make the definition local to
that file to make code maintenance easier.  AKA to prevent rebuilding
the entire kernel when struct msg_queue changes.

Signed-off-by: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
---
 include/linux/msg.h | 18 ------------------
 ipc/msg.c           | 17 +++++++++++++++++
 2 files changed, 17 insertions(+), 18 deletions(-)

diff --git a/include/linux/msg.h b/include/linux/msg.h
index 0a7eefeee0d1..9a972a296b95 100644
--- a/include/linux/msg.h
+++ b/include/linux/msg.h
@@ -3,7 +3,6 @@
 #define _LINUX_MSG_H
 
 #include <linux/list.h>
-#include <linux/time64.h>
 #include <uapi/linux/msg.h>
 
 /* one msg_msg structure for each message */
@@ -16,21 +15,4 @@ struct msg_msg {
 	/* the actual message follows immediately */
 };
 
-/* one msq_queue structure for each present queue on the system */
-struct msg_queue {
-	struct kern_ipc_perm q_perm;
-	time64_t q_stime;		/* last msgsnd time */
-	time64_t q_rtime;		/* last msgrcv time */
-	time64_t q_ctime;		/* last change time */
-	unsigned long q_cbytes;		/* current number of bytes on queue */
-	unsigned long q_qnum;		/* number of messages in queue */
-	unsigned long q_qbytes;		/* max number of bytes on queue */
-	pid_t q_lspid;			/* pid of last msgsnd */
-	pid_t q_lrpid;			/* last receive pid */
-
-	struct list_head q_messages;
-	struct list_head q_receivers;
-	struct list_head q_senders;
-} __randomize_layout;
-
 #endif /* _LINUX_MSG_H */
diff --git a/ipc/msg.c b/ipc/msg.c
index cdfab0825fce..af5a963306c4 100644
--- a/ipc/msg.c
+++ b/ipc/msg.c
@@ -43,6 +43,23 @@
 #include <linux/uaccess.h>
 #include "util.h"
 
+/* one msq_queue structure for each present queue on the system */
+struct msg_queue {
+	struct kern_ipc_perm q_perm;
+	time64_t q_stime;		/* last msgsnd time */
+	time64_t q_rtime;		/* last msgrcv time */
+	time64_t q_ctime;		/* last change time */
+	unsigned long q_cbytes;		/* current number of bytes on queue */
+	unsigned long q_qnum;		/* number of messages in queue */
+	unsigned long q_qbytes;		/* max number of bytes on queue */
+	pid_t q_lspid;			/* pid of last msgsnd */
+	pid_t q_lrpid;			/* last receive pid */
+
+	struct list_head q_messages;
+	struct list_head q_receivers;
+	struct list_head q_senders;
+} __randomize_layout;
+
 /* one msg_receiver structure for each sleeping receiver */
 struct msg_receiver {
 	struct list_head	r_list;
-- 
2.14.1
