From: Gleb Fotengauer-Malinovskiy <glebfm-u2l5PoMzF/Vg9hUCZPvPmw@public.gmane.org>
Subject: [PATCH] uapi: use __u8 from linux/types.h
Date: Wed, 13 Jan 2016 19:10:15 +0300
Message-ID: <20160113160958.GA29108@glebfm.cloud.tilaa.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Airlie <airlied-cv59FeDIM0c@public.gmane.org>, Gerd Hoffmann <kraxel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Michael S. Tsirkin" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, virtualization-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Kernel headers should use linux/types.h based definitions.

Signed-off-by: Gleb Fotengauer-Malinovskiy <glebfm-u2l5PoMzF/Vg9hUCZPvPmw@public.gmane.org>
---
 include/uapi/linux/virtio_gpu.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/uapi/linux/virtio_gpu.h b/include/uapi/linux/virtio_gpu.h
index 7a63faa..4b04ead 100644
--- a/include/uapi/linux/virtio_gpu.h
+++ b/include/uapi/linux/virtio_gpu.h
@@ -287,7 +287,7 @@ struct virtio_gpu_get_capset {
 /* VIRTIO_GPU_RESP_OK_CAPSET */
 struct virtio_gpu_resp_capset {
 	struct virtio_gpu_ctrl_hdr hdr;
-	uint8_t capset_data[];
+	__u8 capset_data[];
 };
 
 #define VIRTIO_GPU_EVENT_DISPLAY (1 << 0)
-- 
glebfm
