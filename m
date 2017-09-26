From: Benjamin Gaignard <benjamin.gaignard@linaro.org>
Subject: [PATCH v4 2/2] staging: ion: create one device entry per heap
Date: Tue, 26 Sep 2017 14:07:05 +0200
Message-ID: <1506427625-19202-3-git-send-email-benjamin.gaignard@linaro.org>
References: <1506427625-19202-1-git-send-email-benjamin.gaignard@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <1506427625-19202-1-git-send-email-benjamin.gaignard@linaro.org>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: labbott@redhat.com, sumit.semwal@linaro.org, gregkh@linuxfoundation.org, arve@android.com, riandrews@android.com, broonie@kernel.org, dan.carpenter@oracle.com
Cc: devel@driverdev.osuosl.org, linux-api@vger.kernel.org, Benjamin Gaignard <benjamin.gaignard@linaro.org>, linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
List-Id: linux-api@vger.kernel.org

Instead a getting one common device "/dev/ion" for
all the heaps this patch allow to create one device
entry ("/dev/ionX") per heap.
Getting an entry per heap could allow to set security rules
per heap and global ones for all heaps.

Allocation requests will be only allowed if the mask_id
match with device minor.
Query request could be done on any of the devices.

Signed-off-by: Benjamin Gaignard <benjamin.gaignard@linaro.org>
---
version 4:
- add a configuration flag to switch between legacy Ion misc device
  and one device per heap version.

version 3:
- change ion_device_add_heap prototype to return a possible error.

version 2:
- simplify ioctl check like propose by Dan
- make sure that we don't register more than ION_DEV_MAX heaps.

 drivers/staging/android/TODO            |  1 -
 drivers/staging/android/ion/Kconfig     |  8 ++++++++
 drivers/staging/android/ion/ion-ioctl.c | 16 ++++++++++++++--
 drivers/staging/android/ion/ion.c       | 29 +++++++++++++++++++++++++++--
 drivers/staging/android/ion/ion.h       | 18 +++++++++++++++++-
 5 files changed, 66 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/android/TODO b/drivers/staging/android/TODO
index 5f14247..d770ffa 100644
--- a/drivers/staging/android/TODO
+++ b/drivers/staging/android/TODO
@@ -9,7 +9,6 @@ TODO:
 ion/
  - Add dt-bindings for remaining heaps (chunk and carveout heaps). This would
    involve putting appropriate bindings in a memory node for Ion to find.
- - Split /dev/ion up into multiple nodes (e.g. /dev/ion/heap0)
  - Better test framework (integration with VGEM was suggested)
 
 Please send patches to Greg Kroah-Hartman <greg@kroah.com> and Cc:
diff --git a/drivers/staging/android/ion/Kconfig b/drivers/staging/android/ion/Kconfig
index a517b2d..6bb07f6 100644
--- a/drivers/staging/android/ion/Kconfig
+++ b/drivers/staging/android/ion/Kconfig
@@ -10,6 +10,14 @@ menuconfig ION
 	  If you're not using Android its probably safe to
 	  say N here.
 
+config ION_ONE_DEVICE_ENTRY_PER_HEAP
+	bool "Create one Ion device per heap"
+	depends on ION
+	help
+	  Choose this option to have one device entry per heap. Each
+	  device with named "/dev/ionX" where X is heap ID.
+	  Selecting this option remove the legacy Ion misc device.
+
 config ION_SYSTEM_HEAP
 	bool "Ion system heap"
 	depends on ION
diff --git a/drivers/staging/android/ion/ion-ioctl.c b/drivers/staging/android/ion/ion-ioctl.c
index e26b786..76492cc 100644
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
@@ -34,6 +35,17 @@ static int validate_ioctl_arg(unsigned int cmd, union ion_ioctl_arg *arg)
 		    arg->query.reserved2 )
 			return -EINVAL;
 		break;
+
+#ifdef CONFIG_ION_ONE_DEVICE_ENTRY_PER_HEAP
+	case ION_IOC_ALLOC:
+	{
+		int mask = 1 << iminor(filp->f_inode);
+
+		if (!(arg->allocation.heap_id_mask & mask))
+			return -EINVAL;
+		break;
+	}
+#endif
 	default:
 		break;
 	}
@@ -69,7 +81,7 @@ long ion_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 	if (copy_from_user(&data, (void __user *)arg, _IOC_SIZE(cmd)))
 		return -EFAULT;
 
-	ret = validate_ioctl_arg(cmd, &data);
+	ret = validate_ioctl_arg(filp, cmd, &data);
 	if (WARN_ON_ONCE(ret))
 		return ret;
 
diff --git a/drivers/staging/android/ion/ion.c b/drivers/staging/android/ion/ion.c
index 93e2c90..18a20d2 100644
--- a/drivers/staging/android/ion/ion.c
+++ b/drivers/staging/android/ion/ion.c
@@ -40,6 +40,10 @@
 
 #include "ion.h"
 
+#ifdef CONFIG_ION_ONE_DEVICE_ENTRY_PER_HEAP
+#define ION_DEV_MAX 32
+#endif
+
 static struct ion_device *internal_dev;
 static int heap_id;
 
