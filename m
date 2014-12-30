From: "Michael S. Tsirkin" <mst@redhat.com>
Subject: [PATCH RFC v2 6/7] virtio_pci: macros for PCI layout offsets.
Date: Tue, 30 Dec 2014 18:35:49 +0200
Message-ID: <1419957310-26009-7-git-send-email-mst@redhat.com>
References: <1419957310-26009-1-git-send-email-mst@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
Content-Disposition: inline
In-Reply-To: <1419957310-26009-1-git-send-email-mst@redhat.com>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/virtualization/>
List-Post: <mailto:virtualization@lists.linux-foundation.org>
List-Help: <mailto:virtualization-request@lists.linux-foundation.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=subscribe>
Sender: virtualization-bounces@lists.linux-foundation.org
Errors-To: virtualization-bounces@lists.linux-foundation.org
To: linux-kernel@vger.kernel.org
Cc: linux-api@vger.kernel.org, virtualization@lists.linux-foundation.org
List-Id: linux-api@vger.kernel.org

QEMU wants it, so why not?  Trust, but verify.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 include/uapi/linux/virtio_pci.h    | 30 ++++++++++++++++++
 drivers/virtio/virtio_pci_modern.c | 63 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 93 insertions(+)

diff --git a/include/uapi/linux/virtio_pci.h b/include/uapi/linux/virtio_pci.h
index 28c2ce0..5d546c6 100644
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
index 6f63b4c..ba04055 100644
--- a/drivers/virtio/virtio_pci_modern.c
+++ b/drivers/virtio/virtio_pci_modern.c
@@ -470,6 +470,67 @@ static inline int virtio_pci_find_capability(struct pci_dev *dev, u8 cfg_type,
 	return 0;
 }
 
+/* This is part of the ABI.  Don't screw with it. */
+static inline void check_offsets(void)
+{
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
+}
+
 /* the PCI probing function */
 int virtio_pci_modern_probe(struct pci_dev *pci_dev,
 			    const struct pci_device_id *id)
@@ -479,6 +540,8 @@ int virtio_pci_modern_probe(struct pci_dev *pci_dev,
 	struct virtio_device_id virtio_id;
 	u32 notify_length;
 
+	check_offsets();
+
 	/* We only own devices >= 0x1000 and <= 0x107f: leave the rest. */
 	if (pci_dev->device < 0x1000 || pci_dev->device > 0x107f)
 		return -ENODEV;
-- 
MST
