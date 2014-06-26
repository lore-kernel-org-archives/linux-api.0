From: Ming Lei <ming.lei@canonical.com>
Subject: [PATCH v2 1/2] include/uapi/linux/virtio_blk.h: introduce feature of VIRTIO_BLK_F_MQ
Date: Thu, 26 Jun 2014 10:08:45 +0800
Message-ID: <1403748526-1923-2-git-send-email-ming.lei@canonical.com>
References: <1403748526-1923-1-git-send-email-ming.lei@canonical.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1403748526-1923-1-git-send-email-ming.lei@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
Cc: Rusty Russell <rusty@rustcorp.com.au>, linux-api@vger.kernel.org, virtualization@lists.linux-foundation.org, "Michael S. Tsirkin" <mst@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, Ming Lei <ming.lei@canonical.com>
List-Id: linux-api@vger.kernel.org

Current virtio-blk spec only supports one virtual queue for transfering
data between VM and host, and inside VM all kinds of operations on
the virtual queue needs to hold one lock, so cause below problems:

	- bad scalability
	- bad throughput

This patch requests to introduce feature of VIRTIO_BLK_F_MQ
so that more than one virtual queues can be used to virtio-blk
device, then above problems can be solved or eased.

Signed-off-by: Ming Lei <ming.lei@canonical.com>
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
