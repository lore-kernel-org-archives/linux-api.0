From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 5/7] direct-io: only use block polling if explicitly requested
Date: Mon, 22 Feb 2016 18:07:54 +0100
Message-ID: <1456160876-14560-6-git-send-email-hch@lst.de>
References: <1456160876-14560-1-git-send-email-hch@lst.de>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1456160876-14560-1-git-send-email-hch@lst.de>
Sender: linux-fsdevel-owner@vger.kernel.org
To: viro@zeniv.linux.org.uk, axboe@fb.com
Cc: milosz@adfin.com, linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/direct-io.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/direct-io.c b/fs/direct-io.c
index d6a9012..0a8d937 100644
--- a/fs/direct-io.c
+++ b/fs/direct-io.c
@@ -445,7 +445,8 @@ static struct bio *dio_await_one(struct dio *dio)
 		__set_current_state(TASK_UNINTERRUPTIBLE);
 		dio->waiter = current;
 		spin_unlock_irqrestore(&dio->bio_lock, flags);
-		if (!blk_poll(bdev_get_queue(dio->bio_bdev), dio->bio_cookie))
+		if (!(dio->iocb->ki_flags & IOCB_HIPRI) ||
+		    !blk_poll(bdev_get_queue(dio->bio_bdev), dio->bio_cookie))
 			io_schedule();
 		/* wake up sets us TASK_RUNNING */
 		spin_lock_irqsave(&dio->bio_lock, flags);
-- 
2.1.4

