From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: [PATCH 6/7] blk-mq: enable polling support by default
Date: Mon, 22 Feb 2016 18:07:55 +0100
Message-ID: <1456160876-14560-7-git-send-email-hch@lst.de>
References: <1456160876-14560-1-git-send-email-hch@lst.de>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1456160876-14560-1-git-send-email-hch-jcswGhMUV9g@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, axboe-b10kYP2dOMg@public.gmane.org
Cc: milosz-B5zB6C1i6pkAvxtiuMwx3w@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Now that applications need to explicitly ask for polling we can enable it
by default in blk-mq drivers.

Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
---
 include/linux/blkdev.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 4571ef1..458f6ef 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -499,7 +499,8 @@ struct request_queue {
 
 #define QUEUE_FLAG_MQ_DEFAULT	((1 << QUEUE_FLAG_IO_STAT) |		\
 				 (1 << QUEUE_FLAG_STACKABLE)	|	\
-				 (1 << QUEUE_FLAG_SAME_COMP))
+				 (1 << QUEUE_FLAG_SAME_COMP)	|	\
+				 (1 << QUEUE_FLAG_POLL))
 
 static inline void queue_lockdep_assert_held(struct request_queue *q)
 {
-- 
2.1.4
