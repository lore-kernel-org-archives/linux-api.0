From: Antonios Motakis <a.motakis-lrHrjnjw1UfHK3s98zE1ajGjJy/sRE9J@public.gmane.org>
Subject: [PATCH 1/4] VFIO: PLATFORM: Add device tree info API and skeleton
Date: Wed, 13 Aug 2014 13:02:16 +0200
Message-ID: <1407927740-14993-2-git-send-email-a.motakis@virtualopensystems.com>
References: <1407927740-14993-1-git-send-email-a.motakis@virtualopensystems.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1407927740-14993-1-git-send-email-a.motakis-lrHrjnjw1UfHK3s98zE1ajGjJy/sRE9J@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, kvmarm-FPEHb7Xf0XXUo1n7N8X6UoWGPAHP3yOg@public.gmane.org, iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Cc: tech-lrHrjnjw1UfHK3s98zE1ajGjJy/sRE9J@public.gmane.org, a.rigo-lrHrjnjw1UfHK3s98zE1ajGjJy/sRE9J@public.gmane.org, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, christoffer.dall-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, kim.phillips-KZfg59tc24xl57MIdRCFDg@public.gmane.org, stuart.yoder-KZfg59tc24xl57MIdRCFDg@public.gmane.org, eric.auger-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, marc.zyngier-5wv7dgnIgG8@public.gmane.org, Antonios Motakis <a.motakis-lrHrjnjw1UfHK3s98zE1ajGjJy/sRE9J@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Vladimir Murzin <vladimir.murzin-5wv7dgnIgG8@public.gmane.org>, Rob Herring <robh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Ashwin Chaugule <ashwin.chaugule-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "open list:ABI/API" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

This patch introduced the API to return device tree info about
a PLATFORM device (if described by a device tree) and the skeleton
of the implementation for VFIO_PLATFORM. Information about any device
node bound by VFIO_PLATFORM should be queried via the introduced ioctl
VFIO_DEVICE_GET_DEVTREE_INFO.

Signed-off-by: Antonios Motakis <a.motakis-lrHrjnjw1UfHK3s98zE1ajGjJy/sRE9J@public.gmane.org>
---
 drivers/vfio/platform/Makefile                |  2 +-
 drivers/vfio/platform/devtree.c               | 27 ++++++++++++++++++++++
 drivers/vfio/platform/vfio_platform.c         | 11 +++++++++
 drivers/vfio/platform/vfio_platform_private.h |  7 ++++++
 include/uapi/linux/vfio.h                     | 32 ++++++++++++++++++++++++---
 5 files changed, 75 insertions(+), 4 deletions(-)
 create mode 100644 drivers/vfio/platform/devtree.c

diff --git a/drivers/vfio/platform/Makefile b/drivers/vfio/platform/Makefile
index 2c53327..4313fd7 100644
--- a/drivers/vfio/platform/Makefile
+++ b/drivers/vfio/platform/Makefile
@@ -1,4 +1,4 @@
 
-vfio-platform-y := vfio_platform.o vfio_platform_irq.o
+vfio-platform-y := vfio_platform.o vfio_platform_irq.o devtree.o
 
 obj-$(CONFIG_VFIO_PLATFORM) += vfio-platform.o
diff --git a/drivers/vfio/platform/devtree.c b/drivers/vfio/platform/devtree.c
new file mode 100644
index 0000000..91cab88
--- /dev/null
+++ b/drivers/vfio/platform/devtree.c
@@ -0,0 +1,27 @@
+#include <linux/slab.h>
+#include <linux/vfio.h>
+#include <linux/of.h>
+#include <linux/platform_device.h>
+#include "vfio_platform_private.h"
+
+void vfio_platform_devtree_get(struct vfio_platform_device *vdev)
+{
+	vdev->of_node = of_node_get(vdev->pdev->dev.of_node);
+}
+
+void vfio_platform_devtree_put(struct vfio_platform_device *vdev)
+{
+	of_node_put(vdev->of_node);
+	vdev->of_node = NULL;
+}
+
+bool vfio_platform_has_devtree(struct vfio_platform_device *vdev)
+{
+	return !!vdev->of_node;
+}
+
+long vfio_platform_devtree_ioctl(struct vfio_platform_device *vdev,
+				 unsigned long arg)
+{
+	return -EINVAL; /* not implemented yet */
+}
diff --git a/drivers/vfio/platform/vfio_platform.c b/drivers/vfio/platform/vfio_platform.c
index f4c06c6..e6fe05a 100644
--- a/drivers/vfio/platform/vfio_platform.c
+++ b/drivers/vfio/platform/vfio_platform.c
@@ -26,6 +26,7 @@
 #include <linux/vfio.h>
 #include <linux/io.h>
 #include <linux/platform_device.h>
+#include <linux/of.h>
 #include <linux/irq.h>
 
 #include "vfio_platform_private.h"
@@ -66,6 +67,9 @@ static int vfio_platform_regions_init(struct vfio_platform_device *vdev)
 
 	vdev->num_regions = cnt;
 
+	/* get device tree node for info if available */
+	vfio_platform_devtree_get(vdev);
+
 	return 0;
 err:
 	kfree(vdev->region);
