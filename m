From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 34/36] eventfd: switch to ->poll_mask
Date: Wed, 17 Jan 2018 20:27:40 +0100
Message-ID: <20180117192742.710-35-hch@lst.de>
References: <20180117192742.710-1-hch@lst.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180117192742.710-1-hch@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: viro@zeniv.linux.org.uk
Cc: Avi Kivity <avi@scylladb.com>, linux-aio@kvack.org, linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/eventfd.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/fs/eventfd.c b/fs/eventfd.c
index 6318a9b57e53..2bbbf13cb816 100644
--- a/fs/eventfd.c
+++ b/fs/eventfd.c
@@ -114,14 +114,20 @@ static int eventfd_release(struct inode *inode, struct file *file)
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
@@ -341,7 +347,8 @@ static const struct file_operations eventfd_fops = {
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
