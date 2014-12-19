From: Antonios Motakis <a.motakis-lrHrjnjw1UfHK3s98zE1ajGjJy/sRE9J@public.gmane.org>
Subject: [RFC PATCH v3 1/3] vfio: platform: add device properties skeleton and
	user API
Date: Fri, 19 Dec 2014 22:20:29 +0100
Message-ID: <1419024032-1269-2-git-send-email-a.motakis@virtualopensystems.com>
References: <1419024032-1269-1-git-send-email-a.motakis@virtualopensystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <1419024032-1269-1-git-send-email-a.motakis-lrHrjnjw1UfHK3s98zE1ajGjJy/sRE9J@public.gmane.org>
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
Cc: "open list:VFIO DRIVER" <kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, eric.auger-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, "open list:ABI/API" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Antonios Motakis <a.motakis-lrHrjnjw1UfHK3s98zE1ajGjJy/sRE9J@public.gmane.org>, tech-lrHrjnjw1UfHK3s98zE1ajGjJy/sRE9J@public.gmane.org, christoffer.dall-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
List-Id: linux-api@vger.kernel.org

This patch introduced the API to return device properties about
a PLATFORM device (if described by a device tree or ACPI) and the
skeleton of the implementation for VFIO_PLATFORM. Information about any
device node bound by VFIO_PLATFORM should be queried via the introduced
ioctl VFIO_DEVICE_GET_DEV_PROPERTY.

The user needs to know the name and the data type of the property he is
accessing.

Signed-off-by: Antonios Motakis <a.motakis-lrHrjnjw1UfHK3s98zE1ajGjJy/sRE9J@public.gmane.org>
---
 drivers/vfio/platform/Makefile                |  3 +-
 drivers/vfio/platform/properties.c            | 61 +++++++++++++++++++++++++++
 drivers/vfio/platform/vfio_platform_common.c  | 35 +++++++++++++++
 drivers/vfio/platform/vfio_platform_private.h |  7 +++
 include/uapi/linux/vfio.h                     | 26 ++++++++++++
 5 files changed, 131 insertions(+), 1 deletion(-)
 create mode 100644 drivers/vfio/platform/properties.c

diff --git a/drivers/vfio/platform/Makefile b/drivers/vfio/platform/Makefile
index 81de144..99f3ba1 100644
--- a/drivers/vfio/platform/Makefile
+++ b/drivers/vfio/platform/Makefile
@@ -1,5 +1,6 @@
 
-vfio-platform-y := vfio_platform.o vfio_platform_common.o vfio_platform_irq.o
+vfio-platform-y := vfio_platform.o vfio_platform_common.o vfio_platform_irq.o \
+		   devtree.o
 
 obj-$(CONFIG_VFIO_PLATFORM) += vfio-platform.o
 
diff --git a/drivers/vfio/platform/properties.c b/drivers/vfio/platform/properties.c
new file mode 100644
index 0000000..8b90465
--- /dev/null
+++ b/drivers/vfio/platform/properties.c
@@ -0,0 +1,61 @@
+#include <linux/slab.h>
+#include <linux/vfio.h>
+#include <linux/property.h>
+#include "vfio_platform_private.h"
+
+static int dev_property_get_strings(struct device *dev,
+				    char *name, unsigned *lenp,
+				    void __user *datap, unsigned long datasz)
+{
+	return -EINVAL;
+}
+
+static int dev_property_get_uint(struct device *dev, char *name,
+				 uint32_t type, unsigned *lenp,
+				 void __user *datap, unsigned long datasz)
+{
+	return -EINVAL;
+}
+
+int vfio_platform_dev_properties(struct device *dev,
+				 uint32_t type, unsigned *lenp,
+				 void __user *datap, unsigned long datasz)
+{
+	char *name;
+	long namesz;
+	int ret;
+
+	namesz = strnlen_user(datap, datasz);
+	if (!namesz)
+		return -EFAULT;
+	if (namesz > datasz)
+		return -EINVAL;
+
+	name = kzalloc(namesz, GFP_KERNEL);
+	if (!name)
+		return -ENOMEM;
+	if (strncpy_from_user(name, datap, namesz) <= 0) {
+		kfree(name);
+		return -EFAULT;
+	}
+
+	switch (type) {
+	case VFIO_DEV_PROPERTY_TYPE_STRINGS:
+		ret = dev_property_get_strings(dev, name, lenp, datap, datasz);
+		break;
+
+	case VFIO_DEV_PROPERTY_TYPE_U64:
+	case VFIO_DEV_PROPERTY_TYPE_U32:
+	case VFIO_DEV_PROPERTY_TYPE_U16:
+	case VFIO_DEV_PROPERTY_TYPE_U8:
+		ret = dev_property_get_uint(dev, name, type, lenp,
+					    datap, datasz);
+		break;
+
+	default:
+		ret = -EINVAL;
+	}
+
+	kfree(name);
+	return ret;
+}
diff --git a/drivers/vfio/platform/vfio_platform_common.c b/drivers/vfio/platform/vfio_platform_common.c
index a532a25..83ad4b74 100644
--- a/drivers/vfio/platform/vfio_platform_common.c
+++ b/drivers/vfio/platform/vfio_platform_common.c
@@ -19,6 +19,7 @@
 #include <linux/slab.h>
 #include <linux/types.h>
 #include <linux/vfio.h>
