From: Antonios Motakis <a.motakis-lrHrjnjw1UfHK3s98zE1ajGjJy/sRE9J@public.gmane.org>
Subject: [PATCH v10 02/20] vfio: platform: probe to devices on the platform bus
Date: Thu, 27 Nov 2014 18:32:42 +0100
Message-ID: <1417109580-10505-3-git-send-email-a.motakis@virtualopensystems.com>
References: <1417109580-10505-1-git-send-email-a.motakis@virtualopensystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <1417109580-10505-1-git-send-email-a.motakis-lrHrjnjw1UfHK3s98zE1ajGjJy/sRE9J@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/iommu/>
List-Post: <mailto:iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: kvmarm-FPEHb7Xf0XXUo1n7N8X6UoWGPAHP3yOg@public.gmane.org, iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: "open list:VFIO DRIVER" <kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, eric.auger-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, marc.zyngier-5wv7dgnIgG8@public.gmane.org, "open list:ABI/API" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, will.deacon-5wv7dgnIgG8@public.gmane.org, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Antonios Motakis <a.motakis-lrHrjnjw1UfHK3s98zE1ajGjJy/sRE9J@public.gmane.org>, tech-lrHrjnjw1UfHK3s98zE1ajGjJy/sRE9J@public.gmane.org, christoffer.dall-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
List-Id: linux-api@vger.kernel.org

Driver to bind to Linux platform devices, and callbacks to discover their
resources to be used by the main VFIO PLATFORM code.

Signed-off-by: Antonios Motakis <a.motakis-lrHrjnjw1UfHK3s98zE1ajGjJy/sRE9J@public.gmane.org>
---
 drivers/vfio/platform/vfio_platform.c | 103 ++++++++++++++++++++++++++++++++++
 include/uapi/linux/vfio.h             |   1 +
 2 files changed, 104 insertions(+)
 create mode 100644 drivers/vfio/platform/vfio_platform.c

diff --git a/drivers/vfio/platform/vfio_platform.c b/drivers/vfio/platform/vfio_platform.c
new file mode 100644
index 0000000..cef645c
--- /dev/null
+++ b/drivers/vfio/platform/vfio_platform.c
@@ -0,0 +1,103 @@
+/*
+ * Copyright (C) 2013 - Virtual Open Systems
+ * Author: Antonios Motakis <a.motakis-lrHrjnjw1UfHK3s98zE1ajGjJy/sRE9J@public.gmane.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License, version 2, as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/vfio.h>
+#include <linux/platform_device.h>
+
+#include "vfio_platform_private.h"
+
+#define DRIVER_VERSION  "0.10"
+#define DRIVER_AUTHOR   "Antonios Motakis <a.motakis-lrHrjnjw1UfHK3s98zE1ajGjJy/sRE9J@public.gmane.org>"
+#define DRIVER_DESC     "VFIO for platform devices - User Level meta-driver"
+
+/* probing devices from the linux platform bus */
+
+static struct resource *get_platform_resource(struct vfio_platform_device *vdev,
+					      int num)
+{
+	struct platform_device *dev = (struct platform_device *) vdev->opaque;
+	int i;
+
+	for (i = 0; i < dev->num_resources; i++) {
+		struct resource *r = &dev->resource[i];
+
+		if (resource_type(r) & (IORESOURCE_MEM|IORESOURCE_IO)) {
+			if (!num)
+				return r;
+
+			num--;
+		}
+	}
+	return NULL;
+}
+
+static int get_platform_irq(struct vfio_platform_device *vdev, int i)
+{
+	struct platform_device *pdev = (struct platform_device *) vdev->opaque;
+
+	return platform_get_irq(pdev, i);
+}
+
+static int vfio_platform_probe(struct platform_device *pdev)
+{
+	struct vfio_platform_device *vdev;
+	int ret;
+
+	vdev = kzalloc(sizeof(*vdev), GFP_KERNEL);
+	if (!vdev)
+		return -ENOMEM;
+
+	vdev->opaque = (void *) pdev;
+	vdev->name = pdev->name;
+	vdev->flags = VFIO_DEVICE_FLAGS_PLATFORM;
+	vdev->get_resource = get_platform_resource;
+	vdev->get_irq = get_platform_irq;
+
+	ret = vfio_platform_probe_common(vdev, &pdev->dev);
+	if (ret)
+		kfree(vdev);
+
+	return ret;
+}
+
+static int vfio_platform_remove(struct platform_device *pdev)
+{
+	struct vfio_platform_device *vdev;
+
+	vdev = vfio_platform_remove_common(&pdev->dev);
+	if (vdev) {
+		kfree(vdev);
+		return 0;
+	}
+
+	return -EINVAL;
+}
+
+static struct platform_driver vfio_platform_driver = {
+	.probe		= vfio_platform_probe,
+	.remove		= vfio_platform_remove,
+	.driver	= {
+		.name	= "vfio-platform",
+		.owner	= THIS_MODULE,
+	},
+};
+
+module_platform_driver(vfio_platform_driver);
+
+MODULE_VERSION(DRIVER_VERSION);
+MODULE_LICENSE("GPL v2");
+MODULE_AUTHOR(DRIVER_AUTHOR);
+MODULE_DESCRIPTION(DRIVER_DESC);
diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index 9ade02b..4e93a97 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -159,6 +159,7 @@ struct vfio_device_info {
 	__u32	flags;
 #define VFIO_DEVICE_FLAGS_RESET	(1 << 0)	/* Device supports reset */
 #define VFIO_DEVICE_FLAGS_PCI	(1 << 1)	/* vfio-pci device */
+#define VFIO_DEVICE_FLAGS_PLATFORM (1 << 2)	/* vfio-platform device */
 	__u32	num_regions;	/* Max region index + 1 */
 	__u32	num_irqs;	/* Max IRQ index + 1 */
 };
-- 
2.1.3
