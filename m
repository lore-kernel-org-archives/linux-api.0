From: Joe Perches <joe@perches.com>
Subject: [PATCH] media: uapi: vsp1: Use __u32 instead of u32
Date: Sat, 16 May 2015 11:11:40 -0700
Message-ID: <1431799900.15709.84.camel@perches.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Laurent Pinchart <Laurent.pinchart@ideasonboard.com>
Cc: linux-api <linux-api@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

Don't use the kernel types in uapi headers.

Signed-off-by: Joe Perches <joe@perches.com>
---
 include/uapi/linux/vsp1.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/uapi/linux/vsp1.h b/include/uapi/linux/vsp1.h
index e18858f..9a82369 100644
--- a/include/uapi/linux/vsp1.h
+++ b/include/uapi/linux/vsp1.h
@@ -28,7 +28,7 @@
 	_IOWR('V', BASE_VIDIOC_PRIVATE + 1, struct vsp1_lut_config)
 
 struct vsp1_lut_config {
-	u32 lut[256];
+	__u32 lut[256];
 };
 
 #endif	/* __VSP1_USER_H__ */
