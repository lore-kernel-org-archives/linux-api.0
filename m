From: adam.manzanares@wdc.com
Subject: [PATCH v7 4/5] fs: blkdev set bio prio from kiocb prio
Date: Tue, 22 May 2018 10:52:20 -0700
Message-ID: <20180522175221.2391-5-adam.manzanares@wdc.com>
References: <20180522175221.2391-1-adam.manzanares@wdc.com>
Return-path: <owner-linux-aio@kvack.org>
In-Reply-To: <20180522175221.2391-1-adam.manzanares@wdc.com>
Sender: owner-linux-aio@kvack.org
To: viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org, axboe@kernel.dk, bcrl@kvack.org
Cc: mingo@kernel.org, tglx@linutronix.de, kstewart@linuxfoundation.org, peterz@infradead.org, pombredanne@nexb.com, gregkh@linuxfoundation.org, bigeasy@linutronix.de, rgoldwyn@suse.com, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-aio@kvack.org, linux-api@vger.kernel.org, hch@infradread.org, jmoyer@redhat.com, Adam Manzanares <adam.manzanares@wdc.com>
List-Id: linux-api@vger.kernel.org

From: Adam Manzanares <adam.manzanares@wdc.com>

Now that kiocb has an ioprio field copy this over to the bio when it is
created from the kiocb.

Signed-off-by: Adam Manzanares <adam.manzanares@wdc.com>
Reviewed-by: Jeff Moyer <jmoyer@redhat.com>
---
 fs/block_dev.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/block_dev.c b/fs/block_dev.c
index 7ec920e27065..11ba99e79d2a 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -216,6 +216,7 @@ __blkdev_direct_IO_simple(struct kiocb *iocb, struct iov_iter *iter,
 	bio.bi_write_hint = iocb->ki_hint;
 	bio.bi_private = current;
 	bio.bi_end_io = blkdev_bio_end_io_simple;
+	bio.bi_ioprio = iocb->ki_ioprio;
 
 	ret = bio_iov_iter_get_pages(&bio, iter);
 	if (unlikely(ret))
@@ -355,6 +356,7 @@ __blkdev_direct_IO(struct kiocb *iocb, struct iov_iter *iter, int nr_pages)
 		bio->bi_write_hint = iocb->ki_hint;
 		bio->bi_private = dio;
 		bio->bi_end_io = blkdev_bio_end_io;
+		bio->bi_ioprio = iocb->ki_ioprio;
 
 		ret = bio_iov_iter_get_pages(bio, iter);
 		if (unlikely(ret)) {
-- 
2.15.1

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
