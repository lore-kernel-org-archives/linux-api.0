From: Benjamin Gaignard <benjamin.gaignard@linaro.org>
Subject: [PATCH v6 2/2] staging: ion: create one device entry per heap
Date: Mon,  6 Nov 2017 16:59:45 +0100
Message-ID: <1509983985-20950-3-git-send-email-benjamin.gaignard@linaro.org>
References: <1509983985-20950-1-git-send-email-benjamin.gaignard@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1509983985-20950-1-git-send-email-benjamin.gaignard@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: labbott@redhat.com, sumit.semwal@linaro.org, gregkh@linuxfoundation.org, arve@android.com, riandrews@android.com, broonie@kernel.org, dan.carpenter@oracle.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org, linux-api@vger.kernel.org, Benjamin Gaignard <benjamin.gaignard@linaro.org>
List-Id: linux-api@vger.kernel.org

Instead a getting only one common device "/dev/ion" for
all the heaps this patch allow to create one device
entry ("/dev/ionX") per heap.
Getting an entry per heap could allow to set security rules
per heap and global ones for all heaps.

Allocation requests will be only allowed if the mask_id
match with device minor.
Query request could be done on any of the devices.

Signed-off-by: Benjamin Gaignard <benjamin.gaignard@linaro.org>
---
 drivers/staging/android/TODO            |  1 -
 drivers/staging/android/ion/Kconfig     |  7 ++++
 drivers/staging/android/ion/ion-ioctl.c | 18 ++++++++--
 drivers/staging/android/ion/ion.c       | 62 +++++++++++++++++++++++++++++----
 drivers/staging/android/ion/ion.h       | 15 ++++++--
 5 files changed, 91 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/android/TODO b/drivers/staging/android/TODO
index 687e0ea..8a11931 100644
--- a/drivers/staging/android/TODO
+++ b/drivers/staging/android/TODO
@@ -8,7 +8,6 @@ TODO:
 ion/
  - Add dt-bindings for remaining heaps (chunk and carveout heaps). This would
    involve putting appropriate bindings in a memory node for Ion to find.
- - Split /dev/ion up into multiple nodes (e.g. /dev/ion/heap0)
  - Better test framework (integration with VGEM was suggested)
 
 Please send patches to Greg Kroah-Hartman <greg@kroah.com> and Cc:
diff --git a/drivers/staging/android/ion/Kconfig b/drivers/staging/android/ion/Kconfig
index a517b2d..cb4666e 100644
--- a/drivers/staging/android/ion/Kconfig
+++ b/drivers/staging/android/ion/Kconfig
@@ -10,6 +10,13 @@ menuconfig ION
 	  If you're not using Android its probably safe to
 	  say N here.
 
+config ION_LEGACY_DEVICE_API
+	bool "Keep using Ion legacy misc device API"
+	depends on ION
+	help
+	  Choose this option to keep using Ion legacy misc device API
+	  i.e. /dev/ion
+
 config ION_SYSTEM_HEAP
 	bool "Ion system heap"
 	depends on ION
diff --git a/drivers/staging/android/ion/ion-ioctl.c b/drivers/staging/android/ion/ion-ioctl.c
index e26b786..bb5c77b 100644
--- a/drivers/staging/android/ion/ion-ioctl.c
+++ b/drivers/staging/android/ion/ion-ioctl.c
@@ -25,7 +25,8 @@ union ion_ioctl_arg {
 	struct ion_heap_query query;
 };
 
