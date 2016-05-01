From: "Andrew F. Davis" <afd-l0cyMroinI0@public.gmane.org>
Subject: [PATCH 05/13] iio: health/afe440x: Fix scan_index assignment
Date: Sun, 1 May 2016 15:36:55 -0500
Message-ID: <1462135023-14445-6-git-send-email-afd@ti.com>
References: <1462135023-14445-1-git-send-email-afd@ti.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1462135023-14445-1-git-send-email-afd-l0cyMroinI0@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jonathan Cameron <jic23-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Hartmut Knaack <knaack.h-Mmb7MZpHnFY@public.gmane.org>, Lars-Peter Clausen <lars-Qo5EllUWu/uELgA04lAiVw@public.gmane.org>, Peter Meerwald <pmeerw-jW+XmwGofnusTnJN9+BGXg@public.gmane.org>
Cc: linux-iio-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Andrew F. Davis" <afd-l0cyMroinI0@public.gmane.org>
List-Id: linux-api@vger.kernel.org

The LED channels are not scannable and so scan_index should
be negative, fix this here.

Signed-off-by: Andrew F. Davis <afd-l0cyMroinI0@public.gmane.org>
---
 drivers/iio/health/afe440x.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iio/health/afe440x.h b/drivers/iio/health/afe440x.h
index 544bbab..583d071 100644
--- a/drivers/iio/health/afe440x.h
+++ b/drivers/iio/health/afe440x.h
@@ -125,7 +125,7 @@ struct afe440x_reg_info {
 		.type = IIO_CURRENT,				\
 		.channel = _index,				\
 		.address = _index,				\
-		.scan_index = _index,				\
+		.scan_index = -1,				\
 		.extend_name = _name,				\
 		.info_mask_separate = BIT(IIO_CHAN_INFO_RAW) |	\
 			BIT(IIO_CHAN_INFO_SCALE),		\
-- 
2.8.1
