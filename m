From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 05/10] direct-io: remove the offset argument to dio_complete
Date: Tue, 29 Mar 2016 19:37:29 +0200
Message-ID: <1459273054-13478-6-git-send-email-hch@lst.de>
References: <1459273054-13478-1-git-send-email-hch@lst.de>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1459273054-13478-1-git-send-email-hch@lst.de>
Sender: linux-fsdevel-owner@vger.kernel.org
To: viro@ZenIV.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

It has to be identical to ki_pos of the iocb, so use that instead.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/direct-io.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/direct-io.c b/fs/direct-io.c
index 8122ff9..53021ef 100644
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

