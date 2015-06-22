From: Marcus Gelderie <marcus.gelderie-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v2] ipc: Modify message queue accounting to reflect both
 total user data and auxiliary kernel data
Date: Tue, 23 Jun 2015 00:25:46 +0200
Message-ID: <20150622222546.GA32432@ramsey.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, John Duffy <jb_duffy-FhtRXb7CoQBt1OO0OYaSVA@public.gmane.org>, Arto Bendiken <arto-TQ6thHYR8Svk1uMJSBkQmQ@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Davidlohr Bueso <dave-h16yJtLeMjHk1uMJSBkQmQ@public.gmane.org>, redmnic-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
List-Id: linux-api@vger.kernel.org

A while back, the message queue implementation in the kernel was
improved to use btrees to speed up retrieval of messages (commit
d6629859b36). The patch introducing the improved kernel handling of
message queues (using btrees) has, as a by-product, changed the
meaning of the QSIZE field in the pseudo-file created for the queue.
Before, this field reflected the size of the user-data in the queue.
Since, it also takes kernel data structures into account. For
example, if 13 bytes of user data are in the queue, on my machine the
file reports a size of 61 bytes.

There was some discussion on this topic before (for example
https://lkml.org/lkml/2014/10/1/115). Commenting on the lkml, Michael
Kerrisk gave the following background (https://lkml.org/lkml/2015/6/16/74):

    The pseudofiles in the mqueue filesystem (usually mounted at
    /dev/mqueue) expose fields with metadata describing a message
    queue. One of these fields, QSIZE, as originally implemented,
    showed the total number of bytes of user data in all messages in
    the message queue, and this feature was documented from the
    beginning in the mq_overview(7) page. In 3.5, some other (useful)
    work happened to break the user-space API in a couple of places,
    including the value exposed via QSIZE, which now includes a measure
    of kernel overhead bytes for the queue, a figure that renders QSIZE
    useless for its original purpose, since there's no way to deduce
    the number of overhead bytes consumed by the implementation.
    (The other user-space breakage was subsequently fixed.)

Reporting the size of the message queue in kernel has its merits, but
doing so in the QSIZE field of the pseudo file corresponding to the
queue is a breaking change, as mentioned above. This patch therefore
returns the QSIZE  field to its original meaning. At the same time,
it introduces a new field QKERSIZE that reflects the size of the queue
in kernel (user data + kernel data).

It should be noted that the resource limit RLIMIT_MSGQUEUE is counted
against the worst-case size of the queue (in both the old and the new
implementation) and is therefore not affected by this change, nor by
the previous one changing the way of accounting.

Signed-off-by: Marcus Gelderie <redmnic-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 ipc/mqueue.c | 20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/ipc/mqueue.c b/ipc/mqueue.c
index 3aaea7f..7d4c464 100644
--- a/ipc/mqueue.c
+++ b/ipc/mqueue.c
@@ -41,7 +41,7 @@
 
 #define MQUEUE_MAGIC	0x19800202
 #define DIRENT_SIZE	20
-#define FILENT_SIZE	80
+#define FILENT_SIZE	90
 
 #define SEND		0
 #define RECV		1
@@ -82,8 +82,12 @@ struct mqueue_inode_info {
 	/* for tasks waiting for free space and messages, respectively */
 	struct ext_wait_queue e_wait_q[2];
 
-	unsigned long qsize; /* size of queue in memory (sum of all msgs) */
-};
+	/* size of queue in memory (sum of all msgs plus kernel
+	 * data structures) */
+	unsigned long qsize;
+
+	/* size of user data in the queue (sum of all msgs) */
+	unsigned long q_usersize; };
 
 static const struct inode_operations mqueue_dir_inode_operations;
 static const struct file_operations mqueue_file_operations;
@@ -151,6 +155,7 @@ static int msg_insert(struct msg_msg *msg, struct mqueue_inode_info *info)
 insert_msg:
 	info->attr.mq_curmsgs++;
 	info->qsize += msg->m_ts;
+	info->q_usersize += msg->m_ts;
 	list_add_tail(&msg->m_list, &leaf->msg_list);
 	return 0;
 }
@@ -210,6 +215,7 @@ try_again:
 	}
 	info->attr.mq_curmsgs--;
 	info->qsize -= msg->m_ts;
+	info->q_usersize -= msg->m_ts;
 	return msg;
 }
 
@@ -246,6 +252,7 @@ static struct inode *mqueue_get_inode(struct super_block *sb,
 		info->notify_owner = NULL;
 		info->notify_user_ns = NULL;
 		info->qsize = 0;
+		info->q_usersize = 0;
 		info->user = NULL;	/* set when all is ok */
 		info->msg_tree = RB_ROOT;
 		info->node_cache = NULL;
@@ -491,13 +498,14 @@ static ssize_t mqueue_read_file(struct file *filp, char __user *u_data,
 
 	spin_lock(&info->lock);
 	snprintf(buffer, sizeof(buffer),
-			"QSIZE:%-10lu NOTIFY:%-5d SIGNO:%-5d NOTIFY_PID:%-6d\n",
-			info->qsize,
+			"QSIZE:%-10lu NOTIFY:%-5d SIGNO:%-5d NOTIFY_PID:%-6d QKERSIZE:%-10lu\n",
+			info->q_usersize,
 			info->notify_owner ? info->notify.sigev_notify : 0,
 			(info->notify_owner &&
 			 info->notify.sigev_notify == SIGEV_SIGNAL) ?
 				info->notify.sigev_signo : 0,
-			pid_vnr(info->notify_owner));
+			pid_vnr(info->notify_owner),
+			info->qsize);
 	spin_unlock(&info->lock);
 	buffer[sizeof(buffer)-1] = '\0';
 
-- 
2.4.4
