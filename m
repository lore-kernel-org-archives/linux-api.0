From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 33/36] pipe: convert to ->poll_mask
Date: Mon, 22 Jan 2018 21:12:40 +0100
Message-ID: <20180122201243.31610-34-hch@lst.de>
References: <20180122201243.31610-1-hch@lst.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180122201243.31610-1-hch@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: viro@zeniv.linux.org.uk
Cc: Avi Kivity <avi@scylladb.com>, linux-aio@kvack.org, linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/pipe.c | 22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

diff --git a/fs/pipe.c b/fs/pipe.c
index a449ca0ec0c6..33a32d13b83d 100644
--- a/fs/pipe.c
+++ b/fs/pipe.c
@@ -514,19 +514,22 @@ static long pipe_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 	}
 }
 
-/* No kernel lock held - fine */
-static __poll_t
-pipe_poll(struct file *filp, poll_table *wait)
+static struct wait_queue_head *
+pipe_get_poll_head(struct file *filp, __poll_t events)
 {
-	__poll_t mask;
 	struct pipe_inode_info *pipe = filp->private_data;
-	int nrbufs;
 
-	poll_wait(filp, &pipe->wait, wait);
+	return &pipe->wait;
+}
+
+/* No kernel lock held - fine */
+static __poll_t pipe_poll_mask(struct file *filp, __poll_t events)
+{
+	struct pipe_inode_info *pipe = filp->private_data;
+	int nrbufs = pipe->nrbufs;
+	__poll_t mask = 0;
 
 	/* Reading only -- no need for acquiring the semaphore.  */
-	nrbufs = pipe->nrbufs;
-	mask = 0;
 	if (filp->f_mode & FMODE_READ) {
 		mask = (nrbufs > 0) ? POLLIN | POLLRDNORM : 0;
 		if (!pipe->writers && filp->f_version != pipe->w_counter)
@@ -1010,7 +1013,8 @@ const struct file_operations pipefifo_fops = {
 	.llseek		= no_llseek,
 	.read_iter	= pipe_read,
 	.write_iter	= pipe_write,
-	.poll		= pipe_poll,
+	.get_poll_head	= pipe_get_poll_head,
+	.poll_mask	= pipe_poll_mask,
 	.unlocked_ioctl	= pipe_ioctl,
 	.release	= pipe_release,
 	.fasync		= pipe_fasync,
-- 
2.14.2
