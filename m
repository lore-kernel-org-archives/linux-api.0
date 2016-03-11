From: Sinan Kaya <okaya@codeaurora.org>
Subject: [PATCH V15 3/4] dma: qcom_hidma: add support for object hierarchy
Date: Fri, 11 Mar 2016 16:49:53 -0500
Message-ID: <1457732994-11175-4-git-send-email-okaya@codeaurora.org>
References: <1457732994-11175-1-git-send-email-okaya@codeaurora.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1457732994-11175-1-git-send-email-okaya@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: dmaengine@vger.kernel.org, timur@codeaurora.org, devicetree@vger.kernel.org, cov@codeaurora.org, vinod.koul@intel.com, jcm@redhat.com
Cc: shankerd@codeaurora.org, vikrams@codeaurora.org, marc.zyngier@arm.com, mark.rutland@arm.com, eric.auger@linaro.org, agross@codeaurora.org, arnd@arndb.de, linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, Sinan Kaya <okaya@codeaurora.org>, Dan Williams <dan.j.williams@intel.com>, Andy Shevchenko <andy.shevchenko@gmail.com>, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

In order to create a relationship model between the channels and the
management object, we are adding support for object hierarchy to the
drivers. This patch simplifies the userspace application development.
We will not have to traverse different firmware paths based on device
tree or ACPI based kernels.

No matter what flavor of kernel is used, objects will be represented as
platform devices.

The new layout is as follows:

hidmam_10: hidma-mgmt@0x5A000000 {
	compatible = "qcom,hidma-mgmt-1.0";
	...

	hidma_10: hidma@0x5a010000 {
			compatible = "qcom,hidma-1.0";
			...
	}
}

The hidma_mgmt_init detects each instance of the hidma-mgmt-1.0 objects
in device tree and calls into the channel driver to create platform devices
for each child of the management object.

Signed-off-by: Sinan Kaya <okaya@codeaurora.org>
---
 Documentation/ABI/testing/sysfs-platform-hidma |   9 ++
 drivers/dma/qcom/hidma.c                       |  39 ++++++++-
 drivers/dma/qcom/hidma_mgmt.c                  | 111 ++++++++++++++++++++++++-
 3 files changed, 155 insertions(+), 4 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-platform-hidma

diff --git a/Documentation/ABI/testing/sysfs-platform-hidma b/Documentation/ABI/testing/sysfs-platform-hidma
new file mode 100644
index 0000000..d364415
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-platform-hidma
@@ -0,0 +1,9 @@
+What:		/sys/devices/platform/hidma-*/chid
+		/sys/devices/platform/QCOM8061:*/chid
+Date:		Dec 2015
+KernelVersion:	4.4
+Contact:	"Sinan Kaya <okaya@cudeaurora.org>"
+Description:
+		Contains the ID of the channel within the HIDMA instance.
+		It is used to associate a given HIDMA channel with the
+		priority and weight calls in the management interface.
diff --git a/drivers/dma/qcom/hidma.c b/drivers/dma/qcom/hidma.c
index 833db9e..ac20bdb 100644
--- a/drivers/dma/qcom/hidma.c
+++ b/drivers/dma/qcom/hidma.c
@@ -549,6 +549,43 @@ static irqreturn_t hidma_chirq_handler(int chirq, void *arg)
 	return hidma_ll_inthandler(chirq, lldev);
 }
 
