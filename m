From: "Michael S. Tsirkin" <mst@redhat.com>
Subject: [PATCH RFC 1/5] virtio_pci: add VIRTIO_PCI_NO_LEGACY
Date: Thu, 11 Dec 2014 21:37:25 +0200
Message-ID: <1418326570-9541-2-git-send-email-mst@redhat.com>
References: <1418326570-9541-1-git-send-email-mst@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
Content-Disposition: inline
In-Reply-To: <1418326570-9541-1-git-send-email-mst@redhat.com>
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

Add macro to disable all legacy register defines.
Helpful to make sure legacy macros don't leak
through into modern code.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
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
