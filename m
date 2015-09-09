From: Baptiste Reynal <b.reynal@virtualopensystems.com>
Subject: [RFC PATCH v4 1/3] vfio: platform: add device properties skeleton and
 user API
Date: Wed,  9 Sep 2015 11:17:09 +0200
Message-ID: <1441790231-22920-2-git-send-email-b.reynal@virtualopensystems.com>
References: <1441790231-22920-1-git-send-email-b.reynal@virtualopensystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
In-Reply-To: <1441790231-22920-1-git-send-email-b.reynal@virtualopensystems.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu, iommu@lists.linux-foundation.org
Cc: "open list:VFIO PLATFORM DRIVER" <kvm@vger.kernel.org>, "open list:ABI/API" <linux-api@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>, alex.williamson@redhat.com, tech@virtualopensystems.com
List-Id: linux-api@vger.kernel.org

From: Antonios Motakis <a.motakis@virtualopensystems.com>

This patch introduces an API that allows to return device properties (OF
or ACPI) of a device bound to the vfio-platform/vfio-amba driver and the
skeleton of the implementation for VFIO_PLATFORM. Information about any
device node bound by VFIO_PLATFORM should be queried via the introduced
ioctl VFIO_DEVICE_GET_DEV_PROPERTY.

The user needs to know the name and the data type of the property he is
accessing.

Signed-off-by: Antonios Motakis <a.motakis@virtualopensystems.com>
Signed-off-by: Baptiste Reynal <b.reynal@virtualopensystems.com>

---
v3 -> v4:
 - added flags placeholder in vfio_dev_properties
 - ioctl returns -E2BIG if the buffer is too small
 - details VFIO_DEVICE_GET_DEV_PROPERTY documentation
---
 drivers/vfio/platform/Makefile                |  3 +-
 drivers/vfio/platform/properties.c            | 77 +++++++++++++++++++++++++++
 drivers/vfio/platform/vfio_platform_common.c  | 35 ++++++++++++
 drivers/vfio/platform/vfio_platform_private.h |  7 +++
 include/uapi/linux/vfio.h                     | 31 +++++++++++
 5 files changed, 152 insertions(+), 1 deletion(-)
 create mode 100644 drivers/vfio/platform/properties.c

diff --git a/drivers/vfio/platform/Makefile b/drivers/vfio/platform/Makefile
index 9ce8afe..37cf5ed 100644
--- a/drivers/vfio/platform/Makefile
+++ b/drivers/vfio/platform/Makefile
@@ -1,5 +1,6 @@
 
-vfio-platform-y := vfio_platform.o vfio_platform_common.o vfio_platform_irq.o
+vfio-platform-y := vfio_platform.o vfio_platform_common.o vfio_platform_irq.o \
+		   properties.o
 
 obj-$(CONFIG_VFIO_PLATFORM) += vfio-platform.o
 obj-$(CONFIG_VFIO_PLATFORM) += reset/
diff --git a/drivers/vfio/platform/properties.c b/drivers/vfio/platform/properties.c
new file mode 100644
index 0000000..98754c2
--- /dev/null
+++ b/drivers/vfio/platform/properties.c
@@ -0,0 +1,77 @@
+/*
+ * Copyright (C) 2015 - Virtual Open Systems
+ * Authors: Antonios Motakis <a.motakis@virtualopensystems.com>
+ *          Baptiste Reynal <b.reynal@virtualopensystems.com>
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
+#include <linux/slab.h>
+#include <linux/vfio.h>
+#include <linux/property.h>
+#include "vfio_platform_private.h"
+
+static int dev_property_get_strings(struct device *dev, uint32_t *flags,
+				    char *name, unsigned *lenp,
+				    void __user *datap, unsigned long datasz)
+{
+	return -EINVAL;
+}
+
+static int dev_property_get_uint(struct device *dev, uint32_t *flags,
+				 char *name, uint32_t type, unsigned *lenp,
+				 void __user *datap, unsigned long datasz)
+{
+	return -EINVAL;
+}
+
+int vfio_platform_dev_properties(struct device *dev, uint32_t *flags,
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
+		ret = dev_property_get_strings(dev, flags, name, lenp,
+				datap, datasz);
+		break;
+
+	case VFIO_DEV_PROPERTY_TYPE_U64:
+	case VFIO_DEV_PROPERTY_TYPE_U32:
+	case VFIO_DEV_PROPERTY_TYPE_U16:
+	case VFIO_DEV_PROPERTY_TYPE_U8:
+		ret = dev_property_get_uint(dev, flags, name, type, lenp,
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
index e43efb5..44ba22c 100644
--- a/drivers/vfio/platform/vfio_platform_common.c
+++ b/drivers/vfio/platform/vfio_platform_common.c
@@ -20,6 +20,7 @@
 #include <linux/types.h>
 #include <linux/uaccess.h>
 #include <linux/vfio.h>
+#include <linux/property.h>
 
 #include "vfio_platform_private.h"
 
@@ -302,6 +303,34 @@ static long vfio_platform_ioctl(void *device_data,
 			return vdev->reset(vdev);
 		else
 			return -EINVAL;
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
+		ret = vfio_platform_dev_properties(vdev->dev, &info.flags,
+				info.type, &info.length, datap, datasz);
+
+		if (copy_to_user((void __user *)arg, &info, minsz))
+			ret = -EFAULT;
+
+		return ret;
+
 	}
 
 	return -ENOTTY;
@@ -553,6 +582,12 @@ int vfio_platform_probe_common(struct vfio_platform_device *vdev,
 
 	vfio_platform_get_reset(vdev, dev);
 
+	/* add device properties flag */
+	if (device_property_present(dev, "name")) {
+		vdev->dev = dev;
+		vdev->flags |= VFIO_DEVICE_FLAGS_DEV_PROPERTIES;
+	}
+
 	mutex_init(&vdev->igate);
 
 	return 0;