-static int validate_ioctl_arg(unsigned int cmd, union ion_ioctl_arg *arg)
+static int validate_ioctl_arg(struct file *filp,
+			      unsigned int cmd, union ion_ioctl_arg *arg)
 {
 	switch (cmd) {
 	case ION_IOC_HEAP_QUERY:
@@ -34,6 +35,19 @@ static int validate_ioctl_arg(unsigned int cmd, union ion_ioctl_arg *arg)
 		    arg->query.reserved2 )
 			return -EINVAL;
 		break;
+
+	case ION_IOC_ALLOC:
+	{
+		int mask = 1 << iminor(filp->f_inode);
+
+#ifdef CONFIG_ION_LEGACY_DEVICE_API
+		if (imajor(filp->f_inode) == MISC_MAJOR)
+			return 0;
+#endif
+		if (!(arg->allocation.heap_id_mask & mask))
+			return -EINVAL;
+		break;
+	}
 	default:
 		break;
 	}
@@ -69,7 +83,7 @@ long ion_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 	if (copy_from_user(&data, (void __user *)arg, _IOC_SIZE(cmd)))
 		return -EFAULT;
 
-	ret = validate_ioctl_arg(cmd, &data);
+	ret = validate_ioctl_arg(filp, cmd, &data);
 	if (WARN_ON_ONCE(ret))
 		return ret;
 
diff --git a/drivers/staging/android/ion/ion.c b/drivers/staging/android/ion/ion.c
index fda9756..2c2568b 100644
--- a/drivers/staging/android/ion/ion.c
+++ b/drivers/staging/android/ion/ion.c
@@ -40,6 +40,9 @@
 
 #include "ion.h"
 
+#define ION_DEV_MAX 32
+#define ION_NAME "ion"
+
 static struct ion_device *internal_dev;
 static int heap_id;
 
@@ -535,15 +538,38 @@ static int debug_shrink_get(void *data, u64 *val)
 DEFINE_SIMPLE_ATTRIBUTE(debug_shrink_fops, debug_shrink_get,
 			debug_shrink_set, "%llu\n");
 
-void ion_device_add_heap(struct ion_heap *heap)
+static struct device ion_bus = {
+	.init_name = ION_NAME,
+};
+
+static struct bus_type ion_bus_type = {
+	.name = ION_NAME,
+};
+
+int ion_device_add_heap(struct ion_heap *heap)
 {
 	struct dentry *debug_file;
 	struct ion_device *dev = internal_dev;
+	int ret = 0;
 
 	if (!heap->ops->allocate || !heap->ops->free)
 		pr_err("%s: can not add heap with invalid ops struct.\n",
 		       __func__);
 
+	if (heap_id >= ION_DEV_MAX)
+		return -EBUSY;
+
+	heap->ddev.parent = &ion_bus;
+	heap->ddev.bus = &ion_bus_type;
+	heap->ddev.devt = MKDEV(MAJOR(internal_dev->devt), heap_id);
+	dev_set_name(&heap->ddev, ION_NAME"%d", heap_id);
+	device_initialize(&heap->ddev);
+	cdev_init(&heap->chrdev, &ion_fops);
+	heap->chrdev.owner = THIS_MODULE;
+	ret = cdev_device_add(&heap->chrdev, &heap->ddev);
+	if (ret < 0)
+		return ret;
+
 	spin_lock_init(&heap->free_lock);
 	heap->free_list_size = 0;
 
@@ -581,6 +607,8 @@ void ion_device_add_heap(struct ion_heap *heap)
 
 	dev->heap_cnt++;
 	up_write(&dev->lock);
+
+	return ret;
 }
 EXPORT_SYMBOL(ion_device_add_heap);
 
@@ -593,8 +621,9 @@ static int ion_device_create(void)
 	if (!idev)
 		return -ENOMEM;
 
+#ifdef CONFIG_ION_LEGACY_DEVICE_API
 	idev->dev.minor = MISC_DYNAMIC_MINOR;
-	idev->dev.name = "ion";
+	idev->dev.name = ION_NAME;
 	idev->dev.fops = &ion_fops;
 	idev->dev.parent = NULL;
 	ret = misc_register(&idev->dev);
@@ -603,19 +632,38 @@ static int ion_device_create(void)
 		kfree(idev);
 		return ret;
 	}
+#endif
 
