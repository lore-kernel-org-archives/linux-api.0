From: Antonios Motakis <a.motakis@virtualopensystems.com>
Subject: [RFC PATCH v2 1/4] vfio: platform: add device tree info API and skeleton
Date: Thu, 16 Oct 2014 17:54:33 +0200
Message-ID: <1413474876-28544-2-git-send-email-a.motakis@virtualopensystems.com>
References: <1413474876-28544-1-git-send-email-a.motakis@virtualopensystems.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1413474876-28544-1-git-send-email-a.motakis@virtualopensystems.com>
Sender: kvm-owner@vger.kernel.org
To: kvmarm@lists.cs.columbia.edu, iommu@lists.linux-foundation.org, alex.williamson@redhat.com
Cc: tech@virtualopensystems.com, christoffer.dall@linaro.org, eric.auger@linaro.org, kim.phillips@freescale.com, Antonios Motakis <a.motakis@virtualopensystems.com>, open list <linux-kernel@vger.kernel.org>, "open list:VFIO DRIVER" <kvm@vger.kernel.org>, "open list:ABI/API" <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

This patch introduced the API to return device tree info about
a PLATFORM device (if described by a device tree) and the skeleton
of the implementation for VFIO_PLATFORM. Information about any device
node bound by VFIO_PLATFORM should be queried via the introduced ioctl
VFIO_DEVICE_GET_DEVTREE_INFO.

The proposed API allows to get a list of strings with available property
names, and then allows to query each property. Note that the properties
are not indexed numerically, so they are always accessed by property name.
The user needs to know the data type of the property he is accessing.

Signed-off-by: Antonios Motakis <a.motakis@virtualopensystems.com>
---
 drivers/vfio/platform/Makefile                |  3 +-
 drivers/vfio/platform/devtree.c               | 70 +++++++++++++++++++++++++++
 drivers/vfio/platform/vfio_platform_common.c  | 39 +++++++++++++++
 drivers/vfio/platform/vfio_platform_private.h |  6 +++
 include/uapi/linux/vfio.h                     | 26 ++++++++++
 5 files changed, 143 insertions(+), 1 deletion(-)
 create mode 100644 drivers/vfio/platform/devtree.c

diff --git a/drivers/vfio/platform/Makefile b/drivers/vfio/platform/Makefile
index 81de144..99f3ba1 100644
--- a/drivers/vfio/platform/Makefile
+++ b/drivers/vfio/platform/Makefile
@@ -1,5 +1,6 @@
 
-vfio-platform-y := vfio_platform.o vfio_platform_common.o vfio_platform_irq.o
+vfio-platform-y := vfio_platform.o vfio_platform_common.o vfio_platform_irq.o \
+		   devtree.o
 
 obj-$(CONFIG_VFIO_PLATFORM) += vfio-platform.o
 
