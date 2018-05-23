From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 30/33] pipe: convert to ->poll_mask
Date: Wed, 23 May 2018 21:20:19 +0200
Message-ID: <20180523192022.1703-31-hch@lst.de>
References: <20180523192022.1703-1-hch@lst.de>
Return-path: <owner-linux-aio@kvack.org>
In-Reply-To: <20180523192022.1703-1-hch@lst.de>
Sender: owner-linux-aio@kvack.org
To: viro@zeniv.linux.org.uk
Cc: Avi Kivity <avi@scylladb.com>, linux-aio@kvack.org, linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/pipe.c | 22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

diff --git a/fs/pipe.c b/fs/pipe.c
index 39d6f431da83..bb0840e234f3 100644
--- a/fs/pipe.c
+++ b/fs/pipe.c
@@ -509,19 +509,22 @@ static long pipe_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
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
 		mask = (nrbufs > 0) ? EPOLLIN | EPOLLRDNORM : 0;
 		if (!pipe->writers && filp->f_version != pipe->w_counter)
@@ -1020,7 +1023,8 @@ const struct file_operations pipefifo_fops = {
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
2.17.0

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
