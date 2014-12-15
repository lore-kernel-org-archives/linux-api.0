From: "Michael S. Tsirkin" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 5/6] virtio_pci: add VIRTIO_PCI_NO_LEGACY
Date: Mon, 15 Dec 2014 23:23:20 +0200
Message-ID: <1418678575-31755-6-git-send-email-mst@redhat.com>
References: <1418678575-31755-1-git-send-email-mst@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1418678575-31755-1-git-send-email-mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Rusty Russell <rusty-8n+1lVoiYb80n/F98K4Iww@public.gmane.org>, virtualization-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Add macro to disable all legacy register defines.
Helpful to make sure legacy macros don't leak
through into modern code.

Signed-off-by: Michael S. Tsirkin <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 include/uapi/linux/virtio_pci.h | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/include/uapi/linux/virtio_pci.h b/include/uapi/linux/virtio_pci.h
index e5ec1ca..35b552c 100644
--- a/include/uapi/linux/virtio_pci.h
+++ b/include/uapi/linux/virtio_pci.h
@@ -41,6 +41,8 @@
 
 #include <linux/virtio_config.h>
 
+#ifndef VIRTIO_PCI_NO_LEGACY
+
 /* A 32-bit r/o bitmask of the features supported by the host */
 #define VIRTIO_PCI_HOST_FEATURES	0
 
@@ -67,16 +69,11 @@
  * a read-and-acknowledge. */
 #define VIRTIO_PCI_ISR			19
 
-/* The bit of the ISR which indicates a device configuration change. */
-#define VIRTIO_PCI_ISR_CONFIG		0x2
-
 /* MSI-X registers: only enabled if MSI-X is enabled. */
 /* A 16-bit vector for configuration changes. */
 #define VIRTIO_MSI_CONFIG_VECTOR        20
 /* A 16-bit vector for selected queue notifications. */
 #define VIRTIO_MSI_QUEUE_VECTOR         22
-/* Vector value used to disable MSI for queue */
-#define VIRTIO_MSI_NO_VECTOR            0xffff
 
 /* The remaining space is defined by each driver as the per-driver
  * configuration space */
@@ -94,4 +91,12 @@
 /* The alignment to use between consumer and producer parts of vring.
  * x86 pagesize again. */
 #define VIRTIO_PCI_VRING_ALIGN		4096
+
+#endif /* VIRTIO_PCI_NO_LEGACY */
+
+/* The bit of the ISR which indicates a device configuration change. */
+#define VIRTIO_PCI_ISR_CONFIG		0x2
+/* Vector value used to disable MSI for queue */
+#define VIRTIO_MSI_NO_VECTOR            0xffff
+
 #endif
-- 
MST
