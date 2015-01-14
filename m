From: "Michael S. Tsirkin" <mst@redhat.com>
Subject: [PATCH v3 14/16] virtio_pci: macros for PCI layout offsets
Date: Wed, 14 Jan 2015 19:28:15 +0200
Message-ID: <1421256142-11512-15-git-send-email-mst@redhat.com>
References: <1421256142-11512-1-git-send-email-mst@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1421256142-11512-1-git-send-email-mst@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Rusty Russell <rusty@rustcorp.com.au>, cornelia.huck@de.ibm.com, virtualization@lists.linux-foundation.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

From: Rusty Russell <rusty@rustcorp.com.au>

QEMU wants it, so why not?  Trust, but verify.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 include/uapi/linux/virtio_pci.h    | 30 ++++++++++++++++++++
 drivers/virtio/virtio_pci_modern.c | 58 +++++++++++++++++++++++++++++++++++++-
 2 files changed, 87 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/virtio_pci.h b/include/uapi/linux/virtio_pci.h
index 4e05423..e841edd 100644
--- a/include/uapi/linux/virtio_pci.h
+++ b/include/uapi/linux/virtio_pci.h
@@ -159,6 +159,36 @@ struct virtio_pci_common_cfg {
 	__le32 queue_used_hi;		/* read-write */
 };
 
+/* Macro versions of offsets for the Old Timers! */
+#define VIRTIO_PCI_CAP_VNDR		0
+#define VIRTIO_PCI_CAP_NEXT		1
+#define VIRTIO_PCI_CAP_LEN		2
+#define VIRTIO_PCI_CAP_TYPE_AND_BAR	3
+#define VIRTIO_PCI_CAP_OFFSET		4
+#define VIRTIO_PCI_CAP_LENGTH		8
+
+#define VIRTIO_PCI_NOTIFY_CAP_MULT	12
+
+#define VIRTIO_PCI_COMMON_DFSELECT	0
+#define VIRTIO_PCI_COMMON_DF		4
+#define VIRTIO_PCI_COMMON_GFSELECT	8
+#define VIRTIO_PCI_COMMON_GF		12
+#define VIRTIO_PCI_COMMON_MSIX		16
+#define VIRTIO_PCI_COMMON_NUMQ		18
+#define VIRTIO_PCI_COMMON_STATUS	20
+#define VIRTIO_PCI_COMMON_CFGGENERATION	21
+#define VIRTIO_PCI_COMMON_Q_SELECT	22
+#define VIRTIO_PCI_COMMON_Q_SIZE	24
+#define VIRTIO_PCI_COMMON_Q_MSIX	26
+#define VIRTIO_PCI_COMMON_Q_ENABLE	28
+#define VIRTIO_PCI_COMMON_Q_NOFF	30
+#define VIRTIO_PCI_COMMON_Q_DESCLO	32
+#define VIRTIO_PCI_COMMON_Q_DESCHI	36
+#define VIRTIO_PCI_COMMON_Q_AVAILLO	40
+#define VIRTIO_PCI_COMMON_Q_AVAILHI	44
+#define VIRTIO_PCI_COMMON_Q_USEDLO	48
+#define VIRTIO_PCI_COMMON_Q_USEDHI	52
+
 #endif /* VIRTIO_PCI_NO_MODERN */
 
 #endif
diff --git a/drivers/virtio/virtio_pci_modern.c b/drivers/virtio/virtio_pci_modern.c
index 38c0a11..5e0d309 100644
--- a/drivers/virtio/virtio_pci_modern.c
+++ b/drivers/virtio/virtio_pci_modern.c
@@ -469,9 +469,65 @@ static void virtio_pci_release_dev(struct device *_d)
 	kfree(vp_dev);
 }
 
