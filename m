From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 06/36] aio: delete iocbs from the active_reqs list in kiocb_cancel
Date: Mon,  5 Mar 2018 13:27:13 -0800
Message-ID: <20180305212743.16664-7-hch@lst.de>
References: <20180305212743.16664-1-hch@lst.de>
Return-path: <owner-linux-aio@kvack.org>
In-Reply-To: <20180305212743.16664-1-hch@lst.de>
Sender: owner-linux-aio@kvack.org
To: viro@zeniv.linux.org.uk
Cc: Avi Kivity <avi@scylladb.com>, linux-aio@kvack.org, linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

One we cancel an iocb there is no reason to keep it on the active_reqs
list, given that the list is only used to look for cancelation candidates.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: Jeff Moyer <jmoyer@redhat.com>
---
 fs/aio.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/aio.c b/fs/aio.c
index 2d40cf5dd4ec..0b6394b4e528 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -561,6 +561,8 @@ static int kiocb_cancel(struct aio_kiocb *kiocb)
 {
 	kiocb_cancel_fn *cancel = kiocb->ki_cancel;
 
+	list_del_init(&kiocb->ki_list);
+
 	if (!cancel)
 		return -EINVAL;
 	kiocb->ki_cancel = NULL;
@@ -607,8 +609,6 @@ static void free_ioctx_users(struct percpu_ref *ref)
 	while (!list_empty(&ctx->active_reqs)) {
 		req = list_first_entry(&ctx->active_reqs,
 				       struct aio_kiocb, ki_list);
-
-		list_del_init(&req->ki_list);
 		kiocb_cancel(req);
 	}
 
-- 
2.14.2

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