@@ -537,15 +541,30 @@ static int debug_shrink_get(void *data, u64 *val)
 DEFINE_SIMPLE_ATTRIBUTE(debug_shrink_fops, debug_shrink_get,
 			debug_shrink_set, "%llu\n");
 
-void ion_device_add_heap(struct ion_heap *heap)
+int ion_device_add_heap(struct ion_heap *heap)
 {
 	struct dentry *debug_file;
 	struct ion_device *dev = internal_dev;
+	int ret = 0;
 
 	if (!heap->ops->allocate || !heap->ops->free)
 		pr_err("%s: can not add heap with invalid ops struct.\n",
 		       __func__);
 
+#ifdef CONFIG_ION_ONE_DEVICE_ENTRY_PER_HEAP
+	if (heap_id >= ION_DEV_MAX)
+		return -EBUSY;
+
+	heap->ddev.devt = MKDEV(MAJOR(dev->devt), heap_id);
+	dev_set_name(&heap->ddev, "ion%d", heap_id);
+	device_initialize(&heap->ddev);
+	cdev_init(&heap->chrdev, &ion_fops);
+	heap->chrdev.owner = THIS_MODULE;
+	ret = cdev_device_add(&heap->chrdev, &heap->ddev);
+	if (ret < 0)
+		return ret;
+#endif
+
 	spin_lock_init(&heap->free_lock);
 	heap->free_list_size = 0;
 
@@ -583,6 +602,8 @@ void ion_device_add_heap(struct ion_heap *heap)
 
 	dev->heap_cnt++;
 	up_write(&dev->lock);
+
+	return ret;
 }
 EXPORT_SYMBOL(ion_device_add_heap);
 
@@ -595,13 +616,17 @@ static int ion_device_create(void)
 	if (!idev)
 		return -ENOMEM;
 
+#ifdef CONFIG_ION_ONE_DEVICE_ENTRY_PER_HEAP
+	ret = alloc_chrdev_region(&idev->devt, 0, ION_DEV_MAX, "ion");
+#else
 	idev->dev.minor = MISC_DYNAMIC_MINOR;
 	idev->dev.name = "ion";
 	idev->dev.fops = &ion_fops;
 	idev->dev.parent = NULL;
 	ret = misc_register(&idev->dev);
+#endif
 	if (ret) {
-		pr_err("ion: failed to register misc device.\n");
+		pr_err("ion: unable to allocate device\n");
 		kfree(idev);
 		return ret;
 	}
diff --git a/drivers/staging/android/ion/ion.h b/drivers/staging/android/ion/ion.h
index 621e5f7..61ada2e 100644
--- a/drivers/staging/android/ion/ion.h
+++ b/drivers/staging/android/ion/ion.h
@@ -26,7 +26,12 @@
 #include <linux/sched.h>
 #include <linux/shrinker.h>
 #include <linux/types.h>
+
+#ifdef CONFIG_ION_ONE_DEVICE_ENTRY_PER_HEAP
+#include <linux/cdev.h>
+#else
 #include <linux/miscdevice.h>
+#endif
 
 #include "../uapi/ion.h"
 
@@ -90,13 +95,18 @@ void ion_buffer_destroy(struct ion_buffer *buffer);
 
 /**
  * struct ion_device - the metadata of the ion device node
+ * @devt:		Ion device if heap have own device entry
  * @dev:		the actual misc device
  * @buffers:		an rb tree of all the existing buffers
  * @buffer_lock:	lock protecting the tree of buffers
  * @lock:		rwsem protecting the tree of heaps and clients
  */
 struct ion_device {
+#ifdef CONFIG_ION_ONE_DEVICE_ENTRY_PER_HEAP
+	dev_t devt;
+#else
 	struct miscdevice dev;
+#endif
 	struct rb_root buffers;
 	struct mutex buffer_lock;
 	struct rw_semaphore lock;
@@ -152,6 +162,8 @@ struct ion_heap_ops {
  * struct ion_heap - represents a heap in the system
  * @node:		rb node to put the heap on the device's tree of heaps
  * @dev:		back pointer to the ion_device
+ * @ddev:		device structure
+ * @chrdev:		associated character device
  * @type:		type of heap
  * @ops:		ops struct as above
  * @flags:		flags
@@ -176,6 +188,10 @@ struct ion_heap_ops {
 struct ion_heap {
 	struct plist_node node;
 	struct ion_device *dev;
+#ifdef CONFIG_ION_ONE_DEVICE_ENTRY_PER_HEAP
+	struct device ddev;
+	struct cdev chrdev;
+#endif
 	enum ion_heap_type type;
 	struct ion_heap_ops *ops;
 	unsigned long flags;
@@ -212,7 +228,7 @@ bool ion_buffer_fault_user_mappings(struct ion_buffer *buffer);
  * ion_device_add_heap - adds a heap to the ion device
  * @heap:		the heap to add
  */
-void ion_device_add_heap(struct ion_heap *heap);
+int ion_device_add_heap(struct ion_heap *heap);
 
 /**
  * some helpers for common operations on buffers using the sg_table
-- 
2.7.4
