From: Marcus Gelderie <redmnic@gmail.com>
Subject: [PATCH v3] ipc: Modify message queue accounting to not take kernel
 data structures into account
Date: Mon, 6 Jul 2015 17:49:28 +0200
Message-ID: <20150706154928.GA19828@ramsey.localdomain>
References: <20150622222546.GA32432@ramsey.localdomain>
 <1435211229.11852.23.camel@stgolabs.net>
 <CAKgNAkieR5zdpKm=P2dcTDJ_3X4HMRoeOQ2D8yghYVKOjDsYAg@mail.gmail.com>
 <1435256484.11852.30.camel@stgolabs.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1435256484.11852.30.camel@stgolabs.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Davidlohr Bueso <dave@stgolabs.net>
Cc: mtk.manpages@gmail.com, Doug Ledford <dledford@redhat.com>, redmnic@gmail.com, lkml <linux-kernel@vger.kernel.org>, David Howells <dhowells@redhat.com>, Alexander Viro <viro@zeniv.linux.org.uk>, John Duffy <jb_duffy@btinternet.com>, Arto Bendiken <arto@bendiken.net>, Linux API <linux-api@vger.kernel.org>, akpm@linux-foundation.org
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
https://lkml.org/lkml/2014/10/1/115). Commenting on a th lkml, Michael
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

This patch removes the accounting of kernel data structures in the
queue. Reporting the size of these data-structures in the QSIZE field
was a breaking change (see Michael's comment above). Without the QSIZE
field reporting the total size of user-data in the queue, there is no
way to deduce this number.

It should be noted that the resource limit RLIMIT_MSGQUEUE is counted
against the worst-case size of the queue (in both the old and the new
implementation). Therefore, the kernel overhead accounting in QSIZE is
not necessary to help the user understand the limitations RLIMIT imposes
on the processes.

Signed-off-by: Marcus Gelderie <redmnic@gmail.com>

v3 Changes: Revert QSIZE to old meaning and remove QKERSIZE field, because the rlimit accounting does not take runtime kernel overhead into account (it is a worst case measure).

---
 ipc/mqueue.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/ipc/mqueue.c b/ipc/mqueue.c
index 3aaea7f..c3fc5c2 100644
--- a/ipc/mqueue.c
+++ b/ipc/mqueue.c
@@ -143,7 +143,6 @@ static int msg_insert(struct msg_msg *msg, struct mqueue_inode_info *info)
 		if (!leaf)
 			return -ENOMEM;
 		INIT_LIST_HEAD(&leaf->msg_list);
-		info->qsize += sizeof(*leaf);
 	}
 	leaf->priority = msg->m_type;
 	rb_link_node(&leaf->rb_node, parent, p);
@@ -188,7 +187,6 @@ try_again:
 			     "lazy leaf delete!\n");
 		rb_erase(&leaf->rb_node, &info->msg_tree);
 		if (info->node_cache) {
-			info->qsize -= sizeof(*leaf);
 			kfree(leaf);
 		} else {
 			info->node_cache = leaf;
@@ -201,7 +199,6 @@ try_again:
 		if (list_empty(&leaf->msg_list)) {
 			rb_erase(&leaf->rb_node, &info->msg_tree);
 			if (info->node_cache) {
-				info->qsize -= sizeof(*leaf);
 				kfree(leaf);
 			} else {
 				info->node_cache = leaf;
@@ -1026,7 +1023,6 @@ SYSCALL_DEFINE5(mq_timedsend, mqd_t, mqdes, const char __user *, u_msg_ptr,
 		/* Save our speculative allocation into the cache */
 		INIT_LIST_HEAD(&new_leaf->msg_list);
 		info->node_cache = new_leaf;
-		info->qsize += sizeof(*new_leaf);
 		new_leaf = NULL;
 	} else {
 		kfree(new_leaf);
@@ -1133,7 +1129,6 @@ SYSCALL_DEFINE5(mq_timedreceive, mqd_t, mqdes, char __user *, u_msg_ptr,
 		/* Save our speculative allocation into the cache */
 		INIT_LIST_HEAD(&new_leaf->msg_list);
 		info->node_cache = new_leaf;
-		info->qsize += sizeof(*new_leaf);
 	} else {
 		kfree(new_leaf);
 	}
-- 
2.4.5