diff --git a/drivers/vfio/platform/vfio_platform_private.h b/drivers/vfio/platform/vfio_platform_private.h
index 1c9b3d5..c75b089 100644
--- a/drivers/vfio/platform/vfio_platform_private.h
+++ b/drivers/vfio/platform/vfio_platform_private.h
@@ -56,6 +56,7 @@ struct vfio_platform_device {
 	u32				num_irqs;
 	int				refcnt;
 	struct mutex			igate;
+	struct device			*dev;
 
 	/*
 	 * These fields should be filled by the bus specific binder
@@ -89,4 +90,10 @@ extern int vfio_platform_set_irqs_ioctl(struct vfio_platform_device *vdev,
 					unsigned start, unsigned count,
 					void *data);
 
+/* device properties support in properties.c */
+extern int vfio_platform_dev_properties(struct device *dev, uint32_t *flags,
+					uint32_t type, unsigned *lenp,
+					void __user *datap,
+					unsigned long datasz);
+
 #endif /* VFIO_PLATFORM_PRIVATE_H */
diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index 9fd7b5d..a1a0eaa 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -164,12 +164,43 @@ struct vfio_device_info {
 #define VFIO_DEVICE_FLAGS_PCI	(1 << 1)	/* vfio-pci device */
 #define VFIO_DEVICE_FLAGS_PLATFORM (1 << 2)	/* vfio-platform device */
 #define VFIO_DEVICE_FLAGS_AMBA  (1 << 3)	/* vfio-amba device */
+#define VFIO_DEVICE_FLAGS_DEV_PROPERTIES (1 << 4) /* Device properties */
 	__u32	num_regions;	/* Max region index + 1 */
 	__u32	num_irqs;	/* Max IRQ index + 1 */
 };
 #define VFIO_DEVICE_GET_INFO		_IO(VFIO_TYPE, VFIO_BASE + 7)
 
 /**
+ * VFIO_DEVICE_GET_DEV_PROPERTY - _IOR(VFIO_TYPE, VFIO_BASE + 17,
+ *						struct vfio_devtree_info)
+ *
+ * Retrieve a device property, e.g. from a HW description (device tree or ACPI)
+ * if available.
+ * Caller will initialize data[] with a single string with the requested
+ * devicetree property name, and type depending on whether an array of strings
+ * or an array of u32 values is expected. On success, data[] will be filled
+ * with the requested information, either as an array of u32, or with a list
+ * of strings separated by the NULL terminating character.
+ * Return: 0 on success, -errno on failure.
+ * Errors:
+ *   E2BIG: the property is too big to fit in the data[] buffer (the required
+ *          size is then written into the length field).
+ */
+struct vfio_dev_property {
+	__u32	argsz;
+	__u32	flags;	/* Placeholder for future extension */
+	__u32	type;
+#define VFIO_DEV_PROPERTY_TYPE_STRINGS	0
+#define VFIO_DEV_PROPERTY_TYPE_U8	1
+#define VFIO_DEV_PROPERTY_TYPE_U16	2
+#define VFIO_DEV_PROPERTY_TYPE_U32	3
+#define VFIO_DEV_PROPERTY_TYPE_U64	4
+	__u32	length;	/* Size of data[] */
+	__u8	data[];
+};
+#define VFIO_DEVICE_GET_DEV_PROPERTY	_IO(VFIO_TYPE, VFIO_BASE + 17)
+
+/**
  * VFIO_DEVICE_GET_REGION_INFO - _IOWR(VFIO_TYPE, VFIO_BASE + 8,
  *				       struct vfio_region_info)
  *
-- 
2.5.1
