From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: [PATCH 05/10] direct-io: remove the offset argument to dio_complete
Date: Thu,  7 Apr 2016 08:51:59 -0700
Message-ID: <1460044324-5298-6-git-send-email-hch@lst.de>
References: <1460044324-5298-1-git-send-email-hch@lst.de>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1460044324-5298-1-git-send-email-hch-jcswGhMUV9g@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

It has to be identical to ki_pos of the iocb, so use that instead.

Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
---
 fs/direct-io.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/direct-io.c b/fs/direct-io.c
index 8949d3e..c61314b 100644
--- a/fs/direct-io.c
+++ b/fs/direct-io.c
@@ -224,9 +224,9 @@ static inline struct page *dio_get_page(struct dio *dio,
  * filesystems can use it to hold additional state between get_block calls and
  * dio_complete.
  */
-static ssize_t dio_complete(struct dio *dio, loff_t offset, ssize_t ret,
-		bool is_async)
+static ssize_t dio_complete(struct dio *dio, ssize_t ret, bool is_async)
 {
+	loff_t offset = dio->iocb->ki_pos;
 	ssize_t transferred = 0;
 
 	/*
@@ -285,7 +285,7 @@ static void dio_aio_complete_work(struct work_struct *work)
 {
 	struct dio *dio = container_of(work, struct dio, complete_work);
 
-	dio_complete(dio, dio->iocb->ki_pos, 0, true);
+	dio_complete(dio, 0, true);
 }
 
 static int dio_bio_complete(struct dio *dio, struct bio *bio);
@@ -314,7 +314,7 @@ static void dio_bio_end_aio(struct bio *bio)
 			queue_work(dio->inode->i_sb->s_dio_done_wq,
 				   &dio->complete_work);
 		} else {
-			dio_complete(dio, dio->iocb->ki_pos, 0, true);
+			dio_complete(dio, 0, true);
 		}
 	}
 }
@@ -1319,7 +1319,7 @@ do_blockdev_direct_IO(struct kiocb *iocb, struct inode *inode,
 		dio_await_completion(dio);
 
 	if (drop_refcount(dio) == 0) {
-		retval = dio_complete(dio, offset, retval, false);
+		retval = dio_complete(dio, retval, false);
 	} else
 		BUG_ON(retval != -EIOCBQUEUED);
 
-- 
2.1.4
