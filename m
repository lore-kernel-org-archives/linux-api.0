From: "Michael S. Tsirkin" <mst@redhat.com>
Subject: [PATCH post-squash 4/9] virtio_pci: macros for PCI layout offsets
Date: Wed, 21 Jan 2015 17:05:20 +0200
Message-ID: <1421852670-23742-5-git-send-email-mst@redhat.com>
References: <1421852670-23742-1-git-send-email-mst@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
Content-Disposition: inline
In-Reply-To: <1421852670-23742-1-git-send-email-mst@redhat.com>
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

From: Rusty Russell <rusty@rustcorp.com.au>

QEMU wants it, so why not?  Trust, but verify.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Tested-by: Gerd Hoffmann <kraxel@redhat.com>
---
 include/uapi/linux/virtio_pci.h    | 36 +++++++++++++++++++----
 drivers/virtio/virtio_pci_modern.c | 60 +++++++++++++++++++++++++++++++++++++-
 2 files changed, 90 insertions(+), 6 deletions(-)

diff --git a/include/uapi/linux/virtio_pci.h b/include/uapi/linux/virtio_pci.h
index a2b2e13..3b7e4d2 100644
--- a/include/uapi/linux/virtio_pci.h
+++ b/include/uapi/linux/virtio_pci.h
@@ -124,11 +124,6 @@ struct virtio_pci_cap {
 	__le32 length;		/* Length of the structure, in bytes. */
 };
 
-#define VIRTIO_PCI_CAP_BAR_SHIFT	5
-#define VIRTIO_PCI_CAP_BAR_MASK		0x7
-#define VIRTIO_PCI_CAP_TYPE_SHIFT	0
-#define VIRTIO_PCI_CAP_TYPE_MASK	0x7
-
 struct virtio_pci_notify_cap {
 	struct virtio_pci_cap cap;
 	__le32 notify_off_multiplier;	/* Multiplier for queue_notify_off. */
@@ -160,6 +155,37 @@ struct virtio_pci_common_cfg {
 	__le32 queue_used_hi;		/* read-write */
 };
 
+/* Macro versions of offsets for the Old Timers! */
+#define VIRTIO_PCI_CAP_VNDR		0
+#define VIRTIO_PCI_CAP_NEXT		1
+#define VIRTIO_PCI_CAP_LEN		2
+#define VIRTIO_PCI_CAP_CFG_TYPE		3
+#define VIRTIO_PCI_CAP_BAR		4
+#define VIRTIO_PCI_CAP_OFFSET		8
+#define VIRTIO_PCI_CAP_LENGTH		12
+
+#define VIRTIO_PCI_NOTIFY_CAP_MULT	16
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
index a3d8101..b2e707ad 100644
--- a/drivers/virtio/virtio_pci_modern.c
+++ b/drivers/virtio/virtio_pci_modern.c
@@ -464,9 +464,67 @@ static void virtio_pci_release_dev(struct device *_d)
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
+	BUILD_BUG_ON(VIRTIO_PCI_CAP_CFG_TYPE !=
+		     offsetof(struct virtio_pci_cap, cfg_type));
+	BUILD_BUG_ON(VIRTIO_PCI_CAP_BAR !=
+		     offsetof(struct virtio_pci_cap, bar));
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