+static ssize_t hidma_show_values(struct device *dev,
+				 struct device_attribute *attr, char *buf)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+	struct hidma_dev *mdev = platform_get_drvdata(pdev);
+
+	buf[0] = 0;
+
+	if (strcmp(attr->attr.name, "chid") == 0)
+		sprintf(buf, "%d\n", mdev->chidx);
+
+	return strlen(buf);
+}
+
+static int hidma_create_sysfs_entry(struct hidma_dev *dev, char *name,
+				    int mode)
+{
+	struct device_attribute *attrs;
+	char *name_copy;
+
+	attrs = devm_kmalloc(dev->ddev.dev, sizeof(struct device_attribute),
+			     GFP_KERNEL);
+	if (!attrs)
+		return -ENOMEM;
+
+	name_copy = devm_kstrdup(dev->ddev.dev, name, GFP_KERNEL);
+	if (!name_copy)
+		return -ENOMEM;
+
+	attrs->attr.name = name_copy;
+	attrs->attr.mode = mode;
+	attrs->show = hidma_show_values;
+	sysfs_attr_init(&attrs->attr);
+
+	return device_create_file(dev->ddev.dev, attrs);
+}
+
 static int hidma_probe(struct platform_device *pdev)
 {
 	struct hidma_dev *dmadev;
@@ -682,6 +719,7 @@ static int hidma_probe(struct platform_device *pdev)
 	dmadev->irq = chirq;
 	tasklet_init(&dmadev->task, hidma_issue_task, (unsigned long)dmadev);
 	hidma_debug_init(dmadev);
+	hidma_create_sysfs_entry(dmadev, "chid", S_IRUGO);
 	dev_info(&pdev->dev, "HI-DMA engine driver registration complete\n");
 	platform_set_drvdata(pdev, dmadev);
 	pm_runtime_mark_last_busy(dmadev->ddev.dev);
@@ -730,7 +768,6 @@ static const struct of_device_id hidma_match[] = {
 	{.compatible = "qcom,hidma-1.0",},
 	{},
 };
-
 MODULE_DEVICE_TABLE(of, hidma_match);
 
 static struct platform_driver hidma_driver = {
diff --git a/drivers/dma/qcom/hidma_mgmt.c b/drivers/dma/qcom/hidma_mgmt.c
index ef491b8..561964f 100644
--- a/drivers/dma/qcom/hidma_mgmt.c
+++ b/drivers/dma/qcom/hidma_mgmt.c
@@ -17,13 +17,14 @@
 #include <linux/acpi.h>
 #include <linux/of.h>
 #include <linux/property.h>
-#include <linux/interrupt.h>
-#include <linux/platform_device.h>
+#include <linux/of_irq.h>
+#include <linux/of_platform.h>
 #include <linux/module.h>
 #include <linux/uaccess.h>
 #include <linux/slab.h>
 #include <linux/pm_runtime.h>
 #include <linux/bitops.h>
+#include <linux/dma-mapping.h>
 
 #include "hidma_mgmt.h"
 
@@ -298,5 +299,109 @@ static struct platform_driver hidma_mgmt_driver = {
 	},
 };
 
-module_platform_driver(hidma_mgmt_driver);
+#if defined(CONFIG_OF) && defined(CONFIG_OF_IRQ)
+static int object_counter;
+
+static int __init hidma_mgmt_of_populate_channels(struct device_node *np)
+{
+	struct platform_device *pdev_parent = of_find_device_by_node(np);
+	struct platform_device_info pdevinfo;
+	struct of_phandle_args out_irq;
+	struct device_node *child;
+	struct resource *res;
+	const __be32 *cell;
+	int ret = 0, size, i, num;
+	u64 addr, addr_size;
+
+	for_each_available_child_of_node(np, child) {
+		struct resource *res_iter;
+		struct platform_device *new_pdev;
+
+		cell = of_get_property(child, "reg", &size);
+		if (!cell) {
+			ret = -EINVAL;
+			goto out;
+		}
+
+		size /= sizeof(*cell);
+		num = size /
+			(of_n_addr_cells(child) + of_n_size_cells(child)) + 1;
+
+		/* allocate a resource array */
+		res = kcalloc(num, sizeof(*res), GFP_KERNEL);
+		if (!res) {
+			ret = -ENOMEM;
+			goto out;
+		}
+
+		/* read each reg value */
+		i = 0;
+		res_iter = res;
+		while (i < size) {
+			addr = of_read_number(&cell[i],
+					      of_n_addr_cells(child));
+			i += of_n_addr_cells(child);
+
+			addr_size = of_read_number(&cell[i],
+						   of_n_size_cells(child));
+			i += of_n_size_cells(child);
+
+			res_iter->start = addr;
+			res_iter->end = res_iter->start + addr_size - 1;
+			res_iter->flags = IORESOURCE_MEM;
+			res_iter++;
+		}
+
+		ret = of_irq_parse_one(child, 0, &out_irq);
+		if (ret)
+			goto out;
+
+		res_iter->start = irq_create_of_mapping(&out_irq);
+		res_iter->name = "hidma event irq";
+		res_iter->flags = IORESOURCE_IRQ;
+
+		memset(&pdevinfo, 0, sizeof(pdevinfo));
+		pdevinfo.fwnode = &child->fwnode;
+		pdevinfo.parent = pdev_parent ? &pdev_parent->dev : NULL;
+		pdevinfo.name = child->name;
+		pdevinfo.id = object_counter++;
+		pdevinfo.res = res;
+		pdevinfo.num_res = num;
+		pdevinfo.data = NULL;
+		pdevinfo.size_data = 0;
+		pdevinfo.dma_mask = DMA_BIT_MASK(64);
+		new_pdev = platform_device_register_full(&pdevinfo);
+		if (!new_pdev) {
+			ret = -ENODEV;
+			goto out;
+		}
+		of_dma_configure(&new_pdev->dev, child);
+
+		kfree(res);
+		res = NULL;
+	}
+out:
+	kfree(res);
+
+	return ret;
+}
+#endif
+
+static int __init hidma_mgmt_init(void)
+{
+#if defined(CONFIG_OF) && defined(CONFIG_OF_IRQ)
+	struct device_node *child;
+
+	for (child = of_find_matching_node(NULL, hidma_mgmt_match); child;
+	     child = of_find_matching_node(child, hidma_mgmt_match)) {
+		/* device tree based firmware here */
+		hidma_mgmt_of_populate_channels(child);
+		of_node_put(child);
+	}
+#endif
+	platform_driver_register(&hidma_mgmt_driver);
+
+	return 0;
+}
+module_init(hidma_mgmt_init);
 MODULE_LICENSE("GPL v2");
-- 
1.8.2.1
