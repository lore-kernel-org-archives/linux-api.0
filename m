From: "kwan.huen" <kwan.huen-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH 1/2] added stream id write support
Date: Mon, 20 Apr 2015 18:47:42 -0700
Message-ID: <1429580863-3451-2-git-send-email-kwan.huen@samsung.com>
References: <1429580863-3451-1-git-send-email-kwan.huen@samsung.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-reply-to: <1429580863-3451-1-git-send-email-kwan.huen-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matthew Wilcox <matthew.r.wilcox-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Keith Busch <keith.busch-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jens Axboe <axboe-b10kYP2dOMg@public.gmane.org>, kwan.huen-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, Dimitri John Ledkov <dimitri.ledkov-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Cc: linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

---
 drivers/block/nvme-core.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/block/nvme-core.c b/drivers/block/nvme-core.c
index 85b8036..332341a 100644
--- a/drivers/block/nvme-core.c
+++ b/drivers/block/nvme-core.c
@@ -769,6 +769,9 @@ static int nvme_submit_iod(struct nvme_queue *nvmeq, struct nvme_iod *iod,
 	if (req->cmd_flags & REQ_RAHEAD)
 		dsmgmt |= NVME_RW_DSM_FREQ_PREFETCH;
 
+	if (rq_data_dir(req))
+		dsmgmt |= bio_get_streamid(req->bio) << 8;
+
 	cmnd = &nvmeq->sq_cmds[nvmeq->sq_tail];
 	memset(cmnd, 0, sizeof(*cmnd));
 
-- 
1.9.1