+#include <linux/property.h>
 
 #include "vfio_platform_private.h"
 
@@ -251,6 +252,34 @@ static long vfio_platform_ioctl(void *device_data,
 
 		return ret;
 
+	} else if (cmd == VFIO_DEVICE_GET_DEV_PROPERTY) {
+		struct vfio_dev_property info;
+		void __user *datap;
+		unsigned long datasz;
+		int ret;
+
+		if (!vdev->dev)
+			return -EINVAL;
+
+		minsz = offsetofend(struct vfio_dev_property, length);
+
+		if (copy_from_user(&info, (void __user *)arg, minsz))
+			return -EFAULT;
+
+		if (info.argsz < minsz)
+			return -EINVAL;
+
+		datap = (void __user *) arg + minsz;
+		datasz = info.argsz - minsz;
+
+		ret = vfio_platform_dev_properties(vdev->dev, info.type,
+						   &info.length, datap, datasz);
+
+		if (copy_to_user((void __user *)arg, &info, minsz))
+			ret = -EFAULT;
+
+		return ret;
+
 	} else if (cmd == VFIO_DEVICE_RESET)
 		return -EINVAL;
 
@@ -501,6 +530,12 @@ int vfio_platform_probe_common(struct vfio_platform_device *vdev,
 		return ret;
 	}
 
+	/* add device properties flag */
+	if (device_property_present(dev, "name")) {
+		vdev->dev = dev;
+		vdev->flags |= VFIO_DEVICE_FLAGS_DEV_PROPERTIES;
+	}
+
 	mutex_init(&vdev->igate);
 
 	return 0;
diff --git a/drivers/vfio/platform/vfio_platform_private.h b/drivers/vfio/platform/vfio_platform_private.h
index c3d5b4b..fc6b1fb 100644
--- a/drivers/vfio/platform/vfio_platform_private.h
+++ b/drivers/vfio/platform/vfio_platform_private.h
@@ -53,6 +53,7 @@ struct vfio_platform_device {
 	u32				num_irqs;
 	int				refcnt;
 	struct mutex			igate;
+	struct device			*dev;
 
 	/*
 	 * These fields should be filled by the bus specific binder
@@ -79,4 +80,10 @@ extern int vfio_platform_set_irqs_ioctl(struct vfio_platform_device *vdev,
 					unsigned start, unsigned count,
 					void *data);
 
+/* device properties support in devtree.c */
+extern int vfio_platform_dev_properties(struct device *dev,
+					uint32_t type, unsigned *lenp,
+					void __user *datap,
+					unsigned long datasz);
+
 #endif /* VFIO_PLATFORM_PRIVATE_H */
diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index 544d3d8..ac50ab3f 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -161,12 +161,38 @@ struct vfio_device_info {
 #define VFIO_DEVICE_FLAGS_PCI	(1 << 1)	/* vfio-pci device */
 #define VFIO_DEVICE_FLAGS_PLATFORM (1 << 2)	/* vfio-platform device */
 #define VFIO_DEVICE_FLAGS_AMBA  (1 << 3)	/* vfio-amba device */
+#define VFIO_DEVICE_FLAGS_DEV_PROPERTIES (1 << 4) /* Device properties */
 	__u32	num_regions;	/* Max region index + 1 */
 	__u32	num_irqs;	/* Max IRQ index + 1 */
 };
 #define VFIO_DEVICE_GET_INFO		_IO(VFIO_TYPE, VFIO_BASE + 7)
 
 /**
+ * VFIO_DEVICE_GET_DEV_PROPERTY - _IOR(VFIO_TYPE, VFIO_BASE + 16,
+ *						struct vfio_devtree_info)
+ *
+ * Retrive a device property, e.g. from a device tree if available.
+ * Caller will initialize data[] with a single string with the requested
+ * devicetree property name, and type depending on whether a array of strings
+ * or an array of u32 values is expected. On success, data[] will be extended
+ * with the requested information, either as an array of u32, or with a list
+ * of strings sepparated by the NULL terminating character.
+ * Return: 0 on success, -errno on failure.
+ */
+struct vfio_dev_property {
+	__u32	argsz;
+	__u32	type;
+#define VFIO_DEV_PROPERTY_TYPE_STRINGS	0
+#define VFIO_DEV_PROPERTY_TYPE_U8	1
+#define VFIO_DEV_PROPERTY_TYPE_U16	2
+#define VFIO_DEV_PROPERTY_TYPE_U32	3
+#define VFIO_DEV_PROPERTY_TYPE_U64	4
+	__u32	length;
+	__u8	data[];
+};
+#define VFIO_DEVICE_GET_DEV_PROPERTY	_IO(VFIO_TYPE, VFIO_BASE + 17)
+
+/**
  * VFIO_DEVICE_GET_REGION_INFO - _IOWR(VFIO_TYPE, VFIO_BASE + 8,
  *				       struct vfio_region_info)
  *
-- 
2.1.3
