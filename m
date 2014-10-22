From: "Michael S. Tsirkin" <mst@redhat.com>
Subject: [PATCH RFC v3 05/16] virtio: add virtio 1.0 feature bit
Date: Wed, 22 Oct 2014 21:44:31 +0300
Message-ID: <1414003404-505-6-git-send-email-mst@redhat.com>
References: <1414003404-505-1-git-send-email-mst@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
Content-Disposition: inline
In-Reply-To: <1414003404-505-1-git-send-email-mst@redhat.com>
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

Based on original patches by Rusty Russell, Thomas Huth
and Cornelia Huck.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 include/uapi/linux/virtio_config.h | 7 +++++--
 drivers/virtio/virtio_ring.c       | 2 ++
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/virtio_config.h b/include/uapi/linux/virtio_config.h
index 3ce768c..f3fe33a 100644
--- a/include/uapi/linux/virtio_config.h
+++ b/include/uapi/linux/virtio_config.h
@@ -41,11 +41,11 @@
 /* We've given up on this device. */
 #define VIRTIO_CONFIG_S_FAILED		0x80
 
-/* Some virtio feature bits (currently bits 28 through 31) are reserved for the
+/* Some virtio feature bits (currently bits 28 through 32) are reserved for the
  * transport being used (eg. virtio_ring), the rest are per-device feature
  * bits. */
 #define VIRTIO_TRANSPORT_F_START	28
-#define VIRTIO_TRANSPORT_F_END		32
+#define VIRTIO_TRANSPORT_F_END		33
 
 /* Do we get callbacks when the ring is completely used, even if we've
  * suppressed them? */
@@ -54,4 +54,7 @@
 /* Can the device handle any descriptor layout? */
 #define VIRTIO_F_ANY_LAYOUT		27
 
+/* v1.0 compliant. */
+#define VIRTIO_F_VERSION_1		32
+
 #endif /* _UAPI_LINUX_VIRTIO_CONFIG_H */
diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
index b311fa7..9f5dfe3 100644
--- a/drivers/virtio/virtio_ring.c
+++ b/drivers/virtio/virtio_ring.c
@@ -780,6 +780,8 @@ void vring_transport_features(struct virtio_device *vdev)
 			break;
 		case VIRTIO_RING_F_EVENT_IDX:
 			break;
+		case VIRTIO_F_VERSION_1:
+			break;
 		default:
 			/* We don't understand this bit. */
 			vdev->features &= ~(1ULL << i);
-- 
MST
