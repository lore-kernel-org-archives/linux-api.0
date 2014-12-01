From: "Michael S. Tsirkin" <mst@redhat.com>
Subject: [PATCH v8 49/50] virtio: make VIRTIO_F_VERSION_1 a transport bit
Date: Mon, 1 Dec 2014 18:06:55 +0200
Message-ID: <1417449619-24896-50-git-send-email-mst@redhat.com>
References: <1417449619-24896-1-git-send-email-mst@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
Content-Disposition: inline
In-Reply-To: <1417449619-24896-1-git-send-email-mst@redhat.com>
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
Cc: thuth@linux.vnet.ibm.com, rusty@au1.ibm.com, linux-api@vger.kernel.org, virtualization@lists.linux-foundation.org, dahi@linux.vnet.ibm.com, pbonzini@redhat.com, David Miller <davem@davemloft.net>
List-Id: linux-api@vger.kernel.org

Activate VIRTIO_F_VERSION_1 automatically unless legacy_only
is set.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 include/uapi/linux/virtio_config.h | 4 ++--
 drivers/virtio/virtio.c            | 6 +++++-
 drivers/virtio/virtio_ring.c       | 2 ++
 3 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/include/uapi/linux/virtio_config.h b/include/uapi/linux/virtio_config.h
index 4d05671..a6d0cde 100644
--- a/include/uapi/linux/virtio_config.h
+++ b/include/uapi/linux/virtio_config.h
@@ -43,11 +43,11 @@
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
diff --git a/drivers/virtio/virtio.c b/drivers/virtio/virtio.c
index f9ad99c..fa6b75d 100644
--- a/drivers/virtio/virtio.c
+++ b/drivers/virtio/virtio.c
@@ -197,7 +197,11 @@ static int virtio_dev_probe(struct device *_d)
 		driver_features_legacy = driver_features;
 	}
 
-	if (driver_features & device_features & (1ULL << VIRTIO_F_VERSION_1))
+	/* Detect legacy-only drivers and disable VIRTIO_F_VERSION_1. */
+	if (drv->legacy_only)
+		device_features &= ~(1ULL << VIRTIO_F_VERSION_1);
+
+	if (device_features & (1ULL << VIRTIO_F_VERSION_1))
 		dev->features = driver_features & device_features;
 	else
 		dev->features = driver_features_legacy & device_features;
diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
index 55532a4..00ec6b3 100644
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
 			__virtio_clear_bit(vdev, i);
-- 
MST
