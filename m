From: Antonios Motakis <a.motakis-lrHrjnjw1UfHK3s98zE1ajGjJy/sRE9J@public.gmane.org>
Subject: [PATCH v8 04/18] vfio: amba: VFIO support for AMBA devices
Date: Mon, 13 Oct 2014 15:10:11 +0200
Message-ID: <1413205825-6370-5-git-send-email-a.motakis@virtualopensystems.com>
References: <1413205825-6370-1-git-send-email-a.motakis@virtualopensystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <1413205825-6370-1-git-send-email-a.motakis-lrHrjnjw1UfHK3s98zE1ajGjJy/sRE9J@public.gmane.org>
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

Add support for discovering AMBA devices with VFIO and handle them
similarly to Linux platform devices.

Signed-off-by: Antonios Motakis <a.motakis-lrHrjnjw1UfHK3s98zE1ajGjJy/sRE9J@public.gmane.org>
---
 drivers/vfio/platform/vfio_amba.c | 108 ++++++++++++++++++++++++++++++++++++++
 include/uapi/linux/vfio.h         |   1 +
 2 files changed, 109 insertions(+)
 create mode 100644 drivers/vfio/platform/vfio_amba.c

diff --git a/drivers/vfio/platform/vfio_amba.c b/drivers/vfio/platform/vfio_amba.c
new file mode 100644
index 0000000..b16a40d
--- /dev/null
+++ b/drivers/vfio/platform/vfio_amba.c
@@ -0,0 +1,108 @@
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
+#include <linux/device.h>
+#include <linux/interrupt.h>
+#include <linux/iommu.h>
+#include <linux/module.h>
+#include <linux/mutex.h>
+#include <linux/notifier.h>
+#include <linux/pm_runtime.h>
+#include <linux/slab.h>
+#include <linux/types.h>
+#include <linux/uaccess.h>
+#include <linux/vfio.h>
+#include <linux/io.h>
+#include <linux/irq.h>
+#include <linux/amba/bus.h>
+
+#include "vfio_platform_private.h"
+
+#define DRIVER_VERSION  "0.8"
+#define DRIVER_AUTHOR   "Antonios Motakis <a.motakis-lrHrjnjw1UfHK3s98zE1ajGjJy/sRE9J@public.gmane.org>"
+#define DRIVER_DESC     "VFIO for AMBA devices - User Level meta-driver"
+
+/* probing devices from the AMBA bus */
+
+static struct resource *get_amba_resource(struct vfio_platform_device *vdev,
+						int i)
+{
+	struct amba_device *adev = (struct amba_device *) vdev->opaque;
+
+	if (i == 0)
+		return &adev->res;
+
+	return NULL;
+}
+
+static int get_amba_irq(struct vfio_platform_device *vdev, int i)
+{
+	struct amba_device *adev = (struct amba_device *) vdev->opaque;
+
+	if (i < AMBA_NR_IRQS)
+		return adev->irq[i];
+
+	return 0;
+}
+
+static int vfio_amba_probe(struct amba_device *adev, const struct amba_id *id)
+{
+
+	struct vfio_platform_device *vdev;
+	int ret;
+
+	vdev = kzalloc(sizeof(*vdev), GFP_KERNEL);
+	if (!vdev)
+		return -ENOMEM;
+
+	vdev->opaque = (void *) adev;
+	vdev->name = "vfio-amba-dev";
+	vdev->flags = VFIO_DEVICE_FLAGS_AMBA;
+	vdev->get_resource = get_amba_resource;
+	vdev->get_irq = get_amba_irq;
+
+	ret = vfio_platform_probe_common(vdev, &adev->dev);
+	if (ret)
+		kfree(vdev);
+
+	return ret;
+}
+
+static int vfio_amba_remove(struct amba_device *adev)
+{
+	return vfio_platform_remove_common(&adev->dev);
+}
+
+static struct amba_id pl330_ids[] = {
+	{ 0, 0 },
+};
+
+MODULE_DEVICE_TABLE(amba, pl330_ids);
+
+static struct amba_driver vfio_amba_driver = {
+	.probe = vfio_amba_probe,
+	.remove = vfio_amba_remove,
+	.id_table = pl330_ids,
+	.drv = {
+		.name = "vfio-amba",
+		.owner = THIS_MODULE,
+	},
+};
+
+module_amba_driver(vfio_amba_driver);
+
+MODULE_VERSION(DRIVER_VERSION);
+MODULE_LICENSE("GPL v2");
+MODULE_AUTHOR(DRIVER_AUTHOR);
+MODULE_DESCRIPTION(DRIVER_DESC);
diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index aca6d3e..1a5986c 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -159,6 +159,7 @@ struct vfio_device_info {
 #define VFIO_DEVICE_FLAGS_RESET	(1 << 0)	/* Device supports reset */
 #define VFIO_DEVICE_FLAGS_PCI	(1 << 1)	/* vfio-pci device */
 #define VFIO_DEVICE_FLAGS_PLATFORM (1 << 2)	/* vfio-platform device */
+#define VFIO_DEVICE_FLAGS_AMBA  (1 << 3)	/* vfio-amba device */
 	__u32	num_regions;	/* Max region index + 1 */
 	__u32	num_irqs;	/* Max IRQ index + 1 */
 };
-- 
2.1.1
