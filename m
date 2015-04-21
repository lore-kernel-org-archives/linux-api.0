From: "kwan.huen" <kwan.huen-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH 2/2] added two nvme commands for open/close streams and garbage
 collection
Date: Mon, 20 Apr 2015 18:47:43 -0700
Message-ID: <1429580863-3451-3-git-send-email-kwan.huen@samsung.com>
References: <1429580863-3451-1-git-send-email-kwan.huen@samsung.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-reply-to: <1429580863-3451-1-git-send-email-kwan.huen-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matthew Wilcox <matthew.r.wilcox-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Keith Busch <keith.busch-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jens Axboe <axboe-b10kYP2dOMg@public.gmane.org>, kwan.huen-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, Dimitri John Ledkov <dimitri.ledkov-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Cc: linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

---
 include/uapi/linux/nvme.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/uapi/linux/nvme.h b/include/uapi/linux/nvme.h
index aef9a81..5025610 100644
--- a/include/uapi/linux/nvme.h
+++ b/include/uapi/linux/nvme.h
@@ -229,6 +229,8 @@ enum nvme_opcode {
 	nvme_cmd_resv_report	= 0x0e,
 	nvme_cmd_resv_acquire	= 0x11,
 	nvme_cmd_resv_release	= 0x15,
+	nvme_cmd_stream_ctrl	= 0x18,
+	nvme_cmd_gc_ctrl	= 0x1c,
 };
 
 struct nvme_common_command {
-- 
1.9.1