diff --git a/drivers/vfio/platform/devtree.c b/drivers/vfio/platform/devtree.c
new file mode 100644
index 0000000..c057be3
--- /dev/null
+++ b/drivers/vfio/platform/devtree.c
@@ -0,0 +1,70 @@
+#include <linux/slab.h>
+#include <linux/vfio.h>
+#include <linux/of.h>
+#include <linux/platform_device.h>
+#include "vfio_platform_private.h"
+
+static int devtree_get_prop_list(struct device_node *np, unsigned *lenp,
+				 void __user *datap, unsigned long datasz)
+{
+	return -EINVAL;
+}
+
+static int devtree_get_strings(struct device_node *np,
+			       char *name, unsigned *lenp,
+			       void __user *datap, unsigned long datasz)
+{
+	return -EINVAL;
+}
+
+static int devtree_get_uint(struct device_node *np, char *name,
+			    uint32_t type, unsigned *lenp,
+			    void __user *datap, unsigned long datasz)
+{
+	return -EINVAL;
+}
+
+int vfio_platform_devtree_info(struct device_node *np,
+			       uint32_t type, unsigned *lenp,
+			       void __user *datap, unsigned long datasz)
+{
+	char *name;
+	long namesz;
+	int ret;
+
+	if (type == VFIO_DEVTREE_PROP_LIST) {
+		return devtree_get_prop_list(np, lenp, datap, datasz);
+	}
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
+	case VFIO_DEVTREE_TYPE_STRINGS:
+		ret = devtree_get_strings(np, name, lenp, datap, datasz);
+		break;
+
+	case VFIO_DEVTREE_TYPE_U32:
+	case VFIO_DEVTREE_TYPE_U16:
+	case VFIO_DEVTREE_TYPE_U8:
+		ret = devtree_get_uint(np, name, type, lenp, datap, datasz);
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
index 2a6c665..bfbee2f 100644
--- a/drivers/vfio/platform/vfio_platform_common.c
+++ b/drivers/vfio/platform/vfio_platform_common.c
@@ -24,6 +24,7 @@
 #include <linux/uaccess.h>
 #include <linux/vfio.h>
 #include <linux/io.h>
+#include <linux/of.h>
 
 #include "vfio_platform_private.h"
 
@@ -244,6 +245,34 @@ static long vfio_platform_ioctl(void *device_data,
 
 		return ret;
 
+	} else if (cmd == VFIO_DEVICE_GET_DEVTREE_INFO) {
+		struct vfio_devtree_info info;
+		void __user *datap;
+		unsigned long datasz;
+		int ret;
+
+		if (!vdev->of_node)
+			return -EINVAL;
+
+		minsz = offsetofend(struct vfio_devtree_info, length);
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
+		ret = vfio_platform_devtree_info(vdev->of_node, info.type,
+						 &info.length, datap, datasz);
+
+		if (copy_to_user((void __user *)arg, &info, minsz))
+			ret = -EFAULT;
+
+		return ret;
+
 	} else if (cmd == VFIO_DEVICE_RESET)
 		return -EINVAL;
 
@@ -486,6 +515,11 @@ int vfio_platform_probe_common(struct vfio_platform_device *vdev,
 		return ret;
 	}
 
+	/* get device tree node for info if available */
+	vdev->of_node = of_node_get(dev->of_node);
+	if (vdev->of_node)
+		vdev->flags |= VFIO_DEVICE_FLAGS_DEVTREE;
+
 	mutex_init(&vdev->igate);
 
 	return 0;
@@ -500,6 +534,11 @@ int vfio_platform_remove_common(struct device *dev)
 	if (!vdev)
 		return -EINVAL;
 
+	if (vdev->of_node) {
+		of_node_put(vdev->of_node);
+		vdev->of_node = NULL;
+	}
+
 	iommu_group_put(dev->iommu_group);
 	kfree(vdev);
 
diff --git a/drivers/vfio/platform/vfio_platform_private.h b/drivers/vfio/platform/vfio_platform_private.h
index 23ef038..fd40a26 100644
--- a/drivers/vfio/platform/vfio_platform_private.h
+++ b/drivers/vfio/platform/vfio_platform_private.h
@@ -60,6 +60,7 @@ struct vfio_platform_device {
 	void		*opaque;
 	const char	*name;
 	uint32_t	flags;
+	struct device_node *of_node;
 	/* callbacks to discover device resources */
 	struct resource*
 		(*get_resource)(struct vfio_platform_device *vdev, int i);
@@ -77,4 +78,9 @@ extern int vfio_platform_set_irqs_ioctl(struct vfio_platform_device *vdev,
 			uint32_t flags, unsigned index, unsigned start,
 			unsigned count, void *data);
 
+/* device tree info support in devtree.c */
+extern int vfio_platform_devtree_info(struct device_node *np,
+				      uint32_t type, unsigned *lenp,
+				      void __user *datap, unsigned long datasz);
+
 #endif /* VFIO_PLATFORM_PRIVATE_H */
diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index 1a5986c..18e6763 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -160,12 +160,38 @@ struct vfio_device_info {
 #define VFIO_DEVICE_FLAGS_PCI	(1 << 1)	/* vfio-pci device */
 #define VFIO_DEVICE_FLAGS_PLATFORM (1 << 2)	/* vfio-platform device */
 #define VFIO_DEVICE_FLAGS_AMBA  (1 << 3)	/* vfio-amba device */
+#define VFIO_DEVICE_FLAGS_DEVTREE (1 << 4)	/* device tree metadata */
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
+#define VFIO_DEVTREE_PROP_LIST		0
+#define VFIO_DEVTREE_TYPE_STRINGS	1
+#define VFIO_DEVTREE_TYPE_U8		2
+#define VFIO_DEVTREE_TYPE_U16		3
+#define VFIO_DEVTREE_TYPE_U32		4
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
2.1.1

