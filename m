From: Baptiste Reynal <b.reynal@virtualopensystems.com>
Subject: [PATCH v12 02/18] vfio: platform: probe to devices on the platform bus
Date: Wed, 21 Jan 2015 13:49:50 +0100
Message-ID: <1421844606-24751-3-git-send-email-b.reynal@virtualopensystems.com>
References: <1421844606-24751-1-git-send-email-b.reynal@virtualopensystems.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1421844606-24751-1-git-send-email-b.reynal@virtualopensystems.com>
Sender: kvm-owner@vger.kernel.org
To: kvmarm@lists.cs.columbia.edu, iommu@lists.linux-fundation.org, alex.williamson@redhat.com
Cc: will.deacon@arm.com, tech@virtualopensystems.com, christoffer.dall@linaro.org, eric.auger@linaro.org, kim.phillips@freescale.com, marc.zyngier@arm.com, Antonios Motakis <a.motakis@virtualopensystems.com>, open list <linux-kernel@vger.kernel.org>, "open list:VFIO DRIVER" <kvm@vger.kernel.org>, "open list:ABI/API" <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

From: Antonios Motakis <a.motakis@virtualopensystems.com>

Driver to bind to Linux platform devices, and callbacks to discover their
resources to be used by the main VFIO PLATFORM code.

Signed-off-by: Antonios Motakis <a.motakis@virtualopensystems.com>
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
+ * Author: Antonios Motakis <a.motakis@virtualopensystems.com>
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
+#define DRIVER_AUTHOR   "Antonios Motakis <a.motakis@virtualopensystems.com>"
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
2.2.2

