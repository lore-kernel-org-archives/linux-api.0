From: "Michael S. Tsirkin" <mst@redhat.com>
Subject: [PATCH v4 09/42] virtio: set FEATURES_OK
Date: Tue, 25 Nov 2014 18:42:01 +0200
Message-ID: <1416933600-21398-10-git-send-email-mst@redhat.com>
References: <1416933600-21398-1-git-send-email-mst@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
Content-Disposition: inline
In-Reply-To: <1416933600-21398-1-git-send-email-mst@redhat.com>
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
Cc: rusty@au1.ibm.com, linux-api@vger.kernel.org, virtualization@lists.linux-foundation.org, pbonzini@redhat.com, David Miller <davem@davemloft.net>
List-Id: linux-api@vger.kernel.org

set FEATURES_OK as per virtio 1.0 spec

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 include/uapi/linux/virtio_config.h |  2 ++
 drivers/virtio/virtio.c            | 29 ++++++++++++++++++++++-------
 2 files changed, 24 insertions(+), 7 deletions(-)

diff --git a/include/uapi/linux/virtio_config.h b/include/uapi/linux/virtio_config.h
index 80e7381..4d05671 100644
--- a/include/uapi/linux/virtio_config.h
+++ b/include/uapi/linux/virtio_config.h
@@ -38,6 +38,8 @@
 #define VIRTIO_CONFIG_S_DRIVER		2
 /* Driver has used its parts of the config, and is happy */
 #define VIRTIO_CONFIG_S_DRIVER_OK	4
+/* Driver has finished configuring features */
+#define VIRTIO_CONFIG_S_FEATURES_OK	8
 /* We've given up on this device. */
 #define VIRTIO_CONFIG_S_FAILED		0x80
 
diff --git a/drivers/virtio/virtio.c b/drivers/virtio/virtio.c
index d213567..a3df817 100644
--- a/drivers/virtio/virtio.c
+++ b/drivers/virtio/virtio.c
@@ -160,6 +160,7 @@ static int virtio_dev_probe(struct device *_d)
 	struct virtio_device *dev = dev_to_virtio(_d);
 	struct virtio_driver *drv = drv_to_virtio(dev->dev.driver);
 	u64 device_features;
+	unsigned status;
 
 	/* We have a driver! */
 	add_status(dev, VIRTIO_CONFIG_S_DRIVER);
@@ -183,18 +184,32 @@ static int virtio_dev_probe(struct device *_d)
 
 	dev->config->finalize_features(dev);
 
+	if (virtio_has_feature(dev, VIRTIO_F_VERSION_1)) {
+		add_status(dev, VIRTIO_CONFIG_S_FEATURES_OK);
+		status = dev->config->get_status(dev);
+		if (!(status & VIRTIO_CONFIG_S_FEATURES_OK)) {
+			printk(KERN_ERR "virtio: device refuses features: %x\n",
+			       status);
+			err = -ENODEV;
+			goto err;
+		}
+	}
+
 	err = drv->probe(dev);
 	if (err)
-		add_status(dev, VIRTIO_CONFIG_S_FAILED);
-	else {
-		add_status(dev, VIRTIO_CONFIG_S_DRIVER_OK);
-		if (drv->scan)
-			drv->scan(dev);
+		goto err;
 
-		virtio_config_enable(dev);
-	}
+	add_status(dev, VIRTIO_CONFIG_S_DRIVER_OK);
+	if (drv->scan)
+		drv->scan(dev);
+
+	virtio_config_enable(dev);
 
+	return 0;
+err:
+	add_status(dev, VIRTIO_CONFIG_S_FAILED);
 	return err;
+
 }
 
 static int virtio_dev_remove(struct device *_d)
-- 
MST
