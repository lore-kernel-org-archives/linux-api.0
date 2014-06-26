From: Ming Lei <ming.lei-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Subject: [PATCH v3 1/2] include/uapi/linux/virtio_blk.h: introduce feature of VIRTIO_BLK_F_MQ
Date: Thu, 26 Jun 2014 17:41:47 +0800
Message-ID: <1403775708-22244-2-git-send-email-ming.lei@canonical.com>
References: <1403775708-22244-1-git-send-email-ming.lei@canonical.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1403775708-22244-1-git-send-email-ming.lei-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Rusty Russell <rusty-8n+1lVoiYb80n/F98K4Iww@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, virtualization-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, "Michael S. Tsirkin" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Stefan Hajnoczi <stefanha-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Paolo Bonzini <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ming Lei <ming.lei-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Current virtio-blk spec only supports one virtual queue for transfering
data between VM and host, and inside VM all kinds of operations on
the virtual queue needs to hold one lock, so cause below problems:

	- bad scalability
	- bad throughput

This patch requests to introduce feature of VIRTIO_BLK_F_MQ
so that more than one virtual queues can be used to virtio-blk
device, then above problems can be solved or eased.

Signed-off-by: Ming Lei <ming.lei-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
---
 include/uapi/linux/virtio_blk.h |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/uapi/linux/virtio_blk.h b/include/uapi/linux/virtio_blk.h
index 6d8e61c..9ad67b2 100644
--- a/include/uapi/linux/virtio_blk.h
+++ b/include/uapi/linux/virtio_blk.h
@@ -40,6 +40,7 @@
 #define VIRTIO_BLK_F_WCE	9	/* Writeback mode enabled after reset */
 #define VIRTIO_BLK_F_TOPOLOGY	10	/* Topology information is available */
 #define VIRTIO_BLK_F_CONFIG_WCE	11	/* Writeback mode available in config */
+#define VIRTIO_BLK_F_MQ		12	/* support more than one vq */
 
 #ifndef __KERNEL__
 /* Old (deprecated) name for VIRTIO_BLK_F_WCE. */
@@ -77,6 +78,10 @@ struct virtio_blk_config {
 
 	/* writeback mode (if VIRTIO_BLK_F_CONFIG_WCE) */
 	__u8 wce;
+	__u8 unused;
+
+	/* number of vqs, only available when VIRTIO_BLK_F_MQ is set */
+	__u16 num_queues;
 } __attribute__((packed));
 
 /*
-- 
1.7.9.5