-	idev->debug_root = debugfs_create_dir("ion", NULL);
-	if (!idev->debug_root) {
+	ret = device_register(&ion_bus);
+	if (ret)
+		goto clean_misc;
+
+	ret = bus_register(&ion_bus_type);
+	if (ret)
+		goto clean_device;
+
+	ret = alloc_chrdev_region(&idev->devt, 0, ION_DEV_MAX, ION_NAME);
+	if (ret)
+		goto clean_device;
+
+	idev->debug_root = debugfs_create_dir(ION_NAME, NULL);
+	if (!idev->debug_root)
 		pr_err("ion: failed to create debugfs root directory.\n");
-		goto debugfs_done;
-	}
 
-debugfs_done:
 	idev->buffers = RB_ROOT;
 	mutex_init(&idev->buffer_lock);
 	init_rwsem(&idev->lock);
 	plist_head_init(&idev->heaps);
 	internal_dev = idev;
 	return 0;
+
+clean_device:
+	device_unregister(&ion_bus);
+clean_misc:
+#ifdef CONFIG_ION_LEGACY_DEVICE_API
+	misc_deregister(&idev->dev);
+#endif
+	kfree(idev);
+	return ret;
 }
 subsys_initcall(ion_device_create);
diff --git a/drivers/staging/android/ion/ion.h b/drivers/staging/android/ion/ion.h
index f5f9cd6..4869e96 100644
--- a/drivers/staging/android/ion/ion.h
+++ b/drivers/staging/android/ion/ion.h
@@ -17,16 +17,19 @@
 #ifndef _ION_H
 #define _ION_H
 
+#include <linux/cdev.h>
 #include <linux/device.h>
 #include <linux/dma-direction.h>
 #include <linux/kref.h>
+#ifdef CONFIG_ION_LEGACY_DEVICE_API
+#include <linux/miscdevice.h>
+#endif
 #include <linux/mm_types.h>
 #include <linux/mutex.h>
 #include <linux/rbtree.h>
 #include <linux/sched.h>
 #include <linux/shrinker.h>
 #include <linux/types.h>
-#include <linux/miscdevice.h>
 
 #include "../uapi/ion.h"
 
@@ -92,12 +95,16 @@ void ion_buffer_destroy(struct ion_buffer *buffer);
 /**
  * struct ion_device - the metadata of the ion device node
  * @dev:		the actual misc device
+ * @devt:		Ion device
  * @buffers:		an rb tree of all the existing buffers
  * @buffer_lock:	lock protecting the tree of buffers
  * @lock:		rwsem protecting the tree of heaps and clients
  */
 struct ion_device {
+#ifdef CONFIG_ION_LEGACY_DEVICE_API
 	struct miscdevice dev;
+#endif
+	dev_t devt;
 	struct rb_root buffers;
 	struct mutex buffer_lock;
 	struct rw_semaphore lock;
@@ -153,6 +160,8 @@ struct ion_heap_ops {
  * struct ion_heap - represents a heap in the system
  * @node:		rb node to put the heap on the device's tree of heaps
  * @dev:		back pointer to the ion_device
+ * @ddev:		device structure
+ * @chrdev:		associated character device
  * @type:		type of heap
  * @ops:		ops struct as above
  * @flags:		flags
@@ -177,6 +186,8 @@ struct ion_heap_ops {
 struct ion_heap {
 	struct plist_node node;
 	struct ion_device *dev;
+	struct device ddev;
+	struct cdev chrdev;
 	enum ion_heap_type type;
 	struct ion_heap_ops *ops;
 	unsigned long flags;
@@ -213,7 +224,7 @@ bool ion_buffer_fault_user_mappings(struct ion_buffer *buffer);
  * ion_device_add_heap - adds a heap to the ion device
  * @heap:		the heap to add
  */
-void ion_device_add_heap(struct ion_heap *heap);
+int ion_device_add_heap(struct ion_heap *heap);
 
 /**
  * some helpers for common operations on buffers using the sg_table
-- 
2.7.4
