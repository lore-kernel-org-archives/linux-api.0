From: Davidlohr Bueso <dave-h16yJtLeMjHk1uMJSBkQmQ@public.gmane.org>
Subject: [PATCH 2/1] ipc,mqueue: Delete bogus overflow check
Date: Fri, 10 Jul 2015 17:48:11 -0700
Message-ID: <1436575691.27924.53.camel@stgolabs.net>
References: <20150622222546.GA32432@ramsey.localdomain>
	 <1435211229.11852.23.camel@stgolabs.net>
	 <CAKgNAkieR5zdpKm=P2dcTDJ_3X4HMRoeOQ2D8yghYVKOjDsYAg@mail.gmail.com>
	 <1435256484.11852.30.camel@stgolabs.net>
	 <20150706154928.GA19828@ramsey.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150706154928.GA19828-W7fNxlbxG8VSq9BJjBFyUp/QNRX+jHPU@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Marcus Gelderie <redmnic-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, John Duffy <jb_duffy-FhtRXb7CoQBt1OO0OYaSVA@public.gmane.org>, Arto Bendiken <arto-TQ6thHYR8Svk1uMJSBkQmQ@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org
List-Id: linux-api@vger.kernel.org

Mathematically, returning -EOVERFLOW in mq_attr_ok()
cannot occur under this condition:

       mq_treesize = attr->mq_maxmsg * sizeof(struct msg_msg) +
	       min_t(unsigned int, attr->mq_maxmsg, MQ_PRIO_MAX) *
	       sizeof(struct posix_msg_tree_node);
       total_size = attr->mq_maxmsg * attr->mq_msgsize;
       if (total_size + mq_treesize < total_size)
	       return -EOVERFLOW;

Thus remove the check and simplify code around calculating
total queue overhead by introducing a mqueue_sizeof() helper.

Signed-off-by: Davidlohr Bueso <dbueso-l3A5Bk7waGM@public.gmane.org>
---
Passes ipc stresser and ltp tests.

 ipc/mqueue.c | 65 +++++++++++++++++++++++++++---------------------------------
 1 file changed, 29 insertions(+), 36 deletions(-)

diff --git a/ipc/mqueue.c b/ipc/mqueue.c
index 161a180..a5d0c9e 100644
--- a/ipc/mqueue.c
+++ b/ipc/mqueue.c
@@ -209,6 +209,31 @@ try_again:
 	return msg;
 }
 
+/*
+ * We used to allocate a static array of pointers and account
+ * the size of that array as well as one msg_msg struct per
+ * possible message into the queue size. That's no longer
+ * accurate as the queue is now an rbtree and will grow and
+ * shrink depending on usage patterns.  We can, however, still
+ * account one msg_msg struct per message, but the nodes are
+ * allocated depending on priority usage, and most programs
+ * only use one, or a handful, of priorities.  However, since
+ * this is pinned memory, we need to assume worst case, so
+ * that means the min(mq_maxmsg, max_priorities) * struct
+ * posix_msg_tree_node.
+ */
+static inline unsigned long mqueue_sizeof(struct mqueue_inode_info *info)
+{
+	unsigned long mq_treesize, mq_max_msgsize;
+
+	mq_treesize = info->attr.mq_maxmsg * sizeof(struct msg_msg) +
+		min_t(unsigned int, info->attr.mq_maxmsg, MQ_PRIO_MAX) *
+		sizeof(struct posix_msg_tree_node);
+
+	mq_max_msgsize = info->attr.mq_maxmsg * info->attr.mq_msgsize;
+	return mq_treesize + mq_max_msgsize; /* bytes */
+}
+
 static struct inode *mqueue_get_inode(struct super_block *sb,
 		struct ipc_namespace *ipc_ns, umode_t mode,
 		struct mq_attr *attr)
