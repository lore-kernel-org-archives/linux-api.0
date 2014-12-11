From: "Michael S. Tsirkin" <mst@redhat.com>
Subject: [PATCH RFC 2/5] virtio-pci: define layout for virtio 1.0
Date: Thu, 11 Dec 2014 21:37:31 +0200
Message-ID: <1418326570-9541-3-git-send-email-mst@redhat.com>
References: <1418326570-9541-1-git-send-email-mst@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1418326570-9541-1-git-send-email-mst@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Rusty Russell <rusty@rustcorp.com.au>, virtualization@lists.linux-foundation.org, cornelia.huck@de.ibm.com, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

From: Rusty Russell <rusty@rustcorp.com.au>

Based on patches by Michael S. Tsirkin <mst@redhat.com>, but I found it
hard to follow so changed to use structures which are more
self-documenting.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 include/uapi/linux/virtio_pci.h | 62 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 62 insertions(+)

diff --git a/include/uapi/linux/virtio_pci.h b/include/uapi/linux/virtio_pci.h
index 35b552c..8423764 100644
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
+	__u8 unused1;
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
