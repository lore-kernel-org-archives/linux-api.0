From: "Michael S. Tsirkin" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH pre-squash 02/14] virtio-pci: define layout for virtio 1.0
Date: Wed, 21 Jan 2015 17:00:10 +0200
Message-ID: <1421852375-22604-3-git-send-email-mst@redhat.com>
References: <1421852375-22604-1-git-send-email-mst@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1421852375-22604-1-git-send-email-mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Rusty Russell <rusty-8n+1lVoiYb80n/F98K4Iww@public.gmane.org>, virtualization-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, Gerd Hoffmann <kraxel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

From: Rusty Russell <rusty-8n+1lVoiYb80n/F98K4Iww@public.gmane.org>

Based on patches by Michael S. Tsirkin <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, but I found it
hard to follow so changed to use structures which are more
self-documenting.

Signed-off-by: Rusty Russell <rusty-8n+1lVoiYb80n/F98K4Iww@public.gmane.org>
Signed-off-by: Michael S. Tsirkin <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Tested-by: Gerd Hoffmann <kraxel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 include/uapi/linux/virtio_pci.h | 62 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 62 insertions(+)

diff --git a/include/uapi/linux/virtio_pci.h b/include/uapi/linux/virtio_pci.h
index 509d630..4e05423 100644
--- a/include/uapi/linux/virtio_pci.h
+++ b/include/uapi/linux/virtio_pci.h
@@ -99,4 +99,66 @@
 /* Vector value used to disable MSI for queue */
 #define VIRTIO_MSI_NO_VECTOR            0xffff
 
+#ifndef VIRTIO_PCI_NO_MODERN
+
+/* IDs for different capabilities.  Must all exist. */
+
+/* Common configuration */
+#define VIRTIO_PCI_CAP_COMMON_CFG	1
+/* Notifications */
+#define VIRTIO_PCI_CAP_NOTIFY_CFG	2
+/* ISR access */
+#define VIRTIO_PCI_CAP_ISR_CFG		3
+/* Device specific confiuration */
+#define VIRTIO_PCI_CAP_DEVICE_CFG	4
+
+/* This is the PCI capability header: */
+struct virtio_pci_cap {
+	__u8 cap_vndr;		/* Generic PCI field: PCI_CAP_ID_VNDR */
+	__u8 cap_next;		/* Generic PCI field: next ptr. */
+	__u8 cap_len;		/* Generic PCI field: capability length */
+	__u8 type_and_bar;	/* Upper 3 bits: bar.
+				 * Lower 3 is VIRTIO_PCI_CAP_*_CFG. */
+	__le32 offset;		/* Offset within bar. */
+	__le32 length;		/* Length. */
+};
+
+#define VIRTIO_PCI_CAP_BAR_SHIFT	5
+#define VIRTIO_PCI_CAP_BAR_MASK		0x7
+#define VIRTIO_PCI_CAP_TYPE_SHIFT	0
+#define VIRTIO_PCI_CAP_TYPE_MASK	0x7
+
+struct virtio_pci_notify_cap {
+	struct virtio_pci_cap cap;
+	__le32 notify_off_multiplier;	/* Multiplier for queue_notify_off. */
+};
+
+/* Fields in VIRTIO_PCI_CAP_COMMON_CFG: */
+struct virtio_pci_common_cfg {
+	/* About the whole device. */
+	__le32 device_feature_select;	/* read-write */
+	__le32 device_feature;		/* read-only */
+	__le32 guest_feature_select;	/* read-write */
+	__le32 guest_feature;		/* read-write */
+	__le16 msix_config;		/* read-write */
+	__le16 num_queues;		/* read-only */
+	__u8 device_status;		/* read-write */
+	__u8 config_generation;		/* read-only */
+
+	/* About a specific virtqueue. */
+	__le16 queue_select;		/* read-write */
+	__le16 queue_size;		/* read-write, power of 2. */
+	__le16 queue_msix_vector;	/* read-write */
+	__le16 queue_enable;		/* read-write */
+	__le16 queue_notify_off;	/* read-only */
+	__le32 queue_desc_lo;		/* read-write */
+	__le32 queue_desc_hi;		/* read-write */
+	__le32 queue_avail_lo;		/* read-write */
+	__le32 queue_avail_hi;		/* read-write */
+	__le32 queue_used_lo;		/* read-write */
+	__le32 queue_used_hi;		/* read-write */
+};
+
+#endif /* VIRTIO_PCI_NO_MODERN */
+
 #endif
-- 
MST