@@ -229,7 +254,7 @@ static struct inode *mqueue_get_inode(struct super_block *sb,
 
 	if (S_ISREG(mode)) {
 		struct mqueue_inode_info *info;
-		unsigned long mq_bytes, mq_treesize;
+		unsigned long mq_bytes;
 
 		inode->i_fop = &mqueue_file_operations;
 		inode->i_size = FILENT_SIZE;
@@ -254,25 +279,8 @@ static struct inode *mqueue_get_inode(struct super_block *sb,
 			info->attr.mq_maxmsg = attr->mq_maxmsg;
 			info->attr.mq_msgsize = attr->mq_msgsize;
 		}
-		/*
-		 * We used to allocate a static array of pointers and account
-		 * the size of that array as well as one msg_msg struct per
-		 * possible message into the queue size. That's no longer
-		 * accurate as the queue is now an rbtree and will grow and
-		 * shrink depending on usage patterns.  We can, however, still
-		 * account one msg_msg struct per message, but the nodes are
-		 * allocated depending on priority usage, and most programs
-		 * only use one, or a handful, of priorities.  However, since
-		 * this is pinned memory, we need to assume worst case, so
-		 * that means the min(mq_maxmsg, max_priorities) * struct
-		 * posix_msg_tree_node.
-		 */
-		mq_treesize = info->attr.mq_maxmsg * sizeof(struct msg_msg) +
-			min_t(unsigned int, info->attr.mq_maxmsg, MQ_PRIO_MAX) *
-			sizeof(struct posix_msg_tree_node);
 
-		mq_bytes = mq_treesize + (info->attr.mq_maxmsg *
-					  info->attr.mq_msgsize);
+		mq_bytes = mqueue_sizeof(info);
 
 		spin_lock(&mq_lock);
 		if (u->mq_bytes + mq_bytes < u->mq_bytes ||
@@ -371,7 +379,7 @@ static void mqueue_evict_inode(struct inode *inode)
 {
 	struct mqueue_inode_info *info;
 	struct user_struct *user;
-	unsigned long mq_bytes, mq_treesize;
+	unsigned long mq_bytes;
 	struct ipc_namespace *ipc_ns;
 	struct msg_msg *msg;
 
@@ -388,13 +396,7 @@ static void mqueue_evict_inode(struct inode *inode)
 	kfree(info->node_cache);
 	spin_unlock(&info->lock);
 
-	/* Total amount of bytes accounted for the mqueue */
-	mq_treesize = info->attr.mq_maxmsg * sizeof(struct msg_msg) +
-		min_t(unsigned int, info->attr.mq_maxmsg, MQ_PRIO_MAX) *
-		sizeof(struct posix_msg_tree_node);
-
-	mq_bytes = mq_treesize + (info->attr.mq_maxmsg *
-				  info->attr.mq_msgsize);
+	mq_bytes = mqueue_sizeof(info);
 
 	user = info->user;
 	if (user) {
@@ -692,9 +694,6 @@ static void remove_notification(struct mqueue_inode_info *info)
 
 static int mq_attr_ok(struct ipc_namespace *ipc_ns, struct mq_attr *attr)
 {
-	int mq_treesize;
-	unsigned long total_size;
-
 	if (attr->mq_maxmsg <= 0 || attr->mq_msgsize <= 0)
 		return -EINVAL;
 	if (capable(CAP_SYS_RESOURCE)) {
@@ -709,12 +708,6 @@ static int mq_attr_ok(struct ipc_namespace *ipc_ns, struct mq_attr *attr)
 	/* check for overflow */
 	if (attr->mq_msgsize > ULONG_MAX/attr->mq_maxmsg)
 		return -EOVERFLOW;
-	mq_treesize = attr->mq_maxmsg * sizeof(struct msg_msg) +
-		min_t(unsigned int, attr->mq_maxmsg, MQ_PRIO_MAX) *
-		sizeof(struct posix_msg_tree_node);
-	total_size = attr->mq_maxmsg * attr->mq_msgsize;
-	if (total_size + mq_treesize < total_size)
-		return -EOVERFLOW;
 	return 0;
 }
 
-- 
2.1.4
