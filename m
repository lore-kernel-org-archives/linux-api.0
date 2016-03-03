From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 6/6] blk-mq: enable polling support by default
Date: Thu,  3 Mar 2016 16:04:03 +0100
Message-ID: <1457017443-17662-7-git-send-email-hch@lst.de>
References: <1457017443-17662-1-git-send-email-hch@lst.de>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1457017443-17662-1-git-send-email-hch@lst.de>
Sender: linux-fsdevel-owner@vger.kernel.org
To: viro@zeniv.linux.org.uk, axboe@fb.com
Cc: milosz@adfin.com, linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Now that applications need to explicitly ask for polling we can enable it
by default in blk-mq drivers.  Note that this will only have an affect
on driver that supply a poll function, which currently only includes nvme.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Stephen Bates <stephen.bates@pmcs.com>
Tested-by: Stephen Bates <stephen.bates@pmcs.com>
Reviewed-by: Jeff Moyer <jmoyer@redhat.com>
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

