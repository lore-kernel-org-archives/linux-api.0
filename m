From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 6/6] blk-mq: enable polling support by default
Date: Thu, 24 Dec 2015 15:14:24 +0100
Message-ID: <1450966464-6847-7-git-send-email-hch@lst.de>
References: <1450966464-6847-1-git-send-email-hch@lst.de>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1450966464-6847-1-git-send-email-hch@lst.de>
Sender: linux-fsdevel-owner@vger.kernel.org
To: viro@zeniv.linux.org.uk, axboe@fb.com
Cc: milosz@adfin.com, linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Now that applications need to explicitly ask for polling we can enable it
by default in blk-mq drivers.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 include/linux/blkdev.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index e711f29..1b73222 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -496,7 +496,8 @@ struct request_queue {
 
 #define QUEUE_FLAG_MQ_DEFAULT	((1 << QUEUE_FLAG_IO_STAT) |		\
 				 (1 << QUEUE_FLAG_STACKABLE)	|	\
-				 (1 << QUEUE_FLAG_SAME_COMP))
+				 (1 << QUEUE_FLAG_SAME_COMP)	|	\
+				 (1 << QUEUE_FLAG_POLL))
 
 static inline void queue_lockdep_assert_held(struct request_queue *q)
 {
-- 
1.9.1

