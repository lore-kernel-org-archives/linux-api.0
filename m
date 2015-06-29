From: "Michael S. Tsirkin" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] virtio_net: document VIRTIO_NET_CTRL_GUEST_OFFLOADS
Date: Mon, 29 Jun 2015 11:19:47 +0200
Message-ID: <1435569574-28792-1-git-send-email-mst@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Yan Vugenfirer <yan-8cRecHGSwSzQT0dZR+AlfA@public.gmane.org>, virtualization-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Document VIRTIO_NET_CTRL_GUEST_OFFLOADS and the
relevant feature bits.

Will allow ethtool control of the offloads down the road.

Reported-by: Yan Vugenfirer <yan-8cRecHGSwSzQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Michael S. Tsirkin <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 include/uapi/linux/virtio_net.h | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/include/uapi/linux/virtio_net.h b/include/uapi/linux/virtio_net.h
index 7bbee79..ec32293 100644
--- a/include/uapi/linux/virtio_net.h
+++ b/include/uapi/linux/virtio_net.h
@@ -34,6 +34,7 @@
 /* The feature bitmap for virtio net */
 #define VIRTIO_NET_F_CSUM	0	/* Host handles pkts w/ partial csum */
 #define VIRTIO_NET_F_GUEST_CSUM	1	/* Guest handles pkts w/ partial csum */
+#define VIRTIO_NET_F_CTRL_GUEST_OFFLOADS 2 /* Dynamic offload configuration. */
 #define VIRTIO_NET_F_MAC	5	/* Host has given MAC address. */
 #define VIRTIO_NET_F_GUEST_TSO4	7	/* Guest can handle TSOv4 in. */
 #define VIRTIO_NET_F_GUEST_TSO6	8	/* Guest can handle TSOv6 in. */
@@ -226,4 +227,19 @@ struct virtio_net_ctrl_mq {
  #define VIRTIO_NET_CTRL_MQ_VQ_PAIRS_MIN        1
  #define VIRTIO_NET_CTRL_MQ_VQ_PAIRS_MAX        0x8000
 
+/*
+ * Control network offloads
+ *
+ * Reconfigures the network offloads that Guest can handle.
+ *
+ * Available with the VIRTIO_NET_F_CTRL_GUEST_OFFLOADS feature bit.
+ *
+ * Command data format matches the feature bit mask exactly.
+ *
+ * See VIRTIO_NET_F_GUEST_* for the list of offloads
+ * that can be enabled/disabled.
+ */
+#define VIRTIO_NET_CTRL_GUEST_OFFLOADS   5
+#define VIRTIO_NET_CTRL_GUEST_OFFLOADS_SET        0
+
 #endif /* _LINUX_VIRTIO_NET_H */
-- 
MST
