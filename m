From: "Michael S. Tsirkin" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH pre-squash 08/14] fixup! virtio_pci: macros for PCI layout
 offsets
Date: Wed, 21 Jan 2015 17:00:29 +0200
Message-ID: <1421852375-22604-9-git-send-email-mst@redhat.com>
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

virtio_pci_modern: fix up vendor capability macros

Gerd Hoffmann noticed that we implemented
capability layout from an old draft.
Unfortunately the code was copied to host as well,
so we didn't notice.

Luckily we caught this in time.

This fixes commit "virtio_pci: macros for PCI layout offsets"
and should be smashed with it.

Reported-by: Gerd Hoffmann <kraxel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Tested-by: Gerd Hoffmann <kraxel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Michael S. Tsirkin <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 include/uapi/linux/virtio_pci.h    | 14 +++++---------
 drivers/virtio/virtio_pci_modern.c |  6 ++++--
 2 files changed, 9 insertions(+), 11 deletions(-)

diff --git a/include/uapi/linux/virtio_pci.h b/include/uapi/linux/virtio_pci.h
index 0911c62..3b7e4d2 100644
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
@@ -164,11 +159,12 @@ struct virtio_pci_common_cfg {
 #define VIRTIO_PCI_CAP_VNDR		0
 #define VIRTIO_PCI_CAP_NEXT		1
 #define VIRTIO_PCI_CAP_LEN		2
-#define VIRTIO_PCI_CAP_TYPE_AND_BAR	3
-#define VIRTIO_PCI_CAP_OFFSET		4
-#define VIRTIO_PCI_CAP_LENGTH		8
+#define VIRTIO_PCI_CAP_CFG_TYPE		3
+#define VIRTIO_PCI_CAP_BAR		4
+#define VIRTIO_PCI_CAP_OFFSET		8
+#define VIRTIO_PCI_CAP_LENGTH		12
 
-#define VIRTIO_PCI_NOTIFY_CAP_MULT	12
+#define VIRTIO_PCI_NOTIFY_CAP_MULT	16
 
 #define VIRTIO_PCI_COMMON_DFSELECT	0
 #define VIRTIO_PCI_COMMON_DF		4
diff --git a/drivers/virtio/virtio_pci_modern.c b/drivers/virtio/virtio_pci_modern.c
index c86594e..b2e707ad 100644
--- a/drivers/virtio/virtio_pci_modern.c
+++ b/drivers/virtio/virtio_pci_modern.c
@@ -474,8 +474,10 @@ static inline void check_offsets(void)
 		     offsetof(struct virtio_pci_cap, cap_next));
 	BUILD_BUG_ON(VIRTIO_PCI_CAP_LEN !=
 		     offsetof(struct virtio_pci_cap, cap_len));
-	BUILD_BUG_ON(VIRTIO_PCI_CAP_TYPE_AND_BAR !=
-		     offsetof(struct virtio_pci_cap, type_and_bar));
+	BUILD_BUG_ON(VIRTIO_PCI_CAP_CFG_TYPE !=
+		     offsetof(struct virtio_pci_cap, cfg_type));
+	BUILD_BUG_ON(VIRTIO_PCI_CAP_BAR !=
+		     offsetof(struct virtio_pci_cap, bar));
 	BUILD_BUG_ON(VIRTIO_PCI_CAP_OFFSET !=
 		     offsetof(struct virtio_pci_cap, offset));
 	BUILD_BUG_ON(VIRTIO_PCI_CAP_LENGTH !=
-- 
MST
