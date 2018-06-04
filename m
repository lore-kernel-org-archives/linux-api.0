From: adam.manzanares@wdc.com
Subject: [PATCH 2/2] fs: aio ioprio use ioprio_check_cap ret val
Date: Mon,  4 Jun 2018 10:59:57 -0700
Message-ID: <20180604175957.2647-2-adam.manzanares@wdc.com>
References: <20180604175957.2647-1-adam.manzanares@wdc.com>
Return-path: <owner-linux-aio@kvack.org>
In-Reply-To: <20180604175957.2647-1-adam.manzanares@wdc.com>
Sender: owner-linux-aio@kvack.org
To: viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org
Cc: axboe@kernel.dk, bcrl@kvack.org, mingo@kernel.org, tglx@linutronix.de, kstewart@linuxfoundation.org, peterz@infradead.org, pombredanne@nexb.com, gregkh@linuxfoundation.org, bigeasy@linutronix.de, rgoldwyn@suse.com, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-aio@kvack.org, linux-api@vger.kernel.org, hch@infradread.org, jmoyer@redhat.com, willy@infradead.org, smfrench@gmail.com, Adam Manzanares <adam.manzanares@wdc.com>
List-Id: linux-api@vger.kernel.org

From: Adam Manzanares <adam.manzanares@wdc.com>

Previously the value was ignored.

Signed-off-by: Adam Manzanares <adam.manzanares@wdc.com>
---
 fs/aio.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/aio.c b/fs/aio.c
index 9527ededa669..134e5b635d64 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -1443,8 +1443,8 @@ static int aio_prep_rw(struct kiocb *req, struct iocb *iocb)
 		 */
 		ret = ioprio_check_cap(iocb->aio_reqprio);
 		if (ret) {
-			pr_debug("aio ioprio check cap error\n");
-			return -EINVAL;
+			pr_debug("aio ioprio check cap error: %d\n", ret);
+			return ret;
 		}
 
 		req->ki_ioprio = iocb->aio_reqprio;
-- 
2.17.0

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