@@ -74,6 +78,7 @@ err:
 
 static void vfio_platform_regions_cleanup(struct vfio_platform_device *vdev)
 {
+	vfio_platform_devtree_put(vdev);
 	vdev->num_regions = 0;
 	kfree(vdev->region);
 }
@@ -132,6 +137,9 @@ static long vfio_platform_ioctl(void *device_data,
 			return -EINVAL;
 
 		info.flags = VFIO_DEVICE_FLAGS_PLATFORM;
+		if (vfio_platform_has_devtree(vdev))
+			info.flags |= VFIO_DEVICE_FLAGS_DEVTREE;
+
 		info.num_regions = vdev->num_regions;
 		info.num_irqs = vdev->num_irqs;
 
@@ -210,6 +218,9 @@ static long vfio_platform_ioctl(void *device_data,
 
 		return ret;
 
+	} else if (cmd == VFIO_DEVICE_GET_DEVTREE_INFO) {
+		return vfio_platform_devtree_ioctl(vdev, arg);
+
 	} else if (cmd == VFIO_DEVICE_RESET)
 		return -EINVAL;
 
diff --git a/drivers/vfio/platform/vfio_platform_private.h b/drivers/vfio/platform/vfio_platform_private.h
index 86a9201..1c42ba0 100644
--- a/drivers/vfio/platform/vfio_platform_private.h
+++ b/drivers/vfio/platform/vfio_platform_private.h
@@ -49,6 +49,7 @@ struct vfio_platform_device {
 	u32				num_regions;
 	struct vfio_platform_irq	*irq;
 	u32				num_irqs;
+	struct device_node		*of_node;
 };
 
 extern int vfio_platform_irq_init(struct vfio_platform_device *vdev);
@@ -59,4 +60,10 @@ extern int vfio_platform_set_irqs_ioctl(struct vfio_platform_device *vdev,
 			uint32_t flags, unsigned index, unsigned start,
 			unsigned count, void *data);
 
+/* device tree info support in devtree.c */
+extern void vfio_platform_devtree_get(struct vfio_platform_device *vdev);
+extern void vfio_platform_devtree_put(struct vfio_platform_device *vdev);
+extern bool vfio_platform_has_devtree(struct vfio_platform_device *vdev);
+extern long vfio_platform_devtree_ioctl(struct vfio_platform_device *vdev,
+					unsigned long arg);
 #endif /* VFIO_PLATFORM_PRIVATE_H */
diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index d381107..60f66ec 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -153,15 +153,41 @@ struct vfio_group_status {
 struct vfio_device_info {
 	__u32	argsz;
 	__u32	flags;
-#define VFIO_DEVICE_FLAGS_RESET	(1 << 0)	/* Device supports reset */
-#define VFIO_DEVICE_FLAGS_PCI	(1 << 1)	/* vfio-pci device */
-#define VFIO_DEVICE_FLAGS_PLATFORM (1 << 2)	/* vfio-platform device */
+#define VFIO_DEVICE_FLAGS_RESET		(1 << 0) /* Device supports reset */
+#define VFIO_DEVICE_FLAGS_PCI		(1 << 1) /* vfio-pci device */
+#define VFIO_DEVICE_FLAGS_PLATFORM	(1 << 2) /* vfio-platform device */
+#define VFIO_DEVICE_FLAGS_DEVTREE	(1 << 3) /* device tree metadata */
 	__u32	num_regions;	/* Max region index + 1 */
 	__u32	num_irqs;	/* Max IRQ index + 1 */
 };
 #define VFIO_DEVICE_GET_INFO		_IO(VFIO_TYPE, VFIO_BASE + 7)
 
 /**
+ * VFIO_DEVICE_GET_DEVTREE_INFO - _IOR(VFIO_TYPE, VFIO_BASE + 16,
+ *						struct vfio_devtree_info)
+ *
+ * Retrieve information from the device's device tree, if available.
+ * Caller will initialize data[] with a single string with the requested
+ * devicetree property name, and type depending on whether a array of strings
+ * or an array of u32 values is expected. On success, data[] will be extended
+ * with the requested information, either as an array of u32, or with a list
+ * of strings sepparated by the NULL terminating character.
+ * Return: 0 on success, -errno on failure.
+ */
+struct vfio_devtree_info {
+	__u32	argsz;
+	__u32	type;
+#define VFIO_DEVTREE_PROP_NAMES		0
+#define VFIO_DEVTREE_ARR_TYPE_STRING	1
+#define VFIO_DEVTREE_ARR_TYPE_U8	2
+#define VFIO_DEVTREE_ARR_TYPE_U16	3
+#define VFIO_DEVTREE_ARR_TYPE_U32	4
+	__u32	length;
+	__u8	data[];
+};
+#define VFIO_DEVICE_GET_DEVTREE_INFO	_IO(VFIO_TYPE, VFIO_BASE + 17)
+
+/**
  * VFIO_DEVICE_GET_REGION_INFO - _IOWR(VFIO_TYPE, VFIO_BASE + 8,
  *				       struct vfio_region_info)
  *
-- 
1.8.3.2
