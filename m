From: "Michael S. Tsirkin" <mst@redhat.com>
Subject: [PATCH v3 08/41] virtio: set FEATURES_OK
Date: Mon, 24 Nov 2014 13:53:14 +0200
Message-ID: <1416829787-14252-9-git-send-email-mst@redhat.com>
References: <1416829787-14252-1-git-send-email-mst@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1416829787-14252-1-git-send-email-mst@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: David Miller <davem@davemloft.net>, cornelia.huck@de.ibm.com, rusty@au1.ibm.com, nab@linux-iscsi.org, pbonzini@redhat.com, Rusty Russell <rusty@rustcorp.com.au>, virtualization@lists.linux-foundation.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

set FEATURES_OK as per virtio 1.0 spec

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 include/uapi/linux/virtio_config.h |  2 ++
 drivers/virtio/virtio.c            | 29 ++++++++++++++++++++++-------
 2 files changed, 24 insertions(+), 7 deletions(-)

diff --git a/include/uapi/linux/virtio_config.h b/include/uapi/linux/virtio_config.h
index f3fe33a..a6d0cde 100644
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
