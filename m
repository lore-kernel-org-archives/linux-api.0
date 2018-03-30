From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 30/32] eventfd: switch to ->poll_mask
Date: Fri, 30 Mar 2018 17:08:07 +0200
Message-ID: <20180330150809.28094-31-hch@lst.de>
References: <20180330150809.28094-1-hch@lst.de>
Return-path: <owner-linux-aio@kvack.org>
In-Reply-To: <20180330150809.28094-1-hch@lst.de>
Sender: owner-linux-aio@kvack.org
To: viro@zeniv.linux.org.uk
Cc: Avi Kivity <avi@scylladb.com>, linux-aio@kvack.org, linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/eventfd.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/fs/eventfd.c b/fs/eventfd.c
index 012f5bd46dfa..d70b4907f978 100644
--- a/fs/eventfd.c
+++ b/fs/eventfd.c
@@ -101,14 +101,20 @@ static int eventfd_release(struct inode *inode, struct file *file)
 	return 0;
 }
 
-static __poll_t eventfd_poll(struct file *file, poll_table *wait)
+static struct wait_queue_head *
+eventfd_get_poll_head(struct file *file, __poll_t events)
+{
+	struct eventfd_ctx *ctx = file->private_data;
+
+	return &ctx->wqh;
+}
+
+static __poll_t eventfd_poll_mask(struct file *file, __poll_t eventmask)
 {
 	struct eventfd_ctx *ctx = file->private_data;
 	__poll_t events = 0;
 	u64 count;
 
-	poll_wait(file, &ctx->wqh, wait);
-
 	/*
 	 * All writes to ctx->count occur within ctx->wqh.lock.  This read
 	 * can be done outside ctx->wqh.lock because we know that poll_wait
@@ -305,7 +311,8 @@ static const struct file_operations eventfd_fops = {
 	.show_fdinfo	= eventfd_show_fdinfo,
 #endif
 	.release	= eventfd_release,
-	.poll		= eventfd_poll,
+	.get_poll_head	= eventfd_get_poll_head,
+	.poll_mask	= eventfd_poll_mask,
 	.read		= eventfd_read,
 	.write		= eventfd_write,
 	.llseek		= noop_llseek,
-- 
2.14.2

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
