From: "Michael S. Tsirkin" <mst@redhat.com>
Subject: [PATCH RFC 2/2] virtio_balloon: drop legacy_only
Date: Tue, 2 Dec 2014 13:44:08 +0200
Message-ID: <1417520617-2135-2-git-send-email-mst@redhat.com>
References: <1417520617-2135-1-git-send-email-mst@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
Content-Disposition: inline
In-Reply-To: <1417520617-2135-1-git-send-email-mst@redhat.com>
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
Cc: linux-api@vger.kernel.org, David Hildenbrand <dahi@linux.vnet.ibm.com>, virtualization@lists.linux-foundation.org
List-Id: linux-api@vger.kernel.org

balloon is the only driver using legacy_only ATM.
It turns out, it's easier to just make balloon support virtio 1.0
endian-ness and drop the flag from core.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 include/linux/virtio.h          | 2 --
 drivers/virtio/virtio.c         | 4 ----
 drivers/virtio/virtio_balloon.c | 1 -
 3 files changed, 7 deletions(-)

diff --git a/include/linux/virtio.h b/include/linux/virtio.h
index 2bbf626..f70411e 100644
--- a/include/linux/virtio.h
+++ b/include/linux/virtio.h
@@ -132,7 +132,6 @@ int virtio_device_restore(struct virtio_device *dev);
  * @feature_table_size: number of entries in the feature table array.
  * @feature_table_legacy: same as feature_table but when working in legacy mode.
  * @feature_table_size_legacy: number of entries in feature table legacy array.
- * @legacy_only: driver does not support virtio 1.0.
  * @probe: the function to call when a device is found.  Returns 0 or -errno.
  * @remove: the function to call when a device is removed.
  * @config_changed: optional function to call when the device configuration
@@ -145,7 +144,6 @@ struct virtio_driver {
 	unsigned int feature_table_size;
 	const unsigned int *feature_table_legacy;
 	unsigned int feature_table_size_legacy;
-	bool legacy_only;
 	int (*probe)(struct virtio_device *dev);
 	void (*scan)(struct virtio_device *dev);
 	void (*remove)(struct virtio_device *dev);
diff --git a/drivers/virtio/virtio.c b/drivers/virtio/virtio.c
index fa6b75d..2e836d8 100644
--- a/drivers/virtio/virtio.c
+++ b/drivers/virtio/virtio.c
@@ -197,10 +197,6 @@ static int virtio_dev_probe(struct device *_d)
 		driver_features_legacy = driver_features;
 	}
 
-	/* Detect legacy-only drivers and disable VIRTIO_F_VERSION_1. */
-	if (drv->legacy_only)
-		device_features &= ~(1ULL << VIRTIO_F_VERSION_1);
-
 	if (device_features & (1ULL << VIRTIO_F_VERSION_1))
 		dev->features = driver_features & device_features;
 	else
diff --git a/drivers/virtio/virtio_balloon.c b/drivers/virtio/virtio_balloon.c
index 721e32f..fed3709 100644
--- a/drivers/virtio/virtio_balloon.c
+++ b/drivers/virtio/virtio_balloon.c
@@ -518,7 +518,6 @@ static unsigned int features[] = {
 };
 
 static struct virtio_driver virtio_balloon_driver = {
-	.legacy_only = true,
 	.feature_table = features,
 	.feature_table_size = ARRAY_SIZE(features),
 	.driver.name =	KBUILD_MODNAME,
-- 
MST