-/* TODO: validate the ABI statically. */
+/* This is part of the ABI.  Don't screw with it. */
 static inline void check_offsets(void)
 {
+	/* Note: disk space was harmed in compilation of this function. */
+	BUILD_BUG_ON(VIRTIO_PCI_CAP_VNDR !=
+		     offsetof(struct virtio_pci_cap, cap_vndr));
+	BUILD_BUG_ON(VIRTIO_PCI_CAP_NEXT !=
+		     offsetof(struct virtio_pci_cap, cap_next));
+	BUILD_BUG_ON(VIRTIO_PCI_CAP_LEN !=
+		     offsetof(struct virtio_pci_cap, cap_len));
+	BUILD_BUG_ON(VIRTIO_PCI_CAP_TYPE_AND_BAR !=
+		     offsetof(struct virtio_pci_cap, type_and_bar));
+	BUILD_BUG_ON(VIRTIO_PCI_CAP_OFFSET !=
+		     offsetof(struct virtio_pci_cap, offset));
+	BUILD_BUG_ON(VIRTIO_PCI_CAP_LENGTH !=
+		     offsetof(struct virtio_pci_cap, length));
+	BUILD_BUG_ON(VIRTIO_PCI_NOTIFY_CAP_MULT !=
+		     offsetof(struct virtio_pci_notify_cap,
+			      notify_off_multiplier));
+	BUILD_BUG_ON(VIRTIO_PCI_COMMON_DFSELECT !=
+		     offsetof(struct virtio_pci_common_cfg,
+			      device_feature_select));
+	BUILD_BUG_ON(VIRTIO_PCI_COMMON_DF !=
+		     offsetof(struct virtio_pci_common_cfg, device_feature));
+	BUILD_BUG_ON(VIRTIO_PCI_COMMON_GFSELECT !=
+		     offsetof(struct virtio_pci_common_cfg,
+			      guest_feature_select));
+	BUILD_BUG_ON(VIRTIO_PCI_COMMON_GF !=
+		     offsetof(struct virtio_pci_common_cfg, guest_feature));
+	BUILD_BUG_ON(VIRTIO_PCI_COMMON_MSIX !=
+		     offsetof(struct virtio_pci_common_cfg, msix_config));
+	BUILD_BUG_ON(VIRTIO_PCI_COMMON_NUMQ !=
+		     offsetof(struct virtio_pci_common_cfg, num_queues));
+	BUILD_BUG_ON(VIRTIO_PCI_COMMON_STATUS !=
+		     offsetof(struct virtio_pci_common_cfg, device_status));
+	BUILD_BUG_ON(VIRTIO_PCI_COMMON_CFGGENERATION !=
+		     offsetof(struct virtio_pci_common_cfg, config_generation));
+	BUILD_BUG_ON(VIRTIO_PCI_COMMON_Q_SELECT !=
+		     offsetof(struct virtio_pci_common_cfg, queue_select));
+	BUILD_BUG_ON(VIRTIO_PCI_COMMON_Q_SIZE !=
+		     offsetof(struct virtio_pci_common_cfg, queue_size));
+	BUILD_BUG_ON(VIRTIO_PCI_COMMON_Q_MSIX !=
+		     offsetof(struct virtio_pci_common_cfg, queue_msix_vector));
+	BUILD_BUG_ON(VIRTIO_PCI_COMMON_Q_ENABLE !=
+		     offsetof(struct virtio_pci_common_cfg, queue_enable));
+	BUILD_BUG_ON(VIRTIO_PCI_COMMON_Q_NOFF !=
+		     offsetof(struct virtio_pci_common_cfg, queue_notify_off));
+	BUILD_BUG_ON(VIRTIO_PCI_COMMON_Q_DESCLO !=
+		     offsetof(struct virtio_pci_common_cfg, queue_desc_lo));
+	BUILD_BUG_ON(VIRTIO_PCI_COMMON_Q_DESCHI !=
+		     offsetof(struct virtio_pci_common_cfg, queue_desc_hi));
+	BUILD_BUG_ON(VIRTIO_PCI_COMMON_Q_AVAILLO !=
+		     offsetof(struct virtio_pci_common_cfg, queue_avail_lo));
+	BUILD_BUG_ON(VIRTIO_PCI_COMMON_Q_AVAILHI !=
+		     offsetof(struct virtio_pci_common_cfg, queue_avail_hi));
+	BUILD_BUG_ON(VIRTIO_PCI_COMMON_Q_USEDLO !=
+		     offsetof(struct virtio_pci_common_cfg, queue_used_lo));
+	BUILD_BUG_ON(VIRTIO_PCI_COMMON_Q_USEDHI !=
+		     offsetof(struct virtio_pci_common_cfg, queue_used_hi));
 }
 
 /* the PCI probing function */
-- 
MST
