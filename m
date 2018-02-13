From: Wu Hao <hao.wu@intel.com>
Subject: [PATCH v4 06/24] fpga: dfl: adds fpga_cdev_find_port
Date: Tue, 13 Feb 2018 17:24:35 +0800
Message-ID: <1518513893-4719-7-git-send-email-hao.wu@intel.com>
References: <1518513893-4719-1-git-send-email-hao.wu@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1518513893-4719-1-git-send-email-hao.wu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: atull@kernel.org, mdf@kernel.org, linux-fpga@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: linux-api@vger.kernel.org, luwei.kang@intel.com, yi.z.zhang@intel.com, hao.wu@intel.com, Tim Whisonant <tim.whisonant@intel.com>, Enno Luebbers <enno.luebbers@intel.com>, Shiva Rao <shiva.rao@intel.com>, Christopher Rauer <christopher.rauer@intel.com>, Xiao Guangrong <guangrong.xiao@linux.intel.com>
List-Id: linux-api@vger.kernel.org

For feature devices, we need a method to find the port dedicated
to the device. This patch adds a function fpga_cdev_find_port
for this purpose. e.g FPGA Management Engine (FME) Partial
Reconfiguration sub feature, it uses this function to find
dedicated port on the device for PR function implementation.

Signed-off-by: Tim Whisonant <tim.whisonant@intel.com>
Signed-off-by: Enno Luebbers <enno.luebbers@intel.com>
Signed-off-by: Shiva Rao <shiva.rao@intel.com>
Signed-off-by: Christopher Rauer <christopher.rauer@intel.com>
Signed-off-by: Xiao Guangrong <guangrong.xiao@linux.intel.com>
Signed-off-by: Wu Hao <hao.wu@intel.com>
---
v3: s/fpga_for_each_port/fpga_cdev_find_port/
    move fpga_cdev_find_port to fpga-dfl module.
v4: improve description in commit message.
    add comments to remind user to put_device after use this function.
---
 drivers/fpga/dfl.c | 34 ++++++++++++++++++++++++++++++++++
 drivers/fpga/dfl.h | 20 ++++++++++++++++++++
 2 files changed, 54 insertions(+)

diff --git a/drivers/fpga/dfl.c b/drivers/fpga/dfl.c
index dcfe5ab..38dc819 100644
--- a/drivers/fpga/dfl.c
+++ b/drivers/fpga/dfl.c
@@ -783,6 +783,40 @@ void fpga_remove_feature_devs(struct fpga_cdev *cdev)
 }
 EXPORT_SYMBOL_GPL(fpga_remove_feature_devs);
 
+/**
+ * __fpga_cdev_find_port - find a port under given container device
+ *
+ * @cdev: container device
+ * @data: data passed to match function
+ * @match: match function used to find specific port from the port device list
+ *
+ * Find a port device under container device. This function needs to be
+ * invoked with lock held.
+ *
+ * This function returns NULL if the device doesn't match and non-zero if it
+ * does. If this function returns non-zero and a reference to the platform
+ * device of port can be obtained.
+ *
+ * NOTE: you will need to drop the device reference with put_device() after use.
+ */
+struct platform_device *
+__fpga_cdev_find_port(struct fpga_cdev *cdev, void *data,
+		      int (*match)(struct platform_device *, void *))
+{
+	struct feature_platform_data *pdata;
+	struct platform_device *port_dev;
+
+	list_for_each_entry(pdata, &cdev->port_dev_list, node) {
+		port_dev = pdata->dev;
+
+		if (match(port_dev, data) && get_device(&port_dev->dev))
+			return port_dev;
+	}
+
+	return NULL;
+}
+EXPORT_SYMBOL_GPL(__fpga_cdev_find_port);
+
 int fpga_port_id(struct platform_device *pdev)
 {
 	void __iomem *base = get_feature_ioaddr_by_id(&pdev->dev,
diff --git a/drivers/fpga/dfl.h b/drivers/fpga/dfl.h
index 9b19399..d6ecda1 100644
--- a/drivers/fpga/dfl.h
+++ b/drivers/fpga/dfl.h
@@ -356,4 +356,24 @@ struct fpga_cdev {
 struct fpga_cdev *fpga_enumerate_feature_devs(struct fpga_enum_info *info);
 void fpga_remove_feature_devs(struct fpga_cdev *cdev);
 
+/*
+ * need to drop the device reference with put_device() after use port platform
+ * device returned by __fpga_cdev_find_port and fpga_cdev_find_port functions.
+ */
+struct platform_device *
+__fpga_cdev_find_port(struct fpga_cdev *cdev, void *data,
+		      int (*match)(struct platform_device *, void *));
+
+static inline struct platform_device *
+fpga_cdev_find_port(struct fpga_cdev *cdev, void *data,
+		    int (*match)(struct platform_device *, void *))
+{
+	struct platform_device *pdev;
+
+	mutex_lock(&cdev->lock);
+	pdev = __fpga_cdev_find_port(cdev, data, match);
+	mutex_unlock(&cdev->lock);
+
+	return pdev;
+}
 #endif /* __FPGA_DFL_H */
-- 
2.7.4
